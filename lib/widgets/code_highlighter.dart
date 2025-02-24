import 'package:ai_app/languages/java.dart';
import 'package:flutter/material.dart';

final styles = {
  'root': const TextStyle(color: Color(0xff333333)),
  'comment':
      const TextStyle(color: Color(0xFF737373), fontStyle: FontStyle.italic),

  'keyword':
      const TextStyle(color: Color(0xffA924A5), fontWeight: FontWeight.normal),

  'type':
      const TextStyle(color: Color(0xff507CC7), fontWeight: FontWeight.normal),

  'number': const TextStyle(color: Color(0xff906B1D)),
  'literal': const TextStyle(color: Color(0xff2481AD)),
  'variable': const TextStyle(color: Color(0xff333333)),

  'string': const TextStyle(color: Color(0xff50A14D)),
  'string1': const TextStyle(color: Color(0xff50A14D)),
  'string2': const TextStyle(color: Color(0xff50A14D)),
  'string3': const TextStyle(color: Color(0xff50A14D)),

  'built_in': const TextStyle(color: Color(0xFF0027A7)),
  'builtin-name': const TextStyle(color: Color(0xffB88525)),

  'function': const TextStyle(color: Color(0xff507CC7)), // اضافه شده
};

Map<String, String> patterns({
  required List<String> builtIn,
  required List<String> builtInName,
  required List<String> keywords,
  required List<String> dataTypes,
  required List<String> literals,
}) {
  return {
    // کامنت‌ها
    'comment': r'\/\/[^\n]*|\/\*[\s\S]*?\*\/',

    // رشته‌ها
    'string': r"'[^']*'",
    'string1': r"'''[^']*'''",
    'string2': r'"[^"]*"',
    'string3': r'"""[^"]*"""',

    'built_in': r'\b(?:' + builtIn.join('|') + r')\b',

    // Built-in Name: نام‌های داخلی (مثل `String`, `int`)
    'builtin-name': r'\b(?:' + builtInName.join('|') + r')\b',

    // Type: نوع داده‌ها (مثل int، String)
    'type': r'\b(?:' + dataTypes.join('|') + r')\b',

    // کلمات کلیدی
    'keyword': r'\b(?:' + keywords.join('|') + r')\b',

    // توابع
    'function': r'\b[a-zA-Z_][a-zA-Z0-9_]*(?=\()',

    // مقادیر ثابت
    'literal': r'\b(?:' + literals.join('|') + r')\b',

    // متغیرها

    'variable': r'\b(?!' + keywords.join('|') + r')\b[a-zA-Z_][a-zA-Z0-9_]*\b',

    // اعداد
    'number': r'\b\d+(\.\d+)?([eE][+-]?\d+)?\b',

    // عبارات باقاعده
    // 'regexp': r'\/(?:\\\/|[^\/\n])+\/[gimuy]*',

    // متن پیش‌فرض
    'root': r'.+',
  };
}

class HighlightedSection {
  final String text; // متن شناسایی‌شده
  final int start; // موقعیت شروع در متن اصلی
  final int end; // موقعیت پایان در متن اصلی
  final String patternKey; // کلید الگوی مربوطه

  HighlightedSection(this.text, this.start, this.end, this.patternKey);
}

List<TextSpan> highlightCode(String code) {
  final List<HighlightedSection> highlightedSections = [];
  final List<TextSpan> spans = [];
  int lastMatchEnd = 0;

  // اعمال هر الگو به صورت جداگانه
  patterns(
    builtIn: javaBuiltIn,
    builtInName: javaBuiltInNames,
    keywords: javaKeywords,
    dataTypes: javaDataTypes,
    literals: javaLiterals,
  ).forEach((key, pattern) {
    final regex = RegExp(pattern);
    final matches = regex.allMatches(code);

    for (final match in matches) {
      final start = match.start;
      final end = match.end;
      final text = match.group(0)!;

      // بررسی اینکه آیا این بخش قبلاً ذخیره شده است یا خیر
      final alreadyExists = highlightedSections.any(
        (section) =>
            (start >= section.start &&
                start < section.end) || // هم‌پوشانی از ابتدا
            (end > section.start && end <= section.end) || // هم‌پوشانی از انتها
            (start <= section.start && end >= section.end),
      ); // پوشش کامل

      if (!alreadyExists) {
        // ذخیره بخش جدید
        highlightedSections.add(HighlightedSection(text, start, end, key));
      }
    }
  });

  // مرتب‌سازی بخش‌ها بر اساس موقعیت شروع
  highlightedSections.sort((a, b) => a.start.compareTo(b.start));

  // ایجاد TextSpan برای هر بخش
  for (final section in highlightedSections) {
    // اضافه کردن متن معمولی (بدون استایل) بین بخش‌ها
    if (lastMatchEnd < section.start) {
      spans.add(TextSpan(
        text: code.substring(lastMatchEnd, section.start),
        style: styles['root'],
      ));
    }

    // اضافه کردن بخش شناسایی‌شده با استایل مناسب
    spans.add(TextSpan(
      text: section.text,
      style: styles[section.patternKey] ?? styles['root'],
    ));

    lastMatchEnd = section.end;
  }

  // اضافه کردن متن باقی‌مانده (بدون استایل)
  if (lastMatchEnd < code.length) {
    spans.add(TextSpan(
      text: code.substring(lastMatchEnd),
      style: styles['root'],
    ));
  }

  return spans;
}

class CodeHighlighter extends StatelessWidget {
  final String code;

  const CodeHighlighter({super.key, required this.code});

  @override
  Widget build(BuildContext context) {
    final spans = highlightCode(code);
    return RichText(
      text: TextSpan(
        style: const TextStyle(
          fontFamily: 'monospace',
          fontSize: 14.0,
        ),
        children: spans,
      ),
    );
  }
}
