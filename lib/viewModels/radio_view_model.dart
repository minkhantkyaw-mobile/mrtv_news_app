import 'package:get/get.dart';
import 'package:mrtv_new_app_sl/models/audio_new_model.dart';
import 'package:mrtv_new_app_sl/services/api_state.dart';
import 'package:mrtv_new_app_sl/services/http_provider.dart';
import 'package:mrtv_new_app_sl/services/http_service.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class RadioViewModel extends GetxController {
  // var videos = <VideoNewModel>[].obs;
  // var records = <Records>[].obs;
  List<Records> records = [];
  var status = ApiStatus.initial.obs;
  final RefreshController refreshController = RefreshController();

  late HttpProvider _httpProvider;

  RadioViewModel(this._httpProvider);

  int _page = 1;
  int _totalPage = 1;

  @override
  void onInit() {
    fetchVideos();
    super.onInit();
  }

  Future<void> refreshVideos() async {
    _page = 1;
    fetchVideos(isRefresh: true);
    refreshController.refreshCompleted();
  }

  Future<void> loadMoreVideos() async {
    if (_page >= _totalPage) {
      refreshController.loadNoData();
      return;
    }
    _page++;
    fetchVideos(isRefresh: false);
  }

  void fetchVideos({bool isRefresh = false}) async {
    if (isRefresh) {
      status.value = ApiStatus.loading;
    }
    try {
      status.value = ApiStatus.loading;
      final result = await _httpProvider.getRequest(
        'radio-news',
        params: {"page": 2},
      );
      status.value = result.status;
      if (result.status == ApiStatus.success) {
        _totalPage = result.data['pagination']['total_pages'];
        List<Records> fetched =
            (result.data['records'] as List)
                .map((e) => Records.fromJson(e))
                .toList();
        if (isRefresh) {
          records = fetched;
          refreshController.refreshCompleted();
        } else {
          records.addAll(fetched);
          refreshController.loadComplete();
        }
        update();
        status.value = ApiStatus.success;
      } else {
        status.value = result.status;
        if (isRefresh)
          refreshController.refreshFailed();
        else
          refreshController.loadFailed();
      }
      // var json = await HttpService.getRequest('radio-news'); // JSON map
      // var radioModel = RadioNewModel.fromJson(json);
      // records.value = radioModel.records ?? [];
    } catch (e) {
      print("error: $e");
    }
  }
}
