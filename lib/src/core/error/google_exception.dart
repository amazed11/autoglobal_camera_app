// import 'package:bloc/bloc.dart';

// class GooglePlatformException {
//   static void googlePlatformException(
//     dynamic err,
//     SSOState state,
//     Emitter<SSOState> emit,
//     String data,
//   ) {
//     switch (err.code) {
//       case 'ERROR_USER_DISABLED':
//         break;
//       case 'ERROR_ACCOUNT_EXISTS_WITH_DIFFERENT_CREDENTIAL':
//         emit(state.copyWith(
//             message:
//                 "Google $data error: Account already exists with a different credential.",
//             status: SSOStatus.failure));
//         break;
//       case 'ERROR_INVALID_CREDENTIAL':
//         emit(state.copyWith(
//             message: "Invalid credentials", status: SSOStatus.failure));
//         break;
//       case 'ERROR_OPERATION_NOT_ALLOWED':
//         break;
//       case 'sign_in_canceled':
//         emit(state.copyWith(
//             message: "$data Cancelled", status: SSOStatus.failure));
//         break;
//       default:
//         emit(
//             state.copyWith(message: err.toString(), status: SSOStatus.failure));
//         break;
//     }
//   }
// }
