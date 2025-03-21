import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/auth/auth_bloc.dart';
import 'home_page.dart';

class PinVerificationPage extends StatefulWidget {
  final bool isSetup;

  const PinVerificationPage({super.key, this.isSetup = true});

  @override
  State<PinVerificationPage> createState() => _PinVerificationPageState();
}

class _PinVerificationPageState extends State<PinVerificationPage> {
  final TextEditingController _pinController = TextEditingController();
  final TextEditingController _confirmPinController = TextEditingController();
  bool _isLoading = false;
  String _errorText = '';

  @override
  void dispose() {
    _pinController.dispose();
    _confirmPinController.dispose();
    super.dispose();
  }

  void _submitPin() {
    if (widget.isSetup) {
      if (_pinController.text.length < 4) {
        setState(() {
          _errorText = 'El PIN debe tener al menos 4 dígitos';
        });
        return;
      }

      if (_pinController.text != _confirmPinController.text) {
        setState(() {
          _errorText = 'Los PINs no coinciden';
        });
        return;
      }

      // Guardar el nuevo PIN
      context.read<AuthBloc>().add(SavePinEvent(pin: _pinController.text));
    } else {
      // Verificar PIN existente
      context.read<AuthBloc>().add(VerifyPinEvent(pin: _pinController.text));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.isSetup ? 'Configurar PIN' : 'Verificar PIN'),
      ),
      body: BlocConsumer<AuthBloc, AuthState>(
        listener: (context, state) {
          if (state is AuthLoading) {
            setState(() => _isLoading = true);
          } else {
            setState(() => _isLoading = false);
          }

          if (state is AuthenticatedState || state is PinSavedState) {
            Navigator.of(context).pushReplacement(
              MaterialPageRoute(builder: (_) => const HomePage()),
            );
          } else if (state is PinVerificationFailedState) {
            setState(() {
              _errorText = 'PIN incorrecto';
              _pinController.clear();
            });
          } else if (state is AuthError) {
            setState(() {
              _errorText = state.message;
            });
          }
        },
        builder: (context, state) {
          return SafeArea(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(24.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const SizedBox(height: 24),
                    // Icono o imagen
                    Icon(
                      widget.isSetup ? Icons.security : Icons.lock,
                      size: 70,
                      color: Theme.of(context).primaryColor,
                    ),
                    const SizedBox(height: 32),
                    // Título
                    Text(
                      widget.isSetup
                          ? 'Configura tu PIN de respaldo'
                          : 'Ingresa tu PIN',
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 16),
                    // Descripción
                    Text(
                      widget.isSetup
                          ? 'Este PIN te permitirá acceder si la autenticación biométrica falla.'
                          : 'Introduce tu PIN para acceder a la aplicación.',
                      style: const TextStyle(
                        fontSize: 16,
                        color: Colors.grey,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 40),
                    // Campo de PIN
                    TextField(
                      controller: _pinController,
                      decoration: InputDecoration(
                        labelText: 'PIN',
                        errorText: _errorText.isNotEmpty ? _errorText : null,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        prefixIcon: const Icon(Icons.pin),
                      ),
                      keyboardType: TextInputType.number,
                      obscureText: true,
                      maxLength: 6,
                      inputFormatters: [
                        FilteringTextInputFormatter.digitsOnly,
                      ],
                      onChanged: (_) {
                        if (_errorText.isNotEmpty) {
                          setState(() {
                            _errorText = '';
                          });
                        }
                      },
                    ),
                    const SizedBox(height: 16),
                    // Campo de confirmación de PIN (solo para configuración)
                    if (widget.isSetup)
                      TextField(
                        controller: _confirmPinController,
                        decoration: InputDecoration(
                          labelText: 'Confirmar PIN',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          prefixIcon: const Icon(Icons.pin),
                        ),
                        keyboardType: TextInputType.number,
                        obscureText: true,
                        maxLength: 6,
                        inputFormatters: [
                          FilteringTextInputFormatter.digitsOnly,
                        ],
                        onChanged: (_) {
                          if (_errorText.isNotEmpty) {
                            setState(() {
                              _errorText = '';
                            });
                          }
                        },
                      ),
                    const SizedBox(height: 32),
                    // Botón de envío
                    ElevatedButton(
                      onPressed: _isLoading ? null : _submitPin,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Theme.of(context).primaryColor,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: _isLoading
                          ? const CircularProgressIndicator(color: Colors.white)
                          : Text(widget.isSetup ? 'Guardar PIN' : 'Verificar'),
                    ),
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