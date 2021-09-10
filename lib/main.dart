import 'dart:convert';

import 'package:anokev2/page_bookmarks.dart';
import 'package:anokev2/page_downloads.dart';
import 'package:anokev2/page_home.dart';
import 'package:anokev2/page_search.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'models.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(MyApp());
}

FocusNode tCFocus;

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'Anoke',
        theme: ThemeData(
          fontFamily: 'Montserrat',
          scaffoldBackgroundColor: Color(0xff18191e),
          primaryColor: Color(0xff7058ff),
          accentColor: Color(0xffff6900),
          unselectedWidgetColor: Color(0xffdddddd),
        ),
        home: PageControllerContainer());
  }
}

class PageControllerContainer extends StatefulWidget {
  @override
  _PageControllerContainerState createState() =>
      _PageControllerContainerState();
}

class _PageControllerContainerState extends State<PageControllerContainer> {
  PageController _pageController;
  int pageIndex = 0;
  var toOpen = false;
  var allanime;

  onPageChanged(int newPageIndex) {
    setState(() {
      pageIndex = newPageIndex;
    });
  }

  onTap(int pageIndex) {
    _pageController.jumpToPage(
      pageIndex,
    );
    if (toOpen && pageIndex == 1) {
      tCFocus.requestFocus();
      SystemChannels.textInput.invokeMethod('TextInput.show');
    }
    if (pageIndex == 1) {
      toOpen = true;
    } else {
      // tCFocus.unfocus();
      toOpen = false;
    }
  }

  Future getAllAnime() async {
    if (allanime == null) {
      final response = await http.get(Uri.https(
          'api.animevost.org', '/v1/last', {'page': '1', 'quantity': '40'}));
      if (response.statusCode == 200) {
        var x = [];
        for (var i in AnimeD.fromJson(jsonDecode(response.body)).data) {
          x.add(AnimeCard.fromJson(i));
        }
        allanime = x;
        return allanime;
      } else {
        throw Exception('Failed to load');
      }
    } else {
      return allanime;
    }
  }

  void initState() {
    super.initState();
    getAllAnime();
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
    ));
    _pageController = PageController();
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  Widget build(BuildContext context) {
    return Scaffold(
        resizeToAvoidBottomInset: false,
        bottomNavigationBar: BottomNavigationBarTheme(
            data: BottomNavigationBarThemeData(
              backgroundColor: Color(0xff1e1f23),
            ),
            child: SizedBox(
                height: 60,
                width: double.infinity,
                child: BottomNavigationBar(
                  currentIndex: pageIndex,
                  onTap: onTap,
                  type: BottomNavigationBarType.fixed,
                  showSelectedLabels: false,
                  showUnselectedLabels: false,
                  items: [
                    BottomNavigationBarItem(
                        icon: ImageIcon(AssetImage('home.png')), label: 'home'),
                    BottomNavigationBarItem(
                        icon: ImageIcon(AssetImage('search.png')),
                        label: 'search'),
                    BottomNavigationBarItem(
                        icon: ImageIcon(AssetImage('bookmark.png')),
                        label: 'bookmarks'),
                    BottomNavigationBarItem(
                        icon: ImageIcon(AssetImage('folder.png')),
                        label: 'downloads'),
                  ],
                ))),
        body: PageView(
          children: [
            PageHome(allanime: getAllAnime()),
            PageSearch(),
            PageBookmarks(),
            PageDownloads(),
          ],
          controller: _pageController,
          onPageChanged: onPageChanged,
          physics: NeverScrollableScrollPhysics(),
        ));
  }
}
