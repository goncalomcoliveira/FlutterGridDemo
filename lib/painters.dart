import 'dart:math' as math;
import 'package:flutter/material.dart';

import 'interactive_grid_layout.dart';

class GridPainter extends CustomPainter {

  final ValueNotifier<int> gridSize;

  GridPainter({required this.gridSize}):super(repaint: gridSize);

  @override
  void paint(Canvas canvas, Size size) {

    //Square size
    double squareSize = size.width / gridSize.value;

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
    for (int k = 1; k < gridSize.value; k++) {
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
  final ValueNotifier<int> gridSize;
  ValueNotifier<Offset> onTappedLocation;

  ItemsPainter({required this.globalState, required this.gridSize, required this.onTappedLocation}):
        super(repaint:
          Listenable.merge(List<Listenable>.from([onTappedLocation, gridSize])));

  @override
  void paint(Canvas canvas, Size size) {

    globalState.resizeItemGrid(gridSize.value);

    //Square size
    double squareSize = size.width / gridSize.value;

    final selectedPaint = Paint()
      ..color = Colors.lightBlue.shade200;

    int? selectedX;
    int? selectedY;

    //Draw Squares
    for (int i = 0; i < gridSize.value; i++) {
      for (int j = 0; j < gridSize.value; j++) {

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
          selectedX = i;
          selectedY = j;
          //onTap();
        }

        bool isSelected = selectedX == i && selectedY == j;

        //Draw background square path if selected
        if (isSelected && selectedX != null && selectedY != null) {
          canvas.drawPath(backgroundSquare, selectedPaint);
        }

        //Draw Items
        if (globalState.gridItems[i][j] != null) {

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
          double textSize = 140 / gridSize.value;
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

class VerticalBarPainter extends CustomPainter {

  InteractiveGridLayoutState globalState;
  final ValueNotifier<int> gridSize;
  ValueNotifier<Matrix4> transformation;

  VerticalBarPainter({required this.globalState, required this.gridSize, required this.transformation}):
        super(repaint:
          Listenable.merge(List<Listenable>.from([transformation, gridSize])));

  @override
  void paint(Canvas canvas, Size size) {

    final double scale = transformation.value.getMaxScaleOnAxis();
    final double dy = transformation.value.getTranslation().y;

    //Square size
    double squareSize = size.height / gridSize.value * scale;
    double lineOffset = 4.0;

    //Backround paint
    final backroundPaint = Paint()
      ..color = Colors.lightBlue.shade200;

    //Draw Background
    canvas.drawRect(Rect.fromLTRB(0, 0, size.width, size.height), backroundPaint);

    //Inside lines' paint
    final linePaint = Paint()
      ..style = PaintingStyle.stroke
      ..color = Colors.white
      ..strokeWidth = 1;

    //Draw inside Lines
    for (int k = 1; k <= gridSize.value; k++) {
      double y = dy + squareSize * k;
      if (y >= 0 && y <= size.height && k < gridSize.value) {
          canvas.drawLine(
            Offset(0 + lineOffset, y), Offset(size.width, y), linePaint);
      }

      //Prepare and draw Text
      double textSize = 14;
      TextStyle textStyle = TextStyle(
          color: Colors.white,
          fontSize: textSize,
          fontWeight: FontWeight.bold
      );
      TextSpan textSpan = TextSpan(
        text: k.toString(),
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
      y -= (squareSize / 2);
      if (y >= 0 + (textPainter.height / 2) && y <= size.height - (textPainter.height / 2)) {
        Offset centerText = Offset((size.width / 2) - (textPainter.width / 2), y - (textPainter.height / 2));
        final offset = centerText;
        textPainter.paint(canvas, offset);
      }
    }
  }

  @override
  bool shouldRepaint(VerticalBarPainter oldDelegate) => false;
  @override
  bool shouldRebuildSemantics(VerticalBarPainter oldDelegate) => false;
}

class HorizontalBarPainter extends CustomPainter {

  InteractiveGridLayoutState globalState;
  final ValueNotifier<int> gridSize;
  ValueNotifier<Matrix4> transformation;

  HorizontalBarPainter({required this.globalState, required this.gridSize, required this.transformation}):
        super(repaint:
          Listenable.merge(List<Listenable>.from([transformation, gridSize])));

  @override
  void paint(Canvas canvas, Size size) {

    final double scale = transformation.value.getMaxScaleOnAxis();
    final double dx = transformation.value.getTranslation().x;

    //Square size
    double squareSize = size.width / gridSize.value * scale;
    double lineOffset = 4.0;

    //Backround paint
    final backroundPaint = Paint()
      ..color = Colors.lightBlue.shade200;

    //Draw Background
    canvas.drawRect(Rect.fromLTRB(0, 0, size.width, size.height), backroundPaint);

    //Inside lines' paint
    final linePaint = Paint()
      ..style = PaintingStyle.stroke
      ..color = Colors.white
      ..strokeWidth = 1;

    //Draw inside Lines
    for (int k = 1; k <= gridSize.value; k++) {
      double x = dx + squareSize * k;
      if (x >= 0 && x <= size.width && k < gridSize.value) { // Only draw the line if it's within the canvas
        canvas.drawLine(Offset(x, 0 + lineOffset), Offset(x, size.height), linePaint);
      }

      //Prepare and draw Text
      double textSize = 14;
      TextStyle textStyle = TextStyle(
          color: Colors.white,
          fontSize: textSize,
          fontWeight: FontWeight.bold
      );
      TextSpan textSpan = TextSpan(
        text: k.toString(),
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
      x -= (squareSize / 2);
      if (x >= 0 + (textPainter.width / 2) && x <= size.width - (textPainter.height / 2)) {
        Offset centerText = Offset(x - (textPainter.width / 2), (size.height / 2) - (textPainter.height / 2));
        final offset = centerText;
        textPainter.paint(canvas, offset);
      }
    }
  }

  @override
  bool shouldRepaint(HorizontalBarPainter oldDelegate) => false;
  @override
  bool shouldRebuildSemantics(HorizontalBarPainter oldDelegate) => false;
}