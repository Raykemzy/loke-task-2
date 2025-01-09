import 'package:audio_waveforms/audio_waveforms.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:loke_task_2/domain/enums.dart';
import 'package:loke_task_2/presentation/widget/audio_controls.dart';
import 'package:loke_task_2/presentation/widget/audio_player.dart';
import 'package:loke_task_2/presentation/widget/audio_recorder.dart';

class AudioWidget extends StatefulWidget {
  const AudioWidget({super.key});

  @override
  State<AudioWidget> createState() => _AudioWidgetState();
}

class _AudioWidgetState extends State<AudioWidget>
    with SingleTickerProviderStateMixin {
  final RecorderController _recorderController = RecorderController();
  final PlayerController _playerController = PlayerController();

  final ValueNotifier<String> _recordedFilePath = ValueNotifier<String>('');

  /// Listenable for audio recording status
  ValueNotifier<AudioRecorderState> audioRecordingState =
      ValueNotifier<AudioRecorderState>(AudioRecorderState.idle);

  /// Listenable for audio duration
  ValueNotifier<int> audioDuration = ValueNotifier(0);

  @override
  void initState() {
    super.initState();
    _recorderController.checkPermission();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _initializeAudioPlayer();
    });
  }

  @override
  void dispose() {
    _recorderController.dispose();
    super.dispose();
  }

  void _initializeAudioPlayer() async {
    ///Get file path from local storage
    await _playerController.preparePlayer(
      path: _recordedFilePath.value,
      shouldExtractWaveform: true,
    );
    _playerController.addListener(setUpAudioPlayerListener);
    _playerController.getDuration().then((value) {
      audioDuration.value = value;
    });
  }

  void setUpAudioPlayerListener() {
    _playerController.onPlayerStateChanged.listen((state) {
      switch (state) {
        case PlayerState.playing:
          audioRecordingState.value = AudioRecorderState.playing;
          break;
        case PlayerState.paused:
          audioRecordingState.value = AudioRecorderState.paused;
          break;
        case PlayerState.stopped:
          break;
        default:
          audioRecordingState.value = AudioRecorderState.idle;
          break;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: audioRecordingState,
      builder: (context, status, _) => Column(
        children: [
          switch (status) {
            AudioRecorderState.idle ||
            AudioRecorderState.recording =>
              AudioRecorder(
                recorderController: _recorderController,
                audioRecordingState: audioRecordingState,
              ),
            _ => AudioPlayer(
                playerController: _playerController,
                audioRecordingState: audioRecordingState,
                waveformData: [],
              )
          },
          20.verticalSpace,
          AudioControls(
            recordState: audioRecordingState,
            onTap: _handleRecordingAndPlayBack,
          ),
        ],
      ),
    );
  }

  void _handleRecordingAndPlayBack() {
    switch (audioRecordingState.value) {
      case AudioRecorderState.idle:
        _startRecording();
        break;
      case AudioRecorderState.recording:
        _stopRecording();
      default:
        () {};
    }
  }

  void _startRecording() async {
    if (_recorderController.hasPermission) {
      _recorderController.record();
      audioRecordingState.value = AudioRecorderState.recording;
    }
  }

  void _stopRecording() async {
    _recordedFilePath.value = await _recorderController.stop() ?? '';
    audioRecordingState.value = AudioRecorderState.recordingStopped;
  }

  String getDurationText(int totalMilliseconds) {
    if (totalMilliseconds < 0) {
      return '00:00';
    }

    int totalSeconds = totalMilliseconds ~/ 1000;
    int minutes = totalSeconds ~/ 60;
    int seconds = totalSeconds % 60;

    return '${minutes.toString().padLeft(2, '0')}'
        ':${seconds.toString().padLeft(2, '0')}';
  }
}
