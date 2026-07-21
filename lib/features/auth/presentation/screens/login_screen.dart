import 'package:auth_flow_app/core/di/injection_container.dart';
import 'package:auth_flow_app/features/auth/presentation/bloc/email_auth/email_auth_bloc.dart';
import 'package:auth_flow_app/features/auth/presentation/bloc/email_auth/email_auth_event.dart';
import 'package:auth_flow_app/features/auth/presentation/bloc/email_auth/email_auth_state.dart';
import 'package:auth_flow_app/features/auth/presentation/bloc/social_auth/social_auth_bloc.dart';
import 'package:auth_flow_app/features/auth/presentation/bloc/social_auth/social_auth_event.dart';
import 'package:auth_flow_app/features/auth/presentation/bloc/social_auth/social_auth_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => sl<EmailAuthBloc>()),
        BlocProvider(create: (context) => sl<SocialAuthBloc>()),
      ],
      child: const LoginView(),
    );
  }
}

class LoginView extends StatefulWidget {
  const LoginView({super.key});

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Login')),
      body: MultiBlocListener(
        listeners: [
          BlocListener<EmailAuthBloc, EmailAuthState>(
            listener: (context, state) {
              if (state is EmailAuthError) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(state.message),
                    backgroundColor: Colors.red,
                  ),
                );
              } else if (state is EmailAuthSuccess) {
                Navigator.pushReplacementNamed(context, '/home');
              }
            },
          ),
          BlocListener<SocialAuthBloc, SocialAuthState>(
            listener: (context, state) {
              if (state is SocialAuthError) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(state.message),
                    backgroundColor: Colors.red,
                  ),
                );
              } else if (state is SocialAuthSuccess) {
                Navigator.pushReplacementNamed(context, '/home');
              }
            },
          ),
        ],
        child: BlocBuilder<EmailAuthBloc, EmailAuthState>(
          builder: (context, emailState) {
            final isLoading =
                emailState is EmailAuthLoading ||
                context.select<SocialAuthBloc, bool>((SocialAuthBloc value) => value.state is SocialAuthLoading);

            if (isLoading) {
              return const Center(child: CircularProgressIndicator());
            }

            return SingleChildScrollView(
              padding: const EdgeInsets.all(24.0),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const SizedBox(height: 40),
                    TextFormField(
                      controller: _emailController,
                      decoration: const InputDecoration(
                        labelText: 'Email',
                        border: OutlineInputBorder(),
                        prefixIcon: Icon(Icons.email),
                      ),
                      keyboardType: TextInputType.emailAddress,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter your email';
                        }
                        if (!value.contains('@')) {
                          return 'Please enter a valid email';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: _passwordController,
                      decoration: const InputDecoration(
                        labelText: 'Password',
                        border: OutlineInputBorder(),
                        prefixIcon: Icon(Icons.lock),
                      ),
                      obscureText: true,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter your password';
                        }
                        if (value.length < 6) {
                          return 'Password must be at least 6 characters';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 24),
                    ElevatedButton(
                      onPressed: () {
                        if (_formKey.currentState!.validate()) {
                          context.read<EmailAuthBloc>().add(
                            SignInWithEmailEvent(
                              email: _emailController.text.trim(),
                              password: _passwordController.text,
                            ),
                          );
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                      ),
                      child: const Text('Login'),
                    ),
                    const SizedBox(height: 16),
                    TextButton(
                      onPressed: () {
                        Navigator.pushNamed(context, '/forgot-password');
                      },
                      child: const Text('Forgot Password?'),
                    ),
                    const SizedBox(height: 16),
                    OutlinedButton(
                      onPressed: () {
                        Navigator.pushNamed(context, '/signup');
                      },
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                      ),
                      child: const Text('Create Account'),
                    ),
                    const SizedBox(height: 32),
                    const Row(
                      children: [
                        Expanded(child: Divider()),
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 16),
                          child: Text('OR'),
                        ),
                        Expanded(child: Divider()),
                      ],
                    ),
                    const SizedBox(height: 32),
                    OutlinedButton.icon(
                      onPressed: () {
                        context.read<SocialAuthBloc>().add(
                          const SignInWithGoogleEvent(),
                        );
                      },
                      icon: const Icon(Icons.g_mobiledata, size: 32),
                      label: const Text('Continue with Google'),
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                      ),
                    ),
                    const SizedBox(height: 12),
                    OutlinedButton.icon(
                      onPressed: () {
                        context.read<SocialAuthBloc>().add(
                          const SignInWithGitHubEvent(),
                        );
                      },
                      icon: const Icon(Icons.code, size: 28),
                      label: const Text('Continue with GitHub'),
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                      ),
                    ),
                    const SizedBox(height: 24),
                    TextButton(
                      onPressed: () {
                        Navigator.pushNamed(context, '/magic-link');
                      },
                      child: const Text('Send Magic Link'),
                    ),
                    TextButton(
                      onPressed: () {
                        Navigator.pushNamed(context, '/phone-auth');
                      },
                      child: const Text('Login with Phone Number'),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
