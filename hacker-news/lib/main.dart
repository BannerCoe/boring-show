import 'package:flutter/material.dart';
import 'src/article.dart';
import 'package:url_launcher/url_launcher.dart';

void main() => runApp(new MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      title: 'Expend list',
      theme: new ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: new MyHomePage(title: 'Expend list'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  _MyHomePageState createState() => new _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  List<Article> _articles = articles;

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: new Text(widget.title),
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          /* Scaffold.of(context)
              .showSnackBar(new SnackBar(content: new Text("Hello")));*/

          setState(() {
            _articles.removeAt(0);
          });
        },
        child: new ListView(
          children: _articles.map(_buildItem).toList(),
        ),
      ),
    );
  }

  Widget _buildItem(Article e) {
    void _openUrl(String url) async {
      if (await canLaunch(url)) {
        launch(url);
      }
    }

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: new ExpansionTile(
        title: new Text(e.text, style: new TextStyle(fontSize: 24.0)),
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              new Text(" ${e.commentsCount} comments"),
              new IconButton(
                icon: new Icon(Icons.launch),
                color: Colors.cyan,
                onPressed: () {
                  _openUrl(e.domain);
                },
              )
            ],
          ),
        ],
      ),
    );
  }
}
