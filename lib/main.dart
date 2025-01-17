import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart'; // bloc
import 'package:player/service/Msg.dart';
import 'package:player/service/http_client.dart';
import './bloc/counter_bloc.dart'; // bloc
import './service/http_service.dart';
import 'data/cache_data.dart';
import 'service/local_storage.dart';
import './service/http_client.dart';
import './utils/device_util.dart';
import './resource/cache_isolate.dart';
import './utils/network_util.dart';
import './utils/log_my_util.dart';
import './service/http_upgrade.dart';
import './global_config.dart';
import './model/client_action.dart';
import './model/client_log.dart';
import './config/config.dart';
import './splash_page.dart';
import 'package:package_info/package_info.dart';

void main() async {
  //0.自身版本
  PackageInfo packageInfo = await PackageInfo.fromPlatform();
  VERSION = packageInfo.version;
  print("version:${VERSION}");
  //1.设备信息
  getDeviceInfo();
  //2.获取后台信息
  await startInit();
  //3.启动页
  await startSplash();
  //4.版本检测
  HttpUpgrade.getVersion();
  //5.自动登录
  autoLogin();
}

void autoLogin() async {
  //1.读取本地信息，确定登录模式。
  me=LocalStorage.getUserMe();
  if(null!=me&&null!=me.userId){
    me.isLogin=false;
    HttpClientUtils.login(me).then((onValue){
      if(Msg.SUCCESS ==onValue.code){
        me=onValue.object;
        LocalStorage.setUserMe(me);
        me.isLogin=true;
      }
    });
  }else{
    me.deviceId=DeviceId;
    HttpClientUtils.guest(me).then((onValue){
      if(Msg.SUCCESS ==onValue.code){
        me=onValue.object;
        me.isLogin=true;
      }
    });
  }
}

Future startSplash() async {
  runApp(BlocProvider<CounterBloc>(
    bloc: CounterBloc(),
    child: BlocProvider(child: APPStartup(), bloc: CounterBloc()),
  ));
}

Future startInit() async {
  //1.读取本地信息；
  await init().then((isReady) {
    //2.连接服务器
    httpConnectServer();
    //3.启动worker线程；P2P只用
  //  const period = const Duration(seconds: 3);
  //  CacheIsolate.init();

    searchVodKeyWordSet.addAll(searchHistoryList);
  });
}

//1.读取本地信息,并检查完整性，是否需要重下载；
Future init() async {
  initLocalIp();
  await LocalStorage.init().then((isRead) {
    HttpService hs = HttpService();
    hs.ready();
    hs.readyDirServer();
  });
}
//1.读取本地信息,并检查完整性，是否需要重下载；

Future httpConnectServer() async {
  try {
    await HttpClientUtils.init().then((isReady) {
      print("HttpClient.init() finished");
    });
  } catch (e) {
    print(e);

    ClientLog cl = new ClientLog("main.dart|connectServer()|$e", "error");
    HttpClientUtils.logReport(cl);
  }
}

class APPStartup extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    ClientAction ca =
        new ClientAction(10, "APPStartup", 0, "", 0, "", 3, "startup");
    HttpClientUtils.actionReport(ca);

    final CounterBloc _counterBloc = BlocProvider.of<CounterBloc>(context);
    return BlocBuilder(
      bloc: _counterBloc,
      builder: (BuildContext context, Map theme) {
        return MaterialApp(
          //title: "p2play",
          // theme: ThemeData(backgroundColor: Colors.white),
//          theme: ThemeData(
//            primarySwatch: Colors.blue,
//          ),
          theme: GlobalConfig.themeData,
          debugShowCheckedModeBanner: false,
          home: new SplashPage(),
        );
      },
    );
  }
}
