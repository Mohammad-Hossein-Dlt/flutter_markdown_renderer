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
    final text = match[0]!; // Get the matched text
    final content = text
        .substring(2, text.length - 2)
        .trim(); // Remove the leading and trailing '\(' and '\)'

    // Add a new node for the inline math
    parser.addNode(md.Element.text('inline_math', content));
    return true;
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
    // If the element type is in the excludeTags list, return an empty string
    if (excludeTags.contains(element.type)) {
      return '';
    }

    String text = '';

    // Extract text from the normal element itself
    text += element.content?.text ?? '';

    // Special case for table elements
    if (element.type == 'table') {
      final tableContent = element.content;
      if (tableContent != null) {
        // Extract text from table headers
        if (tableContent.headers != null) {
          text +=
              ' ${tableContent.headers!.map((header) => _getElementText(header, excludeTags)).join(' ')}';
        }

        // Extract text from table rows and cells
        if (tableContent.rows != null) {
          for (final row in tableContent.rows!) {
            text +=
                ' ${row.map((cell) => _getElementText(cell, excludeTags)).join(' ')}';
          }
        }
      }
    }

    // Prosess element's children
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
    encodeHtml: false,
  );

  final nodes = document.parse(input);
  final elements = _processNodes(nodes);

  List<MarkdownElement> allElements = [];
  void collectElements(MarkdownElement element) {
    allElements.add(element); // Add the element to the list

    // Process children
    for (var child in element.children) {
      collectElements(child);
    }

    // Prosess table headers, rows, and cells
    if (element.type == 'table' && element.content != null) {
      // Process headers
      if (element.content!.headers != null) {
        for (var header in element.content!.headers!) {
          collectElements(header); // Add headers
        }
      }
      // Prosse rows and cells
      if (element.content!.rows != null) {
        for (var row in element.content!.rows!) {
          for (var cell in row) {
            collectElements(cell); // Add cells
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

  if (isBlockLevel(element.tag)) {
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

bool isBlockLevel(String tag) {
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

    // Process headers with new parentTypes
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

    // Process rows
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
      content: Content(error: 'Error processing table ${e.toString()}'),
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
    // If found
    if (element.id == targetId) {
      return true;
    }

    // Search in children
    for (var child in element.children) {
      if (findParents(child, targetId, parents)) {
        parents.add(Parent(type: element.type, id: element.id));
        return true;
      }
    }

    // Search in table headers
    if (element.type == 'table' && element.content?.headers != null) {
      for (var header in element.content!.headers!) {
        if (findParents(header, targetId, parents)) {
          parents.add(Parent(type: element.type, id: element.id));
          return true;
        }
      }
    }

    // Search in table cells
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

  return result.reversed.toList();
}
