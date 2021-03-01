import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:url_launcher/url_launcher.dart';

void main() {
  runApp(NewsApp());
}

class NewsApp extends StatelessWidget {
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primaryColor: Colors.white,
      ),
      home: HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  static List<News> _news = List<News>();
  static List<News> _newsInApp = List<News>();

  Future<List<News>> comingNews() async {
    var url = 'http://www.mocky.io/v2/5ecfddf13200006600e3d6d0';
    var response = await http.get(url);
    var news = List<News>();

    if (response.statusCode == 200) {
      var notesJson = json.decode(response.body);
      for (var noteJson in notesJson) {
        news.add(News.fromJson(noteJson));
      }
    }
    return news;
  }

  @override
  void initState() {
    comingNews().then((value) {
      setState(() {
        _news.addAll(value);
        _newsInApp = _news;
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(97),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            Container(
              margin: EdgeInsets.only(top: 25),
              decoration: BoxDecoration(
                  color: Colors.white,
                  border: Border(
                      bottom: BorderSide(
                    width: 0.5,
                    color: Colors.white,
                  ))),
              child: AppBar(
                title: Text(
                  'News',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                    fontSize: 30,
                  ),
                ),
              ),
            )
          ],
        ),
      ),
      body: ListView.builder(
        itemBuilder: (context, index) {
          return _listItem(index);
        },
        itemCount: _newsInApp.length,
      ),
    );
  }

  _listItem(index) {
    return Container(
      child: Padding(
        padding: const EdgeInsets.only(left: 15, top: 1, right: 1, bottom: 1),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: <Widget>[
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(bottom: 15),
                    child: Text(
                      _newsInApp[index].title,
                      style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.black),
                    ),
                  ),
                ),
                Container(
                  height: 50,
                  child: Align(
                    alignment: Alignment.bottomCenter,
                    child: IconButton(
                      iconSize: 16,
                      color: Colors.black26,
                      alignment: Alignment.bottomCenter,
                      icon: Icon(Icons.arrow_forward_ios),
                      onPressed: () => Navigator.push(context,
                          MaterialPageRoute(builder: (context) {
                        String writer = _newsInApp[index].author;
                        String dat = _newsInApp[index].date;
                        return MaterialApp(
                            debugShowCheckedModeBanner: false,
                            home: Scaffold(
                              appBar: AppBar(
                                centerTitle: true,
                                backgroundColor: Colors.white,
                                leading: IconButton(
                                  iconSize: 20,
                                  color: Colors.blue,
                                  icon: Icon(Icons.arrow_back_ios),
                                  onPressed: () => Navigator.pop(context),
                                ),
                                title: Text(_newsInApp[index].title,
                                    style: TextStyle(
                                        color: Colors.black,
                                        fontSize: 15,
                                        fontWeight: FontWeight.bold)),
                              ),
                              body: SingleChildScrollView(
                                child: Center(
                                  child: Column(
                                    children: <Widget>[
                                      Container(
                                        height: 200,
                                        width: 400,
                                        margin: EdgeInsets.only(bottom: 10),
                                        child: Image.network(
                                            _newsInApp[index].image,
                                            fit: BoxFit.cover),
                                      ),
                                      ListTile(
                                          title: Container(
                                              child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: <Widget>[
                                          Text(
                                            _newsInApp[index].title,
                                            style: TextStyle(
                                                color: Colors.black,
                                                fontWeight: FontWeight.bold,
                                                fontSize: 15),
                                            textAlign: TextAlign.left,
                                          ),
                                          SizedBox(height: 8),
                                          Text(
                                            _newsInApp[index].publisher,
                                            style: TextStyle(
                                                color: Colors.black26),
                                          ),
                                          SizedBox(height: 12),
                                          Text(
                                            _newsInApp[index].text,
                                            textAlign: TextAlign.justify,
                                            style: TextStyle(wordSpacing: 2),
                                          ),
                                          SizedBox(height: 12),
                                          Text('Author: $writer'),
                                          SizedBox(height: 12),
                                          Text('Date: $dat'),
                                          SizedBox(height: 12),
                                          Text('Full story at: '),
                                          SizedBox(height: 5),
                                          InkWell(
                                            child: Text(
                                              _newsInApp[index].url,
                                              style: TextStyle(
                                                  color: Colors.orange),
                                            ),
                                            onTap: () async {
                                              if (await canLaunch(
                                                  _newsInApp[index].url)) {
                                                await launch(
                                                    _newsInApp[index].url);
                                              }
                                            },
                                          )
                                        ],
                                      )))
                                    ],
                                  ),
                                ),
                              ),
                            ));
                      })),
                    ),
                  ),
                )
              ],
            ),
            Text(
              _newsInApp[index].publisher,
              style: TextStyle(
                color: Colors.grey.shade600,
                fontSize: 17,
              ),
            ),
            SizedBox(
              height: 10,
              child: Padding(
                padding: const EdgeInsets.only(top: 6.0, bottom: 0),
                child: Divider(
                  color: Colors.black12,
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}

class News {
  String id;
  String url;
  String title;
  String text;
  String publisher;
  String author;
  String image;
  String date;

  News(this.id, this.url, this.title, this.text, this.publisher, this.author,
      this.image, this.date);

  News.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    url = json['url'];
    title = json['title'];
    text = json['text'];
    publisher = json['publisher'];
    author = json['author'];
    image = json['image'];
    date = json['date'];
  }
}
