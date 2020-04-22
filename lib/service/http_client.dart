import 'package:dio/dio.dart';
import 'dart:convert';
import '../model/source_model.dart';
import '../model/metadata_model.dart';
import '../model/vod_model.dart';
import '../model/peer_action.dart';
import 'package:http/http.dart' as http;
import '../config/config.dart';
import '../model/client_action.dart';
import '../data/cache_data.dart';
import 'date_util.dart';
import 'download_service.dart';
import 'local_storage.dart';
import '../utils/log_my_util.dart';
import '../model/channel_model.dart';
import '../model/program_model.dart';
import '../model/client_log.dart';
import 'package:http_server/http_server.dart' show VirtualDirectory;
import '../model/user_model.dart';

//import './local_data_provider.dart';
import '../model/anchor_model.dart';
import '../model/stype_model.dart';
import '../model/topic_model.dart';
import '../model/video_context_model.dart'; // 模型
import '../service/service_method.dart'; // 网络请求
import '../model/picture_model.dart';
import '../video/lala_page.dart';

/**
 * source:get,report,update,del,
 */
class HttpClientUtils {
  static var sourceMap = new Map();
  static const String TAG = "HttpClient";

  static Future<bool> init() async {
    try {
      //推荐频道
      await getRcmdChannels(0, 10).then((channelModelList) {
        if (null != channelModelList) {
          tvChannelList[0] = channelModelList;
          for (ChannelModel cm in channelModelList) {
            LocalStorage.saveRcmdChannel(cm);
          }
        } else {
          print("fail to getRcmdChannels");
        }
      });
      //央视频道
      await getChannelList(0, 5, 0, 50).then((channelModelList) {
        if (null != channelModelList) {
          tvChannelList[1] = channelModelList.channelModelList;
          for (ChannelModel cm in sportsChannelList[1]) {
            LocalStorage.saveChannel(cm);
          }
        } else {
          print("fail to getChannelList");
        }
      });
      //体育频道
      await getChannelList(1, 0, 0, 50).then((channelModelList) {
        if (null != channelModelList) {
          tvChannelList[2] = channelModelList.channelModelList;
          for (ChannelModel cm in sportsChannelList[0]) {
            LocalStorage.saveChannel(cm);
          }
        } else {
          print("fail to getChannelList");
        }
      });
      //卫视频道
      await getChannelList(2, 4, 0, 50).then((channelModelList) {
        if (null != channelModelList) {
          tvChannelList[3] = channelModelList.channelModelList;
          for (ChannelModel cm in sportsChannelList[1]) {
            LocalStorage.saveChannel(cm);
          }
        } else {
          print("fail to getChannelList");
        }
      });
      //港澳频道
      await getChannelList(0, 2, 0, 50).then((channelModelList) {
        if (null != channelModelList) {
          tvChannelList[4] = channelModelList.channelModelList;
          for (ChannelModel cm in sportsChannelList[1]) {
            LocalStorage.saveChannel(cm);
          }
        } else {
          print("fail to getChannelList");
        }
      });
      //国际频道
      await getChannelList(0, 3, 0, 50).then((channelModelList) {
        if (null != channelModelList) {
          tvChannelList[5] = channelModelList.channelModelList;
          for (ChannelModel cm in sportsChannelList[1]) {
            LocalStorage.saveChannel(cm);
          }
        } else {
          print("fail to getChannelList");
        }
      });
      //当前热点节目单
      await getHotPrograms().then((programModelList) {
        if (null != programModelList) {
          currentEventProgramlist = programModelList.programModelList;
          for (ProgramModel pm in currentEventProgramlist) {
            //LocalStorage.saveProgram(pm);
          }
        } else {
          print("fail to currentEventProgramlist");
        }
      });
      //精选体育资讯
//      await getTopics(1, 0, 10).then((list) {
//        if (null != list) {
//          topicList = list;
//          for (TopicModel m in topicList) {
//            // LocalStorage.saveTopic(m);
//          }
//        } else {
//          print("fail to getTopics");
//        }
//      });
      //提前加载花絮
      await getLalas(LalaPage.page, 6).then((list) {
        if (null != list) {
          lalas = list;
        } else {
          print("fail to getTopics");
        }
      });

      //央视体育
//      await getChannelList(1, 5, 0, 50).then((channelModelList) {
//        if (null != channelModelList) {
//          sportsChannelList[1] = channelModelList.channelModelList;
//          for (ChannelModel cm in sportsChannelList[1]) {
//            LocalStorage.saveChannel(cm);
//          }
//        } else {
//          print("fail to getChannelList");
//        }
//      });

      //国际频道
//      await getChannelList(1, 3, 0, 50).then((channelModelList) {
//        if (null != channelModelList) {
//          sportsChannelList[3] = channelModelList.channelModelList;
//          for (ChannelModel cm in sportsChannelList[1]) {
//            LocalStorage.saveChannel(cm);
//          }
//        } else {
//          print("fail to getChannelList");
//        }
//      });
      //当前播放节目单
      await getCurrentPrograms(0).then((programModelList) {
        if (null != programModelList) {
          currentProgramlist = programModelList.programModelList;
//          for (ProgramModel pm in currentProgramlist) {
//            LocalStorage.saveProgram(pm);
//          }
        } else {
          print("fail to getPorgramList");
        }
      });
      //当体育总赛事
      await getSportsTypes().then((list) {
        if (null != list) {
          stypeList = list;
//          for (ProgramModel pm in currentEventProgramlist) {
//            //LocalStorage.saveProgram(pm);
//          }
        } else {
          print("fail to getSportsTypes");
        }
      });
      //提前加载热门赛事
      await HttpClientUtils.getLeagueProgramList("热门", 0, 20).then((list) {
        if (null != list) {
          List<ProgramModel> programList = list.programModelList;
          if (programList != null && programList.length > 0) {
            leagueProgramList.addAll(programList);
          }
          LogMyUtil.e("leagueProgramList lengh :${leagueProgramList.length}");
        } else {
          LogMyUtil.e("fail to leagueProgramList");
        }
      });
      //赛事节目单
      await getProgramByEventList(0).then((programModelList) {
        if (null != programModelList) {
          eventProgramlist = programModelList.programModelList;
          for (ProgramModel pm in eventProgramlist) {
            LocalStorage.saveProgram(pm);
          }
        } else {
          print("fail to getPorgramList");
        }
      });
      await getProgramByDayList(0).then((programModelList) {
        if (null != programModelList) {
          commonProgramlist[0] = programModelList.programModelList;
          for (ProgramModel pm in commonProgramlist[0]) {
            LocalStorage.saveProgram(pm);
          }
        } else {
          print("fail to getPorgramList");
        }
      });
      //首页
      await getVodList(100).then((vomeVodList) {
        if (null != vomeVodList) {
          homeVodList = vomeVodList.vodModelList;
          for (VodModel vm in homeVodList) {
            LocalStorage.saveVod(vm, column: 100);
          }
        } else {
          print("fail to get column vod");
        }
      });
      //girl live
//      await getAnchors(0).then((vomeVodList) {
//        if (null != vomeVodList) {
//          anchorList = vomeVodList;
//        } else {
//          print("fail to get column vod");
//        }
//      });
      //movie
      await getVodList(1).then((vomeVodList) {
        if (null != vomeVodList) {
          movieList[1] = vomeVodList.vodModelList;
          for (VodModel vm in movieList[1]) {
            LocalStorage.saveVod(vm, column: 1);
          }
        } else {
          print("fail to get column vod");
        }
      });
      await getSportsVodList(1001).then((vomeVodList) {
        if (null != vomeVodList) {
          sportsPlaybackVodList[0] = vomeVodList.vodModelList;
          for (VodModel vm in sportsPlaybackVodList[0]) {
            LocalStorage.saveVod(vm, column: 1001);
          }
        } else {
          print("fail to get column vod");
        }
      });
      await getSportsVodList(1002).then((vomeVodList) {
        if (null != vomeVodList) {
          sportsPlaybackVodList[1] = vomeVodList.vodModelList;
          for (VodModel vm in sportsPlaybackVodList[1]) {
            LocalStorage.saveVod(vm, column: 1002);
          }
        } else {
          print("fail to get column vod");
        }
      });
      await getSportsVodList(1003).then((vomeVodList) {
        if (null != vomeVodList) {
          sportsPlaybackVodList[2] = vomeVodList.vodModelList;
          for (VodModel vm in sportsPlaybackVodList[2]) {
            LocalStorage.saveVod(vm, column: 1003);
          }
        } else {
          print("fail to get column vod");
        }
      });
      //电视回看节目，足球
      await getSportsVodList(1004).then((vomeVodList) {
        if (null != vomeVodList) {
          sportsPlaybackVodList[3] = vomeVodList.vodModelList;
          for (VodModel vm in sportsPlaybackVodList[3]) {
            LocalStorage.saveVod(vm, column: 1004);
          }
        } else {
          print("fail to get column vod");
        }
      });
      //电视回看节目，电竞
      await getSportsVodList(1005).then((vomeVodList) {
        if (null != vomeVodList) {
          sportsPlaybackVodList[4] = vomeVodList.vodModelList;
          for (VodModel vm in sportsPlaybackVodList[4]) {
            LocalStorage.saveVod(vm, column: 1005);
          }
        } else {
          print("fail to get column vod");
        }
      });
      //提前加载电影
      await HttpClientUtils.getVodList(0).then((list) {
        if (null != list) {
          movieList[0] = list.vodModelList;
        } else {
          LogMyUtil.e("fail to get column vod");
        }
      });
      //提前加载综艺
      await HttpClientUtils.getVodList(3).then((list) {
        if (null != list) {
          movieList[1] = list.vodModelList;
        } else {
          LogMyUtil.e("fail to get column vod");
        }
      });
      return true;
    } catch (e) {
      print(e);
      return false;
    }
  }

  static Future<VodModelList> getVodList(int columnId,
      [int typeId1 = 0,
      int groupId = 0,
      bool isCache = true,
      int page = 0,
      int limit = 30]) async {
    String url =
        "$GET_VODS_URL${columnId.toString()}&typeId1=$typeId1&groupId=$groupId&page=$page&limit=$limit";
    LogMyUtil.e("getVodList() url:${url}");
    try {
      var dio = new Dio();
      final response = await dio.get(url);
      String res = response.data.toString();
      //print("r:" + res);
      String res2Json = json.encode(response.data);
      final Map parsed = json.decode(res2Json);
      String code = parsed["code"];
      List<dynamic> list = parsed["objects"];
      VodModelList vodModelList = VodModelList.fromJson(list);
      List vodList = vodModelList.vodModelList;
//      vodModelList.vodModelList
//          .forEach((vodModel) => print('vodModel ${vodModel.detail()}'));
      if (isCache) {
        DownloadService.downloadVodList(vodList);
      }
      print("getVodList() end");
      return vodModelList;
    } catch (e) {
      print("dio e:" + e.toString());
    }
    return null;
  }

  static Future<VodModelList> getSportsVodList(int columnId,
      [int typeId1 = 0,
      int groupId = 0,
      bool isCache = true,
      int page = 0,
      int limit = 30]) async {
    String url =
        "$GET_SPORTSVODS_URL${columnId.toString()}&typeId1=$typeId1&groupId=$groupId&page=$page&limit=$limit";
    LogMyUtil.e("getSportsVodList() url:${url}");
    try {
      var dio = new Dio();
      final response = await dio.get(url);
      String res = response.data.toString();
      //print("r:" + res);
      String res2Json = json.encode(response.data);
      final Map parsed = json.decode(res2Json);
      String code = parsed["code"];
      List<dynamic> list = parsed["objects"];
      VodModelList vodModelList = VodModelList.fromJson(list);
      List vodList = vodModelList.vodModelList;
//      vodModelList.vodModelList
//          .forEach((vodModel) => print('vodModel ${vodModel.detail()}'));
      if (isCache) {
        DownloadService.downloadVodList(vodList);
      }
      print("getVodList() end");
      return vodModelList;
    } catch (e) {
      print("dio e:" + e.toString());
    }
    return null;
  }

  static Future<ChannelModelList> getChannelList(
      [int type = 0, int groupId = 0, int page = 0, int limit = 10]) async {
    String url =
        "$BASE_SERVER_URL$GET_CHANNELS_URL${type.toString()}&groupId=$groupId&page=$page&limit=$limit";
    LogMyUtil.e("getChannelList() url:${url}");
    try {
      var dio = new Dio();
      final response = await dio.get(url);
      String res = response.data.toString();
    //  print("res:" + res);
      String res2Json = json.encode(response.data);
      final Map parsed = json.decode(res2Json);
      String code = parsed["code"];
      List<dynamic> list = parsed["objects"];
      ChannelModelList channelModelList = ChannelModelList.fromJson(list);
      List channelList = channelModelList.channelModelList;
//      channelList
//          .forEach((vodModel) => print('vodModel ${vodModel.toString()}'));
    //  print("getVodList() end");
      return channelModelList;
    } catch (e) {
      print("dio e:" + e.toString());
    }
    return null;
  }

  static Future getProgramList([int type = 0, bool isCache = true]) async {
    String url = "$GET_PROGRAMS_URL${type.toString()}&page=0&limit=50";
    LogMyUtil.e("getPorgramList() url:${url}");
    try {
      var dio = new Dio();
      final response = await dio.get(url);
      String res = response.data.toString();
     // print("res:" + res);
      String res2Json = json.encode(response.data);
      final Map parsed = json.decode(res2Json);
      String code = parsed["code"];
      List<dynamic> list = parsed["objects"];
      ProgramModelList programModelList = ProgramModelList.fromJson(list);
      List programList = programModelList.programModelList;
//      programList
//          .forEach((vodModel) => print('vodModel ${vodModel.toString()}'));
      if (isCache) {
        //DownloadService.downloadVodList(vodList);
      }
      return programModelList;
    } catch (e) {
      print("dio e:" + e.toString());
    }
  }

  static Future getCurrentPrograms([int day = 0, bool isCache = true]) async {
    LogMyUtil.e("getCurrentPrograms() url:${GET_CURRENT_PROGRAMS_URL}");
    try {
      var dio = new Dio();
      final response = await dio.get(GET_CURRENT_PROGRAMS_URL);
      String res = response.data.toString();
     // print("res:" + res);
      String res2Json = json.encode(response.data);
      final Map parsed = json.decode(res2Json);
      String code = parsed["code"];
      List<dynamic> list = parsed["objects"];
      ProgramModelList programModelList = ProgramModelList.fromJson(list);
      List programList = programModelList.programModelList;
//      programList
//          .forEach((vodModel) => print('vodModel ${vodModel.toString()}'));
      if (isCache) {
        //DownloadService.downloadVodList(vodList);
      }
      return programModelList;
    } catch (e) {
      print("dio e:" + e.toString());
    }
  }

  static Future getHotPrograms([int day = 0, bool isCache = true]) async {
    LogMyUtil.e("getCurrentPrograms() url:${GET_HOT_PROGRAMS_URL}");
    try {
      var dio = new Dio();
      final response = await dio.get(GET_HOT_PROGRAMS_URL);
      String res = response.data.toString();
      //print("res:" + res);
      String res2Json = json.encode(response.data);
      final Map parsed = json.decode(res2Json);
      String code = parsed["code"];
      List<dynamic> list = parsed["objects"];
      ProgramModelList programModelList = ProgramModelList.fromJson(list);

      List programList = programModelList.programModelList;

//      programList
//          .forEach((vodModel) => print('vodModel ${vodModel.toString()}'));

      if (isCache) {
        //DownloadService.downloadVodList(vodList);
      }
      return programModelList;
    } catch (e) {
      print("dio e:" + e.toString());
    }
  }

  static Future getAnchors(int page) async {
    LogMyUtil.e("getAnchors() url:$GET_ANCHORS_URL");
    try {
      var dio = new Dio();
      final response = await dio.get("${GET_ANCHORS_URL}&page=$page&limit=10");
      String res = response.data.toString();
      //print("res:" + res);
      String res2Json = json.encode(response.data);
      final Map parsed = json.decode(res2Json);
      String code = parsed["code"];
      List<dynamic> list = parsed["objects"];
      AnchorModelList anchorModelList = AnchorModelList.fromJson(list);
      return anchorModelList.anchorModelList;
    } catch (e) {
      print("dio e:" + e.toString());
    }
  }

  static Future getProgramByEventList(
      [int page = 0, bool isCache = true]) async {
    String url = "$GET_PROGRAMSBYEVENT_URL&page=$page&limit=30";
    LogMyUtil.e("getProgramByEventList() url:${url}");
    try {
      var dio = new Dio();
      final response = await dio.get(url);
      String res = response.data.toString();
    //  print("res:" + res);
      String res2Json = json.encode(response.data);
      final Map parsed = json.decode(res2Json);
      String code = parsed["code"];
      List<dynamic> list = parsed["objects"];
      ProgramModelList programModelList = ProgramModelList.fromJson(list);

      List programList = programModelList.programModelList;

//      programList
//          .forEach((vodModel) => print('vodModel ${vodModel.toString()}'));

      if (isCache) {
        //DownloadService.downloadVodList(vodList);
      }
      return programModelList;
    } catch (e) {
      print("dio e:" + e.toString());
    }
  }

  static Future getLeagueProgramList(String event,
      [int page = 0, int limit = 10]) async {
    String url =
        "$GET_GET_LEAGUE_PROGRAMS_URL&event=$event&page=$page&limit=$limit";
    LogMyUtil.e("getLeagueProgramList() url:${url}");
    try {
      var dio = new Dio();
      final response = await dio.get(url);
      String res = response.data.toString();
     // print("res:" + res);
      String res2Json = json.encode(response.data);
      final Map parsed = json.decode(res2Json);
      String code = parsed["code"];
      List<dynamic> list = parsed["objects"];
      ProgramModelList programModelList = ProgramModelList.fromJson(list);
      List programList = programModelList.programModelList;
//      programList
//          .forEach((vodModel) => print('vodModel ${vodModel.toString()}'));
      return programModelList;
    } catch (e) {
      print("dio e:" + e.toString());
    }
  }

  static Future getProgramByDayList([int day = 0, bool isCache = true]) async {
    String url =
        tokenUrl("$GET_PROGRAMSBYDAY_URL${day.toString()}&page=0&limit=50");
    LogMyUtil.e("getPorgramList() url:${url}");
    try {
      var dio = new Dio();
      final response = await dio.get(url);
      String res = response.data.toString();
     // print("res:" + res);
      String res2Json = json.encode(response.data);
      final Map parsed = json.decode(res2Json);
      String code = parsed["code"];
      List<dynamic> list = parsed["objects"];
      ProgramModelList programModelList = ProgramModelList.fromJson(list);

      List programList = programModelList.programModelList;

//      programList
//          .forEach((vodModel) => print('vodModel ${vodModel.toString()}'));

      if (isCache) {
        //DownloadService.downloadVodList(vodList);
      }
      return programModelList;
    } catch (e) {
      print("dio e:" + e.toString());
    }
  }

  static Future<MetadataModel> getHttpSource(MetadataModel mm) async {
    String url =
        "$BASE_SERVER_URL/getAvailabeSourceList.do?vodId=${mm.vodId}&piece=${mm.piece}";
    print("getHttpSource() url:${url}");
    try {
      var dio = new Dio();
      // print("it is time to connent server!}");
      await dio.get(url).then((response) async {
        String res = response.data.toString();
      //  print("response:" + res);
        String res2Json = json.encode(response.data);
        final Map parsed = json.decode(res2Json);
        String code = parsed["code"];
        List<dynamic> list = parsed["objects"];
        // print('response parse is $code|$list');
        SourceModelList sourceModelList = SourceModelList.fromJson(list);
//        print(
//            'getHttpSource sourceModelList.sourceModelList.length: ${sourceModelList.sourceModelList.length}');
//        sourceModelList.sourceModelList.forEach(
//            (sourceModel) => print('getHttpSource ${sourceModel.toString()}'));

        mm.sourceModelList = sourceModelList.sourceModelList;
        String id = mm.vodId.toString() + "_" + mm.piece;
        sourceMap[id] = mm;
        print("return mm:" + mm.toString());
        return mm;
      });
    } catch (e) {
      print("dio e:" + e.toString());
      return null;
    }
    return mm;
  }

  static Future addHttpSource(MetadataModel mm) async {
    if (false == isReport) {
      return;
    }
    int vodId = mm.vodId;
    String vodName = mm.vodName;
    String piece = mm.piece;
   // print("addHttpSource() mm:${mm.toString()}");
    String url =
        "$BASE_SERVER_URL${ADD_SOURCE_URL}vodId=$vodId&vodName=$vodName&piece=$piece&localIp=$LOCAL_IP&nodeId=$NODE_ID&deviceId=$DEVICE_ID";
    print("addHttpSource url:" + url);
    try {
      var response = await http.get(url);
    //  print("${response.statusCode}");
    //  print("${response.body}");
    //  print("reportHttpSource() end");
    } catch (e) {
      print("fail to add HttpSource()" + e.toString());
    }
  }

  static Future fuzzyQueryVod(String condition) async {
    LogMyUtil.e("fuzzyQuery() url:$FUZZY_QUERY_URL");
    try {
      var dio = new Dio();
      final response = await dio.get("${FUZZY_QUERY_URL}condition=$condition");
      String res = response.data.toString();
    //  print("res:" + res);
      String res2Json = json.encode(response.data);
      final Map parsed = json.decode(res2Json);
      String code = parsed["code"];
      List<dynamic> list = parsed["objects"];
      VodModelList modelList = VodModelList.fromJson(list);
//      modelList.vodModelList
//          .forEach((vodModel) => print('vodModel ${vodModel.detail()}'));
      return modelList.vodModelList;
    } catch (e) {
      print("dio e:" + e.toString());
    }
  }

  static Future test_check() async {
    pNodeSesionBuffer.writeln("start check");
    getChannelList(0, 0, 0, 100).then((onValue) async {
      //channelList[0] = onValue.channelModelList;
      int num = 1;
      int e1 = 0;
      int e2 = 0;
      for (ChannelModel cm in onValue.channelModelList) {
        var t1 = DateTime.now().millisecondsSinceEpoch;
        //const url = 'http://hk2sg.b-cdn.net/live/cctv5hd.m3u8';
        try {
          var response = await http.get(cm.playUrl);
      //    print("${response.statusCode}");
      //    print("${response.body}");
      //    print("reportHttpSource() end");
          var t2 = DateTime.now().millisecondsSinceEpoch;
          var t = t2 - t1;
          String result = "$num spent:$t|${cm.name}|${response.statusCode}";
          if (200 == response.statusCode) {
            result += "|ok";
          } else {
            result += "|not--------";
            e1++;
          }
          if (t > 1000) {
            result += "|slow";
          }
          pNodeSesionBuffer.writeln(result);
        } catch (e) {
          print("fail to add HttpSource()" + e.toString());
          pNodeSesionBuffer.writeln("$num-----except--------:|${cm.name}");
          e2++;
        }
        num++;
      }
      pNodeSesionBuffer.writeln("end check result:E1:$e1,E2:$e2");
    });
  }

  //获取推荐信息
  static Future getRcmdVods(VodModel vod) async {
    print("getRcmdVods:$GET_RCMD_VODS_URL");
    try {
      var dio = new Dio();
      final response =
          await dio.post(tokenUrl(GET_RCMD_VODS_URL), data: vod.toJson());
      String res = response.data.toString();
     // print("res:" + res);
      String res2Json = json.encode(response.data);
      final Map parsed = json.decode(res2Json);
      String code = parsed["code"];
      List<dynamic> list = parsed["objects"];
      VodModelList modelList = VodModelList.fromJson(list);
      return modelList.vodModelList;
    } catch (e) {
      print("fail to getRcmdVods|$e");
    }
  }

  //获取推荐信息
  static Future getRcmdChannels(int page, int limit) async {
    print("getRcmdChannels:$GET_RCMD_CHANNELS_URL");
    try {
      var dio = new Dio();
      final response =
          await dio.get("${GET_RCMD_CHANNELS_URL}page=$page&&limit=$limit");
      String res = response.data.toString();
     // print("res:" + res);
      String res2Json = json.encode(response.data);
      final Map parsed = json.decode(res2Json);
      String code = parsed["code"];
      List<dynamic> list = parsed["objects"];
      ChannelModelList modelList = ChannelModelList.fromJson(list);
      return modelList.channelModelList;
    } catch (e) {
      print("fail to getRcmdChannels|$e");
    }
  }

  //获取体育分类
  static Future getSportsTypes() async {
    print("getSportsTypes:$GET_SPORTS_TYPES_URL");
    try {
      var dio = new Dio();
      final response = await dio.get(GET_SPORTS_TYPES_URL);
      String res = response.data.toString();
     // print("res:" + res);
      String res2Json = json.encode(response.data);
      final Map parsed = json.decode(res2Json);
      String code = parsed["code"];
      List<dynamic> list = parsed["objects"];
      StypeModelList modelList = StypeModelList.fromJson(list);
      return modelList.stypeModelList;
    } catch (e) {
      print("fail to getSportsTypes|$e");
    }
  }

  //获取文章
  static Future getTopics(int type, int page, int limit) async {
    String url =
        "${GET_TOPICS_URL}topicType=${type}&page=${page}&limit=${limit}";
    print("getTopics:$url");
    try {
      var dio = new Dio();
      final response = await dio.get(url);
      String res = response.data.toString();
     // print("res:" + res);
      String res2Json = json.encode(response.data);
      final Map parsed = json.decode(res2Json);
      String code = parsed["code"];
      List<dynamic> list = parsed["objects"];
      TopicModelList modelList = TopicModelList.fromJson(list);
//      modelList.topicModelList.forEach(
//          (sourceModel) => print('getTopics ${sourceModel.toString()}'));
      return modelList.topicModelList;
    } catch (e) {
      print("fail to getTopics|$e");
    }
  }

  //获取lala
  static Future<List<PictureModel>> getLalas(int page, int limit) async {
    String url = "${GET_LALAS_URL}&page=${page}&limit=${limit}";
    print("_getLalas:$url");
    try {
      var dio = new Dio();
      final response = await dio.get(url);
      String res = response.data.toString();
      //print("res:" + res);
      String res2Json = json.encode(response.data);
      final Map parsed = json.decode(res2Json);
      String code = parsed["code"];
      List<dynamic> list = parsed["objects"];
      PictureModelList modelList = PictureModelList.fromJson(list);
      modelList.pictureModelList.forEach(
          (sourceModel) => print('_getLalas ${sourceModel.toString()}'));
      return modelList.pictureModelList;
    } catch (e) {
      print("fail to _getLalas|$e");
    }
  }

  static Future<String> getChannelPlayUrl(ChannelModel channelModel) async {
    String serverUrl = channelModel.serverUrl;
    String tvid = channelModel.tvid;
    String part = channelModel.parts.split(",")[0];
    String playUrl = "";
    if (serverUrl != null || serverUrl.length > 0) {
      //String data = "{\'tvid\':${tvid},\'part\':${part}}";
      FormData data = new FormData.from({
        "tvid": tvid,
        "part": part,
      });
      await getPlayUrl(serverUrl, data).then((onValue) {
        playUrl = onValue;
      });
    }
    return playUrl;
  }

  //获取playUrl
  static Future<String> getPlayUrl(String serverUrl, FormData data) async {
    print("getPlayUrl:$serverUrl|data:$data");
    String url = "";
    try {
      var dio = new Dio();
      final response = await dio.post(serverUrl, data: data);
      String res = response.data.toString();
    //  print("res:" + res);
      String res2Json = json.encode(response.data);
    //  print("1111");
      final Map parsed = json.decode(response.data);
    //  print("2222");
      final Map parsed1 = parsed["data"];
      print("3333");
      print("parsed1:$parsed1");
      url = parsed1["url"];
      print("url:$url");
    } catch (e) {
      print("fail to getPlayUrl|$e");
    }
    return url;
  }

  // 登录
  static Future<Msg>  login(UserModel user) async {
    LogMyUtil.d("$TAG login():url:$LOGIN_URL|me:${me.detail()}");
    me.vipExpire=null;//java 与 dart时间不一致
    Msg msg = new Msg();
    try {
      var dio = new Dio();
      final response = await dio.post(LOGIN_URL,  data: user.toJson());
      String res = response.data.toString();
      LogMyUtil.d("$TAG res:" + res);
      String res2Json = json.encode(response.data);
      final Map parsed = json.decode(res2Json);
      msg.code = "${parsed["code"]}";
      msg.desc = parsed["msg"];
      if (msg.code == '0') {
        final Map parsedObject=parsed["object"];
        msg.object = UserModel.fromJson(parsedObject);
      }
    } catch (e) {
      msg.code = Msg.FAILURE;
      LogMyUtil.d("$TAG fail to login() |$e");
    }
    return msg;
  }

  // 注册
  static Future<Msg>  register(Map<String, dynamic> params) async {
    LogMyUtil.d("$TAG register():url:$REGISTER_URL||$params");
    Msg msg = new Msg();
    try {
      var dio = new Dio();
      final response = await dio.post(REGISTER_URL, data: params);
      String res = response.data.toString();
      LogMyUtil.d("$TAG res:" + res);
      String res2Json = json.encode(response.data);
      final Map parsed = json.decode(res2Json);
      msg.code = "${parsed["code"]}";
      msg.desc = parsed["msg"];
      if (msg.code == '0') {
        final Map parsedObject=parsed["object"];
        msg.object = UserModel.fromJson(parsedObject);
      }
    } catch (e) {
      msg.code = Msg.FAILURE;
      LogMyUtil.d("$TAG fail to register() |$e");
    }
    return msg;
  }

  // 访客
  static Future<Msg> guest(UserModel guest) async {
    String url = GUEST_URL;
    LogMyUtil.d("$TAG guest():url:$url|deviceId:${guest.deviceId}");
    Msg msg = new Msg();
    try {
      var dio = new Dio();
      final response = await dio.post(url, data: guest.toJson());
      String res = response.data.toString();
      LogMyUtil.d("$TAG res:" + res);
      String res2Json = json.encode(response.data);
      final Map parsed = json.decode(res2Json);
      LogMyUtil.d("$TAG 1111111111");
      msg.code  = "${parsed["code"]}";
      LogMyUtil.d("$TAG 22222222222：${msg.code}" );
      msg.desc = parsed["msg"];
      LogMyUtil.d("$TAG 3333333333333333");
      if (msg.code == '0') {
        LogMyUtil.d("$TAG 444444444444");
        final Map parsedObject=parsed["object"];
        msg.object = UserModel.fromJson(parsedObject);
      }
    } catch (e) {
      msg.code = Msg.FAILURE;
      LogMyUtil.d("$TAG fail to guest() |$e");
    }
    return msg;
  }
  //充值
  static Future<Msg> charge(int userId, String cardId) async {
    String url = "${user_charge_URL}userId=$userId&cardId=$cardId";
    LogMyUtil.d("$TAG charge():url:$url");
    Msg msg = new Msg();
    try {
      var dio = new Dio();
      await dio.get(url).then((response) {
        String res = response.data.toString();
        LogMyUtil.d("$TAG res:" + res);
        String res2Json = json.encode(response.data);
        final Map parsed = json.decode(res2Json);
        msg.code = "${parsed["code"]}";
        msg.desc = parsed["msg"];
        if (msg.code == '0') {
          final Map parsedObject=parsed["object"];
          msg.object = UserModel.fromJson(parsedObject);
        }
      });
    } catch (e) {
      msg.code = Msg.FAILURE;
      LogMyUtil.d("$TAG fail to charge() |$e");
    }
    return msg;
  }

  //行为上报
  static Future actionReport(ClientAction ca) async {
    if(LogMyUtil.isDebug){
      return;
    }
    print("actionReport:$ACTION_REPORT_URL");
    try {
      var dio = new Dio();
      final response = await dio.post(ACTION_REPORT_URL, data: ca.toJson());
      print("response:${response.data}");
      //var data = json.decode(response);
      // String res2Json = json.encode(response.data);
    } catch (e) {
      print("fail to actionReport|$e");
    }
  }

  //p2p日志上报
  static Future holeReport(PeerAction pa) async {
    if(LogMyUtil.isDebug){
      return;
    }
    String url = "$HOLE_REPORT_URL}";
    print("holeReport:$url");
    try {
      var dio = new Dio();
      final response = await dio.post(HOLE_REPORT_URL, data: pa.toJson());
      print("response:${response.data}");
      //String res2Json = json.encode(response.data);
    } catch (e) {
      print("fail to holeReport|$e");
    }
  }

  //日志上报
  static Future logReport(ClientLog cl) async {
    if(LogMyUtil.isDebug){
      return;
    }
    print("logReport:$LOG_REPORT_URL");
    try {
      var dio = new Dio();
      final response = await dio.post(LOG_REPORT_URL, data: cl.toJson());
      print("response:${response.data}");
      //String res2Json = json.encode(response.data);
    } catch (e) {
      print("fail to logReport|$e");
    }
  }

  static String tokenUrl(url) {
    String tokenUrl = "$url&token=$token";
    print("tokenUrl:$tokenUrl");
    return tokenUrl;
  }
}
