import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/auth/auth_bloc.dart';
import '../bloc/qr_scanner/qr_scanner_bloc.dart';
import 'auth_page.dart';
import 'qr_scanner_page.dart';
import '../widgets/qr_scan_item.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  void initState() {
    super.initState();
    // Cargar historial de escaneos
    context.read<QrScannerBloc>().add(LoadScansEvent());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('QR Scanner App'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () {
              // Cerrar sesión
              context.read<AuthBloc>().add(LogoutEvent());
              Navigator.of(context).pushReplacement(
                MaterialPageRoute(builder: (_) => const AuthPage()),
              );
            },
          ),
        ],
      ),
      body: BlocBuilder<QrScannerBloc, QrScannerState>(
        builder: (context, state) {
          if (state is QRScannerLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is ScansLoadedState) {
            if (state.scans.isEmpty) {
              return _buildEmptyState();
            }
            return _buildScanList(state);
          } else if (state is QRScannerError) {
            return Center(
              child: Text('Error: ${state.message}'),
            );
          }

          // Estado inicial o cualquier otro estado
          return _buildEmptyState();
        },
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (_) => const QRScannerPage(),
            ),
          ).then((_) {
            // Actualizar la lista de escaneos al volver
            context.read<QrScannerBloc>().add(LoadScansEvent());
          });
        },
        icon: const Icon(Icons.qr_code_scanner),
        label: const Text('Escanear'),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.qr_code_scanner,
            size: 80,
            color: Colors.grey[400],
          ),
          const SizedBox(height: 16),
          const Text(
            'No hay escaneos',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            'Presiona el botón para escanear un código QR',
            style: TextStyle(
              color: Colors.grey,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildScanList(ScansLoadedState state) {
    return ListView.builder(
      padding: const EdgeInsets.only(bottom: 80),
      itemCount: state.scans.length,
      itemBuilder: (context, index) {
        final scan = state.scans[index];
        return QRScanItem(
          scan: scan,
          onDelete: () {
            context.read<QrScannerBloc>().add(DeleteScanEvent(id: scan.id!));
          },
        );
      },
    );
  }
}
