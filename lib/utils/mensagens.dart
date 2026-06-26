import 'package:ansicolor/ansicolor.dart';

/// Classe responsável pela padronização e coloração de mensagens de sistema no terminal.
class Mensagem {
  static final _azul = AnsiPen()..blue();
  static final _amarelo = AnsiPen()..yellow();
  static final _vermelho = AnsiPen()..red();

  /// Exibe mensagens de caráter informativo com coloração azul.
  static void info(String texto) {
    print(_azul('[INFO] $texto'));
  }

  /// Exibe mensagens de aviso ou atenção com coloração amarela.
  static void alerta(String texto) {
    print(_amarelo('[ALERTA] $texto'));
  }

  /// Exibe mensagens de erro crítico com coloração vermelha.
  static void erro(String texto) {
    print(_vermelho('[ERRO] $texto'));
  }
}