import 'package:flutter/material.dart';

//次のテトリミノを表示する。
class NextBlock extends StatefulWidget {
  @override
  State createState() => _NextBlockState();
}

class _NextBlockState extends State{
  @override
  Widget build(BuildContext context){
    return Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(5),
          color:  Colors.white,
        ),
        width: double.infinity,//使用可能な最大幅
        padding: EdgeInsets.all(5.0),//全方向に余白を設定する
        child: Column(//領域をたてに3つ分ける
          mainAxisSize: MainAxisSize.max,//できるだけ小さくなろうとする
          children: [
            Text( //１つ目の領域
              'Next',
              style: TextStyle(
                fontWeight: FontWeight.bold,//文字の太さを調整
              ),
            ),
            SizedBox(height: 5,), //２つ目の領域（１つ目と３つ目のスキマ）
            AspectRatio( //３つ目の領域（ここに次のブロックを表示する
              aspectRatio: 1, //正方形にする
              child: Container(
                color: Colors.indigo[600],
              ),
            ),
          ],
        )
    );
  }
}