import 'package:ai_app/constants/colors.dart';
import 'package:ai_app/constants/data.dart';
import 'package:ai_app/constants/theme.dart';
import 'package:ai_app/utils/direction_analysis/direction_analysis.dart';
import 'package:ai_app/widgets/copy_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_highlight/flutter_highlight.dart';
import 'package:flutter_math_fork/flutter_math.dart';
import 'package:markdown/markdown.dart' as md;

class BoxSyntax extends md.InlineSyntax {
  BoxSyntax() : super(r'`([^`]+)`');

  @override
  bool onMatch(md.InlineParser parser, Match match) {
    final content = match.group(1)!;
    parser.addNode(md.Element.text('inline_code', content));
    return true;
  }
}

class LatexMathSyntax extends md.InlineSyntax {
  LatexMathSyntax()
      : super(
          r'\\\(.*?\\\)',
        );

  @override
  bool onMatch(md.InlineParser parser, Match match) {
    final text = match[0]!; // متن کامل پیدا شده
    final content = text
        .substring(2, text.length - 2)
        .trim(); // حذف `\(...\)` برای فرمول درون‌خطی

    // اضافه کردن یک گره جدید با نوع 'math' و محتوای فرمول
    parser.addNode(md.Element.text('inline_math', content));
    return true;
  }
}

class LatexBlockMathSyntax extends md.BlockSyntax {
  LatexBlockMathSyntax() : super();

  @override
  RegExp get pattern => RegExp(r'^\\\[(.*?)\\\]$');

  @override
  md.Node? parse(md.BlockParser parser) {
    final match = pattern.firstMatch(parser.current.content)!;
    final content = match.group(1)?.trim() ?? '';

    // ایجاد یک گره جدید برای فرمول بلوکی
    parser.advance();
    return md.Element.text('math_block', content);
  }
}

class LatexBlockSyntax extends md.BlockSyntax {
  @override
  RegExp get pattern => RegExp(r'^\\\[$');

  @override
  md.Node parse(md.BlockParser parser) {
    final buffer = StringBuffer();
    parser.advance();

    while (!parser.isDone) {
      final line = parser.current.content;
      if (line.trim() == r'\]') {
        parser.advance();
        break;
      }
      buffer.writeln(line);
      parser.advance();
    }

    return md.Element('math_block', [md.Text(buffer.toString().trim())]);
  }
}

class ArrayContent extends StatefulWidget {
  const ArrayContent({super.key});

  @override
  State<ArrayContent> createState() => _ArrayContentState();
}

class _ArrayContentState extends State<ArrayContent> {
  // String text = '';
  // List<MarkdownElement> displayedElements = [];
  // int index = 0;
  // Timer? _timer;

  // @override
  // void initState() {
  //   super.initState();
  //   text = textData;

  //   _startTyping();
  // }

  // void _startTyping() {
  //   _timer = Timer.periodic(
  //     const Duration(milliseconds: 10),
  //     (timer) {
  //       if (index < text.length) {
  //         setState(() {
  //           displayedElements = parseMarkdown(text.substring(0, index));
  //           index++;
  //         });
  //       } else {
  //         _timer?.cancel();
  //       }
  //     },
  //   );
  // }

  // @override
  // void dispose() {
  //   _timer?.cancel();
  //   super.dispose();
  // }

  String get textData => d11;

  List<MarkdownElement> get elements => parseMarkdown(textData);

  String get rawText {
    String text = '';

    for (MarkdownElement element in elements) {
      text += element.extractFullText(excludeTags: ['code']);
    }

    return text;
  }

  TextDirection get direction => getDominantTextDirectionFromText(rawText);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
          child: SingleChildScrollView(
        padding: const EdgeInsets.all(40),
        child: MarkdownRenderer(
          elements: elements,
          parentDirection: direction,
        ),
      )),
    );
  }

  String fixOrderedListIndentation(String content) {
    final lines = content.split('\n');
    final output = StringBuffer();

    for (final line in lines) {
      if (line.trim().isEmpty) {
        output.writeln();
        continue;
      }

      // تشخیص لیستهای ترتیبی (عددی مثل 1. , 2. , ...)
      final match = RegExp(r'^(\s*)(\d+\.)\s+(.*)').firstMatch(line);
      if (match == null) {
        output.writeln(line); // خطوط غیرلیست بدون تغییر
        continue;
      }

      final rawIndent = match.group(1)!.length;
      final type = match.group(2)!;
      final text = match.group(3)!;

      // محاسبه سطح تو رفتگی (ایندنت قبلی حذف شده)
      final indentLevel = (rawIndent / 3).floor();

      // اعمال ایندنت جدید: سطح * ۳ فاصله
      final newIndent = ' ' * (indentLevel * 3);
      output.writeln('$newIndent$type $text');
    }

    return output.toString();
  }

  String fixUnorderedListIndentation(String content) {
    final lines = content.split('\n');
    final output = StringBuffer();

    for (final line in lines) {
      if (line.trim().isEmpty) {
        output.writeln();
        continue;
      }

      // تشخیص لیستهای نامرتب (* یا -)
      final match = RegExp(r'^(\s*)(\*|\-)\s+(.*)').firstMatch(line);
      if (match == null) {
        output.writeln(line); // خطوط غیرلیست بدون تغییر
        continue;
      }

      final rawIndent = match.group(1)!.length;
      final type = match.group(2)!;
      final text = match.group(3)!;

      // محاسبه سطح تو رفتگی (ایندنت قبلی حذف شده)
      final indentLevel = (rawIndent / 2).floor();

      // اعمال ایندنت جدید: سطح * ۲ فاصله
      final newIndent = ' ' * (indentLevel * 2);
      output.writeln('$newIndent$type $text');
    }

    return output.toString();
  }
}

class Parent {
  final String type;
  final int id;

  Parent({
    required this.type,
    required this.id,
  });

  @override
  String toString() => 'Parent(type: $type, id: $id)';
}

class Content {
  String? text;

  List<MarkdownElement>? headers;
  List<List<MarkdownElement>>? rows;

  String? error;
  Content({
    this.text,
    this.headers,
    this.rows,
    this.error,
  });
  @override
  String toString() {
    final buffer = StringBuffer('Content(');
    final fields = <String>[];

    if (text != null) fields.add('text: \'$text\'');
    if (headers != null) {
      fields.add('headers: [\n    ${headers!.join(",\n    ")}\n  ]');
    }
    if (rows != null) {
      final rowsStr = rows!
          .map((row) => '[\n      ${row.join(",\n      ")}\n    ]')
          .join(',\n    ');
      fields.add('rows: [\n    $rowsStr\n  ]');
    }
    if (error != null) fields.add('error: \'$error\'');

    buffer.write(fields.join(', '));
    buffer.write(')');
    return buffer.toString();
  }
}

class Attributes {
  String? language;
  String? href;
  String? title;
  String? src;
  String? alt;

  Attributes({
    this.language,
    this.href,
    this.title,
    this.src,
    this.alt,
  });

  @override
  String toString() {
    final fields = <String>[];
    if (language != null) fields.add('language: \'$language\'');
    if (href != null) fields.add('href: \'$href\'');
    if (title != null) fields.add('title: \'$title\'');
    if (src != null) fields.add('src: \'$src\'');
    if (alt != null) fields.add('alt: \'$alt\'');
    return 'Attributes(${fields.join(', ')})';
  }
}

class MarkdownElement {
  int id;
  String type;
  Content? content;
  Attributes? attributes;
  List<MarkdownElement> children;
  int indent;
  int index;
  MarkdownElement({
    required this.type,
    this.content,
    this.attributes,
    this.children = const [],
    this.indent = 0,
    this.index = 0,
  }) : id = 0;

  List<int> getAllChildrenIds() {
    List<int> ids = [];
    for (var child in children) {
      ids.add(child.id);
      ids.addAll(child.getAllChildrenIds());
    }
    return ids;
  }

  String extractFullText({List<String> excludeTags = const []}) {
    String text = '';

    if (type == 'table') {
      if (content?.headers != null) {
        text += content!.headers!
            .map((element) => _getElementText(element, excludeTags))
            .join(' ')
            .trim();
      }
      if (content?.rows != null) {
        text += content!.rows!
            .map(
              (elements) => elements.map(
                (e) => _getElementText(e, excludeTags),
              ),
            )
            .join(' ')
            .trim();
      }
    }
    text += children
        .map((element) => _getElementText(element, excludeTags))
        .join(' ')
        .trim();

    return text;
  }

  String _getElementText(MarkdownElement element, List<String> excludeTags) {
    // اگر تگ عنصر در لیست ممنوعه بود، متن آن حذف می‌شود
    if (excludeTags.contains(element.type)) {
      return '';
    }

    String text = '';

    // استخراج متن از محتوای معمولی (مثلاً پاراگراف‌ها)
    text += element.content?.text ?? '';

    // پردازش خاص برای جدول‌ها
    if (element.type == 'table') {
      final tableContent = element.content;
      if (tableContent != null) {
        // استخراج متن هدرهای جدول
        if (tableContent.headers != null) {
          text +=
              ' ${tableContent.headers!.map((header) => _getElementText(header, excludeTags)).join(' ')}';
        }

        // استخراج متن سطرهای جدول
        if (tableContent.rows != null) {
          for (final row in tableContent.rows!) {
            text +=
                ' ${row.map((cell) => _getElementText(cell, excludeTags)).join(' ')}';
          }
        }
      }
    }

    // پردازش فرزندان عنصر
    if (element.children.isNotEmpty) {
      text +=
          ' ${element.children.map((child) => _getElementText(child, excludeTags)).join(' ')}';
    }

    return text.trim();
  }

  @override
  String toString() {
    final indentStr = '  ' * indent;
    final buffer = StringBuffer();

    buffer.write('${indentStr}MarkdownElement(\n');
    buffer.write('$indentStr  type: \'$type\',\n');
    buffer.write('$indentStr  id: \'$id\',\n');

    if (content != null) {
      final contentStr = content.toString().replaceAll('\n', '\n$indentStr  ');
      buffer.write('$indentStr  content: $contentStr,\n');
    }

    if (attributes != null) {
      buffer.write('$indentStr  attributes: $attributes,\n');
    }

    if (children.isNotEmpty) {
      buffer.write('$indentStr  children: [\n');
      for (final child in children) {
        final childStr = child.toString().replaceAll('\n', '\n$indentStr    ');
        buffer.write('$indentStr    $childStr,\n');
      }
      buffer.write('$indentStr  ],\n');
    }

    buffer.write('$indentStr  indent: $indent,\n');
    buffer.write('$indentStr  index: $index,\n');
    buffer.write('$indentStr)');

    return buffer.toString();
  }
}

List<MarkdownElement> parseMarkdown(String input) {
  final document = md.Document(
    extensionSet: md.ExtensionSet.gitHubWeb,
    blockSyntaxes: [
      LatexBlockSyntax(),
      ...md.ExtensionSet.gitHubFlavored.blockSyntaxes,
    ],
    inlineSyntaxes: [
      ...md.ExtensionSet.gitHubFlavored.inlineSyntaxes,
      LatexMathSyntax(),
      BoxSyntax(),
      md.LineBreakSyntax(),
      md.InlineHtmlSyntax(),
    ],
  );

  final nodes = document.parse(input);
  final elements = _processNodes(nodes);

  List<MarkdownElement> allElements = [];
  void collectElements(MarkdownElement element) {
    allElements.add(element); // افزودن المان فعلی

    // پردازش فرزندان معمولی
    for (var child in element.children) {
      collectElements(child);
    }

    // پردازش محتوای جدول
    if (element.type == 'table' && element.content != null) {
      // پردازش سربرگ‌ها
      if (element.content!.headers != null) {
        for (var header in element.content!.headers!) {
          collectElements(header); // افزودن سربرگ‌ها
        }
      }
      // پردازش سطرها و سلول‌ها
      if (element.content!.rows != null) {
        for (var row in element.content!.rows!) {
          for (var cell in row) {
            collectElements(cell); // افزودن سلول‌ها
          }
        }
      }
    }
  }

  for (var element in elements) {
    collectElements(element);
  }

  int currentId = 1;
  for (var element in allElements) {
    element.id = currentId++;
  }
  return elements;
}

List<MarkdownElement> _processNodes(
  List<md.Node> nodes, {
  int parentIndentLevel = 0,
}) {
  return nodes.asMap().entries.map((entry) {
    final index = entry.key;
    final node = entry.value;
    if (node is md.Element) {
      return _processElement(
        node,
        parentIndent: parentIndentLevel,
        index: index,
      );
    } else if (node is md.Text) {
      return _processText(
        node,
        indentLevel: parentIndentLevel,
        index: index,
      );
    }
    return MarkdownElement(
      type: 'unknown',
      index: index,
      content: Content(
        text: node.toString(),
      ),
      indent: parentIndentLevel,
    );
  }).toList();
}

MarkdownElement _processText(
  md.Text text, {
  int indentLevel = 0,
  required int index,
}) {
  return MarkdownElement(
    type: 'text',
    index: index,
    content: Content(text: text.text.isEmpty ? null : text.text),
    attributes: null,
    children: [],
    indent: indentLevel,
  );
}

MarkdownElement _processElement(
  md.Element element, {
  int parentIndent = 0,
  List<String>? parentTypes,
  required int index,
}) {
  int currentIndent = parentIndent;

  if (_isBlockLevel(element.tag)) {
    currentIndent = parentIndent + 1;
  }

  if (_isSpecialElement(element)) {
    return _processSpecialElements(
      element,
      indentLevel: parentIndent,
      parentTypes: parentTypes,
      index: index,
    );
  }

  final children = _processNodes(
    element.children ?? [],
    parentIndentLevel: currentIndent,
  );

  final content = children.isEmpty ? _extractTextFromElement(element) : null;

  return MarkdownElement(
    type: element.tag,
    index: index,
    content: Content(text: content),
    children: children,
    indent: currentIndent,
  );
}

bool _isBlockLevel(String tag) {
  return {
    "div",
    "p",
    "h1", "h2", "h3", "h4", "h5", "h6",
    "ul", "ol", "li",
    "dl", "dt", "dd",
    "header", "footer", "nav", "main", "article", "section", "aside",
    "figure", "figcaption",
    "form",
    "table", "tr", "th", "td", "tbody", "thead", "tfoot",
    "fieldset", "legend",
    "hr",
    "pre",
    "blockquote",
    "address",
    "details", "summary",
    "dialog",
    "canvas",
    "video", "audio",
    "dir",
    'img',
    "menu",
    'math_block', //
  }.contains(tag);
}

String? _extractTextFromElement(md.Element element) {
  final texts =
      element.children?.whereType<md.Text>().map((t) => t.text).toList() ?? [];

  return texts.isNotEmpty ? texts.join(' ').trim() : null;
}

bool _isSpecialElement(md.Element element) {
  return {
    'blockquote',
    'table',
    'code',
    'a',
    'img',
    'math_block',
  }.contains(element.tag);
}

MarkdownElement _processSpecialElements(
  md.Element element, {
  int indentLevel = 0,
  List<String>? parentTypes,
  required int index,
}) {
  switch (element.tag) {
    case 'blockquote':
      return _processBlockquote(
        element,
        indentLevel: indentLevel,
        index: index,
      );
    case 'table':
      return _processTable(
        element,
        indentLevel: indentLevel,
        index: index,
      );
    case 'code':
      return _processCodeBlock(
        element,
        indentLevel: indentLevel,
        index: index,
      );
    case 'a':
      return _processLink(
        element,
        indentLevel: indentLevel,
        index: index,
      );
    case 'img':
      return _processImage(
        element,
        indentLevel: indentLevel,
        index: index,
      );
    case 'math_block':
      return _processLatex(
        element,
        indentLevel: indentLevel,
        index: index,
      );
    default:
      return _processElement(
        element,
        parentIndent: indentLevel,
        parentTypes: parentTypes,
        index: index,
      );
  }
}

MarkdownElement _processBlockquote(
  md.Element element, {
  int indentLevel = 0,
  required int index,
}) {
  return MarkdownElement(
    type: element.tag,
    index: index,
    indent: indentLevel,
    children: _processNodes(
      element.children ?? [],
      parentIndentLevel: indentLevel + 1,
    ),
  );
}

MarkdownElement _processTable(
  md.Element element, {
  int indentLevel = 1,
  required int index,
}) {
  try {
    final headerRow = element.children!
        .whereType<md.Element>()
        .firstWhere((e) => e.tag == 'thead')
        .children!
        .whereType<md.Element>()
        .firstWhere((e) => e.tag == 'tr');

    // پردازش هدرها با parentTypes جدید
    final headerRowMarkdownElements = _processNodes(
      headerRow.children ?? [],
      parentIndentLevel: indentLevel,
    );

    final headers = headerRowMarkdownElements
        .where((element) => element.type == 'th')
        .toList();

    final body = element.children!
        .whereType<md.Element>()
        .firstWhere((e) => e.tag == 'tbody');

    // پردازش ردیف‌ها
    final rows = body.children
            ?.whereType<md.Element>()
            .where((e) => e.tag == 'tr')
            .map((tr) {
          return _processNodes(
            tr.children ?? [],
            parentIndentLevel: indentLevel,
          ).where((e) => e.type == 'td').toList();
        }).toList() ??
        [];

    return MarkdownElement(
      type: element.tag,
      index: index,
      content: Content(headers: headers, rows: rows),
      indent: indentLevel,
    );
  } catch (e) {
    return MarkdownElement(
      type: element.tag,
      index: index,
      content: Content(error: 'خطا در پردازش جدول: ${e.toString()}'),
      indent: indentLevel,
    );
  }
}

MarkdownElement _processCodeBlock(
  md.Element element, {
  int indentLevel = 0,
  required int index,
}) {
  final language =
      element.attributes['class']?.replaceAll('language-', '') ?? '';

  return MarkdownElement(
    type: element.tag,
    index: index,
    attributes: Attributes(language: language),
    indent: indentLevel,
    children: _processNodes(
      element.children ?? [],
      parentIndentLevel: indentLevel,
    ),
  );
}

MarkdownElement _processLink(
  md.Element element, {
  int indentLevel = 0,
  required int index,
}) {
  return MarkdownElement(
    type: element.tag,
    index: index,
    attributes: Attributes(
      href: element.attributes['href'] ?? '',
      title: element.attributes['title'] ?? '',
    ),
    children: _processNodes(
      element.children ?? [],
      parentIndentLevel: indentLevel,
    ),
    indent: indentLevel,
  );
}

MarkdownElement _processImage(
  md.Element element, {
  int indentLevel = 0,
  required int index,
}) {
  return MarkdownElement(
    type: element.tag,
    index: index,
    attributes: Attributes(
      src: element.attributes['src'] ?? '',
      alt: element.attributes['alt'] ?? '',
      title: element.attributes['title'] ?? '',
    ),
    indent: indentLevel,
    children: _processNodes(
      element.children ?? [],
      parentIndentLevel: indentLevel,
    ),
  );
}

MarkdownElement _processLatex(
  md.Element element, {
  int indentLevel = 0,
  required int index,
}) {
  return MarkdownElement(
    type: element.tag,
    index: index,
    indent: indentLevel,
    children: _processNodes(
      element.children ?? [],
      parentIndentLevel: indentLevel,
    ),
  );
}

List<Parent> findParentsById(List<MarkdownElement> root, int targetId) {
  List<Parent> result = [];

  bool findParents(
      MarkdownElement element, int targetId, List<Parent> parents) {
    // اگر عنصر فعلی همان عنصری باشد که به دنبال آن هستیم
    if (element.id == targetId) {
      return true;
    }

    // جستجو در فرزندان
    for (var child in element.children) {
      if (findParents(child, targetId, parents)) {
        parents.add(Parent(type: element.type, id: element.id));
        return true;
      }
    }

    // جستجو در هدرهای جدول
    if (element.type == 'table' && element.content?.headers != null) {
      for (var header in element.content!.headers!) {
        if (findParents(header, targetId, parents)) {
          parents.add(Parent(type: element.type, id: element.id));
          return true;
        }
      }
    }

    // جستجو در سطرهای جدول
    if (element.type == 'table' && element.content?.rows != null) {
      for (var row in element.content!.rows!) {
        for (var cell in row) {
          if (findParents(cell, targetId, parents)) {
            parents.add(Parent(type: element.type, id: element.id));
            return true;
          }
        }
      }
    }

    return false;
  }

  for (var element in root) {
    findParents(element, targetId, result);
  }

  return result.reversed.toList(); // ترتیب والدین را از ریشه به برگ برگردانید
}

// ----------------------------------------------------------------------------------------------------------

class Group {
  final String level;
  final List<MarkdownElement> elements;

  Group({required this.level, required this.elements});

  List<int> getAllChildrenIds() {
    List<int> ids = [];
    for (var element in elements) {
      ids.addAll(element.getAllChildrenIds()); // جمعآوری idهای فرزندان هر المنت
    }
    return ids;
  }

  String extractFullText() {
    return elements.map((element) => _getElementText(element)).join(' ');
  }

  String _getElementText(MarkdownElement element) {
    String text = element.content?.text ?? '';
    if (element.children.isNotEmpty) {
      text +=
          ' ${element.children.map((child) => _getElementText(child)).join(' ')}';
    }
    return text.trim();
  }
}

const TextStyle baseStyle = TextStyle(
  color: black,
  fontFamily: 'Shabnam',
  height: 1.6,
);

class MarkdownRenderer extends StatelessWidget {
  final List<MarkdownElement> elements;

  final TextDirection parentDirection;

  const MarkdownRenderer({
    super.key,
    required this.elements,
    required this.parentDirection,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: elements
          .map(
            (e) => _buildBlockElement(
              e,
              baseStyle,
            ),
          )
          .toList(),
    );
  }

  // Search by id
  MarkdownElement? findElementById(
      List<MarkdownElement> elements, int targetId) {
    for (final element in elements) {
      if (element.id == targetId) {
        return element;
      }
      final foundInChildren = findElementById(element.children, targetId);
      if (foundInChildren != null) {
        return foundInChildren;
      }
    }
    return null;
  }
// Build tag groups

  List<Group> _groupChildrenByLevel(
    List<MarkdownElement> children,
  ) {
    List<Group> groups = [];
    if (children.isEmpty) return groups;

    bool currentIsBlock = _isBlockLevel(children.first.type);
    List<MarkdownElement> currentGroup = [children.first];

    for (int i = 1; i < children.length; i++) {
      var child = children[i];
      bool isBlock = _isBlockLevel(child.type);
      if (isBlock == currentIsBlock) {
        currentGroup.add(child);
      } else {
        groups.add(
          Group(
            level: currentIsBlock ? 'block' : 'inline',
            elements: currentGroup,
          ),
        );
        currentIsBlock = isBlock;
        currentGroup = [child];
      }
    }
    groups.add(
      Group(
        level: currentIsBlock ? 'block' : 'inline',
        elements: currentGroup,
      ),
    );
    return groups;
  }

  List<Widget> _buildGroupedChildren(
    List<MarkdownElement> children,
    TextStyle parentStyle, {
    TextDirection? direction,
    TextAlign? align,
  }) {
    var groups = _groupChildrenByLevel(children);

    return groups.map((group) {
      if (group.level == 'inline') {
        String text = group.extractFullText();
        TextDirection textDirection = parentDirection;

        DirectionAnalysis analysis = analyzeTextDirection(text);

        if (analysis.isMixed()) {
          textDirection = parentDirection;
        } else {
          textDirection = getDominantTextDirectionFromText(text);
        }

        TextAlign textAlign = parentDirection == TextDirection.ltr
            ? TextAlign.left
            : TextAlign.right;

        return _buildInlineGroup(
          group.elements,
          parentStyle,
          direction: textDirection,
          align: textAlign,
        );
      } else {
        return Column(
          children: group.elements
              .map(
                (e) => _buildBlockElement(
                  e,
                  parentStyle,
                  direction: direction,
                  align: align,
                ),
              )
              .toList(),
        );
      }
    }).toList();
  }

  Widget _buildInlineGroup(
    List<MarkdownElement> elements,
    TextStyle parentStyle, {
    TextDirection? direction,
    TextAlign? align,
  }) {
    List<InlineSpan> spans = [];
    for (var element in elements) {
      spans.add(_buildTextSpan(element, parentStyle));
    }
    return RichText(
      softWrap: true,
      textDirection: direction,
      textAlign: align ?? TextAlign.start,
      text: TextSpan(children: spans),
    );
  }

// Build block elements

  Widget _buildBlockElement(
    MarkdownElement element,
    TextStyle style, {
    TextDirection? direction,
    TextAlign? align,
  }) {
    String text = element.extractFullText();
    TextDirection textDirection = getDominantTextDirectionFromText(text);

    switch (element.type) {
      case 'p':
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 8),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisSize: MainAxisSize.min,
            children: _buildGroupedChildren(
              element.children,
              style,
              direction: textDirection,
              align: align,
            ),
          ),
        );
      case 'h1':
      case 'h2':
      case 'h3':
      case 'h4':
      case 'h5':
      case 'h6':
        return Directionality(
          textDirection: textDirection,
          child: Padding(
            padding: const EdgeInsets.only(top: 10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              mainAxisSize: MainAxisSize.min,
              children: _buildGroupedChildren(
                element.children,
                _resolveStyle(element.type, style),
              ),
            ),
          ),
        );
      case 'ul':
      case 'ol':
        return Directionality(
          textDirection: parentDirection,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: element.children.map(
              (child) {
                return _buildListItem(
                  child,
                  style,
                );
              },
            ).toList(),
          ),
        );

      case 'table':
        if (element.content?.error != null) {
          return Text(element.content!.error!);
        }
        return Directionality(
          textDirection: textDirection,
          child: _buildTableFromData(
            element.content?.headers ?? [],
            element.content?.rows ?? [],
            style,
            parentDirection == TextDirection.ltr
                ? Alignment.centerLeft
                : Alignment.centerRight,
          ),
        );

      case 'code':
        return Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: element.children.map((child) {
            if (child.type == 'text') {
              return _buildCodeBlock(
                  child.content?.text, element.attributes?.language);
            } else {
              return const SizedBox.shrink();
            }
          }).toList(),
        );

      case 'pre':
        return Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: element.children.map((child) {
            return _buildBlockElement(child, style);
          }).toList(),
        );
      case 'img':
        return Image.network(
          element.attributes?.src ?? '',
          errorBuilder: (_, __, ___) => Text(element.attributes?.alt ?? ''),
        );
      case 'blockquote':
        return Directionality(
          textDirection: parentDirection,
          child: _buildBlockquote(element, style),
        );
      case 'hr':
        return const Divider(
          color: lightGrey,
          indent: 1,
        );

      case 'math_block':
        return _buildLatex(element);
      default:
        if (element.children.isNotEmpty) {
          return Directionality(
            textDirection: textDirection,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: _buildGroupedChildren(element.children, style),
            ),
          );
        } else {
          return const SizedBox.shrink();
        }
    }
  }

// Pre defined text styles

  TextStyle _resolveStyle(String type, TextStyle parentStyle) {
    switch (type) {
      case 'h1':
        return parentStyle.merge(
          const TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        );
      case 'h2':
        return parentStyle.merge(
          const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        );
      case 'h3':
        return parentStyle.merge(
          const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        );
      case 'h4':
        return parentStyle.merge(
          const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        );
      case 'h5':
        return parentStyle.merge(
          const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.bold,
          ),
        );
      case 'h6':
        return parentStyle.merge(
          const TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.bold,
          ),
        );
      case 'strong':
        return parentStyle.merge(
          const TextStyle(
            fontWeight: FontWeight.bold,
          ),
        );
      case 'b':
        return parentStyle.merge(
          const TextStyle(
            fontWeight: FontWeight.bold,
          ),
        );
      case 'em':
        return parentStyle.merge(
          const TextStyle(
            fontStyle: FontStyle.italic,
          ),
        );
      case 'i':
        return parentStyle.merge(
          const TextStyle(
            fontStyle: FontStyle.italic,
          ),
        );
      case 'del':
        return parentStyle.merge(
          const TextStyle(
            decoration: TextDecoration.lineThrough,
          ),
        );
      case 'a':
        return parentStyle.merge(
          const TextStyle(
            color: Colors.blue,
            decoration: TextDecoration.underline,
            decorationColor: Colors.blue,
          ),
        );

      case 'inline_code':
        return parentStyle.merge(
          const TextStyle(
            fontSize: 14,
            color: Color(0xFF8D8D8D),
            decorationColor: black,
            fontFamily: 'monospace',
          ),
        );
      case 'inline_math':
        return parentStyle.merge(
          const TextStyle(
            fontSize: 14,
            decorationColor: black,
            // fontFamily: 'monospace',
          ),
        );
      default:
        return parentStyle;
    }
  }

// Build Text Span

  InlineSpan _buildTextSpan(
    MarkdownElement element,
    TextStyle parentStyle,
  ) {
    final style = _resolveStyle(element.type, parentStyle);
    final textContent = element.content?.text ?? '';

    int? mathId = _isInsideMath(element);
    if (mathId != null) {
      return _buildMathTextSpan(element, style);
    }

    int? linkId = _isInsideLink(element);
    if (linkId != null) {
      return _buildLinkTextSpan(
          findElementById(elements, linkId), element, style);
    }

    int? codeId = _isInsideCode(element);
    if (codeId != null) {
      return _buildCodeTextSpan(element, style);
    }

    return TextSpan(
      text: textContent,
      style: style,
      children: element.children.map((e) => _buildTextSpan(e, style)).toList(),
    );
  }

  int? _isInsideCode(MarkdownElement element) {
    if (element.type != 'text') {
      return null;
    }

    List<Parent> parents = findParentsById(elements, element.id);

    List<int?> gatherIds = parents.map(
      (e) {
        if (e.type == 'inline_code') {
          return e.id;
        }
      },
    ).toList();

    if (gatherIds.every((element) => element == null)) {
      return null;
    }

    return gatherIds.where((e) => e != null).first;
  }

  InlineSpan _buildCodeTextSpan(
    MarkdownElement element,
    TextStyle style,
  ) {
    return WidgetSpan(
      baseline: TextBaseline.alphabetic,
      alignment: PlaceholderAlignment.baseline,
      child: Text(
        element.content?.text ?? '',
        textDirection: TextDirection.ltr,
        style: style,
      ),
    );
  }

  int? _isInsideMath(MarkdownElement element) {
    if (element.type != 'text') {
      return null;
    }

    List<Parent> parents = findParentsById(elements, element.id);

    List<int?> gatherIds = parents.map(
      (e) {
        if (e.type == 'inline_math' || e.type == 'math_block') {
          return e.id;
        }
      },
    ).toList();

    if (gatherIds.every((element) => element == null)) {
      return null;
    }

    return gatherIds.where((e) => e != null).first;
  }

  InlineSpan _buildMathTextSpan(
    MarkdownElement element,
    TextStyle style,
  ) {
    String mathData = element.content?.text ?? '';

    final pattern = RegExp(r'\\text\{([^}]*)\}');
    final matches = pattern.allMatches(mathData);

    List<InlineSpan> spans = [];

    int start = 0;
    for (final match in matches) {
      // متنی که قبل از \text{...} قرار دارد
      if (match.start > start) {
        final chunk = mathData.substring(start, match.start);
        if (chunk.isNotEmpty) {
          spans.add(
            _createWidgetSpan(
              child: Directionality(
                textDirection: TextDirection.ltr,
                child: FittedBox(
                  fit: BoxFit.cover,
                  child: Math.tex(
                    chunk,
                    settings: const TexParserSettings(
                      displayMode: true,
                      strict: Strict.function,
                    ),
                  ),
                ),
              ),
            ),
          );
        }
      }

      // متنی که داخل \text{...} است
      final textInside = match.group(1);
      if (textInside != null && textInside.isNotEmpty) {
        spans.add(
          TextSpan(
            text: ' $textInside ',
            style: style,
          ),
        );
      }
      start = match.end;
    }

    // اگر متنی بعد از آخرین \text{...} باقی مانده بود
    if (start < mathData.length) {
      final chunk = mathData.substring(start);
      if (chunk.isNotEmpty) {
        spans.add(
          _createWidgetSpan(
            child: Directionality(
              textDirection: TextDirection.ltr,
              child: FittedBox(
                fit: BoxFit.cover,
                child: Math.tex(
                  chunk,
                  settings: const TexParserSettings(
                    displayMode: true,
                    strict: Strict.function,
                  ),
                ),
              ),
            ),
          ),
        );
      }
    }

    return _createWidgetSpan(
      child: RichText(
        textDirection: TextDirection.ltr,
        text: TextSpan(
          children: spans,
        ),
      ),
    );
  }

  int? _isInsideLink(MarkdownElement element) {
    if (element.type != 'text') {
      return null;
    }

    List<Parent> parents = findParentsById(elements, element.id);

    List<int?> gatherIds = parents.map(
      (e) {
        if (e.type == 'a') {
          return e.id;
        }
      },
    ).toList();

    if (gatherIds.every((element) => element == null)) {
      return null;
    }

    return gatherIds.where((e) => e != null).first;
  }

  InlineSpan _buildLinkTextSpan(
    MarkdownElement? parent,
    MarkdownElement element,
    TextStyle style,
  ) {
    return _createWidgetSpan(
      child: InkWell(
        onTap: () {
          print(parent?.attributes?.href);
        },
        child: Text(element.content?.text ?? '', style: style),
      ),
    );
  }

  InlineSpan _createWidgetSpan({required Widget child}) {
    return WidgetSpan(
      baseline: TextBaseline.alphabetic,
      alignment: PlaceholderAlignment.baseline,
      child: child,
    );
  }

//  Build widgets

  Widget _buildListItem(
    MarkdownElement element,
    TextStyle style,
  ) {
    List<Parent> parents = findParentsById(elements, element.id);

    final bool isOrderedList = parents.isNotEmpty && parents.last.type == 'ol';
    final String indicator = isOrderedList ? '${element.index + 1}. ' : '• ';

    EdgeInsetsDirectional edgeInsetsDirectional =
        const EdgeInsetsDirectional.only(
      top: 4,
      bottom: 4,
    );

    return Padding(
      padding: edgeInsetsDirectional,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.baseline,
        textBaseline: TextBaseline.alphabetic,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Text(
            indicator,
            style: const TextStyle(
              fontSize: 16,
              color: Colors.grey,
              height: 1.6,
            ),
          ),
          const SizedBox(width: 4),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: _buildGroupedChildren(
                element.children,
                style,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCodeBlock(String? code, String? language) {
    return Directionality(
      textDirection: TextDirection.ltr,
      child: Container(
        width: double.infinity,
        margin: const EdgeInsets.symmetric(vertical: 10),
        decoration: BoxDecoration(
          color: Colors.grey[100],
          borderRadius: BorderRadius.circular(8.0),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 6),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: Row(
                textDirection: TextDirection.ltr,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    language == null || language.isEmpty
                        ? 'plaintext'
                        : language[0].toUpperCase() + language.substring(1),
                    style: const TextStyle(
                      color: black,
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(
                    height: 26,
                    child: CopyButton(
                      onPressed: () {},
                    ),
                  ),
                ],
              ),
            ),
            Container(
              width: double.infinity,
              height: 0.5,
              decoration: const BoxDecoration(
                color: lightGrey,
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: HighlightView(
                  code ?? '',
                  language: language == null || language.isEmpty
                      ? 'plaintext'
                      : language,
                  theme: theme,
                  padding: const EdgeInsets.all(8.0),
                  textStyle: const TextStyle(
                    fontFamily: 'monospace',
                    fontSize: 14.0,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTableFromData(
    List<MarkdownElement> headers,
    List<List<MarkdownElement>> rows,
    TextStyle style,
    Alignment? alignment,
  ) {
    // نرمالایز کردن سطرها
    final normalizedRows = rows.map((row) {
      if (row.length < headers.length) {
        return [...row, ...List.filled(headers.length - row.length, '')];
      } else if (row.length > headers.length) {
        return row.sublist(0, headers.length);
      }
      return row;
    }).toList();

    return Align(
      alignment: alignment ?? Alignment.center,
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Container(
          margin: const EdgeInsets.symmetric(vertical: 8),
          decoration: BoxDecoration(
            border: Border.all(color: lightGrey),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Table(
            defaultColumnWidth: const IntrinsicColumnWidth(),
            border: const TableBorder.symmetric(
              inside: BorderSide(color: lightGrey),
            ),
            children: [
              TableRow(
                decoration: BoxDecoration(
                  color: Colors.grey[100],
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(8),
                    topRight: Radius.circular(8),
                  ),
                ),
                children: headers
                    .map((header) => Padding(
                          padding: const EdgeInsets.all(12),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisSize: MainAxisSize.min,
                            children: _buildGroupedChildren(
                              header.children,
                              style,
                              align: TextAlign.center,
                            ),
                          ),
                        ))
                    .toList(),
              ),
              ...normalizedRows.map(
                (row) => TableRow(
                  children: row
                      .map(
                        (cell) => Padding(
                          padding: const EdgeInsets.all(12),
                          child: cell is MarkdownElement
                              ? Column(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  mainAxisSize: MainAxisSize.min,
                                  children: _buildGroupedChildren(
                                    cell.children,
                                    style,
                                    align: TextAlign.center,
                                  ),
                                )
                              : Text(cell.toString()),
                        ),
                      )
                      .toList(),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildBlockquote(
    MarkdownElement element,
    TextStyle style,
  ) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: IntrinsicHeight(
        child: Row(
          children: [
            Container(
              width: 4,
              decoration: BoxDecoration(
                color: lightGrey,
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: _buildGroupedChildren(
                    element.children,
                    style,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLatex(
    MarkdownElement element,
  ) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 10),
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: Colors.grey[100],
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: _buildGroupedChildren(
          element.children,
          baseStyle,
        ),
      ),
    );
  }
}

class RtlTextSpan extends TextSpan {
  const RtlTextSpan({
    required String str,
    super.style,
    super.children,
    super.semanticsLabel,
  }) : super(text: "\u200F$str");
}

class LtrTextSpan extends TextSpan {
  const LtrTextSpan({
    required String str,
    super.style,
    super.children,
    super.semanticsLabel,
  }) : super(text: "\u200E$str");
}
