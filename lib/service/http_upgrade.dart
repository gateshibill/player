import 'package:http/http.dart' as http;
import '../config/config.dart';
//import 'package:url_launcher/url_launcher.dart';
import '../data/cache_data.dart';
import 'package:flutter/material.dart';
import 'package:ini/ini.dart';
import 'package:gbk2utf8/gbk2utf8.dart';
/**
 * source:get,report,update,del,
 */
class HttpUpgrade {

  static Future getVersion() async {
    print("getVersion : $GET_VERSION_URL");
    try {
      var response = await http.get(GET_VERSION_URL);
      if(response.statusCode!=200){
        print("fail to getVersion!");
      }
      String data = gbk.decode(response.bodyBytes);
      print("response.body:data");
      Config config= Config.fromString(data);

      latestVersion = config.get("apk", "version");
      downlaodLink=config.get("apk", "downlaodLink");
      description=config.get("apk", "description");

      print("version:$latestVersion");
      print("downlaodLink:$downlaodLink");
      print("description:$description");

      return latestVersion;
    } catch (e) {
      print("fail to getVersion()" + e.toString());
      return null;
    }
    return null;
  }

  static showUpgrade(BuildContext context) async {
    getVersion().then((onValue) {
      latestVersion = onValue;
      print("latestVersion:$latestVersion");
      if (null == latestVersion || latestVersion == VERSION) {
        print("this is latest verson");
        return;
      }
      //HttpUpgrade.launchURL();
     // return;
      showDialog(
        // 设置点击 dialog 外部不取消 dialog，默认能够取消
        barrierDismissible: false,
        context: context,
        builder: (context) => AlertDialog(
          title: Text('发现最新版本:$latestVersion'),
          titleTextStyle: TextStyle(color: Colors.purple),
          // 标题文字样式
          content: Text('当前版本:$VERSION,升级体验更多功能！'),
          contentTextStyle: TextStyle(color: Colors.green),
          // 内容文字样式
          //backgroundColor: CupertinoColors.white,
          elevation: 8.0,
          // 投影的阴影高度
          semanticLabel: 'Label',
          // 这个用于无障碍下弹出 dialog 的提示
          shape: Border.all(),
          // dialog 的操作按钮，actions 的个数尽量控制不要过多，否则会溢出 `Overflow`
          actions: <Widget>[
            FlatButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text('下次再说')),
             //点击关闭 dialog，需要通过 Navigator 进行操作
            FlatButton(
                onPressed: () {
                  Navigator.of(context).pop();
                  HttpUpgrade.launchURL();
                },
                child: Text('现在升级')),
          ],
        ),
      );
    });
  }

  static launchURL() async {
    print("DOWNLOAD_URL:$downlaodLink");
//    if (await canLaunch(downlaodLink)) {
//      await launch(downlaodLink);
//    } else {
//      throw 'Could not launch $downlaodLink';
//    }
  }
}
