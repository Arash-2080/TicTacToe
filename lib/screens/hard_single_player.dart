import 'package:flutter/material.dart';
import 'dart:math';

class MediumSinglePlayer extends StatefulWidget {
  const MediumSinglePlayer({super.key});

  @override
  State<MediumSinglePlayer> createState() => _MediumSinglePlayer();
}

class _MediumSinglePlayer extends State<MediumSinglePlayer> {
  bool isTurnO = true;
  List<String> xOroList = ['', '', '', '', '', '', '', '', ''];
  int filledBox = 0;
  bool gameHasResult = false;
  int scoreX = 0;
  int scoreO = 0;
  String winnerTitle = '';
  String previousWinner = ''; // اضافه کردن این متغیر

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Tic Tac Toe - Hard'),
        flexibleSpace: Image(
          image: AssetImage('images/12.jpg'),
          fit: BoxFit.cover,
        ),
        centerTitle: true,
        elevation: 0,
        actions: [
          IconButton(
            onPressed: () {
              clearBoard();
              scoreO = 0;
              scoreX = 0;
            },
            icon: Icon(Icons.refresh),
          ),
        ],
      ),
      backgroundColor: Colors.black,
      body: SafeArea(
        child: DecoratedBox(
          position: DecorationPosition.background,
          decoration: BoxDecoration(
            image: DecorationImage(
                image: AssetImage('images/12.jpg'), fit: BoxFit.fitHeight),
          ),
          child: _getBody(),
        ),
      ),
    );
  }

  Widget _getBody() {
    return Column(
      children: [
        SizedBox(height: 20),
        _getScoreBoard(),
        SizedBox(height: 20),
        _getResultButton(),
        SizedBox(height: 20),
        _getGrid(),
        _getTurn(),
        SizedBox(height: 60),
      ],
    );
  }

  Widget _getResultButton() {
    return Visibility(
      visible: gameHasResult,
      child: OutlinedButton(
        style: OutlinedButton.styleFrom(
          side: BorderSide(color: Colors.white, width: 2),
        ),
        onPressed: () {
          setState(() {
            gameHasResult = false;
            clearBoard();
            if (previousWinner == 'X') {
              isTurnO = false; // برنده X است، بنابراین نوبت O است
              Future.delayed(Duration(milliseconds: 500), () {
                if (!isTurnO) {
                  makeComputerMove();
                }
              });
            } else {
              isTurnO =
                  true; // برنده O است یا بازی مساوی شده، بنابراین نوبت X است
              Future.delayed(Duration(milliseconds: 500), () {
                if (!isTurnO) {
                  makeComputerMove();
                }
              });
            }
          });
        },
        child: Text(
          '$winnerTitle ! , play again',
          style: TextStyle(
              color: Colors.white, fontWeight: FontWeight.bold, fontSize: 20),
        ),
      ),
    );
  }

  Widget _getScoreBoard() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        Column(
          children: [
            Padding(
              padding: EdgeInsets.all(9),
              child: Text(
                'Player O',
                style: TextStyle(
                    color: Colors.red,
                    fontSize: 25,
                    fontWeight: FontWeight.bold),
              ),
            ),
            Padding(
              padding: EdgeInsets.all(9),
              child: Text(
                '$scoreO',
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 32,
                    fontWeight: FontWeight.bold),
              ),
            ),
          ],
        ),
        Column(
          children: [
            Padding(
              padding: EdgeInsets.all(9),
              child: Text(
                'Player X',
                style: TextStyle(
                    color: Colors.yellow,
                    fontSize: 25,
                    fontWeight: FontWeight.bold),
              ),
            ),
            Padding(
              padding: EdgeInsets.all(9),
              child: Text(
                '$scoreX',
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 32,
                    fontWeight: FontWeight.bold),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _getGrid() {
    return Expanded(
      child: GridView.builder(
        itemCount: 9,
        gridDelegate:
            SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 3),
        itemBuilder: (context, index) {
          return GestureDetector(
            onTap: () {
              tapped(index);
            },
            child: Container(
              width: 100,
              height: 100,
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey),
              ),
              child: Center(
                child: Text(
                  xOroList[index],
                  style: TextStyle(
                      color:
                          xOroList[index] == 'X' ? Colors.yellow : Colors.red,
                      fontSize: 40),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _getTurn() {
    return Text(
      isTurnO ? 'Turn O' : 'Turn X',
      style: TextStyle(
          color: Colors.white, fontSize: 25, fontWeight: FontWeight.bold),
    );
  }

  void tapped(int index) {
    if (gameHasResult || xOroList[index] != '') {
      return;
    }

    setState(() {
      xOroList[index] = 'O';
      filledBox++;
      isTurnO = !isTurnO;
      checkWinner();
      if (!gameHasResult && !isTurnO) {
        Future.delayed(Duration(milliseconds: 500), () {
          makeComputerMove();
        });
      }
    });
  }

  void makeComputerMove() {
    int index = findBestMove();
    setState(() {
      xOroList[index] = 'X';
      filledBox++;
      isTurnO = !isTurnO;
      checkWinner();
    });
  }

  int findBestMove() {
    int bestScore = -1000;
    int bestMove = -1;

    for (int i = 0; i < 9; i++) {
      if (xOroList[i] == '') {
        xOroList[i] = 'X';
        int moveScore = minimax(xOroList, 0, false);
        xOroList[i] = '';
        if (moveScore > bestScore) {
          bestMove = i;
          bestScore = moveScore;
        }
      }
    }
    return bestMove;
  }

  int minimax(List<String> board, int depth, bool isMaximizing) {
    String result = checkWinnerMinimax(board);
    if (result != '') {
      if (result == 'X') {
        return 10 - depth;
      } else if (result == 'O') {
        return depth - 10;
      } else if (result == 'Draw') {
        return 0;
      }
    }

    if (isMaximizing) {
      int bestScore = -1000;
      for (int i = 0; i < 9; i++) {
        if (board[i] == '') {
          board[i] = 'X';
          int score = minimax(board, depth + 1, false);
          board[i] = '';
          bestScore = max(score, bestScore);
        }
      }
      return bestScore;
    } else {
      int bestScore = 1000;
      for (int i = 0; i < 9; i++) {
        if (board[i] == '') {
          board[i] = 'O';
          int score = minimax(board, depth + 1, true);
          board[i] = '';
          bestScore = min(score, bestScore);
        }
      }
      return bestScore;
    }
  }

  String checkWinnerMinimax(List<String> board) {
    for (int i = 0; i < 3; i++) {
      if (board[i * 3] == board[i * 3 + 1] &&
          board[i * 3] == board[i * 3 + 2] &&
          board[i * 3] != '') {
        return board[i * 3];
      }
      if (board[i] == board[i + 3] &&
          board[i] == board[i + 6] &&
          board[i] != '') {
        return board[i];
      }
    }
    if (board[0] == board[4] && board[0] == board[8] && board[0] != '') {
      return board[0];
    }
    if (board[2] == board[4] && board[2] == board[6] && board[2] != '') {
      return board[2];
    }
    if (!board.contains('')) {
      return 'Draw';
    }
    return '';
  }

  void checkWinner() {
    if (xOroList[0] == xOroList[1] &&
        xOroList[0] == xOroList[2] &&
        xOroList[0] != '') {
      hasResult(xOroList[0], 'Winner is ' + xOroList[0]);
      return;
    }
    if (xOroList[3] == xOroList[4] &&
        xOroList[3] == xOroList[5] &&
        xOroList[3] != '') {
      hasResult(xOroList[3], 'Winner is ' + xOroList[3]);
      return;
    }
    if (xOroList[6] == xOroList[7] &&
        xOroList[6] == xOroList[8] &&
        xOroList[6] != '') {
      hasResult(xOroList[6], 'Winner is ' + xOroList[6]);
      return;
    }
    if (xOroList[0] == xOroList[3] &&
        xOroList[0] == xOroList[6] &&
        xOroList[0] != '') {
      hasResult(xOroList[0], 'Winner is ' + xOroList[0]);
      return;
    }
    if (xOroList[1] == xOroList[4] &&
        xOroList[1] == xOroList[7] &&
        xOroList[1] != '') {
      hasResult(xOroList[1], 'Winner is ' + xOroList[1]);
      return;
    }
    if (xOroList[2] == xOroList[5] &&
        xOroList[2] == xOroList[8] &&
        xOroList[2] != '') {
      hasResult(xOroList[2], 'Winner is ' + xOroList[2]);
      return;
    }
    if (xOroList[0] == xOroList[4] &&
        xOroList[0] == xOroList[8] &&
        xOroList[0] != '') {
      hasResult(xOroList[0], 'Winner is ' + xOroList[0]);
      return;
    }
    if (xOroList[2] == xOroList[4] &&
        xOroList[2] == xOroList[6] &&
        xOroList[2] != '') {
      hasResult(xOroList[2], 'Winner is ' + xOroList[2]);
      return;
    }
    if (filledBox == 9) {
      hasResult('', 'Draw');
    }
  }

  void clearBoard() {
    setState(() {
      for (int i = 0; i < xOroList.length; i++) {
        xOroList[i] = '';
      }
      filledBox = 0;
      gameHasResult = false;
      winnerTitle = '';
    });
  }

  void hasResult(String winner, String title) {
    setState(() {
      gameHasResult = true;
      winnerTitle = title;
      previousWinner = winner; // ذخیره برنده‌ی فعلی
      if (winner == 'X') {
        scoreX++;
      } else if (winner == 'O') {
        scoreO++;
      }
    });
  }
}
