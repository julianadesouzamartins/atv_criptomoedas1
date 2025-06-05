import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '/controller/favorite_controller.dart';

class FavoritePage extends StatelessWidget {
  const FavoritePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final favoritos = context.watch<FavoriteController>().favoritos;

    final allCryptos = [
      {'symbol': 'BTC', 'name': 'Bitcoin'},
      {'symbol': 'ETH', 'name': 'Ethereum'},
      {'symbol': 'XRP', 'name': 'Ripple'},
      {'symbol': 'LTC', 'name': 'Litecoin'},
      {'symbol': 'ADA', 'name': 'Cardano'},
      {'symbol': 'SOL', 'name': 'Solana'},
      {'symbol': 'BNB', 'name': 'BNB'},
      {'symbol': 'DOGE', 'name': 'Dogecoin'},
      {'symbol': 'DOT', 'name': 'Polkadot'},
      {'symbol': 'AVAX', 'name': 'Avalanche'},
    ];

    final favoriteCryptos = allCryptos.where(
      (crypto) => favoritos[crypto['symbol']] == true,
    ).toList();

    return Scaffold(
      appBar: AppBar(title: const Text('Favoritas')),
      body: favoriteCryptos.isEmpty
          ? const Center(child: Text('Nenhuma criptomoeda favorita.'))
          : ListView.builder(
              itemCount: favoriteCryptos.length,
              itemBuilder: (context, index) {
                final crypto = favoriteCryptos[index];
                final symbol = crypto['symbol']!;
                final name = crypto['name']!;
                final iconUrl =
                    'https://cryptoicon-api.vercel.app/api/icon/${symbol.toLowerCase()}';

                return ListTile(
                  leading: Image.network(
                    iconUrl,
                    width: 32,
                    height: 32,
                    errorBuilder: (context, error, stackTrace) =>
                        const Icon(Icons.currency_bitcoin),
                  ),
                  title: Text('$name ($symbol)'),
                  trailing: IconButton(
                    icon: const Icon(Icons.favorite, color: Colors.red),
                    onPressed: () {
                      context.read<FavoriteController>().toggleFavorite(symbol);
                    },
                  ),
                );
              },
            ),
    );
  }
}
