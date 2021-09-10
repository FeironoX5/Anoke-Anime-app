import 'package:anokev2/page_video.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:localstore/localstore.dart';
import 'package:path_provider/path_provider.dart';

import 'models.dart';

class PageAnime extends StatefulWidget {
  PageAnime(
      {Key key,
      this.id,
      this.title,
      this.urlImagePreview,
      this.screenImage,
      this.rating,
      this.votes,
      this.description,
      this.series,
      this.director,
      this.year,
      this.genre})
      : super(key: key);
  final id;
  final title;
  final urlImagePreview;
  final screenImage;
  final rating;
  final votes;
  final description;
  final series;
  final director;
  final year;
  final genre;

  @override
  _PageAnimeState createState() => _PageAnimeState();
}

class _PageAnimeState extends State<PageAnime> {
  bool closedDescr = true;
  var progress = [];
  final _db = Localstore.instance;
  final _items1 = {};
  final _items2 = {};
  final _items3 = {};
  final _itemsDownloads = {};
  var _subscription1;
  var _subscription2;
  var _subscription3;
  var _subscriptiond;

  getD() {
    _subscription1 = _db.collection('watching').stream.listen((event) {
      setState(() {
        final item = AnimeCard.fromJson(event);
        _items1.putIfAbsent(item.id, () => item);
      });
    });
    _subscription2 = _db.collection('willwatch').stream.listen((event) {
      setState(() {
        final item = AnimeCard.fromJson(event);
        _items2.putIfAbsent(item.id, () => item);
      });
    });
    _subscription3 = _db.collection('watched').stream.listen((event) {
      setState(() {
        final item = AnimeCard.fromJson(event);
        _items3.putIfAbsent(item.id, () => item);
      });
    });
    _subscriptiond = _db.collection('downloads').stream.listen((event) {
      setState(() {
        final item = DownloadedAnime.fromJson(event);
        _itemsDownloads.putIfAbsent(item.id, () => item);
      });
    });
  }

  @override
  initState() {
    getD();
    super.initState();
  }

  @override
  void dispose() {
    if (_subscription1 != null) _subscription1?.cancel();
    if (_subscription2 != null) _subscription2?.cancel();
    if (_subscription3 != null) _subscription3?.cancel();
    if (_subscriptiond != null) _subscriptiond?.cancel();
    super.dispose();
  }

  Future<void> downloadFile(videoid, index) async {
    Dio dio = Dio();
    var i = progress.length;
    progress.add([false, 0, videoid.toString()]);
    try {
      var dir = await getApplicationDocumentsDirectory();
      await dio.download(
          'https://video.animetop.info/' + videoid.toString() + '.mp4',
          '${dir.path}/' + videoid + '.mp4', onReceiveProgress: (rec, total) {
        setState(() {
          progress[i][0] = true;
          progress[i][1] = (rec / total) * 100;
        });
      }).then((value) {
        setState(() {
          progress[i][0] = false;
          progress[i][1] = 100;
          var db = Localstore.instance;
          var id = db.collection('downloads').doc().id;
          db.collection('downloads').doc(id).set({
            'parent': {
              'id': widget.id,
              'title': widget.title,
              'urlImagePreview': widget.urlImagePreview,
              'screenImage': widget.screenImage,
              'rating': widget.rating,
              'votes': widget.votes,
              'description': widget.description,
              'series': widget.series,
              'director': widget.director,
              'year': widget.year,
              'genre': widget.genre,
            },
            'id': videoid,
            'index': index,
          });
        });
      });
    } catch (e) {
      progress[i][0] = false;
      progress[i][1] = 0;
      return false;
    }
  }

  getDownloadStatus(videoid) {
    var x = [false, 0, videoid];
    for (var i in progress) {
      if (i[2] == videoid.toString()) {
        x = i;
      }
    }
    return x;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Column(
      children: [
        Expanded(
          child: CustomScrollView(
            physics: BouncingScrollPhysics(),
            slivers: [
              SliverAppBar(
                expandedHeight: 500,
                stretch: true,
                flexibleSpace: FlexibleSpaceBar(
                  stretchModes: [
                    StretchMode.zoomBackground,
                  ],
                  background: Stack(
                    fit: StackFit.expand,
                    children: [
                      Positioned.fill(
                          child: Container(
                        decoration: BoxDecoration(
                            image: DecorationImage(
                                image: CachedNetworkImageProvider(
                                    widget.urlImagePreview),
                                fit: BoxFit.cover)),
                      )),
                      Align(
                          alignment: Alignment.bottomCenter,
                          child: Container(
                            width: double.infinity,
                            decoration: BoxDecoration(
                                gradient: LinearGradient(
                                    colors: [Colors.transparent, Colors.black],
                                    begin: Alignment.topCenter,
                                    end: Alignment.bottomCenter)),
                            child: Padding(
                              padding: const EdgeInsets.all(15.0),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.end,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Container(
                                    child: Text(
                                      widget.title.split('/')[0],
                                      style: Theme.of(context)
                                          .textTheme
                                          .headline4
                                          .copyWith(
                                            color: Colors.white,
                                            fontWeight: FontWeight.bold,
                                          ),
                                    ),
                                  ),
                                  SizedBox(height: 5),
                                  Container(
                                    child: Text(
                                      widget.genre,
                                      style: TextStyle(
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                  SizedBox(
                                    height: 10,
                                  ),
                                  Container(
                                    width: (_items1[widget.id] == null &&
                                            _items2[widget.id] == null &&
                                            _items3[widget.id] == null)
                                        ? 235
                                        : 220,
                                    child: RaisedButton(
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(25),
                                        ),
                                        color: Colors.deepPurple,
                                        child: Row(
                                          children: [
                                            (_items1[widget.id] == null &&
                                                    _items2[widget.id] ==
                                                        null &&
                                                    _items3[widget.id] == null)
                                                ? Icon(Icons.add,
                                                    color: Colors.white,
                                                    size: 17)
                                                : Icon(Icons.remove,
                                                    color: Colors.white,
                                                    size: 17),
                                            SizedBox(
                                              width: 5,
                                            ),
                                            (_items1[widget.id] == null &&
                                                    _items2[widget.id] ==
                                                        null &&
                                                    _items3[widget.id] == null)
                                                ? Text('Добавить в коллекцию',
                                                    style: TextStyle(
                                                        color: Colors.white,
                                                        fontWeight:
                                                            FontWeight.w600))
                                                : Text('Убрать из коллекции',
                                                    style: TextStyle(
                                                        color: Colors.white,
                                                        fontWeight:
                                                            FontWeight.w600))
                                          ],
                                        ),
                                        onPressed: () {
                                          if (_items1[widget.id] == null &&
                                              _items2[widget.id] == null &&
                                              _items3[widget.id] == null) {
                                            showModalBottomSheet(
                                                backgroundColor:
                                                    Colors.transparent,
                                                context: context,
                                                builder: (context) {
                                                  return Container(
                                                    height: 250,
                                                    decoration: BoxDecoration(
                                                        borderRadius:
                                                            BorderRadius.vertical(
                                                                top: Radius
                                                                    .circular(
                                                                        20)),
                                                        color: Color(0xff111213)),
                                                    child: Column(
                                                      mainAxisSize:
                                                          MainAxisSize.max,
                                                      children: [
                                                        Expanded(
                                                          child: Container(
                                                            child: ListView(
                                                              padding:
                                                                  EdgeInsets
                                                                      .fromLTRB(
                                                                          0,
                                                                          10,
                                                                          0,
                                                                          0),
                                                              physics:
                                                                  BouncingScrollPhysics(),
                                                              children: [
                                                                ListTile(
                                                                    onTap:
                                                                        () async {
                                                                      final db =
                                                                          Localstore
                                                                              .instance;
                                                                      db
                                                                          .collection(
                                                                              'watching')
                                                                          .doc(widget
                                                                              .id
                                                                              .toString())
                                                                          .set({
                                                                        'id': widget
                                                                            .id,
                                                                        'title':
                                                                            widget.title,
                                                                        'urlImagePreview':
                                                                            widget.urlImagePreview,
                                                                        'screenImage':
                                                                            widget.screenImage,
                                                                        'rating':
                                                                            widget.rating,
                                                                        'votes':
                                                                            widget.votes,
                                                                        'description':
                                                                            widget.description,
                                                                        'series':
                                                                            widget.series,
                                                                        'director':
                                                                            widget.director,
                                                                        'year':
                                                                            widget.year,
                                                                        'genre':
                                                                            widget.genre
                                                                      });
                                                                      Navigator.pop(
                                                                          context);
                                                                    },
                                                                    title: Text(
                                                                      'Смотрю',
                                                                      style: TextStyle(
                                                                          color:
                                                                              Colors.white),
                                                                    )),
                                                                Divider(),
                                                                ListTile(
                                                                    onTap:
                                                                        () async {
                                                                      final db =
                                                                          Localstore
                                                                              .instance;
                                                                      db
                                                                          .collection(widget
                                                                              .id
                                                                              .toString())
                                                                          .doc(
                                                                              'watched')
                                                                          .set({
                                                                        'id': widget
                                                                            .id,
                                                                        'title':
                                                                            widget.title,
                                                                        'urlImagePreview':
                                                                            widget.urlImagePreview,
                                                                        'screenImage':
                                                                            widget.screenImage,
                                                                        'rating':
                                                                            widget.rating,
                                                                        'votes':
                                                                            widget.votes,
                                                                        'description':
                                                                            widget.description,
                                                                        'series':
                                                                            widget.series,
                                                                        'director':
                                                                            widget.director,
                                                                        'year':
                                                                            widget.year,
                                                                        'genre':
                                                                            widget.genre
                                                                      });
                                                                      Navigator.pop(
                                                                          context);
                                                                    },
                                                                    title: Text(
                                                                        'Буду смотреть',
                                                                        style: TextStyle(
                                                                            color:
                                                                                Colors.white))),
                                                                Divider(),
                                                                ListTile(
                                                                    onTap: () {
                                                                      final db =
                                                                          Localstore
                                                                              .instance;
                                                                      db
                                                                          .collection(
                                                                              'watched')
                                                                          .doc(widget
                                                                              .id
                                                                              .toString())
                                                                          .set({
                                                                        'id': widget
                                                                            .id,
                                                                        'title':
                                                                            widget.title,
                                                                        'urlImagePreview':
                                                                            widget.urlImagePreview,
                                                                        'screenImage':
                                                                            widget.screenImage,
                                                                        'rating':
                                                                            widget.rating,
                                                                        'votes':
                                                                            widget.votes,
                                                                        'description':
                                                                            widget.description,
                                                                        'series':
                                                                            widget.series,
                                                                        'director':
                                                                            widget.director,
                                                                        'year':
                                                                            widget.year,
                                                                        'genre':
                                                                            widget.genre
                                                                      });
                                                                      Navigator.pop(
                                                                          context);
                                                                    },
                                                                    title: Text(
                                                                        'Просмотрено',
                                                                        style: TextStyle(
                                                                            color:
                                                                                Colors.white))),
                                                              ],
                                                            ),
                                                          ),
                                                        )
                                                      ],
                                                    ),
                                                  );
                                                });
                                          } else {
                                            final db = Localstore.instance;
                                            setState(() {
                                              db
                                                  .collection('watching')
                                                  .doc(widget.id.toString())
                                                  .delete();
                                              db
                                                  .collection('watched')
                                                  .doc(widget.id.toString())
                                                  .delete();
                                              db
                                                  .collection('willwatch')
                                                  .doc(widget.id.toString())
                                                  .delete();
                                              _items1
                                                  .remove(widget.id);
                                              _items2
                                                  .remove(widget.id);
                                              _items3
                                                  .remove(widget.id);
                                              print(_items1);
                                            });
                                          }
                                        }),
                                  )
                                ],
                              ),
                            ),
                          )),
                    ],
                  ),
                ),
              ),
              SliverToBoxAdapter(
                  child: Container(
                color: Color(0xff000000),
                child: Container(
                  decoration: BoxDecoration(
                      color: Color(0xff18191e),
                      borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(20),
                          topRight: Radius.circular(20))),
                  child: Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Row(
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SizedBox(
                                height: 5,
                              ),
                              Text(
                                'Об аниме',
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 17,
                                    fontWeight: FontWeight.w700),
                              ),
                              SizedBox(
                                height: 6,
                              ),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Container(
                                    height: (closedDescr ? 70.0 : null),
                                    child: Stack(
                                      alignment: Alignment.topCenter,
                                      children: [
                                        Text(
                                          widget.description
                                              .toString()
                                              .replaceAll('<br />', ''),
                                          style: TextStyle(color: Colors.white),
                                        ),
                                        Container(
                                          decoration: BoxDecoration(
                                              gradient: LinearGradient(
                                                  colors: [
                                                Color(0x18191e),
                                                Color(0x18191e),
                                                (closedDescr
                                                    ? Color(0xff18191e)
                                                    : Color(0x18191e))
                                              ],
                                                  begin: Alignment.topCenter,
                                                  end: Alignment.bottomCenter)),
                                        )
                                      ],
                                    ),
                                  ),
                                  SizedBox(
                                    height: 5,
                                  ),
                                  InkWell(
                                    onTap: () {
                                      setState(() {
                                        closedDescr = !closedDescr;
                                      });
                                    },
                                    child: Text(
                                        (closedDescr
                                            ? 'Читать больше'
                                            : 'Свернуть'),
                                        style: TextStyle(
                                          color: Color(0xffff6900),
                                          fontWeight: FontWeight.w600,
                                        )),
                                  ),
                                ],
                              ),
                              SizedBox(
                                height: 20,
                              ),
                              Text(
                                'Оценки',
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 17,
                                    fontWeight: FontWeight.w700),
                              ),
                              SizedBox(
                                height: 6,
                              ),
                              Container(
                                width: double.infinity,
                                padding: EdgeInsets.all(20),
                                decoration: BoxDecoration(
                                    color: Color(0xFF2F2F2F),
                                    borderRadius: BorderRadius.circular(15)),
                                child: Column(
                                  children: [
                                    Text(
                                        (((widget.rating / widget.votes) * 10)
                                                    .floor() /
                                                10)
                                            .toString(),
                                        style: TextStyle(
                                            color: Color(0xFF0CB832),
                                            fontWeight: FontWeight.w700,
                                            fontSize: 60)),
                                    Text(
                                      widget.votes.toString() + ' оценок',
                                      style: TextStyle(
                                        color: Colors.white,
                                      ),
                                    )
                                  ],
                                ),
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              Table(
                                children: [
                                  TableRow(children: [
                                    TableCell(
                                      child: Container(
                                        margin: EdgeInsets.fromLTRB(0, 0, 5, 0),
                                        padding: EdgeInsets.all(20),
                                        decoration: BoxDecoration(
                                            color: Color(0xFF2F2F2F),
                                            borderRadius:
                                                BorderRadius.circular(15)),
                                        child: Column(
                                          children: [
                                            Text(
                                                widget.series
                                                    .split(',')
                                                    .length
                                                    .toString(),
                                                style: TextStyle(
                                                    color: Colors.white,
                                                    fontWeight: FontWeight.w700,
                                                    fontSize: 30)),
                                            Text(
                                              'серии',
                                              style: TextStyle(
                                                color: Colors.white,
                                              ),
                                            )
                                          ],
                                        ),
                                      ),
                                    ),
                                    TableCell(
                                      child: Container(
                                        margin: EdgeInsets.fromLTRB(5, 0, 5, 0),
                                        padding: EdgeInsets.all(20),
                                        decoration: BoxDecoration(
                                            color: Color(0xFF2F2F2F),
                                            borderRadius:
                                                BorderRadius.circular(15)),
                                        child: Column(
                                          children: [
                                            Text(widget.year,
                                                style: TextStyle(
                                                    color: Colors.white,
                                                    fontWeight: FontWeight.w700,
                                                    fontSize: 30)),
                                            Text(
                                              'год выпуска',
                                              style: TextStyle(
                                                color: Colors.white,
                                              ),
                                            )
                                          ],
                                        ),
                                      ),
                                    ),
                                  ])
                                ],
                              ),
                              SizedBox(
                                height: 20,
                              ),
                              Text(
                                'Скриншоты',
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 17,
                                    fontWeight: FontWeight.w700),
                              ),
                              SizedBox(
                                height: 6,
                              ),
                              Container(
                                height: 200,
                                child: ListView.builder(
                                  physics: BouncingScrollPhysics(),
                                  scrollDirection: Axis.horizontal,
                                  itemCount: widget.screenImage.length,
                                  itemBuilder: (context, index) {
                                    return Container(
                                      margin: EdgeInsets.fromLTRB(0, 0, 10, 0),
                                      decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(15),
                                          image: DecorationImage(
                                              image:
                                                  new CachedNetworkImageProvider(
                                                      'https://static.openni.ru' +
                                                          widget.screenImage[
                                                              index]),
                                              fit: BoxFit.cover)),
                                      width: 320,
                                      height: 200,
                                    );
                                  },
                                ),
                              )
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              )),
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.all(15.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Text(
                        'Список серий',
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 17,
                            fontWeight: FontWeight.w700),
                      ),
                    ],
                  ),
                ),
              ),
              SliverList(
                delegate: SliverChildBuilderDelegate((_, index) {
                  index = index + 1;
                  return ListTile(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => PageVideo(
                                id: widget.series
                                    .split(',')[index - 1]
                                    .split(':')[1]
                                    .replaceAll("'", ""))),
                      );
                    },
                    title: Text(
                      '$index серия',
                      style: TextStyle(
                        color: Colors.white,
                      ),
                    ),
                    trailing: GestureDetector(
                      onTap: () {
                        downloadFile(
                            widget.series
                                .split(',')[index - 1]
                                .split(':')[1]
                                .replaceAll("'", ""),
                            index);
                      },
                      child: getDownloadStatus(widget.series
                              .split(',')[index - 1]
                              .split(':')[1]
                              .replaceAll("'", ""))[0]
                          ? SizedBox(
                              width: 23,
                              height: 23,
                              child: CircularProgressIndicator(
                                  backgroundColor: Color(0x2cffffff),
                                  strokeWidth: 3,
                                  value: getDownloadStatus(widget.series
                                          .split(',')[index - 1]
                                          .split(':')[1]
                                          .replaceAll("'", ""))[1] /
                                      100),
                            )
                          : getDownloadStatus(widget.series
                                      .split(',')[index - 1]
                                      .split(':')[1]
                                      .replaceAll("'", ""))[1] ==
                                  100
                              ? Icon(
                                  Icons.file_download_done,
                                  color: Colors.white,
                                )
                              : Icon(Icons.download_sharp, color: Colors.white),
                    ),
                  );
                }, childCount: widget.series.split(',').length),
              ),
            ],
          ),
        ),
      ],
    ));
  }
}
