import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:whatsappmessenger/common/widgets/error.dart';
import 'package:whatsappmessenger/common/widgets/loding_screen.dart';
import 'package:whatsappmessenger/firebase_options.dart';
import 'package:whatsappmessenger/mobile_screen.dart';
import 'package:whatsappmessenger/router.dart';
import 'package:whatsappmessenger/view/auth/controller/auth_controller.dart';
import 'package:whatsappmessenger/view/landing/screens/screens.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends ConsumerWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Whatsapp',
        onGenerateRoute: (settings) => generateRoute(settings),
        // home:  const Openingscreen(),
        home: ref.watch(userDataAuthProvider).when(
            data: (user) {
              if (user == null) {
                return const Openingscreen();
              } else {
                return const MobilelayoutScreen();
             }
            },
            error: (err, trace) {
              return Errorpage(error: err.toString()
              );
            },
            loading: () => const LodingScreen()
            )
          );
        }
      }
