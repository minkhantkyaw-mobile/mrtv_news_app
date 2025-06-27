import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mrtv_new_app_sl/viewModels/audio_dialog_controller.dart';

class AutioDialogWidget extends StatelessWidget {
  final String audioUrl;

  final String imageUrl;

  final String title;

  final String body;
  const AutioDialogWidget({
    super.key,
    required this.audioUrl,
    required this.imageUrl,
    required this.title,
    required this.body,
  });

  @override
  Widget build(BuildContext context) {
    final AudioDialogController controller = Get.put(AudioDialogController());
    controller.init(audioUrl);
    return Dialog(
      insetPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 60),
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              title,
              style: TextStyle(
                color: Colors.black,
                fontSize: 18,
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
                        final pos =
                            controller.position.value.inMilliseconds.toDouble();
                        final dur =
                            controller
                                .audioPlayerController
                                .duration
                                ?.inMilliseconds
                                .toDouble() ??
                            1.0;

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
                                    image: imageUrl,
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
                                  divisions: dur > 0 ? dur ~/ 1000 : null,
                                  onChanged: (value) {
                                    controller.audioPlayerController.seek(
                                      Duration(milliseconds: value.toInt()),
                                    );
                                  },
                                ),
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.only(bottom: 20),
                                    child: SizedBox(
                                      width: 45,
                                      child: Text(
                                        controller.formatDuration(
                                          controller.position.value,
                                        ),
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
                                        controller.isPlaying.value
                                            ? Icons.pause
                                            : Icons.play_arrow,
                                        color: Colors.white,
                                        size: 32,
                                      ),
                                      onPressed: controller.togglePlayback,
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(bottom: 20),
                                    child: SizedBox(
                                      width: 45,
                                      child: Text(
                                        controller.formatDuration(
                                          controller
                                                  .audioPlayerController
                                                  .duration ??
                                              Duration.zero,
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),

                              SizedBox(height: 10),
                              Text(
                                body != 'null' && body.isNotEmpty
                                    ? body
                                    : "There is no detai Available !!!",
                                style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 18,
                                ),
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
