import 'package:flutter/material.dart';
import 'package:tetris_mobile_app/next_block.dart';

//importしている「material.dart」は、マテリアルデザインのUIがまとめられたパッケージです。
import 'score_bar.dart';
import 'game.dart';

//Widget：FlutterのUIを構築しているパーツのことをWidget
// コンストラクタでrunApp関数を呼び出し
// runAppメソッドは引数のwidgetをスクリーンにアタッチする
void main() => runApp(MyApp());

// MyApp： 自分で作成したWidget
class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Tetris(),
    );
  }
}

// StatefulWidgetはbuildメソッドを持たず、createStateメソッドを持ち、これがStateクラスを返す
class Tetris extends StatefulWidget {
  //　createState()ビルド後に呼ばれるメソッドで必須
  // 　型はState
  @override
  State createState() => _TetrisState();
}

// 「_」をつけるとプライベートになる
class _TetrisState extends State {
  // Gameエリアのウィジェットにアクセスするためグローバルキーを使う
  // ※GameStateをパブリッククラスにし、keyを受け入れるコンストラクタを作っておくこと。
  GlobalKey<GameState> _keyGame = GlobalKey();
  // build()：MaterialAppで画面のテーマ等を設定できる
  @override
  Widget build(BuildContext context) {
    // Scaffold： マテリアルデザイン用Widget
    return Scaffold(
      //AppBar： アプリケーションバー用Widget
      appBar: AppBar(
        //上タイトル
        title: Text('tetris'),
        centerTitle: true,
        backgroundColor: Colors.purple,
      ),
      body: SafeArea(//SafeArea を使用すると OS に関わらず適切な領域にウィジェットを収めてくれます
        //ボディ部の画面
        child: Column(
          children: [
            // 全てのWidgetを一つのファイルに入れると面倒になる。
            // 必要なWidgetをでばっくで見つけることも難しくなる。
            // なので、別ファイルにクラスを宣言します。
            // ScoreBarクラスはインジケータを表示するWidgetです。
            ScoreBar(), //スコア表示
            Expanded(
              //残りの部分
              child: Center(
                //垂直水平方向に中央寄せ
                child: Row(
                  //縦に分割したいときはRowを使う
                  crossAxisAlignment: CrossAxisAlignment.start,
                  //垂直方法の開始位置にそろえる 水平ならmainAxisAlignment
                  children: [
                    //残りの部分を分割するので、Flexibleを使う
                    Flexible(
                      //左画面
                      flex: 3,
                      child: Padding(
                          padding: EdgeInsets.fromLTRB(10.0, 10.0, 5.0, 10.0),
                          child: Game(key:_keyGame)),//ゲームwidgetに置き換える。グローバルキーをゲームのコンストラクターに渡す。
                    ),
                    Flexible(
                      //右画面
                      flex: 1,
                      child: Padding(
                        padding: EdgeInsets.fromLTRB(5.0, 10.0, 10.0, 10.0),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            NextBlock(),
                            SizedBox(height: 30,), //余白
                            ElevatedButton(
                              //RaisedButtonが非推奨なのでElevatedButton
                              child: Text(
                                // グローバルキーを使って、GameStateにアクセスする
                                // isPlaying変数には、gamestateのcurrentStateでアクセスする
                                _keyGame.currentState != null
                                    && _keyGame.currentState.isPlaying ////ゲーム中のフラグ
                                    ? 'End': 'Start',
                                style: TextStyle(
                                    fontSize: 18,
                                    color: Colors.grey[200],
                                ),
                              ),
                              onPressed: () {
                                //Flutterにボタンを再描画させるため、setStateを使う
                                setState(() {
                                  // グローバルキーを使って、GameStateにアクセスする
                                  _keyGame.currentState != null
                                      && _keyGame.currentState.isPlaying
                                      ? _keyGame.currentState.endGame()
                                      : _keyGame.currentState.startGame();
                                });

                              },
                            )
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
      backgroundColor: Colors.deepPurpleAccent, //枠というか全体の背景色
    );
  }
}

// widegetのツリー
//
// MyApp
// ↓
// MaterrialApp
// ↓
// Scaffold