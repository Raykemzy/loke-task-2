import 'package:audio_waveforms/audio_waveforms.dart';
import 'package:flutter/material.dart';
import 'package:loke_task_2/core/context_extensions.dart';
import 'package:loke_task_2/domain/enums.dart';

class AudioPlayer extends StatelessWidget {
  final PlayerController playerController;
  final ValueNotifier<AudioRecorderState> audioRecordingState;
  final List<double> waveformData;
  const AudioPlayer({
    super.key,
    required this.playerController,
    required this.audioRecordingState,
    required this.waveformData,
  });

  @override
  Widget build(BuildContext context) {
    return AudioFileWaveforms(
      playerController: playerController,
      size: Size(context.width, 40),
      playerWaveStyle: PlayerWaveStyle(
        showSeekLine: false,
        fixedWaveColor: context.theme.colorScheme.onPrimary,
        liveWaveColor: context.theme.colorScheme.primary,
      ),
    );
  }
}
