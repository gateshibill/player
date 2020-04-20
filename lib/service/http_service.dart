import 'package:http_multi_server/http_multi_server.dart';
import 'package:shelf/shelf.dart' as shelf;
import 'package:shelf/shelf_io.dart' as shelf_io;
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:dio/dio.dart';
import 'dart:convert' show utf8;
import '../model/source_model.dart';
import 'package:json_annotation/json_annotation.dart';
import '../config/config.dart';
import '../utils/log_my_util.dart';


import 'package:http_server/http_server.dart' show VirtualDirectory;


class HttpService{
  ready() async {
    LogMyUtil.v("reay");
    HttpServer.bind(InternetAddress.anyIPv6, 8081).then((server) {
      server.listen((HttpRequest request) {
        request.response.write('Hello, world!');
        request.response.close();
      });
    });
  }

  readyDirServer() async {
    final MY_HTTP_ROOT_PATH  =(await getApplicationDocumentsDirectory()).path;
    // final MY_HTTP_ROOT_PATH = (await getExternalStorageDirectory()).path;
    LogMyUtil.v("MY_HTTP_ROOT_PATH:" + MY_HTTP_ROOT_PATH);
    final virDir = new VirtualDirectory(MY_HTTP_ROOT_PATH)

      ..allowDirectoryListing = true;
    HttpServer.bind(InternetAddress.anyIPv6, HTTP_SERVER_PORT).then((server) {
      server.listen((request) {

        virDir.serveRequest(request);
      });
    });
  }
}
