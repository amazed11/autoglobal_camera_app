// import 'package:get_storage/get_storage.dart';
// import 'package:injectable/injectable.dart';

// @injectable
// class GetStorageService {
//   static final GetStorageService _getStorageService =
//       GetStorageService._internal();
//   factory GetStorageService() {
//     return _getStorageService;
//   }
//   GetStorageService._internal();

//   final box = GetStorage();

//   //language
//   Future<void> saveLanguage(String lang) async {
//     box.write("language", lang);
//   }

//   Future<String> getLanguage() async => box.read("language");

//   //token
//   Future<void> saveToken(String token) async {
//     box.write("token", token);
//   }

//   Future<String> getToken() async => box.read("token");
// }
