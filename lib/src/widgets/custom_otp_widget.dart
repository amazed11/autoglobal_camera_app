// import 'dart:async';

// import 'package:flutter/material.dart';
// import 'package:indoor_inspection_mobile_app/src/utils/validation.dart';

// import '../../di_injection.dart';
// import '../core/app/dimensions.dart';
// import '../core/app/texts.dart';
// import '../core/development/console.dart';
// import '../core/enums/enums.dart';
// import '../utils/unfocus_keyboard.dart';
// import 'custom_button.dart';
// import 'custom_text.dart';
// import 'custom_text_field.dart';

// class CustomOTPWidget extends StatefulWidget {
//   final AuthType? purpose;
//   const CustomOTPWidget({
//     super.key,
//     this.purpose,
//   });
//   @override
//   State<CustomOTPWidget> createState() => _CustomOTPWidgetState();
// }

// class _CustomOTPWidgetState extends State<CustomOTPWidget> {
//   final ValueNotifier<int> resendDuration = ValueNotifier<int>(120);
//   final ValueNotifier<double> height = ValueNotifier<double>(0);
//   ValueNotifier<bool> isClicked = ValueNotifier<bool>(true);
//   Timer? otpResendTimer;

//   @override
//   void initState() {
//     startTimer();
//     super.initState();
//   }

//   void startTimer() {
//     logger(resendDuration.value, loggerType: LoggerType.success);
//     resendDuration.value = otpDurationText;
//     const oneSec = Duration(seconds: 1);
//     otpResendTimer?.cancel();
//     otpResendTimer = Timer.periodic(
//       oneSec,
//       (Timer timers) {
//         if (resendDuration.value <= 0) {
//           isClicked.value = false;
//           timers.cancel();
//         } else {
//           resendDuration.value--;
//         }
//       },
//     );
//   }

//   @override
//   void dispose() {
//     otpResendTimer?.cancel();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         ValueListenableBuilder(
//             valueListenable: height,
//             builder: (context, value, child) {
//               return Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   Form(
//                     key: sl.get<VerifyOtpCubit>().verifyOtpFormKey,
//                     child: CustomTextFormField(
//                       hintText: enterCodeText,
//                       labelText: otpcodeText,
//                       textInputAction: TextInputAction.done,
//                       validator: (val) {
//                         if (val.toString().isEmptyData()) {
//                           return emptyText;
//                         } else if (val.toString().isOtpLength()) {
//                           return validOtpText;
//                         } else if (!val.toString().isValidOtp()) {
//                           return validOtpText;
//                         } else {
//                           return null;
//                         }
//                       },
//                       controller: sl.get<VerifyOtpCubit>().otpController,
//                       onlyNumber: true,
//                       textInputType: TextInputType.number,
//                     ),
//                   ),
//                   vSizedBox1,
//                   Align(
//                     alignment: Alignment.centerRight,
//                     child: ValueListenableBuilder(
//                       valueListenable: resendDuration,
//                       builder: (context, value, child) {
//                         return value != 0
//                             ? CustomText.ourText(
//                                 "$resendotpText in ${value}s",
//                                 fontSize: 13,
//                                 color: Colors.grey,
//                               )
//                             : hSizedBox0;
//                       },
//                     ),
//                   ),
//                 ],
//               );
//             }),
//         vSizedBox0,
//         Align(
//           alignment: Alignment.centerRight,
//           child: ValueListenableBuilder(
//             valueListenable: isClicked,
//             builder: (context, value, child) {
//               if (!value) {
//                 return CustomButton.elevatedButton(
//                   resendCodeText,
//                   () {
//                     isClicked.value = true;
//                     startTimer();
//                     sl
//                         .get<SetOtpCubit>()
//                         .setOTP(fromResend: true, purpose: widget.purpose);
//                     unfocusKeyboard(context);
//                   },
//                   isBorder: true,
//                   height: 32,
//                   width: 110,
//                   padding: EdgeInsets.zero,
//                   fontSize: 14,
//                   fontWeight: FontWeight.w500,
//                   titleColor: AppColor.kPrimaryMain,
//                   color: AppColor.kPrimaryMain,
//                 );
//               } else {
//                 return const SizedBox.shrink();
//               }
//             },
//           ),
//         ),
//         vSizedBox1,
//       ],
//     );
//   }
// }
