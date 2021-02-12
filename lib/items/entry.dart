import 'package:flutter/material.dart';

// エントリー
class Entry {
  final String title;
  final String link;
  final String domain;
  final String description;
  final String image;
  final DateTime date;
  final List<EntryTag> tags;
  final int bookmarkCount;
  final String bookmarkCommentPageUrl;

  Entry({
    @required this.title,
    @required this.link,
    @required this.domain,
    @required this.description,
    @required this.image,
    @required this.date,
    @required this.tags,
    @required this.bookmarkCount,
    @required this.bookmarkCommentPageUrl,
  }) : super();

  factory Entry.fromJson(dynamic json) => Entry(
        title: json["title"],
        link: json['link'],
        domain: json['domain'],
        description: json['description'],
        image: json['image'],
        date: DateTime.tryParse(json['date'])?.toLocal(),
        tags: json['tags'].map<EntryTag>((e) => EntryTag.fromJson(e)).toList(),
        bookmarkCount: json['bookmark_count'],
        bookmarkCommentPageUrl: json['bookmark_comment_list_page_url'],
      );
}

// エントリーのタグ
class EntryTag {
  final String title;
  final String link;

  EntryTag({
    @required this.title,
    @required this.link,
  }) : super();

  factory EntryTag.fromJson(dynamic json) => EntryTag(
        title: json['title'],
        link: json['link'],
      );
}
