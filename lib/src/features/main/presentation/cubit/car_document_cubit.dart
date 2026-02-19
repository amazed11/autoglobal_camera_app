import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:file_picker/file_picker.dart';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';

import '../../../../core/app/texts.dart';
import '../../../../core/configs/api_config.dart';
import '../../../../services/local/shared_preferences.dart';

part 'car_document_state.dart';

class CarDocumentCubit extends Cubit<CarDocumentState> {
  CarDocumentCubit() : super(const CarDocumentState());

  // ── File picking ──────────────────────────────────────────────────────────

  Future<void> pickFile(DocField field) async {
    try {
      final result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['pdf', 'jpg', 'jpeg', 'png'],
        allowMultiple: false,
      );
      if (result == null || result.files.isEmpty) return;

      final picked = result.files.first;
      if (picked.path == null) return;

      final paths = Map<DocField, String>.from(state.filePaths);
      final names = Map<DocField, String>.from(state.fileNames);
      paths[field] = picked.path!;
      names[field] = picked.name;
      emit(state.copyWith(filePaths: paths, fileNames: names));
    } catch (_) {
      // Silently ignore picker cancel
    }
  }

  void removeFile(DocField field) {
    final paths = Map<DocField, String>.from(state.filePaths)..remove(field);
    final names = Map<DocField, String>.from(state.fileNames)..remove(field);
    emit(state.copyWith(filePaths: paths, fileNames: names));
  }

  // ── Submit multipart ──────────────────────────────────────────────────────

  Future<void> submitDocuments(int carId) async {
    if (state.filePaths.isEmpty) return;

    emit(state.copyWith(status: CarDocumentStatus.submitting));
    try {
      final uri =
          Uri.parse('${ApiConfig.baseUrl}${ApiConfig.carsDocumentUrl}/$carId');
      final token = SharedPreference.getToken();
      final request = http.MultipartRequest('POST', uri);

      request.headers.addAll({
        'Accept': 'application/json',
        authorizationText: '$bearerText $token',
      });

      for (final entry in state.filePaths.entries) {
        final file = File(entry.value);
        final ext = entry.value.split('.').last.toLowerCase();
        final contentType = ext == 'pdf'
            ? MediaType('application', 'pdf')
            : MediaType('image', ext);
        request.files.add(await http.MultipartFile.fromPath(
          entry.key.key,
          file.path,
          contentType: contentType,
        ));
      }

      final streamed = await request.send();
      final response = await http.Response.fromStream(streamed);

      if (response.statusCode == 200 || response.statusCode == 201) {
        emit(state.copyWith(
          status: CarDocumentStatus.submitted,
          message: 'Car document updated successfully',
        ));
      } else {
        throw Exception('Server error ${response.statusCode}');
      }
    } catch (e) {
      emit(state.copyWith(
        status: CarDocumentStatus.failure,
        message: e.toString(),
      ));
    }
  }
}
