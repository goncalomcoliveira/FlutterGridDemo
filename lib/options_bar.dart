import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'interactive_grid_layout.dart';

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
      iconSize: MaterialStateProperty.all<double>(10),
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
      iconSize: MaterialStateProperty.all<double>(10),
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
                  IconButton(
                    onPressed: () {
                      setState(() {
                        globalState.gridShape = GridShape.circle;
                        globalState.notify();
                      });
                    },
                    icon: globalState.gridShape == GridShape.circle ?
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Image.asset('assets/images/shapes/circle_selected.png'),
                    ) :
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Image.asset('assets/images/shapes/circle_base.png'),
                    ),
                    style: globalState.gridShape == GridShape.circle ? onStyle : offStyle,
                  ),
                  const SizedBox(width: 16),
                  IconButton(
                    onPressed: () {
                      setState(() {
                        globalState.gridShape = GridShape.square;
                        globalState.notify();
                      });
                    },
                    icon: globalState.gridShape == GridShape.square ?
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Image.asset('assets/images/shapes/square_selected.png'),
                    ) :
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Image.asset('assets/images/shapes/square_base.png'),
                    ),
                    style: globalState.gridShape == GridShape.square ? onStyle : offStyle,
                  ),
                  const SizedBox(width: 16),
                  IconButton(
                    onPressed: () {
                      setState(() {
                        globalState.gridShape = GridShape.star;
                        globalState.notify();
                      });
                    },
                    icon: globalState.gridShape == GridShape.star ?
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Image.asset('assets/images/shapes/star_selected.png'),
                    ) :
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Image.asset('assets/images/shapes/star_base.png'),
                    ),
                    style: globalState.gridShape == GridShape.star ? onStyle : offStyle,
                  ),
                  const SizedBox(width: 16),
                ],
              )
          ),
        ],
      ),
    );
  }
}