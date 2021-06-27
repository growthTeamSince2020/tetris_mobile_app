import 'dart:async';
import 'package:flutter/material.dart';
import 'block.dart';
import 'dart:math';

const BLOCKS_X = 10;// ゲームの幅
const BLOCKS_Y = 20;// ゲームの高さ
const GAME_AREA_BORDER_WIDTH = 2.0; // ゲームエリアの枠線の幅
const REFRESH_RATE = 1; //ゲーム速度
const SUB_BLOCK_EDGE_WIDTH = 2.0;


//左ゲーム画面のフィールドを表示
class Game extends StatefulWidget{
  //キーを設定する。
  Game ({Key key}):super(key:key);

  @override
  State createState() => GameState();
}

class GameState extends State{
  double subBlockWidth;
  Duration duration = Duration(seconds: REFRESH_RATE);//ゲームの速度
  GlobalKey _keyGameArea = GlobalKey();
  Block block;
  Timer timer;
  bool isPlaying = false;//ゲーム中のフラグ

  //新しいテトリミノをランダムで作成
  Block getNewBlock(){
    print("新しいテトリミノをランダムで作成");
    int blockType = Random().nextInt(7);
    print(blockType);
    int orientationIndex = Random().nextInt(4);

    switch (blockType){
      case 0:
        return IBlock(orientationIndex);
      case 1:
        return JBlock(orientationIndex);
      case 2:
        return LBlock(orientationIndex);
      case 3:
        return OBlock(orientationIndex);
      case 4:
        return TBlock(orientationIndex);
      case 5:
        return SBlock(orientationIndex);
      case 6:
        return ZBlock(orientationIndex);
      default:
        return null;
    }
  }
  // ゲームスタート準備
  void startGame(){
    print("ゲーム開始");
    isPlaying = true;
    // GlobalKeyを使い、ゲームエリアの現在のcontextにアクセス
    // findRenderObjectでレンダリングされたゲームエリアのオブジェクトを取得できる
    RenderBox renderBoxGame = _keyGameArea.currentContext.findRenderObject();

    // 利用するゲームエリアは、ゲームエリアの枠線の幅を含まない
    subBlockWidth =(renderBoxGame.size.width -GAME_AREA_BORDER_WIDTH * 2) / BLOCKS_X;
    block = getNewBlock();
    //300ミリ秒毎にonPlay(コールバック)を呼び出す
    timer = Timer.periodic(duration, onPlay);
  }
  //ゲーム停止
  void endGame(){
    print("ゲーム終了");
    isPlaying = false;
    timer.cancel();
  }

  //timer引数は必須だが別に使わなくてもいい。
  void onPlay(Timer timer){
    //flutterがブロックの位置と状態が変化したことを認識するため、setStateを呼び出す
    setState(() {
      //ブロックを下に移動させる
      block.move(BlockMovement.DOWN);
    });
  }

  Widget getPositionedSquareContainer(Color color, int x, int y){
    print("color: $color,x: $x,y: $y");
    return Positioned(

      //ビクセル座標(絶対座標)
      left: x * subBlockWidth,
      top: y * subBlockWidth,
      child: Container(
        width: subBlockWidth - SUB_BLOCK_EDGE_WIDTH,
        height: subBlockWidth - SUB_BLOCK_EDGE_WIDTH,
        decoration: BoxDecoration(
          color: color,
          // BorderまたはBoxDecotationを描画するときに使う形状。circle（円）とrectangle（長方形）が選べる
          shape: BoxShape.rectangle,
          borderRadius: BorderRadius.all(const Radius.circular(3.0)),
        ),
      ),
    );
  }
  // ブロックを描画する
  //TODO：subBlocksにPositionedの要素を入れて表示されると、ブロックが表示されない不具合改修（だだ配列に詰めないでブロックを表示するとちゃんと表示される）

  // ignore: missing_return
  Widget drawBlocks(){
    // 初期化
    if(block == null) return null;
    // サブブロックは、配置可能なWidgetのリストとして宣言する
    print("block : $block");
    List<Positioned> subBlocks = [];
    // ブロックを作る＝各サブブロックをループし、それぞれをコンテナに変換する
    block.subBlocks.forEach((subBlock){
      subBlocks.add(
          getPositionedSquareContainer(
        //絶対座標にする（サブブロックの座標はブロックの相対位置なのでそれぞれ足す）
        subBlock.color, subBlock.x + block.x, subBlock.y + block.y));
      return Stack(children: subBlocks,);
    });

    // TODO: 削除予定　下のreturn Stack();
    // return Stack(
    //   children: <Widget>[
    //     Positioned(
    //       left: subBlockWidth,
    //       top: subBlockWidth,
    //       width: subBlockWidth - SUB_BLOCK_EDGE_WIDTH,
    //       height: subBlockWidth - SUB_BLOCK_EDGE_WIDTH,
    //       child: Container(color: Colors.yellow,),
    //     ),
    //     Positioned(
    //       left: 100.0,
    //       top: 100.0,
    //       right: 100.0,
    //       bottom: 200.0,
    //       child: Container(color: Colors.green,),
    //     ),
    //   ],
    // );
  }

  @override
  Widget build(BuildContext context){
    //AspectRatioを使うことでwidgetのアスペクト比を一定に保つことができる
    return AspectRatio(
      aspectRatio: BLOCKS_X / BLOCKS_Y,//高さに対する幅の比率
    // child  単一のウィジットをとります。 Containerは子のサイズやpadding,marginなどの設定ができる。
      child: Container(
        key: _keyGameArea,// ゲームエリアの鍵
        //BoxDecorationのクラスには、ボックスを描画するためのさまざまな方法を提供します。
        decoration: BoxDecoration(
          color: Colors.indigo[800],
          border:  Border.all(
            width: 2.0,
            color: Colors.white
          ),
         //すべての範囲の border を作るクラス　radiusは半径の意 circularは円形の意
         borderRadius: BorderRadius.all(Radius.circular(10.0))//すべての範囲の border を作るクラス　radiusは半径の意
        ),
        child: drawBlocks(),
      ),
    );
  }
}