import 'dart:async';
import 'package:markdown_parser/constants/data.dart';
import 'package:markdown_parser/markdown/renderer.dart';
import 'package:markdown_parser/markdown/direction_analysis/direction_analysis.dart';
import 'package:markdown_parser/markdown/merkdown_to_array.dart';
import 'package:flutter/material.dart';

class Content extends StatefulWidget {
  const Content({super.key});

  @override
  State<Content> createState() => _ContentState();
}

class _ContentState extends State<Content> {
  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: SafeArea(
          child: SingleChildScrollView(
        reverse: true,
        padding: EdgeInsets.all(40),
        child: SingleItem(),
      )),
    );
  }
}

class SingleItem extends StatefulWidget {
  const SingleItem({super.key});

  @override
  State<SingleItem> createState() => _SingleItemState();
}

class _SingleItemState extends State<SingleItem> {
  String text = '';
  List<MarkdownElement> displayedElements = [];
  int index = 0;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    text = textData;

    _startTyping();
  }

  void _startTyping() {
    _timer = Timer.periodic(
      const Duration(milliseconds: 10),
      (timer) {
        if (index < text.length) {
          setState(() {
            displayedElements = parseMarkdown(text.substring(0, index));
            index++;
          });
        } else {
          _timer?.cancel();
        }
      },
    );
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  String get textData => d15;

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
    return MarkdownRenderer(
      elements: displayedElements,
      parentDirection: direction,
    );
  }
}
