import 'package:flutter/material.dart';

class Feed {
  factory Feed.fromJson(dynamic json) => Feed(
        id: json['id'],
        name: json['name'],
        hotentryUrl: json['hotentry_url'],
        entrylistUrl: json['entrylist_url'],
      );

  Feed({
    @required this.id,
    @required this.name,
    @required this.hotentryUrl,
    @required this.entrylistUrl,
  }) : super();

  final String id;
  final String name;
  final String hotentryUrl;
  final String entrylistUrl;
}
