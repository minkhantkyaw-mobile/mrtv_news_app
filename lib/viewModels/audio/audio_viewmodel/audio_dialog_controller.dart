import 'dart:async';

import 'package:get/get.dart';
import 'package:mrtv_new_app_sl/viewModels/audio/audio_viewmodel/audio_handler.dart';

import '../../../models/audio_new_model.dart';

class AudioDialogController extends GetxController {
  final MyAudioHandler audioHandler;
  AudioDialogController(this.audioHandler);

  var isInitialized = false.obs;
  var isPlaying = false.obs;
  Rx<Duration> position = Duration.zero.obs;

  List<Records> playList = [];
  int currentIndex = 0;
  @override
  void onInit() {
    super.onInit();
    audioHandler.playbackState.listen((state) {
      isPlaying.value = state.playing;
    });

    audioHandler.playbackState.listen((state) {
      isPlaying.value = state.playing;
      position.value = state.position;
    });

    audioHandler.mediaItem.listen((item) {
      if (item != null) {
        isInitialized.value = true;
      }
    });
  }

  Function(int)? onTrackChanged;

  void initPlayList(List<Records> records, int startIndex) async {
    // print("play");
    playList = records;
    currentIndex = startIndex;
    await _playCurrent();
  }

  Future<void> _playCurrent() async {
    isInitialized.value = false;
    print(currentIndex);

    try {
      final record = playList[currentIndex];
      await audioHandler.stop();

      await (audioHandler as dynamic).setAudio(record.audio ?? '');
      await Future.delayed(Duration(milliseconds: 300));
      await audioHandler.play();

      onTrackChanged?.call(currentIndex);
      audioHandler.mediaItem.listen((item) {
        if (item != null) {
          isInitialized.value = true;
        }
      });
    } catch (e) {
      print("Playback error: $e");
    }
  }

  void togglePlayback() {
    isPlaying.value ? audioHandler.pause() : audioHandler.play();
  }

  Future<void> skipNext() async {
    if (currentIndex + 1 < playList.length) {
      currentIndex++;
      await _playCurrent();
    }
  }

  Future<void> skipPrevious() async {
    if (currentIndex > 0) {
      currentIndex--;
      await _playCurrent();
    }
  }

  @override
  void onClose() {
    audioHandler.stop();
    super.onClose();
  }

  String formatDuration(Duration d) {
    final minutes = d.inMinutes.remainder(60).toString().padLeft(2, '0');
    final seconds = d.inSeconds.remainder(60).toString().padLeft(2, '0');
    return "$minutes:$seconds";
  }
}
