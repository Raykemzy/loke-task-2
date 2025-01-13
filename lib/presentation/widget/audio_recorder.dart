import 'dart:async';

import 'package:audio_waveforms/audio_waveforms.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:loke_task_2/core/context_extensions.dart';
import 'package:loke_task_2/domain/enums.dart';

class AudioRecorder extends StatefulWidget {
  final RecorderController recorderController;
  final ValueNotifier<AudioRecorderState> audioRecordingState;
  const AudioRecorder({
    super.key,
    required this.recorderController,
    required this.audioRecordingState,
  });

  @override
  State<AudioRecorder> createState() => _AudioRecorderState();
}

class _AudioRecorderState extends State<AudioRecorder>
    with SingleTickerProviderStateMixin {
  late ValueNotifier<double> _waveformWidthNotifier;
  late AnimationController _animationController;
  // Timer to periodically update the elapsed time
  Timer? _timer;

  //Rate at width waveForm reduces in pixels per second
  final int growthRate = 50;

  final double _horizontalPadding = 18.w;

  @override
  void initState() {
    super.initState();
    _waveformWidthNotifier = ValueNotifier(0.0);
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    )..addListener(() {
        final elapsedDuration = widget.recorderController.elapsedDuration;
        final calculatedWidth = elapsedDuration.inSeconds * growthRate;
        final screenWidth = context.width - _horizontalPadding;

        _waveformWidthNotifier.value = calculatedWidth > screenWidth
            ? screenWidth
            : calculatedWidth.toDouble();
      });

    _animationController.repeat();
  }

  @override
  void dispose() {
    _animationController.dispose();
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: _horizontalPadding),
      child: ValueListenableBuilder<double>(
        valueListenable: _waveformWidthNotifier,
        builder: (context, waveformWidth, _) {
          final screenWidth = context.width - _horizontalPadding;
          final flatLineWidth = screenWidth - waveformWidth;
          return SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            physics: const NeverScrollableScrollPhysics(),
            child: Row(
              children: [
                if (flatLineWidth > 0)
                  AnimatedContainer(
                    duration: const Duration(milliseconds: 800),
                    curve: Curves.easeInOut,
                    width: flatLineWidth,
                    height: 2,
                    color: context.theme.colorScheme.onPrimary,
                  ),
                if (widget.recorderController.isRecording)
                  ValueListenableBuilder(
                    valueListenable: widget.audioRecordingState,
                    builder: (context, state, _) {
                      return state == AudioRecorderState.recording
                          ? Padding(
                              padding: EdgeInsets.only(left: 5.w),
                              child: AudioWaveforms(
                                recorderController: widget.recorderController,
                                size: Size(waveformWidth, 40),
                                waveStyle: WaveStyle(
                                  scaleFactor: 100,
                                  showMiddleLine: false,
                                  waveCap: StrokeCap.square,
                                  waveColor:
                                      context.theme.colorScheme.onPrimary,
                                  extendWaveform: true,
                                  spacing: 6.0,
                                ),
                              ),
                            )
                          : const SizedBox.shrink();
                    },
                  ),
              ],
            ),
          );
        },
      ),
    );
  }
}
