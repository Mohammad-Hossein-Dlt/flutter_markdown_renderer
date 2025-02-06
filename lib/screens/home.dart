// import 'dart:async';
// import 'dart:convert';
// import 'package:ai_app/constants/colors.dart';
// import 'package:ai_app/constants/data.dart';
// import 'package:ai_app/constants/iconsax_icons.dart';
// import 'package:ai_app/screens/markdown_pakage.dart';
// import 'package:cached_network_image/cached_network_image.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_highlight/flutter_highlight.dart';

// class Home extends StatefulWidget {
//   const Home({super.key});

//   @override
//   State<Home> createState() => _HomeState();
// }

// class _HomeState extends State<Home> {
//   String text = '';
//   String _displayedText = "";
//   int _currentIndex = 0;
//   Timer? _timer;

//   @override
//   void initState() {
//     super.initState();
//     String t = ddd;

//     List<int> utf8Bytes = utf8.encode(t);
//     text = utf8.decode(utf8Bytes);

//     _startTyping();
//   }

//   void _startTyping() {
//     _timer = Timer.periodic(
//       const Duration(milliseconds: 10),
//       (timer) {
//         if (_currentIndex < text.length) {
//           setState(() {
//             _displayedText += text[_currentIndex];
//             _currentIndex++;
//           });
//         } else {
//           _timer?.cancel();
//         }
//       },
//     );
//   }

//   @override
//   void dispose() {
//     _timer?.cancel();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: SafeArea(
//         child: MarkdownParser(markdownData: data2),
//       ),
//     );
//   }
// }

// class MarkdownParser extends StatefulWidget {
//   final String markdownData;

//   const MarkdownParser({super.key, required this.markdownData});

//   @override
//   State<MarkdownParser> createState() => _MarkdownParserState();
// }

// class _MarkdownParserState extends State<MarkdownParser> {
//   @override
//   Widget build(BuildContext context) {
//     final parsedLines = _parseMarkdown(widget.markdownData);
//     final widgets = _buildWidgets(parsedLines);

//     return SingleChildScrollView(
//       padding: const EdgeInsets.symmetric(horizontal: 16.0),
//       child: Column(
//         children: widgets,
//       ),
//     );
//   }

//   List<MarkdownElement> _parseMarkdown(String markdown) {
//     final lines = markdown.split('\n');
//     final elements = <MarkdownElement>[];
//     bool inCodeBlock = false;
//     String codeBuffer = '';
//     String? language;

//     for (var i = 0; i < lines.length; i++) {
//       final line = lines[i];
//       final trimmedLine = line.trim();

//       if (line.startsWith('```')) {
//         if (inCodeBlock) {
//           elements.add(
//             MarkdownElement(
//               type: MarkdownType.codeBlock,
//               content: codeBuffer.trim(),
//               language: language,
//             ),
//           );
//           codeBuffer = '';
//           inCodeBlock = false;
//           language = null;
//         } else {
//           inCodeBlock = true;
//           language = line.substring(3).trim();
//         }
//       } else if (inCodeBlock) {
//         codeBuffer += '$line\n';
//       } else if (line.startsWith('|') &&
//           i + 1 < lines.length &&
//           lines[i + 1].startsWith('|')) {
//         final tableLines = <String>[];
//         while (i < lines.length && lines[i].startsWith('|')) {
//           tableLines.add(lines[i]);
//           i++;
//         }
//         i--;
//         elements.add(MarkdownElement(
//           type: MarkdownType.table,
//           content: tableLines.join('\n'),
//         ));
//       } else {
//         final listMatch = RegExp(r'^(\s*)([-•*]|\d+\.)\s').firstMatch(line);
//         if (listMatch != null) {
//           final indent = listMatch.group(1)!.length;
//           RegExp orderPattern = RegExp(r'\d+\.');
//           final isOrdered = orderPattern.hasMatch(listMatch.group(2)!);
//           Match? findedListNumber = orderPattern.firstMatch(line);
//           String? listNumber;

//           if (findedListNumber != null) {
//             listNumber = findedListNumber.group(0);
//           }

//           elements.add(
//             MarkdownElement(
//               type: isOrdered
//                   ? MarkdownType.orderedListItem
//                   : MarkdownType.unorderedListItem,
//               content: line.trim(),
//               indentLevel: indent ~/ 2,
//               listNumber: listNumber,
//             ),
//           );
//         } else if (trimmedLine.startsWith('# ')) {
//           elements.add(MarkdownElement(
//             type: MarkdownType.header1,
//             content: trimmedLine.substring(2).trim(),
//           ));
//         } else if (trimmedLine.startsWith('## ')) {
//           elements.add(MarkdownElement(
//             type: MarkdownType.header2,
//             content: trimmedLine.substring(3).trim(),
//           ));
//         } else if (trimmedLine.startsWith('### ')) {
//           elements.add(MarkdownElement(
//             type: MarkdownType.header3,
//             content: trimmedLine.substring(4).trim(),
//           ));
//         } else if (trimmedLine.startsWith('>')) {
//           // شمارش تعداد سطح‌های تو رفتگی
//           int level = 0;
//           String remaining = line;

//           // پردازش تمام '>'های ابتدای خط (با فاصله یا بدون فاصله)
//           while (remaining.startsWith('>')) {
//             level++;
//             remaining = remaining.substring(1).trimLeft();

//             // پردازش فضاهای خالی پس از '>' برای تو رفتگی بیشتر
//             while (remaining.startsWith(' ')) {
//               remaining = remaining.substring(1);
//             }
//           }

//           elements.add(MarkdownElement(
//             type: MarkdownType.blockquote,
//             content: remaining.trim(),
//             indentLevel: level - 1, // سطح تو رفتگی از ۰ شروع می‌شود
//           ));
//         } else if (RegExp(r'^ *-{3,} *$').hasMatch(trimmedLine)) {
//           elements.add(MarkdownElement(
//             type: MarkdownType.horizontalRule,
//             content: '',
//           ));
//         } else if (trimmedLine.isEmpty) {
//           elements.add(MarkdownElement(
//             type: MarkdownType.emptyLine,
//             content: '',
//           ));
//         } else {
//           elements.add(MarkdownElement(
//             type: MarkdownType.paragraph,
//             content: trimmedLine,
//           ));
//         }
//       }
//     }

//     if (inCodeBlock) {
//       elements.add(
//         MarkdownElement(
//           type: MarkdownType.codeBlock,
//           content: codeBuffer.trim(),
//           language: language,
//         ),
//       );
//       codeBuffer = '';
//       inCodeBlock = false;
//       language = null;
//     }

//     return elements;
//   }

//   List<Widget> _buildWidgets(List<MarkdownElement> elements) {
//     final widgets = <Widget>[];
//     for (var element in elements) {
//       switch (element.type) {
//         case MarkdownType.header1:
//           widgets.add(
//             Align(
//               alignment: getAlignmentFromText(element.content),
//               child: _buildHeader(element.content, 32),
//             ),
//           );
//           break;
//         case MarkdownType.header2:
//           widgets.add(
//             Align(
//               alignment: getAlignmentFromText(element.content),
//               child: _buildHeader(element.content, 24),
//             ),
//           );
//           break;
//         case MarkdownType.header3:
//           widgets.add(
//             Align(
//               alignment: getAlignmentFromText(element.content),
//               child: _buildHeader(element.content, 20),
//             ),
//           );
//           break;
//         case MarkdownType.paragraph:
//           widgets.add(
//             Align(
//               alignment: getAlignmentFromText(element.content),
//               child: _buildParagraph(element.content),
//             ),
//           );
//           break;
//         case MarkdownType.unorderedListItem:
//           widgets.add(
//             Align(
//               alignment: getAlignmentFromText(element.content),
//               child: _buildListItem(element),
//             ),
//           );
//           break;
//         case MarkdownType.orderedListItem:
//           widgets.add(
//             Align(
//               alignment: getAlignmentFromText(element.content),
//               child: _buildListItem(element),
//             ),
//           );
//           break;

//         case MarkdownType.blockquote:
//           widgets.add(
//             Align(
//               alignment: getAlignmentFromText(element.content),
//               child: _buildBlockquote(element.content),
//             ),
//           );
//           break;
//         case MarkdownType.codeBlock:
//           widgets.add(
//             _buildCodeBlock(element.content, element.language),
//           );
//           break;
//         case MarkdownType.table:
//           widgets.add(
//             _buildTable(element.content),
//           );
//           break;

//         case MarkdownType.horizontalRule:
//           widgets.add(
//             horizontalRule(),
//           );
//           break;
//         case MarkdownType.emptyLine:
//           widgets.add(
//             const SizedBox(height: 8),
//           );
//           break;
//       }
//     }

//     return widgets;
//   }

//   Widget _buildListItem(MarkdownElement element) {
//     String content =
//         element.content.replaceFirst(RegExp(r'^(\s*)([-•*]|\d+\.)\s'), '');

//     TextDirection dominantTextDirection =
//         getDominantTextDirectionFromText(element.content);
//     bool isRTL = dominantTextDirection == TextDirection.rtl;

//     final indicator = element.type == MarkdownType.orderedListItem
//         ? '${element.listNumber} '
//         : '• ';

//     EdgeInsetsDirectional edgeInsetsDirectional = EdgeInsetsDirectional.only(
//       start: !isRTL ? 30.0 * element.indentLevel : 0,
//       end: isRTL ? 30.0 * element.indentLevel : 0,
//       top: 4,
//       bottom: 4,
//     );

//     if (isRTL) {
//       edgeInsetsDirectional = EdgeInsetsDirectional.only(
//         start: isRTL ? 30.0 * element.indentLevel : 0,
//         end: !isRTL ? 30.0 * element.indentLevel : 0,
//         top: 4,
//         bottom: 4,
//       );
//     }

//     return Padding(
//       padding: edgeInsetsDirectional,
//       child: IntrinsicHeight(
//         child: Row(
//           crossAxisAlignment: CrossAxisAlignment.baseline,
//           textBaseline: TextBaseline.alphabetic,
//           children: [
//             Text(
//               indicator,
//               style: const TextStyle(
//                 fontSize: 16,
//                 color: grey,
//                 height: 1.6,
//               ),
//             ),
//             const SizedBox(width: 4),
//             Expanded(
//               child: _buildFormattedText(
//                 content,
//                 direction: dominantTextDirection,
//                 baseStyle: const TextStyle(height: 1.6, fontSize: 16),
//                 textAlign: TextAlign.left,
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   List<InlineSpan> _buildTextSpans(String text, {TextStyle? baseStyle}) {
//     final spans = <InlineSpan>[];
//     final regex = RegExp(
//       r'(\*\*\*([^\n]*?)\*\*\*|\*\*([^\n]*?)\*\*|\*([^\n]*?)\*|_([^\n]*?)_|~~([^\n]*?)~~|`([^\n]*?)`|!\[([^\n]*?)\]\(([^\n]*?)\)|\[([^\n]*?)\]\(([^\n]*?)\)|~([^\n]*?)~)',
//       multiLine: true,
//       dotAll: true,
//     );

//     final matches = regex.allMatches(text);
//     int lastMatchEnd = 0;

//     void addPlainText(int start, int end) {
//       if (start < end) {
//         spans.add(
//           TextSpan(
//             text: text.substring(start, end),
//             style: baseStyle,
//           ),
//         );
//       }
//     }

//     for (final match in matches) {
//       addPlainText(lastMatchEnd, match.start);
//       final matchText = match.group(0) ?? '';

//       TextStyle? newStyle;
//       String? content;

//       if (matchText.startsWith('***')) {
//         content = match.group(2) ?? '';
//         final isBold = baseStyle?.fontWeight == FontWeight.bold;
//         final isItalic = baseStyle?.fontStyle == FontStyle.italic;
//         newStyle = TextStyle(
//           fontWeight: isBold ? null : FontWeight.bold,
//           fontStyle: isItalic ? null : FontStyle.italic,
//         ).merge(baseStyle);
//       } else if (matchText.startsWith('**')) {
//         content = match.group(3) ?? '';
//         final isBold = baseStyle?.fontWeight == FontWeight.bold;
//         newStyle = TextStyle(
//           fontWeight: isBold ? null : FontWeight.bold,
//         ).merge(baseStyle);
//       } else if (matchText.startsWith('*')) {
//         content = match.group(4) ?? '';
//         final isItalic = baseStyle?.fontStyle == FontStyle.italic;
//         newStyle = TextStyle(
//           fontStyle: isItalic ? null : FontStyle.italic,
//         ).merge(baseStyle);
//       } else if (matchText.startsWith('_')) {
//         content = match.group(5) ?? '';
//         final isItalic = baseStyle?.fontStyle == FontStyle.italic;
//         newStyle = TextStyle(
//           fontStyle: isItalic ? null : FontStyle.italic,
//         ).merge(baseStyle);
//       } else if (matchText.startsWith('~~')) {
//         content = match.group(6) ?? '';
//         final hasStrikethrough =
//             baseStyle?.decoration?.contains(TextDecoration.lineThrough) ??
//                 false;
//         newStyle = TextStyle(
//           decoration: hasStrikethrough ? null : TextDecoration.lineThrough,
//           decorationColor: hasStrikethrough ? null : black,
//         ).merge(baseStyle);
//       } else if (matchText.startsWith('`')) {
//         content = match.group(7) ?? '';
//         final isMonospace = baseStyle?.fontFamily == 'monospace';
//         newStyle = TextStyle(
//           fontFamily: isMonospace ? null : 'monospace',
//           height: isMonospace ? null : 1.4,
//           color: Colors.grey[600],
//         ).merge(baseStyle);
//       } else if (matchText.startsWith('![')) {
//         final altText = match.group(8);
//         final imageUrl = match.group(9);
//         if (imageUrl != null) {
//           spans.add(
//             WidgetSpan(
//               baseline: TextBaseline.alphabetic,
//               alignment: PlaceholderAlignment.middle,
//               child: CachedNetworkImage(
//                 imageUrl: imageUrl.substring(5, imageUrl.length - 1),
//                 imageBuilder: (context, imageProvider) {
//                   return SizedBox(
//                     width: 200,
//                     height: 200,
//                     child: ClipRRect(
//                       borderRadius: BorderRadius.circular(20),
//                       child: Image(
//                         image: imageProvider,
//                         fit: BoxFit.cover,
//                       ),
//                     ),
//                   );
//                 },
//                 placeholder: (context, url) {
//                   return const SizedBox(
//                     width: 20,
//                     height: 20,
//                     child: CircularProgressIndicator(
//                       color: grey,
//                       strokeWidth: 2,
//                     ),
//                   );
//                 },
//                 errorWidget: (context, error, stackTrace) =>
//                     Text(altText ?? 'Image Error'),
//               ),
//             ),
//           );
//         }
//         lastMatchEnd = match.end;

//         continue;
//       } else if (matchText.startsWith('[')) {
//         final linkText = match.group(10);
//         final url = match.group(11);
//         if (url != null) {
//           spans.add(
//             WidgetSpan(
//               baseline: TextBaseline.alphabetic,
//               alignment: PlaceholderAlignment.middle,
//               child: InkWell(
//                 borderRadius: BorderRadius.circular(4),
//                 onTap: () {
//                   print(url);
//                 },
//                 child: RichText(
//                   text: TextSpan(
//                     style: const TextStyle(
//                       color: Colors.blue,
//                       decoration: TextDecoration.underline,
//                     ).merge(baseStyle),
//                     children:
//                         _buildTextSpans(linkText ?? url, baseStyle: baseStyle),
//                   ),
//                 ),
//               ),
//             ),
//           );
//         }
//         lastMatchEnd = match.end;

//         continue;
//       } else if (matchText.startsWith('~')) {
//         content = match.group(12)!;
//         final hasUnderline =
//             baseStyle?.decoration?.contains(TextDecoration.underline) ?? false;
//         newStyle = TextStyle(
//           decoration: hasUnderline ? null : TextDecoration.underline,
//           decorationColor: hasUnderline ? null : black,
//         ).merge(baseStyle);
//       }

//       if (newStyle != null && content != null) {
//         spans.add(
//           TextSpan(
//             style: newStyle,
//             children: _buildTextSpans(content, baseStyle: newStyle),
//           ),
//         );
//       } else {
//         addPlainText(match.start, match.end);
//       }

//       lastMatchEnd = match.end;
//     }

//     addPlainText(lastMatchEnd, text.length);
//     return spans;
//   }

//   Widget _buildFormattedText(
//     String text, {
//     TextDirection? direction,
//     TextStyle? baseStyle,
//     TextAlign? textAlign,
//   }) {
//     final textDirection = direction ?? getDominantTextDirectionFromText(text);

//     return RichText(
//       textAlign: textAlign ?? TextAlign.start,
//       textDirection: textDirection,
//       text: TextSpan(
//         style: const TextStyle(
//           fontFamily: 'Shabnam',
//           fontSize: 16,
//           color: Colors.black,
//           height: 1.4,
//         ).merge(baseStyle),
//         children: _buildTextSpans(
//           text,
//         ),
//       ),
//     );
//   }

//   Widget _buildHeader(String text, double fontSize) {
//     return Padding(
//       padding: const EdgeInsets.symmetric(vertical: 8),
//       child: _buildFormattedText(
//         text,
//         baseStyle: TextStyle(
//           fontSize: fontSize,
//           fontWeight: FontWeight.bold,
//           height: 1.4,
//         ),
//       ),
//     );
//   }

//   Widget _buildParagraph(String text) {
//     return Padding(
//       padding: const EdgeInsets.symmetric(vertical: 4),
//       child: _buildFormattedText(text),
//     );
//   }

//   Widget _buildBlockquote(String text) {
//     return IntrinsicHeight(
//       child: Row(
//         children: [
//           Container(
//             width: 4,
//             height: double.infinity,
//             decoration: BoxDecoration(
//               color: lightGrey,
//               borderRadius: BorderRadius.circular(10),
//             ),
//           ),
//           const SizedBox(width: 10),
//           Padding(
//             padding: const EdgeInsets.symmetric(vertical: 4),
//             child: _buildFormattedText(text),
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _buildCodeBlock(String code, String? language) {
//     return Container(
//       width: double.infinity,
//       padding: const EdgeInsets.symmetric(horizontal: 8.0),
//       decoration: BoxDecoration(
//         color: Colors.grey[100],
//         borderRadius: BorderRadius.circular(8.0),
//       ),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Padding(
//             padding: const EdgeInsets.symmetric(horizontal: 4),
//             child: Row(
//               textDirection: TextDirection.ltr,
//               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//               children: [
//                 Text(
//                   language == null || language.isEmpty ? 'plaintext' : language,
//                   style: const TextStyle(
//                     color: grey,
//                   ),
//                 ),
//                 TextButton(
//                   style: TextButton.styleFrom(
//                     padding: EdgeInsets.zero,
//                     minimumSize: const Size(90, 30),
//                     maximumSize: const Size(90, 30),
//                     fixedSize: const Size(90, 30),
//                     overlayColor: black,
//                     shape: RoundedRectangleBorder(
//                       borderRadius: BorderRadius.circular(10),
//                     ),
//                   ),
//                   onPressed: () {},
//                   child: const Row(
//                     mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//                     children: [
//                       Icon(
//                         Iconsax.copy,
//                         size: 20,
//                         color: grey,
//                       ),
//                       Text(
//                         'Copy code',
//                         style: TextStyle(
//                           fontSize: 12,
//                           color: grey,
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),
//               ],
//             ),
//           ),
//           Container(
//             width: double.infinity,
//             height: 0.5,
//             decoration: const BoxDecoration(
//               color: lightGrey,
//             ),
//           ),
//           SingleChildScrollView(
//             scrollDirection: Axis.horizontal,
//             child: HighlightView(
//               code,
//               language: language == null || language.isEmpty
//                   ? 'plaintext'
//                   : language, // زبان کدنویسی (پیش‌فرض: ساده)
//               theme: theme, // تم برجسته‌سازی
//               padding: const EdgeInsets.all(8.0),
//               textStyle: const TextStyle(
//                 fontFamily: 'monospace',
//                 fontSize: 14.0,
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _buildTable(String tableContent) {
//     final rows = tableContent.split('\n');
//     final headers = rows.first
//         .split('|')
//         .map((e) => e.trim())
//         .where((e) => e.isNotEmpty)
//         .toList();

//     final headerCount = headers.length;

//     final dataRows = rows.skip(2).map((row) {
//       var cells = row
//           .split('|')
//           .map((e) => e.trim())
//           .where((e) => e.isNotEmpty)
//           .toList();

//       // نرمالایز کردن طول سطرها
//       if (cells.length < headerCount) {
//         // پر کردن سلول‌های خالی برای سطرهای کوتاه‌تر
//         cells.addAll(List.filled(headerCount - cells.length, ''));
//       } else if (cells.length > headerCount) {
//         // قطع کردن سطرهای بلندتر
//         cells = cells.sublist(0, headerCount);
//       }

//       return cells;
//     }).toList();

//     return Align(
//       alignment: Alignment.center,
//       child: Directionality(
//         textDirection: getDominantTextDirectionFromText(tableContent),
//         child: SingleChildScrollView(
//           scrollDirection: Axis.horizontal,
//           child: Container(
//             margin: const EdgeInsets.symmetric(vertical: 8),
//             decoration: BoxDecoration(
//               border: Border.all(color: lightGrey),
//               borderRadius: BorderRadius.circular(8),
//             ),
//             child: Table(
//               defaultColumnWidth: const IntrinsicColumnWidth(),
//               border: const TableBorder.symmetric(
//                 inside: BorderSide(color: lightGrey),
//               ),
//               children: [
//                 TableRow(
//                   decoration: BoxDecoration(
//                     color: Colors.grey[100],
//                     borderRadius: const BorderRadius.only(
//                       topLeft: Radius.circular(8),
//                       topRight: Radius.circular(8),
//                     ),
//                   ),
//                   children: headers
//                       .map((header) => Padding(
//                             padding: const EdgeInsets.all(12),
//                             child: Text(
//                               header,
//                               textAlign: TextAlign.center,
//                               style:
//                                   const TextStyle(fontWeight: FontWeight.bold),
//                             ),
//                           ))
//                       .toList(),
//                 ),
//                 ...dataRows.map(
//                   (row) => TableRow(
//                     children: row
//                         .map(
//                           (cell) => Padding(
//                             padding: const EdgeInsets.all(12),
//                             child: _buildFormattedText(
//                               cell,
//                               textAlign: TextAlign.center,
//                             ),
//                           ),
//                         )
//                         .toList(),
//                   ),
//                 ),
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }

//   Widget horizontalRule() {
//     return const Divider(
//       height: 1,
//       thickness: 1,
//       color: lightGrey,
//     );
//   }
// }

// enum MarkdownType {
//   header1,
//   header2,
//   header3,
//   paragraph,
//   unorderedListItem,
//   orderedListItem,
//   blockquote,
//   codeBlock,
//   table,
//   horizontalRule,
//   emptyLine,
// }

// class MarkdownElement {
//   final MarkdownType type;
//   String content;
//   final String? language;
//   final int indentLevel;
//   final String? listNumber;
//   final List<MarkdownElement> children;

//   MarkdownElement({
//     required this.type,
//     required this.content,
//     this.language,
//     this.indentLevel = 0,
//     this.listNumber,
//     this.children = const [],
//   });
// }

// // پیش‌محاسبه محدوده‌های RTL به صورت ایستا
// const rtlIntervals = [
//   Interval(0x0590, 0x05FF), // عبری
//   Interval(0x0600, 0x06FF), // عربی
//   Interval(0x0750, 0x077F), // مکمل عربی
//   Interval(0x0870, 0x089F), // توسعه یافته B عربی
//   Interval(0x08A0, 0x08FF), // توسعه یافته A عربی
//   Interval(0xFB1D, 0xFB4F), // اشکال ارائه عبری
//   Interval(0xFB50, 0xFDFF), // اشکال ارائه A عربی
//   Interval(0xFE70, 0xFEFF), // اشکال ارائه B عربی
//   Interval(0x10E60, 0x10E7F), // نمادهای عددی رومی
//   Interval(0x1EE00, 0x1EEFF), // نمادهای ریاضی عربی
//   Interval(0x1EC70, 0x1ECBF), // نمادهای هندی
//   Interval(0x1ED00, 0x1ED4F), // نمادهای سریلانکایی
// ];

// class Interval {
//   final int start;
//   final int end;

//   const Interval(this.start, this.end);
// }

// // کش جهت متن برای متن‌های تکراری
// final _directionCache = <String, TextDirection>{};

// // TextDirection getDominantTextDirectionFromText(String text) {
// //   if (text.isEmpty) return TextDirection.ltr;

// //   return _directionCache.putIfAbsent(
// //     text,
// //     () {
// //       int rtlCount = 0;
// //       int ltrCount = 0;

// //       final codeUnits = text.runes.iterator;
// //       while (codeUnits.moveNext()) {
// //         final codeUnit = codeUnits.current;

// //         // بررسی RTL با جستجوی دودویی در محدوده‌ها
// //         bool isRtl = false;
// //         int low = 0;
// //         int high = rtlIntervals.length - 1;

// //         while (low <= high) {
// //           final mid = (low + high) ~/ 2;
// //           final interval = rtlIntervals[mid];

// //           if (codeUnit < interval.start) {
// //             high = mid - 1;
// //           } else if (codeUnit > interval.end) {
// //             low = mid + 1;
// //           } else {
// //             isRtl = true;
// //             break;
// //           }
// //         }

// //         // بررسی LTR با شرایط بهینه شده
// //         final isLtr = (codeUnit >= 0x0041 && codeUnit <= 0x007A) || // A-Z, a-z
// //             (codeUnit >= 0x0400 && codeUnit <= 0x04FF) || // سیریلیک
// //             (codeUnit >= 0x4E00 &&
// //                 codeUnit <= 0x9FFF); // CJK Unified Ideographs

// //         // آمارگیری
// //         if (isRtl) rtlCount++;
// //         if (isLtr) ltrCount++;
// //       }

// //       // اولویت‌بندی طبق استاندارد Unicode
// //       return (rtlCount > ltrCount ? TextDirection.rtl : TextDirection.ltr);
// //     },
// //   );
// // }

// CrossAxisAlignment getCrossAxisAlignmentFromText(String text) {
//   final textDirection = getDominantTextDirectionFromText(text);
//   return textDirection == TextDirection.rtl
//       ? CrossAxisAlignment.end
//       : CrossAxisAlignment.start;
// }

// Alignment getAlignmentFromText(String text) {
//   final textDirection = getDominantTextDirectionFromText(text);
//   return textDirection == TextDirection.rtl
//       ? Alignment.centerRight
//       : Alignment.centerLeft;
// }

// TextDirection getDominantTextDirectionFromText(String text) {
//   if (text.isEmpty) return TextDirection.ltr;

//   return _directionCache.putIfAbsent(
//     text,
//     () {
//       int rtlCount = 0;
//       int ltrCount = 0;
//       TextDirection? firstStrongDirection;

//       final codeUnits = text.runes.iterator;
//       while (codeUnits.moveNext()) {
//         final codeUnit = codeUnits.current;

//         // بررسی RTL با جستجوی دودویی در محدوده‌ها
//         bool isRtl = false;
//         int low = 0;
//         int high = rtlIntervals.length - 1;

//         while (low <= high) {
//           final mid = (low + high) ~/ 2;
//           final interval = rtlIntervals[mid];

//           if (codeUnit < interval.start) {
//             high = mid - 1;
//           } else if (codeUnit > interval.end) {
//             low = mid + 1;
//           } else {
//             isRtl = true;
//             break;
//           }
//         }

//         // بررسی LTR با شرایط بهینه شده
//         final isLtr = (codeUnit >= 0x0041 && codeUnit <= 0x007A) || // A-Z, a-z
//             (codeUnit >= 0x0400 && codeUnit <= 0x04FF) || // سیریلیک
//             (codeUnit >= 0x4E00 &&
//                 codeUnit <= 0x9FFF); // CJK Unified Ideographs

//         // آمارگیری
//         if (isRtl) rtlCount++;
//         if (isLtr) ltrCount++;

//         // تشخیص اولیه جهت قوی
//         if (firstStrongDirection == null) {
//           if (isRtl) {
//             firstStrongDirection = TextDirection.rtl;
//             break; // خروج زودهنگام طبق استاندارد UBA
//           } else if (isLtr) {
//             firstStrongDirection = TextDirection.ltr;
//             break;
//           }
//         }
//       }

//       // اولویت‌بندی طبق استاندارد Unicode
//       return firstStrongDirection ??
//           (rtlCount > ltrCount ? TextDirection.rtl : TextDirection.ltr);
//     },
//   );
// }

import 'package:markdown/markdown.dart' as md;

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
  // MarkdownElement.resetIdCounter();

  final document = md.Document(
    extensionSet: md.ExtensionSet.gitHubWeb,
    blockSyntaxes: [
      ...md.ExtensionSet.gitHubFlavored.blockSyntaxes,
    ],
    inlineSyntaxes: [
      ...md.ExtensionSet.gitHubFlavored.inlineSyntaxes,
      md.LineBreakSyntax(),
      md.InlineHtmlSyntax(),
    ],
  );

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
    default:
      return _processElement(
        element,
        parentIndent: indentLevel,
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
