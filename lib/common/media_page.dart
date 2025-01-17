import 'package:flutter/material.dart';
import 'package:flutter_ijkplayer/flutter_ijkplayer.dart';
import 'package:player/data/cache_data.dart';
import 'package:player/player/serial_detail.dart';
import 'package:player/video/serial_page.dart';
import '../model/media_model.dart';
import '../player/video_detail.dart';
import '../player/movie_player.dart';
import '../player/anchor_player.dart';
import '../common/html_page.dart';
import '../player/live_detail.dart';
 class MediaPage extends StatelessWidget {
  MediaPage({Key key, @required this.mediaModel,this.context,this.mediaController});
  IjkMediaController mediaController;
  MediaModel mediaModel;
  BuildContext context;
  @override
  Widget build(BuildContext context) {
   switch (mediaModel.getMediaType()){
     case MediaType.Video:
       currentPlayMedia=mediaModel;//为了显示标题
       return VideoDetail(vod:mediaModel, context:this.context,mediaController:this.mediaController);
       break;
     case MediaType.Topic:
       return HtmlPage(mediaModel:mediaModel, context:this.context);
       break;
     case MediaType.Channel://电视频道直播
       currentPlayMedia=mediaModel;//为了显示标题
       return LiveDetail(vod:mediaModel, context:this.context,mediaController:this.mediaController);
       break;
     case MediaType.Anchor:
       //return LiveDetail(mediaModel:mediaModel);
       break;
     case MediaType.Program:
       break;
     case MediaType.Serial:
       currentPlayMedia=mediaModel;//为了显示标题
       return SerialDetail(vod:mediaModel, context:this.context);
       break;
   }
  }
}

