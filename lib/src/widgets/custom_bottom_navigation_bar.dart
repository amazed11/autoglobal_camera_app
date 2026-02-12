// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';

// import '../../di_injection.dart';
// import '../core/app/colors.dart';
// import '../features/main/presentation/cubit/nav_cubit.dart';

// class CustomUserBottomNavigationBar extends StatelessWidget {
//   const CustomUserBottomNavigationBar({Key? key}) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return BlocBuilder<NavCubit, int>(
//       builder: (context, state) {
//         return BottomNavigationBar(
//           type: BottomNavigationBarType.fixed,
//           selectedItemColor: AppColor.kPrimaryMain,
//           unselectedItemColor: Colors.grey,
//           selectedFontSize: 12.0,
//           selectedLabelStyle: const TextStyle(fontWeight: FontWeight.w700),
//           unselectedFontSize: 12.0,
//           currentIndex: state,
//           onTap: (int index) {
//             getIt<NavCubit>().changeCurrentIndex(index);
//           },
//           items: [
//             custombottomitem(
//               'Home',
//               Icons.home_outlined,
//               Icons.home_filled,
//             ),
//             custombottomitem(
//               'Search',
//               Icons.search,
//               Icons.search_outlined,
//             ),
//             custombottomitem(
//               'Wishlist',
//               Icons.favorite_border,
//               Icons.favorite,
//             ),
//             custombottomitem(
//               'Profile',
//               Icons.person_outlined,
//               Icons.person,
//             ),
//           ],
//         );
//       },
//     );
//   }
// }

// BottomNavigationBarItem custombottomitem(
//     String? label, IconData activeIcon, IconData icon) {
//   return BottomNavigationBarItem(
//     label: label,
//     activeIcon: BlocBuilder<NavCubit, int>(
//       builder: (context, state) {
//         return Padding(
//             padding: const EdgeInsets.only(bottom: 2.5),
//             child: Icon(activeIcon));
//       },
//     ),
//     icon: Padding(
//       padding: const EdgeInsets.only(bottom: 2.5),
//       child: Icon(icon),
//     ),
//   );
// }
