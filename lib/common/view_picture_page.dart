import 'package:flutter/material.dart';
import 'package:photo_view/photo_view.dart';
import 'package:photo_view/photo_view_gallery.dart';
import '../model/client_action.dart';
import '../service/http_client.dart';
// ...

class ViewPicturePage extends StatefulWidget {
  ViewPicturePage({Key key, this.networkImages}) : super(key: key);
  List<NetworkImage> networkImages;

  @override
  _ViewPicturePageState createState() => new _ViewPicturePageState(networkImages: networkImages);
}

class _ViewPicturePageState extends State<ViewPicturePage> {
  _ViewPicturePageState({Key key, this.networkImages});

  List<NetworkImage> networkImages;

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
              imageProvider: networkImages[index],
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