import 'package:flutter/material.dart';

class FavoriteController extends ChangeNotifier {
  final Map<String, bool> _favoritos = {};

  Map<String, bool> get favoritos => _favoritos;

  bool isFavorite(String symbol) {
    return _favoritos[symbol] ?? false;
  }

  void toggleFavorite(String symbol) {
    _favoritos[symbol] = !isFavorite(symbol);
    notifyListeners();
  }
}
