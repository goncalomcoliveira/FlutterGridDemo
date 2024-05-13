import 'package:flutter/material.dart';
import 'package:flutter_grid_demo/painters.dart';
import 'package:provider/provider.dart';
import 'interactive_grid_layout.dart';

//ignore: must_be_immutable
class InteractiveGrid extends StatefulWidget {
  const InteractiveGrid({super.key });

  @override
  State<InteractiveGrid> createState() => _InteractiveGridState();
}

class _InteractiveGridState extends State<InteractiveGrid> {

  ValueNotifier<int> gridSize = ValueNotifier(10);
  ValueNotifier<Matrix4> transformation = ValueNotifier(Matrix4.identity());

  bool isExpanded = false;

  @override
  Widget build(BuildContext context) {

    gridSize.addListener(() {
      transformation.value = Matrix4.identity();
    });

    TransformationController transformationController = TransformationController();

    print('  Build InteractiveGrid');

    return Stack(
      children: [
        Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TopBar(gridSize: gridSize, transformation: transformation),
              ],
            ),
            Row(
              children: [
                SideBar(
                    gridSize: gridSize,
                    transformation: transformation),
                GridView(
                    gridSize: gridSize,
                    transformationController: transformationController,
                    transformation: transformation),
              ],
            ),
          ],
        ),
        Container(
          decoration: BoxDecoration(
            color: Colors.lightBlue.shade400,
            border: Border.all(
              width: 2,
              color: Colors.lightBlue.shade400,
            ),
          ),
          child: SizedBox(
            width: 40,
            height: 40,
            child: IconButton(
              onPressed: () {
                setState(() {
                  if (isExpanded) {
                    gridSize.value = 10;
                    isExpanded = false;
                  }
                  else {
                    gridSize.value = 12;
                    isExpanded = true;
                  }
                });
              },
              icon: isExpanded ? Image.asset('assets/images/icon/smaller_icon.png') : Image.asset('assets/images/icon/bigger_icon.png'),
            ),
          )
        ),
      ]
    );
  }
}

class GridView extends StatelessWidget {
  GridView({
    super.key,
    required this.gridSize,
    required this.transformationController,
    required this.transformation,
  });

  final ValueNotifier<int> gridSize;
  final TransformationController transformationController;
  final ValueNotifier<Matrix4> transformation;

  ValueNotifier<Offset> onTappedLocation = ValueNotifier(Offset.zero);

  @override
  Widget build(BuildContext context) {

    print('    Build GridView');

    var globalState = context.watch<InteractiveGridLayoutState>();

    return Container(
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
                          painter: GridPainter(gridSize: gridSize)
                      ),
                      CustomPaint(
                          size: Size(
                            MediaQuery.of(context).size.width,
                            MediaQuery.of(context).size.height,
                          ),
                          painter: ItemsPainter(globalState: globalState, gridSize: gridSize, onTappedLocation: onTappedLocation)
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

class SideBar extends StatelessWidget {
  const SideBar({
    super.key,
    required this.gridSize,
    required this.transformation,
  });

  final ValueNotifier<int> gridSize;
  final ValueNotifier<Matrix4> transformation;

  @override
  Widget build(BuildContext context) {

    print('    Build SideBar');

    var globalState = context.watch<InteractiveGridLayoutState>();

    return Container(
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
                painter: VerticalBarPainter(globalState: globalState, gridSize: gridSize, transformation: transformation)
            ),
          ],
        ),
      ),
    );
  }
}

class TopBar extends StatelessWidget {
  const TopBar({
    super.key,
    required this.gridSize,
    required this.transformation,
  });

  final ValueNotifier<int> gridSize;
  final ValueNotifier<Matrix4> transformation;

  @override
  Widget build(BuildContext context) {

    print('    Build TopBar');

    var globalState = context.watch<InteractiveGridLayoutState>();

    return Container(
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
                painter: HorizontalBarPainter(globalState: globalState, gridSize: gridSize, transformation: transformation)
            ),
          ],
        ),
      ),
    );
  }
}