
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:graphview/GraphView.dart';
import 'package:the_chess_engine/src/chess_opening_directory/cod_map.dart';

import '/src/chess/chess.dart';
import 'cod_map.dart';

class ChessOpeningDirectory extends ChangeNotifier{
  String name;
  final ChessColor playerColor;

  List<ChessOpeningMove> currentPath = [];
  final Chess currentChessBoard = Chess();

  final String startingPosition = 'rnbqkbnr/pppppppp/8/8/8/8/PPPPPPPP/RNBQKBNR w KQkq - 0 1';

  final ChessOpeningMove testMove = ChessOpeningMove('rnbqkbnr/pppppppp/8/8/8/8/PPPPPPPP/RNBQKBNR w KQkq - 0 1', 'e4', 'comment');

  late Map<String, PositionMoves> moves = {
    'rnbqkbnr/pppppppp/8/8/8/8/PPPPPPPP/RNBQKBNR w KQkq - 0 1': PositionMoves(),

  };
  // {
  //   'rnbqkbnr/pppppppp/8/8/8/8/PPPPPPPP/RNBQKBNR w KQkq - 0 1': [
  //     ChessOpeningMove('rnbqkbnr/pppppppp/8/8/8/8/PPPPPPPP/RNBQKBNR w KQkq - 0 1', 'e4', 'comment'),
  //     ChessOpeningMove('rnbqkbnr/pppppppp/8/8/8/8/PPPPPPPP/RNBQKBNR w KQkq - 0 1', 'd4', 'comment'),
  //     ChessOpeningMove('rnbqkbnr/pppppppp/8/8/8/8/PPPPPPPP/RNBQKBNR w KQkq - 0 1', 'Nf3', 'comment'),
  //     ChessOpeningMove('rnbqkbnr/pppppppp/8/8/8/8/PPPPPPPP/RNBQKBNR w KQkq - 0 1', 'a4', 'comment'),
  //     ChessOpeningMove('rnbqkbnr/pppppppp/8/8/8/8/PPPPPPPP/RNBQKBNR w KQkq - 0 1', 'a3', 'comment'),
  //     ChessOpeningMove('rnbqkbnr/pppppppp/8/8/8/8/PPPPPPPP/RNBQKBNR w KQkq - 0 1', 'b3', 'comment'),
  //     ChessOpeningMove('rnbqkbnr/pppppppp/8/8/8/8/PPPPPPPP/RNBQKBNR w KQkq - 0 1', 'b4', 'comment'),
  //     // ChessOpeningMove('rnbqkbnr/pppppppp/8/8/8/8/PPPPPPPP/RNBQKBNR w KQkq - 0 1', 'b3', 'comment'),
  //   ],
  //   'rnbqkbnr/pppppppp/8/8/4P3/8/PPPP1PPP/RNBQKBNR b KQkq e3 0 1': [ChessOpeningMove('rnbqkbnr/pppppppp/8/8/4P3/8/PPPP1PPP/RNBQKBNR b KQkq e3 0 1', 'e5', 'comment')],
  //   'rnbqkbnr/pppppppp/8/8/3P4/8/PPP1PPPP/RNBQKBNR b KQkq d3 0 1': [ChessOpeningMove('rnbqkbnr/pppppppp/8/8/3P4/8/PPP1PPPP/RNBQKBNR b KQkq d3 0 1', 'e5', 'comment')],
  // };
  // Map<String, List<ChessOpeningMove>> blackMoves = {
  //   'rnbqkbnr/pppppppp/8/8/4P3/8/PPPP1PPP/RNBQKBNR b KQkq e3 0 1': [ChessOpeningMove('rnbqkbnr/pppppppp/8/8/4P3/8/PPPP1PPP/RNBQKBNR b KQkq e3 0 1', 'e5', 'comment')]
  // };

//   rnbqkbnr/pppppppp/8/8/4P3/8/PPPP1PPP/RNBQKBNR b KQkq e3 0 1
//   rnbqkbnr/pppppppp/8/8/4P3/8/PPPP1PPP/RNBQKBNR b KQkq e3 0 1
  ChessOpeningDirectory(this.name, this.playerColor);
  ChessOpeningDirectory.fromNewGame(this.name, this.playerColor){}

  void applyMove(move){
    String startPos = currentChessBoard.fen;
    String sanMove = currentChessBoard.move(move);
    print(sanMove);

    if(sanMove=="") return;

    String endPos = currentChessBoard.fen;

    ChessOpeningMove com = ChessOpeningMove(startPos, sanMove, "", resultingBoard: endPos);

    currentPath.add(com);
    print(currentPath);
    notifyListeners();

  }

  void registerPath(){
    print("test");
    print(currentPath);
    for(ChessOpeningMove com in currentPath){
      registerMove(com);
    }
    notifyListeners();
  }

  void registerMove(ChessOpeningMove move){
    print(moves);
    print(move);

    if(moves.containsKey(move.originalBoard) && !moves[move.originalBoard]!.following.any((com) => com.move == move.move))
    {

      moves[move.originalBoard]!.following.add(move);

      if(!moves.containsKey(move.resultingBoard)) {
        moves[move.resultingBoard] = PositionMoves();
      }
      moves[move.resultingBoard]?.preceding.add(move);

      print(moves);
    }else{
      print("ERR cannot register move");
    }
  }

  Graph getGraph(){
    Graph graph = Graph();

    List<String> registeredNodes = [];

    moves.forEach((key, value) {
        if(!registeredNodes.contains(key))
        {
          graph.addNode(Node.Id(key));
          registeredNodes.add(key);
        }
      for (var element in value.following) {
        if(!registeredNodes.contains(element.resultingBoard))
        {
          graph.addNode(Node.Id(element.resultingBoard));
          registeredNodes.add(element.resultingBoard);
        }
        graph.addEdge(graph.getNodeUsingId(element.originalBoard), graph.getNodeUsingId(element.resultingBoard),
          paint: Paint()
            ..color = element.isWhiteMove()? Colors.white : Colors.black
            ..strokeWidth = 2.5
          ,
        );
      }
    });

    // print("NODES:");
    // for (var node in graph.nodes) {
    //   print(Chess.fromFEN(node.key?.value as String).ascii);
    //   print(node.key?.value as String);
    // }
    //
    // print(graph.toJson());
    return graph;
  }

  void setPathToPos(String pos){
    List<ChessOpeningMove> path = [];

    while(pos != startingPosition)
    {
      if(moves.containsKey(pos))
        {
          if(moves[pos]!.preceding.isNotEmpty)
            {
              path.insert(0, moves[pos]!.preceding[0]);
              pos = moves[pos]!.preceding[0].originalBoard;
            }
          else{break;}
        }else{break;}
    }

    currentPath = path;

    currentChessBoard.load(path.isNotEmpty? path.last.resultingBoard : startingPosition);
    notifyListeners();
  }

  bool isPosInPath(String pos){
    if(pos==startingPosition) return true;

    for(ChessOpeningMove com in currentPath){
      if(com.resultingBoard == pos) return true;
    }

    return false;
  }


}

class PositionMoves
{
  List<ChessOpeningMove> preceding = [];
  List<ChessOpeningMove> following = [];
}

class ChessOpeningMove
{
  final String originalBoard;
  final String move;
  final String comment;
  late final String resultingBoard;

  num playCount = 0;


  ChessOpeningMove(this.originalBoard ,this.move, this.comment, {this.playCount=0, resultingBoard=""}){
    Chess game = Chess.fromFEN(originalBoard);
    game.move(move);
    // print(game.ascii);
    if(resultingBoard != ""){
      this.resultingBoard = resultingBoard;
    }else{
      this.resultingBoard = game.generate_fen();
    }
  }

  bool isWhiteMove(){
    return originalBoard.split(' ')[1] == 'w';
  }
}