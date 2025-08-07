import 'package:hive/hive.dart';
part 'bookmark_item_model.g.dart';

@HiveType(typeId: 0)
class BookmarkItem extends HiveObject {
  @HiveField(0)
  final int nid;

  @HiveField(1)
  final String title;

  @HiveField(2)
  final String? video;

  @HiveField(3)
  final String? image;

  @HiveField(4)
  final String? postedDate;

  @HiveField(5)
  final String? source;

  BookmarkItem({
    required this.nid,
    required this.title,
    this.video,
    this.image,
    this.postedDate,
    this.source,
  });
}
