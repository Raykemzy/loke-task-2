import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:loke_task_2/core/context_extensions.dart';
import 'package:loke_task_2/core/theme.dart';
import 'package:loke_task_2/domain/enums.dart';
import 'package:loke_task_2/gen/assets.gen.dart';
import 'package:loke_task_2/presentation/notifiers/save_audio_notifier.dart';
import 'package:loke_task_2/presentation/widget/app_svg_widget.dart';

class AudioControls extends ConsumerWidget {
  final ValueNotifier<AudioRecorderState> recordState;
  final VoidCallback onTap;
  final VoidCallback? onDeleted;
  const AudioControls({
    super.key,
    required this.onTap,
    required this.recordState,
    this.onDeleted,
  });
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final notifier = ref.read(saveAudioNotifierProvider.notifier);
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 80.w),
      child: ValueListenableBuilder(
          valueListenable: recordState,
          builder: (context, audioState, _) {
            return Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    InkWell(
                      onTap: () {
                        if (audioState == AudioRecorderState.recording ||
                            audioState == AudioRecorderState.idle) {
                          return;
                        }
                        notifier.deleteAudio(onDeleted: onDeleted);
                      },
                      child: Text(
                        'Delete',
                        style: context.theme.textTheme.displayMedium?.copyWith(
                          color: _getColor(audioState),
                        ),
                      ),
                    ),
                    _RecordButton(onTap: onTap, recordState: recordState),
                    Text(
                      'Submit',
                      style: context.theme.textTheme.displayMedium?.copyWith(
                        color: _getColor(audioState),
                      ),
                    ),
                  ],
                ),
                20.verticalSpace,
                Center(
                  child: Text(
                    'Unmatch',
                    style: context.theme.textTheme.displayMedium?.copyWith(
                      color: audioState == AudioRecorderState.recording
                          ? context.theme.colorScheme.onError.withOpacity(0.3)
                          : context.theme.colorScheme.error,
                    ),
                  ),
                ),
                40.verticalSpace,
              ],
            );
          }),
    );
  }

  Color _getColor(AudioRecorderState audioState) {
    return audioState == AudioRecorderState.idle ||
            audioState == AudioRecorderState.recording ||
            audioState == AudioRecorderState.playingStopped
        ? AppTheme.disabledColor.withOpacity(0.6)
        : Colors.white;
  }
}

class _RecordButton extends StatelessWidget {
  final ValueNotifier<AudioRecorderState> recordState;
  final VoidCallback onTap;
  const _RecordButton({required this.onTap, required this.recordState});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        width: 65.w,
        height: 65.h,
        padding: EdgeInsets.all(3.5.sp),
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: Border.all(
            color: context.theme.colorScheme.surface.withOpacity(0.7),
            width: 3,
          ),
          color: Colors.transparent,
        ),
        child: ValueListenableBuilder(
          valueListenable: recordState,
          builder: (context, state, _) {
            return AnimatedContainer(
              width: 60.w,
              height: 60.h,
              duration: const Duration(milliseconds: 500),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: state == AudioRecorderState.idle ||
                        state == AudioRecorderState.playingStopped
                    ? context.theme.primaryColor
                    : Colors.transparent,
              ),
              child: Center(
                child: AnimatedSwitcher(
                  duration: const Duration(milliseconds: 500),
                  child: switch (state) {
                    AudioRecorderState.recording => AppSvgWidget(
                        path: Assets.svgs.stopButton,
                      ),
                    AudioRecorderState.recordingStopped ||
                    AudioRecorderState.paused =>
                      AppSvgWidget(path: Assets.svgs.playButton),
                    AudioRecorderState.playing => AppSvgWidget(
                        path: Assets.svgs.pauseButton,
                      ),
                    _ => const SizedBox(),
                  },
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
