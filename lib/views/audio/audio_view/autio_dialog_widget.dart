import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mrtv_new_app_sl/models/audio_new_model.dart';
import 'package:mrtv_new_app_sl/viewModels/audio/audio_viewmodel/audio_dialog_controller.dart';
import 'package:mrtv_new_app_sl/viewModels/audio/audio_viewmodel/audio_handler.dart';

class AutioDialogWidget extends StatefulWidget {
  final String audioUrl;
  final String imageUrl;
  final String title;
  final String body;
  final List<Records> playList;
  final int startIndex;

  const AutioDialogWidget({
    super.key,
    required this.audioUrl,
    required this.imageUrl,
    required this.title,
    required this.body,
    required this.playList,
    required this.startIndex,
  });

  @override
  State<AutioDialogWidget> createState() => _AutioDialogWidgetState();
}

class _AutioDialogWidgetState extends State<AutioDialogWidget> {
  late AudioDialogController controller;
  Records? currentRecord;
  @override
  void initState() {
    super.initState();

    if (Get.isRegistered<AudioDialogController>()) {
      Get.delete<AudioDialogController>();
    }
    final MyAudioHandler audioHandler = MyAudioHandler();
    controller = Get.put(AudioDialogController(audioHandler));

    currentRecord = widget.playList[widget.startIndex];
    controller.onTrackChanged = (index) {
      setState(() {
        currentRecord = widget.playList[index];
      });
    };
    controller.initPlayList(widget.playList, widget.startIndex);
  }

  @override
  void dispose() {
    Get.delete<AudioDialogController>();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final textTheme = theme.textTheme;
    // final AudioDialogController controller = Get.put(AudioDialogController());
    // controller.initPlayList(widget.playList, widget.startIndex);
    // controller.init(audioUrl);
    return Dialog(
      insetPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 60),
      backgroundColor: theme.dialogBackgroundColor,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              currentRecord?.title ?? 'No Title',
              style: textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 10),
            Flexible(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    Container(
                      // height: 400,
                      child: Obx(() {
                        final dur =
                            controller
                                .audioHandler
                                .mediaItem
                                .value
                                ?.duration
                                ?.inMilliseconds
                                ?.toDouble();
                        final pos =
                            controller.position.value.inMilliseconds.toDouble();

                        if (dur == null || dur <= 0) {
                          return CircularProgressIndicator(); // Still loading
                        }

                        // print("pos $pos");

                        final value =
                            (dur > 0) ? (pos / dur).clamp(0.0, 1.0) : 0.0;
                        if (controller.isInitialized.value) {
                          return Column(
                            children: [
                              Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(16),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black26,
                                      blurRadius: 18,
                                      offset: Offset(0, 4),
                                    ),
                                  ],
                                ),
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(16),
                                  child: FadeInImage.assetNetwork(
                                    placeholder:
                                        'assets/placeholder.jpg', // or use a spinner gif
                                    image: currentRecord!.image ?? '',
                                    height:
                                        MediaQuery.of(context).size.height / 6,
                                    width: double.infinity,

                                    fit: BoxFit.fill,
                                  ),
                                ),
                              ),
                              SizedBox(height: 10),
                              // LinearProgressIndicator(value: value),
                              SliderTheme(
                                data: SliderTheme.of(context).copyWith(
                                  activeTrackColor: Color.fromARGB(
                                    255,
                                    11,
                                    57,
                                    95,
                                  ),
                                  inactiveTrackColor: Color.fromARGB(
                                    89,
                                    60,
                                    161,
                                    244,
                                  ),
                                  trackHeight: 4.0,
                                  thumbColor: Color.fromARGB(255, 11, 57, 95),
                                  thumbShape: RoundSliderThumbShape(
                                    enabledThumbRadius: 8.0,
                                  ),
                                  overlayColor: Color.fromARGB(
                                    255,
                                    11,
                                    57,
                                    95,
                                  ).withAlpha(32),
                                  overlayShape: RoundSliderOverlayShape(
                                    overlayRadius: 16.0,
                                  ),
                                  valueIndicatorColor: Color.fromARGB(
                                    255,
                                    11,
                                    57,
                                    95,
                                  ),
                                  valueIndicatorTextStyle: TextStyle(
                                    color: Colors.white,
                                  ),
                                ),
                                child: Slider(
                                  value: pos.clamp(0.0, dur),
                                  min: 0.0,
                                  max: dur,
                                  label: '${(pos / 1000).toStringAsFixed(0)}s',
                                  divisions: dur >= 1000 ? dur ~/ 1000 : 1,
                                  onChanged: (value) {
                                    controller.audioHandler.seek(
                                      Duration(milliseconds: value.toInt()),
                                    );
                                  },
                                ),
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.only(bottom: 20),
                                    child: SizedBox(
                                      width: 45,
                                      child: Text(
                                        controller.formatDuration(
                                          controller.position.value,
                                        ),
                                        style: textTheme.bodySmall,
                                      ),
                                    ),
                                  ),
                                  Container(
                                    decoration: BoxDecoration(
                                      color: const Color.fromARGB(
                                        255,
                                        11,
                                        57,
                                        95,
                                      ),
                                      shape: BoxShape.circle,
                                      boxShadow: [
                                        BoxShadow(
                                          color: Colors.black26,
                                          blurRadius: 6,
                                          offset: Offset(0, 4),
                                        ),
                                      ],
                                    ),
                                    child: IconButton(
                                      icon: Icon(
                                        Icons.skip_previous,
                                        color: Colors.white,
                                        size: 32,
                                      ),
                                      onPressed: controller.skipPrevious,
                                    ),
                                  ),
                                  Container(
                                    decoration: BoxDecoration(
                                      color: const Color.fromARGB(
                                        255,
                                        11,
                                        57,
                                        95,
                                      ),
                                      shape: BoxShape.circle,
                                      boxShadow: [
                                        BoxShadow(
                                          color: Colors.black26,
                                          blurRadius: 6,
                                          offset: Offset(0, 4),
                                        ),
                                      ],
                                    ),
                                    child: IconButton(
                                      icon: Icon(
                                        controller.isPlaying.value
                                            ? Icons.pause
                                            : Icons.play_arrow,
                                        color: Colors.white,
                                        size: 32,
                                      ),
                                      onPressed: controller.togglePlayback,
                                    ),
                                  ),
                                  Container(
                                    decoration: BoxDecoration(
                                      color: const Color.fromARGB(
                                        255,
                                        11,
                                        57,
                                        95,
                                      ),
                                      shape: BoxShape.circle,
                                      boxShadow: [
                                        BoxShadow(
                                          color: Colors.black26,
                                          blurRadius: 6,
                                          offset: Offset(0, 4),
                                        ),
                                      ],
                                    ),
                                    child: IconButton(
                                      icon: Icon(
                                        Icons.skip_next,
                                        color: Colors.white,
                                        size: 32,
                                      ),
                                      onPressed: controller.skipNext,
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(bottom: 20),
                                    child: SizedBox(
                                      width: 45,
                                      child: Text(
                                        controller.formatDuration(
                                          controller
                                                  .audioHandler
                                                  .mediaItem
                                                  .value
                                                  ?.duration ??
                                              Duration.zero,
                                        ),
                                        style: textTheme.bodySmall,
                                        // controller.formatDuration(
                                        //   controller
                                        //           .audioPlayerController
                                        //           .duration ??
                                        //       Duration.zero,
                                        // ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),

                              SizedBox(height: 10),
                              Text(
                                widget.body != 'null' && widget.body.isNotEmpty
                                    ? currentRecord!.body!
                                    : "There is no detai Available !!!",
                                style: textTheme.bodyLarge,
                                textAlign: TextAlign.center,
                              ),
                            ],
                          );
                        } else {
                          return Center(child: CircularProgressIndicator());
                        }
                      }),
                    ),
                  ],
                ),
              ),
            ),

            // SizedBox(height: 10),
          ],
        ),
      ),
    );
  }
}
