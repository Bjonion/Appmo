import 'package:flutter/material.dart';
import 'package:appflutter/screen/catalogo_pantalla.dart';

class AccesoPantalla extends StatefulWidget {
  const AccesoPantalla({super.key});

  @override
  State<AccesoPantalla> createState() => _AccesoPantallaState();
}

class _AccesoPantallaState extends State<AccesoPantalla> {
  final _formKey = GlobalKey<FormState>();
  final _correoController = TextEditingController();
  final _contrasenaController = TextEditingController();

  final List<String> _roles = const ['Comprador', 'Propietario', 'Agente'];

  String _rolSeleccionado = 'Comprador';
  bool _ocultarContrasena = true;

  @override
  void dispose() {
    _correoController.dispose();
    _contrasenaController.dispose();
    super.dispose();
  }

  void _ingresar() {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    Navigator.push(
      context,
      MaterialPageRoute<void>(
        builder: (context) => CatalogoPantalla(rol: _rolSeleccionado),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 440),
              child: Column(
                children: [
                  const _EncabezadoMarca(),
                  const SizedBox(height: 28),
                  Card(
                    elevation: 3,
                    shadowColor: Colors.black12,
                    child: Padding(
                      padding: const EdgeInsets.all(24),
                      child: Form(
                        key: _formKey,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            TextFormField(
                              controller: _correoController,
                              keyboardType: TextInputType.emailAddress,
                              decoration: const InputDecoration(
                                labelText: 'Correo electrónico',
                                hintText: 'tu@correo.com',
                                prefixIcon: Icon(Icons.email_outlined),
                                border: OutlineInputBorder(),
                              ),
                              validator: (value) {
                                final correo = value?.trim() ?? '';
                                if (correo.isEmpty) {
                                  return 'Ingresa tu correo electrónico';
                                }
                                if (!correo.contains('@') ||
                                    !correo.contains('.')) {
                                  return 'Ingresa un correo válido';
                                }
                                return null;
                              },
                            ),
                            const SizedBox(height: 18),
                            TextFormField(
                              controller: _contrasenaController,
                              obscureText: _ocultarContrasena,
                              decoration: InputDecoration(
                                labelText: 'Contraseña',
                                prefixIcon: const Icon(Icons.lock_outline),
                                border: const OutlineInputBorder(),
                                suffixIcon: IconButton(
                                  tooltip: _ocultarContrasena
                                      ? 'Mostrar contraseña'
                                      : 'Ocultar contraseña',
                                  onPressed: () {
                                    setState(() {
                                      _ocultarContrasena = !_ocultarContrasena;
                                    });
                                  },
                                  icon: Icon(
                                    _ocultarContrasena
                                        ? Icons.visibility_outlined
                                        : Icons.visibility_off_outlined,
                                  ),
                                ),
                              ),
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Ingresa tu contraseña';
                                }
                                if (value.length < 6) {
                                  return 'Usa al menos 6 caracteres';
                                }
                                return null;
                              },
                            ),
                            const SizedBox(height: 18),
                            DropdownButtonFormField<String>(
                              initialValue: _rolSeleccionado,
                              decoration: const InputDecoration(
                                labelText: 'Selecciona tu rol',
                                prefixIcon: Icon(Icons.people_outline),
                                border: OutlineInputBorder(),
                              ),
                              items: _roles
                                  .map(
                                    (rol) => DropdownMenuItem<String>(
                                      value: rol,
                                      child: Text(rol),
                                    ),
                                  )
                                  .toList(),
                              onChanged: (rol) {
                                if (rol != null) {
                                  setState(() {
                                    _rolSeleccionado = rol;
                                  });
                                }
                              },
                            ),
                            const SizedBox(height: 24),
                            SizedBox(
                              height: 52,
                              child: FilledButton(
                                onPressed: _ingresar,
                                child: const Text(
                                  'Ingresar',
                                  style: TextStyle(
                                    fontSize: 17,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(height: 18),
                            Container(
                              padding: const EdgeInsets.all(14),
                              decoration: BoxDecoration(
                                color: const Color(0xFFEAF4FA),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: const Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Icon(
                                    Icons.info_outline,
                                    color: Color(0xFF0E4775),
                                  ),
                                  SizedBox(width: 10),
                                  Expanded(
                                    child: Text(
                                      'Modo demostración: el rol define las '
                                      'opciones disponibles.',
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _EncabezadoMarca extends StatelessWidget {
  const _EncabezadoMarca();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          width: 104,
          height: 104,
          decoration: const BoxDecoration(
            color: Color(0xFFE2F4F3),
            shape: BoxShape.circle,
          ),
          child: const Icon(
            Icons.house_outlined,
            size: 62,
            color: Color(0xFF0E4775),
          ),
        ),
        const SizedBox(height: 14),
        Text(
          'InmoConecta',
          style: Theme.of(context).textTheme.headlineLarge?.copyWith(
            color: const Color(0xFF0E4775),
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 6),
        Text(
          'Encuentra y conecta oportunidades',
          textAlign: TextAlign.center,
          style: Theme.of(context).textTheme.titleMedium
              ?.copyWith(color: const Color(0xFF424B55)),
        ),
      ],
    );
  }
}
