import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/auth/auth_bloc.dart';
import 'home_page.dart';
import 'pin_verification_page.dart';
import '../widgets/biometric_button.dart';

class AuthPage extends StatefulWidget {
  const AuthPage({super.key});

  @override
  State<AuthPage> createState() => _AuthPageState();
}

class _AuthPageState extends State<AuthPage> {
  bool _isLoading = false;
  bool _isBiometricSupported = false;

  @override
  void initState() {
    super.initState();
    // Verificar soporte biométrico
    context.read<AuthBloc>().add(CheckBiometricSupportEvent());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocConsumer<AuthBloc, AuthState>(
        listener: (context, state) {
          if (state is AuthLoading) {
            setState(() => _isLoading = true);
          } else {
            setState(() => _isLoading = false);
          }

          if (state is BiometricSupportState) {
            setState(() => _isBiometricSupported = state.isSupported);
          } else if (state is AuthenticatedState) {
            Navigator.of(context).pushReplacement(
              MaterialPageRoute(builder: (_) => const HomePage()),
            );
          } else if (state is BiometricFailedState) {
            // Cargar información del usuario para verificar si ya tiene un PIN configurado
            context.read<AuthBloc>().add(LoadUserInfoEvent());
          } else if (state is UserInfoLoadedState) {
            // Verificar si el usuario ya ha configurado un PIN
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (_) => PinVerificationPage(
                  isSetup: !state.user.hasSetupPin,
                ),
              ),
            );
          } else if (state is AuthError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.message)),
            );
          }
        },
        builder: (context, state) {
          return SafeArea(
            child: Center(
              child: Padding(
                padding: const EdgeInsets.all(24.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Spacer(),
                    // Logo o imagen principal
                    Container(
                      width: 150,
                      height: 150,
                      decoration: BoxDecoration(
                        color: Theme.of(context).primaryColor.withOpacity(0.1),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        Icons.qr_code_scanner,
                        size: 80,
                        color: Theme.of(context).primaryColor,
                      ),
                    ),
                    const SizedBox(height: 32),
                    // Título de la app
                    const Text(
                      'Seek Challenge',
                      style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const Text(
                      'by Abel Tarazona',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.grey,
                      ),
                    ),
                    const Spacer(),
                    // Botón de autenticación biométrica
                    if (_isLoading)
                      const CircularProgressIndicator()
                    else if (_isBiometricSupported)
                      BiometricButton(
                        onPressed: () {
                          context.read<AuthBloc>().add(AuthenticateBiometricEvent());
                        },
                      )
                    else
                      ElevatedButton(
                        onPressed: () {
                          // Cargar información del usuario para verificar si ya tiene un PIN configurado
                          context.read<AuthBloc>().add(LoadUserInfoEvent());
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Theme.of(context).primaryColor,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(
                            horizontal: 32,
                            vertical: 16,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: const Text('Continuar con PIN'),
                      ),
                    const SizedBox(height: 48),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}