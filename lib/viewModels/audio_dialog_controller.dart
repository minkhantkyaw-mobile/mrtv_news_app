import 'package:get/get.dart';
import 'package:just_audio/just_audio.dart';

class AudioDialogController extends GetxController {
  late AudioPlayer audioPlayerController;
  var isInitialized = false.obs;
  var isPlaying = false.obs;
  Rx<Duration> position = Duration.zero.obs;

  void init(String url) async {
    // print("url :" + url);
    audioPlayerController = AudioPlayer();
    await audioPlayerController.setUrl(url);
    isInitialized.value = true;
    audioPlayerController.play();

    audioPlayerController.playerStateStream.listen((state) {
      isPlaying.value = state.playing;
    });

    audioPlayerController.positionStream.listen((p) {
      position.value = p;
    });
    // await audioPlayerController.play(); // Play while waiting for completion
    // await audioPlayerController.pause(); // Pause but remain ready to play
    // await audioPlayerController.seek(
    //   Duration(seconds: 10),
    // ); // Jump to the 10 second position
    // await audioPlayerController.setSpeed(2.0); // Twice as fast
    // await audioPlayerController.setVolume(0.5); // Half as loud
    // await audioPlayerController.stop(); // Stop and free resources
  }

  void togglePlayback() {
    if (isPlaying.value) {
      audioPlayerController.pause();
    } else {
      audioPlayerController.play();
    }
  }

  @override
  void onClose() {
    audioPlayerController.dispose();
    super.onClose();
  }

  String formatDuration(Duration d) {
    final minutes = d.inMinutes.remainder(60).toString().padLeft(2, '0');
    final seconds = d.inSeconds.remainder(60).toString().padLeft(2, '0');
    return "$minutes:$seconds";
  }
}
