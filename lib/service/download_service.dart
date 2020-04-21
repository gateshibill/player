import 'dart:io';
import 'package:dio/dio.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:convert';
import 'local_storage.dart';
import '../model/source_model.dart';
import 'local_storage.dart';
import '../model/vod_model.dart';
import '../model/metadata_model.dart';
import '../data/cache_data.dart';
import './http_client.dart';
import '../config/config.dart';
import '../resource/cache_isolate.dart';
import '../utils/log_my_util.dart';
import '../utils/network_util.dart';

class DownloadService {
  static var dio = new Dio();

  static Future downloadVodList(List<VodModel> vodList) async {
    print("downloadVodList() sart");
    for (VodModel vm in vodList) {
      vm.metadataList = new List<MetadataModel>(); //临时这样，写在这里不合理
      vm.baseDir = BASE_DIR; //临时这样，写在这里不合理
      if (vm.vodCopyright) {
        await downloadVod(vm);
      } else {
        print("no copyright,do not need to download");
      }
    }
  }

  static Future downloadVod(VodModel vm) async {
    print('downloadVod start');
    String playUrl = vm.vodPlayUrl;
    //获取m3u8文件
    String fileName = "playlist.m3u8"; //零时预定，有可能不妥
//        playUrl.substring(playUrl.lastIndexOf("/") + 1, playUrl.length);
    vm.playlistFileName = fileName;
    String dir = "${vm.baseDir}/${vm.vodId.toString()}";
    await download(playUrl, dir, fileName).then((isSucess) async {
      //1.解析m3u8, 2.下载电影前面三个ts
      await parseM3u8(vm).then((vm) {
        if (vm.metadataList.isEmpty) {
          print("vm.metadataList.isEmpty");
        } else {
          downloadThreeMetas(vm);
        }
      });
    });
//
//    await downloadThreeMetas(vm).then((vm) {
//      print('downloadVod end');
//    });
    return;
  }

  static Future<VodModel> parseM3u8(VodModel vm) async {
    print("paserM3u8 start ${vm.toString()}");
    String filepath =
        BASE_DIR + "/" + vm.vodId.toString() + "/" + vm.playlistFileName;
    var file = File(filepath);
    List<MetadataModel> metaList = new List();
    try {
      List<String> lines = await file.readAsLines();
      for (var line in lines) {
        bool isTs = line.endsWith(".ts");
        if (isTs) {
          MetadataModel mm = new MetadataModel(vm.vodName, line.trim());
          mm.vodId = vm.vodId;
          mm.vodName = vm.vodName;
          int last = vm.vodPlayUrl.lastIndexOf("/");
          mm.playUrl = vm.vodPlayUrl.substring(0, last + 1) + mm.piece;
          vm.metadataList.add(mm);
        }
        // print(line);
      }
      return vm;
    } catch (e) {
      print(e);
    }
    return null;
  }

  static Future downloadThreeMetas(VodModel vm) async {
    print('downloadMeta start:${vm.toString()}');
    if (vm.metadataList[0] != null) {
      MetadataModel mm = vm.metadataList[0];
      await checkForCache(mm);
    }
    if (vm.metadataList[1] != null) {
      MetadataModel mm = vm.metadataList[1];
      await checkForCache(mm);
    }
    if (vm.metadataList[2] != null) {
      MetadataModel mm = vm.metadataList[3];
      await checkForCache(mm);
    }
  }

  static void checkForCache(MetadataModel mm) async {
    if (false == isReport) {//临时方案
      return;
    }
    String filePath = '$BASE_DIR/${mm.vodId}/${mm.piece}';
    File file = File(filePath);
    bool isExit = await file.exists(); //返回真假
    if (isExit) {
      LocalStorage.saveMetadataMap(mm);
      LocalStorage.saveMetadata(mm); //防止清除sp而cache还存在的情况；
     await HttpClientUtils.addHttpSource(mm);
    } else {
      print("$filePath is not exist,will download again!");
      CacheIsolate.addTask(mm);
    }
  }

  /**
   * 需要先去请求服务器，或者资源节点
   */
  static Future<bool> downloadMeta(MetadataModel mm) async {
    print("start downloadMeta:${mm.vodId}|${mm.vodName}|${mm.piece}");
    String url = "";
    String pieceName = mm.piece;
    String dir = "${mm.baseDir}/${mm.vodId.toString()}";
    print("downloadMeta dir:${dir}}");

    bool isDownloadSuccess = false;
    await getDownloadSource(mm).then((sm) {
      //没有节点时，使用服务器资源，先采用把服务资源也添加到节点，保证无空极点
      if (null == sm) {
        print("sm in null");
        url = mm.playUrl;
        mm.fromIp = "server";
      } else {
        print("downloadMeta " + sm.toString());
        if (1 == sm.status) {
          //同一网络，使用内网IP
          url =
              "http://${sm.localIp}:$HTTP_SERVER_PORT/${sm.vodId.toString()}/${sm.piece}";
          mm.fromIp = sm.localIp;
          print("here user local network peer:$url");
        } else {
          //暂时还是从服务器获取,待打通大网从节点下
          url = "http://$VIDEO_SERVER_IP/${mm.vodId.toString()}/${mm.piece}";
          mm.fromIp = VIDEO_SERVER_IP;
        }
      }
    });
    await download(url, dir, pieceName).then((isSuccess) {
      isDownloadSuccess = isSuccess;
      if (null == isSuccess) {
        print("download is null");
        return false;
      }
      if (isDownloadSuccess) {
        mm.status = 2; //已经下载的状态；
      } else {
        mm.status = 0;
      }
      return isDownloadSuccess;
    });
    return isDownloadSuccess;
  }

  static Future<bool> download(String url, String dir, String fileName) async {
    print("start downloading args:${url},${dir}|${fileName}");
    int statusCode = 0;
    String destFileName = "";
    bool isDownloadSuccess = false;
    try {
      if (null != dir) {
        var directory = new Directory('$dir');
        // print("create dir:" + directory.absolute.path);
        directory.createSync();
        //print("created dir:" + directory.absolute.path);
        destFileName = '$dir/$fileName';
      } else {
        destFileName = '$fileName';
      }
      print("destFileName:${destFileName}");
      File file = File(destFileName);
      bool isExitFile = false;
      await file.exists().then((isExit) async {
        isExitFile = isExit;
        isDownloadSuccess = isExit;
        if (isExitFile) {
          print("${destFileName} is exist!");
          return true;
        }

        print("it time to dio.download");
        await dio.download(url, destFileName).then((response) {
          statusCode = response.statusCode;
          print("downloaded statusCode:" + statusCode.toString());
          print("download succeed!");
          isDownloadSuccess = true;
        });
        return isDownloadSuccess;
      });
      return isDownloadSuccess;
    } catch (e) {
      print("e:" + e.toString());
    }
    return isDownloadSuccess;
  }

  /**
   * 待完成,从服务器获取资源节点
   */
  static Future<SourceModel> getDownloadSource(MetadataModel mm) async {
    print("getDownloadSource start");
    SourceModel sm = null;
    await HttpClientUtils.getHttpSource(mm).then((mm) {
      if (null == mm) {
        print("mm is null");
        return null;
      }
      print(
          "mm.sourceModelList.length:" + mm.sourceModelList.length.toString());
      if (mm.sourceModelList.length > 0) {
        //默认取第一个资源；
        print("return mm.sourceModelList[0]");
        sm = mm.sourceModelList[0];
        return mm.sourceModelList[0];
      } else {
        print("no node source is available!");
        return null;
      }
    });
    return sm;
  }

  static checkmd5(MetadataModel mm, md5) {
    return 0;
  }
}
