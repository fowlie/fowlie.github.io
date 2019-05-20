---
title: winning algorithm for tic tac toe using a 3x3 magic square
layout: post
date: 2018-08-24 00:00:00 +0000
comments: true

---
I'm not sure why I did this, but after reading about the 3x3 magic square I wanted to write a tic tac toe winning algorithm. If you haven't heard about it before, the 3x3 magic square is a matrix where the sum of every number in an edge or a diagonal equals to 15 (the magic number). So all you have to do is think of the playing board as a layered board where this picture is the bottom layer, and then the players can place their bricks on top of it. To determine if a player has won, all you need to do is find a combination of a players number from the magic square where the sum equals 15!![](/uploads/2018/08/24/3x3magicsquare.png "3x3 Magic Square")

As I couldn't find any good examples of this in Java wanted to create an example for myself and thought it would be a good idea to share this little fun piece of code with you.

```java
class TicTacToe {
    char board[] = new char[8];
    int[] magicSquare = new int[]{4, 9, 2, 3, 5, 7, 8, 1, 6};

    public static void main(String[] args) {
        TicTacToe ticTacToe = new TicTacToe();
        ticTacToe.board = new char[]{' ', ' ', 'x',
                                     'o', 'x', 'o',
                                     'x', ' ', 'o'};
        ticTacToe.checkWinner();
    }

    void checkWinner() {
        if (hasWon('x')) System.out.println("x win!");
        else if (hasWon('o')) System.out.println("o win!");
        else System.out.println("No winner yet...");
    }

    boolean hasWon(char player) {
        for (int i = 0; i < 9; i++)
            for (int j = 0; j < 9; j++)
                for (int k = 0; k < 9; k++)
                    if (i != j && i != k && j != k)
                        if (board[i] == player && board[j] == player && board[k] == player)
                            if (magicSquare[i] + magicSquare[j] + magicSquare[k] == 15)
                                return true;
        return false;
    }
}
```
