import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_connect/http/src/utils/utils.dart';
import 'package:mrtv_new_app_sl/services/api_state.dart';
import 'package:mrtv_new_app_sl/services/dio_http_service.dart';
import 'package:mrtv_new_app_sl/viewModels/radio_view_model.dart';
import 'package:mrtv_new_app_sl/viewModels/video_dialog_controller.dart';
import 'package:mrtv_new_app_sl/views/autio_dialog_widget.dart';
import 'package:mrtv_new_app_sl/views/video_dialog_widget.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class AudtioNewScreen extends StatelessWidget {
  const AudtioNewScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final radioVM = Get.put(RadioViewModel(DioHttpService()));
    return GetBuilder<RadioViewModel>(
      builder: (radioVM) {
        switch (radioVM.status.value) {
          case ApiStatus.loading:
            return Center(child: CircularProgressIndicator());
          case ApiStatus.success:
            return SmartRefresher(
              controller: radioVM.refreshController,
              enablePullDown: true,
              enablePullUp: true,
              onRefresh: () {
                radioVM.refreshVideos();
              },
              onLoading: () {
                radioVM.loadMoreVideos();
              },
              child: ListView.builder(
                addAutomaticKeepAlives: true,
                itemCount: radioVM.records.length,
                itemBuilder: (context, index) {
                  final audio = radioVM.records[index];
                  return Padding(
                    padding: EdgeInsets.all(2),
                    child: GestureDetector(
                      onTap: () {
                        Get.dialog(
                          AutioDialogWidget(
                            audioUrl: audio.audio ?? '',
                            imageUrl: audio.image ?? '',
                            title: audio.title.toString(),
                            body: audio.body.toString(),
                          ),
                        ).then((_) {
                          Get.delete<VideoDialogController>();
                        });
                      },

                      child: Card(
                        color: const Color.fromARGB(255, 247, 245, 223),
                        elevation: 2,
                        child: SizedBox(
                          height: 100,
                          child: Row(
                            children: [
                              ClipRRect(
                                borderRadius: BorderRadius.circular(10),
                                child: Image.network(
                                  audio.image ??
                                      'https://via.placeholder.com/150',
                                  height: double.infinity,
                                  width:
                                      MediaQuery.of(context).size.width * 0.2,
                                  fit: BoxFit.cover,
                                ),
                              ),
                              const SizedBox(width: 10),
                              Expanded(
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Column(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        audio.title ?? 'No Title',
                                        style: const TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.w400,
                                        ),
                                        maxLines: 2,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                      Align(
                                        alignment: Alignment.bottomRight,
                                        child: Text(
                                          audio.postedDate ?? 'No Date',
                                          style: TextStyle(
                                            fontSize: 12,
                                            color: Colors.grey[600],
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
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
