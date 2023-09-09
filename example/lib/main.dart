import 'package:example/playground.dart';
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
        useMaterial3: true,
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
  bool loading = false;

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
      body: Stack(
        children: [
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Column(
                children: [
                  const Text(
                    "Tutorial: Hello, World",
                    style: TextStyle(fontSize: 36),
                  ),
                  const Padding(padding: EdgeInsets.symmetric(vertical: 32)),
                  if (helloWorldXml != null)
                    MusicNotationCanvas(
                      scorePartwise: ScorePartwise.fromXml(helloWorldXml!),
                  ),
                  if (helloWorldXml == null) const SizedBox.shrink(),
                ],
              ),
              Expanded(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ExampleScores.apresUnReve,
                    ExampleScores.chopinPrelude
                  ]
                      .map(
                        (score) => Padding(
                          padding: const EdgeInsets.symmetric(vertical: 4.0),
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              fixedSize: const Size(320, 80),
                            ),
                            onPressed: () => onPressed(score),
                            child: Text(score.name),
                          ),
                        ),
                      )
                      .toList(),
                ),
              ),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  fixedSize: const Size(320, 80),
                ),
                onPressed: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => const Playground(),
                    ),
                  );
                },
                child: const Text("playground"),
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
          loading
              ? Opacity(
                  opacity: loading ? 0.5 : 0,
                  child: const ModalBarrier(
                    dismissible: false,
                    color: Colors.black,
                  ),
                )
              : const SizedBox.shrink(),
          loading
              ? AnimatedOpacity(
                  opacity: loading ? 1 : 0,
                  duration: const Duration(milliseconds: 250),
                  child: const Center(
                    child: LoadingWidget(),
                  ),
                )
              : const SizedBox.shrink(),
        ],
      ),
    );
  }

  Future<void> onPressed(ExampleScores score) async {
    setState(() {
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

      if (context.mounted) {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => ScorePage(scorePartwise: scorePartwise),
          ),
        );
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
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

class LoadingWidget extends StatelessWidget {
  const LoadingWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SizedBox(
        height: 120,
        width: 120,
        child: CircularProgressIndicator(
          valueColor: AlwaysStoppedAnimation<Color>(
            Theme.of(context).colorScheme.primary,
          ),
          backgroundColor: Colors.white,
          strokeWidth: 8.0,
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
