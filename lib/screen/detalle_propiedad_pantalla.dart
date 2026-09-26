import 'package:flutter/material.dart';
import 'package:appflutter/modelos/propiedad.dart';

class DetallePropiedadPantalla extends StatelessWidget {
  const DetallePropiedadPantalla({super.key, required this.propiedad});

  final Propiedad propiedad;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Detalle de propiedad')),
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
                propiedad.titulo,
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.headlineSmall,
              ),
              const SizedBox(height: 8),
              Text(
                '${propiedad.sector}, ${propiedad.ciudad}',
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 8),
              const Text(
                'P-03 se completará en el siguiente paso.',
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
