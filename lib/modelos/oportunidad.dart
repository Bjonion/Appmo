import 'package:appflutter/modelos/propiedad.dart';

class Oportunidad {
  const Oportunidad({
    required this.propiedad,
    required this.captador,
    required this.colocador,
    required this.precioVenta,
    required this.comisionTotal,
    required this.porcentajeCaptador,
    required this.porcentajeColocador,
    required this.estado,
  });

  final Propiedad propiedad;
  final String captador;
  final String colocador;
  final int precioVenta;
  final int comisionTotal;
  final double porcentajeCaptador;
  final double porcentajeColocador;
  final String estado;

  double get valorCaptador => comisionTotal * porcentajeCaptador / 100;

  double get valorColocador => comisionTotal * porcentajeColocador / 100;
}

String formatearPesos(num valor) {
  final digitos = valor.round().toString();
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
