import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:seek_challenge/presentation/bloc/auth/auth_bloc.dart';
import 'package:seek_challenge/presentation/bloc/qr_scanner/qr_scanner_bloc.dart';
import 'package:seek_challenge/presentation/pages/auth_page.dart';
import 'di/injection_container.dart' as di;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  await di.init();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<AuthBloc>(
          create: (context) => di.sl<AuthBloc>()..add(LoadUserInfoEvent()),
        ),
        BlocProvider<QrScannerBloc>(
          create: (context) => di.sl<QrScannerBloc>(),
        ),
      ],
      child: MaterialApp(
        title: 'Seek Challenge',
        theme: ThemeData(
          visualDensity: VisualDensity.adaptivePlatformDensity,
          useMaterial3: true,
          primaryColor: Colors.red,
        ),
        home: const AuthPage(),
        debugShowCheckedModeBanner: false,
      ),
    );
  }
}
