import 'package:flutter/material.dart';
import 'package:frontend/data.dart';
import 'package:frontend/grid.dart';

class GridCell extends StatefulWidget {
  const GridCell({
    Key? key,
    required this.grid,
    required this.changeTurn,
  }) : super(key: key);

  final Grid grid;
  final void Function(int id) changeTurn;

  @override
  State<GridCell> createState() => _GridCellState();
}

class _GridCellState extends State<GridCell> {
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        if (widget.grid.value == '') {
          widget.changeTurn(widget.grid.id);
        }
      },
      child: Container(
        padding: const EdgeInsets.all(16.0), 
        decoration: BoxDecoration(
          border: Border.all(
            color: Colors.black, 
            width: 1.0,
          ),
        ),
        child: Center(
          child: Text(
            widget.grid.value,
            style: const TextStyle(
              fontSize: 40.0, 
              fontWeight: FontWeight.bold, 
            ),
          ),
        ),
      ),
    );
  }
}
