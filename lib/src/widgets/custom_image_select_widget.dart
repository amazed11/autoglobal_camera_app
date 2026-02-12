// import 'dart:io';

// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:user_ag_car_app/src/features/common/presentation/cubit/image/cubit/image_cubit.dart';
// import 'package:user_ag_car_app/src/widgets/custom_dialogs.dart';

// class CustomImageViewWidget extends StatelessWidget {
//   const CustomImageViewWidget({
//     super.key,
//     this.e,
//     this.removedImage,
//   });
//   final File? e;
//   final Function()? removedImage;
//   @override
//   Widget build(BuildContext context) {
//     return BlocBuilder<ImageCubit, ImageState>(
//       builder: (context, state) {
//         return GestureDetector(
//           onTap: () {
//             CustomDialogs.showImageDialog(
//                 context: context, isLocal: true, imageUrl: e?.path);
//           },
//           child: Container(
//             color: Colors.black,
//             child: Stack(
//               children: [
//                 if (e != null)
//                   Image.file(
//                     File(e!.path),
//                     width: 85,
//                     height: 85,
//                   ),
//                 Positioned(
//                   right: 0,
//                   top: 0,
//                   child: InkWell(
//                     onTap: removedImage,
//                     child: Container(
//                       width: 20,
//                       height: 20,
//                       alignment: Alignment.center,
//                       decoration: const BoxDecoration(
//                         color: Colors.white,
//                         shape: BoxShape.circle,
//                       ),
//                       child: const Center(
//                           child: Icon(
//                         Icons.remove_circle,
//                         color: Colors.red,
//                         size: 20,
//                       )),
//                     ),
//                   ),
//                 )
//               ],
//             ),
//           ),
//         );
//       },
//     );
//   }
// }
