
import 'package:common_utils/common_utils.dart';

class StrUtils {
  static String subString(String str, int length) {
    if (null == str) {
      return "";
    } else {
      return '${str.substring(0, (str.length > length ? length : str.length))}';
    }
  }

  static bool isEmptyStr(String str) => ObjectUtil.isEmptyString(str);

  static bool isEmpty(Object object) => ObjectUtil.isEmpty(isEmptyStr);
}
