import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'InteractiveGridLayout.dart';

class GridToolbar extends StatefulWidget {
  const GridToolbar({ super.key });

  @override
  State<GridToolbar> createState() => _GridToolbarState();
}

class _GridToolbarState extends State<GridToolbar> {
  @override
  Widget build(BuildContext context) {

    print('Build GridToolbar');

    var globalState = context.watch<InteractiveGridLayoutState>();
    var gridState = globalState.gridState;

    ButtonStyle onStyle = ButtonStyle(
      shape: MaterialStateProperty.all<RoundedRectangleBorder>(
          RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16.0),
          )
      ),
      backgroundColor: MaterialStateProperty.all<Color>(Colors.lightBlue.shade200),
    );

    ButtonStyle offStyle = ButtonStyle(
      shape: MaterialStateProperty.all<RoundedRectangleBorder>(
          RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16.0),
            side: BorderSide(
              color: Colors.lightBlue.shade200,
              width: 2
            )
          )
      ),
      backgroundColor: MaterialStateProperty.all<Color>(Colors.white),
    );

    return AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        height: gridState == GridState.create ? 100 : 0,
        curve: Curves.fastOutSlowIn,
        child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(
              child: ListView(
                scrollDirection: Axis.horizontal,
                children: [
                  SizedBox(
                    width: 100, // <-- Your width
                    height: 100, // <-- Your height
                    child: ElevatedButton(
                      onPressed: () {
                        setState(() {
                        globalState.gridShape = GridShape.circle;
                        globalState.notify();
                        });
                      },
                      style: globalState.gridShape == GridShape.circle ? onStyle : offStyle,
                      child: null
                    )
                  ),
                  const SizedBox(width: 16),
                  SizedBox(
                      width: 100, // <-- Your width
                      height: 100, // <-- Your height
                      child: ElevatedButton(
                          onPressed: () {
                            setState(() {
                              globalState.gridShape = GridShape.square;
                              globalState.notify();
                            });
                          },
                          style: globalState.gridShape == GridShape.square ? onStyle : offStyle,
                          child: null
                      )
                  ),
                  const SizedBox(width: 16),
                  SizedBox(
                      width: 100, // <-- Your width
                      height: 100, // <-- Your height
                      child: ElevatedButton(
                          onPressed: () {
                            setState(() {
                              globalState.gridShape = GridShape.star;
                              globalState.notify();
                            });
                          },
                          style: globalState.gridShape == GridShape.star ? onStyle : offStyle,
                          child: null
                      )
                  ),
                ],
              )
          ),
        ],
      ),
    );
  }
}

class ShapePainter extends CustomPainter {

  ShapePainter({required this.shape});
  GridShape shape;

  final borderPaint = Paint()
    ..color = Colors.white
    ..style = PaintingStyle.stroke
    ..strokeWidth = 16;

  @override
  void paint(Canvas canvas, Size size) {
    switch (shape) {
      case GridShape.circle: {
        var radius = size.width / 2;
        Offset center = Offset(radius, radius);

        Path borderPath = Path();
        borderPath.addOval(
            Rect.fromCircle(center: center, radius: radius)
        );
        canvas.drawPath(borderPath, borderPaint);

        print('Size: ' + size.width.toString() + ', ' + size.height.toString());
      }
      case GridShape.square: {
        var radius = size.width / 2;
        Offset center = Offset(radius, radius);

        Path borderPath = Path();
        borderPath.addRect(
            Rect.fromCenter(center: center, width: radius + 16, height: radius + 16)
        );
        canvas.drawPath(borderPath, borderPaint);
      }
      case GridShape.star: {

      }
    }
  }

  @override
  bool shouldRepaint(ShapePainter oldDelegate) => false;
  @override
  bool shouldRebuildSemantics(ShapePainter oldDelegate) => false;
}