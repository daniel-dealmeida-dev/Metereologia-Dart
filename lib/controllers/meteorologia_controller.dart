import 'dart:convert';
import 'dart:io';
import 'package:atividade_final_dart/models/registro_climatico.dart';
import 'package:atividade_final_dart/models/metricas_mensais.dart';
import 'package:atividade_final_dart/services/processador_estatico.dart';
import 'package:atividade_final_dart/utils/mensagens.dart';
import 'package:path/path.dart' as p;

class MeteorologiaController {
  final ProcessadorEstatistico processador = ProcessadorEstatistico();

  Future<void> carregarDados() async {
    final pasta = Directory(r'C:\clima\sensores');

    if (!await pasta.exists()) {
      Mensagem.erro('Pasta não encontrada.');
      return;
    }

    // Processamento sequencial de arquivos .csv na pasta informada
    await for (final arquivo in pasta.list()) {
      if (arquivo is! File || !arquivo.path.endsWith('.csv')) continue;

      final nome = p.basename(arquivo.path);

      try {
        // Extração de metadados (UF e ano) a partir da nomenclatura do arquivo
        final partes = nome.replaceAll('.csv', '').split('_');
        final uf = partes[0].toUpperCase();
        final ano = int.parse(partes[1]);

        Mensagem.info('Processando $nome');

        // Configuração de decodificação para suporte a caracteres especiais
        final linhas = arquivo
            .openRead()
            .transform(latin1.decoder)
            .transform(const LineSplitter());

        Map<String, int>? idx;

        await for (final line in linhas) {
          if (line.trim().isEmpty) continue;

          final cols = line.split(',');

          // Definição dos índices das colunas a partir do cabeçalho
          if (idx == null) {
            idx = _mapearCabecalhoSimples(cols);
            continue;
          }

          if (idx.isEmpty) continue;

          try {
            // Conversão de linha CSV para modelo e registro no processador estatístico
            final r = RegistroClimatico.fromDinamico(
              colunas: cols,
              indices: idx,
              uf: uf,
              ano: ano,
            );
            
            processador.registrarDadosNoMes(
              uf: r.uf,
              ano: r.dataHora.year,
              mes: r.dataHora.month,
              temp: r.temperatura,
              umidade: r.umidade,
              velVento: r.velocidadeVento,
              direcaoVento: r.direcaoVento,
              hora: r.dataHora.hour,
            );
          } catch (e) {
            print('ERRO NA LINHA DO CSV: $e');
          }
        }
      } catch (e) {
        Mensagem.erro('Erro em $nome: $e');
      }
    }
  }

  // Identificação dinâmica de índices de colunas para maior flexibilidade na leitura
  Map<String, int> _mapearCabecalhoSimples(List<String> cols) {
    final map = <String, int>{};

    for (int i = 0; i < cols.length; i++) {
      final c = cols[i].toLowerCase().trim();

      if (c.contains('mes') || c.contains('mês')) map['mes'] = i;
      if (c.contains('dia')) map['dia'] = i;
      if (c.contains('hora')) map['hora'] = i;
      if (c.contains('temperatura')) map['temperatura'] = i;
      if (c.contains('umidade')) map['umidade'] = i;
      if (c.contains('velocidade')) map['velocidadevento'] = i;
      if (c.contains('direção') || c.contains('direcao')) {
        map['direcaovento'] = i;
      }
    }

    return map;
  }

  MetricasMensais? consultarRelatorioMensal(String uf, int ano, int mes) {
    return processador.obterMetricas(uf, ano, mes);
  }

  MetricasMensais consultarConsolidadoAnual(String uf, int ano) {
    return processador.calcularConsolidadoAnual(uf, ano);
  }
}