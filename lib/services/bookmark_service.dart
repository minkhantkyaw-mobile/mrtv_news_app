import 'package:hive/hive.dart';
import 'package:mrtv_new_app_sl/models/bookMarkRecords.dart';

class BookmarkService {
  static const _boxName = 'bookmarks';

  late Box<Bookmarkrecords> _bookmarkBox;

  BookmarkService();

  Future<void> init() async {
    if (!Hive.isBoxOpen(_boxName)) {
      _bookmarkBox = await Hive.openBox<Bookmarkrecords>(_boxName);
    } else {
      _bookmarkBox = Hive.box<Bookmarkrecords>(_boxName);
    }
  }

  List<Bookmarkrecords> getAllBookmarks() => _bookmarkBox.values.toList();

  bool isBookmarked(String source, int nid) {
    return _bookmarkBox.containsKey(_generateKey(source, nid));
  }

  void addBookmark(Bookmarkrecords item) {
    final key = _generateKey(item.source ?? 'unknown', item.nid ?? 0);
    _bookmarkBox.put(key, item);
  }

  void removeBookmark(String source, int nid) {
    final key = _generateKey(source, nid);
    _bookmarkBox.delete(key);
  }

  String _generateKey(String source, int nid) => '$source:$nid';
}
