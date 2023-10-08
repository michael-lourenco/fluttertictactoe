import 'package:flutter/material.dart';

class MyGame extends StatefulWidget {
  const MyGame({Key? key}) : super(key: key);

  @override
  State<MyGame> createState() => _MyGameState();
}

class _MyGameState extends State<MyGame> {
  List gameGrid = [
    ['', '', ''],
    ['', '', ''],
    ['', '', ''],
  ];

  int moves = 0;
  String currentPlayer = 'X';
  String informativeText = 'Vamos comecar?';
  bool gameStarted = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          AbsorbPointer(
            absorbing: !gameStarted,
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: const [
                    Padding(
                      padding: EdgeInsets.all(20.0),
                      child: Text(
                        "Jogo da Velha",
                        style: TextStyle(
                            fontSize: 50,
                            color: Colors.black,
                            fontStyle: FontStyle.italic),
                      ),
                    )
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    myButton(row: 0, column: 0),
                    myButton(row: 0, column: 1),
                    myButton(row: 0, column: 2),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    myButton(row: 1, column: 0),
                    myButton(row: 1, column: 1),
                    myButton(row: 1, column: 2),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    myButton(row: 2, column: 0),
                    myButton(row: 2, column: 1),
                    myButton(row: 2, column: 2),
                  ],
                ),
              ],
            ),
          ),
          Column(
            children: [
              Padding(
                padding: EdgeInsets.all(15.0),
                child: Text(
                  informativeText,
                  style: TextStyle(
                      fontSize: 20,
                      color: Colors.black,
                      fontWeight: FontWeight.bold),
                ),
              ),
              AbsorbPointer(
                absorbing: gameStarted,
                child:
                    Opacity(opacity: gameStarted ? 0 : 1, child: btnStart()),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget myButton({required int row, required int column}) {
    return Padding(
      padding: const EdgeInsets.all(4.0),
      child: AbsorbPointer(
        absorbing: gameGrid[row][column] == '' ? false : true,
        child: ElevatedButton(
          onPressed: () {
            setState(() {
              clique(row: row, column: column);
            });
          },
          style: ElevatedButton.styleFrom(
              fixedSize: const Size(100, 100), primary: Colors.black38),
          child: Text(
            gameGrid[row][column],
            style: TextStyle(fontSize: 50),
          ),
        ),
      ),
    );
  }

  Widget btnStart() {
    return Padding(
      padding: const EdgeInsets.all(4.0),
      child: ElevatedButton(
        onPressed: () {
          setState(() {
            gameStarted = true;
            moves = 0;
            gameGrid = List.generate(3, (i) => List.filled(3, ''));
            informativeText = '$currentPlayer é sua vez.';
          });
        },
        style: ElevatedButton.styleFrom(
            fixedSize: const Size(200, 50), primary: Colors.amber),
        child: Text(
          moves > 0 ? "Jogar Novamente" : "Bora Jogar!",
          style: TextStyle(fontSize: 20),
        ),
      ),
    );
  }

  // logica do click
  void clique({required int row, required int column}) {
    moves++;
    gameGrid[row][column] = currentPlayer;
    bool hasWinner = verifyWinner(player: currentPlayer, row: row, column: column);

    if (hasWinner) {
      informativeText = '$currentPlayer win!';
      gameStarted = false;
    } else if (hasWinner == false && moves == 9) {
      informativeText = 'Empate!';
      gameStarted = false;
    } else {
      if (currentPlayer == 'X') {
        currentPlayer = 'O';
      } else {
        currentPlayer = 'X';
      }
      informativeText = '$currentPlayer é a sua vez.';
    }
  }

  bool verifyWinner({required String player, required int row, required int column}) {
    bool win = true;
    // verify row
    for (int i = 0; i < 3; i++) {
      if (gameGrid[row][i] != player) {
        win = false;
        break;
      }
    }

    // verify column
    if (win == false) {
      for (int j = 0; j < 3; j++) {
        if (gameGrid[j][column] != player) {
          win = false;
          break;
        } else {
          win = true;
        }
      }
    }

    // verify diagonal
    if (win == false) {
      if (gameGrid[1][1] == player) {
        if (gameGrid[0][0] == player && gameGrid[2][2] == player) {
          win == true;
        } else if (gameGrid[0][2] == player && gameGrid[2][0] == player) {
          win = true;
        }
      }
    }

    return win;
  }
}
