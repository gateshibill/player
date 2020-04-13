import 'date_util.dart';
import 'shared_preferences.dart';
import '../model/user_model.dart';
import './http_client.dart';
import 'dart:convert';
import '../model/client_log.dart';

//class UserModel {
//  String userId;
//  String userNickName;
//  String userPortrait;
//  String userPhone;
//  String userPwd;
//}

class LocalDataProvider {
  UserModel _briefInfo;
  SpUtil sp;
  static bool loginOK = false;

  static LocalDataProvider _instance;

  static bool _isAndroid = true;
  static int _remindTime = 0;
  static int _loginTime = 0;

  // 单利
  static LocalDataProvider getInstance() {
    if (_instance == null) {
      _instance = LocalDataProvider();
    }
    return _instance;
  }

  initData() async {
    print("initData()");
    sp = await SpUtil.getInstance();
    _remindTime = sp.getInt(SharedPreferencesKeys.remindTime);
    _loginTime = sp.getInt(SharedPreferencesKeys.userLoginTime);
    _briefInfo = UserModel();
    initBriefInfo();
  }

  initBriefInfo() {
    print("initBriefInfo()");
    try {
      print("sp.userId:${sp.getString(SharedPreferencesKeys.userId)}");
      if (null == sp.getString(SharedPreferencesKeys.userId)) {
        return;
      }
      _briefInfo.userId = int.parse(sp.getString(SharedPreferencesKeys.userId));
      _briefInfo.userNickName =
          sp.getString(SharedPreferencesKeys.userNickName);
      _briefInfo.userPortrait =
          sp.getString(SharedPreferencesKeys.userPortrait);
      _briefInfo.userPhone = sp.getString(SharedPreferencesKeys.userPhone);
      _briefInfo.userPwd = sp.getString(SharedPreferencesKeys.userPwd);

      print("_briefInfo.userNickName:${_briefInfo.userNickName}");
      //自动登录
      HttpClient.login({
        'userPhone': _briefInfo.userPhone,
        'userPwd': _briefInfo.userPwd
      }).then((response) {
        if (null == response) {
          print("fail to login,$response");
          return;
        }
        final Map parsed = json.decode(response);
        String code = parsed["code"].toString();
        final Map objectJson = parsed["object"];
        if (code == '200') {
          loginOK = true;
        } else {
          print("fail to login,$response");
        }
      });
    } catch (e) {
      print(e);
      ClientLog cl = new ClientLog(
          "local_data_provider.dart|initBriefInfo()|$e", "error");
      HttpClient.logReport(cl);
    }
  }

  saveUserInfo(userId, userNickName, userPortrait, userPhone, userPwd) async {
    sp.putString(SharedPreferencesKeys.userId, userId);
    sp.putString(SharedPreferencesKeys.userNickName, userNickName);
    sp.putString(SharedPreferencesKeys.userPortrait, userPortrait);
    sp.putString(SharedPreferencesKeys.userPhone, userPhone);
    sp.putString(SharedPreferencesKeys.userPwd, userPwd);
    print("userNickName:${userNickName}");
    loginOK = true;
  }

  bool isLogin() {
    return loginOK;
    if (null == _briefInfo) {
      print("111111111111111111");
      return false;
    } else {
      if (null == _loginTime) {
        print("22222222222222222222_loginTime:$_loginTime");
        return false;
      } else {
        if ((DateUtils.getNowDateMs() - _loginTime) > 3 * 86400000) {
          // 三天以后，登录信息没有用
          print("333333333333333333333333");
          return false;
        } else {
          // 三天以内，登录信息有用
          print("444444444444444444444444444");
          return true;
        }
      }
    }
  }

  setIos() {
    _isAndroid = false;
  }

  isAndroid() {
    return _isAndroid;
  }

  int getLoginTime() {
    return _loginTime;
  }

  setLoginTime(int time) {
    _loginTime = time;
  }

  int getRemindTime() {
    return _remindTime;
  }

  setRemindTime(int time) {
    _remindTime = time;
  }

  getUserId() {
    return _briefInfo.userId;
  }

  getUserNickName() {
    return _briefInfo.userNickName;
  }

  getUserHeadface() {
    return _briefInfo.userPortrait;
  }

  String getPokeMeTime(String key) {
    return sp.get('pokeMeTime');
  }

  clearAll() {
    _briefInfo.userId = null;
    _briefInfo.userNickName = null;
    _briefInfo.userPortrait = null;
    sp.clear();
  }
}
