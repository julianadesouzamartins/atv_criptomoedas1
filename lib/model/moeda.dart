class Moeda {
  final int id;
  final String nome;
  final String symbol;
  final double preco;

  Moeda({
    required this.id,
    required this.nome,
    required this.symbol,
    required this.preco,
  });

  factory Moeda.fromJson(Map<String, dynamic> json) {
    return Moeda(
      id: json['id'] ?? 0,
      nome: json['name'] ?? '',
      symbol: json['symbol'] ?? '',
      preco: (json['quote'] != null &&
              json['quote']['USD'] != null &&
              json['quote']['USD']['price'] != null)
          ? (json['quote']['USD']['price'] as num).toDouble()
          : 0.0,
    );
  }
}
