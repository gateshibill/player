import 'package:flutter_ijkplayer/flutter_ijkplayer.dart';
import 'package:flutter/material.dart';
import 'package:player/data/cache_data.dart';
import 'package:player/model/media_model.dart';
import 'package:player/model/vod_model.dart';
import 'package:player/service/local_storage.dart';


class PlayerController{
  //Player({Key key, @required this.mc});
  IjkMediaController mc;
  StatefulWidget widget;

  play(MediaModel vod){
    mc.setNetworkDataSource(vod.getPlayUrl(), autoPlay: true);
   // widget.setState(() {});
    currentPlayMedia=vod;
    LocalStorage.savaCurrentMedia(currentPlayMedia);
  }
}