import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'interactive_grid.dart';
import 'options_bar.dart';
import 'state_bar.dart';

//ignore: must_be_immutable
class InteractiveGridLayout extends StatelessWidget {
  InteractiveGridLayout({super.key});

  var titleStyle = TextStyle(
    fontSize: 32,
    color: Colors.lightBlue.shade800,
    fontWeight: FontWeight.bold,
  );

  @override
  Widget build(BuildContext context) {

    print('Build InteractiveGridLayout');

    return ChangeNotifierProvider(
      create: (context) => InteractiveGridLayoutState(),
      child: Card(
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
                    child: Text('Interactable Grid', style: titleStyle)
                ),
                const SizedBox(width: 0, height: 24),
                const StateBar(),
                const SizedBox(width: 0, height: 24),
                InteractiveGrid(),
                const SizedBox(width: 0, height: 24),
                const GridToolbar(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class InteractiveGridLayoutState extends ChangeNotifier {
  GridState gridState = GridState.create;
  GridShape gridShape = GridShape.circle;

  late List<List> gridItems = List<List>.generate(10, (i) => List<dynamic>.generate(10, (index) => null, growable: false), growable: false);

  InteractiveGridLayoutState() {
    gridItems = List<List>.generate(10, (i) => List<dynamic>.generate(10, (index) => null, growable: false), growable: false);
  }

  //Build selection array
  void resizeItemGrid(int size) {
    gridItems = resizeList(gridItems, size, size);
  }

  List<List<dynamic>> resizeList(List<List<dynamic>> originalList, int newRowSize, int newColumnSize) {
    List<List<dynamic>> resizedList = List.generate(newRowSize, (i) => List<dynamic>.generate(newColumnSize, (index) => null, growable: false), growable: false);

    for (int i = 0; i < originalList.length && i < newRowSize; i++) {
      for (int j = 0; j < originalList[i].length && j < newColumnSize; j++) {
        resizedList[i][j] = originalList[i][j];
      }
    }

    return resizedList;
  }

  void updateState(GridState gridState) {
    this.gridState = gridState;
    notifyListeners();
  }

  void updateShape(GridShape gridShape) {
    this.gridShape = gridShape;
    notifyListeners();
  }
}

enum GridState { create, select, delete }
enum GridShape { circle, square, star }