





String subString(String str, int length) {
  if (null == str) {
    return "";
  } else {
    return '${str.substring(0, (str.length > length ? length : str.length))}';
  }
}
