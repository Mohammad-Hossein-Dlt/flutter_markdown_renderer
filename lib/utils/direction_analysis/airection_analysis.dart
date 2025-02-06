import 'package:flutter/material.dart';

const rtlIntervals = [
  Interval(0x0590, 0x05FF), // عبری
  Interval(0x0600, 0x06FF), // عربی
  Interval(0x0750, 0x077F), // مکمل عربی
  Interval(0x08A0, 0x08FF), // توسعه یافته A عربی
  Interval(0xFB50, 0xFDFF), // اشکال ارائه A عربی
  Interval(0x0870, 0x089F), // توسعه یافته B عربی
  Interval(0xFE70, 0xFEFF), // اشکال ارائه B عربی
  Interval(0xFB1D, 0xFB4F), // اشکال ارائه عبری
  Interval(0x10E60, 0x10E7F), // نمادهای عددی رومی
  Interval(0x1EE00, 0x1EEFF), // نمادهای ریاضی عربی
  Interval(0x1EC70, 0x1ECBF), // نمادهای هندی
  Interval(0x1ED00, 0x1ED4F), // نمادهای سریلانکایی
  Interval(0x0700, 0x074F), // Syriac
  Interval(0x0780, 0x07BF), // Thaana
  Interval(0x07C0, 0x07FF), // N'Ko
  Interval(0x0800, 0x083F), // Samaritan
  Interval(0x0840, 0x085F), // Mandaic
  Interval(0x0860, 0x086F), // Syriac Supplement
];

const ltrIntervals = [
  // لاتین و مشتقات
  Interval(0x0041, 0x007A), // Basic Latin
  Interval(0x00C0, 0x00FF), // Latin-1 Supplement
  Interval(0x0100, 0x017F), // Latin Extended-A
  Interval(0x0180, 0x024F), // Latin Extended-B
  Interval(0x1E00, 0x1EFF), // Latin Extended Additional
  Interval(0x2C60, 0x2C7F), // Latin Extended-C
  Interval(0xA720, 0xA7FF), // Latin Extended-D
  Interval(0xAB30, 0xAB6F), // Latin Extended-E

  // یونانی
  Interval(0x0370, 0x03FF), // Greek
  Interval(0x1F00, 0x1FFF), // Greek Extended

  // سیریلیک
  Interval(0x0400, 0x04FF), // Cyrillic
  Interval(0x0500, 0x052F), // Cyrillic Supplement
  Interval(0x2DE0, 0x2DFF), // Cyrillic Extended-A
  Interval(0xA640, 0xA69F), // Cyrillic Extended-B

  // آسیایی
  Interval(0x4E00, 0x9FFF), // CJK Unified Ideographs
  Interval(0x3040, 0x309F), // Hiragana
  Interval(0x30A0, 0x30FF), // Katakana
  Interval(0xAC00, 0xD7AF), // Hangul Syllables
  Interval(0x1100, 0x11FF), // Hangul Jamo

  // هندی و جنوب آسیا
  Interval(0x0900, 0x097F), // Devanagari
  Interval(0x0980, 0x09FF), // Bengali
  Interval(0x0A00, 0x0A7F), // Gurmukhi
  Interval(0x0A80, 0x0AFF), // Gujarati
  Interval(0x0B00, 0x0B7F), // Oriya
  Interval(0x0B80, 0x0BFF), // Tamil
  Interval(0x0C00, 0x0C7F), // Telugu
  Interval(0x0C80, 0x0CFF), // Kannada
  Interval(0x0D00, 0x0D7F), // Malayalam
  Interval(0x0D80, 0x0DFF), // Sinhala

  // شرق آسیا و جنوب شرقی آسیا
  Interval(0x0E00, 0x0E7F), // Thai
  Interval(0x0E80, 0x0EFF), // Lao
  Interval(0x0F00, 0x0FFF), // Tibetan
  Interval(0x1000, 0x109F), // Myanmar
  Interval(0x1780, 0x17FF), // Khmer

  // سایر سیستم‌های نوشتاری
  Interval(0x10A0, 0x10FF), // Georgian
  Interval(0x1200, 0x137F), // Ethiopic
  Interval(0x13A0, 0x13FF), // Cherokee
  Interval(0x1400, 0x167F), // Unified Canadian Aboriginal
  Interval(0x1680, 0x169F), // Ogham
  Interval(0x16A0, 0x16FF), // Runic
  Interval(0x0530, 0x058F), // Armenian
  Interval(0x1C00, 0x1C4F), // Lepcha
  Interval(0x1C50, 0x1C7F), // Ol Chiki
];

class Interval {
  final int start;
  final int end;

  const Interval(this.start, this.end);
}

enum TextDirectionDominance {
  rtlDominant,
  ltrDominant,
  neutral,
  equal,
}

class DirectionAnalysis {
  final TextDirectionDominance dominance;
  final double rtlPercent;
  final double ltrPercent;
  final double neutralPercent;

  DirectionAnalysis({
    required this.dominance,
    required this.rtlPercent,
    required this.ltrPercent,
    required this.neutralPercent,
  });

  bool isMixed() {
    return ltrPercent > 0 && rtlPercent > 0;
  }
}

DirectionAnalysis analyzeTextDirection(String text) {
  int rtlCount = 0;
  int ltrCount = 0;
  int neutralCount = 0;

  for (int i = 0; i < text.length; i++) {
    final code = text.codeUnitAt(i);

    if (_isCodeInIntervals(code, rtlIntervals)) {
      rtlCount++;
    } else if (_isCodeInIntervals(code, ltrIntervals)) {
      ltrCount++;
    } else {
      // کاراکترهای خنثی (اعداد، علائم، فاصله و ...)
      neutralCount++;
    }
  }

  final total = text.length;
  final rtlPercent = (rtlCount / total) * 100;
  final ltrPercent = (ltrCount / total) * 100;
  final neutralPercent = (neutralCount / total) * 100;

  return DirectionAnalysis(
    dominance: _getDominance(rtlPercent, ltrPercent),
    rtlPercent: rtlPercent,
    ltrPercent: ltrPercent,
    neutralPercent: neutralPercent,
  );
}

TextDirectionDominance _getDominance(double rtl, double ltr) {
  if (rtl > ltr) return TextDirectionDominance.rtlDominant;
  if (ltr > rtl) return TextDirectionDominance.ltrDominant;
  if (rtl == 0 && ltr == 0) return TextDirectionDominance.neutral;
  return TextDirectionDominance.equal;
}

bool _isCodeInIntervals(int code, List<Interval> intervals) {
  for (final interval in intervals) {
    if (code >= interval.start && code <= interval.end) return true;
  }
  return false;
}

// -----------------------------------------------------------------------------

final _directionCache = <String, TextDirection>{};

TextDirection getDominantTextDirectionFromText(String text) {
  if (text.isEmpty) return TextDirection.ltr;

  return _directionCache.putIfAbsent(text, () {
    int rtlCount = 0;
    int ltrCount = 0;

    for (final codeUnit in text.runes) {
      // بررسی RTL با جستجوی دودویی در rtlIntervals
      bool isRtl = _isInIntervals(codeUnit, rtlIntervals);

      // بررسی LTR با جستجوی دودویی در ltrIntervals
      bool isLtr = _isInIntervals(codeUnit, ltrIntervals);

      if (isRtl) rtlCount++;
      if (isLtr) ltrCount++;
    }

    return rtlCount > ltrCount ? TextDirection.rtl : TextDirection.ltr;
  });
}

bool _isInIntervals(int codeUnit, List<Interval> intervals) {
  int low = 0;
  int high = intervals.length - 1;

  while (low <= high) {
    int mid = (low + high) ~/ 2;
    final interval = intervals[mid];

    if (codeUnit < interval.start) {
      high = mid - 1;
    } else if (codeUnit > interval.end) {
      low = mid + 1;
    } else {
      return true;
    }
  }

  return false;
}

CrossAxisAlignment getCrossAxisAlignmentFromText(String text) {
  final textDirection = getDominantTextDirectionFromText(text);
  return textDirection == TextDirection.rtl
      ? CrossAxisAlignment.end
      : CrossAxisAlignment.start;
}

Alignment getAlignmentFromText(String text) {
  final textDirection = getDominantTextDirectionFromText(text);
  return textDirection == TextDirection.rtl
      ? Alignment.centerRight
      : Alignment.centerLeft;
}
