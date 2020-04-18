import 'dart:ui';


import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:player/common/widget_common.dart';

class UiUtil {
  static void showToast(String value) {
    Fluttertoast.showToast(
        msg: value,
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.CENTER,
        timeInSecForIos: 1,
        backgroundColor: Color(0x88000000),
        textColor: Colors.white,
        fontSize: 14.0);
  }
  static isPad(){
    num screeHeight = window.physicalSize.height / window.devicePixelRatio;
    num screenWidth = window.physicalSize.width / window.devicePixelRatio;
    if (screenWidth > screeHeight) {
      // 如果是横屏的情况需要改变基准
      if(window.physicalSize.height / window.devicePixelRatio>=768){
        return true;
      }
    } else {// 竖屏
      if(window.physicalSize.width / window.devicePixelRatio>=768){
        return true;
      }
    }

    return false;
  }
}
defaultCacheNetworkImage(String url) {
  return new CachedNetworkImage(
    imageUrl: url,
    placeholder: (context, url) => cachPlaceHolder(),
    errorWidget: (context, url, error) => cachPlaceHolder(),
  );
}

//  Widget carousel() {
//    return new Container(
//        height: 180.0,
//        margin: new EdgeInsets.only(top: 0.0, bottom: 0),
//        padding: const EdgeInsets.only(top: 0.0),
//        child: CarouselSlider(
//          height: 180.0,
//          viewportFraction: 1.0,
//          autoPlay: true,
//          items: [
//            'http://sportslive.hongxiuba.com/pic/carousel/ad1.png?1',
//            'http://sportslive.hongxiuba.com/pic/carousel/ad2.png?2',
//            'http://sportslive.hongxiuba.com/pic/carousel/ad3.png',
//            'http://sportslive.hongxiuba.com/pic/carousel/ad4.png',
//            'http://sportslive.hongxiuba.com/pic/carousel/ad6.png',
//            //'http://sportslive.hongxiuba.com/pic/carousel/ad1.png',
//            'http://sportslive.hongxiuba.com/pic/carousel/chinafoot.png',
//            // 'http://sportslive.hongxiuba.com/pic/carousel/ad2.png',
//          ].map((i) {
//            return Builder(
//              builder: (BuildContext context) {
////                return new FlatButton(
////                  onPressed: () {
////                    Navigator.of(context)
////                        .push(new MaterialPageRoute(builder: (context) {
////                      return new LiveDetail(vod: channelList[2][3]);
////                    }));
////                  },
//                //child:
//                return new CachedNetworkImage(
//                  imageUrl: i,
//                  placeholder: (context, url) => cachPlaceHolder(),
//                  errorWidget: (context, url, error) => new Icon(Icons.error),
//                  // ),
//                );
//              },
//            );
//          }).toList(),
//        ));
//  }