import 'dart:convert';

// ─── Top-level parse helpers ──────────────────────────────────────────────────

CarDamagePartsModel carDamagePartsModelFromJson(String str) =>
    CarDamagePartsModel.fromJson(json.decode(str));

// ─── Response wrapper ─────────────────────────────────────────────────────────

class CarDamagePartsModel {
  final String? status;
  final CarDamageData? data;

  CarDamagePartsModel({this.status, this.data});

  factory CarDamagePartsModel.fromJson(Map<String, dynamic> json) =>
      CarDamagePartsModel(
        status: json['status'],
        data:
            json['data'] == null ? null : CarDamageData.fromJson(json['data']),
      );
}

// ─── Data ─────────────────────────────────────────────────────────────────────

class CarDamageData {
  /// Outer / visible body parts  (first_parts)
  final Map<String, String> firstParts;

  /// Structural / underbody parts (second_parts)
  final Map<String, String> secondParts;

  /// Available damage options
  final Map<String, String> options;

  CarDamageData({
    required this.firstParts,
    required this.secondParts,
    required this.options,
  });

  factory CarDamageData.fromJson(Map<String, dynamic> json) => CarDamageData(
        firstParts: _toStringMap(json['first_parts']),
        secondParts: _toStringMap(json['second_parts']),
        options: _toStringMap(json['options']),
      );

  static Map<String, String> _toStringMap(dynamic raw) {
    if (raw == null) return {};
    return Map<String, String>.from(raw as Map);
  }
}

// ─── Selection tracking (in-memory) ─────────────────────────────────────────

/// Maps partKey → set of selected option keys
typedef DamageSelection = Map<String, Set<String>>;

/// Convert selection to POST body  { "hood": ["scratches","bumps"], ... }
Map<String, List<String>> damageSelectionToJson(DamageSelection sel) =>
    sel.map((k, v) => MapEntry(k, v.toList()));
