import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mrtv_new_app_sl/services/dio_http_service.dart';
import 'package:mrtv_new_app_sl/viewModels/audio/audio_search/audio_search_controller.dart';
import 'package:mrtv_new_app_sl/views/audio/audio_view/audio_view_grid_widget.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class AudioSearchScreen extends StatefulWidget {
  const AudioSearchScreen({super.key});

  @override
  State<AudioSearchScreen> createState() => _AudioSearchScreenState();
}

class _AudioSearchScreenState extends State<AudioSearchScreen> {
  final FocusNode _focusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    // Trigger cursor to appear after build
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _focusNode.requestFocus();
    });
  }

  @override
  Widget build(BuildContext context) {
    final videoVM = Get.put(AudioSearchController(DioHttpService()));
    final TextEditingController _searchController = TextEditingController();
    final theme = Theme.of(context);
    final textTheme = theme.textTheme;
    final colorScheme = theme.colorScheme;
    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: AppBar(
        title: Image(
          height: MediaQuery.of(context).size.height / 4,
          width: MediaQuery.of(context).size.width / 4,
          image: NetworkImage(
            "https://upload.wikimedia.org/wikipedia/commons/b/bb/Mrtvchannellogo.png",
          ),
        ),
        // title: Text("MRTV"),
        backgroundColor: theme.appBarTheme.backgroundColor,
      ),
      body: Column(
        children: [
          // 🔍 Search Field
          Container(
            decoration: BoxDecoration(color: theme.cardColor),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextField(
                focusNode: _focusNode,
                controller: _searchController,
                decoration: InputDecoration(
                  hintText: "Search News...",
                  hintStyle: textTheme.bodyMedium,
                  prefixIcon: Icon(Icons.search, color: colorScheme.primary),

                  suffixIcon: IconButton(
                    icon: Icon(Icons.clear, color: colorScheme.primary),
                    onPressed: () {
                      _searchController.clear();
                      videoVM.setSearchKeyword(''); // clear search
                    },
                  ),
                  filled: true,
                  fillColor:
                      theme.inputDecorationTheme.fillColor ?? theme.cardColor,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                onChanged: (value) {
                  videoVM.setSearchKeyword(value, lang: 'en / mm'); // or 'en'
                },
              ),
            ),
          ),

          // 📰 ListView from ViewModel
          Expanded(
            child: GetBuilder<AudioSearchController>(
              builder: (videoVM) {
                if (videoVM.searchKeyword.isEmpty) {
                  return Center(
                    child: Text(
                      "🔍 Please enter a search term",
                      style: TextStyle(fontSize: 16, color: Colors.grey),
                    ),
                  );
                }

                if (videoVM.records.isEmpty) {
                  return Center(
                    child: Text(
                      "No results found",
                      style: TextStyle(fontSize: 16, color: Colors.grey),
                    ),
                  );
                }

                return SmartRefresher(
                  controller: videoVM.refreshController,
                  enablePullDown: true,
                  enablePullUp: true,
                  onRefresh: () {
                    videoVM.refreshVideos();
                  },
                  onLoading: () {
                    videoVM.loadMore();
                  },
                  child: ListView.builder(
                    addAutomaticKeepAlives: true,

                    itemCount: videoVM.records.length,
                    itemBuilder: (context, index) {
                      final video = videoVM.records[index];

                      /// To Split Child Widget
                      return AudioViewGridWidget(video, index);
                    },
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
