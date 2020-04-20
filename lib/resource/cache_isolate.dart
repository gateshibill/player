import 'dart:async';
import 'dart:isolate';
import 'dart:io';
import 'dart:convert';
import './local_storage.dart';
import '../model/metadata_model.dart';
import '../service/download_service.dart';
import '../config/config.dart';
import '../data/cache_data.dart';
import '../service/http_client.dart';
import '../utils/log_my_util.dart';

class CacheIsolate {
  //  Isolate isolate;
  //  ReceivePort receivePort;

  static List<MetadataModel> normalTaskList = new List();
  static int counter = 0;

  static void init() async {
    for (int i = 0; i < DOWNLOAD_THREAD_NUM && i < normalTaskList.length; i++) {
      await startNormalThread(normalTaskList.removeLast());
    }
    //metadataList.sort((left,right)=>left.expireIndex.compareTo(right.expireIndex));
  }

  static Future<dynamic> startPrivilegeThread(MetadataModel task) async {
    LogMyUtil.v("startPrivilegeThread()");
    final receivePort = new ReceivePort();
    Isolate isolate = await Isolate.spawn(execute, receivePort.sendPort);
    final sendPort = await receivePort.first as SendPort;
    LogMyUtil.v("sendPort is ok receivePort");
    final response = new ReceivePort();
    //发送数据
    sendPort.send([task, response.sendPort]);
    LogMyUtil.v("sendPort task to isolate!");
    response.listen((isSuccess) {
      LogMyUtil.v("privilege download is finished!");
      receivePort.close();
      isolate.kill(priority: Isolate.immediate);
      return isSuccess;
    });
  }

  static Future<dynamic> startNormalThread(MetadataModel task) async {
    LogMyUtil.v("startNormalThread()");
    counter++;
    final receivePort = new ReceivePort();
    Isolate isolate = await Isolate.spawn(execute, receivePort.sendPort);
    final sendPort = await receivePort.first as SendPort;
    final response = new ReceivePort();
    //发送数据
    sendPort.send([task, response.sendPort]);
    response.listen((mm) async {
      LogMyUtil.v("isolate download finished:" + mm.toString());
      if (null != mm && 2 == mm.status) {
        //描述记录本地
        LocalStorage.saveMetadata(mm);
        //下载成功资源上报
        await HttpClient.addHttpSource(mm);
      }
      counter--;
      if (counter < DOWNLOAD_THREAD_NUM && !normalTaskList.isEmpty) {
        MetadataModel taskTmp = normalTaskList.removeLast();
        receivePort.close();
        isolate.kill(priority: Isolate.immediate);
        startNormalThread(taskTmp);
      }
    });
  }

  static void addTask(MetadataModel task) async {
    print("download thread num:$counter");
    if (counter < DOWNLOAD_THREAD_NUM) {
      startNormalThread(task);
    } else {
      normalTaskList.add(task);
    }
  }

  static void execute(SendPort sendPort) async {
    print("execute()");
    final port = new ReceivePort();
    sendPort.send(port.sendPort);
    port.listen((message) {
      //LogUtil.v(" port.listen((message):start download!");
      MetadataModel mm = message[0] as MetadataModel;
      final send = message[1] as SendPort;
      //执行任务download()
      bool isOK = false;
      DownloadService.downloadMeta(mm).then((isSucess) {
        print("execute mm:${mm.toString()}");
        if (null == isSucess) {
          print("DownloadService.downloadMeta return null!}");
          return;
        }
        isOK = isSucess;
        if (!isSucess) {
          DownloadService.downloadMeta(mm).then((isSucess) {
            print("execute mm:${mm.toString()}");
            isOK = isSucess;
          });
        }
        print("send.send(mm):${mm.toString()}");
        send.send(mm);
      });
    });
  }
}
