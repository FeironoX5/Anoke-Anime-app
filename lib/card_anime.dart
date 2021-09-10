import 'package:anokev2/page_anime.dart';
import 'package:anokev2/styles.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class CardAnime extends StatefulWidget {
  CardAnime(
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
  _CardAnimeState createState() => _CardAnimeState();
}

class _CardAnimeState extends State<CardAnime> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => PageAnime(
                    id: widget.id,
                    title: widget.title,
                    urlImagePreview: widget.urlImagePreview,
                    screenImage: widget.screenImage,
                    rating: widget.rating,
                    votes: widget.votes,
                    description: widget.description,
                    series: widget.series,
                    director: widget.director,
                    year: widget.year,
                    genre: widget.genre)),
          );
        },
        child: Container(
          margin: EdgeInsets.fromLTRB(8, 5, 8, 5),
          width: (MediaQuery.of(context).size.width / 2) - 24,
          height: MediaQuery.of(context).size.width * 0.75 + 30,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.max,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Expanded(
                  flex: 4,
                  child: Container(
                    width: double.infinity,
                    child: Stack(
                      alignment: AlignmentDirectional.topEnd,
                      children: [
                        Container(
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(14),
                            child: CachedNetworkImage(
                                imageUrl: widget.urlImagePreview,
                                fit: BoxFit.cover,
                                width: double.infinity,
                                height: double.infinity),
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.fromLTRB(0, 7, 7, 0),
                          child: Container(
                            width: 45,
                            height: 23,
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                              color: Color(0xffff6900),
                              borderRadius: BorderRadius.circular(7),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(Icons.star, color: Colors.white, size: 12),
                                Padding(
                                  padding: EdgeInsets.fromLTRB(1, 0, 0, 0),
                                  child: Text(
                                      (((widget.rating / widget.votes) * 10)
                                                  .floor() /
                                              10)
                                          .toString(),
                                      style: TextStyle(
                                          fontFamily: 'Montserrat',
                                          color: Colors.white,
                                          fontSize: StylesData().f3,
                                          fontWeight: FontWeight.w600)),
                                )
                              ],
                            ),
                          ),
                        )
                      ],
                    ),
                  )),
              Expanded(
                  flex: 1,
                  child: Container(
                    width: double.infinity,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(
                          height: 6,
                        ),
                        Container(
                          child: Text(widget.title.split('/')[0],
                              overflow: TextOverflow.ellipsis,
                              maxLines: 2,
                              style: TextStyle(
                                  fontFamily: 'Montserrat',
                                  fontWeight: FontWeight.w600,
                                  color: Colors.white,
                                  fontSize: StylesData().f2)),
                        ),
                        Text(widget.genre.split(',')[0],
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                                fontFamily: 'Montserrat',
                                fontWeight: FontWeight.w600,
                                color: Color(0xbdffffff),
                                fontSize: StylesData().f3))
                      ],
                    ),
                  ))
            ],
          ),
        ));
  }
}
