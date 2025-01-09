//Object in which audio file is going to be stored locally
import 'package:hive_flutter/hive_flutter.dart';

part 'local_audio_model.g.dart';

@HiveType(typeId: 1)
class LocalAudioModel {
  @HiveField(0)
  final String filePath;
  @HiveField(1)
  final List<double> waveformData;
  @HiveField(2)
  final int duration;

  LocalAudioModel({
    required this.filePath,
    required this.waveformData,
    required this.duration,
  });
}
