import 'package:flutter/material.dart';

class TwoPlayerScreen extends StatefulWidget {
  const TwoPlayerScreen({super.key});

  @override
  State<TwoPlayerScreen> createState() => _TwoPlayerScreenState();
}

class _TwoPlayerScreenState extends State<TwoPlayerScreen> {
  bool isTurnO = true;

  List<String> xOroList = ['', '', '', '', '', '', '', '', ''];

  int filledBox = 0;

  bool gameHasResult = false;

  int scoreX = 0;
  int scoreO = 0;

  String winnerTitle = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Tic Tac Toe'),
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
          child: _getbody(),
        ),
      ),
    );
  }

  Column _getbody() {
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
          });
        },
        child: Text(
          '$winnerTitle , play again',
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
                style: TextStyle(color: Colors.red,
                    fontSize: 25,
                    fontWeight: FontWeight.bold),
              ),
            ),
            Padding(
              padding: EdgeInsets.all(9),
              child: Text(
                '$scoreO',
                style: TextStyle(color: Colors.white, fontSize: 32,fontWeight: FontWeight.bold),
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
                style: TextStyle(color: Colors.yellow,
                    fontSize: 25,
                    fontWeight: FontWeight.bold),
              ),
            ),
            Padding(
              padding: EdgeInsets.all(9),
              child: Text(
                '$scoreX',
                style: TextStyle(color: Colors.white, fontSize: 32,fontWeight: FontWeight.bold),
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
    if (gameHasResult) {
      return;
    }

    setState(
      () {
        if (xOroList[index] != '') {
          return;
        }
        if (isTurnO) {
          xOroList[index] = 'O';
          filledBox = filledBox + 1;
        } else {
          xOroList[index] = 'X';
          filledBox = filledBox + 1;
        }
        isTurnO = !isTurnO;
        checkWinner();
      },
    );
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
      for (var i = 0; i < xOroList.length; i++) {
        xOroList[i] = '';
      }
      filledBox = 0;
    });
  }

  void hasResult(String winner, String title) {
    setState(() {
      gameHasResult = true;
      winnerTitle = title;
      if (winner == 'X') {
        scoreX = scoreX + 1;
      } else if (winner == 'O') {
        scoreO = scoreO + 1;
      } else {
        scoreO = scoreO + 1;
        scoreX = scoreX + 1;
      }
    });
  }
}
