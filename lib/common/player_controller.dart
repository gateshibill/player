import 'package:flutter_ijkplayer/flutter_ijkplayer.dart';
import 'package:flutter/material.dart';


class PlayerController{
  //Player({Key key, @required this.mc});
  IjkMediaController mc;
  StatefulWidget widget;

  play(String playUrl,var ex){
    mc.setNetworkDataSource(playUrl, autoPlay: true);
   // widget.setState(() {});
  }
}