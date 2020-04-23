import 'package:flutter/material.dart';
import 'package:flutter_ijkplayer/flutter_ijkplayer.dart';
import 'package:player/data/cache_data.dart';
import 'package:player/utils/ui_util.dart';
import 'media_page.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_ijkplayer/flutter_ijkplayer.dart';

Widget refreshButton(var myselsf) {
  return new Center(
    child: FlatButton(
      onPressed: () {
        myselsf.handleRefresh();
      },
//      child: Text("刷新", style: new TextStyle(color: Colors.lightBlue))));
      child: new Center(child: new Image.asset("assets/ball_loading.gif") //
          ),
    ),
  );
}

Widget vipValidate() {
if(!me.vipExpire.isAfter(DateTime.now())){
  UiUtil.showToast('您的VIP已到期');
}
}


Widget cachPlaceHolder() {
  return new Container(
    child: new Center(
      child: new CircularProgressIndicator(strokeWidth: 1.0),
    ),
    width: 40.0,
    height: 25.0,
  );
}

Widget play(BuildContext context,IjkMediaController homeMediaController, String posterUrl,
    [String errorUrl = "assets/images/" + 'ad4.png']) {
  print("posterUrl:${posterUrl}");
  return new Container(
    height: 210.0,
  //  margin: new EdgeInsets.only(top: 0.0, bottom: 0),
   // padding: const EdgeInsets.only(top: 0.0),
    //  alignment:Alignment.center,
    child: IjkPlayer(
        mediaController: homeMediaController,
        statusWidgetBuilder: (
          BuildContext context,
          IjkMediaController controller,
          IjkStatus status,
        ) {
          if (status == IjkStatus.error) {
            return Center(
             // height:210,
             // alignment:Alignment.center,
             // padding: const EdgeInsets.only(top: 0.0),
              child: new Image.asset(
                errorUrl,
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height,
                fit: BoxFit.cover,
              ),
            );
          }
//          else if (status == IjkStatus.playing) {
//           // return Container();
//          }
         else if (status == IjkStatus.preparing||status==IjkStatus.prepared||status==IjkStatus.noDatasource) {
         // else if (status !=IjkStatus.playing) {
            return Center(
              //Expanded(
              // flex: 1,
              child: new AspectRatio(
                aspectRatio: 3.5 / 2,
                // width: 130,
                //height: 110,
                // child: Image.network("http://www.90oo.com/bbs88/attachments/month_1511/151122205405eb94f0e894031d.jpg"),
                child: new CachedNetworkImage(
                  imageUrl: posterUrl,
                  errorWidget: (context, url, error) =>
                      new Icon(Icons.autorenew),
                  fit: BoxFit.cover,
                ),
              ),
             // margin: new EdgeInsets.only(top: 6.0, bottom: 6.0),
            );
          }
        }),
  );
}

Widget _buildStatusWidget(
  BuildContext context,
  IjkMediaController controller,
  IjkStatus status,
) {
  if (status == IjkStatus.error) {
    return Center(
      child: new Image.asset(
        "assets/images/" + 'ad6.png',
        //scale: 2.0,
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        fit: BoxFit.cover,
      ),
    );
  } else if (status != IjkStatus.playing) {
    return Center(
      child: new Image.asset(
        "assets/images/" + 'ad4.png',
        //scale: 2.0,
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        fit: BoxFit.cover,
      ),
    );
  }
}
