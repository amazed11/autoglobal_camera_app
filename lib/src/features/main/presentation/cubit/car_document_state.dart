part of 'car_document_cubit.dart';

enum CarDocumentStatus { initial, submitting, submitted, failure }

/// Document field keys matching the API form fields
enum DocField { carCertificate, malso, pl, expLicence }

extension DocFieldExt on DocField {
  String get key {
    switch (this) {
      case DocField.carCertificate:
        return 'car_certificate';
      case DocField.malso:
        return 'malso';
      case DocField.pl:
        return 'pl';
      case DocField.expLicence:
        return 'exp_licence';
    }
  }

  String get label {
    switch (this) {
      case DocField.carCertificate:
        return 'Car Certificate';
      case DocField.malso:
        return 'Malso Document';
      case DocField.pl:
        return 'PL Document';
      case DocField.expLicence:
        return 'Export Licence';
    }
  }

  String get description {
    switch (this) {
      case DocField.carCertificate:
        return 'Official vehicle ownership certificate';
      case DocField.malso:
        return 'Malso paperwork for customs';
      case DocField.pl:
        return 'Packing list / PL form';
      case DocField.expLicence:
        return 'Export authorisation licence';
    }
  }
}

class CarDocumentState extends Equatable {
  final CarDocumentStatus status;
  final Map<DocField, String> filePaths; // DocField → absolute path
  final Map<DocField, String> fileNames; // DocField → display name
  final String? message;

  const CarDocumentState({
    this.status = CarDocumentStatus.initial,
    this.filePaths = const {},
    this.fileNames = const {},
    this.message,
  });

  bool hasFile(DocField field) => filePaths.containsKey(field);

  int get totalFiles => filePaths.length;

  CarDocumentState copyWith({
    CarDocumentStatus? status,
    Map<DocField, String>? filePaths,
    Map<DocField, String>? fileNames,
    String? message,
  }) =>
      CarDocumentState(
        status: status ?? this.status,
        filePaths: filePaths ?? this.filePaths,
        fileNames: fileNames ?? this.fileNames,
        message: message ?? this.message,
      );

  @override
  List<Object?> get props => [status, filePaths, fileNames, message];
}
