import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:appflutter/modelos/propiedad.dart';

class FormularioPropiedadPantalla extends StatefulWidget {
  const FormularioPropiedadPantalla({super.key, required this.rol});

  final String rol;

  @override
  State<FormularioPropiedadPantalla> createState() =>
      _FormularioPropiedadPantallaState();
}

class _FormularioPropiedadPantallaState
    extends State<FormularioPropiedadPantalla> {
  final _formKey = GlobalKey<FormState>();
  final _tituloController = TextEditingController();
  final _direccionController = TextEditingController();
  final _precioController = TextEditingController();
  final _descripcionController = TextEditingController();
  final _habitacionesController = TextEditingController();
  final _banosController = TextEditingController();
  final _areaController = TextEditingController();
  final _responsableController = TextEditingController(text: 'Julián');

  String? _tipoSeleccionado;
  String? _ciudadSeleccionada;
  bool _imagenSeleccionada = false;
  bool _mostrarErrorImagen = false;

  @override
  void dispose() {
    _tituloController.dispose();
    _direccionController.dispose();
    _precioController.dispose();
    _descripcionController.dispose();
    _habitacionesController.dispose();
    _banosController.dispose();
    _areaController.dispose();
    _responsableController.dispose();
    super.dispose();
  }

  String? _validarObligatorio(String? valor) {
    if (valor == null || valor.trim().isEmpty) {
      return 'Campo obligatorio';
    }
    return null;
  }

  String? _validarNumeroPositivo(String? valor) {
    final errorObligatorio = _validarObligatorio(valor);
    if (errorObligatorio != null) {
      return errorObligatorio;
    }

    final numero = int.tryParse(valor!.trim());
    if (numero == null || numero <= 0) {
      return 'Ingresa un valor mayor que cero';
    }
    return null;
  }

  String _formatearPrecio(String valor) {
    final digitos = valor.replaceAll(RegExp(r'\D'), '');
    final grupos = <String>[];

    for (var fin = digitos.length; fin > 0; fin -= 3) {
      var inicio = fin - 3;
      if (inicio < 0) {
        inicio = 0;
      }
      grupos.insert(0, digitos.substring(inicio, fin));
    }

    return r'$ ' + grupos.join('.');
  }

  void _seleccionarImagen() {
    setState(() {
      _imagenSeleccionada = true;
      _mostrarErrorImagen = false;
    });
  }

  void _guardarPropiedad() {
    final formularioValido = _formKey.currentState!.validate();

    setState(() {
      _mostrarErrorImagen = !_imagenSeleccionada;
    });

    if (!formularioValido || !_imagenSeleccionada) {
      return;
    }

    final propiedad = Propiedad(
      titulo: _tituloController.text.trim(),
      ciudad: _ciudadSeleccionada!,
      sector: _direccionController.text.trim(),
      tipo: _tipoSeleccionado!,
      precio: _formatearPrecio(_precioController.text),
      habitaciones: int.parse(_habitacionesController.text.trim()),
      banos: int.parse(_banosController.text.trim()),
      area: int.parse(_areaController.text.trim()),
      descripcion: _descripcionController.text.trim(),
      responsable: _responsableController.text.trim(),
    );

    Navigator.pop(context, propiedad);
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
              'Nueva propiedad',
              style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                color: const Color(0xFF0E4775),
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 6),
            Text(
              'Completa la ficha como ${widget.rol.toLowerCase()}.',
              style: const TextStyle(color: Color(0xFF5D6670)),
            ),
            const SizedBox(height: 18),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    TextFormField(
                      controller: _tituloController,
                      decoration: const InputDecoration(
                        labelText: 'Título',
                        hintText: 'Ej. Apartamento moderno en Laureles',
                        prefixIcon: Icon(Icons.description_outlined),
                        border: OutlineInputBorder(),
                      ),
                      textCapitalization: TextCapitalization.sentences,
                      validator: _validarObligatorio,
                    ),
                    const SizedBox(height: 14),
                    DropdownButtonFormField<String>(
                      initialValue: _tipoSeleccionado,
                      decoration: const InputDecoration(
                        labelText: 'Tipo de inmueble',
                        prefixIcon: Icon(Icons.home_outlined),
                        border: OutlineInputBorder(),
                      ),
                      hint: const Text('Selecciona el tipo de inmueble'),
                      items: const ['Apartamento', 'Casa']
                          .map(
                            (tipo) => DropdownMenuItem(
                              value: tipo,
                              child: Text(tipo),
                            ),
                          )
                          .toList(),
                      onChanged: (tipo) {
                        setState(() => _tipoSeleccionado = tipo);
                      },
                      validator: _validarObligatorio,
                    ),
                    const SizedBox(height: 14),
                    DropdownButtonFormField<String>(
                      initialValue: _ciudadSeleccionada,
                      decoration: const InputDecoration(
                        labelText: 'Ciudad',
                        prefixIcon: Icon(Icons.location_on_outlined),
                        border: OutlineInputBorder(),
                      ),
                      hint: const Text('Selecciona la ciudad'),
                      items: const ['Medellín', 'Envigado']
                          .map(
                            (ciudad) => DropdownMenuItem(
                              value: ciudad,
                              child: Text(ciudad),
                            ),
                          )
                          .toList(),
                      onChanged: (ciudad) {
                        setState(() => _ciudadSeleccionada = ciudad);
                      },
                      validator: _validarObligatorio,
                    ),
                    const SizedBox(height: 14),
                    TextFormField(
                      controller: _direccionController,
                      decoration: const InputDecoration(
                        labelText: 'Dirección o sector',
                        hintText: 'Ej. Cra. 70 # 45-32 o Laureles',
                        prefixIcon: Icon(Icons.map_outlined),
                        border: OutlineInputBorder(),
                      ),
                      textCapitalization: TextCapitalization.words,
                      validator: _validarObligatorio,
                    ),
                    const SizedBox(height: 14),
                    TextFormField(
                      controller: _precioController,
                      decoration: const InputDecoration(
                        labelText: 'Precio',
                        hintText: 'Ej. 480000000',
                        prefixIcon: Icon(Icons.attach_money),
                        border: OutlineInputBorder(),
                      ),
                      keyboardType: TextInputType.number,
                      inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                      validator: _validarNumeroPositivo,
                    ),
                    const SizedBox(height: 14),
                    TextFormField(
                      controller: _descripcionController,
                      decoration: const InputDecoration(
                        labelText: 'Descripción',
                        hintText:
                            'Describe las características de la propiedad',
                        prefixIcon: Icon(Icons.notes_outlined),
                        border: OutlineInputBorder(),
                        alignLabelWithHint: true,
                      ),
                      minLines: 3,
                      maxLines: 4,
                      textCapitalization: TextCapitalization.sentences,
                      validator: _validarObligatorio,
                    ),
                    const SizedBox(height: 14),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: _CampoNumero(
                            controller: _habitacionesController,
                            etiqueta: 'Habitaciones',
                            icono: Icons.bed_outlined,
                            validator: _validarNumeroPositivo,
                          ),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: _CampoNumero(
                            controller: _banosController,
                            etiqueta: 'Baños',
                            icono: Icons.bathtub_outlined,
                            validator: _validarNumeroPositivo,
                          ),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: _CampoNumero(
                            controller: _areaController,
                            etiqueta: 'Área (m²)',
                            icono: Icons.square_foot,
                            validator: _validarNumeroPositivo,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 14),
                    TextFormField(
                      controller: _responsableController,
                      decoration: const InputDecoration(
                        labelText: 'Responsable',
                        prefixIcon: Icon(Icons.person_outline),
                        border: OutlineInputBorder(),
                      ),
                      textCapitalization: TextCapitalization.words,
                      validator: _validarObligatorio,
                    ),
                    const SizedBox(height: 16),
                    _SelectorImagen(
                      seleccionada: _imagenSeleccionada,
                      mostrarError: _mostrarErrorImagen,
                      onTap: _seleccionarImagen,
                    ),
                    const SizedBox(height: 18),
                    SizedBox(
                      width: double.infinity,
                      height: 50,
                      child: FilledButton.icon(
                        onPressed: _guardarPropiedad,
                        icon: const Icon(Icons.save_outlined),
                        label: const Text('Guardar propiedad'),
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
            ),
          ],
        ),
      ),
    );
  }
}

class _CampoNumero extends StatelessWidget {
  const _CampoNumero({
    required this.controller,
    required this.etiqueta,
    required this.icono,
    required this.validator,
  });

  final TextEditingController controller;
  final String etiqueta;
  final IconData icono;
  final FormFieldValidator<String> validator;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(
        labelText: etiqueta,
        prefixIcon: Icon(icono),
        border: const OutlineInputBorder(),
      ),
      keyboardType: TextInputType.number,
      inputFormatters: [FilteringTextInputFormatter.digitsOnly],
      validator: validator,
    );
  }
}

class _SelectorImagen extends StatelessWidget {
  const _SelectorImagen({
    required this.seleccionada,
    required this.mostrarError,
    required this.onTap,
  });

  final bool seleccionada;
  final bool mostrarError;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final color = mostrarError
        ? Theme.of(context).colorScheme.error
        : seleccionada
        ? const Color(0xFF25A7A3)
        : const Color(0xFF7A9AB5);

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
        decoration: BoxDecoration(
          color: const Color(0xFFF4F8FB),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: color, width: 1.5),
        ),
        child: Column(
          children: [
            Icon(
              seleccionada
                  ? Icons.check_circle_outline
                  : Icons.add_photo_alternate_outlined,
              size: 38,
              color: color,
            ),
            const SizedBox(height: 8),
            Text(
              seleccionada ? 'Imagen seleccionada' : 'Agregar imagen',
              style: TextStyle(fontWeight: FontWeight.bold, color: color),
            ),
            const SizedBox(height: 4),
            Text(
              mostrarError
                  ? 'Selecciona al menos una imagen'
                  : 'Se requiere al menos una imagen',
              textAlign: TextAlign.center,
              style: TextStyle(color: color),
            ),
          ],
        ),
      ),
    );
  }
}
