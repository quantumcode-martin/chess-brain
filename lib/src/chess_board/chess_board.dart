import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../chess/chess.dart';
import '/src/chess_opening_directory/chess_opening_directory.dart';
import 'package:provider/provider.dart';

class ChessBoard extends StatefulWidget {

  const ChessBoard({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => ChessBoardState();
}

class ChessBoardState extends State<ChessBoard> {
  late final double tileSize = MediaQuery.of(context).size.width / 8.0;
  final lightColor = const Color.fromRGBO(240, 217, 181, 1.0);
  final darkColor = const Color.fromRGBO(181, 136, 99, 1.0);



  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(10),
      child: Consumer<ChessOpeningDirectory>(
        builder: (context, cod, child)=> Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            ...List.generate(
                8,
                (y) => Expanded(
                    child:Row(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        ...List.generate(
                            8,
                            (x) => Expanded(
                              child:Container(
                                decoration: BoxDecoration(
                                  color: buildCellColor(x, y),
                                ),
                                child: Stack(
                                  children: [
                                    Center(child: Text(toSquare(x, y), style: TextStyle(color: buildCellColor(x-1, y).withAlpha(75)),)),
                                    buildDragTarget(x, y),
                                    // Container(alignment: Alignment.center, child: _buildChessPiece(x, y)),
                                  ],
                                )
                              )
                              ),

                              // width: tileSize,
                              // height: tileSize,
                              )
                      ],
                    ))).reversed
          ],
        ),
      ),
    );
  }

  void showDragOptions() {
    String a  = "";
  }
  Color buildCellColor(int x, int y) => (x+y).isEven ? darkColor : lightColor;

  DragTarget<MovingPiece> buildDragTarget(int x, int y){
    return DragTarget<MovingPiece>(

      onAccept: (movingPiece){

        setState((){
          context.read<ChessOpeningDirectory>().applyMove({
            'from': movingPiece.position,
            'to': toSquare(x, y),
            'promotion': 'q',
              });

        });

        },
        onWillAccept: (piece) => true,
        builder: (context, data, rejects) => Container(alignment: Alignment.center, child: _buildChessPiece(x, y)),

    );
  }




  Widget? _buildChessPiece(int x, int y) {
    final Piece? piece = context.read<ChessOpeningDirectory>().currentChessBoard.get(toSquare(x, y));
    if(piece != null)
      {
        MovingPiece movingPiece = MovingPiece(toSquare(x, y), piece);

        final boardPiece = MouseRegion(
          cursor: SystemMouseCursors.grab,
          child: Container(
          alignment: Alignment.center,
            // decoration: BoxDecoration(color: Colors.red),
            constraints: const BoxConstraints(maxWidth: 100, maxHeight: 100),
        child: FractionallySizedBox(

          heightFactor: 0.66,
          widthFactor: 0.66,
          child: SvgPicture.asset(
                // "images/chess_pieces/black_b.svg",
                piece.fileName,
                width: 80,
                height: 80,

        )
        )

        ));
        return GestureDetector(
          child: piece.color != context.read<ChessOpeningDirectory>().currentChessBoard.turn ? boardPiece : Draggable<MovingPiece>(
            data: movingPiece,
            feedback: boardPiece,
            childWhenDragging: const SizedBox.shrink(),
            dragAnchorStrategy: (draggable, context, position) => const Offset(50,50),
            onDragStarted: test,
            // maxSimultaneousDrags: ()=>1,
            child: boardPiece,
          ),

        );
      }
    return null;

  }
  
}

class StaticChessBoard extends StatelessWidget {
  final lightColor = const Color.fromRGBO(240, 217, 181, 1.0);
  final darkColor = const Color.fromRGBO(181, 136, 99, 1.0);

  late final Chess position;
  final size_x;
  final size_y;

  StaticChessBoard(fenPosition, this.size_x, this.size_y, {Key? key}) : super(key: key)
  {
    position = Chess.fromFEN(fenPosition);
  }


  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(1),
      width: size_x,
      height: size_y,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          ...List.generate(
              8,
                  (y) => Expanded(
                  child:Row(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      ...List.generate(
                        8,
                            (x) => Expanded(
                            child:Container(
                                decoration: BoxDecoration(color: buildCellColor(x, y)),

                                 child:_buildChessPiece(x, y),
                                    // Container(alignment: Alignment.center, child: _buildChessPiece(x, y)),
                                )
                            )
                        ),

                        // width: tileSize,
                        // height: tileSize,

                    ],
                  ))).reversed
        ],
      ),
    );
  }


  Widget? _buildChessPiece(int x, int y) {
    final Piece? piece = position.get(toSquare(x, y));
    if(piece != null)
    {
      MovingPiece movingPiece = MovingPiece(toSquare(x, y), piece);

      return Container(
              alignment: Alignment.center,
              // decoration: BoxDecoration(color: Colors.red),
              constraints: const BoxConstraints(maxWidth: 100, maxHeight: 100),
              child: FractionallySizedBox(

                  heightFactor: 0.66,
                  widthFactor: 0.66,
                  child: SvgPicture.asset(
                    // "images/chess_pieces/black_b.svg",
                    piece.fileName,
                    width: 80,
                    height: 80,

                  )
              )

          );
    }
    return null;

  }

  Color buildCellColor(int x, int y) => (x+y).isEven ? darkColor : lightColor;

}

String toSquare(int x, int y) => "${String.fromCharCode(97+x)}${y+1}";

void test() {}

class MovingPiece {
  final String position;
  final Piece piece;

  MovingPiece(this.position, this.piece);
}