import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:loke_task_2/core/context_extensions.dart';
import 'package:loke_task_2/gen/assets.gen.dart';

class BioSection extends StatelessWidget {
  const BioSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 50.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const _PictureAndNameTag(),
          Positioned(
            left: 60,
            top: 30,
            child: SizedBox(
              width: context.width / 1.5,
              child: Text(
                'What is your favorite time of the day?',
                style: context.theme.textTheme.titleMedium?.copyWith(height: 1),
              ),
            ),
          ),
          65.verticalSpace,
          Center(
            child: Text(
              '"Mine is definitely the peace in the morning."',
              style: context.theme.textTheme.displayMedium?.copyWith(
                color: context.theme.colorScheme.secondary.withOpacity(0.7),
                fontStyle: FontStyle.italic
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _PictureAndNameTag extends StatelessWidget {
  const _PictureAndNameTag();

  @override
  Widget build(BuildContext context) {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        Container(
          padding: EdgeInsets.only(
            top: 5.h,
            bottom: 5.h,
            right: 20.w,
            left: 50.w,
          ),
          decoration: BoxDecoration(
            color: const Color(0xFF121518),
            borderRadius: BorderRadius.circular(50.sp),
          ),
          child: Text(
            'Stroll Question',
            style: context.theme.textTheme.titleSmall,
          ),
        ),
        Positioned(
          left: -40,
          top: -15,
          child: Container(
            width: 80.w,
            height: 80.h,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(
                width: 10,
                color: const Color(0xFF121517),
              ),
              image: DecorationImage(
                fit: BoxFit.cover,
                image: AssetImage(Assets.images.profilePhoto.path),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
