import 'dart:io';

import 'package:audio_waveforms/audio_waveforms.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:loke_task_2/domain/enums.dart';
import 'package:loke_task_2/domain/models/local_audio_model.dart';
import 'package:loke_task_2/presentation/notifiers/save_audio_notifier.dart';
import 'package:loke_task_2/presentation/widget/audio_controls.dart';
import 'package:loke_task_2/presentation/widget/audio_player.dart';
import 'package:loke_task_2/presentation/widget/audio_recorder.dart';

class AudioWidget extends ConsumerStatefulWidget {
  const AudioWidget({super.key});

  @override
  ConsumerState<AudioWidget> createState() => _AudioWidgetState();
}

class _AudioWidgetState extends ConsumerState<AudioWidget>
    with SingleTickerProviderStateMixin {
  final RecorderController _recorderController = RecorderController();
  final PlayerController _playerController = PlayerController();

  final ValueNotifier<String> _recordedFilePath = ValueNotifier<String>('');
  final ValueNotifier<List<double>> _waveFormData =
      ValueNotifier<List<double>>([]);

  /// Listenable for audio recording status
  final ValueNotifier<AudioRecorderState> _audioRecordingState =
      ValueNotifier<AudioRecorderState>(AudioRecorderState.idle);

  /// Listenable for audio duration
  final ValueNotifier<int> _audioDuration = ValueNotifier(0);

  @override
  void initState() {
    super.initState();
    _recorderController.checkPermission();
    recorderListener();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      final notifier = ref.read(saveAudioNotifierProvider.notifier);
      notifier.getLocallyStoredAudioObject();
      await _initializeAudioPlayer();
    });
  }

  @override
  void dispose() {
    _recorderController.dispose();
    _playerController.dispose();
    super.dispose();
  }

  Future<void> _initializeAudioPlayer() async {
    final audioObject = ref.watch(saveAudioNotifierProvider);
    if (audioObject?.filePath == null || audioObject?.filePath == '') {
      print("No valid audio file path found.");
      return;
    }

    final file = File(audioObject!.filePath);
    if (!file.existsSync()) {
      print("Audio file not found at path: ${audioObject.filePath}");
      return;
    }

    ///Get file path from local storage
    await _playerController.preparePlayer(
      path: audioObject.filePath,
      shouldExtractWaveform: true,
    );
    _playerController.addListener(setUpAudioPlayerListener);
    _playerController.getDuration().then((value) {
      _audioDuration.value = value;
    });
    _waveFormData.value = _playerController.waveformData;

    //_saveWaveFormData();
  }

  // void _saveWaveFormData() {
  //   final waveformData = _playerController.waveformData;
  //   final audioObject = ref.watch(saveAudioNotifierProvider);
  //   final updatedObject = audioObject.copyWith(waveformData: waveformData);
  //   ref.read(saveAudioNotifierProvider.notifier).saveAudioObject(updatedObject);
  // }

  void recorderListener() {
    _recorderController.onRecordingEnded.listen((duration) {
      _waveFormData.value = _recorderController.waveData;
    });
  }

  void setUpAudioPlayerListener() {
    _playerController.onPlayerStateChanged.listen((state) {
      switch (state) {
        case PlayerState.playing:
          _audioRecordingState.value = AudioRecorderState.playing;
          break;
        case PlayerState.paused:
          _audioRecordingState.value = AudioRecorderState.paused;
          break;
        case PlayerState.stopped:
          break;
        default:
          _audioRecordingState.value = AudioRecorderState.idle;
          break;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: _audioRecordingState,
      builder: (context, status, _) => Column(
        children: [
          switch (status) {
            AudioRecorderState.idle ||
            AudioRecorderState.recording =>
              AudioRecorder(
                recorderController: _recorderController,
                audioRecordingState: _audioRecordingState,
              ),
            _ => AudioPlayer(
                playerController: _playerController,
                audioRecordingState: _audioRecordingState,
                waveformData: _waveFormData.value,
              )
          },
          20.verticalSpace,
          AudioControls(
            recordState: _audioRecordingState,
            onTap: _handleRecordingAndPlayBack,
          ),
        ],
      ),
    );
  }

  void _handleRecordingAndPlayBack() {
    switch (_audioRecordingState.value) {
      case AudioRecorderState.idle:
        _startRecording();
        break;
      case AudioRecorderState.recording:
        _stopRecording();
        break;
      case AudioRecorderState.recordingStopped || AudioRecorderState.paused:
        _playRecording();
        break;
      case AudioRecorderState.playing:
        _pauseRecording();
        break;
      default:
        () {};
    }
  }

  void _startRecording() async {
    if (_recorderController.hasPermission) {
      _recorderController.record();
      _audioRecordingState.value = AudioRecorderState.recording;
    }
  }

  void _stopRecording() async {
    final notifier = ref.read(saveAudioNotifierProvider.notifier);

    _recordedFilePath.value = await _recorderController.stop() ?? '';
    _audioRecordingState.value = AudioRecorderState.recordingStopped;
    _audioDuration.value = _recorderController.elapsedDuration.inSeconds;

    final audioObject = LocalAudioModel(
      filePath: _recordedFilePath.value,
      waveformData: _waveFormData.value,
      duration: _audioDuration.value,
    );

    // Save audio data and reinitialize the player
    notifier.saveAudioObject(audioObject);
    await _initializeAudioPlayer();
  }

  void _playRecording() async {
    await _playerController.startPlayer();
    await _playerController.setFinishMode(finishMode: FinishMode.pause);
    _audioRecordingState.value = AudioRecorderState.playing;
  }

  void _pauseRecording() async {
    await _playerController.pausePlayer();
    _audioRecordingState.value = AudioRecorderState.paused;
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
