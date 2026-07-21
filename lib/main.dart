import 'package:auth_flow_app/core/constants.dart';
import 'package:auth_flow_app/features/auth/presentation/screens/edit_profile_screen.dart';
import 'package:auth_flow_app/features/auth/presentation/screens/forgot_password_screen.dart';
import 'package:auth_flow_app/features/auth/presentation/screens/magic_link_screen.dart';
import 'package:auth_flow_app/features/auth/presentation/screens/phone_auth_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:auth_flow_app/core/di/injection_container.dart';
import 'package:auth_flow_app/features/auth/presentation/bloc/session/session_bloc.dart';
import 'package:auth_flow_app/features/auth/presentation/bloc/session/session_event.dart';
import 'package:auth_flow_app/features/auth/presentation/bloc/session/session_state.dart';
import 'package:auth_flow_app/features/auth/presentation/screens/home_screen.dart';
import 'package:auth_flow_app/features/auth/presentation/screens/login_screen.dart';
import 'package:auth_flow_app/features/auth/presentation/screens/signup_screen.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await dotenv.load();

  await Supabase.initialize(
    url: dotenv.get('SUPABASE_URL'),
    publishableKey: dotenv.get('SUPABASE_PUBLISHABLE_KEY'),
  );

  await initDependencies();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => sl<SessionBloc>()..add(const CheckAuthStatusEvent()),
      child: MaterialApp(
        title: Constants.appName,
        debugShowCheckedModeBanner: false,
        theme: ThemeData(colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue)),
        themeMode: .system,
        home: const AuthWrapper(),
        routes: {
          '/login': (context) => const LoginPage(),
          '/signup': (context) => const SignupPage(),
          '/home': (context) => const HomePage(),
          '/forgot-password': (context) => const ForgotPasswordProcessScreen(),
          '/phone-auth': (context) => const PhoneAuthScreen(),
          '/magic-link': (context) => const MagicLinkScreen(),
          '/edit_profile': (context) => const EditProfileScreen(),
        },
      ),
    );
  }
}

class AuthWrapper extends StatelessWidget {
  const AuthWrapper({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SessionBloc, SessionState>(
      builder: (context, state) => switch (state) {
        SessionLoading() || SessionInitial() => const Scaffold(body: Center(child: CircularProgressIndicator())),
        Authenticated(user: _) => const HomePage(),
        _ => const LoginPage(),
      },
    );
  }
}
