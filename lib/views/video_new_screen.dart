import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mrtv_new_app_sl/services/api_state.dart';
import 'package:mrtv_new_app_sl/services/dio_http_service.dart';
import 'package:mrtv_new_app_sl/viewModels/video_dialog_controller.dart';
import 'package:mrtv_new_app_sl/viewModels/video_view_model.dart';
import 'package:mrtv_new_app_sl/views/video_dialog_widget.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class VideoNewScreen extends StatelessWidget {
  const VideoNewScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final videoVM = Get.put(VideoViewModel(DioHttpService()));
    return GetBuilder<VideoViewModel>(
      builder: (videoVM) {
        switch (videoVM.status.value) {
          case ApiStatus.loading:
            return Center(child: CircularProgressIndicator());
          case ApiStatus.success:
            return SmartRefresher(
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
                ),
                itemCount: videoVM.records.length,
                itemBuilder: (context, index) {
                  final video = videoVM.records[index];
                  return GestureDetector(
                    onTap: () {
                      Get.dialog(
                        VideoDialogWidget(
                          videoUrl: video.video ?? '',
                          title: video.title.toString(),
                          body: video.body.toString(),
                        ),
                      ).then((_) {
                        Get.delete<VideoDialogController>();
                      });
                    },
                    child: Padding(
                      padding: const EdgeInsets.all(4.0),
                      child: Card(
                        color: const Color.fromARGB(255, 247, 245, 223),
                        elevation: 2,
                        child: Padding(
                          padding: const EdgeInsets.only(bottom: 10),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              ClipRRect(
                                borderRadius: BorderRadius.circular(10),
                                child: AspectRatio(
                                  aspectRatio: 16 / 9,
                                  child: Image.network(
                                    // height: MediaQuery.of(context).size.height / 10,
                                    // width: MediaQuery.of(context).size.width,
                                    fit: BoxFit.fill,
                                    video.image ?? 'Wait for image...',
                                  ),
                                ),
                              ),
                              SizedBox(height: 18),
                              Expanded(
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 8,
                                  ),
                                  child: Text(
                                    overflow: TextOverflow.ellipsis,
                                    maxLines: 2,
                                    video.title ?? 'No Title',
                                    style: TextStyle(
                                      fontSize: 18,
                                      color: Colors.black87,
                                      fontWeight: FontWeight.w400,
                                    ),
                                  ),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 2,
                                ),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    Text(
                                      overflow: TextOverflow.ellipsis,
                                      maxLines: 1,
                                      video.postedDate ?? 'No Date Available',
                                      style: TextStyle(
                                        fontSize: 10,
                                        fontWeight: FontWeight.w400,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
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
