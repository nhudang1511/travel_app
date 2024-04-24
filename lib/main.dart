import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_nhu_nguyen/config/bloc_observe.dart';
import 'package:flutter_nhu_nguyen/travel/bloc/promo/promo_bloc.dart';
import 'package:flutter_nhu_nguyen/travel/bloc/rating/rating_bloc.dart';
import 'package:flutter_nhu_nguyen/travel/model/notification_model.dart';
import 'package:flutter_nhu_nguyen/travel/repository/promo_repository.dart';
import 'package:flutter_nhu_nguyen/travel/screen/splash/splash_screen.dart';
import 'package:overlay_support/overlay_support.dart';
import 'package:provider/provider.dart';
import 'config/app_route.dart';
import 'config/shared_preferences.dart';
import 'config/theme/theme_provider.dart';
import 'travel/bloc/bloc.dart';
import 'travel/cubits/cubit.dart';
import 'travel/repository/repository.dart';
import 'firebase_options.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  Bloc.observer = const AppObserver();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  //FirebaseApi().initNotifications();
  await SharedService.init();
  runApp(ChangeNotifierProvider(
    create: (context) => ThemeProvider(),
    child: const MyApp(),
  ));
}


class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => AuthBloc(AuthRepository())..add(AuthEventStarted())),
        BlocProvider(create: (context) => LoginCubit(AuthRepository())),
        BlocProvider(create: (context) => SignupCubit(AuthRepository())),
        BlocProvider(
          create: (_) => UserBloc(
            AuthRepository(), UserRepository(),
          )..add(LoadUser()),
        ),
        BlocProvider(
          create: (_) => ForgotPasswordCubit(
            AuthRepository(),
          ),
        ),
        BlocProvider(create: (_)=>BookingBloc(BookingRepository())),
        BlocProvider(create: (_)=>BookingFlightBloc(BookingFlightRepository())),
        BlocProvider(create: (_) => NotificationBloc(NotificationRepository())),
        BlocProvider(create: (_) => RatingBloc(RatingRepository())),
        BlocProvider(create: (_) => PromoBloc(PromoRepository())),
      ],
      child: OverlaySupport.global(
        child: MaterialApp(
          title: 'Introduction screen',
          debugShowCheckedModeBanner: false,
          theme: Provider.of<ThemeProvider>(context).themeData,
          onGenerateRoute: (settings) {
            return AppRouter.onGenerateRoute(settings);
          },
          home: Builder(
            builder: (context) {
              return const SplashScreen();
            },
          ),
        ),
      ),
    );
  }
}
