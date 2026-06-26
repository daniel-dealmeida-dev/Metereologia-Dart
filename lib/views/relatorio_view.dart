import 'dart:io';
import 'package:atividade_final_dart/controllers/meteorologia_controller.dart';
import 'package:atividade_final_dart/models/metricas_mensais.dart';
import 'package:atividade_final_dart/utils/helpers.dart';
import 'package:atividade_final_dart/utils/mensagens.dart';

// Classe responsável pela interação com o usuário via terminal e exibição dos relatórios.
class MeteorologiaView {
  final MeteorologiaController _controller = MeteorologiaController();

  // definições de escopo para a geração dos relatórios
  final List<String> _estados = ['SP', 'SC'];
  final int _anoAlvo = 2024;

  /// inicia o ciclo de execução do sistema, carregando dados e mantendo o menu ativo.
  Future<void> iniciar() async {
    Mensagem.info('Carregando base de dados climáticos...');
    await _controller.carregarDados();

    while (true) {
      print('\nOLÁ, LEANDRO. QUE RELATÓRIO VOCÊ PRECISA?');
      print('1 - TEMPERATURA');
      print('2 - UMIDADE');
      print('3 - DIREÇÃO DO VENTO');
      print('0 - SAIR DO SISTEMA');
      stdout.write('DIGITE O NÚMERO DA OPÇÃO DESEJADA: ');

      final opcao = stdin.readLineSync()?.trim() ?? '';

      if (opcao == '0') {
        print('\nEncerrando o programa. Até logo!');
        break;
      }

      switch (opcao) {
        case '1':
          _gerarRelatorioTemperatura();
          break;
        case '2':
          _gerarRelatorioUmidade();
          break;
        case '3':
          _gerarRelatorioVento();
          break;
        default:
          Mensagem.erro('Opção inválida! Digite um número correspondente ao menu.');
      }
    }
  }

  // Processa e exibe as métricas estatísticas de temperatura.
  void _gerarRelatorioTemperatura() {
    final buffer = StringBuffer();
    buffer.writeln('\n-- RELATÓRIO DE TEMPERATURA --');

    for (var uf in _estados) {
      buffer.writeln('\n--------------------------------');
      buffer.writeln('ESTADO: $uf | ANO: $_anoAlvo');
      buffer.writeln('-------------------------------');

      for (int mes = 1; mes <= 12; mes++) {
        final MetricasMensais? metricas = _controller.consultarRelatorioMensal(uf, _anoAlvo, mes);

        if (metricas == null || metricas.tempQtd == 0) continue;

        final nomeMes = Helpers.obterNomemes(mes);

        buffer.writeln('   Mês: $nomeMes');
        buffer.writeln('     Média:  ${Helpers.formatarTemperaturaColorida(metricas.calcularTempMedia())}');
        buffer.writeln('     Máxima: ${Helpers.formatarTemperaturaColorida(metricas.tempMax)}');
        buffer.writeln('     Mínima: ${Helpers.formatarTemperaturaColorida(metricas.tempMin)}');
      }

      final MetricasMensais anual = _controller.consultarConsolidadoAnual(uf, _anoAlvo);
      if (anual.tempQtd > 0) {
        buffer.writeln('\n   >> CONSOLIDADO ANUAL ($uf):');
        buffer.writeln('     Média Geral:  ${Helpers.formatarTemperaturaColorida(anual.calcularTempMedia())}');
        buffer.writeln('     Máxima Geral: ${Helpers.formatarTemperaturaColorida(anual.tempMax)}');
        buffer.writeln('     Mínima Geral: ${Helpers.formatarTemperaturaColorida(anual.tempMin)}');

        buffer.writeln('\n     MÉDIA POR HORÁRIO NO ANO ($uf):');
        for (int h = 0; h < 24; h++) {
          if ((anual.tempQtdPorHora[h] ?? 0) > 0) {
            final medHora = anual.calcularTempMediaPorHora(h);
            buffer.writeln('       ${h.toString().padLeft(2, '0')}h: ${Helpers.formatarTemperaturaColorida(medHora)}');
          }
        }
      }
    }

    print(buffer.toString());
    _verificarSalvarArquivo(buffer.toString(), 'CLIMA');
  }

  // Processa e exibe as métricas estatísticas de umidade.
  void _gerarRelatorioUmidade() {
    final buffer = StringBuffer();
    buffer.writeln('\n-- RELATÓRIO DE UMIDADE --');

    for (var uf in _estados) {
      buffer.writeln('\n-----------------------------------');
      buffer.writeln('ESTADO: $uf | ANO: $_anoAlvo');
      buffer.writeln('----------------------------------');

      for (int mes = 1; mes <= 12; mes++) {
        final MetricasMensais? metricas = _controller.consultarRelatorioMensal(uf, _anoAlvo, mes);

        if (metricas == null || metricas.umiQtd == 0) continue;

        final nomeMes = Helpers.obterNomemes(mes);

        buffer.writeln('   Mês: $nomeMes');
        buffer.writeln('Média:  ${Helpers.formatarUmidadeColorida(metricas.calcularUmiMedia(), 'media')}');
        buffer.writeln('Máxima: ${Helpers.formatarUmidadeColorida(metricas.umiMax, 'maxima')}');
        buffer.writeln('Mínima: ${Helpers.formatarUmidadeColorida(metricas.umiMin, 'minima')}');
      }

      final MetricasMensais anual = _controller.consultarConsolidadoAnual(uf, _anoAlvo);
      if (anual.umiQtd > 0) {
        buffer.writeln('\n CONSOLIDADO ANUAL ($uf):');
        buffer.writeln('     Média Geral:  ${Helpers.formatarUmidadeColorida(anual.calcularUmiMedia(), 'media')}');
        buffer.writeln('     Máxima Geral: ${Helpers.formatarUmidadeColorida(anual.umiMax, 'maxima')}');
        buffer.writeln('     Mínima Geral: ${Helpers.formatarUmidadeColorida(anual.umiMin, 'minima')}');
      }
    }

    print(buffer.toString());
    _verificarSalvarArquivo(buffer.toString(), 'UMIDADE');
  }


  void _gerarRelatorioVento() {
    final buffer = StringBuffer();
    buffer.writeln('\n-- RELATÓRIO DE DIREÇÃO DO VENTO --');

    for (var uf in _estados) {
      buffer.writeln('\n------------------------------');
      buffer.writeln('ESTADO: $uf | ANO: $_anoAlvo');
      buffer.writeln('----------------------------');

      for (int mes = 1; mes <= 12; mes++) {
        final MetricasMensais? metricas = _controller.consultarRelatorioMensal(uf, _anoAlvo, mes);

        if (metricas == null || metricas.frequenciaVento.isEmpty) continue;

        final nomeMes = Helpers.obterNomemes(mes);
        final modaGraus = metricas.calcularModaDirecaoVento();

        buffer.writeln('   Mês: $nomeMes -> Predominante: ${Helpers.formatarVentoColorido(modaGraus)}');
      }

      final MetricasMensais anual = _controller.consultarConsolidadoAnual(uf, _anoAlvo);
      if (anual.frequenciaVento.isNotEmpty) {
        final modaAnual = anual.calcularModaDirecaoVento();
        buffer.writeln('\n   >> CONSOLIDADO ANUAL ($uf):');
        buffer.writeln('     Direção de Maior Frequência: ${Helpers.formatarVentoColorido(modaAnual)}');
      }
    }

    print(buffer.toString());
    _verificarSalvarArquivo(buffer.toString(), 'VENTO');
  }

  // Realiza a exportação do conteúdo do buffer para arquivo de texto, removendo códigos ANSI.
  void _verificarSalvarArquivo(String textoRelatorio, String prefixoArquivo) {
    stdout.write('\nDESEJA SALVAR ESTE RELATÓRIO EM ARQUIVO TXT? (S/N): ');
    final resposta = stdin.readLineSync()?.trim().toUpperCase() ?? '';

    if (resposta == 'S') {
      try {
        final agora = DateTime.now();
        final dataStr = '${agora.year}-${agora.month.toString().padLeft(2, '0')}-${agora.day.toString().padLeft(2, '0')}';
        final horaStr = '${agora.hour.toString().padLeft(2, '0')}-${agora.minute.toString().padLeft(2, '0')}';

        final nomeArquivo = '${prefixoArquivo.toUpperCase()}_${dataStr}_$horaStr.txt';
        final textoLimpo = Helpers.removerCodigoAnsi(textoRelatorio);

        final arquivo = File(nomeArquivo);
        arquivo.writeAsStringSync(textoLimpo);

        print('\n\x1B[32mSucesso: Relatório salvo em "$nomeArquivo"!\x1B[0m');
      } catch (e) {
        Mensagem.erro('Erro ao salvar o arquivo: $e');
      }
    }
  }
}
