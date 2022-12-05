
import 'package:flutter/material.dart';
import 'package:svg_test_flutter/widget/bd_map.dart';
import 'package:svg_test_flutter/widget/map_controller.dart';

void main() => runApp(
      MyApp(),
    );

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Clickable Map of Bangladesh',
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  BangladeshMapController _controller = BangladeshMapController();
  @override
  void initState() {
    super.initState();
    _controller.addListener(scheduleRebuild);
  }

  @override
  void dispose() {
    _controller.removeListener(scheduleRebuild);
    super.dispose();
  }

  void scheduleRebuild() => setState(() {});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BangladeshMap(
        context: context,
        mapController: _controller,
        defaultColor: Color(0xff006a4e),
        selectedColor: Color(0xfff42a41),
        textColor: Colors.white,
      ),
    );
  }
}
