import 'package:flutter/material.dart';
import 'package:flutter_math_fork/flutter_math.dart';
import 'package:markdown_parser/constants/colors.dart';
import 'package:markdown_parser/markdown/widgets/code_highlighter.dart';
import 'package:markdown_parser/markdown/merkdown_to_array.dart';
import 'package:markdown_parser/markdown/direction_analysis/direction_analysis.dart';
import 'package:markdown_parser/markdown/widgets/copy_button.dart';

class Group {
  final String level;
  final List<MarkdownElement> elements;

  Group({required this.level, required this.elements});

  List<int> getAllChildrenIds() {
    List<int> ids = [];
    for (var element in elements) {
      ids.addAll(element.getAllChildrenIds());
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

    bool currentIsBlock = isBlockLevel(children.first.type);
    List<MarkdownElement> currentGroup = [children.first];

    for (int i = 1; i < children.length; i++) {
      var child = children[i];
      bool isBlock = isBlockLevel(child.type);
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
                // child: HighlightView(
                //   code ?? '',
                //   language: language == null || language.isEmpty
                //       ? 'plaintext'
                //       : language,
                //   theme: theme,
                //   padding: const EdgeInsets.all(8.0),
                //   textStyle: const TextStyle(
                //     fontFamily: 'monospace',
                //     fontSize: 14.0,
                //   ),
                // ),
                child: CodeHighlighter(code: code ?? ''),
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
      width: double.infinity,
      margin: const EdgeInsets.symmetric(vertical: 10),
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: Colors.grey[100],
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
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
