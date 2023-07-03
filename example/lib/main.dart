import 'package:example/score_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:music_notation/music_notation.dart';
import 'package:xml/xml.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData.from(
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.pink,
          brightness: Brightness.light,
        ),
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  XmlDocument? helloWorldXml;
  XmlDocument? octaveXml;

  @override
  void initState() {
    ExampleScores.helloWorld.read().then((value) {
      if (value != null) {
        setState(() {
          helloWorldXml = value;
        });
      }
    });
    ExampleScores.scale.read().then((value) {
      if (value != null) {
        setState(() {
          octaveXml = value;
        });
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Music notation example"),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Column(
              children: [
                const Text(
                  "Tutorial: Hello, World",
                  style: TextStyle(fontSize: 36),
                ),
                const Padding(padding: EdgeInsets.symmetric(vertical: 32)),
                SizedBox.fromSize(
                  size: const Size.fromHeight(120),
                  child: helloWorldXml != null
                      ? MusicNotationCanvas(
                          scorePartwise: ScorePartwise.fromXml(helloWorldXml!),
                        )
                      : const SizedBox.shrink(),
                ),
              ],
            ),
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children:
                    [ExampleScores.apresUnReve, ExampleScores.chopinPrelude]
                        .map(
                          (score) => Padding(
                            padding: const EdgeInsets.symmetric(vertical: 4.0),
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                fixedSize: const Size(320, 80),
                              ),
                              onPressed: () {
                                Navigator.of(context).push(
                                  MaterialPageRoute(
                                    builder: (context) => const ScorePage(),
                                  ),
                                );
                              },
                              child: Text(score.name),
                            ),
                          ),
                        )
                        .toList(),
              ),
            ),
            Column(
              children: [
                const Text(
                  "Scale",
                  style: TextStyle(fontSize: 36),
                ),
                const Padding(padding: EdgeInsets.symmetric(vertical: 32)),
                SizedBox.fromSize(
                  size: const Size.fromHeight(120),
                  child: octaveXml != null
                      ? MusicNotationCanvas(
                          scorePartwise: ScorePartwise.fromXml(octaveXml!),
                        )
                      : const SizedBox.shrink(),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}

enum ExampleScores {
  helloWorld("assets/scores/hello_world.xml", "Tutorial: Hello world"),
  scale("assets/scores/scale.xml", "Scale"),
  apresUnReve("assets/scores/après_un_rêve.xml", "Tutorial: Après un rêve"),
  chopinPrelude("assets/scores/chopin_prelude.xml", "Tutorial: Chopin Prelude");

  const ExampleScores(this.path, this.name);

  final String path;
  final String name;

  Future<XmlDocument?> read() async {
    try {
      String xmlString = await rootBundle.loadString(path);
      return XmlDocument.parse(xmlString);
    } catch (e) {
      // ignore: avoid_print
      print("$name Error: $e");
      return null;
    }
  }
}
