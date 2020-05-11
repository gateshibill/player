import 'package:flutter/material.dart';
import 'package:player/data/cache_data.dart';
import 'package:player/player/serial_detail.dart';
import 'package:player/video/serial_page.dart';
import '../model/media_model.dart';
import '../player/video_detail.dart';
import '../player/movie_player.dart';
import '../player/anchor_player.dart';
import '../common/html_page.dart';
import '../moive/details/live_detail.dart';
 class MediaPage extends StatelessWidget {
  MediaPage({Key key, @required this.mediaModel,this.context});
  MediaModel mediaModel;
  BuildContext context;
  @override
  Widget build(BuildContext context) {
   switch (mediaModel.getMediaType()){
     case MediaType.Video:
       return VideoDetail(vod:mediaModel, context:this.context);
       break;
     case MediaType.Topic:
       return HtmlPage(mediaModel:mediaModel, context:this.context);
       break;
     case MediaType.Channel:
       return LiveDetail(vod:mediaModel, context:this.context);
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

