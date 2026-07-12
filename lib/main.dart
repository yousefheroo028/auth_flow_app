import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:auth_flow_app/core/di/injection_container.dart';
import 'package:auth_flow_app/features/auth/presentation/bloc/session/session_bloc.dart';
import 'package:auth_flow_app/features/auth/presentation/bloc/session/session_event.dart';
import 'package:auth_flow_app/features/auth/presentation/bloc/session/session_state.dart';
import 'package:auth_flow_app/features/auth/presentation/screens/home_screen.dart';
import 'package:auth_flow_app/features/auth/presentation/screens/login_screen.dart';
import 'package:auth_flow_app/features/auth/presentation/screens/signup_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

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
        title: 'Auth Flow App',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue)),
        home: const AuthWrapper(),
        routes: {
          '/login': (context) => const LoginPage(),
          '/signup': (context) => const SignupPage(),
          '/home': (context) => const HomePage(),
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
