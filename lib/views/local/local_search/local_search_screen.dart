import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mrtv_new_app_sl/services/dio_http_service.dart';
import 'package:mrtv_new_app_sl/viewModels/local/local_search/local_search_controller.dart';
import 'package:mrtv_new_app_sl/views/local/local_view/local_view_grid_widget.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class LocalSearchScreen extends StatefulWidget {
  const LocalSearchScreen({super.key});

  @override
  State<LocalSearchScreen> createState() => _LocalSearchScreenState();
}

class _LocalSearchScreenState extends State<LocalSearchScreen> {
  final FocusNode _focusNode = FocusNode();
  // final videoVM = Get.put(LocalSearchController(DioHttpService()));

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
    final theme = Theme.of(context);
    final videoVM = Get.put(LocalSearchController(DioHttpService()));
    final TextEditingController _searchController = TextEditingController();
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
        backgroundColor:
            theme.appBarTheme.backgroundColor ?? theme.scaffoldBackgroundColor,
        // backgroundColor: const Color.fromARGB(235, 252, 249, 234),
      ),
      body: Column(
        children: [
          // 🔍 Search Field
          Container(
            color: theme.cardColor,

            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextField(
                focusNode: _focusNode,
                controller: _searchController,
                decoration: InputDecoration(
                  hintText: "Search News...",
                  hintStyle: TextStyle(color: theme.hintColor),
                  prefixIcon: Icon(Icons.search, color: theme.iconTheme.color),
                  suffixIcon: IconButton(
                    icon: Icon(Icons.clear, color: theme.iconTheme.color),
                    onPressed: () {
                      _searchController.clear();
                      videoVM.setSearchKeyword(''); // clear search
                    },
                  ),
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
            child: GetBuilder<LocalSearchController>(
              builder: (videoVM) {
                if (videoVM.searchKeyword.isEmpty) {
                  return Center(
                    child: Text(
                      "🔍 Please enter a search term",
                      style: TextStyle(
                        fontSize: 16,
                        color: theme.textTheme.bodySmall?.color?.withOpacity(
                          0.6,
                        ),
                      ),
                    ),
                  );
                }

                if (videoVM.records.isEmpty) {
                  return Center(
                    child: Text(
                      "No results found",
                      style: TextStyle(
                        fontSize: 16,
                        color: theme.textTheme.bodySmall?.color?.withOpacity(
                          0.6,
                        ),
                      ),
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
                  child: GridView.builder(
                    addAutomaticKeepAlives: true,
                    gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
                      maxCrossAxisExtent: 300, // dynamically adjust columns
                    ),
                    itemCount: videoVM.records.length,
                    itemBuilder: (context, index) {
                      final video = videoVM.records[index];
                      // print(video);

                      /// To Split Child Widget
                      return LocalViewGridWidget(video);
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
