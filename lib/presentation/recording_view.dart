import 'package:flutter/material.dart';
import 'package:loke_task_2/presentation/widget/bio_section.dart';
import 'package:loke_task_2/presentation/widget/custom_scaffold.dart';
import 'package:loke_task_2/presentation/widget/header_section.dart';

class RecordingView extends StatelessWidget {
  const RecordingView({super.key});

  @override
  Widget build(BuildContext context) {
    return const CustomScaffold(
      body: SafeArea(
        child: Column(
          children: [
            HeaderSection(),
            Spacer(),
            BioSection(),
          ],
        ),
      ),
    );
  }
}