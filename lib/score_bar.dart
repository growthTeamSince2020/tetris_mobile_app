import 'package:flutter/material.dart';
//material.dartのインポート 一般的に使用されるFlutterウィジェットのカタログのflutter.dev/widgets。material.io/design 材料設計への導入のため。

// スコアバーの表示
//スコアは頻繁に更新されるため、ScoreBarはStatefulWidgetである必要があります。
class ScoreBar extends StatefulWidget{
  @override
  State createState() => _ScoreBarState();
}

class _ScoreBarState extends State{
  @override
  Widget build(BuildContext context){
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Colors.indigo[800], Colors.indigo[400], Colors.indigo[800]],
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Padding(padding: EdgeInsets.all(10.0),
            child: Text(
              'Score : 0',
              style:TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
