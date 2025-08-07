import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:mrtv_new_app_sl/viewModels/bookmark/bookmark_controller.dart';
import 'package:mrtv_new_app_sl/viewModels/video/video_viewmodel/video_dialog_controller.dart';
import 'package:mrtv_new_app_sl/views/video/video_view/video_dialog_widget.dart';

class BookmarkScreen extends StatelessWidget {
  const BookmarkScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(BookmarkController());

    return Scaffold(
      appBar: AppBar(title: Text("Bookmarks")),
      body: Obx(() {
        final bookmarks = controller.bookmarks;

        if (bookmarks.isEmpty) {
          return Center(child: Text("No bookmarks yet."));
        }

        return ListView.builder(
          itemCount: bookmarks.length,
          itemBuilder: (context, index) {
            final item = bookmarks[index];

            return ListTile(
              leading:
                  item.image != null
                      ? Image.network(item.image!, width: 60, fit: BoxFit.cover)
                      : Icon(Icons.image_not_supported),
              title: Text(item.title),
              subtitle: Text(item.postedDate ?? ''),
              trailing: IconButton(
                icon: Icon(Icons.delete),
                onPressed: () {
                  controller.removeBookmark(item.source ?? '', item.nid);
                },
              ),
              onTap: () {
                final url = item.video;
                print("Tapped video URL: $url");

                if (url == null || url.isEmpty) {
                  Get.snackbar("Error", "No video URL found for this item.");
                  return;
                }
                Get.dialog(
                  VideoDialogWidget(
                    videoUrl: item.video ?? '',
                    title: item.title,
                    body: item.body ?? '',
                  ),
                ).then((_) {
                  Get.delete<VideoDialogController>();
                });
              },
            );
          },
        );
      }),
    );
  }
}
