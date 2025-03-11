import 'package:markdown_parser/markdown/languages/java.dart';
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
  // 'builtin-name': const TextStyle(color: Color(0xffB88525)),

  'function': const TextStyle(color: Color(0xff507CC7)),
};

Map<String, String> patterns({
  required List<String> builtIn,
  required List<String> keywords,
  required List<String> dataTypes,
  required List<String> literals,
}) {
  return {
    // Comment
    'comment': r'\/\/[^\n]*|\/\*[\s\S]*?\*\/',

    // Strings
    'string': r"'[^']*'",
    'string1': r"'''[^']*'''",
    'string2': r'"[^"]*"',
    'string3': r'"""[^"]*"""',

    'built_in': r'\b(?:' + builtIn.join('|') + r')\b',

    // Type ( int، String)
    'type': r'\b(?:' + dataTypes.join('|') + r')\b',

    // Keywords (if, else, for, while, return, break, continue, etc.)
    'keyword': r'\b(?:' + keywords.join('|') + r')\b',

    // Functions
    'function': r'\b[a-zA-Z_][a-zA-Z0-9_]*(?=\()',

    // Literals (true, false, null)
    'literal': r'\b(?:' + literals.join('|') + r')\b',

    // Variables

    'variable': r'\b(?!' + keywords.join('|') + r')\b[a-zA-Z_][a-zA-Z0-9_]*\b',

    // Numbers
    'number': r'\b\d+(\.\d+)?([eE][+-]?\d+)?\b',

    // Regular expressions
    // 'regexp': r'\/(?:\\\/|[^\/\n])+\/[gimuy]*',

    // Default
    'root': r'.+',
  };
}

class HighlightedSection {
  final String text;
  final int start;
  final int end;
  final String patternKey;

  HighlightedSection(this.text, this.start, this.end, this.patternKey);
}

List<TextSpan> highlightCode(String code) {
  final List<HighlightedSection> highlightedSections = [];
  final List<TextSpan> spans = [];
  int lastMatchEnd = 0;

  patterns(
    builtIn: javaBuiltIn,
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

      // Check if the section already exists
      final alreadyExists = highlightedSections.any(
        (section) =>
            (start >= section.start &&
                start < section.end) || // Overlap from the start
            (end > section.start &&
                end <= section.end) || // Overlap from the end
            (start <= section.start && end >= section.end),
      );

      if (!alreadyExists) {
        // Add the section to the list
        highlightedSections.add(HighlightedSection(text, start, end, key));
      }
    }
  });

  // Sort the sections by their start index
  highlightedSections.sort((a, b) => a.start.compareTo(b.start));

  // Create the spans
  for (final section in highlightedSections) {
    // Add the text before the current section
    if (lastMatchEnd < section.start) {
      spans.add(TextSpan(
        text: code.substring(lastMatchEnd, section.start),
        style: styles['root'],
      ));
    }

    // Add the highlighted section
    spans.add(TextSpan(
      text: section.text,
      style: styles[section.patternKey] ?? styles['root'],
    ));

    lastMatchEnd = section.end;
  }

  // Add the remaining text
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
