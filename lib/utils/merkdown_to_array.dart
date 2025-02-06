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
  List<String>? parents;
  Content? content;
  Attributes? attributes;
  List<MarkdownElement> children;
  int indent;
  int index;
  MarkdownElement({
    required this.type,
    this.parents = const [],
    this.content,
    // this.textContent,
    this.attributes,
    this.children = const [],
    this.indent = 0,
    this.index = 0,
  }) : id = 0;

  List<int> getAllChildrenIds() {
    List<int> ids = [];
    for (var child in children) {
      ids.add(child.id); // افزودن id فرزند فعلی
      ids.addAll(child.getAllChildrenIds()); // افزودن idهای فرزندان بازگشتی
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
    buffer.write('$indentStr  type: \'$type\',\n'); // تغییر در این خط
    buffer.write('$indentStr  id: \'$id\',\n'); // تغییر در این خط

    if (parents != null && parents!.isNotEmpty) {
      buffer.write('$indentStr  parentTypes: [\n');
      buffer.write(parents!.map((t) => '$indentStr    \'$t\'').join(',\n'));
      buffer.write('\n$indentStr  ],\n');
    }

    if (content != null) {
      final contentStr = content.toString().replaceAll('\n', '\n$indentStr  ');
      buffer.write('$indentStr  content: $contentStr,\n');
    }

    // buffer.write('$indentStr  textContent: \'$textContent\',\n');

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
  // MarkdownElement.resetIdCounter();

  final document = md.Document(
    extensionSet: md.ExtensionSet.gitHubWeb,
    blockSyntaxes: [
      ...md.ExtensionSet.gitHubFlavored.blockSyntaxes,
    ],
    inlineSyntaxes: [
      ...md.ExtensionSet.gitHubFlavored.inlineSyntaxes,
      BoxSyntax(),
      md.LineBreakSyntax(),
      md.InlineHtmlSyntax(),
    ],
  );
  // final nodes = document.parse(input);
  // return _processNodes(nodes);

  final nodes = document.parse(input);
  final elements = _processNodes(nodes);

  // جمعآوری تمام المانها به ترتیب پیشوندی (pre-order)
  List<MarkdownElement> allElements = [];
  void collectElements(MarkdownElement element) {
    allElements.add(element);
    for (var child in element.children) {
      collectElements(child);
    }
  }

  for (var element in elements) {
    collectElements(element);
  }

  // اختصاص IDها به ترتیب
  int currentId = 1;
  for (var element in allElements) {
    element.id = currentId++;
  }

  return elements;
}

List<MarkdownElement> _processNodes(
  List<md.Node> nodes, {
  int parentIndentLevel = 0,
  List<String>? parentTypes, // تغییر پارامتر به List<String>?
}) {
  return nodes.asMap().entries.map((entry) {
    final index = entry.key;
    final node = entry.value;
    if (node is md.Element) {
      return _processElement(
        node,
        parentIndent: parentIndentLevel,
        parentTypes: parentTypes, // ارسال parentTypes
        index: index,
      );
    } else if (node is md.Text) {
      return _processText(
        node,
        indentLevel: parentIndentLevel,
        parentTypes: parentTypes, // ارسال parentTypes
        index: index,
      );
    }
    return MarkdownElement(
      type: 'unknown',
      parents: parentTypes,
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
  List<String>? parentTypes,
  required int index,
}) {
  return MarkdownElement(
    type: 'text',
    parents: parentTypes,
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
  List<String>? parentTypes, // تغییر پارامتر
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

  // ایجاد لیست جدید برای parentTypes فرزندان
  final children = _processNodes(
    element.children ?? [],
    parentIndentLevel: currentIndent,
    parentTypes: [
      ...(parentTypes ?? []),
      element.tag
    ], // اضافه کردن تگ فعلی به لیست والدین
  );

  final content = children.isEmpty ? _extractTextFromElement(element) : null;

  return MarkdownElement(
    type: element.tag,
    parents: parentTypes, // parentTypes والدین بالاتر
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
    "menu", //
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
        parentTypes: parentTypes,
        index: index,
      );
    case 'table':
      return _processTable(
        element,
        indentLevel: indentLevel,
        parentTypes: parentTypes,
        index: index,
      );
    case 'code':
      return _processCodeBlock(
        element,
        indentLevel: indentLevel,
        parentTypes: parentTypes,
        index: index,
      );
    case 'a':
      return _processLink(
        element,
        indentLevel: indentLevel,
        parentTypes: parentTypes,
        index: index,
      );
    case 'img':
      return _processImage(
        element,
        indentLevel: indentLevel,
        parentTypes: parentTypes,
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
  List<String>? parentTypes,
  required int index,
}) {
  // ایجاد لیست جدید parentTypes با افزودن تگ فعلی
  List<String> newParentTypes = [...(parentTypes ?? []), element.tag];

  return MarkdownElement(
    type: element.tag,
    parents: parentTypes,
    index: index,
    indent: indentLevel,
    children: _processNodes(
      element.children ?? [],
      parentIndentLevel: indentLevel + 1,
      parentTypes: newParentTypes, // ارسال لیست به‌روزشده
    ),
  );
}

MarkdownElement _processTable(
  md.Element element, {
  int indentLevel = 1,
  List<String>? parentTypes,
  required int index,
}) {
  try {
    // ایجاد لیست جدید parentTypes برای فرزندان
    final tableParentTypes = [...(parentTypes ?? []), element.tag];

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
      parentTypes: [...tableParentTypes, 'tr'],
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
            parentTypes: [...tableParentTypes, 'tr'],
          ).where((e) => e.type == 'td').toList();
        }).toList() ??
        [];

    return MarkdownElement(
      type: element.tag,
      parents: parentTypes,
      index: index,
      content: Content(headers: headers, rows: rows),
      indent: indentLevel,
    );
  } catch (e) {
    return MarkdownElement(
      type: element.tag,
      parents: parentTypes,
      index: index,
      content: Content(error: 'خطا در پردازش جدول: ${e.toString()}'),
      indent: indentLevel,
    );
  }
}

MarkdownElement _processCodeBlock(
  md.Element element, {
  int indentLevel = 0,
  List<String>? parentTypes,
  required int index,
}) {
  final language =
      element.attributes['class']?.replaceAll('language-', '') ?? '';

  return MarkdownElement(
    type: element.tag,
    parents: parentTypes,
    index: index,
    attributes: Attributes(language: language),
    indent: indentLevel,
    children: _processNodes(
      element.children ?? [],
      parentIndentLevel: indentLevel,
      parentTypes: [...(parentTypes ?? []), element.tag],
    ),
  );
}

MarkdownElement _processLink(
  md.Element element, {
  int indentLevel = 0,
  List<String>? parentTypes,
  required int index,
}) {
  return MarkdownElement(
    type: element.tag,
    parents: parentTypes,
    index: index,
    attributes: Attributes(
      href: element.attributes['href'] ?? '',
      title: element.attributes['title'] ?? '',
    ),
    children: _processNodes(
      element.children ?? [],
      parentIndentLevel: indentLevel,
      parentTypes: [...(parentTypes ?? []), element.tag],
    ),
    indent: indentLevel,
  );
}

MarkdownElement _processImage(
  md.Element element, {
  int indentLevel = 0,
  List<String>? parentTypes,
  required int index,
}) {
  return MarkdownElement(
    type: element.tag,
    parents: parentTypes,
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
      parentTypes: [...(parentTypes ?? []), element.tag],
    ),
  );
}
