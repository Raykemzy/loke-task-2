import 'dart:io';

import 'package:audio_waveforms/audio_waveforms.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:loke_task_2/core/context_extensions.dart';
import 'package:loke_task_2/core/theme.dart';
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

  /// Listenable for audio file path status
  final ValueNotifier<String> _recordedFilePath = ValueNotifier<String>('');

  /// Listenable for audio wave form data status
  final ValueNotifier<List<double>> _waveFormData = ValueNotifier<List<double>>(
    [],
  );

  /// Listenable for audio recording status
  final ValueNotifier<AudioRecorderState> _audioRecordingState =
      ValueNotifier<AudioRecorderState>(AudioRecorderState.idle);

  /// Listenable for audio duration
  final ValueNotifier<int> _audioDuration = ValueNotifier(0);

  /// Listenable for current playing duration
  final ValueNotifier<int> _currentPlayingDuration = ValueNotifier(0);

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

  Future<void> _initializeAudioPlayer({LocalAudioModel? savedObject}) async {
    LocalAudioModel? audioObjectToUse;
    if (savedObject == null) {
      audioObjectToUse = ref.watch(saveAudioNotifierProvider);
    } else {
      audioObjectToUse = savedObject;
    }

    if (audioObjectToUse?.filePath == null ||
        audioObjectToUse?.filePath == '') {
      if (kDebugMode) {
        print("No valid audio file path found.");
      }
      return;
    }

    final file = File(audioObjectToUse!.filePath);
    if (!file.existsSync()) {
      if (kDebugMode) {
        print("Audio file not found at path: ${audioObjectToUse.filePath}");
      }
      return;
    }

    ///Get file path from local storage
    await _playerController.preparePlayer(
      path: audioObjectToUse.filePath,
      shouldExtractWaveform: true,
    );
    _playerController.addListener(setUpAudioPlayerListener);
    _playerController.getDuration().then((value) {
      _audioDuration.value = savedObject == null ? 0 : value;
    });
    _waveFormData.value = _playerController.waveformData;
    if (kDebugMode) {
      print(_waveFormData.value);
    }
  }

  void recorderListener() {
    _recorderController.onCurrentDuration.listen((duration) {
      _audioDuration.value = duration.inMilliseconds;
      if (kDebugMode) {
        print('durationnnn -> ${_audioDuration.value}');
      }
    });
    _playerController.onCurrentDurationChanged.listen((duration) {
      _currentPlayingDuration.value = duration;
    });
  }

  void setUpAudioPlayerListener() {
    _playerController.onCurrentExtractedWaveformData.listen((waveFormData) {
      _waveFormData.value = waveFormData;
    });
    _playerController.onPlayerStateChanged.listen((state) {
      switch (state) {
        case PlayerState.playing:
          _audioRecordingState.value = AudioRecorderState.playing;
          break;
        case PlayerState.paused:
          _audioRecordingState.value = AudioRecorderState.paused;
          break;
        case PlayerState.stopped:
          _audioRecordingState.value = AudioRecorderState.playingStopped;
        default:
          _audioRecordingState.value = _audioRecordingState.value;
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
          ValueListenableBuilder(
              valueListenable: _audioDuration,
              builder: (context, duration, _) {
                return ValueListenableBuilder(
                    valueListenable: _currentPlayingDuration,
                    builder: (context, currentElapsedDuration, _) {
                      return Center(
                        child: Text(
                          status == AudioRecorderState.recordingStopped ||
                                  status == AudioRecorderState.playing ||
                                  status == AudioRecorderState.paused
                              ? '${getDurationText(currentElapsedDuration)} / ${getDurationText(duration)}'
                              : getDurationText(duration),
                          style:
                              context.theme.textTheme.displayMedium?.copyWith(
                            color: getColor(),
                          ),
                        ),
                      );
                    });
              }),
          20.verticalSpace,
          SizedBox(
            height: 40,
            child: switch (status) {
              AudioRecorderState.idle ||
              AudioRecorderState.recording ||
              AudioRecorderState.playingStopped =>
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
          ),
          20.verticalSpace,
          AudioControls(
            recordState: _audioRecordingState,
            onTap: _handleRecordingAndPlayBack,
            onDeleted: onRecordingDeleted,
          ),
        ],
      ),
    );
  }

  void _handleRecordingAndPlayBack() {
    switch (_audioRecordingState.value) {
      case AudioRecorderState.idle:
      case AudioRecorderState.playingStopped:
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

    final audioObject = LocalAudioModel(
      filePath: _recordedFilePath.value,
      waveformData: _waveFormData.value,
      duration: _audioDuration.value,
    );

    // Save audio data and reinitialize the player
    notifier.saveAudioObject(
      audioObject,
      onSaved: (savedAudioObject) async => await _initializeAudioPlayer(
        savedObject: savedAudioObject,
      ),
    );
  }

  void _playRecording() async {
    await _playerController.startPlayer();
    await _playerController.setFinishMode(finishMode: FinishMode.stop);
    _audioRecordingState.value = AudioRecorderState.playing;
  }

  void _pauseRecording() async {
    await _playerController.pausePlayer();
    _audioRecordingState.value = AudioRecorderState.paused;
  }

  String getDurationText(int totalMilliseconds) {
    if (totalMilliseconds <= 0) {
      return '00:00';
    }

    int totalSeconds = totalMilliseconds ~/ 1000;
    int minutes = totalSeconds ~/ 60;
    int seconds = totalSeconds % 60;

    return '${minutes.toString().padLeft(2, '0')}'
        ':${seconds.toString().padLeft(2, '0')}';
  }

  Color getColor() {
    return _audioRecordingState.value == AudioRecorderState.idle ||
            _audioRecordingState.value == AudioRecorderState.playingStopped
        ? AppTheme.disabledColor
        : _audioRecordingState.value == AudioRecorderState.recording
            ? context.theme.colorScheme.onSecondary
            : Colors.white;
  }

  void onRecordingDeleted() async {
    _audioRecordingState.value = AudioRecorderState.idle;
    _waveFormData.value = [];
    _audioDuration.value = 0;
    await _playerController.stopPlayer();
  }
}
