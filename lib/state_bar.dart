import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'interactive_grid_layout.dart';

//ignore: must_be_immutable
class StateBar extends StatefulWidget {
  const StateBar({ super.key });

  @override
  State<StateBar> createState() => _StateBarState();
}

class _StateBarState extends State<StateBar> {

  @override
  Widget build(BuildContext context) {

    print('Build StateBar');

    var globalState = context.watch<InteractiveGridLayoutState>();

    ButtonStyle normalStyle = ButtonStyle(
      foregroundColor: MaterialStateProperty.all<Color>(Colors.lightBlue.shade800),
      backgroundColor: MaterialStateProperty.all<Color>(Colors.white),
      shape: MaterialStateProperty.all<RoundedRectangleBorder>(
          RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(64.0),
              side: BorderSide(
                  color: Colors.lightBlue.shade200,
                  width: 2
              )
          )
      ),
      elevation: MaterialStateProperty.all<double?>(2)
    );

    ButtonStyle selectedStyle = ButtonStyle(
        foregroundColor: MaterialStateProperty.all<Color>(Colors.white),
        backgroundColor: MaterialStateProperty.all<Color>(Colors.lightBlue.shade200),
        shape: MaterialStateProperty.all<RoundedRectangleBorder>(
            RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(64.0),
            )
        ),
        elevation: MaterialStateProperty.all<double?>(4)
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
                globalState.notify();
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
                globalState.notify();
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
                globalState.notify();
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