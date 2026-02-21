import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'firebase_options.dart';

// ================= AUTH =================
import 'features/auth/data/datasource/auth_remote_datasource.dart';
import 'features/auth/data/datasource/auth_local_datasource.dart';
import 'features/auth/data/repository/auth_repo_impl.dart';
import 'features/auth/domain/repositories/auth_repository.dart';
import 'features/auth/presentation/bloc/auth_bloc.dart';
import 'features/auth/presentation/screens/login_screen.dart';

// ================= HOME =================
import 'features/home/data/datasouce/home_remote_datasource.dart';
import 'features/home/data/repository/home_repository_impl.dart';
import 'features/home/presentation/bloc/home_bloc.dart';
import 'features/home/presentation/screens/homescreen.dart';

// ================= EVENT =================
import 'features/event/data/datasource/event_remote_datasource.dart';
import 'features/event/data/repository/event_repository_impl.dart';
import 'features/event/presentation/bloc/event_bloc.dart';

// ================= REGISTRATION =================
import 'features/participate/data/datasources/registration_remote_datasource.dart';
import 'features/participate/data/repositories/registration_repository_impl.dart';
import 'features/participate/presentation/bloc/register_bloc.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  final firebaseAuth = FirebaseAuth.instance;
  final firestore = FirebaseFirestore.instance;

  // ================= AUTH SETUP =================
  final authRemote =
  AuthRemoteDataSource(firebaseAuth, firestore);
  final authLocal = AuthLocalDataSource();

  final AuthRepository authRepository =
  AuthRepositoryImpl(authRemote, authLocal);

  // ================= HOME SETUP =================
  final homeRemote = HomeRemoteDataSource(firestore);
  final homeRepository =
  HomeRepositoryImpl(homeRemote);

  // ================= EVENT SETUP =================
  final eventRemote =
  EventRemoteDataSource(firestore);
  final eventRepository =
  EventRepositoryImpl(eventRemote);

  // ================= REGISTRATION SETUP =================
  final registrationRemote =
  RegistrationRemoteDataSource(firestore);
  final registrationRepository =
  RegistrationRepositoryImpl(registrationRemote);

  runApp(
    MultiBlocProvider(
      providers: [
        BlocProvider<AuthBloc>(
          create: (_) => AuthBloc(authRepository),
        ),
        BlocProvider<HomeBloc>(
          create: (_) => HomeBloc(homeRepository),
        ),
        BlocProvider<EventBloc>(
          create: (_) => EventBloc(eventRepository),
        ),
        BlocProvider<RegistrationBloc>(
          create: (_) =>
              RegistrationBloc(registrationRepository),
        ),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(375, 812),
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (context, child) {
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          theme: ThemeData(
            scaffoldBackgroundColor: const Color(0xffF9F9FB),
            appBarTheme: const AppBarTheme(
              backgroundColor: Colors.transparent,
              elevation: 0,
              centerTitle: true,
              foregroundColor: Colors.black,
            ),
          ),
          home: const AuthWrapper(),
        );
      },
    );
  }
}

class AuthWrapper extends StatelessWidget {
  const AuthWrapper({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {

        // 🔥 Loading state
        if (snapshot.connectionState ==
            ConnectionState.waiting) {
          return const Scaffold(
            body: Center(
              child: CircularProgressIndicator(),
            ),
          );
        }

        // 🔥 Logged In
        if (snapshot.data != null) {
          return const HomeScreen();
        }

        // 🔥 Not Logged In
        return const LoginScreen();
      },
    );
  }
}
