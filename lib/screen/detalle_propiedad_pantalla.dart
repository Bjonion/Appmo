import 'package:flutter/material.dart';
import 'package:appflutter/modelos/propiedad.dart';

class DetallePropiedadPantalla extends StatelessWidget {
  const DetallePropiedadPantalla({super.key, required this.propiedad});

  final Propiedad propiedad;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Row(
          children: [
            Icon(Icons.house_outlined, color: Color(0xFF0E4775)),
            SizedBox(width: 8),
            Text(
              'InmoConecta',
              style: TextStyle(
                color: Color(0xFF0E4775),
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(20, 8, 20, 28),
        children: [
          Text(
            'Detalle de propiedad',
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
              color: const Color(0xFF0E4775),
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          _ImagenPropiedad(tipo: propiedad.tipo),
          const SizedBox(height: 20),
          Text(
            propiedad.titulo,
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
              color: const Color(0xFF0E4775),
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 10),
          const Align(
            alignment: Alignment.centerLeft,
            child: Chip(
              avatar: Icon(Icons.circle, size: 12, color: Color(0xFF25A7A3)),
              label: Text('Publicada'),
              backgroundColor: Color(0xFFE2F4F3),
            ),
          ),
          const SizedBox(height: 6),
          Row(
            children: [
              const Icon(Icons.location_on_outlined, color: Color(0xFF5D6670)),
              const SizedBox(width: 6),
              Expanded(
                child: Text(
                  '${propiedad.sector}, ${propiedad.ciudad}',
                  style: Theme.of(context).textTheme.titleMedium,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            propiedad.precio,
            style: Theme.of(context).textTheme.headlineMedium?.copyWith(
              color: const Color(0xFF0E4775),
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 20),
          Row(
            children: [
              Expanded(
                child: _Caracteristica(
                  icono: Icons.bed_outlined,
                  valor: '${propiedad.habitaciones}',
                  etiqueta: 'habitaciones',
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: _Caracteristica(
                  icono: Icons.bathtub_outlined,
                  valor: '${propiedad.banos}',
                  etiqueta: 'baños',
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: _Caracteristica(
                  icono: Icons.square_foot,
                  valor: '${propiedad.area}',
                  etiqueta: 'm²',
                ),
              ),
            ],
          ),
          const SizedBox(height: 18),
          _SeccionDetalle(
            titulo: 'Descripción',
            child: Text(
              propiedad.descripcion,
              style: Theme.of(context).textTheme.bodyLarge,
            ),
          ),
          const SizedBox(height: 14),
          _SeccionDetalle(
            titulo: 'Responsable',
            child: Row(
              children: [
                const CircleAvatar(
                  radius: 28,
                  backgroundColor: Color(0xFFE2F4F3),
                  child: Icon(
                    Icons.person_outline,
                    color: Color(0xFF0E4775),
                    size: 32,
                  ),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        propiedad.responsable,
                        style: Theme.of(context).textTheme.titleMedium
                            ?.copyWith(fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 3),
                      const Text('Agente inmobiliario'),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _ImagenPropiedad extends StatelessWidget {
  const _ImagenPropiedad({required this.tipo});

  final String tipo;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 250,
      decoration: BoxDecoration(
        color: const Color(0xFFE2F4F3),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Stack(
        children: [
          Center(
            child: Icon(
              tipo == 'Casa' ? Icons.house_outlined : Icons.apartment_outlined,
              size: 120,
              color: const Color(0xFF0E4775),
            ),
          ),
          Positioned(
            right: 14,
            bottom: 14,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 7),
              decoration: BoxDecoration(
                color: const Color(0xCC26313A),
                borderRadius: BorderRadius.circular(20),
              ),
              child: const Text('1 / 4', style: TextStyle(color: Colors.white)),
            ),
          ),
        ],
      ),
    );
  }
}

class _Caracteristica extends StatelessWidget {
  const _Caracteristica({
    required this.icono,
    required this.valor,
    required this.etiqueta,
  });

  final IconData icono;
  final String valor;
  final String etiqueta;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 14),
        child: Column(
          children: [
            Icon(icono, color: const Color(0xFF0E4775), size: 30),
            const SizedBox(height: 8),
            Text(
              valor,
              style: Theme.of(context).textTheme.titleMedium
                  ?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 2),
            FittedBox(child: Text(etiqueta)),
          ],
        ),
      ),
    );
  }
}

class _SeccionDetalle extends StatelessWidget {
  const _SeccionDetalle({required this.titulo, required this.child});

  final String titulo;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(18),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              titulo,
              style: Theme.of(context).textTheme.titleLarge
                  ?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            child,
          ],
        ),
      ),
    );
  }
}
