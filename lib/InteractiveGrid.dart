import 'package:flutter/material.dart';

import 'main.dart';

class InteractiveGrid extends StatelessWidget {
  const InteractiveGrid({
    super.key,
    required this.onTappedLocation,
    required this.widget,
  });

  final ValueNotifier<Offset> onTappedLocation;
  final MyHomePage widget;

  @override
  Widget build(BuildContext context) {
    return InteractiveViewer(
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
              painter: GridPainter(nSquares: widget.nSquares, onTappedLocation: onTappedLocation, onTap: () {
                print('CLICK');
              })
          ),
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

    //Build selection array
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
        path.addRect(
            Rect.fromPoints(
                Offset((i * spacing), (j * spacing)),
                Offset(((i + 1) * spacing), ((j + 1) * spacing))
            )
        );

        if (onTappedLocation.value != const Offset(0.0, 0.0) && path.contains(onTappedLocation.value)) {
          gridSelections[i][j] = !gridSelections[i][j];
          onTap();
        }

        if (gridSelections[i][j]) {
          canvas.drawPath(path, squaresPaint);
          Path selectedPath = Path();
          selectedPath.addOval(
              Rect.fromCircle(center: Offset((i * spacing) + (spacing / 2), (j * spacing) + (spacing / 2)), radius: spacing / 2)
          );
          canvas.drawPath(selectedPath, squaresPaintSelected);
        }
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