import 'package:flutter/material.dart';
import 'dart:convert'; // jsonのデーコード
import 'package:day3/items/feed.dart'; // フィードオブジェクト
import 'package:http/http.dart' as http; // 通信ライブラリ
import 'package:day3/entries_page.dart';

class MainPage extends StatefulWidget {
  const MainPage({
    Key key,
  }) : super(key: key);

  @override
  State<StatefulWidget> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  // 追加 通信の状態を保持
  Future<List<Feed>> _future;

  @override
  void initState() {
    // 追加 ここが通ったタイミングで通信が行われる
    _future = getFeeds();
    super.initState();
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(
          title: const Text('はてなブックマーク'),
        ),
        body: body(context),
      );
  // ボディ部分を追加
  Widget body(BuildContext context) => FutureBuilder<List<Feed>>(
        builder: (context, snapshot) {
          if (snapshot.connectionState != ConnectionState.done) {
            return loading(context);
          }
          // タブ表示部分を返却する
          return tab(context, snapshot.data);
        },
        // ここを修正
        future: _future,
      );

  // タブを表示
  Widget tab(BuildContext context, List<Feed> feeds) => DefaultTabController(
        // タブ数はフィードリスト分
        length: feeds.length,
        child: Column(
          mainAxisSize: MainAxisSize.max,
          children: [
            // タブバーを表示
            TabBar(
              isScrollable: true,
              labelColor: Colors.black,
              tabs: feeds
                  .map<Widget>(
                    (e) => Tab(
                      text: e.name,
                    ),
                  )
                  .toList(),
            ),
            // 残り部分をいっぱい使う
            Expanded(
              // タブが変更されるとこちらTabBarViewで定義されたWidgetが表示される
              child: TabBarView(
                children: feeds
                    .map<Widget>(
                      // EntriesPageを表示するように変更
                      (e) => EntriesPage(feed: e),
                    )
                    .toList(),
              ),
            ),
          ],
        ),
      );

  // 通信中の画面を追加
  Widget loading(BuildContext context) => Center(
        child: CircularProgressIndicator(),
      );

  Future<List<Feed>> getFeeds() async {
    // APIにアクセス
    final response = await http.get(
      'https://hatena-bookmark-api.herokuapp.com/feeds',
    );
    // 本来はstatusCodeの確認などをする必要があるがここではなにもしない
    // デバッグ用に結果をコンソールに出力
    print(response.body);
    // JSONのデコード
    final items = jsonDecode(response.body) as List<dynamic>;
    // フィードオブジェクトを作成して返却
    return items.map<Feed>((e) => Feed.fromJson(e)).toList();
  }
}
