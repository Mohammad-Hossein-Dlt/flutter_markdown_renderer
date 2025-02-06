import 'package:ai_app/constants/colors.dart';
import 'package:ai_app/constants/data.dart';
import 'package:ai_app/constants/theme.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_highlight/flutter_highlight.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:markdown/markdown.dart' as md;

class BoxSyntax extends md.InlineSyntax {
  BoxSyntax() : super(r'`([^`]+)`'); // شناسایی متن بین دو backtick

  @override
  bool onMatch(md.InlineParser parser, Match match) {
    final content = match.group(1)!; // متن داخل backtick
    parser.addNode(
        md.Element.text('inline_code', content)); // ایجاد یک تگ جدید به نام box
    return true;
  }
}

List<Map<String, dynamic>> markdownToJson(String markdownText) {
  final nodes = md.Document().parse(markdownText);
  final jsonList = _processNodes(nodes);
  // return jsonEncode(jsonList);
  return jsonList;
}

List<Map<String, dynamic>> _processNodes(List<md.Node> nodes) {
  final List<Map<String, dynamic>> result = [];

  for (final node in nodes) {
    if (node is md.Element) {
      final Map<String, dynamic> element = {
        'type': node.tag,
        'content': _extractContent(node),
      };
      if (node.attributes.isNotEmpty) {
        element['attributes'] = node.attributes;
      }
      if (node.children != null) {
        element['children'] = _processNodes(node.children!);
      }
      result.add(element);
    } else if (node is Text) {
      result.add({
        'type': 'text',
        'content': node.textContent,
      });
    }
  }

  return result;
}

dynamic _extractContent(md.Element element) {
  if (element.tag == 'ul' || element.tag == 'ol') {
    return null; // Content در لیست‌ها از طریق children مدیریت می‌شود
  }
  return element.textContent;
}

class XmlContent extends StatefulWidget {
  const XmlContent({super.key});

  @override
  State<XmlContent> createState() => _XmlContentState();
}

class _XmlContentState extends State<XmlContent> {
  // String text = '';
  // String _displayedText = "";
  // int _currentIndex = 0;
  // Timer? _timer;

  // @override
  // void initState() {
  //   super.initState();
  //   text = d10;

  //   _startTyping();
  // }

  // void _startTyping() {
  //   _timer = Timer.periodic(
  //     const Duration(milliseconds: 10),
  //     (timer) {
  //       if (_currentIndex < text.length) {
  //         setState(() {
  //           _displayedText += text[_currentIndex];
  //           _currentIndex++;
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

  @override
  Widget build(BuildContext context) {
    // String converted = md.markdownToHtml(
    //   // d6.replaceAll(RegExp(r'\n\s*\n'), '\n<br>\n'),
    //   d6,
    // extensionSet: md.ExtensionSet.gitHubFlavored,
    // blockSyntaxes: [
    //   ...md.ExtensionSet.gitHubFlavored.blockSyntaxes,
    // ],
    // inlineSyntaxes: [
    //   ...md.ExtensionSet.gitHubFlavored.inlineSyntaxes,
    //   BoxSyntax(),
    //   md.LineBreakSyntax(),
    //   md.InlineHtmlSyntax(),
    // ],
    // );

    // final document = md.Document();
    // final nodes = document.parseLines(d6.split('\n'));
    // if (kDebugMode) {
    //   debugPrint(nodes.toString());
    // }
    final jsonOutput = markdownToJson(d10);
    if (kDebugMode) {
      debugPrint(jsonOutput.toString());
    }
    return Scaffold(
      body: SafeArea(
        child: MarkdownParser(markdownData: d10),
      ),
    );
  }
}

class MarkdownParser extends StatefulWidget {
  final String markdownData;

  const MarkdownParser({super.key, required this.markdownData});

  @override
  State<MarkdownParser> createState() => _MarkdownParserState();
}

class _MarkdownParserState extends State<MarkdownParser> {
  @override
  Widget build(BuildContext context) {
    final parsedLines = _parseMarkdown(widget.markdownData);
    final widgets = _buildWidgets(parsedLines);

    return ListView(
      padding: const EdgeInsets.all(10),
      children: widgets,
    );
  }

  List<MarkdownElement> _parseMarkdown(
    String markdown, {
    int parentBlockquoteIndent = 0,
  }) {
    final lines = markdown.split('\n');
    final elements = <MarkdownElement>[];
    bool inCodeBlock = false;
    String codeBuffer = '';
    String? language;

    for (var i = 0; i < lines.length; i++) {
      final line = lines[i];
      final trimmedLine = line.trim();

      if (trimmedLine.startsWith('```')) {
        if (inCodeBlock) {
          elements.add(
            MarkdownElement(
              type: MarkdownType.codeBlock,
              content: codeBuffer.trim(),
              language: language,
            ),
          );
          codeBuffer = '';
          inCodeBlock = false;
          language = null;
        } else {
          inCodeBlock = true;
          language = trimmedLine.substring(3).trim();
        }
      } else if (inCodeBlock) {
        codeBuffer += '$trimmedLine\n';
      } else if (line.startsWith('|') &&
          i + 1 < lines.length &&
          lines[i + 1].startsWith('|')) {
        final tableLines = <String>[];
        while (i < lines.length && lines[i].startsWith('|')) {
          tableLines.add(lines[i]);
          i++;
        }
        i--;
        elements.add(MarkdownElement(
          type: MarkdownType.table,
          content: tableLines.join('\n'),
        ));
      } else {
        final listMatch = RegExp(r'^(\s*)([-•*]|\d+\.)\s').firstMatch(line);
        if (listMatch != null) {
          final indent = listMatch.group(1)!.length;
          RegExp orderPattern = RegExp(r'\d+\.');
          final isOrdered = orderPattern.hasMatch(listMatch.group(2)!);
          Match? findedListNumber = orderPattern.firstMatch(line);
          String? listNumber;

          if (findedListNumber != null) {
            listNumber = findedListNumber.group(0);
          }

          elements.add(
            MarkdownElement(
              type: isOrdered
                  ? MarkdownType.orderedListItem
                  : MarkdownType.unorderedListItem,
              content: line.trim(),
              indentLevel: indent ~/ 2,
              listNumber: listNumber,
            ),
          );
        } else if (trimmedLine.startsWith('# ')) {
          elements.add(MarkdownElement(
            type: MarkdownType.header1,
            content: trimmedLine.substring(2).trim(),
          ));
        } else if (trimmedLine.startsWith('## ')) {
          elements.add(MarkdownElement(
            type: MarkdownType.header2,
            content: trimmedLine.substring(3).trim(),
          ));
        } else if (trimmedLine.startsWith('### ')) {
          elements.add(MarkdownElement(
            type: MarkdownType.header3,
            content: trimmedLine.substring(4).trim(),
          ));
        } else if (trimmedLine.startsWith('#### ')) {
          elements.add(MarkdownElement(
            type: MarkdownType.header4,
            content: trimmedLine.substring(5).trim(),
          ));
        } else if (trimmedLine.startsWith('##### ')) {
          elements.add(MarkdownElement(
            type: MarkdownType.header5,
            content: trimmedLine.substring(6).trim(),
          ));
        } else if (trimmedLine.startsWith('###### ')) {
          elements.add(MarkdownElement(
            type: MarkdownType.header6,
            content: trimmedLine.substring(7).trim(),
          ));
        } else if (trimmedLine.startsWith('>')) {
          int currentIndent = parentBlockquoteIndent;
          List<String> blockquoteContent = [];

          while (i < lines.length &&
              (lines[i].trim().isEmpty || lines[i].startsWith('>'))) {
            if (lines[i].trim().isNotEmpty) {
              String processedLine =
                  lines[i].replaceFirst(RegExp(r'^>+\s*'), '');
              blockquoteContent.add(processedLine);
            } else {
              blockquoteContent.add('');
            }
            i++;
          }
          i--;
          final children = _parseMarkdown(
            blockquoteContent.join('\n'),
            parentBlockquoteIndent: parentBlockquoteIndent + 1,
          );

          elements.add(
            MarkdownElement(
              type: MarkdownType.blockquote,
              content: '',
              indentLevel: currentIndent,
              children: children,
            ),
          );
        } else if (RegExp(r'^ *-{3,} *$').hasMatch(trimmedLine)) {
          elements.add(MarkdownElement(
            type: MarkdownType.horizontalRule,
            content: '',
          ));
        } else if (trimmedLine.isEmpty) {
          elements.add(MarkdownElement(
            type: MarkdownType.emptyLine,
            content: '',
          ));
        } else {
          elements.add(MarkdownElement(
            type: MarkdownType.paragraph,
            content: trimmedLine,
          ));
        }
      }
    }

    if (inCodeBlock) {
      elements.add(
        MarkdownElement(
          type: MarkdownType.codeBlock,
          content: codeBuffer.trim(),
          language: language,
        ),
      );
      codeBuffer = '';
      inCodeBlock = false;
      language = null;
    }

    return elements;
  }

  List<Widget> _buildWidgets(List<MarkdownElement> elements) {
    final widgets = <Widget>[];
    for (var element in elements) {
      switch (element.type) {
        case MarkdownType.header1:
          widgets.add(_buildHeader(element.content, 32));
          break;
        case MarkdownType.header2:
          widgets.add(_buildHeader(element.content, 24));
          break;
        case MarkdownType.header3:
          widgets.add(_buildHeader(element.content, 20));
          break;
        case MarkdownType.header4:
          widgets.add(_buildHeader(element.content, 16));
          break;
        case MarkdownType.header5:
          widgets.add(_buildHeader(element.content, 12));
          break;
        case MarkdownType.header6:
          widgets.add(_buildHeader(element.content, 8));
          break;
        case MarkdownType.paragraph:
          widgets.add(_buildParagraph(element.content));
          break;
        case MarkdownType.unorderedListItem:
          widgets.add(_buildListItem(element));
          break;
        case MarkdownType.orderedListItem:
          widgets.add(_buildListItem(element));
          break;
        case MarkdownType.blockquote:
          widgets.add(_buildBlockquote(element));
          break;
        case MarkdownType.codeBlock:
          widgets.add(_buildCodeBlock(element.content, element.language));
          break;
        case MarkdownType.table:
          widgets.add(_buildTable(element.content));
          break;
        case MarkdownType.horizontalRule:
          widgets.add(horizontalRule());
          break;
        case MarkdownType.emptyLine:
          widgets.add(const SizedBox(height: 8));
          break;
      }
    }
    return widgets;
  }

  Widget _buildParagraph(String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: _buildFormattedText(text),
    );
  }

  Widget _buildFormattedText(
    String text, {
    TextDirection? direction,
    TextStyle? baseStyle,
    TextAlign? textAlign,
  }) {
    final textDirection = direction ?? getDominantTextDirectionFromText(text);

    return RichText(
      textAlign: textAlign ?? TextAlign.start,
      textDirection: textDirection,
      text: TextSpan(
        style: const TextStyle(
          fontFamily: 'Shabnam',
          fontSize: 16,
          color: Colors.black,
          height: 1.4,
        ).merge(baseStyle),
        children: _buildTextSpans(text, baseStyle: baseStyle),
      ),
    );
  }

  // List<InlineSpan> _buildTextSpans(String text, {TextStyle? baseStyle}) {
  //   final spans = <InlineSpan>[];
  //   final regex = RegExp(
  //     r'(\*\*\*([^\n]*?)\*\*\*|\*\*([^\n]*?)\*\*|\*([^\n]*?)\*|_([^\n]*?)_|~~([^\n]*?)~~|`([^\n]*?)`|!\[([^\n]*?)\]\(([^\n]*?)\)|\[([^\n]*?)\]\(([^\n]*?)\)|~([^\n]*?)~)',
  //     multiLine: true,
  //     dotAll: true,
  //   );

  //   final matches = regex.allMatches(text);
  //   int lastMatchEnd = 0;

  //   void addPlainText(int start, int end) {
  //     if (start < end) {
  //       spans.add(
  //         TextSpan(
  //           text: text.substring(start, end),
  //           style: baseStyle,
  //         ),
  //       );
  //     }
  //   }

  //   for (final match in matches) {
  //     addPlainText(lastMatchEnd, match.start);
  //     final matchText = match.group(0) ?? '';

  //     TextStyle? newStyle;
  //     String? content;

  //     if (matchText.startsWith('***')) {
  //       content = match.group(2) ?? '';
  //       newStyle = const TextStyle(
  //         fontWeight: FontWeight.bold,
  //         fontStyle: FontStyle.italic,
  //       ).merge(baseStyle);
  //     } else if (matchText.startsWith('**')) {
  //       content = match.group(3) ?? '';
  //       newStyle = const TextStyle(
  //         fontWeight: FontWeight.bold,
  //       ).merge(baseStyle);
  //     } else if (matchText.startsWith('*')) {
  //       content = match.group(4) ?? '';
  //       newStyle = const TextStyle(
  //         fontStyle: FontStyle.italic,
  //       ).merge(baseStyle);
  //     } else if (matchText.startsWith('_')) {
  //       content = match.group(5) ?? '';
  //       newStyle = const TextStyle(
  //         fontStyle: FontStyle.italic,
  //       ).merge(baseStyle);
  //     } else if (matchText.startsWith('~~')) {
  //       content = match.group(6) ?? '';
  //       newStyle = const TextStyle(
  //         decoration: TextDecoration.lineThrough,
  //         decorationColor: black,
  //       ).merge(baseStyle);
  //     } else if (matchText.startsWith('~')) {
  //       content = match.group(12) ?? '';
  //       newStyle = const TextStyle(
  //         decoration: TextDecoration.underline,
  //         decorationColor: black,
  //       ).merge(baseStyle);
  //     } else if (matchText.startsWith('`')) {
  //       content = match.group(7) ?? '';
  //       newStyle = TextStyle(
  //         fontFamily: 'monospace',
  //         color: Colors.grey.shade600,
  //         height: 1.2,
  //       ).merge(baseStyle);
  //     } else if (matchText.startsWith('![')) {
  //       final altText = match.group(8);
  //       final imageUrl = match.group(9);
  //       if (imageUrl != null) {
  //         spans.add(
  //           WidgetSpan(
  //             baseline: TextBaseline.alphabetic,
  //             alignment: PlaceholderAlignment.middle,
  //             child: CachedNetworkImage(
  //               imageUrl: imageUrl,
  //               imageBuilder: (context, imageProvider) {
  //                 return SizedBox(
  //                   width: 200,
  //                   height: 200,
  //                   child: ClipRRect(
  //                     borderRadius: BorderRadius.circular(20),
  //                     child: Image(
  //                       image: imageProvider,
  //                       fit: BoxFit.cover,
  //                     ),
  //                   ),
  //                 );
  //               },
  //               placeholder: (context, url) {
  //                 return const SizedBox(
  //                   width: 20,
  //                   height: 20,
  //                   child: CircularProgressIndicator(
  //                     color: grey,
  //                     strokeWidth: 2,
  //                   ),
  //                 );
  //               },
  //               errorWidget: (context, error, stackTrace) =>
  //                   Text(altText ?? 'Image Error'),
  //             ),
  //           ),
  //         );
  //       }
  //       lastMatchEnd = match.end;
  //       continue;
  //     } else if (matchText.startsWith('[')) {
  //       final linkText = match.group(10);
  //       final url = match.group(11);
  //       if (url != null) {
  //         spans.add(
  //           WidgetSpan(
  //             baseline: TextBaseline.alphabetic,
  //             alignment: PlaceholderAlignment.middle,
  //             child: InkWell(
  //               borderRadius: BorderRadius.circular(4),
  //               onTap: () {
  //                 print(url);
  //               },
  //               child: RichText(
  //                 text: TextSpan(
  //                   style: const TextStyle(
  //                     color: Colors.blue,
  //                     decoration: TextDecoration.underline,
  //                   ).merge(baseStyle),
  //                   children:
  //                       _buildTextSpans(linkText ?? url, baseStyle: baseStyle),
  //                 ),
  //               ),
  //             ),
  //           ),
  //         );
  //       }
  //       lastMatchEnd = match.end;
  //       continue;
  //     }

  //     if (newStyle != null && content != null) {
  //       spans.add(
  //         TextSpan(
  //           style: newStyle,
  //           children: _buildTextSpans(content, baseStyle: newStyle),
  //         ),
  //       );
  //     } else {
  //       addPlainText(match.start, match.end);
  //     }

  //     lastMatchEnd = match.end;
  //   }

  //   addPlainText(lastMatchEnd, text.length);
  //   return spans;
  // }

  // List<InlineSpan> _buildTextSpans(String text, {TextStyle? baseStyle}) {
  //   final spans = <InlineSpan>[];
  //   final regex = RegExp(
  //     r'(\~\~([^\n]*?)\~\~|~([^\n]*?)~|\*\*\*([^\n]*?)\*\*\*|\*\*([^\n]*?)\*\*|\*([^\n]*?)\*|_([^\n]*?)_|`([^\n]*?)`|!\[([^\n]*?)\]\(([^\n]*?)\)|\[([^\n]*?)\]\(([^\n]*?)\))',
  //     multiLine: true,
  //     dotAll: true,
  //   );

  //   final matches = regex.allMatches(text);
  //   int lastMatchEnd = 0;

  //   void addPlainText(int start, int end) {
  //     if (start < end) {
  //       spans.add(
  //         TextSpan(
  //           text: text.substring(start, end),
  //           style: baseStyle,
  //         ),
  //       );
  //     }
  //   }

  //   for (final match in matches) {
  //     addPlainText(lastMatchEnd, match.start);
  //     final matchText = match.group(0) ?? '';

  //     TextStyle? newStyle;
  //     String? content;

  //     // اولویت پردازش با سینتکسهای سطح بالاتر (~ و ~~)
  //     if (matchText.startsWith('~~')) {
  //       content = match.group(2) ?? '';
  //       newStyle = const TextStyle(
  //         decoration: TextDecoration.lineThrough,
  //         decorationColor: Colors.black,
  //       ).merge(baseStyle);
  //     } else if (matchText.startsWith('~') && !matchText.startsWith('~~')) {
  //       content = match.group(3) ?? '';
  //       newStyle = const TextStyle(
  //         decoration: TextDecoration.underline,
  //         decorationColor: Colors.black,
  //       ).merge(baseStyle);
  //     } else if (matchText.startsWith('***')) {
  //       content = match.group(4) ?? '';
  //       newStyle = const TextStyle(
  //         fontWeight: FontWeight.bold,
  //         fontStyle: FontStyle.italic,
  //       ).merge(baseStyle);
  //     } else if (matchText.startsWith('**')) {
  //       content = match.group(5) ?? '';
  //       newStyle = const TextStyle(
  //         fontWeight: FontWeight.bold,
  //       ).merge(baseStyle);
  //     } else if (matchText.startsWith('*')) {
  //       content = match.group(6) ?? '';
  //       newStyle = const TextStyle(
  //         fontStyle: FontStyle.italic,
  //       ).merge(baseStyle);
  //     } else if (matchText.startsWith('_')) {
  //       content = match.group(7) ?? '';
  //       newStyle = const TextStyle(
  //         fontStyle: FontStyle.italic,
  //       ).merge(baseStyle);
  //     } else if (matchText.startsWith('`')) {
  //       content = match.group(8) ?? '';
  //       newStyle = const TextStyle(
  //         fontFamily: 'monospace',
  //         color: grey,
  //         // height: 1.2,
  //         fontSize: 12,
  //       ).merge(baseStyle);

  //       spans.add(
  //         WidgetSpan(
  //           baseline: TextBaseline.alphabetic,
  //           alignment: PlaceholderAlignment.middle,
  //           child: Container(
  //             padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 0),
  //             decoration: BoxDecoration(
  //               color: Colors.grey[200],
  //               borderRadius: BorderRadius.circular(4),
  //             ),
  //             child: Text(
  //               content,
  //               style: newStyle,
  //             ),
  //           ),
  //         ),
  //       );
  //       lastMatchEnd = match.end;
  //       continue;
  //     } else if (matchText.startsWith('![')) {
  //       // پردازش تصاویر
  //       final altText = match.group(9);
  //       final imageUrl = match.group(10);
  //       if (imageUrl != null) {
  //         spans.add(
  //           WidgetSpan(
  //             baseline: TextBaseline.alphabetic,
  //             alignment: PlaceholderAlignment.middle,
  //             child: CachedNetworkImage(
  //               imageUrl: imageUrl,
  //               imageBuilder: (context, imageProvider) {
  //                 return SizedBox(
  //                   width: 200,
  //                   height: 200,
  //                   child: ClipRRect(
  //                     borderRadius: BorderRadius.circular(20),
  //                     child: Image(
  //                       image: imageProvider,
  //                       fit: BoxFit.cover,
  //                     ),
  //                   ),
  //                 );
  //               },
  //               placeholder: (context, url) {
  //                 return const SizedBox(
  //                   width: 20,
  //                   height: 20,
  //                   child: CircularProgressIndicator(
  //                     color: Colors.grey,
  //                     strokeWidth: 2,
  //                   ),
  //                 );
  //               },
  //               errorWidget: (context, error, stackTrace) =>
  //                   Text(altText ?? 'Image Error'),
  //             ),
  //           ),
  //         );
  //       }
  //       lastMatchEnd = match.end;
  //       continue;
  //     } else if (matchText.startsWith('[')) {
  //       // پردازش لینکها
  //       final linkText = match.group(11);
  //       final url = match.group(12);
  //       if (url != null) {
  //         spans.add(
  //           WidgetSpan(
  //             baseline: TextBaseline.alphabetic,
  //             alignment: PlaceholderAlignment.middle,
  //             child: InkWell(
  //               borderRadius: BorderRadius.circular(4),
  //               // onTap: () => launchUrl(Uri.parse(url)),
  //               child: RichText(
  //                 text: TextSpan(
  //                   style: const TextStyle(
  //                     color: Colors.blue,
  //                     decoration: TextDecoration.underline,
  //                   ).merge(baseStyle),
  //                   children:
  //                       _buildTextSpans(linkText ?? url, baseStyle: baseStyle),
  //                 ),
  //               ),
  //             ),
  //           ),
  //         );
  //       }
  //       lastMatchEnd = match.end;
  //       continue;
  //     }

  //     if (newStyle != null && content != null) {
  //       spans.add(
  //         TextSpan(
  //           style: newStyle,
  //           children: _buildTextSpans(content, baseStyle: newStyle),
  //         ),
  //       );
  //     } else {
  //       addPlainText(match.start, match.end);
  //     }

  //     lastMatchEnd = match.end;
  //   }

  //   addPlainText(lastMatchEnd, text.length);
  //   return spans;
  // }

  List<InlineSpan> _buildTextSpans(String text, {TextStyle? baseStyle}) {
    final spans = <InlineSpan>[];
    final regex = RegExp(
      r'(\*\*\*[^*]+\*\*\*|\*\*[^*]+\*\*|\*[^*]+\*|_[^_]+_|~~[^~]+~~|`[^`]+`|!\[.*?\]\(.*?\)|\[.*?\]\(.*?\)|~[^~]+~)',
      multiLine: true,
      dotAll: true,
    );

    final matches = regex.allMatches(text);
    int lastMatchEnd = 0;

    void addPlainText(int start, int end) {
      if (start < end) {
        spans.add(
          TextSpan(
            text: text.substring(start, end),
            style: baseStyle,
          ),
        );
      }
    }

    for (final match in matches) {
      addPlainText(lastMatchEnd, match.start);
      final matchText = match.group(0) ?? '';

      TextStyle? newStyle;
      String? content;

      if (matchText.startsWith('***')) {
        content = matchText.substring(3, matchText.length - 3);
        newStyle = const TextStyle(
          fontWeight: FontWeight.bold,
          fontStyle: FontStyle.italic,
        ).merge(baseStyle);
      } else if (matchText.startsWith('**')) {
        content = matchText.substring(2, matchText.length - 2);
        newStyle = const TextStyle(
          fontWeight: FontWeight.bold,
        ).merge(baseStyle);
      } else if (matchText.startsWith('*')) {
        content = matchText.substring(1, matchText.length - 1);
        newStyle = const TextStyle(
          fontStyle: FontStyle.italic,
        ).merge(baseStyle);
      } else if (matchText.startsWith('_')) {
        content = matchText.substring(1, matchText.length - 1);
        newStyle = const TextStyle(
          fontStyle: FontStyle.italic,
        ).merge(baseStyle);
      } else if (matchText.startsWith('~~')) {
        content = matchText.substring(2, matchText.length - 2);
        newStyle = const TextStyle(
          decoration: TextDecoration.lineThrough,
          decorationColor: black,
        ).merge(baseStyle);
      } else if (matchText.startsWith('~') && !matchText.startsWith('~~')) {
        content = matchText.substring(1, matchText.length - 1);
        newStyle = const TextStyle(
          decoration: TextDecoration.underline,
          decorationColor: black,
        ).merge(baseStyle);
      } else if (matchText.startsWith('`')) {
        content = matchText.substring(1, matchText.length - 1);
        newStyle = TextStyle(
          fontFamily: 'monospace',
          color: Colors.grey.shade600,
          height: 1.2,
        ).merge(baseStyle);
      } else if (matchText.startsWith('![')) {
        final altText = matchText.substring(2, matchText.indexOf(']'));
        final imageUrl = matchText.substring(
            matchText.indexOf('(') + 1, matchText.lastIndexOf(')'));
        spans.add(
          WidgetSpan(
            baseline: TextBaseline.alphabetic,
            alignment: PlaceholderAlignment.middle,
            child: CachedNetworkImage(
              imageUrl: imageUrl,
              imageBuilder: (context, imageProvider) {
                return SizedBox(
                  width: 200,
                  height: 200,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(20),
                    child: Image(
                      image: imageProvider,
                      fit: BoxFit.cover,
                    ),
                  ),
                );
              },
              placeholder: (context, url) {
                return const SizedBox(
                  width: 20,
                  height: 20,
                  child: CircularProgressIndicator(
                    color: grey,
                    strokeWidth: 2,
                  ),
                );
              },
              errorWidget: (context, error, stackTrace) =>
                  Text(altText.isNotEmpty ? altText : 'Image Error'),
            ),
          ),
        );
        lastMatchEnd = match.end;
        continue;
      } else if (matchText.startsWith('[')) {
        final linkText = matchText.substring(1, matchText.indexOf(']'));
        final url = matchText.substring(
            matchText.indexOf('(') + 1, matchText.lastIndexOf(')'));
        spans.add(
          WidgetSpan(
            baseline: TextBaseline.alphabetic,
            alignment: PlaceholderAlignment.middle,
            child: InkWell(
              borderRadius: BorderRadius.circular(4),
              onTap: () {
                print(url);
              },
              child: RichText(
                text: TextSpan(
                  style: const TextStyle(
                    color: Colors.blue,
                    decoration: TextDecoration.underline,
                  ).merge(baseStyle),
                  children: _buildTextSpans(
                      linkText.isNotEmpty ? linkText : url,
                      baseStyle: baseStyle),
                ),
              ),
            ),
          ),
        );
        lastMatchEnd = match.end;
        continue;
      }

      if (newStyle != null && content != null) {
        spans.add(
          TextSpan(
            style: newStyle,
            children: _buildTextSpans(content, baseStyle: newStyle),
          ),
        );
      } else {
        addPlainText(match.start, match.end);
      }

      lastMatchEnd = match.end;
    }

    addPlainText(lastMatchEnd, text.length);
    return spans;
  }

  Widget _buildHeader(String text, double fontSize) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: _buildFormattedText(
        text,
        baseStyle: TextStyle(
          fontSize: fontSize,
          fontWeight: FontWeight.bold,
          height: 1.4,
        ),
      ),
    );
  }

  Widget _buildBlockquote(MarkdownElement element) {
    Widget childContent = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: _buildWidgets(element.children),
    );

    return Padding(
      padding:
          EdgeInsetsDirectional.only(start: element.indentLevel > 0 ? 6 : 0),
      child: IntrinsicHeight(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
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
              child: childContent,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCodeBlock(String code, String? language) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      decoration: BoxDecoration(
        color: Colors.grey[100],
        borderRadius: BorderRadius.circular(8.0),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            textDirection: TextDirection.ltr,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                language == null || language.isEmpty
                    ? 'plaintext'
                    : language[0].toUpperCase() + language.substring(1),
                style: const TextStyle(
                  color: grey,
                ),
              ),
              TextButton(
                style: TextButton.styleFrom(
                  padding: EdgeInsets.zero,
                  minimumSize: const Size(90, 30),
                  maximumSize: const Size(90, 30),
                  fixedSize: const Size(90, 30),
                  overlayColor: black,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                onPressed: () {},
                child: const Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Icon(
                      FontAwesomeIcons.clipboard,
                      size: 18,
                      color: black,
                    ),
                    Text(
                      'Copy code',
                      style: TextStyle(
                        fontSize: 12,
                        color: black,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          Container(
            width: double.infinity,
            height: 0.5,
            decoration: const BoxDecoration(
              color: lightGrey,
            ),
          ),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: HighlightView(
              code,
              language: language == null || language.isEmpty
                  ? 'plaintext'
                  : language, // زبان کدنویسی (پیش‌فرض: ساده)
              theme: theme, // تم برجسته‌سازی
              padding: const EdgeInsets.all(8.0),
              textStyle: const TextStyle(
                fontFamily: 'monospace',
                fontSize: 14.0,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget horizontalRule() {
    return const Divider(
      height: 1,
      thickness: 1,
      color: lightGrey,
    );
  }

  Widget _buildListItem(MarkdownElement element) {
    String content =
        element.content.replaceFirst(RegExp(r'^(\s*)([-•*]|\d+\.)\s'), '');

    TextDirection dominantTextDirection =
        getDominantTextDirectionFromText(element.content);
    bool isRTL = dominantTextDirection == TextDirection.rtl;

    final indicator = element.type == MarkdownType.orderedListItem
        ? '${element.listNumber} '
        : '• ';

    EdgeInsetsDirectional edgeInsetsDirectional = EdgeInsetsDirectional.only(
      start: !isRTL ? 30.0 * element.indentLevel : 0,
      end: isRTL ? 30.0 * element.indentLevel : 0,
      top: 4,
      bottom: 4,
    );

    if (isRTL) {
      edgeInsetsDirectional = EdgeInsetsDirectional.only(
        start: isRTL ? 30.0 * element.indentLevel : 0,
        end: !isRTL ? 30.0 * element.indentLevel : 0,
        top: 4,
        bottom: 4,
      );
    }

    return Padding(
      padding: edgeInsetsDirectional,
      child: IntrinsicHeight(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.baseline,
          textBaseline: TextBaseline.alphabetic,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Text(
              indicator,
              style: const TextStyle(
                fontSize: 16,
                color: grey,
                height: 1.6,
              ),
            ),
            const SizedBox(width: 4),
            Expanded(
              child: _buildFormattedText(
                content,
                direction: dominantTextDirection,
                baseStyle: const TextStyle(height: 1.6, fontSize: 16),
                textAlign: TextAlign.left,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTable(String tableContent) {
    final rows = tableContent.split('\n');
    final headers = rows.first
        .split('|')
        .map((e) => e.trim())
        .where((e) => e.isNotEmpty)
        .toList();

    final headerCount = headers.length;

    final dataRows = rows.skip(2).map((row) {
      var cells = row
          .split('|')
          .map((e) => e.trim())
          .where((e) => e.isNotEmpty)
          .toList();

      // نرمالایز کردن طول سطرها
      if (cells.length < headerCount) {
        // پر کردن سلول‌های خالی برای سطرهای کوتاه‌تر
        cells.addAll(List.filled(headerCount - cells.length, ''));
      } else if (cells.length > headerCount) {
        // قطع کردن سطرهای بلندتر
        cells = cells.sublist(0, headerCount);
      }

      return cells;
    }).toList();

    return Align(
      alignment: Alignment.center,
      child: Directionality(
        textDirection: getDominantTextDirectionFromText(tableContent),
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
                            child: Text(
                              header,
                              textAlign: TextAlign.center,
                              style:
                                  const TextStyle(fontWeight: FontWeight.bold),
                            ),
                          ))
                      .toList(),
                ),
                ...dataRows.map(
                  (row) => TableRow(
                    children: row
                        .map(
                          (cell) => Padding(
                            padding: const EdgeInsets.all(12),
                            child: _buildFormattedText(
                              cell,
                              textAlign: TextAlign.center,
                            ),
                          ),
                        )
                        .toList(),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

enum MarkdownType {
  header1,
  header2,
  header3,
  header4,
  header5,
  header6,
  paragraph,
  unorderedListItem,
  orderedListItem,
  blockquote,
  codeBlock,
  table,
  horizontalRule,
  emptyLine,
}

class MarkdownElement {
  final MarkdownType type;
  String content;
  final String? language;
  final int indentLevel;
  final String? listNumber;
  final List<MarkdownElement> children; // محتوای تو در تو

  MarkdownElement({
    required this.type,
    required this.content,
    this.language,
    this.indentLevel = 0,
    this.listNumber,
    this.children = const [],
  });
}

// List<InlineSpan> _buildTextSpans(String text, {TextStyle? baseStyle}) {
//   // 1. تعریف delimiterها با اولویت طولانی‌ترین علامت باز
//   final delimiters = [
//     DelimiterInfo(
//       open: '***',
//       close: '***',
//       style: const TextStyle(
//         fontWeight: FontWeight.bold,
//         fontStyle: FontStyle.italic,
//       ),
//     ),
//     DelimiterInfo(
//       open: '**',
//       close: '**',
//       style: const TextStyle(
//         fontWeight: FontWeight.bold,
//       ),
//     ),
//     DelimiterInfo(
//       open: '~~',
//       close: '~~',
//       style: const TextStyle(
//         decoration: TextDecoration.lineThrough,
//       ),
//     ),
//     DelimiterInfo(
//       open: '`',
//       close: '`',
//       style: TextStyle(
//         fontFamily: 'monospace',
//         color: Colors.grey[600],
//       ),
//     ),
//     DelimiterInfo(
//       open: '*',
//       close: '*',
//       style: const TextStyle(
//         fontStyle: FontStyle.italic,
//       ),
//     ),
//     DelimiterInfo(
//       open: '~',
//       close: '~',
//       style: const TextStyle(
//         decoration: TextDecoration.underline,
//       ),
//     ),
//     DelimiterInfo(
//       open: '_',
//       close: '_',
//       style: const TextStyle(
//         fontStyle: FontStyle.italic,
//       ),
//     ),
//   ]..sort((a, b) =>
//       b.open.length.compareTo(a.open.length)); // اولویت با طولانی‌ترها

//   final spans = <InlineSpan>[];
//   final stack = <DelimiterStackEntry>[];
//   final textBuffer = StringBuffer();
//   int i = 0;

//   while (i < text.length) {
//     bool foundDelimiter = false;

//     // 2. بررسی delimiterهای باز با اولویت طولانی‌ترین
//     for (final delimiter in delimiters) {
//       if (i + delimiter.open.length > text.length) continue;

//       final candidate = text.substring(i, i + delimiter.open.length);
//       if (candidate == delimiter.open) {
//         // ذخیره متن عادی قبل از delimiter
//         if (textBuffer.isNotEmpty) {
//           spans.add(TextSpan(
//             text: textBuffer.toString(),
//             style: baseStyle,
//           ));
//           textBuffer.clear();
//         }

//         // اضافه به پشته با استایل ترکیبی
//         stack.add(DelimiterStackEntry(
//           delimiter: delimiter,
//           startIndex: i,
//           parentStyle: baseStyle,
//         ));

//         i += delimiter.open.length;
//         foundDelimiter = true;
//         break;
//       }
//     }

//     if (foundDelimiter) continue;

//     // 3. بررسی delimiterهای بسته
//     bool foundClosing = false;
//     for (final delimiter in delimiters) {
//       if (i + delimiter.close.length > text.length) continue;

//       final candidate = text.substring(i, i + delimiter.close.length);
//       if (candidate == delimiter.close) {
//         // جستجو در پشته برای تطابق
//         for (int j = stack.length - 1; j >= 0; j--) {
//           final entry = stack[j];
//           if (entry.delimiter == delimiter) {
//             // محاسبه محدوده محتوا
//             final contentStart = entry.startIndex + delimiter.open.length;
//             final contentEnd = i;
//             final content = text.substring(contentStart, contentEnd);

//             // ترکیب استایل والد و فرزند
//             final combinedStyle =
//                 entry.parentStyle?.merge(delimiter.style) ?? delimiter.style;

//             // پردازش بازگشتی با اولویت داخلی‌ترین المان
//             final innerSpans =
//                 _buildTextSpans(content, baseStyle: combinedStyle);

//             // حذف المان‌های پشته از j به بعد
//             stack.removeRange(j, stack.length);

//             // اضافه کردن spans داخلی
//             spans.add(TextSpan(
//               children: innerSpans,
//               style: combinedStyle,
//             ));

//             i += delimiter.close.length;
//             foundClosing = true;
//             break;
//           }
//         }
//         if (foundClosing) break;
//       }
//     }

//     if (foundClosing) continue;

//     // 4. افزودن کاراکتر به بافر در صورت عدم وجود delimiter
//     textBuffer.write(text[i]);
//     i++;
//   }

//   // 5. افزودن متن باقی‌مانده از بافر
//   if (textBuffer.isNotEmpty) {
//     spans.add(TextSpan(
//       text: textBuffer.toString(),
//       style: baseStyle,
//     ));
//   }

//   return spans;
// }

// class DelimiterInfo {
//   final String open;
//   final String close;
//   final TextStyle style;

//   DelimiterInfo({
//     required this.open,
//     required this.close,
//     required this.style,
//   });

//   @override
//   bool operator ==(Object other) =>
//       identical(this, other) ||
//       other is DelimiterInfo && open == other.open && close == other.close;

//   @override
//   int get hashCode => open.hashCode ^ close.hashCode;
// }

// class DelimiterStackEntry {
//   final DelimiterInfo delimiter;
//   final int startIndex;
//   final TextStyle? parentStyle;

//   DelimiterStackEntry({
//     required this.delimiter,
//     required this.startIndex,
//     required this.parentStyle,
//   });
// }

const rtlIntervals = [
  Interval(0x0590, 0x05FF), // عبری
  Interval(0x0600, 0x06FF), // عربی
  Interval(0x0750, 0x077F), // مکمل عربی
  Interval(0x0870, 0x089F), // توسعه یافته B عربی
  Interval(0x08A0, 0x08FF), // توسعه یافته A عربی
  Interval(0xFB1D, 0xFB4F), // اشکال ارائه عبری
  Interval(0xFB50, 0xFDFF), // اشکال ارائه A عربی
  Interval(0xFE70, 0xFEFF), // اشکال ارائه B عربی
  Interval(0x10E60, 0x10E7F), // نمادهای عددی رومی
  Interval(0x1EE00, 0x1EEFF), // نمادهای ریاضی عربی
  Interval(0x1EC70, 0x1ECBF), // نمادهای هندی
  Interval(0x1ED00, 0x1ED4F), // نمادهای سریلانکایی
];

class Interval {
  final int start;
  final int end;

  const Interval(this.start, this.end);
}

final _directionCache = <String, TextDirection>{};

TextDirection getDominantTextDirectionFromText(String text) {
  if (text.isEmpty) return TextDirection.ltr;

  return _directionCache.putIfAbsent(
    text,
    () {
      int rtlCount = 0;
      int ltrCount = 0;
      TextDirection? firstStrongDirection;

      final codeUnits = text.runes.iterator;
      while (codeUnits.moveNext()) {
        final codeUnit = codeUnits.current;

        // بررسی RTL با جستجوی دودویی در محدوده‌ها
        bool isRtl = false;
        int low = 0;
        int high = rtlIntervals.length - 1;

        while (low <= high) {
          final mid = (low + high) ~/ 2;
          final interval = rtlIntervals[mid];

          if (codeUnit < interval.start) {
            high = mid - 1;
          } else if (codeUnit > interval.end) {
            low = mid + 1;
          } else {
            isRtl = true;
            break;
          }
        }

        // بررسی LTR با شرایط بهینه شده
        final isLtr = (codeUnit >= 0x0041 && codeUnit <= 0x007A) || // A-Z, a-z
            (codeUnit >= 0x0400 && codeUnit <= 0x04FF) || // سیریلیک
            (codeUnit >= 0x4E00 &&
                codeUnit <= 0x9FFF); // CJK Unified Ideographs

        // آمارگیری
        if (isRtl) rtlCount++;
        if (isLtr) ltrCount++;

        // تشخیص اولیه جهت قوی
        if (firstStrongDirection == null) {
          if (isRtl) {
            firstStrongDirection = TextDirection.rtl;
            break; // خروج زودهنگام طبق استاندارد UBA
          } else if (isLtr) {
            firstStrongDirection = TextDirection.ltr;
            break;
          }
        }
      }

      // اولویت‌بندی طبق استاندارد Unicode
      return firstStrongDirection ??
          (rtlCount > ltrCount ? TextDirection.rtl : TextDirection.ltr);
    },
  );
}
