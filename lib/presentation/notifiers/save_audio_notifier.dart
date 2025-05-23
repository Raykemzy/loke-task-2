import 'dart:io';

import 'package:flutter/services.dart';
import 'package:hive/hive.dart';
import 'package:loke_task_2/core/services/local_storage.dart';
import 'package:loke_task_2/core/services/local_storage_impl.dart';
import 'package:loke_task_2/core/services/storage_keys.dart';
import 'package:loke_task_2/domain/models/local_audio_model.dart';
import 'package:path_provider/path_provider.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'save_audio_notifier.g.dart';

@riverpod
class SaveAudioNotifier extends _$SaveAudioNotifier {
  late final LocalStorage _db;
  late final String _audioDirectoryPath;

  @override
  LocalAudioModel? build() {
    _db = LocalStorageImpl(Hive.box(StorageKeys.appBox));
    _initializeStorage();
    return LocalAudioModel.emptyState();
  }

  Future<void> _initializeStorage() async {
    // Get the application-specific directory for storing audio files.
    final appDir = await getApplicationDocumentsDirectory();
    _audioDirectoryPath = appDir.path;

    // Ensure the directory exists.
    final dir = Directory(_audioDirectoryPath);
    if (!dir.existsSync()) {
      await dir.create(recursive: true);
    }
  }

  void saveAudioObject(
    LocalAudioModel model, {
    required void Function(LocalAudioModel) onSaved,
  }) async {
    final fileName = model.filePath.split('/').last;
    final newFilePath = '$_audioDirectoryPath/$fileName';

    final file = File(model.filePath);
    if (file.existsSync()) {
      // Update the model with the file path if file exists.
      final updatedModel = LocalAudioModel(
        filePath: newFilePath,
        waveformData: model.waveformData,
        duration: model.duration,
      );

      await _db.put(StorageKeys.audioRecording, updatedModel);
      state = updatedModel;
      onSaved(updatedModel);
    }
  }

  void getLocallyStoredAudioObject() {
    final audioObject = _db.get(StorageKeys.audioRecording) as LocalAudioModel?;

    if (audioObject != null && File(audioObject.filePath).existsSync()) {
      state = audioObject;
    } else {
      state = LocalAudioModel.emptyState();
    }
  }

  void deleteAudio({VoidCallback? onDeleted}) async {
    await _db.clear();
    state = LocalAudioModel.emptyState();
    if (onDeleted == null) return;
    onDeleted();
  }
}
