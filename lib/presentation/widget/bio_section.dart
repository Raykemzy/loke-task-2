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
        children: [
          const _PictureAndNameTag(),
          20.verticalSpace,
          SizedBox(
            width: context.width / 1.5,
            child: Text(
              'What is your favorite time of the day?',
              textAlign: TextAlign.center,
              style: context.theme.textTheme.titleMedium?.copyWith(height: 1),
            ),
          ),
          20.verticalSpace,
          Center(
            child: Text(
              '"Mine is definitely the peace in the morning."',
              style: context.theme.textTheme.displayMedium?.copyWith(
                  color: context.theme.colorScheme.secondary.withOpacity(0.7),
                  fontStyle: FontStyle.italic),
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
      alignment: AlignmentDirectional.bottomCenter,
      children: [
        Container(
          width: 60.w,
          height: 60.h,
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
        Positioned(
          bottom: -10,
          child: Container(
            padding: EdgeInsets.symmetric(vertical: 5.h, horizontal: 10.w),
            decoration: BoxDecoration(
              color: const Color(0xFF121518),
              borderRadius: BorderRadius.circular(50.sp),
            ),
            child: Text(
              'Stroll Question',
              style: context.theme.textTheme.titleSmall,
            ),
          ),
        ),
      ],
    );
  }
}
