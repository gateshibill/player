import 'package:flutter/material.dart';
import 'package:photo_view/photo_view.dart';
import 'package:photo_view/photo_view_gallery.dart';
import '../model/client_action.dart';
import '../service/http_client.dart';
// ...

class ViewPicturePage1 extends StatefulWidget {
  ViewPicturePage1({Key key, this.networkImages}) : super(key: key);
  List<String> networkImages;

  @override
  _ViewPicturePage1State createState() => new _ViewPicturePage1State(networkImages: networkImages);
}

class _ViewPicturePage1State extends State<ViewPicturePage1> {
  _ViewPicturePage1State({Key key, this.networkImages});

  List<String> networkImages;

  @override
  Widget build(BuildContext context) {
    ClientAction ca =
    new ClientAction(203, "ViewPicturePage", 0, "", 0, "", 1, "browse");
    HttpClientUtils.actionReport(ca);

    return Container(
        child: PhotoViewGallery.builder(
          scrollPhysics: const BouncingScrollPhysics(),
          builder: (BuildContext context, int index) {
            return PhotoViewGalleryPageOptions(
              imageProvider: NetworkImage(networkImages[index]),
              initialScale: PhotoViewComputedScale.contained * 0.8,
              heroAttributes: PhotoViewHeroAttributes(tag: index),
            );
          },
          itemCount: networkImages.length,
          //loadingChild: this.,
         // backgroundDecoration: this.backgroundDecoration,
         // pageController: widget.pageController,
         // onPageChanged: onPageChanged,
        )
    );
  }



}