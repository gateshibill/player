import 'package:flutter/material.dart';
import '../resource/local_storage.dart';
import '../model/metadata_model.dart';
import '../utils/log_util.dart';
import '../global_config.dart';
import 'package:intl/intl.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'dart:io';
import '../data/cache_data.dart';

class TaskDetail extends StatefulWidget {
  @override
  _TaskDetailState createState() => _TaskDetailState();
}

class _TaskDetailState extends State<TaskDetail> {
  ScrollController _scrollController = new ScrollController();
  List<MetadataModel> mmlist = LocalStorage.getMetadataList();
  //List<MetadataModel> mmlist = metadataList;

  @override
  void initState() {
    super.initState();
    _handleRefresh();
    setState(() {
      _scrollController.addListener(() {
        if (_scrollController.position.pixels ==
            _scrollController.position.maxScrollExtent) {
          _getMoreData();
        }
      });
    });
    LogUtil.v("initState setState()");
  }
  @override
  void dispose() {
    super.dispose();
  }

  Widget build(BuildContext context) {
    return new MaterialApp(
      theme: GlobalConfig.themeData,
      debugShowCheckedModeBanner: false,
      home: new Scaffold(
        appBar: AppBar(
          title: Text("cachetask(${mmlist.length})"),
        ),
          body:ListView.builder(
            itemBuilder: (BuildContext context, int index) {
             // LogUtil.e("itemBuilder index:$index");
              return itemBuilder1(context, index);
            },
            itemCount: mmlist.length,
            controller: _scrollController,
          ),
      ),
    );
  }

  Widget itemBuilder1(BuildContext context, int index) {
    //String time= formatDate(mmlist[index].time, ['yyyy', '-', 'mm', '-', 'dd']);
    String time= DateFormat('MM-dd kk:mm').format(mmlist[index].time);
    return ListTile(
        title: Text("$index:${mmlist[index].vodName}|${mmlist[index].piece}|${mmlist[index].fromIp}|${time}"),
    );
  }

  Future _handleRefresh() async {
    LogUtil.e("_handleRefresh");
    return;
  }

  Future _getMoreData() async {
    LogUtil.e("_getMoreData()");
  }
}
