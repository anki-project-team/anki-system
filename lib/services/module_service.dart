// lib/services/module_service.dart
// Lädt Module und Karten aus Firestore (statt hardcoded ap1_karten.dart)

import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/card_model.dart';

class ModuleData {
  final String id;
  final String name;
  final String icon;
  final String description;
  final bool isFree;
  final int order;
  final int cardCount;
  final List<CardModel> cards;

  ModuleData({
    required this.id,
    required this.name,
    required this.icon,
    required this.description,
    required this.isFree,
    required this.order,
    required this.cardCount,
    required this.cards,
  });
}

class ModuleService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  // ── Alle Module laden (ohne Karten) ──────────────────
  Future<List<ModuleData>> getModules() async {
    final snapshot = await _db
        .collection('modules')
        .orderBy('order')
        .get();

    return snapshot.docs.map((doc) {
      final data = doc.data();
      return ModuleData(
        id: doc.id,
        name: data['name'] ?? doc.id,
        icon: data['icon'] ?? '📚',
        description: data['description'] ?? '',
        isFree: data['isFree'] ?? false,
        order: data['order'] ?? 0,
        cardCount: data['cardCount'] ?? 0,
        cards: [],
      );
    }).toList();
  }

  // ── Karten für ein Modul laden ───────────────────────
  Future<List<CardModel>> getCardsForModule(String moduleId) async {
    final snapshot = await _db
        .collection('modules')
        .doc(moduleId)
        .collection('cards')
        .get();

    return snapshot.docs.map((doc) {
      final data = doc.data();
      return CardModel(
        id: doc.id,
        question: data['question'] ?? '',
        shortAnswer: data['shortAnswer'] ?? '',
        longAnswer: data['longAnswer'] ?? '',
        url: data['url'] ?? '',
        hashtags: List<String>.from(data['hashtags'] ?? []),
        difficulty: (data['difficulty'] ?? 5.0).toDouble(),
        stability: (data['stability'] ?? 1.0).toDouble(),
        dueDate: (data['dueDate'] as Timestamp?)?.toDate() ?? DateTime.now(),
        reviewCount: data['reviewCount'] ?? 0,
      );
    }).toList();
  }

  // ── Alle Module MIT Karten laden ─────────────────────
  Future<List<ModuleData>> getModulesWithCards() async {
    final modules = await getModules();
    final result = <ModuleData>[];

    for (final module in modules) {
      final cards = await getCardsForModule(module.id);
      result.add(ModuleData(
        id: module.id,
        name: module.name,
        icon: module.icon,
        description: module.description,
        isFree: module.isFree,
        order: module.order,
        cardCount: cards.length,
        cards: cards,
      ));
    }

    return result;
  }

  // ── Alle Karten aller Module laden ───────────────────
  Future<List<CardModel>> getAllCards() async {
    final modules = await getModulesWithCards();
    return modules.expand((m) => m.cards).toList();
  }

  // ── Nur kostenlose Module mit Karten ─────────────────
  Future<List<ModuleData>> getFreeModules() async {
    final modules = await getModulesWithCards();
    return modules.where((m) => m.isFree).toList();
  }
}
