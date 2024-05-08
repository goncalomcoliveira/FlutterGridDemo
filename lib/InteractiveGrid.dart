import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'InteractiveGridLayout.dart';

//ignore: must_be_immutable
class InteractiveGrid extends StatelessWidget {
  InteractiveGrid({super.key });

  ValueNotifier<Offset> onTappedLocation = ValueNotifier(Offset.zero);

  @override
  Widget build(BuildContext context) {
    var globalState = context.watch<InteractiveGridLayoutState>();

    return InteractiveViewer(
      panEnabled: false,
      boundaryMargin: const EdgeInsets.all(2),
      minScale: 0.5,
      maxScale: 4,
        child: SizedBox(
          width: 600,
          height: 600,
            child: GestureDetector(
              onTapDown: (details) { onTappedLocation.value = details.localPosition;
                print('Tap Down');},
              child: RepaintBoundary(
                child: CustomPaint(
                  size: Size(
                    MediaQuery.of(context).size.width,
                    MediaQuery.of(context).size.height,
                  ),
                  painter: GridPainter(globalState: globalState, onTappedLocation: onTappedLocation)
                          ),
              ),
        ),
      ),
    );
  }
}

class GridPainter extends CustomPainter {

  InteractiveGridLayoutState globalState;
  ValueNotifier<Offset> onTappedLocation;

  late int nSquares;
  late List gridItems;
  late int? selectedX;
  late int? selectedY;

  GridPainter({required this.globalState, required this.onTappedLocation}):super(repaint: onTappedLocation) {
    nSquares = globalState.nSquares;

    int row = nSquares;
    int col = nSquares;

    //Build selection array
    gridItems = List<List>.generate(row, (i) => List<dynamic>.generate(col, (index) => false, growable: false), growable: false);
  }

  @override
  void paint(Canvas canvas, Size size) {

    print("UPDATE PAINT");

    //Square size
    double squareSize = size.width / nSquares;

    final backgroundPaint = Paint()
      ..color = Colors.white;
    final selectedPaint = Paint()
      ..color = Colors.lightBlue.shade200;

    selectedX = null;
    selectedY = null;

    //Draw Squares
    for (int i = 0; i < nSquares; i++) {
      for (int j = 0; j < nSquares; j++) {

        //Create background square path
        Path backgroundSquare = Path();
        backgroundSquare.addRect(
            Rect.fromPoints(
                Offset((i * squareSize), (j * squareSize)),
                Offset(((i + 1) * squareSize), ((j + 1) * squareSize))
            )
        );

        //If Clicked
        if (onTappedLocation.value != const Offset(0.0, 0.0) && backgroundSquare.contains(onTappedLocation.value)) {
          if (!gridItems[i][j] && globalState.gridState == GridState.create) {
            gridItems[i][j] = !gridItems[i][j];
          }
          if (gridItems[i][j] && globalState.gridState == GridState.delete) {
            gridItems[i][j] = !gridItems[i][j];
          }
          selectedX = i;
          selectedY = j;
          //onTap();
        }

        bool isSelected = selectedX == i && selectedY == j;

        //Adapt background square color if selected
        Paint backgroundSquarePaint = Paint();
        if (isSelected && selectedX != null && selectedY != null) {
          backgroundSquarePaint = selectedPaint;
        }
        else {
          backgroundSquarePaint = backgroundPaint;
        }

        //Draw background square path
        canvas.drawPath(backgroundSquare, backgroundSquarePaint);

        //Draw Items
        if (gridItems[i][j]) {

          //Adapt colors if selected
          Paint borderPaint = Paint();
          Paint insidePaint = Paint();
          if (isSelected) {
            borderPaint = backgroundPaint;
            insidePaint = selectedPaint;
          }
          else {
            borderPaint = selectedPaint;
            insidePaint = backgroundPaint;
          }

          Offset center = Offset((i * squareSize) + (squareSize / 2), (j * squareSize) + (squareSize / 2));

          //Draw Item Border circle
          Path borderPath = Path();
          borderPath.addOval(
              Rect.fromCircle(center: center, radius: squareSize / 2)
          );
          canvas.drawPath(borderPath, borderPaint);

          //Draw Item inside circle
          Path insidePath = Path();
          insidePath.addOval(
              Rect.fromCircle(center: center, radius: (squareSize / 2) * 0.66)
          );
          canvas.drawPath(insidePath, insidePaint);

          //Prepare and draw Text
          double textSize = 140 / nSquares;
          TextStyle textStyle = const TextStyle();
          if (isSelected) {
            textStyle = TextStyle(
              color: Colors.white,
              fontSize: textSize,
              fontWeight: FontWeight.bold
            );
          }
          else {
            textStyle = TextStyle(
              color: Colors.black,
              fontSize: textSize,
            );
          }
          TextSpan textSpan = TextSpan(
            text: 'Item',
            style: textStyle,
          );
          final textPainter = TextPainter(
            text: textSpan,
            textDirection: TextDirection.ltr,
            textAlign: TextAlign.center,
          );
          textPainter.layout(
            minWidth: 0,
            maxWidth: squareSize * 0.66,
          );
          Offset centerText = Offset((i * squareSize) + (squareSize / 2) - (textPainter.width / 2), (j * squareSize) + (squareSize / 2) - (textPainter.height / 2));
          final offset = centerText;
          textPainter.paint(canvas, offset);
        }
      }
    }

    //Inside lines' paint
    final linePaint = Paint()
      ..style = PaintingStyle.stroke
      ..color = Colors.lightBlue.shade100
      ..strokeWidth = 1;

    //Draw inside Lines
    for (int k = 1; k < nSquares; k++) {
      canvas.drawLine(Offset(squareSize * k, 0), Offset(squareSize * k, size.height), linePaint);
      canvas.drawLine(Offset(0, squareSize * k), Offset(size.width, squareSize * k), linePaint);
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
    canvas.drawLine(Offset(squareSize * nSquares, 0), Offset(squareSize * nSquares, size.height), borderLinePaint);
    canvas.drawLine(Offset(0, squareSize * nSquares), Offset(size.width, squareSize * nSquares), borderLinePaint);
  }

  @override
  bool shouldRepaint(GridPainter oldDelegate) => false;
  @override
  bool shouldRebuildSemantics(GridPainter oldDelegate) => false;
}