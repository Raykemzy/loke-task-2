import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:loke_task_2/core/context_extensions.dart';
import 'package:loke_task_2/core/theme.dart';
import 'package:loke_task_2/gen/assets.gen.dart';
import 'package:loke_task_2/presentation/widget/app_svg_widget.dart';

class HeaderSection extends StatelessWidget {
  const HeaderSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 18.w),
      child: Column(
        children: [
          const _Indicators(),
          10.verticalSpace,
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              AppSvgWidget(path: Assets.svgs.chevronLeft),
              Text(
                'Angelina, 28',
                style: context.theme.textTheme.titleMedium?.copyWith(
                  fontSize: 18.sp,
                ),
              ),
              AppSvgWidget(path: Assets.svgs.threeDot),
            ],
          ),
        ],
      ),
    );
  }
}

class _Indicators extends StatelessWidget {
  const _Indicators();

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const Flexible(
          child: _Indicator(isCurrentIndicator: true),
        ),
        10.horizontalSpace,
        const Flexible(child: _Indicator()),
      ],
    );
  }
}

class _Indicator extends StatelessWidget {
  final bool isCurrentIndicator;
  const _Indicator({
    this.isCurrentIndicator = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 5.h,
      width: context.width,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        color: isCurrentIndicator
            ? AppTheme.activeIndicatorColor
            : AppTheme.inActiveIndicatorColor.withOpacity(0.5),
      ),
    );
  }
}
