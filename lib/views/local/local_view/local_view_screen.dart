import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mrtv_new_app_sl/services/api_state.dart';
import 'package:mrtv_new_app_sl/services/dio_http_service.dart';
import 'package:mrtv_new_app_sl/viewModels/local/local_viewmodel/local_view_model.dart';
import 'package:mrtv_new_app_sl/views/local/local_search/local_search_screen.dart';
import 'package:mrtv_new_app_sl/views/local/local_view/local_view_grid_widget.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class LocalViewScreen extends StatelessWidget {
  const LocalViewScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final videoVM = Get.put(LocalViewModel(DioHttpService()));
    return GetBuilder<LocalViewModel>(
      builder: (videoVM) {
        switch (videoVM.status.value) {
          case ApiStatus.loading:
            return Center(child: CircularProgressIndicator());
          case ApiStatus.success:
            return Column(
              children: [
                Container(
                  decoration: BoxDecoration(
                    color: Theme.of(context).scaffoldBackgroundColor,
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: TextField(
                      readOnly: true,
                      decoration: InputDecoration(
                        hintText: "Search News...",
                        prefixIcon: Icon(Icons.search),
                        suffixIcon: IconButton(
                          icon: Icon(Icons.clear),
                          onPressed: () {
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (context) => LocalSearchScreen(),
                              ),
                            );
                          },
                        ),

                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      onTap: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) => LocalSearchScreen(),
                          ),
                        );
                      },
                    ),
                  ),
                ),

                Expanded(
                  child: SmartRefresher(
                    controller: videoVM.refreshController,
                    enablePullDown: true,
                    enablePullUp: true,
                    onRefresh: () {
                      videoVM.refreshVideos();
                    },
                    onLoading: () {
                      videoVM.loadMoreVideos();
                    },
                    child: GridView.builder(
                      addAutomaticKeepAlives: true,
                      gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
                        maxCrossAxisExtent: 300, // dynamically adjust columns
                          mainAxisSpacing: 10,
                          crossAxisSpacing: 2,
                          childAspectRatio: 0.85
                      ),
                      itemCount: videoVM.records.length,
                      itemBuilder: (context, index) {
                        final video = videoVM.records[index];

                        /// To Split Child Widget
                        return LocalViewGridWidget(video);
                      },
                    ),
                  ),
                ),
              ],
            );
          case ApiStatus.clientError:
            return Center(child: Text("Client Error: Bad request"));
          case ApiStatus.serverError:
            return Center(child: Text("Server Error: Please try again later"));
          case ApiStatus.networkError:
            return Center(child: Text("Network Error: Check your internet"));
          default:
            return Center(child: Text("Unknown Error"));
        }
      },
    );
  }
}
