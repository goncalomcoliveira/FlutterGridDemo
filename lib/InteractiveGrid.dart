import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'dart:math' as math;


import 'InteractiveGridLayout.dart';

//ignore: must_be_immutable
class InteractiveGrid extends StatelessWidget {
  InteractiveGrid({super.key });

  ValueNotifier<Offset> onTappedLocation = ValueNotifier(Offset.zero);

  @override
  Widget build(BuildContext context) {
    var globalState = context.watch<InteractiveGridLayoutState>();

    print('Build InteractiveGrid');

    return Container(
      width: 600,
      height: 600,
      decoration: BoxDecoration(
        color: Colors.lightBlue.shade200,
        border: Border.all(
          width: 4,
          color: Colors.lightBlue.shade200,
        ),
      ),
      child: InteractiveViewer(
        panEnabled: false,
        boundaryMargin: const EdgeInsets.all(2),
        minScale: 0.8,
        maxScale: 4,
          child: SizedBox(
              child: GestureDetector(
                onTapDown: (details) { onTappedLocation.value = details.localPosition;
                  //print('Tap Down');
                },
                child: RepaintBoundary(
                  child: Stack(
                    children: [
                      CustomPaint(
                          size: Size(
                            MediaQuery.of(context).size.width,
                            MediaQuery.of(context).size.height,
                          ),
                          painter: GridPainter(globalState: globalState)
                      ),
                      CustomPaint(
                          size: Size(
                            MediaQuery.of(context).size.width,
                            MediaQuery.of(context).size.height,
                          ),
                          painter: ItemsPainter(globalState: globalState, onTappedLocation: onTappedLocation)
                      ),
                    ],
                  ),
                ),
          ),
        ),
      ),
    );
  }
}



class GridPainter extends CustomPainter {

  InteractiveGridLayoutState globalState;

  GridPainter({required this.globalState});

  @override
  void paint(Canvas canvas, Size size) {

    //Square size
    double squareSize = size.width / globalState.nSquares;

    //Backround paint
    final backroundPaint = Paint()
      ..color = Colors.white;

    //Draw Background
    canvas.drawRect(Rect.fromLTRB(0, 0, size.width, size.height), backroundPaint);

    //Inside lines' paint
    final linePaint = Paint()
      ..style = PaintingStyle.stroke
      ..color = Colors.lightBlue.shade100
      ..strokeWidth = 1;

    //Draw inside Lines
    for (int k = 1; k < globalState.nSquares; k++) {
      canvas.drawLine(Offset(squareSize * k, 0), Offset(squareSize * k, size.height), linePaint);
      canvas.drawLine(Offset(0, squareSize * k), Offset(size.width, squareSize * k), linePaint);
    }
  }

  @override
  bool shouldRepaint(GridPainter oldDelegate) => false;
  @override
  bool shouldRebuildSemantics(GridPainter oldDelegate) => false;
}

class ItemsPainter extends CustomPainter {

  InteractiveGridLayoutState globalState;
  ValueNotifier<Offset> onTappedLocation;

  ItemsPainter({required this.globalState, required this.onTappedLocation}):super(repaint: onTappedLocation);

  @override
  void paint(Canvas canvas, Size size) {

    //print("UPDATE PAINT");

    //Square size
    double squareSize = size.width / globalState.nSquares;

    final selectedPaint = Paint()
      ..color = Colors.lightBlue.shade200;

    globalState.selectedX = null;
    globalState.selectedY = null;

    //Draw Squares
    for (int i = 0; i < globalState.nSquares; i++) {
      for (int j = 0; j < globalState.nSquares; j++) {

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
          if (globalState.gridState == GridState.create && globalState.gridItems[i][j] != globalState.gridShape) {
            globalState.gridItems[i][j] = globalState.gridShape;
          }
          if (globalState.gridState == GridState.delete && globalState.gridItems[i][j] != null) {
            globalState.gridItems[i][j] = null;
          }
          globalState.selectedX = i;
          globalState.selectedY = j;
          //onTap();
        }

        bool isSelected = globalState.selectedX == i && globalState.selectedY == j;

        //Draw background square path if selected
        if (isSelected && globalState.selectedX != null && globalState.selectedY != null) {
          canvas.drawPath(backgroundSquare, selectedPaint);
        }

        //Draw Items
        if (globalState.gridItems[i][j] != null) {

          print(globalState.gridItems[i][j]);

          Offset center = Offset((i * squareSize) + (squareSize / 2), (j * squareSize) + (squareSize / 2));

          var strokeWidth = 8.0;
          Color itemColor = Colors.lightBlue.shade200;
          if (isSelected) {
            itemColor = Colors.white;
          }

          final borderPaint = Paint()
            ..color = itemColor
            ..style = PaintingStyle.stroke
            ..strokeWidth = strokeWidth;

          //Draw Item Border circle
          Path borderPath = Path();
          switch (globalState.gridItems[i][j]) {
            case GridShape.circle:
              borderPath.addOval(
                  Rect.fromCircle(
                      center: center, radius: (squareSize - strokeWidth) / 2)
              );
            case GridShape.square:
              borderPath.addRect(
                  Rect.fromCenter(
                      center: center,
                      width: squareSize - strokeWidth,
                      height: squareSize - strokeWidth
                  )
              );
            case GridShape.star: {
                var numOfPoints = 5;
                var offset = 3;
                var path = Path();

                var radius = (squareSize - strokeWidth) / 2;
                var inner = radius / 1.5;
                var rotation = math.pi / 2 * 3;
                var step = math.pi / numOfPoints;

                path.moveTo(0, - (radius - offset));

                for (var i = 0; i <= numOfPoints; i++) {
                  var x = math.cos(rotation) * radius;
                  var y = math.sin(rotation) * radius;
                  path.lineTo(x, y + offset);
                  rotation += step;

                  x = math.cos(rotation) * inner;
                  y = math.sin(rotation) * inner;
                  path.lineTo(x, y + offset);
                  rotation += step;
                }

                borderPath.addPath(path, center);
              }
          }
          canvas.drawPath(borderPath, borderPaint);

          //Prepare and draw Text
          double textSize = 140 / globalState.nSquares;
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
  }

  @override
  bool shouldRepaint(ItemsPainter oldDelegate) => false;
  @override
  bool shouldRebuildSemantics(ItemsPainter oldDelegate) => false;
}