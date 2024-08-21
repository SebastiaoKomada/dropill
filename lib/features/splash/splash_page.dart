  import 'package:dropill_project/common/constants/app_colors.dart';
  import 'package:dropill_project/common/constants/app_text_styles.dart';
  import 'package:dropill_project/common/constants/routes.dart';
  import 'package:dropill_project/features/splash/splash_controller.dart';
  import 'package:dropill_project/features/splash/splash_state.dart';
  import 'package:dropill_project/locator.dart';
  import 'package:flutter/material.dart';

  class SplashPage extends StatefulWidget {
    const SplashPage({super.key});

    @override
    State<SplashPage> createState() => _SplashPageState();
  }

  class _SplashPageState extends State<SplashPage> {
    final _splashController = locator.get<SplashController>();

    @override
    void initState() {
      super.initState();
      _splashController.isUserLogged();
      _splashController.addListener(() {
        if(_splashController.state is SplashStateSuccess){
          Navigator.pushReplacementNamed(context, NamedRoute.profile);
        } else {
          Navigator.pushReplacementNamed(context, NamedRoute.initial);
        }
      });
    }

    @override
    Widget build(BuildContext context) {
      return  Scaffold(
        body: Container(
          alignment: Alignment.center,
          decoration: const BoxDecoration(
              gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [AppColors.darkBlue, AppColors.standartBlue])
          ),
          child: Text('dropill',
              style: AppTextStyles.bigText50.copyWith(color: AppColors.white)),
        ),
      );
    }
  }