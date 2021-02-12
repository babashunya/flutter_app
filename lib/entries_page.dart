import 'package:flutter/material.dart';
import 'package:day3/items/feed.dart';

import 'dart:convert';
import 'package:day3/items/entry.dart';
import 'package:http/http.dart' as http;
import 'package:day3/tiles/entry_tile.dart';
import 'package:url_launcher/url_launcher.dart';

class EntriesPage extends StatefulWidget {
  const EntriesPage({
    Key key,
    @required this.feed,
  }) : super(key: key);

  final Feed feed;

  @override
  State<StatefulWidget> createState() => _EntriesPageState();
}

class _EntriesPageState extends State<EntriesPage>
    with AutomaticKeepAliveClientMixin {
  Future<List<Entry>> _future;

  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    _future = getEntries();
    super.initState();
  }

  @override
  Widget build(
    BuildContext context,
  ) {
    // ダミー
    super.build(context);
    return _build(context);
  }

  Widget _build(BuildContext context) => FutureBuilder<List<Entry>>(
        builder: (context, snapshot) {
          if (snapshot.connectionState != ConnectionState.done) {
            return loading(context);
          }
          if (snapshot.hasError) {
            print(snapshot.error);
            return Container();
          }
          return RefreshIndicator(
            child: list(context, snapshot.data),
            onRefresh: () async {
              final future = getEntries();
              await future;
              setState(() {
                // _fetureを更新する
                _future = future;
              });
            },
          );
        },
        future: _future,
      );

  // 追加 リスト
  Widget list(BuildContext context, List<Entry> entries) => ListView.builder(
        itemBuilder: (context, index) {
          final entry = entries[index];
          // 修正 EntryTileを使うようにする
          return EntryTile(
            entry: entry,
            onTap: () {
              // とりあえずタップされたエントリーのタイトルを出力
              print(entry.title);
              launch(
                entry.link,
                forceWebView: true,
                forceSafariVC: true,
              );
            },
            onTapTag: (tag) {
              // タグタイトルを出力
              print(tag.title);
              // ブラウザを開く
              launch(
                tag.link,
                forceWebView: true,
                forceSafariVC: true,
              );
            },
          );
        },
        itemCount: entries.length,
      );

  // 追加 ローディング
  Widget loading(BuildContext context) {
    return Center(
      child: CircularProgressIndicator(),
    );
  }

  // 追加 APIからエントリーリスト取得
  Future<List<Entry>> getEntries() async {
    // 人気のエントリーリストを取得
    final response = await http.get(
      'https://hatena-bookmark-api.herokuapp.com${widget.feed.hotentryUrl}',
    );
    print(response.body);
    // JSONデコード
    final items = jsonDecode(response.body) as List<dynamic>;
    // エントリーに変換
    return items.map<Entry>((e) => Entry.fromJson(e)).toList();
  }
}
