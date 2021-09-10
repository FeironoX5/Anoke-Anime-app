import 'package:anokev2/main.dart';
import 'package:anokev2/models.dart';
import 'package:anokev2/page_anime.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:localstore/localstore.dart';

import 'card_anime.dart';

class BookmarksViewer extends StatefulWidget {
  BookmarksViewer({Key key, this.data}) : super(key: key);

  final data;

  @override
  _BookmarksViewerState createState() => _BookmarksViewerState();
}

class _BookmarksViewerState extends State<BookmarksViewer> {
  @override
  Widget build(BuildContext context) {
    if (widget.data.length == 0) {
      return Center(
          child: GestureDetector(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(
              padding: EdgeInsets.fromLTRB(40, 0, 40, 0),
              child: Text(
                'Чтобы добавить фильм в список нажмите на кнопку на странице аниме',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Color(0xA9FFFFFF),
                  fontSize: 15,
                ),
              ),
            ),
            SizedBox(
              height: 20,
            ),
          ],
        ),
      ));
    }
    return Padding(
        padding: EdgeInsets.fromLTRB(8, 0, 8, 0),
        child: ListView.builder(
          padding: EdgeInsets.only(top: 13),
          physics: BouncingScrollPhysics(),
          itemCount: (widget.data.length / 2).ceil(),
          itemBuilder: (context, index) {
            var anime1;
            var anime2;
            try {
              var key1 = widget.data.keys.elementAt((index) * 2);
              var key2 = widget.data.keys.elementAt((index) * 2 + 1);
              anime1 = widget.data[key1];
              anime2 = widget.data[key2];
            } catch (e) {
              var key1 = widget.data.keys.elementAt((index) * 2);
              anime1 = widget.data[key1];
              return Row(children: [
                CardAnime(
                  id: anime1.id,
                  title: anime1.title,
                  urlImagePreview: anime1.urlImagePreview,
                  screenImage: anime1.screenImage,
                  rating: anime1.rating,
                  votes: anime1.votes,
                  description: anime1.description,
                  series: anime1.series,
                  director: anime1.director,
                  year: anime1.year,
                  genre: anime1.genre,
                ),
              ]);
            }

            return new Row(
              children: [
                CardAnime(
                  id: anime1.id,
                  title: anime1.title,
                  urlImagePreview: anime1.urlImagePreview,
                  screenImage: anime1.screenImage,
                  rating: anime1.rating,
                  votes: anime1.votes,
                  description: anime1.description,
                  series: anime1.series,
                  director: anime1.director,
                  year: anime1.year,
                  genre: anime1.genre,
                ),
                CardAnime(
                  id: anime2.id,
                  title: anime2.title,
                  urlImagePreview: anime2.urlImagePreview,
                  screenImage: anime2.screenImage,
                  rating: anime2.rating,
                  votes: anime2.votes,
                  description: anime2.description,
                  series: anime2.series,
                  director: anime2.director,
                  year: anime2.year,
                  genre: anime2.genre,
                ),
              ],
            );
          },
        ));
  }
}

class PageBookmarks extends StatefulWidget {
  @override
  _PageBookmarksState createState() => _PageBookmarksState();
}

class _PageBookmarksState extends State<PageBookmarks> {
  final _db = Localstore.instance;
  final _items1 = {};
  final _items2 = {};
  final _items3 = {};
  var _subscription1;
  var _subscription2;
  var _subscription3;

  @override
  initState() {
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
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
        length: 3,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
                height: 170,
                color: Color(0xff111213),
                width: double.infinity,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: EdgeInsets.fromLTRB(15, 50, 20, 15),
                      child: Text('Закладки',
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w700,
                            fontSize: 40,
                          )),
                    ),
                    TabBar(
                      isScrollable: true,
                      indicatorColor: Colors.transparent,
                      labelStyle: TextStyle(
                        color: Colors.white,
                        fontFamily: 'Montserrat',
                        fontWeight: FontWeight.w600,
                        fontSize: 20,
                      ),
                      unselectedLabelStyle: TextStyle(
                        color: Color(0xbdffffff),
                        fontFamily: 'Montserrat',
                        fontWeight: FontWeight.w600,
                      ),
                      physics: BouncingScrollPhysics(),
                      tabs: [
                        Tab(text: 'Смотрю'),
                        Tab(text: 'Буду смотреть'),
                        Tab(text: 'Просмотрено'),
                      ],
                    ),
                  ],
                )),
            SizedBox(
                height: MediaQuery.of(context).size.height - 230,
                width: double.infinity,
                child: TabBarView(
                  physics: BouncingScrollPhysics(),
                  children: [
                    BookmarksViewer(data: _items1),
                    BookmarksViewer(data: _items2),
                    BookmarksViewer(data: _items3),
                  ],
                ))
          ],
        ));
  }
}
