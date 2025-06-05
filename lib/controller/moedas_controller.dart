import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../model/moeda.dart';
import '../services/api_service.dart';

class MoedasController {
  final ApiService _apiService = ApiService();
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  List<Moeda> moedas = [];
  List<String> favoritos = [];

  /// Carrega moedas da API
  Future<void> carregarMoedas() async {
    moedas = await _apiService.fetchCoins();
    await carregarFavoritos(); // opcional: já carrega favoritos junto
  }

  /// Carrega favoritos do Firestore
  Future<void> carregarFavoritos() async {
    final user = _auth.currentUser;
    if (user == null) {
      favoritos = [];
      return;
    }

    try {
      final doc = await _firestore.collection('favoritos').doc(user.uid).get();
      favoritos = doc.exists ? List<String>.from(doc.data()?['ids'] ?? []) : [];
    } catch (e) {
      favoritos = [];
      debugPrint('Erro ao carregar favoritos: $e');
    }
  }

  /// Alterna status de favorito
  Future<void> toggleFavorito(String id) async {
    final user = _auth.currentUser;
    if (user == null) return;

    if (favoritos.contains(id)) {
      favoritos.remove(id);
    } else {
      favoritos.add(id);
    }

    try {
      await _firestore.collection('favoritos').doc(user.uid).set({
        'ids': favoritos,
      });
    } catch (e) {
      debugPrint('Erro ao salvar favoritos: $e');
    }
  }

  /// Verifica se a moeda está favoritada
  bool isFavorito(String id) {
    return favoritos.contains(id);
  }

  /// Faz logout e navega para tela de login
  Future<void> logout(BuildContext context) async {
    await _auth.signOut();
    Navigator.pushReplacementNamed(context, '/login');
  }
}
