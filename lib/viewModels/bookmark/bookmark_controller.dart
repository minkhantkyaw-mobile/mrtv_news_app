import 'package:get/get.dart';
import 'package:hive/hive.dart';
import 'package:mrtv_new_app_sl/models/base_record.dart';
import 'package:mrtv_new_app_sl/models/bookMarkRecords.dart';

class BookmarkController extends GetxController {
  final RxSet<String> _keys = <String>{}.obs;
  final RxList<Bookmarkrecords> bookmarks = <Bookmarkrecords>[].obs;
  late Box<Bookmarkrecords> _bookmarkBox;

  @override
  void onInit() {
    super.onInit();
    _bookmarkBox = Hive.box<Bookmarkrecords>('bookmarks');
    _keys.addAll(_bookmarkBox.keys.cast<String>());
    loadBookmarks();
  }

  void loadBookmarks() {
    bookmarks.assignAll(_bookmarkBox.values.toList());
  }

  bool isBookmarked(String source, int nid) {
    return _keys.contains(_generateKey(source, nid));
  }

  void toggleBookmark(BaseRecord record, String source) {
    final key = _generateKey(source, record.nid ?? 0);
    if (_bookmarkBox.containsKey(key)) {
      _bookmarkBox.delete(key);
      _keys.remove(key); // update reactive state
    } else {
      final item = Bookmarkrecords.fromBaseRecord(record, source);
      _bookmarkBox.put(key, item);
      _keys.add(key); // update reactive state
      print(item.video);
    }
    loadBookmarks();
  }

  void removeBookmark(String source, int nid) {
    final key = _generateKey(source, nid);
    _bookmarkBox.delete(key);
    _keys.remove(key); // update reactive state
    loadBookmarks();
  }

  String _generateKey(String source, int nid) => '$source:$nid';
}
