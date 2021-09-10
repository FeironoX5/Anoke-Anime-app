import 'dart:convert';
import 'package:anokev2/main.dart';
import 'package:anokev2/page_anime.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'card_anime.dart';
import 'models.dart';

class PageSearch extends StatefulWidget {
  @override
  _PageSearchState createState() => _PageSearchState();
}

class _PageSearchState extends State<PageSearch> {
  var sanime;
  final tC = TextEditingController();

  @override
  void initState() {
    super.initState();
    tCFocus = FocusNode();
    getSearched(false);
  }

  Future getSearched(st) async {
    if (sanime == null || st == true) {
      sanime = null;
      final response =
          await http.post(Uri.https('api.animevost.org', '/v1/search'), body: {
        'name': tC.text
      }, // Setting as body parameter
              headers: {
            'Content-Type': 'application/x-www-form-urlencoded',
            "Access-Control-Allow-Origin": "*",
            "Access-Control-Allow-Credentials": 'true',
            "Access-Control-Allow-Headers":
                "Origin,Content-Type,X-Amz-Date,Authorization,X-Api-Key,X-Amz-Security-Token,locale",
            "Access-Control-Allow-Methods": "POST, OPTIONS"
          });
      if (response.statusCode == 200) {
        var x = [];
        for (var i in AnimeD.fromJson(jsonDecode(response.body)).data) {
          x.add(AnimeCard.fromJson(i));
        }
        sanime = x;
        return sanime;
      } else {
        throw Exception('Что-то пошло не так :(');
      }
    } else {
      return sanime;
    }
  }

  @override
  void dispose() {
    tC.dispose();
    tCFocus.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        resizeToAvoidBottomInset: false,
        body: FutureBuilder(
          future: getSearched(false),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              return NotificationListener<OverscrollIndicatorNotification>(
                  onNotification: (OverscrollIndicatorNotification overscroll) {
                    overscroll.disallowGlow();
                  },
                  child: ListView.builder(
                    // padding: EdgeInsets.all(14),
                    itemCount: (snapshot.data.length / 2).floor() + 1,
                    // itemCount: snapshot.data.length,
                    itemBuilder: (context, index) {
                      if (index == 0) {
                        return Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                  height: 185,
                                  color: Color(0xff111213),
                                  width: double.infinity,
                                  child: Padding(
                                    padding:
                                        EdgeInsets.fromLTRB(15, 50, 20, 15),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text('Поиск',
                                            style: TextStyle(
                                              color: Colors.white,
                                              fontWeight: FontWeight.w700,
                                              fontSize: 40,
                                            )),
                                        SizedBox(height: 15),
                                        TextField(
                                          focusNode: tCFocus,
                                          controller: tC,
                                          onSubmitted: (value) {
                                            setState(() {
                                              getSearched(true);
                                            });
                                          },
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontWeight: FontWeight.w600,
                                            fontSize: 20,
                                          ),
                                          cursorColor: Color(0xffff6900),
                                          decoration: InputDecoration(
                                            hintText: 'Фильмы, сериалы',
                                            hintStyle: TextStyle(
                                              color: Color(0xbdffffff),
                                              fontWeight: FontWeight.w600,
                                              fontSize: 20,
                                            ),
                                            border: UnderlineInputBorder(
                                                borderRadius:
                                                    BorderRadius.circular(8)),
                                            filled: true,
                                            fillColor: Color(0xff18191e),
                                            contentPadding:
                                                const EdgeInsets.only(
                                                    left: 14.0,
                                                    bottom: 6.0,
                                                    top: 8.0),
                                          ),
                                        ),
                                      ],
                                    ),
                                  )),
                              SizedBox(
                                height: 15,
                              ),
                            ]);
                      }
                      var anime1;
                      var anime2;
                      try {
                        anime1 = snapshot.data[(index - 1) * 2];
                        anime2 = snapshot.data[(index - 1) * 2 + 1];
                      } catch (e) {
                        anime1 = snapshot.data[(index - 1) * 2];
                        return Padding(
                            padding: EdgeInsets.fromLTRB(8, 0, 8, 0),
                            child: Row(children: [
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
                            ]));
                      }

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
                          ));
                    },
                  ));
            } else if (snapshot.hasError) {
              return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                        height: 185,
                        color: Color(0xff111213),
                        width: double.infinity,
                        child: Padding(
                          padding: EdgeInsets.fromLTRB(16, 50, 20, 16),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('Поиск',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.w700,
                                    fontSize: 40,
                                  )),
                              SizedBox(height: 15),
                              TextField(
                                focusNode: tCFocus,
                                controller: tC,
                                onSubmitted: (value) {
                                  setState(() {
                                    getSearched(true);
                                  });
                                },
                                style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w600,
                                  fontSize: 20,
                                ),
                                cursorColor: Color(0xffff6900),
                                decoration: InputDecoration(
                                  hintText: 'Фильмы, сериалы',
                                  hintStyle: TextStyle(
                                    color: Color(0xbdffffff),
                                    fontWeight: FontWeight.w600,
                                    fontSize: 20,
                                  ),
                                  border: InputBorder.none,
                                  filled: true,
                                  fillColor: Color(0xff18191e),
                                  contentPadding: const EdgeInsets.only(
                                      left: 14.0, bottom: 6.0, top: 8.0),
                                ),
                              ),
                            ],
                          ),
                        )),
                  ]);
            }
            return Center(
              child: CircularProgressIndicator(),
            );
          },
        ));
  }
}
