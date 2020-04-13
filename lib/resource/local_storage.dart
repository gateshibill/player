import 'dart:convert';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../model/metadata_model.dart';
import '../model/vod_model.dart';
import '../data/cache_data.dart';
import '../model/channel_model.dart';
import '../model/program_model.dart';
import '../service/download_service.dart';
import '../utils/log_util.dart';
import '../model/topic_model.dart';

//VirtualDirectory可以从根路径获取文件和目录清单
import 'package:http_server/http_server.dart' show VirtualDirectory;

/**
 *
 */
class LocalStorage {
  static SharedPreferences sharedPreferences = null;
  static Map<String, MetadataModel> metadataMap =
      new Map<String, MetadataModel>();

  //static var vodMap = new Map();
  static Map<int, VodModel> historyVoMap = new Map<int, VodModel>();
  static Map<int, ChannelModel> historyChannelMap = new Map<int, ChannelModel>();

  static Future<bool> init() async {
    BASE_DIR = (await getApplicationDocumentsDirectory()).path;
    LogUtil.v("LocalStorage init start base_dir:${BASE_DIR}");
    await SharedPreferences.getInstance().then((sp) {
      sharedPreferences = sp;
      //sharedPreferences.clear();
      Set<String> keys = sharedPreferences.getKeys();
      LogUtil.v("sharedPreferences keys length:" + keys.length.toString());
      for (var key in keys) {
        // if (key.startsWith("vod_")) {
        String vodJson = sharedPreferences.get(key);
        LogUtil.v("sp:${key}:${vodJson}");
        try {
          if (key.startsWith("vod_100_")) {
            final Map parsed = json.decode(vodJson);
            VodModel vm = VodModel.fromJson(parsed);
            //vodMap[vm.vodId] = vm;
            homeVodList.add(vm);
          } else if (key.startsWith("vod_1_")) {
            final Map parsed = json.decode(vodJson);
            VodModel vm = VodModel.fromJson(parsed);
            //vodMap[vm.vodId] = vm;
            videoVodList[0].add(vm);
          } else if (key.startsWith("vod_101_")) {
            final Map parsed = json.decode(vodJson);
            VodModel vm = VodModel.fromJson(parsed);
            //vodMap[vm.vodId] = vm;
            videoVodList[1].add(vm);
          } else if (key.startsWith("historyVod_")) {
            final Map parsed = json.decode(vodJson);
            VodModel vm = VodModel.fromJson(parsed);
            historyVoMap[vm.vodId] = vm;
          } else if (key.startsWith("historyChannel_")) {
            final Map parsed = json.decode(vodJson);
            ChannelModel m = ChannelModel.fromJson(parsed);
            historyChannelMap[m.id] = m;
          }else if (key.startsWith("program_")) {
            final Map parsed = json.decode(vodJson);
            ProgramModel pm = ProgramModel.fromJson(parsed);
            // vodMap[pm.id] = pm;
            commonProgramlist[0].add(pm);
          } else if (key.startsWith("vod_1001")) {
            final Map parsed = json.decode(vodJson);
            VodModel m = VodModel.fromJson(parsed);
            // vodMap[pm.id] = pm;
            sportsPlaybackVodList[0].add(m);
          } else if (key.startsWith("vod_1002")) {
            final Map parsed = json.decode(vodJson);
            VodModel m = VodModel.fromJson(parsed);
            // vodMap[pm.id] = pm;
            sportsPlaybackVodList[1].add(m);
          } else if (key.startsWith("vod_1003")) {
            final Map parsed = json.decode(vodJson);
            VodModel m = VodModel.fromJson(parsed);
            // vodMap[pm.id] = pm;
            sportsPlaybackVodList[2].add(m);
          } else if (key.startsWith("meta_")) {
            String metaJson = sharedPreferences.get(key);
            final Map parsed = json.decode(metaJson);
            MetadataModel mm = MetadataModel.fromJson(parsed);
            metadataMap[key] = mm;
            // metadataList.add(mm);
            DownloadService.checkForCache(mm);
//          }else if (key.startsWith("topic_")) {
//            final Map parsed = json.decode(vodJson);
//            TopicModel m = TopicModel.fromJson(parsed);
//            //vodMap[vm.vodId] = vm;
//            topicList.add(m);
          }
        } catch (e) {
        }
      }
    });
    return true;
  }

  static SharedPreferences instance() {
    return sharedPreferences;
  }

  /**
   * 利用SharedPreferences存储数据
   */
  static void _saveString(String key, String value) async {
  //  print("set:$key | $value");
   sharedPreferences.setString(key, value);
  }

  static void saveVod(VodModel vm, {int column = 1}) async {
    try {
      LocalStorage._saveString(
          "vod_${column}_${vm.vodId.toString()}_" , json.encode(vm));
    } catch (e) {
      print(e);
    }
  }

  //未限制长度，待完善
  static void saveHistoryVod(VodModel vm) async {
    LocalStorage._saveString("historyVod_${vm.vodId.toString()}_" ,json.encode(vm));
  }
  //未限制长度，待完善
  static void saveHistoryChannel(ChannelModel m) async {
    LocalStorage._saveString("historyChannel_${m.id.toString()}_" ,json.encode(m));
  }

  static void saveChannel(ChannelModel cm) async {
    LocalStorage._saveString("channel_${cm.id.toString()}_" , json.encode(cm));
  }
  static void saveTopic(TopicModel m) async {
    LocalStorage._saveString("topic_${m.topicId}_" , json.encode(m));
  }

  static void saveProgram(ProgramModel pm, {int day = 1}) async {
    LocalStorage._saveString(
        "program_${day}_${pm.id.toString()}_", json.encode(pm));
  }

  static void saveMetadata(MetadataModel mm) async {
    String key = "meta_" + mm.vodId.toString() + "_" + mm.piece;
    LocalStorage._saveString(key, json.encode(mm));
  }

  static void saveMetadataMap(MetadataModel mm) {
    String key = "meta_" + mm.vodId.toString() + "_" + mm.piece;
    metadataMap[key] = mm;
  }

  static List<MetadataModel> getMetadataList() {
    return LocalStorage.metadataMap.values.toList();
  }

  /**
   * 获取存在SharedPreferences中的数据
   */
  static String getString(String key) {
    return sharedPreferences.get(key);
  }

  /**
   * 获取存在SharedPreferences中的数据
   */
  static List<String> getStringList(String key) {
    return sharedPreferences.getStringList(key);
  }

  /**
   * 清除缓存数据
   */
  static clear() {
    return sharedPreferences.clear();
  }

  static cleanCache() {
    try {
      List<MetadataModel> mmlist = LocalStorage.metadataMap.values.toList();
      for (MetadataModel mm in mmlist) {
        String filePath = '$BASE_DIR/${mm.vodId}/${mm.piece}';
        LogUtil.v("delete:" + filePath);
        File file = File(filePath);
        file.delete();
      }
    } catch (e) {
      LogUtil.v("clearnCache() e" + e.toString());
    }
  }
}
