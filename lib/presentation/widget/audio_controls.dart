import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:loke_task_2/core/context_extensions.dart';
import 'package:loke_task_2/domain/enums.dart';
import 'package:loke_task_2/gen/assets.gen.dart';
import 'package:loke_task_2/presentation/widget/app_svg_widget.dart';

class AudioControls extends StatelessWidget {
  final ValueNotifier<AudioRecorderState> recordState;
  final VoidCallback onTap;
  const AudioControls({
    super.key,
    required this.onTap,
    required this.recordState,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 80.w),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Delete',
                style: context.theme.textTheme.displayMedium,
              ),
              _RecordButton(onTap: onTap, recordState: recordState),
              Text(
                'Submit',
                style: context.theme.textTheme.displayMedium,
              ),
            ],
          ),
          20.verticalSpace,
          Center(
            child: Text(
              'Unmatch',
              style: context.theme.textTheme.displayMedium,
            ),
          ),
          40.verticalSpace,
        ],
      ),
    );
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
        width: 70.w,
        height: 70.h,
        padding: EdgeInsets.all(5.sp),
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
                color: state == AudioRecorderState.idle
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
