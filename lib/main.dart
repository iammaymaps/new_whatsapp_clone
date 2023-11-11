import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:new_whatsapp_clone/colors.dart';
import 'package:new_whatsapp_clone/common/widgets/error.dart';
import 'package:new_whatsapp_clone/feature/auth/controller/auth_controller.dart';
import 'package:new_whatsapp_clone/feature/landing/screens/landingScreen.dart';
import 'package:new_whatsapp_clone/firebase_options.dart';
import 'package:new_whatsapp_clone/router.dart';
import 'package:new_whatsapp_clone/screens/mobile_layout_screen.dart';
import 'package:new_whatsapp_clone/widgets/loader.dart';


void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends ConsumerWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Whatsapp UI',
      theme: ThemeData.dark().copyWith(
        scaffoldBackgroundColor: backgroundColor,
        appBarTheme: const AppBarTheme(color: appBarColor),
      ),
      onGenerateRoute: (settings) => generateRoute(settings),
      home: ref.watch(userDataAuthProvider).when(
          data: (user) {
            if (user == null) {
              return const LandingPage();
            }
            return const MobileLayoutScreen();
          },
          error: (err, trace) {
            return ErrorScreen(error: err.toString());
          },
          loading: () => const Loader()),
      // const ResponsiveLayout(
      //   mobileScreenLayout: MobileLayoutScreen(),
      //   webScreenLayout: WebLayoutScreen(),
      // ),
    );
  }
}
