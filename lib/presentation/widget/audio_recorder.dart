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

class _AudioRecorderState extends State<AudioRecorder> {
  // Timer to periodically update the elapsed time
  Timer? _timer;

  //Elapsed time of recording
  late int _elapsedTimeInSeconds;

  //Rate at width waveForm increases in pixels per second
  final int growthRate = 50;

  final double _horizontalPadding = 18.w;

  @override
  void initState() {
    super.initState();
    _elapsedTimeInSeconds = widget.recorderController.elapsedDuration.inSeconds;

    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        // Fetch the current elapsed duration from the recorder controller
        _elapsedTimeInSeconds =
            widget.recorderController.elapsedDuration.inSeconds;
      });
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  //Waveform width
  double get _waveformWidth {
    final calculatedWidth = _elapsedTimeInSeconds * growthRate;
    final screenWidth = context.width - _horizontalPadding;
    return calculatedWidth > screenWidth
        ? screenWidth
        : calculatedWidth.toDouble();
  }

  double get _flatLineWidth {
    final screenWidth = context.width - _horizontalPadding;
    return screenWidth - _waveformWidth;
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: _horizontalPadding),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        physics: const NeverScrollableScrollPhysics(),
        child: Row(
          children: [
            if (_flatLineWidth > 0)
              AnimatedContainer(
                duration: const Duration(milliseconds: 800),
                curve: Curves.easeInOut,
                width: _flatLineWidth,
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
                            size: Size(_waveformWidth, 40),
                            waveStyle: WaveStyle(
                              showMiddleLine: false,
                              waveColor: context.theme.colorScheme.onPrimary,
                              extendWaveform: true,
                            ),
                          ),
                        )
                      : const SizedBox.shrink();
                },
              ),
          ],
        ),
      ),
    );
  }
}
