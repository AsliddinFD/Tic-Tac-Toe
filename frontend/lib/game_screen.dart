import 'dart:ffi';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:frontend/data.dart';
import 'package:frontend/grid_cell.dart';

class GameScreen extends StatefulWidget {
  @override
  State<GameScreen> createState() {
    return _GameScreenState();
  }
}

class _GameScreenState extends State<GameScreen> {
  String turn = '';
  bool draw = true;
  bool confirm = false;
  int playerXScore = 0;
  int playerOScore = 0;

  void showWinner(String msg) {
    if (Platform.isIOS) {
      showCupertinoDialog(
        context: context,
        builder: (context) => CupertinoAlertDialog(
          content: Text(msg),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
                setState(() {
                  confirm = true;
                });
                resetGame();
              },
              child: const Text('Okay'),
            )
          ],
        ),
      );
    } else {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          content: Text(msg),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
                setState(() {
                  confirm = true;
                });
                resetGame();
              },
              child: const Text('Okay'),
            ),
          ],
        ),
      );
    }
  }

  resetGame() {
    for (var i in gridCells) {
      setState(() {
        i.value = '';
        turn = '';
      });
    }
  }

  bool checkDraw() {
    final unSelectedCells = gridCells.where((element) => element.value == '');
    if (unSelectedCells.isEmpty && draw == true) {
      return true;
    }
    return false;
  }

  String checkWinner() {
    final winConditions = [
      [0, 1, 2],
      [0, 3, 6],
      [0, 4, 8],
      [1, 4, 7],
      [2, 5, 8],
      [2, 4, 6],
      [3, 4, 5],
      [6, 7, 8],
    ];

    for (final condition in winConditions) {
      final values = condition.map((index) => gridCells[index].value).toList();
      if (values.every((value) => value == 'X')) {
        showWinner('X won the game');
        setState(() {
          draw = false;
        });

        return 'X';
      } else if (values.every((value) => value == 'O')) {
        showWinner('O won the game');
        setState(() {
          draw = false; // Set draw to false when O wins.
        });

        return 'O';
      }
    }
    if (checkDraw()) {
      showWinner("Game was draw!");

      return 'Draw';
    }
    return 'None';
  }


  

  void changeTurn(int id) {
    final selectedCell = gridCells.firstWhere((gridCell) => gridCell.id == id);
    if (turn == '') {
      setState(() {
        turn = 'X';
        selectedCell.value = turn;
        checkWinner();
      });
      return;
    } else if (turn == 'X') {
      setState(() {
        turn = 'O';
        selectedCell.value = turn;
        checkWinner();
      });
      return;
    } else if (turn == 'O') {
      setState(() {
        turn = 'X';
        selectedCell.value = turn;
        checkWinner();
      });
      return;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: GridView(
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 3,
          ),
          children: [
            for (var i in gridCells)
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: GridCell(
                  grid: i,
                  changeTurn: changeTurn,
                ),
              ),
            
          ],
        ),
      ),
    );
  }
}
