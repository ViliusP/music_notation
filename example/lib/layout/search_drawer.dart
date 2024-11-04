import 'dart:async';
import 'dart:convert';

import 'package:collection/collection.dart';
import 'package:example/examples/notation_examples.dart';
import 'package:example/main.dart';
import 'package:example/score_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fuzzywuzzy/fuzzywuzzy.dart';
import 'package:fuzzywuzzy/model/extracted_result.dart';
import 'package:music_notation/music_notation.dart';
import 'package:xml/xml.dart';

class SearchDrawer extends StatefulWidget {
  const SearchDrawer({super.key});

  @override
  State<SearchDrawer> createState() => _SearchDrawerState();
}

class _SearchDrawerState extends State<SearchDrawer> {
  TextEditingController editingController = TextEditingController();

  bool loading = false;
  Timer? _checkTypingTimer;
  int? selectedIndex;

  FontMetadata? font;
  static const _fontPath =
      'packages/music_notation/smufl_fonts/Leland/leland_metadata.json';

  final List<ExtractedResult<NotationExample>> _defaultSearchResults =
      NotationExample.values
          .mapIndexed((i, e) =>
              ExtractedResult<NotationExample>(e, 100, i, (x) => x.displayName))
          .toList();

  List<ExtractedResult<NotationExample>> searchResults = [];

  @override
  void initState() {
    searchResults = _defaultSearchResults;

    rootBundle.loadString(_fontPath).then((x) {
      font = FontMetadata.fromJson(jsonDecode(x));
      setState(() {});
    });

    super.initState();
  }

  void filterSearchResults(String query) {
    setState(() {
      if (query.isEmpty) {
        searchResults = _defaultSearchResults;
        return;
      }

      searchResults = extractTop<NotationExample>(
        query: query,
        choices: NotationExample.values,
        limit: 10,
        cutoff: 60,
        getter: (x) => x.displayName,
      );
    });
  }

  void _startTimer() {
    _checkTypingTimer = Timer(const Duration(milliseconds: 350), () {
      filterSearchResults(editingController.text);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.symmetric(
              vertical: 16.0,
              horizontal: 16.0,
            ),
            child: TextField(
              onSubmitted: (value) {
                filterSearchResults(value);
                _checkTypingTimer?.cancel();
              },
              controller: editingController,
              onChanged: (_) {
                _checkTypingTimer?.cancel();
                _startTimer();
              },
              decoration: InputDecoration(
                  labelText: "Search",
                  hintText: "Search",
                  prefixIcon: Icon(Icons.search),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(25.0)),
                  )),
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8),
              child: ListView.builder(
                shrinkWrap: true,
                itemCount: searchResults.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    selectedTileColor: Theme.of(context)
                        .colorScheme
                        .inversePrimary
                        .withOpacity(.40),
                    selected: searchResults[index].index == selectedIndex,
                    onTap: () => onListTileTap(searchResults[index].index),
                    title: Text(NotationExample
                        .values[searchResults[index].index].displayName),
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future onListTileTap(int index) async {
    NotationExample score = NotationExample.values[index];

    setState(() {
      selectedIndex = index;
      loading = true;
    });
    XmlDocument? document = await score.read();
    if (document == null) {
      return;
    }
    try {
      final ScorePartwise scorePartwise = ScorePartwise.fromXml(
        document,
      );

      if (mounted) {
        Navigator.of(MyApp.navigatorKey.currentContext!).push(
          PageRouteBuilder(
            pageBuilder: (_, __, ___) => ScorePage(
              fontMetadata: font,
              scorePartwise: scorePartwise,
              description: score.description,
            ),
            transitionDuration: Duration(milliseconds: 0),
            transitionsBuilder: (_, a, __, c) => FadeTransition(
              key: ValueKey(score.displayName),
              opacity: a,
              child: c,
            ),
          ),
        );
      }
    } catch (e) {
      selectedIndex = null;
      if (mounted) {
        ScaffoldMessenger.of(MyApp.navigatorKey.currentContext!).showSnackBar(
          SnackBar(content: Text(e.toString())),
        );
      }
    } finally {
      setState(() {
        loading = false;
      });
    }
  }
}
