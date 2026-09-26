class Propiedad {
  const Propiedad({
    required this.titulo,
    required this.ciudad,
    required this.sector,
    required this.tipo,
    required this.precio,
    required this.habitaciones,
    required this.banos,
    required this.area,
    required this.descripcion,
    required this.responsable,
  });

  final String titulo;
  final String ciudad;
  final String sector;
  final String tipo;
  final String precio;
  final int habitaciones;
  final int banos;
  final int area;
  final String descripcion;
  final String responsable;
}
