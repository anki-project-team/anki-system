import 'package:flutter/material.dart';

/// Design-System Tokens — single source of truth.
///
/// Usage: `DS.spacingMd`, `DS.title`, `DS.accentColor`, etc.
abstract final class DS {
  // ── Spacing ──────────────────────────────────────────
  static const double spacingXs   =  4.0;
  static const double spacingSm   =  8.0;
  static const double spacingMd   = 12.0;
  static const double spacingLg   = 16.0;
  static const double spacingXl   = 20.0;
  static const double spacingXxl  = 24.0;
  static const double spacingXxxl = 32.0;

  // ── Font Sizes ───────────────────────────────────────
  static const double caption  = 10.0;
  static const double small    = 11.0;
  static const double body     = 13.0;
  static const double subtitle = 14.0;
  static const double title    = 17.0;
  static const double headline = 22.0;
  static const double hero     = 28.0;

  // ── Font Weights ─────────────────────────────────────
  static const FontWeight regular   = FontWeight.w400;
  static const FontWeight medium    = FontWeight.w500;
  static const FontWeight semibold  = FontWeight.w600;
  static const FontWeight bold      = FontWeight.w700;
  static const FontWeight extrabold = FontWeight.w800;

  // ── Colors ───────────────────────────────────────────
  static const Color bgColor     = Color(0xFF162447);
  static const Color accentColor = Color(0xFFE8813A);
  static const Color cardColor   = Color(0xFF1e3a5f);
  static const Color darkColor   = Color(0xFF1a2744);
  static const Color greenColor  = Color(0xFF22C55E);
  static const Color redColor    = Color(0xFFEF4444);
  static const Color blueColor   = Color(0xFF3B82F6);
  static const Color yellowColor = Color(0xFFF0C030);

  // ── Border Radius ────────────────────────────────────
  static const double radiusSm   =  8.0;
  static const double radiusMd   = 12.0;
  static const double radiusLg   = 14.0;
  static const double radiusXl   = 16.0;
  static const double radiusPill = 20.0;

  // ── Touch Targets ────────────────────────────────────
  static const double minTouchTarget = 44.0;
  static const double buttonHeight   = 48.0;
  static const double navBarHeight   = 70.0;

  // ── Opacity ──────────────────────────────────────────
  static const double opacitySubtle        = 0.06;
  static const double opacityLight         = 0.12;
  static const double opacityMedium        = 0.25;
  static const double opacityStrong        = 0.45;
  static const double opacityTextSecondary = 0.55;
}
