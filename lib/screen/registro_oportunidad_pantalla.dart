import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:appflutter/modelos/oportunidad.dart';
import 'package:appflutter/modelos/propiedad.dart';

class RegistroOportunidadPantalla extends StatefulWidget {
  const RegistroOportunidadPantalla({
    super.key,
    required this.propiedades,
    this.oportunidad,
  });

  final List<Propiedad> propiedades;
  final Oportunidad? oportunidad;

  @override
  State<RegistroOportunidadPantalla> createState() =>
      _RegistroOportunidadPantallaState();
}

class _RegistroOportunidadPantallaState
    extends State<RegistroOportunidadPantalla> {
  static const _participantes = [
    'Andrés Gómez',
    'Carolina Ruiz',
    'Julián López',
    'Laura Martínez',
  ];

  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _precioVentaController;
  late final TextEditingController _comisionController;
  late final TextEditingController _porcentajeCaptadorController;
  late final TextEditingController _porcentajeColocadorController;

  late Propiedad _propiedadSeleccionada;
  String? _captadorSeleccionado;
  String? _colocadorSeleccionado;
  bool _mostrarResumen = false;
  String? _mensajeCalculo;

  @override
  void initState() {
    super.initState();
    final oportunidad = widget.oportunidad;
    _propiedadSeleccionada = oportunidad?.propiedad ?? widget.propiedades.first;
    _captadorSeleccionado = oportunidad?.captador;
    _colocadorSeleccionado = oportunidad?.colocador;
    _precioVentaController = TextEditingController(
      text: oportunidad?.precioVenta.toString() ?? '',
    );
    _comisionController = TextEditingController(
      text: oportunidad?.comisionTotal.toString() ?? '',
    );
    _porcentajeCaptadorController = TextEditingController(
      text: oportunidad == null
          ? '50'
          : _formatearPorcentaje(oportunidad.porcentajeCaptador),
    );
    _porcentajeColocadorController = TextEditingController(
      text: oportunidad == null
          ? '50'
          : _formatearPorcentaje(oportunidad.porcentajeColocador),
    );
    _mostrarResumen = oportunidad != null;
    if (_mostrarResumen) {
      _mensajeCalculo = 'La distribución suma 100 %';
    }
  }

  @override
  void dispose() {
    _precioVentaController.dispose();
    _comisionController.dispose();
    _porcentajeCaptadorController.dispose();
    _porcentajeColocadorController.dispose();
    super.dispose();
  }

  String _formatearPorcentaje(double valor) {
    if (valor == valor.roundToDouble()) {
      return valor.round().toString();
    }
    return valor.toString();
  }

  String? _validarObligatorio(String? valor) {
    if (valor == null || valor.trim().isEmpty) {
      return 'Campo obligatorio';
    }
    return null;
  }

  String? _validarMonto(String? valor) {
    final obligatorio = _validarObligatorio(valor);
    if (obligatorio != null) {
      return obligatorio;
    }

    final numero = int.tryParse(valor!.trim());
    if (numero == null || numero <= 0) {
      return 'Debe ser mayor que cero';
    }
    return null;
  }

  String? _validarPorcentaje(String? valor) {
    final obligatorio = _validarObligatorio(valor);
    if (obligatorio != null) {
      return obligatorio;
    }

    final numero = double.tryParse(valor!.trim().replaceAll(',', '.'));
    if (numero == null || numero < 0 || numero > 100) {
      return 'Usa un valor entre 0 y 100';
    }
    return null;
  }

  void _ocultarResumen() {
    if (_mostrarResumen || _mensajeCalculo != null) {
      setState(() {
        _mostrarResumen = false;
        _mensajeCalculo = null;
      });
    }
  }

  double get _porcentajeCaptador => double.parse(
    _porcentajeCaptadorController.text.trim().replaceAll(',', '.'),
  );

  double get _porcentajeColocador => double.parse(
    _porcentajeColocadorController.text.trim().replaceAll(',', '.'),
  );

  int get _comisionTotal => int.parse(_comisionController.text.trim());

  bool _validarYCalcular() {
    final formularioValido = _formKey.currentState!.validate();
    if (!formularioValido) {
      setState(() {
        _mostrarResumen = false;
        _mensajeCalculo = 'Completa correctamente los campos obligatorios.';
      });
      return false;
    }

    final precioVenta = int.parse(_precioVentaController.text.trim());
    if (_comisionTotal > precioVenta) {
      setState(() {
        _mostrarResumen = false;
        _mensajeCalculo = 'La comisión no puede superar el precio de venta.';
      });
      return false;
    }

    final suma = _porcentajeCaptador + _porcentajeColocador;
    if ((suma - 100).abs() > 0.001) {
      setState(() {
        _mostrarResumen = false;
        _mensajeCalculo = 'Los porcentajes deben sumar exactamente 100 %.';
      });
      return false;
    }

    setState(() {
      _mostrarResumen = true;
      _mensajeCalculo = 'La distribución suma 100 %';
    });
    return true;
  }

  Oportunidad _crearOportunidad() {
    return Oportunidad(
      propiedad: _propiedadSeleccionada,
      captador: _captadorSeleccionado!,
      colocador: _colocadorSeleccionado!,
      precioVenta: int.parse(_precioVentaController.text.trim()),
      comisionTotal: _comisionTotal,
      porcentajeCaptador: _porcentajeCaptador,
      porcentajeColocador: _porcentajeColocador,
      estado: widget.oportunidad?.estado ?? 'Registrada',
    );
  }

  void _guardarOportunidad() {
    if (!_validarYCalcular()) {
      return;
    }
    Navigator.pop(context, _crearOportunidad());
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
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.fromLTRB(20, 8, 20, 32),
          children: [
            Text(
              'Registrar oportunidad',
              style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                color: const Color(0xFF0E4775),
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 18),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    DropdownButtonFormField<Propiedad>(
                      initialValue: _propiedadSeleccionada,
                      isExpanded: true,
                      decoration: const InputDecoration(
                        labelText: 'Propiedad',
                        prefixIcon: Icon(Icons.home_outlined),
                        border: OutlineInputBorder(),
                      ),
                      items: widget.propiedades
                          .map(
                            (propiedad) => DropdownMenuItem(
                              value: propiedad,
                              child: Text(
                                propiedad.titulo,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          )
                          .toList(),
                      onChanged: (propiedad) {
                        if (propiedad != null) {
                          setState(() => _propiedadSeleccionada = propiedad);
                          _ocultarResumen();
                        }
                      },
                    ),
                    const SizedBox(height: 14),
                    DropdownButtonFormField<String>(
                      initialValue: _captadorSeleccionado,
                      decoration: const InputDecoration(
                        labelText: 'Punta captadora',
                        prefixIcon: Icon(Icons.person_outline),
                        border: OutlineInputBorder(),
                      ),
                      hint: const Text('Selecciona al participante'),
                      items: _participantes
                          .map(
                            (nombre) => DropdownMenuItem(
                              value: nombre,
                              child: Text(nombre),
                            ),
                          )
                          .toList(),
                      onChanged: (nombre) {
                        setState(() => _captadorSeleccionado = nombre);
                        _ocultarResumen();
                      },
                      validator: _validarObligatorio,
                    ),
                    const SizedBox(height: 14),
                    DropdownButtonFormField<String>(
                      initialValue: _colocadorSeleccionado,
                      decoration: const InputDecoration(
                        labelText: 'Punta colocadora',
                        prefixIcon: Icon(Icons.people_outline),
                        border: OutlineInputBorder(),
                      ),
                      hint: const Text('Selecciona al participante'),
                      items: _participantes
                          .map(
                            (nombre) => DropdownMenuItem(
                              value: nombre,
                              child: Text(nombre),
                            ),
                          )
                          .toList(),
                      onChanged: (nombre) {
                        setState(() => _colocadorSeleccionado = nombre);
                        _ocultarResumen();
                      },
                      validator: _validarObligatorio,
                    ),
                    const SizedBox(height: 14),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: _CampoNumerico(
                            controller: _precioVentaController,
                            etiqueta: 'Precio de venta',
                            icono: Icons.attach_money,
                            validator: _validarMonto,
                            onChanged: (_) => _ocultarResumen(),
                          ),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: _CampoNumerico(
                            controller: _comisionController,
                            etiqueta: 'Comisión total',
                            icono: Icons.monetization_on_outlined,
                            validator: _validarMonto,
                            onChanged: (_) => _ocultarResumen(),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 14),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: _CampoNumerico(
                            controller: _porcentajeCaptadorController,
                            etiqueta: 'Captadora (%)',
                            icono: Icons.percent,
                            permiteDecimal: true,
                            validator: _validarPorcentaje,
                            onChanged: (_) => _ocultarResumen(),
                          ),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: _CampoNumerico(
                            controller: _porcentajeColocadorController,
                            etiqueta: 'Colocadora (%)',
                            icono: Icons.percent,
                            permiteDecimal: true,
                            validator: _validarPorcentaje,
                            onChanged: (_) => _ocultarResumen(),
                          ),
                        ),
                      ],
                    ),
                    if (_mensajeCalculo != null) ...[
                      const SizedBox(height: 14),
                      _MensajeCalculo(
                        texto: _mensajeCalculo!,
                        esValido: _mostrarResumen,
                      ),
                    ],
                    const SizedBox(height: 16),
                    SizedBox(
                      width: double.infinity,
                      height: 50,
                      child: FilledButton.icon(
                        onPressed: _validarYCalcular,
                        icon: const Icon(Icons.calculate_outlined),
                        label: const Text('Calcular comisión'),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            if (_mostrarResumen) ...[
              const SizedBox(height: 18),
              _ResumenComision(oportunidad: _crearOportunidad()),
            ],
            const SizedBox(height: 18),
            SizedBox(
              height: 50,
              child: FilledButton.icon(
                onPressed: _guardarOportunidad,
                icon: const Icon(Icons.save_outlined),
                label: const Text('Guardar oportunidad'),
              ),
            ),
            const SizedBox(height: 8),
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancelar'),
            ),
          ],
        ),
      ),
    );
  }
}

class _CampoNumerico extends StatelessWidget {
  const _CampoNumerico({
    required this.controller,
    required this.etiqueta,
    required this.icono,
    required this.validator,
    required this.onChanged,
    this.permiteDecimal = false,
  });

  final TextEditingController controller;
  final String etiqueta;
  final IconData icono;
  final FormFieldValidator<String> validator;
  final ValueChanged<String> onChanged;
  final bool permiteDecimal;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(
        labelText: etiqueta,
        prefixIcon: Icon(icono),
        border: const OutlineInputBorder(),
      ),
      keyboardType: TextInputType.numberWithOptions(decimal: permiteDecimal),
      inputFormatters: [
        if (permiteDecimal)
          FilteringTextInputFormatter.allow(RegExp(r'[0-9.,]'))
        else
          FilteringTextInputFormatter.digitsOnly,
      ],
      validator: validator,
      onChanged: onChanged,
    );
  }
}

class _MensajeCalculo extends StatelessWidget {
  const _MensajeCalculo({required this.texto, required this.esValido});

  final String texto;
  final bool esValido;

  @override
  Widget build(BuildContext context) {
    final color = esValido
        ? const Color(0xFF168F8B)
        : Theme.of(context).colorScheme.error;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        children: [
          Icon(
            esValido ? Icons.check_circle : Icons.error_outline,
            color: color,
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              texto,
              style: TextStyle(color: color, fontWeight: FontWeight.w600),
            ),
          ),
        ],
      ),
    );
  }
}

class _ResumenComision extends StatelessWidget {
  const _ResumenComision({required this.oportunidad});

  final Oportunidad oportunidad;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(18),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const CircleAvatar(
                  backgroundColor: Color(0xFFE2F4F3),
                  child: Icon(Icons.bar_chart, color: Color(0xFF25A7A3)),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    'Resumen de comisión',
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      color: const Color(0xFF0E4775),
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Chip(label: Text(oportunidad.estado)),
              ],
            ),
            const SizedBox(height: 16),
            _ResultadoPunta(
              titulo: 'Punta captadora',
              participante: oportunidad.captador,
              porcentaje: oportunidad.porcentajeCaptador,
              valor: oportunidad.valorCaptador,
            ),
            const Divider(height: 24),
            _ResultadoPunta(
              titulo: 'Punta colocadora',
              participante: oportunidad.colocador,
              porcentaje: oportunidad.porcentajeColocador,
              valor: oportunidad.valorColocador,
            ),
            const SizedBox(height: 16),
            const Row(
              children: [
                Icon(Icons.info_outline, size: 20, color: Color(0xFF5D6670)),
                SizedBox(width: 8),
                Expanded(
                  child: Text(
                    'Cálculo informativo en pesos colombianos',
                    style: TextStyle(color: Color(0xFF5D6670)),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _ResultadoPunta extends StatelessWidget {
  const _ResultadoPunta({
    required this.titulo,
    required this.participante,
    required this.porcentaje,
    required this.valor,
  });

  final String titulo;
  final String participante;
  final double porcentaje;
  final double valor;

  @override
  Widget build(BuildContext context) {
    final porcentajeTexto = porcentaje == porcentaje.roundToDouble()
        ? porcentaje.round().toString()
        : porcentaje.toString();

    return Row(
      children: [
        const Icon(Icons.person_outline, color: Color(0xFF5D6670)),
        const SizedBox(width: 10),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(titulo, style: const TextStyle(color: Color(0xFF5D6670))),
              Text('$participante · $porcentajeTexto %'),
            ],
          ),
        ),
        Text(
          formatearPesos(valor),
          style: const TextStyle(
            color: Color(0xFF0E4775),
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }
}
