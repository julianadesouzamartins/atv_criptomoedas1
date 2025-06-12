import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../controller/favorite_controller.dart';
import '../services/api_service.dart';
import '../model/moeda.dart';

class CryptoListPage extends StatefulWidget {
  const CryptoListPage({super.key});

  @override
  State<CryptoListPage> createState() => _CryptoListPageState();
}

class _CryptoListPageState extends State<CryptoListPage> {
  List<Moeda> moedas = [];
  bool isLoading = true;
  int limit = 20;

  @override
  void initState() {
    super.initState();
    carregarMoedas();
  }

  Future<void> carregarMoedas({bool adicionar = false}) async {
    setState(() => isLoading = true);
    try {
      final api = ApiService();
      final lista = await api.fetchCoins(limit: limit);
      setState(() {
        moedas = lista;
        isLoading = false;
      });
    } catch (e) {
      print('Erro: $e');
      setState(() => isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final favoriteController = context.watch<FavoriteController>();
    final user = FirebaseAuth.instance.currentUser;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Criptomoedas'),
        actions: [
          IconButton(
            icon: const Icon(Icons.favorite),
            onPressed: () => Navigator.pushNamed(context, '/favorites'),
          ),
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () async {
              await FirebaseAuth.instance.signOut();
              Navigator.pushReplacementNamed(context, '/login');
            },
          ),
        ],
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : Column(
              children: [
                Expanded(
                  child: ListView.builder(
                    itemCount: moedas.length,
                    itemBuilder: (context, index) {
                      final moeda = moedas[index];
                      final isFavorite =
                          favoriteController.isFavorite(moeda.symbol);
                      final iconUrl =
                          'https://cryptoicon-api.vercel.app/api/icon/${moeda.symbol.toLowerCase()}';

                      return ListTile(
                        leading: Image.network(
                          iconUrl,
                          width: 32,
                          height: 32,
                          errorBuilder: (context, error, stackTrace) =>
                              const Icon(Icons.currency_bitcoin),
                        ),
                        title: Text('${moeda.nome} (${moeda.symbol})'),
                        subtitle: Text('Preço: \$${moeda.preco.toStringAsFixed(2)}'),
                        trailing: user != null
                            ? IconButton(
                                icon: Icon(
                                  isFavorite
                                      ? Icons.favorite
                                      : Icons.favorite_border,
                                  color: isFavorite ? Colors.red : null,
                                ),
                                onPressed: () => favoriteController
                                    .toggleFavorite(moeda.symbol),
                              )
                            : null,
                      );
                    },
                  ),
                ),
                ElevatedButton(
                  onPressed: () {
                    setState(() {
                      limit += 20;
                    });
                    carregarMoedas();
                  },
                  child: const Text('Ver mais moedas'),
                ),
              ],
            ),
    );
  }
}
