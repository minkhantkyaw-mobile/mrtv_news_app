import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mrtv_new_app_sl/models/base_record.dart';
import 'package:mrtv_new_app_sl/models/local_new_model.dart';
import 'package:mrtv_new_app_sl/viewModels/bookmark/bookmark_controller.dart';
import 'package:mrtv_new_app_sl/viewModels/local/local_viewmodel/local_dialog_controller.dart';
import 'package:mrtv_new_app_sl/views/local/local_view/local_dialog_widget.dart';

class LocalViewGridWidget extends StatelessWidget {
  final Records video;
  const LocalViewGridWidget(this.video, {super.key});

  @override
  Widget build(BuildContext context) {
    // print(video);
    final bookmarkController = Get.put(BookmarkController());
    final source = "local_news";
    final theme = Theme.of(context);
    final textTheme = theme.textTheme;
    return GestureDetector(
      onTap: () {
        Get.dialog(
          LocalDialogWidget(
            videoUrl: video.video ?? '',
            title: video.title.toString() ?? '',
            body: video.body.toString() ?? '',
          ),
        ).then((_) {
          Get.delete<LocalDialogController>();
        });
      },
      child: Padding(
        padding: const EdgeInsets.all(4.0),
        child: Card(
          color:
              theme.brightness == Brightness.dark
                  ? const Color.fromARGB(255, 50, 50, 50)
                  : const Color.fromARGB(255, 247, 245, 223),
          elevation: 2,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: AspectRatio(
                    aspectRatio: 16 / 9,
                    child: Image.network(
                      video.image ?? '',
                      fit: BoxFit.cover,
                      errorBuilder:
                          (_, __, ___) => Center(
                            child: Text("No Image", style: textTheme.bodySmall),
                          ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 5),
                  child: Text(
                    video.title ?? 'No Title',
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: textTheme.bodyLarge?.copyWith(
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
                Expanded(
                  child: Row(
                    children: [
                      Text(
                        video.postedDate ?? 'No Date',
                        style: textTheme.bodySmall,
                      ),
                      Obx(() {
                        final isBookmarked = bookmarkController.isBookmarked(
                          source,
                          video.nid ?? 0,
                        );
                        return IconButton(
                          icon: Icon(
                            isBookmarked
                                ? Icons.bookmark
                                : Icons.bookmark_border,
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
              ],
            ),
          ),
        ),
      ),
    );
  }
}
