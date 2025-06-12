import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../controller/favorite_controller.dart';
import '../model/moeda.dart';
import '../services/api_service.dart';

class FavoritePage extends StatefulWidget {
  const FavoritePage({Key? key}) : super(key: key);

  @override
  State<FavoritePage> createState() => _FavoritePageState();
}

class _FavoritePageState extends State<FavoritePage> {
  List<Moeda> todasMoedas = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    carregarMoedas();
  }

  Future<void> carregarMoedas() async {
    try {
      final api = ApiService();
      final lista = await api.fetchCoins(limit: 100);
      setState(() {
        todasMoedas = lista;
        isLoading = false;
      });
    } catch (e) {
      print('Erro: $e');
      setState(() => isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final favoritos = context.watch<FavoriteController>().favoritos;

    final favoritas = todasMoedas.where(
      (moeda) => favoritos[moeda.symbol] == true,
    ).toList();

    return Scaffold(
      appBar: AppBar(title: const Text('Favoritas')),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : favoritas.isEmpty
              ? const Center(child: Text('Nenhuma criptomoeda favorita.'))
              : ListView.builder(
                  itemCount: favoritas.length,
                  itemBuilder: (context, index) {
                    final moeda = favoritas[index];
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
                      subtitle:
                          Text('Preço: \$${moeda.preco.toStringAsFixed(2)}'),
                      trailing: IconButton(
                        icon: const Icon(Icons.favorite, color: Colors.red),
                        onPressed: () {
                          context
                              .read<FavoriteController>()
                              .toggleFavorite(moeda.symbol);
                          setState(() {}); // atualiza lista ao remover
                        },
                      ),
                    );
                  },
                ),
    );
  }
}
