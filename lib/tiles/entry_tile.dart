import 'package:day3/items/entry.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class EntryTile extends StatelessWidget {
  const EntryTile({
    Key key,
    @required this.entry,
    this.onTap,
    this.onTapTag,
  })  : assert(entry != null),
        super();

  final Entry entry;
  final VoidCallback onTap;
  final ValueChanged<EntryTag> onTapTag;

  @override
  Widget build(BuildContext context) => Card(
        child: ClipRRect(
          child: _child(context),
          borderRadius: BorderRadius.circular(8),
        ),
        margin: EdgeInsets.symmetric(horizontal: 8, vertical: 8),
        elevation: 4,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      );

  // Child
  Widget _child(BuildContext context) => Stack(
        children: [
          Positioned.fill(
            child: _image(context),
          ),
          Material(
            color: Colors.transparent,
            // 追加 タップ可能にするためInkWellで囲む
            child: InkWell(
              onTap: onTap,
              // childには元のWidgetを指定
              child: Column(
                children: [
                  AspectRatio(
                    aspectRatio: 2,
                  ),
                  // Containerではタップフィードバックが表示されないのでInkに変更
                  // Containerは文字部分がタップ指定されない
                  Ink(
                    color: Colors.white.withOpacity(0.9),
                    child: _body(context),
                  ),
                ],
              ),
            ),
          ),
        ],
      );

  //
  Widget _body(BuildContext context) => Padding(
        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // タイトル
            Text(
              entry.title,
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 2),
            if (entry.description.isNotEmpty)
              // 詳細がある場合は詳細を表示
              Text(
                entry.description,
                // 追加 最大2行
                maxLines: 2,
                // 追加 最後を丸める(...)
                overflow: TextOverflow.ellipsis,
                // 追加 テキストスタイル
                style: TextStyle(
                  fontSize: 13,
                  color: Colors.grey[700],
                ),
              ),
            SizedBox(
              height: 4,
            ),
            if (entry.tags.isNotEmpty)
              Padding(
                padding: EdgeInsets.only(bottom: 4),
                child: _tags(context),
              ),
            // ユーザ数, ドメイン名, 登録日時
            Row(
              children: [
                // ユーザ数
                Text(
                  '${entry.bookmarkCount} users',
                  // 追加 テキストスタイル
                  style: TextStyle(
                    color: Colors.red[400],
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(
                  width: 8,
                ),
                // ドメイン名
                Flexible(
                  child: Text(
                    entry.domain,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey[600],
                    ),
                  ),
                ),
                SizedBox(
                  width: 8,
                ),
                // 登録日時
                Text(
                  entry.date.formattedString,
                  // 追加 テキストスタイル
                  style: TextStyle(
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ],
        ),
      );

  // 画像表示
  Widget _image(BuildContext context) {
    if (entry.image == null) {
      return Container(
        color: Colors.grey,
      );
    }
    return Image.network(
      entry.image,
      fit: BoxFit.cover,
      errorBuilder: (context, error, stackTrace) {
        return Container(
          color: Colors.grey,
        );
      },
    );
  }

// 追加 タグ表示実装
  Widget _tags(BuildContext context) {
    return Wrap(
      alignment: WrapAlignment.start,
      spacing: 8,
      runSpacing: 2,
      crossAxisAlignment: WrapCrossAlignment.center,
      children: entry.tags
          .map(
            (e) => TextButton(
              onPressed: () => onTapTag?.call(e),
              child: Text(
                e.title,
                style: TextStyle(
                  fontSize: 11,
                ),
              ),
              style: ButtonStyle(
                tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                minimumSize: MaterialStateProperty.all(Size(0, 0)),
                padding: MaterialStateProperty.all(
                    EdgeInsets.symmetric(vertical: 2)),
              ),
            ),
          )
          .toList(),
    );
  }
}

// DateTimeに新しいメソッドを追加
extension _FortmattedString on DateTime {
  String get formattedString {
    final now = DateTime.now();
    final diff = now.difference(this);
    if (diff.inDays < 1) {
      // 当日の場合
      if (diff.inHours < 1) {
        // 1時間以内
        if (diff.inMinutes < 1) {
          // 1分以内
          return 'now';
        }
        return '${diff.inMinutes}分前';
      }
      return '${diff.inHours}時間前';
    } else if (diff.inDays < 30) {
      // 30日以内
      return '${diff.inDays}日前';
    }
    if (now.year == year) {
      // 同じ年の場合
      return DateFormat.MMMd('ja_JP').format(this);
    }
    return DateFormat.yMMMd('ja_JP').format(this);
  }
}
