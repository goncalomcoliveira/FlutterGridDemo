import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'InteractiveGrid.dart';
import 'OptionsBar.dart';
import 'StateBar.dart';

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
  int nSquares = 10;
  GridState gridState = GridState.create;
}

enum GridState { create, select, delete }