import 'package:flutter/material.dart';
import 'package:graphview/GraphView.dart';
import 'package:provider/provider.dart';
import 'package:the_chess_engine/src/chess_board/chess_board.dart';
import 'package:the_chess_engine/src/chess_opening_directory/chess_opening_directory.dart';
import '/src/chess/chess.dart';

class ChessMap extends StatefulWidget {

  const ChessMap({Key? key}) : super(key: key);
  @override
  State<StatefulWidget> createState() => ChessMapState();

}

class ChessMapState extends State<ChessMap> {
  SugiyamaConfiguration builder = SugiyamaConfiguration()
    ..orientation = SugiyamaConfiguration.ORIENTATION_LEFT_RIGHT
    ..levelSeparation = 60
    ..nodeSeparation = 20
  ;

  Widget build(BuildContext context) {

    return Consumer<ChessOpeningDirectory>(
      builder:(context, cod, child) => Stack(
        children: [
          const SizedBox.expand(
            child: DecoratedBox(decoration: BoxDecoration(color: Color.fromRGBO(240, 217, 181, 1.0)),),
          ),

          InteractiveViewer(
            constrained: false,
            boundaryMargin: EdgeInsets.all(250),
            minScale: 0.001,
            maxScale: 5.6,
            // clipBehavior: Clip.none,
            child: GraphView(
              graph: cod.getGraph(),
              algorithm: SugiyamaAlgorithm(builder),
              builder: (Node node) {

                return rectangleWidget(cod, node.key?.value as String);
              },
              paint: Paint()
                ..color = Colors.black
              ,
            )



            // Container(
            //   width: 1000,
            //   height: 1000,
            //   // margin: const EdgeInsets.all(10),
            //   child:
            //   Stack(children: [
            //     Container(decoration: const BoxDecoration(color: Color.fromRGBO(240, 217, 181, 1.0)),),
            //     Consumer<ChessOpeningDirectory>(
            //         builder: (context, cod, child) => GraphView(
            //         graph: cod.getGraph(),
            //         algorithm: SugiyamaAlgorithm(builder),
            //         builder: (Node node) {
            //
            //           return rectangleWidget(node.key?.value as String);
            //         },
            //       )
            //     ),
            //
            //   ],
            //   ),
            //
            // ),
          ),

        ],
      ),
    );
  }

  Widget rectangleWidget(ChessOpeningDirectory cod, String pos) {
    return InkWell(
      onTap: () {
        cod.setPathToPos(pos);
      },
      child: Container(
          padding: EdgeInsets.all(1),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(5),
            boxShadow: [
              BoxShadow(color: cod.isPosInPath(pos)?Colors.red:_boardColor(pos), spreadRadius: 1),
            ],
          ),
          child: StaticChessBoard(pos, 75, 75),
    ));
  }

  Color _boardColor(String fen){
    var toMove = fen.split(' ')[1];
    return toMove=='b'? Colors.black : Colors.white;
  }

}


// Consumer<ChessOpeningDirectory>(
// builder: (context, cod, child) => GraphView(
// graph: cod.getGraph(),
// algorithm: SugiyamaAlgorithm(builder),
// builder: (Node node) {
// var a = node.key?.value as int;
// return rectangleWidget(a);
// },
// )
// ),
