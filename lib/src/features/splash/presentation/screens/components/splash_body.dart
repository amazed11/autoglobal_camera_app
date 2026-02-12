import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../../di_injection.dart';
import '../../../../../core/app/dimensions.dart';
import '../../../../../core/configs/route_config.dart';
import '../../../../../core/development/console.dart';
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
    getIt<SplashCubit>().getPreferences();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<SplashCubit, SplashState>(
      listener: (context, state) {
        print("I am inside splash listener");
        if (state.status == SplashStatus.initial) {
          consolelog("i am initial");
        }

        if (state.status == SplashStatus.loggedIn) {
          AppRouter().clearAndNavigate(RouteConfig.mainRoute);
        }
        if (state.status == SplashStatus.loggedOut) {
          AppRouter().clearAndNavigate(RouteConfig.loginRoute);
        }
      },
      child: SafeArea(
        child: Scaffold(
          appBar: AppBar(
            systemOverlayStyle: SystemUiOverlayStyle.light,
          ),
          body: const Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text("Ag Car"),
                vSizedBox2,
                Expanded(
                  child: Center(
                    child: CircularProgressIndicator(
                      strokeWidth: 1.5,
                    ),
                  ),
                ),
                vSizedBox1,
              ],
            ),
          ),
        ),
      ),
    );
  }
}
