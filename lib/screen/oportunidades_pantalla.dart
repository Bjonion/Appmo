import 'package:flutter/material.dart';
import 'package:appflutter/modelos/oportunidad.dart';
import 'package:appflutter/modelos/propiedad.dart';
import 'package:appflutter/screen/registro_oportunidad_pantalla.dart';

class OportunidadesPantalla extends StatefulWidget {
  const OportunidadesPantalla({
    super.key,
    required this.rol,
    required this.propiedades,
  });

  final String rol;
  final List<Propiedad> propiedades;

  @override
  State<OportunidadesPantalla> createState() => _OportunidadesPantallaState();
}

class _OportunidadesPantallaState extends State<OportunidadesPantalla> {
  late final List<Oportunidad> _oportunidades;

  @override
  void initState() {
    super.initState();
    _oportunidades = [
      Oportunidad(
        propiedad: widget.propiedades.first,
        captador: 'Laura Martínez',
        colocador: 'Julián López',
        precioVenta: 480000000,
        comisionTotal: 24000000,
        porcentajeCaptador: 50,
        porcentajeColocador: 50,
        estado: 'Registrada',
      ),
      Oportunidad(
        propiedad: widget.propiedades.length > 1
            ? widget.propiedades[1]
            : widget.propiedades.first,
        captador: 'Andrés Gómez',
        colocador: 'Carolina Ruiz',
        precioVenta: 720000000,
        comisionTotal: 36000000,
        porcentajeCaptador: 50,
        porcentajeColocador: 50,
        estado: 'Reservada',
      ),
    ];
  }

  Future<void> _abrirRegistro([Oportunidad? oportunidad]) async {
    final resultado = await Navigator.push<Oportunidad>(
      context,
      MaterialPageRoute<Oportunidad>(
        builder: (context) => RegistroOportunidadPantalla(
          propiedades: widget.propiedades,
          oportunidad: oportunidad,
        ),
      ),
    );

    if (!mounted || resultado == null) {
      return;
    }

    setState(() {
      if (oportunidad == null) {
        _oportunidades.insert(0, resultado);
      } else {
        final indice = _oportunidades.indexOf(oportunidad);
        _oportunidades[indice] = resultado;
      }
    });

    ScaffoldMessenger.of(context)
        .showSnackBar(const SnackBar(content: Text('Oportunidad guardada.')));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        titleSpacing: 0,
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
        padding: const EdgeInsets.fromLTRB(20, 8, 20, 32),
        children: [
          Text(
            'Oportunidades',
            style: Theme.of(context).textTheme.headlineMedium?.copyWith(
              color: const Color(0xFF0E4775),
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 6),
          const Text(
            'Selecciona una oportunidad para revisar el cálculo',
            style: TextStyle(color: Color(0xFF5D6670)),
          ),
          const SizedBox(height: 18),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(18),
              child: Row(
                children: [
                  const CircleAvatar(
                    radius: 28,
                    backgroundColor: Color(0xFFE2F4F3),
                    child: Icon(
                      Icons.bar_chart,
                      color: Color(0xFF25A7A3),
                      size: 30,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Text(
                    '${_oportunidades.length}',
                    style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                      color: const Color(0xFF0E4775),
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(width: 8),
                  const Expanded(child: Text('oportunidades registradas')),
                ],
              ),
            ),
          ),
          const SizedBox(height: 14),
          SizedBox(
            height: 50,
            child: FilledButton.icon(
              onPressed: _abrirRegistro,
              icon: const Icon(Icons.add_circle_outline),
              label: const Text('Nueva oportunidad'),
            ),
          ),
          const SizedBox(height: 18),
          ..._oportunidades.map(
            (oportunidad) => Padding(
              padding: const EdgeInsets.only(bottom: 14),
              child: _TarjetaOportunidad(
                oportunidad: oportunidad,
                onTap: () => _abrirRegistro(oportunidad),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _TarjetaOportunidad extends StatelessWidget {
  const _TarjetaOportunidad({required this.oportunidad, required this.onTap});

  final Oportunidad oportunidad;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final esRegistrada = oportunidad.estado == 'Registrada';

    return Card(
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(18),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CircleAvatar(
                    radius: 25,
                    backgroundColor: esRegistrada
                        ? const Color(0xFFE2F4F3)
                        : const Color(0xFFE5F1FA),
                    child: Icon(
                      oportunidad.propiedad.tipo == 'Casa'
                          ? Icons.house_outlined
                          : Icons.apartment_outlined,
                      color: esRegistrada
                          ? const Color(0xFF25A7A3)
                          : const Color(0xFF0E4775),
                    ),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          oportunidad.propiedad.titulo,
                          style: Theme.of(context).textTheme.titleMedium
                              ?.copyWith(fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 8),
                        Chip(
                          visualDensity: VisualDensity.compact,
                          label: Text(oportunidad.estado),
                          backgroundColor: esRegistrada
                              ? const Color(0xFFE2F4F3)
                              : const Color(0xFFE5F1FA),
                        ),
                      ],
                    ),
                  ),
                  const Icon(Icons.chevron_right),
                ],
              ),
              const SizedBox(height: 16),
              _DatoOportunidad(
                icono: Icons.person_outline,
                etiqueta: 'Captadora',
                valor: oportunidad.captador,
              ),
              const SizedBox(height: 10),
              _DatoOportunidad(
                icono: Icons.people_outline,
                etiqueta: 'Colocadora',
                valor: oportunidad.colocador,
              ),
              const SizedBox(height: 10),
              _DatoOportunidad(
                icono: Icons.monetization_on_outlined,
                etiqueta: 'Comisión',
                valor: formatearPesos(oportunidad.comisionTotal),
                destacar: true,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _DatoOportunidad extends StatelessWidget {
  const _DatoOportunidad({
    required this.icono,
    required this.etiqueta,
    required this.valor,
    this.destacar = false,
  });

  final IconData icono;
  final String etiqueta;
  final String valor;
  final bool destacar;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icono, size: 22, color: const Color(0xFF5D6670)),
        const SizedBox(width: 10),
        Text('$etiqueta: ', style: const TextStyle(color: Color(0xFF5D6670))),
        Expanded(
          child: Text(
            valor,
            style: TextStyle(
              color: destacar ? const Color(0xFF0E4775) : null,
              fontWeight: destacar ? FontWeight.bold : FontWeight.normal,
            ),
          ),
        ),
      ],
    );
  }
}
