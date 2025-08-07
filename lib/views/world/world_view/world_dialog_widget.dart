import 'package:chewie/chewie.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:mrtv_new_app_sl/viewModels/world/world_viewmodel/world_dialog_controller.dart';

class WorldDialogWidget extends StatelessWidget {
  final String videoUrl;
  final String title;
  final String body;
  WorldDialogWidget({
    super.key,
    required this.videoUrl,
    required this.title,
    required this.body,
  }) {
    final controller = Get.put(WorldDialogController());
    controller.init(videoUrl);
  }

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<WorldDialogController>();
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    return Dialog(
      insetPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 60),
      backgroundColor: theme.dialogBackgroundColor,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                title,
                style: theme.textTheme.titleLarge?.copyWith(
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
                  style: theme.textTheme.bodyLarge,
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
