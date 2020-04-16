import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:html/dom.dart' as dom;
import 'media_page.dart';
import '../model/media_model.dart';
import '../model/topic_model.dart';

class HtmlPage  extends MediaPage{
  HtmlPage({Key key, @required this.mediaModel,this.context});
  MediaModel mediaModel;
  BuildContext context;
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
//      title: 'Flutter Demo',
//      theme: new ThemeData(
//        primarySwatch: Colors.blue,
//      ),
      home: new MyHomePage(mediaModel: mediaModel,context:context),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.mediaModel,this.context}) : super(key: key);
  //MediaPage({Key key, @required this.mediaModel});
  //final String title;
  MediaModel mediaModel;
  BuildContext context;
  @override
  _MyHomePageState createState() => new _MyHomePageState(mediaModel: mediaModel,context: this.context);
}

class _MyHomePageState extends State<MyHomePage> {
  _MyHomePageState({Key key, this.mediaModel,this.context});
  TopicModel mediaModel;
  BuildContext context;
  @override
  Widget build(BuildContext context) {
    String content="<h1>${mediaModel.getName()}</h1>  " + mediaModel.topicContent;

    return new Scaffold(
      appBar: new AppBar(
        leading: new IconButton(
          icon: new Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.of(this.context).pop(),
        ),
        title: new Text(mediaModel.getName()),
      ),
      body: new Center(
        child: SingleChildScrollView(
          child: Html(
            data:content,
            //Optional parameters:
            padding: EdgeInsets.all(8.0),
            linkStyle: const TextStyle(
              color: Colors.redAccent,
              decorationColor: Colors.redAccent,
              decoration: TextDecoration.underline,
            ),
            onLinkTap: (url) {
              print("Opening $url...");
            },
            onImageTap: (src) {
              print(src);
            },
            //Must have useRichText set to false for this to work
            customRender: (node, children) {
              if (node is dom.Element) {
                switch (node.localName) {
                  case "custom_tag":
                    return Column(children: children);
                }
              }
              return null;
            },
            customTextAlign: (dom.Node node) {
              if (node is dom.Element) {
                switch (node.localName) {
                  case "p":
                    return TextAlign.justify;
                }
              }
              return null;
            },
            customTextStyle: (dom.Node node, TextStyle baseStyle) {
              if (node is dom.Element) {
                switch (node.localName) {
                  case "p":
                    return baseStyle.merge(TextStyle(height: 2, fontSize: 20));
                }
              }
              return baseStyle;
            },
          ),
        ),
      ),
    );
  }
}
