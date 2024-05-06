import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

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
                      InteractiveViewer(
                        panEnabled: false, // Set it to false to prevent panning.
                        boundaryMargin: const EdgeInsets.all(2),
                        minScale: 0.5,
                        maxScale: 4,
                        child: GestureDetector(
                          onTapDown: (details) {
                            onTappedLocation.value = details.localPosition;
                          },
                          child: SizedBox(
                            width: 600,
                            height: 600,
                            child: CustomPaint(
                                size: Size(
                                  MediaQuery.of(context).size.width,
                                  MediaQuery.of(context).size.height,
                                ),
                                painter: GridPainter(nSquares: widget.nSquares, onTappedLocation: onTappedLocation, onTap: (){
                                  print('CLICK');
                                })
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 0, height: 24),
                      Container(
                        width: 128,
                        height: 144,
                        color: Colors.grey.shade300,
                      ),
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

class GridPainter extends CustomPainter {

  int nSquares;
  ValueNotifier<Offset> onTappedLocation;
  VoidCallback onTap;

  late List gridSelections;

  GridPainter({required this.nSquares, required this.onTappedLocation, required this.onTap}):super(repaint: onTappedLocation) {
    int row = nSquares;
    int col = nSquares;

    gridSelections = List<List>.generate(row, (i) => List<dynamic>.generate(col, (index) => false, growable: false), growable: false);
  }

  @override
  void paint(Canvas canvas, Size size) {

    double spacing = size.width / nSquares;

    //Squares' paints
    final squaresPaint = Paint()
      ..color = Colors.white;
    final squaresPaintSelected = Paint()
      ..color = Colors.lightBlue.shade50;

    //Draw Squares
    for (int i = 0; i < nSquares; i++) {
      for (int j = 0; j < nSquares; j++) {
        Path path = Path();
        path.addRect(Rect.fromPoints(
            Offset((i * spacing), (j * spacing)),
            Offset(((i + 1) * spacing), ((j + 1) * spacing))
        ));

        if (path.contains(onTappedLocation.value)) {
          gridSelections[i][j] = !gridSelections[i][j];
          onTap();
        }

        if (gridSelections[i][j]) { canvas.drawPath(path, squaresPaintSelected); }
        else { canvas.drawPath(path, squaresPaint); }
      }
    }

    //Inside lines' paint
    final linePaint = Paint()
      ..style = PaintingStyle.stroke
      ..color = Colors.lightBlue.shade100
      ..strokeWidth = 1;

    //Draw inside Lines
    for (int k = 1; k < nSquares; k++) {
      canvas.drawLine(Offset(spacing * k, 0), Offset(spacing * k, size.height), linePaint);
      canvas.drawLine(Offset(0, spacing * k), Offset(size.width, spacing * k), linePaint);
    }

    //Border lines' paint
    final borderLinePaint = Paint()
      ..style = PaintingStyle.stroke
      ..color = Colors.lightBlue.shade200
      ..strokeCap = StrokeCap.round
      ..strokeWidth = 4;

    //Draw border Lines
    canvas.drawLine(const Offset(0, 0), Offset(0, size.height), borderLinePaint);
    canvas.drawLine(const Offset(0, 0), Offset(size.width, 0), borderLinePaint);
    canvas.drawLine(Offset(spacing * nSquares, 0), Offset(spacing * nSquares, size.height), borderLinePaint);
    canvas.drawLine(Offset(0, spacing * nSquares), Offset(size.width, spacing * nSquares), borderLinePaint);
  }

  @override
  bool shouldRepaint(GridPainter oldDelegate) => false;
  @override
  bool shouldRebuildSemantics(GridPainter oldDelegate) => false;
}