import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class FavoriteController with ChangeNotifier {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Map<String, bool> _favorites = {};

  Map<String, bool> get favoritos => _favorites;

  FavoriteController() {
    _loadFavorites();
  }

  Future<void> _loadFavorites() async {
    final user = _auth.currentUser;
    if (user == null) return;

    final doc = await _firestore.collection('favorites').doc(user.uid).get();
    if (doc.exists) {
      final data = doc.data()!;
      _favorites = data.map((key, value) => MapEntry(key, value as bool));
    }

    notifyListeners();
  }

  Future<void> toggleFavorite(String symbol) async {
    final user = _auth.currentUser;
    if (user == null) return;

    final isFavorite = _favorites[symbol] ?? false;
    _favorites[symbol] = !isFavorite;

    await _firestore.collection('favorites').doc(user.uid).set(
      {symbol: !isFavorite},
      SetOptions(merge: true),
    );

    notifyListeners();
  }

  bool isFavorite(String symbol) {
    return _favorites[symbol] ?? false;
  }
}
