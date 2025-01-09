import 'package:audio_waveforms/audio_waveforms.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
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
    return Row(
      children: [
        Expanded(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 18.w),
            child: AudioFileWaveforms(
              playerController: playerController,
              waveformData: waveformData,
              waveformType: WaveformType.fitWidth,
              size: Size(context.width, 40),
              padding: EdgeInsets.zero,
              margin: EdgeInsets.zero,
              animationDuration: const Duration(milliseconds: 1000),
              playerWaveStyle: PlayerWaveStyle(
                spacing: 5,
                showSeekLine: false,
                scaleFactor: 500,
                fixedWaveColor: context.theme.colorScheme.onPrimary,
                liveWaveColor: context.theme.colorScheme.primary,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
