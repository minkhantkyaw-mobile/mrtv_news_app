import 'package:get/get.dart';
import 'package:video_player/video_player.dart';

class LocalDialogController extends GetxController {
  late VideoPlayerController videoPlayerController;
  var isInitialized = false.obs;
  void init(String url) {
    print("url :" + url);
    videoPlayerController = VideoPlayerController.networkUrl(Uri.parse(url))
      ..initialize().then((_) {
        isInitialized.value = true;
        videoPlayerController.play();
      });
  }

  @override
  void onClose() {
    videoPlayerController.pause();
    videoPlayerController.dispose();
    super.onClose();
  }
}
