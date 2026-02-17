import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../../di_injection.dart';
import '../../../../../core/app/dimensions.dart';
import '../../../../../core/app/medias.dart';
import '../../../../../core/configs/route_config.dart';
import '../../../../../core/routing/route_generator.dart';
import '../../cubit/splash_cubit.dart';

class SplashBody extends StatefulWidget {
  const SplashBody({super.key});

  @override
  State<SplashBody> createState() => _SplashBodyState();
}

class _SplashBodyState extends State<SplashBody> {
  @override
  void initState() {
    super.initState();
    getIt<SplashCubit>().getPreferences();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<SplashCubit, SplashState>(
      listener: (context, state) {
        print("I am inside splash listener");
        if (state.status == SplashStatus.initial) {}
        if (state.status == SplashStatus.loggedIn) {
          AppRouter().clearAndNavigate(RouteConfig.mainRoute);
        }
        if (state.status == SplashStatus.loggedOut) {
          AppRouter().clearAndNavigate(RouteConfig.loginRoute);
        }
      },
      child: Scaffold(
        backgroundColor: Colors.white,
        body: SizedBox(
          height: appHeight(context),
          width: appWidth(context),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Image.asset(
                kSplashImage,
                width: appWidth(context) * 0.6,
              ),
              const SizedBox(height: 20),
              const CircularProgressIndicator(
                strokeWidth: 1.5,
              ),
              vSizedBox1,
            ],
          ),
        ),
      ),
    );
  }
}
