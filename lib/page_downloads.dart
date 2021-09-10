import 'package:anokev2/models.dart';
import 'package:anokev2/page_anime.dart';
import 'package:anokev2/page_video.dart';
import 'package:anokev2/page_video_download.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:localstore/localstore.dart';
import 'package:path_provider/path_provider.dart';

class PageDownloads extends StatefulWidget {
  @override
  _PageDownloadsState createState() => _PageDownloadsState();
}

class _PageDownloadsState extends State<PageDownloads> {
  final _db = Localstore.instance;
  final _items = {};
  var _subscription;

  @override
  initState() {
    _subscription = _db.collection('downloads').stream.listen((event) {
      setState(() {
        final item = DownloadedAnime.fromJson(event);
        _items.putIfAbsent(item.id, () => item);
      });
    });
    super.initState();
  }

  @override
  void dispose() {
    if (_subscription != null) _subscription?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_items.length == 0) {
      return Scaffold(
          body:
              Column(crossAxisAlignment: CrossAxisAlignment.center, children: [
        Container(
            height: 120,
            color: Color(0xff111213),
            width: double.infinity,
            child: Padding(
              padding: EdgeInsets.fromLTRB(15, 50, 20, 15),
              child: Text('Загрузки',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w700,
                    fontSize: 40,
                  )),
            )),
        Padding(
          padding: EdgeInsets.only(top: 20),
          child: Text(
            'У вас нет скачанных серий',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Color(0xA9FFFFFF),
              fontSize: 15,
            ),
          ),
        )
      ]));
    }
    return Scaffold(
        body: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
            height: 120,
            color: Color(0xff111213),
            width: double.infinity,
            child: Padding(
              padding: EdgeInsets.fromLTRB(15, 50, 20, 15),
              child: Text('Загрузки',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w700,
                    fontSize: 40,
                  )),
            )),
        Container(
          height: MediaQuery.of(context).size.height - 120 - 60,
          child: ListView.builder(
            physics: BouncingScrollPhysics(),
            padding: EdgeInsets.fromLTRB(14, 5, 14, 5),
            scrollDirection: Axis.vertical,
            itemCount: _items.length,
            itemBuilder: (context, index) {
              var key = _items.keys.elementAt(index);
              var anime = _items[key];
              return new GestureDetector(
                onLongPress: () {
                  showModalBottomSheet(
                      backgroundColor: Colors.transparent,
                      context: context,
                      builder: (context) {
                        return Container(
                            height: 80,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.vertical(
                                    top: Radius.circular(20)),
                                color: Color(0xff111213)),
                            child: Column(
                                mainAxisSize: MainAxisSize.max,
                                children: [
                                  Expanded(
                                      child: Container(
                                          child: ListView(
                                              padding: EdgeInsets.fromLTRB(
                                                  0, 10, 0, 0),
                                              physics: BouncingScrollPhysics(),
                                              children: [
                                        ListTile(
                                            title: Text(
                                              'Удалить',
                                              style:
                                                  TextStyle(color: Colors.red),
                                            ),
                                            onTap: () async {
                                              Dio dio = Dio();
                                              var dir =
                                                  await getApplicationDocumentsDirectory();
                                              dio
                                                  .delete('${dir.path}/' +
                                                      anime.id +
                                                      '.mp4')
                                                  .then((value) {});
                                            }),
                                        Divider()
                                      ])))
                                ]));
                      });
                },
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => PageVideoDownload(id: anime.id)),
                  );
                },
                child: Container(
                  width: double.infinity,
                  height: 70,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    mainAxisSize: MainAxisSize.max,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      Expanded(
                          flex: 15,
                          child: Container(
                            width: double.infinity,
                            child: Padding(
                              padding: EdgeInsets.fromLTRB(10, 12, 12, 12),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(anime.parent.title,
                                      overflow: TextOverflow.ellipsis,
                                      style: TextStyle(
                                          fontFamily: 'Montserrat',
                                          fontWeight: FontWeight.w600,
                                          color: Colors.white,
                                          fontSize: 17)),
                                  Text(anime.index.toString() + ' серия',
                                      overflow: TextOverflow.ellipsis,
                                      style: TextStyle(
                                          fontFamily: 'Montserrat',
                                          fontWeight: FontWeight.w600,
                                          color: Color(0xbdffffff),
                                          fontSize: 13)),
                                ],
                              ),
                            ),
                          )),
                      Expanded(
                        flex: 1,
                        child: Center(
                          child: Icon(Icons.chevron_right,
                              color: Color(0xffd4d4d4)),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        )
      ],
    ));
  }
}
