import 'package:flutter/material.dart';

class CatalogoPantalla extends StatelessWidget {
  const CatalogoPantalla({super.key, required this.rol});

  final String rol;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Catálogo')),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(
                Icons.home_work_outlined,
                size: 72,
                color: Color(0xFF0E4775),
              ),
              const SizedBox(height: 16),
              Text(
                'P-02 Catálogo',
                style: Theme.of(context).textTheme.headlineSmall,
              ),
              const SizedBox(height: 8),
              Text('Rol seleccionado: $rol', textAlign: TextAlign.center),
              const SizedBox(height: 8),
              const Text(
                'Esta pantalla se completará en el siguiente paso.',
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
