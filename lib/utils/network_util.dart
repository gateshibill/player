
//import 'package:get_ip/get_ip.dart';
import 'dart:io';
import 'dart:convert';
import '../config/config.dart';
//import 'package:unique_identifier/unique_identifier.dart';


Future<String> initLocalIp() async {
  String ipAddress;
  // Platform messages may fail, so we use a try/catch PlatformException.
//  try {
//    ipAddress = await GetIp.ipAddress;
//    LOCAL_IP=ipAddress;
//    DEVICE_ID = await UniqueIdentifier.serial;
//    print("DEVICE_ID:$DEVICE_ID");
//  } catch(e) {
//    ipAddress = 'Failed to get ipAdress.';
//    print(e);
//  }
//  print ("ipAddress:"+ipAddress);
return ipAddress;
}

