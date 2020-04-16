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