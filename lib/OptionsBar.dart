import 'package:flutter/material.dart';

class GridToolbar extends StatelessWidget {
  const GridToolbar({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 200,
      child: Row(
        children: [
          Expanded(
              child: ListView(
                scrollDirection: Axis.horizontal,
                children: [
                  Container(
                    color: Colors.amber[600],
                    child: const Center(child: Text('Entry A')),
                  ),
                ],
              )
          ),
        ],
      ),
    );
  }
}