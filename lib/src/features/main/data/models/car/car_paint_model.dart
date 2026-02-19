import 'dart:convert';

// ─── Top-level parse helpers ──────────────────────────────────────────────────

CarPaintPartsModel carPaintPartsModelFromJson(String str) =>
    CarPaintPartsModel.fromJson(json.decode(str));

// ─── Response wrapper ─────────────────────────────────────────────────────────

class CarPaintPartsModel {
  final String? status;
  final CarPaintData? data;

  CarPaintPartsModel({this.status, this.data});

  factory CarPaintPartsModel.fromJson(Map<String, dynamic> json) =>
      CarPaintPartsModel(
        status: json['status'],
        data: json['data'] == null ? null : CarPaintData.fromJson(json['data']),
      );
}

// ─── Data ─────────────────────────────────────────────────────────────────────

class CarPaintData {
  /// All paintable body parts  { part_key: "Part Label", … }
  final Map<String, String> parts;

  /// Paint condition options   { option_key: "Option Label", … }
  final Map<String, String> options;

  CarPaintData({required this.parts, required this.options});

  factory CarPaintData.fromJson(Map<String, dynamic> json) => CarPaintData(
        parts: _toStringMap(json['parts']),
        options: _toStringMap(json['options']),
      );

  static Map<String, String> _toStringMap(dynamic raw) {
    if (raw == null) return {};
    return Map<String, String>.from(raw as Map);
  }
}

// ─── Constants ────────────────────────────────────────────────────────────────

/// Paint option keys as returned by the API
const String kOriginalPaint = 'original_paint';
const String kRepainted = 'repainted';
const String kHeavyRepairFiller = 'heavy_repair_filler';

/// Parts in the top-view SVG tab
const Set<String> kTopViewPaintKeys = {
  'hood',
  'front_left_fender',
  'front_right_fender',
  'front_left_door',
  'front_right_door',
  'rear_left_door',
  'rear_right_door',
  'trunk',
  'roof',
  'rear_left_fender',
  'rear_right_fender',
  'left_step',
  'right_step',
  'roof_edge_left',
  'roof_edge_right',
};

/// Parts shown on the second tab (bottom-view SVG used as rear detail)
const Set<String> kBottomViewPaintKeys = {
  'roof_edg_Left',
  'roof_edg_right',
};
