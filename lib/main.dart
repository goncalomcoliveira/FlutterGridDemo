import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import 'InteractiveGrid.dart';
import 'OptionsBar.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(nSquares: 10),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.nSquares});

  final int nSquares;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {

  ValueNotifier<Offset> onTappedLocation = ValueNotifier(Offset.zero);
  var titleStyle = TextStyle(
    fontSize: 32,
    color: Colors.lightBlue.shade800,
    fontWeight: FontWeight.bold,
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.lightBlue.shade200,
      body: Padding(
        padding: const EdgeInsets.fromLTRB(48.0,64.0,48.0,64.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Card(
              color: Colors.white,
              child: Padding(
                padding: const EdgeInsets.all(48.0),
                child: Center(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Align(
                          alignment: Alignment.centerLeft,
                          child: Text('Editable Grid', style: titleStyle)
                      ),
                      const SizedBox(width: 0, height: 24),
                      InteractiveGrid(onTappedLocation: onTappedLocation, widget: widget),
                      const SizedBox(width: 0, height: 24),
                      GridToolbar(),
                      const SizedBox(width: 0, height: 24),
                      /*
                      Container(
                        width: 128,
                        height: 144,
                        color: Colors.grey.shade300,
                      ),
                       */
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}