import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mrtv_new_app_sl/services/api_state.dart';
import 'package:mrtv_new_app_sl/services/dio_http_service.dart';
import 'package:mrtv_new_app_sl/viewModels/audio/audio_viewmodel/radio_view_model.dart';
import 'package:mrtv_new_app_sl/views/audio/audio_search/audio_search_screen.dart';
import 'package:mrtv_new_app_sl/views/audio/audio_view/audio_view_grid_widget.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class AudtioNewScreen extends StatelessWidget {
  const AudtioNewScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final radioVM = Get.put(RadioViewModel(DioHttpService()));
    return GetBuilder<RadioViewModel>(
      builder: (radioVM) {
        switch (radioVM.status.value) {
          case ApiStatus.loading:
            return Center(child: CircularProgressIndicator());
          case ApiStatus.success:
            return Column(
              children: [
                Container(
                  color: theme.cardColor,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: TextField(
                      readOnly: true,
                      style: TextStyle(color: theme.textTheme.bodyLarge?.color),
                      decoration: InputDecoration(
                        hintText: "Search News...",
                        hintStyle: TextStyle(color: theme.hintColor),
                        prefixIcon: Icon(
                          Icons.search,
                          color: theme.iconTheme.color,
                        ),
                        suffixIcon: IconButton(
                          icon: Icon(Icons.clear, color: theme.iconTheme.color),
                          onPressed: () {
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (context) => AudioSearchScreen(),
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
                            builder: (context) => AudioSearchScreen(),
                          ),
                        );
                      },
                    ),
                  ),
                ),

                Expanded(
                  child: SmartRefresher(
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
                        //split widget
                        return AudioViewGridWidget(audio, index);
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
