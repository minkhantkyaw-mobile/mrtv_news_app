import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mrtv_new_app_sl/services/api_state.dart';
import 'package:mrtv_new_app_sl/services/dio_http_service.dart';
import 'package:mrtv_new_app_sl/viewModels/video/video_viewmodel/video_view_model.dart';
import 'package:mrtv_new_app_sl/views/video/video_search/video_search_screen.dart';
import 'package:mrtv_new_app_sl/views/video/video_view/video_view_grid_widget.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class VideoNewScreen extends StatelessWidget {
  const VideoNewScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final textTheme = theme.textTheme;
    final videoVM = Get.put(VideoViewModel(DioHttpService()));
    return GetBuilder<VideoViewModel>(
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
                    child: SizedBox(
                      height: 50, // or 48, adjust as needed
                      child: TextField(
                        readOnly: true,
                        decoration: InputDecoration(
                          hintText: "Search News...",
                          hintStyle: textTheme.labelSmall,
                          prefixIcon: Icon(Icons.search),
                          suffixIcon: IconButton(
                            icon: Icon(Icons.clear),
                            onPressed: () {
                              Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder: (context) => VideoSearchScreen(),
                                ),
                              );
                            },
                          ),
                          contentPadding: EdgeInsets.symmetric(
                            vertical: 0,
                            horizontal: 12,
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        onTap: () {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (context) => VideoSearchScreen(),
                            ),
                          );
                        },
                      ),
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
                        maxCrossAxisExtent: 300,
                        mainAxisExtent: 230,
                        mainAxisSpacing: 4,
                        crossAxisSpacing: 1,
                      ),
                      itemCount: videoVM.records.length,
                      itemBuilder: (context, index) {
                        final video = videoVM.records[index];

                        /// To Split Child Widget
                        return VideoViewGridWidget(video);
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

// if (ApiStatus.loading) {}
// else if 
// else