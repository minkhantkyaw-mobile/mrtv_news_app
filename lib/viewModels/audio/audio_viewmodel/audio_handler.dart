import 'package:audio_service/audio_service.dart';
import 'package:just_audio/just_audio.dart';

class MyAudioHandler extends BaseAudioHandler {
  final _player = AudioPlayer();

  MyAudioHandler() {
    _player.playerStateStream.listen((state) {
      playbackState.add(
        PlaybackState(
          controls: [
            MediaControl.play,
            MediaControl.pause,
            MediaControl.stop,
            MediaControl.skipToNext,
            MediaControl.skipToPrevious,
          ],
          systemActions: const {
            MediaAction.seek,
            MediaAction.play,
            MediaAction.pause,
            MediaAction.stop,
          },
          playing: state.playing,
          processingState:
              {
                ProcessingState.idle: AudioProcessingState.idle,
                ProcessingState.loading: AudioProcessingState.loading,
                ProcessingState.buffering: AudioProcessingState.buffering,
                ProcessingState.ready: AudioProcessingState.ready,
                ProcessingState.completed: AudioProcessingState.completed,
              }[_player.processingState]!,
          updatePosition: _player.position,
          bufferedPosition: _player.bufferedPosition,
          speed: _player.speed,
          queueIndex: null,
        ),
      );
    });
    _player.positionStream.listen((pos) {
      playbackState.add(
        playbackState.value.copyWith(
          updatePosition: pos,
          bufferedPosition: _player.bufferedPosition,
          speed: _player.speed,
          playing: playbackState.value.playing,
          processingState: playbackState.value.processingState,
          controls: playbackState.value.controls,
          queueIndex: playbackState.value.queueIndex,
          systemActions: playbackState.value.systemActions,
        ),
      );
    });

    _player.durationStream.listen((duration) {
      final currentMediaItem = mediaItem.value;
      if (currentMediaItem != null && duration != null) {
        mediaItem.add(currentMediaItem.copyWith(duration: duration));
      }
    });
  }

  Future<void> setAudio(String url) async {
    playbackState.add(
      playbackState.value.copyWith(
        processingState: AudioProcessingState.loading,
      ),
    );

    await _player.setUrl(url);

    final duration = _player.duration ?? Duration.zero;
    final item = MediaItem(
      id: url,
      title: 'Audio Title',
      album: 'Album',
      duration: duration,
      artist: 'Artist',
      artUri: Uri.parse('https://example.com/art.jpg'),
    );

    mediaItem.value = item; // ✅ proper way

    await _player.setUrl(url);

    playbackState.add(
      playbackState.value.copyWith(
        controls: [
          MediaControl.play,
          MediaControl.pause,
          MediaControl.stop,
          MediaControl.skipToNext,
          MediaControl.skipToPrevious,
        ],
        playing: true,
        processingState: AudioProcessingState.ready,
        // playing: false,
      ),
    );
  }

  Future<void> play() => _player.play();

  @override
  Future<void> pause() => _player.pause();

  @override
  Future<void> stop() => _player.stop();
  @override
  Future<void> seek(Duration position) async {
    await _player.seek(position);
  }
}
