import 'package:get/get.dart';
import 'package:mrtv_new_app_sl/models/audio_new_model.dart';
import 'package:mrtv_new_app_sl/services/api_state.dart';
import 'package:mrtv_new_app_sl/services/dio_http_service.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class AudioSearchController extends GetxController {
  List<Records> records = [];
  var status = ApiStatus.initial.obs;
  final DioHttpService _httpService;
  AudioSearchController(this._httpService);
  String searchKeyword = '';
  String _language = 'en / mm'; // or 'en'
  int _page = 1;
  int _totalPage = 1;
  final RefreshController refreshController = RefreshController();

  void setSearchKeyword(String keyword, {String lang = 'em / mm'}) {
    searchKeyword = keyword;
    _language = lang;
    _page = 1;
    fetchVideos();
  }

  Future<void> refreshVideos() async {
    _page = 1;
    fetchVideos(isRefresh: true);
    refreshController.refreshCompleted();
  }

  void fetchVideos({bool isRefresh = false}) async {
    if (isRefresh) {
      status.value = ApiStatus.loading;
    }
    try {
      final result = await _httpService.getRequest(
        'radio-news',
        params: {
          "pageno": _page,

          if (searchKeyword.isNotEmpty) "keyword": searchKeyword,
          "language": _language,
        },
      );

      if (result.status == ApiStatus.success) {
        _totalPage = result.data['pagination']['total_pages'];
        records =
            (result.data['records'] as List)
                .map((e) => Records.fromJson(e))
                .toList();
        update();
      }
    } catch (e) {
      print("error: $e");
    }
  }

  Future<void> loadMore() async {
    print(_totalPage);
    print(_page);
    if (_page >= _totalPage) {
      refreshController.loadNoData();
      return;
    }

    _page++;
    final result = await _httpService.getRequest(
      'radio-news',
      params: {
        "pageno": _page,
        if (searchKeyword.isNotEmpty) "keyword": searchKeyword,
        "language": _language,
      },
    );

    if (result.status == ApiStatus.success) {
      final more =
          (result.data['records'] as List)
              .map((e) => Records.fromJson(e))
              .toList();
      records.addAll(more);
      refreshController.loadComplete();
    } else {
      refreshController.loadFailed();
    }
    update();
  }
}
