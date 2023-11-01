import 'package:animated_splash_screen/animated_splash_screen.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mahal/controllers/cubit/cubit.dart';
import 'package:mahal/controllers/cubit/state.dart';
import 'package:mahal/views/todo_layout_screens.dart';
import 'package:mahal/shared/styles/themes.dart';
import 'package:page_transition/page_transition.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await EasyLocalization.ensureInitialized();

  SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
  bool isDark = sharedPreferences.getBool("isDark") ?? false;
  runApp(EasyLocalization(

      path: "assets/translations",
      supportedLocales: const [Locale('en', 'US'), Locale('ar', 'EG')],
      fallbackLocale: const Locale('en', 'US'),
      child: MyApp(isDark: isDark,),
  ) );
}
class MyApp extends StatelessWidget {
  const MyApp({super.key, required this.isDark});
  final bool isDark;
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return  MultiBlocProvider(
      providers: [
        BlocProvider(create: (context)=> ToDoCubit()..createToDoDatabase()..changeThemeMode(darkMode: isDark)),
      ],
      child: BlocBuilder<ToDoCubit, ToDoState>(
        builder: (BuildContext context, state) {
          var cubit = ToDoCubit.get(context);
          return  MaterialApp(
            localizationsDelegates: context.localizationDelegates,
            supportedLocales: context.supportedLocales,
            locale: context.locale,
            title: 'ToDo App'.tr(),
            theme: lightTheme,
            darkTheme: darkTheme,
            themeMode: cubit.isDark ? ThemeMode.dark: ThemeMode.light,
            home: AnimatedSplashScreen(
              splash: Image.asset('assets/images/deal.jpg', fit: BoxFit.cover,),
              splashIconSize: double.infinity,
              duration: 500,
              splashTransition: SplashTransition.fadeTransition,
              pageTransitionType: PageTransitionType.fade,
              centered: true,
              backgroundColor: Colors.transparent,
              nextScreen: const ToDOScreens(),
            ),
          );
        }

      ),
    );
  }
}
