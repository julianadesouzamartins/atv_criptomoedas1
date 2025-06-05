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
      id: json['id'],
      nome: json['name'],
      symbol: json['symbol'],
      preco: (json['quote']['USD']['price'] as num).toDouble(),
    );
  }
}
