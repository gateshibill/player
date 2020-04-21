


class LogMyUtil {
  static bool isDebug = true; //是否是debug模式,true: log v 不输出.

  static d(Object object) => _printLog("d:"+object.toString());

  static v(Object object) => _printLog("v:"+object.toString());

  static e(Object object) => _printLog("e:"+object.toString());

  static _printLog(String string) {
    if (isDebug) print('[player]' + string);
  }
}

