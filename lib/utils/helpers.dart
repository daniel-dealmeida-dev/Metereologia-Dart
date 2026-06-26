import 'dart:math';
import 'package:yaansi/yaansi.dart' as yaansi; 

class Helpers {
  // Conversões de unidades de medida para diferentes padrões climáticos
  static double celciusParaFahrenheit(double c) => (c * 9 / 5) + 32;
  static double celciusParaKelvin(double c) => c + 273.15;
  static double grausParaRadianos(double g) => g * pi / 180;
  static double msParaKmh(double ms) => ms * 3.6;
  static double msParaMph(double ms) => ms * 2.23694; 

  // Mapeamento numérico para representação textual de meses
  static String obterNomemes(int mes) {
    const meses = {
      1: 'Janeiro', 2: 'Fevereiro', 3: 'Março', 4: 'Abril',
      5: 'Maio', 6: 'Junho', 7: 'Julho', 8: 'Agosto',
      9: 'Setembro', 10: 'Outubro', 11: 'Novembro', 12: 'Dezembro'
    };
    return meses[mes] ?? 'Desconhecido';
  }

  // remoção de sequências de escape ANSI para exportação de arquivos de texto puros
  static String removerCodigoAnsi(String texto) {
    return texto.replaceAll(RegExp(r'\x1B\[[0-9;]*m'), '');
  }

  // Formatação com cores via biblioteca Yaanzi para exibição no terminal

  static String formatarTemperaturaColorida(double c) {
    final f = celciusParaFahrenheit(c);
    final k = celciusParaKelvin(c);

    // Exibição em Celsius (vermelho), Fahrenheit (amarelo) e Kelvin (azul)
    return '${yaansi.red('${c.toStringAsFixed(1)}°C')} / '
        '${yaansi.yellow('${f.toStringAsFixed(1)}°F')} / '
        '${yaansi.blue('${k.toStringAsFixed(1)}K')}';
  }

  static String formatarUmidadeColorida(double valor, String tipo) {
    final txt = valor < 1.0 ? '${valor.toStringAsFixed(4)} kg/kg' : '${valor.toStringAsFixed(1)}%';

    switch (tipo.toLowerCase()) {
      case 'media':
        return yaansi.green(txt);
      case 'maxima':
        return yaansi.red(txt);
      case 'minima':
        return yaansi.blue(txt);
      default:
        return txt;
    }
  }

  static String formatarVelocidadeVento(double ms) {
    final kmh = msParaKmh(ms);
    final mph = msParaMph(ms);
    return yaansi.yellow('${ms.toStringAsFixed(1)} m/s | ${kmh.toStringAsFixed(1)} km/h | ${mph.toStringAsFixed(1)} mph');
  }

  static String formatarVentoColorido(double graus) {
    final rad = grausParaRadianos(graus);
    // Vento representado uniformemente na cor amarela
    return yaansi.yellow('${graus.toStringAsFixed(0)}° / ${rad.toStringAsFixed(2)} rad');
  }
}