import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:the_chess_engine/src/chess/chess.dart';
import 'package:the_chess_engine/src/chess_opening_directory/chess_opening_directory.dart';
import 'package:the_chess_engine/src/chess_opening_directory/cod_map.dart';
import '../chess_board/chess_board.dart';

class HomePage extends StatelessWidget {

  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context ) {
    ChessOpeningDirectory cod = ChessOpeningDirectory('test', ChessColor.WHITE);

    return Scaffold(
      appBar: AppBar(title: const Text("The Chess Engine"),),
      body: SafeArea(

        child: Center(

          child: Container(
            margin: const EdgeInsets.all(50),
            decoration: const BoxDecoration(
              // color: Colors.lightBlueAccent,
            ),
            child: ChangeNotifierProvider(
              create: (context) => cod,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                mainAxisSize: MainAxisSize.max,
                children: [
                  const Expanded(
                    child: Center(
                      child: AspectRatio(aspectRatio: 1,
                      child: ChessMap(),
                    ),
                  )),
                  Expanded(
                    child: Center(
                      child: Column(
                        children: [
                          const Expanded(
                            child: Center(
                              child: AspectRatio(
                                aspectRatio: 1,
                                child: ChessBoard(),
                              ),
                            ),
                          ),
                          ElevatedButton(
                              onPressed: ()=>{print("test")},
                              child: const Text("Register Move")

                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            )
          ),
        ),
      ),
    );
  }
}