import 'dart:convert';
import 'package:http/http.dart' as http;
import '../model/moeda.dart';

class ApiService {
  final String _apiKey = '81d1905a-dedf-4f57-80df-7c1edadef363'; // removido espaço no final
  final String _baseUrl = 'https://pro-api.coinmarketcap.com/v1/cryptocurrency/listings/latest';

  // Retorna lista de objetos Moeda
  Future<List<Moeda>> fetchCoins() async {
    final response = await http.get(
      Uri.parse('$_baseUrl?limit=20&convert=USD'),
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

  // Retorna lista de Map<String, dynamic> (para compatibilidade com views baseadas em Map)
  Future<List<Map<String, dynamic>>> fetchCoinsRaw() async {
    final moedas = await fetchCoins();

    return moedas.map((moeda) => {
      'id': moeda.id,
      'name': moeda.nome,
      'price': moeda.preco,
    }).toList();
  }
}
