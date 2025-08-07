import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mrtv_new_app_sl/models/audio_new_model.dart';
import 'package:mrtv_new_app_sl/models/base_record.dart';
import 'package:mrtv_new_app_sl/services/dio_http_service.dart';
import 'package:mrtv_new_app_sl/viewModels/audio/audio_viewmodel/audio_dialog_controller.dart';
import 'package:mrtv_new_app_sl/viewModels/audio/audio_viewmodel/audio_handler.dart';
import 'package:mrtv_new_app_sl/viewModels/audio/audio_viewmodel/radio_view_model.dart';
import 'package:mrtv_new_app_sl/viewModels/bookmark/bookmark_controller.dart';
import 'package:mrtv_new_app_sl/views/audio/audio_view/autio_dialog_widget.dart';

class AudioViewGridWidget extends StatelessWidget {
  const AudioViewGridWidget(this.audio, this.index, {super.key});
  final Records audio;
  final int index;
  @override
  Widget build(BuildContext context) {
    final bookmarkController = Get.put(BookmarkController());
    final source = "radio_news";
    final theme = Theme.of(context);
    final radioVM = Get.put(RadioViewModel(DioHttpService()));
    return Padding(
      padding: EdgeInsets.all(2),
      child: GestureDetector(
        onTap: () async {
          if (Get.isRegistered<AudioDialogController>()) {
            final oldController = Get.find<AudioDialogController>();
            oldController.dispose(); // Stop audio safely
            await Future.delayed(
              Duration(milliseconds: 300),
            ); // give just_audio time to finish
            Get.delete<AudioDialogController>();
          }
          final MyAudioHandler audioHandler = MyAudioHandler();
          final controller = Get.put(AudioDialogController(audioHandler));

          Get.dialog(
            AutioDialogWidget(
              audioUrl: audio.audio ?? '',
              imageUrl: audio.image ?? '',
              title: audio.title.toString(),
              body: audio.body.toString(),
              playList: radioVM.records,
              startIndex: index,
            ),
          ).then((_) {
            if (Get.isRegistered<AudioDialogController>()) {
              final c = Get.find<AudioDialogController>();
              c.dispose();
              Get.delete<AudioDialogController>();
            }
          });
        },

        child: Card(
          color:
              theme.brightness == Brightness.dark
                  ? const Color.fromARGB(
                    255,
                    50,
                    50,
                    50,
                  ) // custom dark card color
                  : const Color.fromARGB(255, 247, 245, 223),
          elevation: 2,
          child: SizedBox(
            height: 118,
            child: Row(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: Image.network(
                    audio.image ?? 'https://via.placeholder.com/150',
                    height: double.infinity,
                    width: MediaQuery.of(context).size.width * 0.2,
                    fit: BoxFit.cover,
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(top: 8, left: 8, right: 8),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          audio.title ?? 'No Title',
                          style: theme.textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.w500,
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                        Align(
                          // alignment: Alignment.bottomRight,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              Text(
                                audio.postedDate ?? 'No Date',
                                style: theme.textTheme.bodySmall?.copyWith(
                                  color: theme.hintColor,
                                  fontSize: 12,
                                ),
                              ),
                              Obx(() {
                                final isBookmarked = bookmarkController
                                    .isBookmarked(source, audio.nid ?? 0);
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
                                      audio as BaseRecord,
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
              ],
            ),
          ),
        ),
      ),
    );
  }
}
