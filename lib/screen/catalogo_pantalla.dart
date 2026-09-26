import 'package:flutter/material.dart';
import 'package:appflutter/modelos/propiedad.dart';
import 'package:appflutter/screen/detalle_propiedad_pantalla.dart';
import 'package:appflutter/screen/formulario_propiedad_pantalla.dart';
import 'package:appflutter/screen/oportunidades_pantalla.dart';

class CatalogoPantalla extends StatefulWidget {
  const CatalogoPantalla({super.key, required this.rol});

  final String rol;

  @override
  State<CatalogoPantalla> createState() => _CatalogoPantallaState();
}

class _CatalogoPantallaState extends State<CatalogoPantalla> {
  static const List<Propiedad> _propiedadesIniciales = [
    Propiedad(
      titulo: 'Apartamento moderno en Laureles',
      ciudad: 'Medellín',
      sector: 'Laureles',
      tipo: 'Apartamento',
      precio: r'$ 480.000.000',
      habitaciones: 3,
      banos: 2,
      area: 96,
      descripcion:
          'Apartamento iluminado con balcón, cocina abierta y excelente '
          'ubicación cerca de parques y servicios.',
      responsable: 'Andrés Gómez',
    ),
    Propiedad(
      titulo: 'Casa familiar en Envigado',
      ciudad: 'Envigado',
      sector: 'Loma de Las Brujas',
      tipo: 'Casa',
      precio: r'$ 720.000.000',
      habitaciones: 4,
      banos: 3,
      area: 180,
      descripcion:
          'Casa amplia con zona verde, espacios familiares y acceso cercano '
          'a servicios y vías principales.',
      responsable: 'Andrés Gómez',
    ),
  ];

  late final List<Propiedad> _propiedades;
  late List<Propiedad> _resultados;
  String _ciudadSeleccionada = 'Todas';
  String _tipoSeleccionado = 'Todos';

  @override
  void initState() {
    super.initState();
    _propiedades = List<Propiedad>.of(_propiedadesIniciales);
    _resultados = List<Propiedad>.of(_propiedades);
  }

  List<Propiedad> _filtrarPropiedades() {
    return _propiedades.where((propiedad) {
      final coincideCiudad =
          _ciudadSeleccionada == 'Todas' ||
          propiedad.ciudad == _ciudadSeleccionada;
      final coincideTipo =
          _tipoSeleccionado == 'Todos' || propiedad.tipo == _tipoSeleccionado;
      return coincideCiudad && coincideTipo;
    }).toList();
  }

  void _aplicarFiltros() {
    setState(() {
      _resultados = _filtrarPropiedades();
    });
  }

  Future<void> _abrirFormularioPropiedad() async {
    final nuevaPropiedad = await Navigator.push<Propiedad>(
      context,
      MaterialPageRoute<Propiedad>(
        builder: (context) => FormularioPropiedadPantalla(rol: widget.rol),
      ),
    );

    if (!mounted || nuevaPropiedad == null) {
      return;
    }

    setState(() {
      _propiedades.insert(0, nuevaPropiedad);
      _resultados = _filtrarPropiedades();
    });

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Propiedad guardada correctamente.')),
    );
  }

  void _abrirOportunidades() {
    Navigator.push(
      context,
      MaterialPageRoute<void>(
        builder: (context) => OportunidadesPantalla(
          rol: widget.rol,
          propiedades: List<Propiedad>.unmodifiable(_propiedades),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
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
        actions: [
          IconButton(
            tooltip: 'Cerrar sesión',
            onPressed: () => Navigator.pop(context),
            icon: const Icon(Icons.logout),
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(20, 8, 20, 24),
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Hola, Andrés',
                style: Theme.of(context).textTheme.titleLarge
                    ?.copyWith(fontWeight: FontWeight.bold),
              ),
              Chip(
                avatar: const Icon(Icons.person_outline, size: 18),
                label: Text(widget.rol),
                backgroundColor: const Color(0xFFE2F4F3),
              ),
            ],
          ),
          const SizedBox(height: 18),
          Text(
            'Propiedades disponibles',
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
              color: const Color(0xFF0E4775),
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 14),
          _construirFiltros(),
          if (widget.rol != 'Comprador') ...[
            const SizedBox(height: 16),
            _construirAccionesDelRol(),
          ],
          const SizedBox(height: 20),
          if (_resultados.isEmpty)
            const _SinResultados()
          else
            ..._resultados.map(
              (propiedad) => Padding(
                padding: const EdgeInsets.only(bottom: 16),
                child: _TarjetaPropiedad(
                  propiedad: propiedad,
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute<void>(
                        builder: (context) =>
                            DetallePropiedadPantalla(propiedad: propiedad),
                      ),
                    );
                  },
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _construirFiltros() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            DropdownButtonFormField<String>(
              initialValue: _ciudadSeleccionada,
              decoration: const InputDecoration(
                labelText: 'Ciudad',
                prefixIcon: Icon(Icons.location_on_outlined),
                border: OutlineInputBorder(),
              ),
              items: const ['Todas', 'Medellín', 'Envigado']
                  .map(
                    (ciudad) =>
                        DropdownMenuItem(value: ciudad, child: Text(ciudad)),
                  )
                  .toList(),
              onChanged: (ciudad) {
                if (ciudad != null) {
                  _ciudadSeleccionada = ciudad;
                }
              },
            ),
            const SizedBox(height: 12),
            DropdownButtonFormField<String>(
              initialValue: _tipoSeleccionado,
              decoration: const InputDecoration(
                labelText: 'Tipo de inmueble',
                prefixIcon: Icon(Icons.apartment_outlined),
                border: OutlineInputBorder(),
              ),
              items: const ['Todos', 'Apartamento', 'Casa']
                  .map(
                    (tipo) => DropdownMenuItem(value: tipo, child: Text(tipo)),
                  )
                  .toList(),
              onChanged: (tipo) {
                if (tipo != null) {
                  _tipoSeleccionado = tipo;
                }
              },
            ),
            const SizedBox(height: 14),
            SizedBox(
              width: double.infinity,
              height: 48,
              child: FilledButton.icon(
                onPressed: _aplicarFiltros,
                icon: const Icon(Icons.search),
                label: const Text('Filtrar'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _construirAccionesDelRol() {
    return Wrap(
      spacing: 12,
      runSpacing: 12,
      children: [
        OutlinedButton.icon(
          onPressed: _abrirFormularioPropiedad,
          icon: const Icon(Icons.add_home_outlined),
          label: const Text('Publicar propiedad'),
        ),
        if (widget.rol == 'Agente')
          OutlinedButton.icon(
            onPressed: _abrirOportunidades,
            icon: const Icon(Icons.bar_chart_outlined),
            label: const Text('Oportunidades'),
          ),
      ],
    );
  }
}

class _TarjetaPropiedad extends StatelessWidget {
  const _TarjetaPropiedad({required this.propiedad, required this.onTap});

  final Propiedad propiedad;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Card(
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              height: 150,
              width: double.infinity,
              color: const Color(0xFFE2F4F3),
              child: Icon(
                propiedad.tipo == 'Casa'
                    ? Icons.house_outlined
                    : Icons.apartment_outlined,
                size: 76,
                color: const Color(0xFF0E4775),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          propiedad.titulo,
                          style: Theme.of(context).textTheme.titleMedium
                              ?.copyWith(fontWeight: FontWeight.bold),
                        ),
                      ),
                      const Icon(Icons.chevron_right),
                    ],
                  ),
                  const SizedBox(height: 6),
                  Text(
                    '${propiedad.sector}, ${propiedad.ciudad}',
                    style: const TextStyle(color: Color(0xFF5D6670)),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    propiedad.precio,
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      color: const Color(0xFF0E4775),
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Wrap(
                    spacing: 18,
                    runSpacing: 8,
                    children: [
                      _DatoPropiedad(
                        icono: Icons.bed_outlined,
                        texto: '${propiedad.habitaciones} hab',
                      ),
                      _DatoPropiedad(
                        icono: Icons.bathtub_outlined,
                        texto: '${propiedad.banos} baños',
                      ),
                      _DatoPropiedad(
                        icono: Icons.square_foot,
                        texto: '${propiedad.area} m²',
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _DatoPropiedad extends StatelessWidget {
  const _DatoPropiedad({required this.icono, required this.texto});

  final IconData icono;
  final String texto;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icono, size: 20, color: const Color(0xFF5D6670)),
        const SizedBox(width: 5),
        Text(texto),
      ],
    );
  }
}

class _SinResultados extends StatelessWidget {
  const _SinResultados();

  @override
  Widget build(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.symmetric(vertical: 48),
      child: Column(
        children: [
          Icon(Icons.search_off, size: 64, color: Color(0xFF5D6670)),
          SizedBox(height: 12),
          Text('No hay propiedades con los filtros seleccionados.'),
        ],
      ),
    );
  }
}
