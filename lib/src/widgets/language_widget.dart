// import 'package:flutter/material.dart';

// import '../core/app/colors.dart';
// import 'custom_text.dart';

// class LanguageWidget extends StatelessWidget {
//   const LanguageWidget({
//     super.key,
//     required this.cubit,
//   });

//   final LanguageCubit cubit;

//   @override
//   Widget build(BuildContext context) {
//     return Column(
//       mainAxisSize: MainAxisSize.min,
//       children: cubit.languages.map((language) {
//         return ClipRRect(
//           borderRadius: BorderRadius.circular(10),
//           child: RadioListTile<Language>(
//             shape: RoundedRectangleBorder(
//               borderRadius: BorderRadius.circular(24),
//             ),
//             tileColor: cubit.selectedLang == language
//                 ? AppColor.kSecondaryButton
//                 : null,
//             title: CustomText.ourText(
//               language,
//               fontWeight: cubit.selectedLang == language
//                   ? FontWeight.w600
//                   : FontWeight.normal,
//               color: AppColor.kPrimaryMain,
//             ),
//             value: language == 'English' ? Language.english : Language.japanese,
//             groupValue: cubit.state,
//             onChanged: (val) {
//               print('Language Selected: $val');
//               cubit.setSelectedLang(language);
//               cubit.setLanguage(val!);
//             },
//           ),
//         );
//       }).toList(),
//     );
//   }
// }
