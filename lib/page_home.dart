import 'dart:convert';
import 'package:anokev2/page_anime.dart';
import 'package:anokev2/styles.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_options.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'models.dart';
import 'card_anime.dart';

class PageHome extends StatefulWidget {
  PageHome({Key key, this.allanime}) : super(key: key);
  final allanime;

  @override
  _PageHomeState createState() => _PageHomeState();
}

class _PageHomeState extends State<PageHome> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder(
        future: widget.allanime,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return NotificationListener<OverscrollIndicatorNotification>(
                onNotification: (OverscrollIndicatorNotification overscroll) {
                  overscroll.disallowGlow();
                },
                child: ListView.builder(
                  itemCount: (snapshot.data.length / 2).floor(),
                  itemBuilder: (context, index) {
                    if (index == 0) {
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          CarouselSlider.builder(
                              itemCount: 4,
                              options: CarouselOptions(
                                enlargeStrategy:
                                    CenterPageEnlargeStrategy.height,
                                viewportFraction: 1,
                                aspectRatio: 1,
                                height:
                                    MediaQuery.of(context).size.height - 300,
                                autoPlay: true,
                                enlargeCenterPage: true,
                              ),
                              itemBuilder: (BuildContext context, int itemIndex,
                                      int x) =>
                                  GestureDetector(
                                    onTap: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) => PageAnime(
                                                id: snapshot.data[itemIndex].id,
                                                title: snapshot
                                                    .data[itemIndex].title,
                                                urlImagePreview: snapshot
                                                    .data[itemIndex]
                                                    .urlImagePreview,
                                                screenImage: snapshot
                                                    .data[itemIndex]
                                                    .screenImage,
                                                rating: snapshot
                                                    .data[itemIndex].rating,
                                                votes: snapshot
                                                    .data[itemIndex].votes,
                                                description: snapshot
                                                    .data[itemIndex]
                                                    .description,
                                                series: snapshot
                                                    .data[itemIndex].series,
                                                director: snapshot
                                                    .data[itemIndex].director,
                                                year: snapshot
                                                    .data[itemIndex].year,
                                                genre: snapshot
                                                    .data[itemIndex].genre)),
                                      );
                                    },
                                    child:
                                        Stack(fit: StackFit.expand, children: [
                                      Positioned.fill(
                                          child: Container(
                                        margin: EdgeInsets.only(bottom: 1),
                                        decoration: BoxDecoration(
                                            image: DecorationImage(
                                                image: new CachedNetworkImageProvider(
                                                    'https://static.openni.ru' +
                                                        snapshot.data[itemIndex]
                                                            .screenImage[0]),
                                                fit: BoxFit.cover,
                                                alignment:
                                                    Alignment.topCenter)),
                                      )),
                                      Align(
                                          alignment: Alignment.bottomCenter,
                                          child: Container(
                                              width: double.infinity,
                                              height: MediaQuery.of(context)
                                                      .size
                                                      .height -
                                                  400,
                                              decoration: BoxDecoration(
                                                  gradient: LinearGradient(
                                                      colors: [
                                                    Color(0x15161a),
                                                    Color(0x2d15161a),
                                                    Color(0xff18191e)
                                                  ],
                                                      begin:
                                                          Alignment.topCenter,
                                                      end: Alignment
                                                          .bottomCenter)),
                                              child: Padding(
                                                  padding: const EdgeInsets.all(
                                                      15.0),
                                                  child: Column(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment.end,
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .center,
                                                      children: [
                                                        Text(
                                                            snapshot
                                                                .data[itemIndex]
                                                                .title
                                                                .split('/')[0].split(':')[0]
                                                                .toString(),
                                                            textAlign: TextAlign
                                                                .center,
                                                            style: TextStyle(
                                                              color:
                                                                  Colors.white,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w700,
                                                              fontSize: 35,
                                                            )),
                                                        SizedBox(height: 5),
                                                        Text(
                                                          snapshot
                                                              .data[itemIndex]
                                                              .title
                                                              .split('/')[1]
                                                              .split('[')[0]
                                                              .toString(),
                                                          textAlign:
                                                              TextAlign.center,
                                                          style: TextStyle(
                                                            color: Colors.white,
                                                            fontWeight:
                                                                FontWeight.w600,
                                                            fontSize: StylesData().f1,
                                                          ),
                                                        ),
                                                        SizedBox(height: 80),
                                                        Row(
                                                          children: [
                                                            Text(
                                                              (((snapshot.data[itemIndex].rating / snapshot.data[itemIndex].votes) *
                                                                              10)
                                                                          .floor() /
                                                                      10)
                                                                  .toString(),
                                                              textAlign:
                                                                  TextAlign
                                                                      .center,
                                                              style: TextStyle(
                                                                color: Colors
                                                                    .white,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w600,
                                                                fontSize: StylesData().f3,
                                                              ),
                                                            ),
                                                            SizedBox(
                                                              width: 16,
                                                            ),
                                                            Text(
                                                              snapshot
                                                                  .data[
                                                                      itemIndex]
                                                                  .genre
                                                                  .toString()
                                                                  .split(
                                                                      ',')[0],
                                                              textAlign:
                                                                  TextAlign
                                                                      .center,
                                                              style: TextStyle(
                                                                color: Colors
                                                                    .white,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w600,
                                                                fontSize: StylesData().f3,
                                                              ),
                                                            ),
                                                            SizedBox(
                                                              width: StylesData().f3,
                                                            ),
                                                            Text(
                                                              snapshot
                                                                  .data[
                                                                      itemIndex]
                                                                  .year
                                                                  .toString(),
                                                              textAlign:
                                                                  TextAlign
                                                                      .center,
                                                              style: TextStyle(
                                                                color: Colors
                                                                    .white,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w600,
                                                                fontSize: StylesData().f3,
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                        SizedBox(
                                                          height: 10,
                                                        )
                                                      ]))))
                                    ]),
                                  )),
                          SizedBox(
                            height: 15,
                          ),
                        ],
                      );
                    }
                    if (index == 1) {
                      return SizedBox();
                    }
                    var anime1 = snapshot.data[(index) * 2];
                    var anime2 = snapshot.data[(index) * 2 + 1];

                    return new Padding(
                      padding: EdgeInsets.fromLTRB(8, 0, 8, 0),
                      child: Row(
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
                      ),
                    );
                  },
                ));
          } else if (snapshot.hasError) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset('dazai.png', width: 180),
                  SizedBox(
                    height: 15,
                  ),
                  SizedBox(
                    width: 150,
                    child: Text(
                      'Мы не можем загрузить данные',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Color(0xC3FFFFFF),
                        fontSize: 15,
                      ),
                    ),
                  ),
                ],
              ),
            );
          }
          return Center(
            child: CircularProgressIndicator(),
          );
        },
      ),
    );
  }
}
