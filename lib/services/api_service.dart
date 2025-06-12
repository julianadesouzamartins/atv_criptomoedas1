import 'dart:convert';
import 'package:http/http.dart' as http;
import '../model/moeda.dart';

class ApiService {
  final String _apiKey = '81d1905a-dedf-4f57-80df-7c1edadef363';
  final String _baseUrl =
      'https://pro-api.coinmarketcap.com/v1/cryptocurrency/listings/latest';

  // Retorna lista de objetos Moeda com suporte ao parâmetro "limit"
  Future<List<Moeda>> fetchCoins({int limit = 20}) async {
    final response = await http.get(
      Uri.parse('$_baseUrl?limit=$limit&convert=USD'),
      headers: {
        'X-CMC_PRO_API_KEY': _apiKey,
        'Accept': 'application/json',
      },
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      final List<dynamic> moedasJson = data['data'];

      return moedasJson.map((json) => Moeda.fromJson(json)).toList();
    } else {
      throw Exception('Erro ao carregar moedas: ${response.statusCode}');
    }
  }

  // Versão alternativa que retorna um Map (caso precise em algum ponto)
  Future<List<Map<String, dynamic>>> fetchCoinsRaw({int limit = 20}) async {
    final moedas = await fetchCoins(limit: limit);
    return moedas
        .map((moeda) => {
              'id': moeda.symbol,
              'name': moeda.nome,
              'price': moeda.preco,
            })
        .toList();
  }
}
