// import 'package:ai_app/constants/colors.dart';
// import 'package:ai_app/constants/data.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_markdown/flutter_markdown.dart';
// import 'package:flutter_highlight/flutter_highlight.dart';
// import 'package:markdown/markdown.dart' as md;

// class MarkdownPakage extends StatefulWidget {
//   const MarkdownPakage({super.key});

//   @override
//   State<MarkdownPakage> createState() => _MarkdownPakageState();
// }

// class _MarkdownPakageState extends State<MarkdownPakage> {
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: SafeArea(
//         child: Markdown(
//           styleSheet: MarkdownStyleSheet(
//             codeblockDecoration: const BoxDecoration(
//               color: Colors.transparent,
//             ),
//           ),
//           data: d6,
//           builders: {
//             'code': CustomInlineBuilder(),
//             'pre': CodeElementBuilder(),
//             'table': CustomTableBuilder(),
//           },
//         ),
//       ),
//     );
//   }
// }

// class CustomTableBuilder extends MarkdownElementBuilder {
//   @override
//   Widget visitElementAfter(md.Element element, TextStyle? preferredStyle) {
//     // Ensure the element is a table
//     if (element.tag == 'table') {
//       final rows = <TableRow>[];

//       // Iterate through the table's children (e.g., rows)
//       for (var row in element.children!) {
//         if (row is md.Element && row.tag == 'tr') {
//           final cells = <Widget>[];

//           // Iterate through the row's children (e.g., cells)
//           for (var cell in row.children!) {
//             if (cell is md.Element && (cell.tag == 'td' || cell.tag == 'th')) {
//               cells.add(
//                 Container(
//                   padding: const EdgeInsets.all(8),
//                   decoration: BoxDecoration(
//                     color: Colors.white,
//                     border: Border.all(color: Colors.grey.shade300, width: 1),
//                     borderRadius: BorderRadius.circular(8), // Rounded corners
//                   ),
//                   child: Text(
//                     cell.textContent, // Extract text content
//                     style: TextStyle(
//                       fontWeight: cell.tag == 'th'
//                           ? FontWeight.bold
//                           : FontWeight.normal,
//                       fontSize: 14,
//                     ),
//                   ),
//                 ),
//               );
//             }
//           }

//           rows.add(TableRow(children: cells));
//         }
//       }

//       return Container(
//         decoration: BoxDecoration(
//           color: Colors.grey.shade100,
//           borderRadius:
//               BorderRadius.circular(12), // Rounded corners for the whole table
//           border: Border.all(color: Colors.grey, width: 1),
//         ),
//         child: Table(
//           border: const TableBorder.symmetric(
//             inside: BorderSide.none,
//             outside: BorderSide.none,
//           ),
//           children: rows,
//         ),
//       );
//     }

//     return const SizedBox.shrink(); // Return an empty widget if not a table
//   }
// }

// // برای پردازش تک بک‌تیک
// class CustomInlineBuilder extends MarkdownElementBuilder {
//   @override
//   Widget? visitElementAfter(md.Element element, TextStyle? preferredStyle) {
//     return Container(
//       padding: const EdgeInsets.symmetric(horizontal: 4),
//       child: Text(
//         element.textContent,
//         style: TextStyle(
//           fontFamily: 'monospace',
//           color: Colors.grey[600],
//         ),
//       ),
//     );
//   }
// }

// class CodeElementBuilder extends MarkdownElementBuilder {
//   @override
//   Widget? visitElementAfter(md.Element element, TextStyle? preferredStyle) {
//     String language = 'plaintext';
//     if (element.children?.isNotEmpty == true) {
//       final codeElement = element.children!.first as md.Element;
//       language =
//           codeElement.attributes['class']?.split('-').last ?? 'plaintext';
//     }

//     final String code = element.textContent.trim();
//     return Container(
//       width: double.infinity,
//       margin: const EdgeInsets.symmetric(vertical: 8),
//       padding: const EdgeInsets.symmetric(horizontal: 10),
//       decoration: BoxDecoration(
//         color: Colors.grey[100],
//         borderRadius: BorderRadius.circular(8),
//       ),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.end,
//         mainAxisAlignment: MainAxisAlignment.start,
//         children: [
//           Row(
//             textDirection: TextDirection.ltr,
//             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//             children: [
//               Text(
//                 language,
//                 style: const TextStyle(
//                   // fontWeight: FontWeight.bold,
//                   color: grey,
//                 ),
//               ),
//               TextButton(
//                 style: TextButton.styleFrom(
//                   padding: EdgeInsets.zero,
//                   minimumSize: const Size(80, 24),
//                   maximumSize: const Size(80, 24),
//                 ),
//                 onPressed: () {},
//                 child: const Text(
//                   'Copy code',
//                   style: TextStyle(
//                     fontSize: 12,
//                     color: grey,
//                   ),
//                 ),
//               ),
//             ],
//           ),
//           Container(
//             width: double.infinity,
//             height: 0.5,
//             decoration: const BoxDecoration(
//               color: lightGrey,
//             ),
//           ),
//           Directionality(
//             textDirection: TextDirection.ltr,
//             child: SingleChildScrollView(
//               scrollDirection: Axis.horizontal,
//               child: HighlightView(
//                 code,
//                 language: language,
//                 theme: theme,
//                 padding: const EdgeInsets.all(10),
//                 textStyle: const TextStyle(
//                   fontFamily: 'monospace',
//                   fontSize: 14,
//                 ),
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }

// const theme = {
//   'root':
//       TextStyle(color: Color(0xff333333), backgroundColor: Colors.transparent),
//   'comment': TextStyle(color: Color(0xFF737373), fontStyle: FontStyle.italic),
//   'quote': TextStyle(color: Color(0xff6a737d), fontStyle: FontStyle.italic),
//   'keyword': TextStyle(color: Color(0xffA924A5), fontWeight: FontWeight.normal),
//   'selector-tag':
//       TextStyle(color: Color(0xffA924A5), fontWeight: FontWeight.normal),
//   'subst': TextStyle(color: Color(0xffE55548), fontWeight: FontWeight.normal),
//   'number': TextStyle(color: Color(0xff976800)),
//   'literal': TextStyle(color: Color(0xff005cc5)),
//   'variable': TextStyle(color: Color(0xff005cc5)),
//   'template-variable': TextStyle(color: Color(0xff005cc5)),
//   'string': TextStyle(color: Color(0xff50A14D)),
//   'doctag': TextStyle(color: Color(0xff032f62)),
//   'title': TextStyle(color: Color(0xff3D77F5), fontWeight: FontWeight.normal),
//   'section': TextStyle(color: Color(0xff3D77F5), fontWeight: FontWeight.normal),
//   'selector-id':
//       TextStyle(color: Color(0xff3D77F5), fontWeight: FontWeight.normal),
//   'type': TextStyle(color: Color(0xff3D77F5), fontWeight: FontWeight.normal),
//   'tag': TextStyle(color: Color(0xff50A14D), fontWeight: FontWeight.normal),
//   'name': TextStyle(color: Color(0xff50A14D), fontWeight: FontWeight.normal),
//   'attribute':
//       TextStyle(color: Color(0xff50A14D), fontWeight: FontWeight.normal),
//   'regexp': TextStyle(color: Color(0xff032f62)),
//   'link': TextStyle(color: Color(0xff032f62)),
//   'symbol': TextStyle(color: Color(0xffe36209)),
//   'bullet': TextStyle(color: Color(0xffe36209)),
//   'built_in': TextStyle(color: Color(0xff005cc5)),
//   'builtin-name': TextStyle(color: Color(0xff005cc5)),
//   'meta': TextStyle(color: Color(0xff6a737d), fontWeight: FontWeight.normal),
//   'deletion': TextStyle(backgroundColor: Color(0xffffeef0)),
//   'addition': TextStyle(backgroundColor: Color(0xffe6ffed)),
//   'emphasis': TextStyle(fontStyle: FontStyle.italic),
//   'strong': TextStyle(fontWeight: FontWeight.normal),
// };
