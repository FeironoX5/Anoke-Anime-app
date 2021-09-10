import 'package:flutter/cupertino.dart';

class AnimeCard {
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

  AnimeCard({
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
    this.genre,
  });

  factory AnimeCard.fromJson(Map<String, dynamic> json) {
    return AnimeCard(
      id: json['id'],
      title: json['title'],
      urlImagePreview: json['urlImagePreview'],
      screenImage: json['screenImage'],
      rating: json['rating'],
      votes: json['votes'],
      description: json['description'],
      series: json['series'],
      director: json['director'],
      year: json['year'],
      genre: json['genre'],
    );
  }
}

class AnimeD {
  final state;
  final data;

  AnimeD({
    this.state,
    this.data,
  });

  factory AnimeD.fromJson(Map<String, dynamic> json) {
    return AnimeD(
      state: json['state'],
      data: json['data'],
    );
  }
}
class DownloadedAnime {
  final parent;
  final id;
  final index;

  DownloadedAnime({
    this.parent,
    this.id,
    this.index,
  });

  factory DownloadedAnime.fromJson(Map<String, dynamic> json) {
    return DownloadedAnime(
      parent: AnimeCard(
        id: json['parent']['id'],
        title: json['parent']['title'],
        urlImagePreview: json['parent']['urlImagePreview'],
        screenImage: json['parent']['screenImage'],
        rating: json['parent']['rating'],
        votes: json['parent']['votes'],
        description: json['parent']['description'],
        series: json['parent']['series'],
        director: json['parent']['director'],
        year: json['parent']['year'],
        genre: json['parent']['genre'],
      ),
      id: json['id'],
      index: json['index'],
    );
  }
}

class AnimeList {
  List data = [];

  AnimeList({this.data});

  factory AnimeList.fromJson(json) {
    var animelist;
    for (var x in json) {
      animelist.add(AnimeCard.fromJson(x));
    }
    return animelist;
  }
}

class User {
  final String name;
  final String profileImageUrl;

  const User({
    @required this.name,
    @required this.profileImageUrl,
  });
}

