import 'package:flutter/material.dart';
import 'package:flutter_grid_demo/painters.dart';
import 'package:provider/provider.dart';
import 'interactive_grid_layout.dart';

//ignore: must_be_immutable
class InteractiveGrid extends StatelessWidget {
  InteractiveGrid({super.key });

  ValueNotifier<Offset> onTappedLocation = ValueNotifier(Offset.zero);
  ValueNotifier<Matrix4> transformation = ValueNotifier(Matrix4.identity());

  @override
  Widget build(BuildContext context) {
    var globalState = context.watch<InteractiveGridLayoutState>();

    TransformationController transformationController = TransformationController();

    print('Build InteractiveGrid');

    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Container(
              width: 560,
              height: 40,
              decoration: BoxDecoration(
                color: Colors.lightBlue.shade200,
                border: Border.all(
                  width: 4,
                  color: Colors.lightBlue.shade200,
                ),
              ),
              child: RepaintBoundary(
                child: Stack(
                  children: [
                    CustomPaint(
                        size: Size(
                          MediaQuery.of(context).size.width,
                          MediaQuery.of(context).size.height,
                        ),
                        painter: HorizontalBarPainter(globalState: globalState, transformation: transformation)
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
        Row(
          children: [
            Container(
              width: 40,
              height: 560,
              decoration: BoxDecoration(
                color: Colors.lightBlue.shade200,
                border: Border.all(
                  width: 4,
                  color: Colors.lightBlue.shade200,
                ),
              ),
              child: RepaintBoundary(
                child: Stack(
                  children: [
                    CustomPaint(
                        size: Size(
                          MediaQuery.of(context).size.width,
                          MediaQuery.of(context).size.height,
                        ),
                        painter: VerticalBarPainter(globalState: globalState, transformation: transformation)
                    ),
                  ],
                ),
              ),
            ),
            Container(
              width: 560,
              height: 560,
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
                transformationController: transformationController,
                onInteractionUpdate: (details) {
                  transformation.value = transformationController.value;
                },
                  child: SizedBox(
                      child: GestureDetector(
                        onTapDown: (details) { onTappedLocation.value = details.localPosition; },
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
            ),
          ],
        ),
      ],
    );
  }
}