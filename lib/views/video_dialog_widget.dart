import 'package:chewie/chewie.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mrtv_new_app_sl/viewModels/video_dialog_controller.dart';
import 'package:video_player/video_player.dart';

class VideoDialogWidget extends StatelessWidget {
  final String videoUrl;
  final String title;
  final String body;

  VideoDialogWidget({
    super.key,
    required this.videoUrl,
    required this.title,
    required this.body,
  }) {
    final controller = Get.put(VideoDialogController());
    controller.init(videoUrl);
  }

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<VideoDialogController>();
    return Dialog(
      insetPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 60),
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: SingleChildScrollView(
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
              Container(
                height: MediaQuery.of(context).size.height / 4,
                child: Obx(() {
                  if (controller.isInitialized.value) {
                    return AspectRatio(
                      aspectRatio: 16 / 9,
                      child: Chewie(
                        controller: ChewieController(
                          videoPlayerController:
                              controller.videoPlayerController,
                          autoPlay: true,
                          looping: false,
                        ),
                      ),
                    );
                  } else {
                    return Center(child: CircularProgressIndicator());
                  }
                }),
              ),
              SizedBox(height: 10),
              Padding(
                padding: const EdgeInsets.all(10.0),
                child: Text(
                  body != 'null' && body.isNotEmpty
                      ? body
                      : "There is no detail Available !!!",
                  style: TextStyle(color: Colors.black, fontSize: 18),
                  textAlign: TextAlign.center,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
