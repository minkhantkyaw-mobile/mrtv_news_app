import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mrtv_new_app_sl/models/base_record.dart';
import 'package:mrtv_new_app_sl/models/video_new_model.dart';
import 'package:mrtv_new_app_sl/viewModels/bookmark/bookmark_controller.dart';
import 'package:mrtv_new_app_sl/viewModels/download/download_controller.dart';
import '../../../viewModels/video/video_viewmodel/video_dialog_controller.dart';
import 'video_dialog_widget.dart';

class VideoViewGridWidget extends StatelessWidget {
  final Records video;
  const VideoViewGridWidget(this.video, {super.key});

  @override
  Widget build(BuildContext context) {
    final bookmarkController = Get.put(BookmarkController());
    final source = "national_news";
    final theme = Theme.of(context);
    final textTheme = theme.textTheme;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 6),
      child: GestureDetector(
        onLongPress: () {
          final downloadController = Get.find<DownloadController>();
          final downloadUrl = video.video ?? '';
          final fileName = "${video.title ?? 'media'}.mp4";

          if (downloadUrl.isEmpty) {
            Get.snackbar("Download Failed", "No media URL found");
            return;
          }

          Get.bottomSheet(
            Container(
              color: Get.isDarkMode ? Colors.grey[900] : Colors.white,
              padding: const EdgeInsets.all(16),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  ListTile(
                    leading: Icon(Icons.download),
                    title: Text("Download"),
                    onTap: () {
                      Get.back(); // close bottom sheet
                      downloadController.downloadFile(downloadUrl, fileName);
                    },
                  ),
                  Obx(() {
                    return downloadController.downloading.value
                        ? Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: LinearProgressIndicator(),
                        )
                        : SizedBox.shrink();
                  }),
                ],
              ),
            ),
          );
        },

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
        child: Card(

          color: theme.brightness == Brightness.dark
              ? const Color.fromARGB(255, 50, 50, 50)
              : const Color.fromARGB(255, 247, 245, 223),
          elevation: 2,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ClipRRect(
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(10),
                  topRight: Radius.circular(10),
                ),
                child: AspectRatio(
                  aspectRatio: 16 / 9,
                  child: Image.network(
                    video.image ?? '',
                    fit: BoxFit.cover,
                    errorBuilder: (_, __, ___) => Center(
                      child: Text("No Image", style: textTheme.bodySmall),
                    ),
                  ),
                ),
              ),

              // Title
              Padding(
                padding: const EdgeInsets.only(top: 6, right: 8, left: 8),
                child: Text(
                  video.title ?? 'No Title',
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: textTheme.bodyMedium?.copyWith(
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),

              const SizedBox(height: 6),

              // Date + Bookmark
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      video.postedDate ?? 'No Date',
                      style: textTheme.labelSmall,
                    ),
                    Obx(() {
                      final isBookmarked = bookmarkController.isBookmarked(
                        source,
                        video.nid ?? 0,
                      );
                      return IconButton(
                        padding: EdgeInsets.zero,
                        constraints: const BoxConstraints(),
                        icon: Icon(
                          isBookmarked ? Icons.bookmark : Icons.bookmark_border,
                          color: isBookmarked ? Colors.amber : null,
                          size: 20,
                        ),
                        onPressed: () {
                          bookmarkController.toggleBookmark(
                            video as BaseRecord,
                            source,
                          );
                        },
                      );
                    }),
                  ],
                ),
              ),
              const SizedBox(height: 6),
            ],
          ),
        ),

      ),
    );
  }
}
