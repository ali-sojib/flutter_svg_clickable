import 'package:flutter/material.dart';
import 'package:svg_test_flutter/svg_new_test/parser/parser.dart';
import 'package:touchable/touchable.dart';

import 'paints/path_painter.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  late ScrollController controller;
  final svgPath = "images/ng.svg";
  List<Path> paths = [];
  late Path _selectedPath;
  double heightSvg = 0;
  double widthSvg = 0;

  @override
  void initState() {
    controller = ScrollController();
    parseSvgToPath();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("SVG Interactions")),
      body: Center(
        child: Column(
          children: [
            SizedBox(
              width: double.infinity, // full screen here, you can change size to see different effect
              height: MediaQuery.of(context).size.height * .6,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: CanvasTouchDetector(
                  builder: (context) => CustomPaint(
                    painter: PathPainter(
                      context: context,
                      paths: paths,
                      curPath: _selectedPath,
                      onPressed: (curPath) {
                        controller.animateTo(
                          controller.position.maxScrollExtent * paths.indexOf(curPath) / paths.length,
                          curve: Curves.easeIn,
                          duration: const Duration(milliseconds: 500),
                        );
                        setState(() {
                          _selectedPath = curPath;
                        });
                      },
                      height: heightSvg,
                      width: widthSvg,
                    ),
                  ),
                ),
              ),
            ),
            Expanded(
              child: ListView.separated(
                  controller: controller,
                  shrinkWrap: true,
                  scrollDirection: Axis.horizontal,
                  itemBuilder: (context, index) => GestureDetector(
                        onTap: () => setState(() {
                          _selectedPath = paths[index];
                        }),
                        child: CircleAvatar(
                          child: Text("${index + 1}"),
                          backgroundColor: _selectedPath == paths[index] ? Colors.green : Colors.white,
                        ),
                      ),
                  separatorBuilder: (context, index) => const SizedBox(width: 8),
                  itemCount: paths.length),
            )
          ],
        ),
      ),
    );
  }

  void parseSvgToPath() {
    SvgParser parser = SvgParser();
    parser.loadFromFile(svgPath).then((value) {
      setState(() {
        paths = parser.getPaths();
        heightSvg = parser.svgHeight!;
        widthSvg = parser.svgWidth!;
      });
    });
  }
}
