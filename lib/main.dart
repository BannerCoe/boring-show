import 'dart:collection';

import 'package:boring_show/src/article.dart';
import 'package:boring_show/src/hn_bloc.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

void main() {
  final hnBloc = HackerNewsBloc();
  runApp(MyApp(hnBloc));
}

class MyApp extends StatelessWidget {
  final HackerNewsBloc bloc;

  MyApp(this.bloc);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(
        title: 'Flutter Hacker News',
        bloc: bloc,
      ),
    );
  }
}

class MyHomePage extends StatefulWidget {
  final HackerNewsBloc bloc;

  MyHomePage({Key key, this.title, this.bloc}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  var _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: StreamBuilder<UnmodifiableListView<Article>>(
        stream: widget.bloc.articles,
        initialData: UnmodifiableListView<Article>([]),
        builder: (context, snapshot) =>
            ListView(
              children: snapshot.data.map(_buildItem).toList(),
            ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        items: [
          BottomNavigationBarItem(
              title: Text("Top Stories"), icon: Icon(Icons.arrow_drop_up)),
          BottomNavigationBarItem(
              title: Text("News Stories"), icon: Icon(Icons.new_releases))
        ],
        onTap: (index) {
          if(index ==0) {
            widget.bloc.storiesType.add(StoriesType.topStories);
          }else{
            widget.bloc.storiesType.add(StoriesType.newStories);
          }
        },

      ),
    );
  }

  Widget _buildItem(Article article) {
    return Padding(
      key: Key(article.title),
      padding: const EdgeInsets.all(8.0),
      child: ExpansionTile(
        title: Text(
          article.title ?? '[null]',
          style: TextStyle(fontSize: 14),
        ),
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              Text("${article.type}"),
              IconButton(
                onPressed: () async {
                  if (await canLaunch(article.url)) {
                    launch(article.url);
                  }
                },
                icon: Icon(Icons.open_in_browser),
                color: Theme
                    .of(context)
                    .primaryColor,
              )
            ],
          ),
        ],
      ),
    );
  }
}
