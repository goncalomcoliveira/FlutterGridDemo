import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'InteractiveGridLayout.dart';

//ignore: must_be_immutable
class StateBar extends StatefulWidget {
  const StateBar({ super.key });

  @override
  State<StateBar> createState() => _StateBarState();
}

class _StateBarState extends State<StateBar> {

  @override
  Widget build(BuildContext context) {
    var globalState = context.watch<InteractiveGridLayoutState>();

    ButtonStyle normalStyle = ElevatedButton.styleFrom(
      foregroundColor: Colors.lightBlue.shade800,
      backgroundColor: Colors.white,
      elevation: 2,
    );

    ButtonStyle selectedStyle = ElevatedButton.styleFrom(
      foregroundColor: Colors.white,
      backgroundColor: Colors.lightBlue.shade200,
      elevation: 4,
    );

    return SizedBox(
      height: 32,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          ElevatedButton(
            onPressed: () {
              setState(() {
                globalState.gridState = GridState.create;
              });
            },
            style: globalState.gridState == GridState.create ? selectedStyle : normalStyle,
            child: const Text('Create', style: TextStyle(fontSize: 16)),
          ),
          const SizedBox(width: 24, height: 0),
          ElevatedButton(
            onPressed: () {
              setState(() {
                globalState.gridState = GridState.select;
              });
            },
            style: globalState.gridState == GridState.select ? selectedStyle : normalStyle,
            child: const Text('Select', style: TextStyle(fontSize: 16)),
          ),
          const SizedBox(width: 24, height: 0),
          ElevatedButton(
            onPressed: () {
              setState(() {
                globalState.gridState = GridState.delete;
              });
            },
            style: globalState.gridState == GridState.delete ? selectedStyle : normalStyle,
            child: const Text('Delete', style: TextStyle(fontSize: 16)),
          ),
        ],
      ),
    );
  }
}