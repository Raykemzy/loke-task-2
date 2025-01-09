// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'local_audio_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class LocalAudioModelAdapter extends TypeAdapter<LocalAudioModel> {
  @override
  final int typeId = 1;

  @override
  LocalAudioModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return LocalAudioModel(
      filePath: fields[0] as String,
      waveformData: (fields[1] as List).cast<double>(),
      duration: fields[2] as int,
    );
  }

  @override
  void write(BinaryWriter writer, LocalAudioModel obj) {
    writer
      ..writeByte(3)
      ..writeByte(0)
      ..write(obj.filePath)
      ..writeByte(1)
      ..write(obj.waveformData)
      ..writeByte(2)
      ..write(obj.duration);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is LocalAudioModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
