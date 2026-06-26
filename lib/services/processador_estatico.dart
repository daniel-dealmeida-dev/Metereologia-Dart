import 'package:atividade_final_dart/models/metricas_mensais.dart';
import 'package:atividade_final_dart/controllers/meteorologia_controller.dart';

class ProcessadorEstatistico {
  // Estrutura de armazenamento hierárquica: UF -> Ano -> Mês -> MetricasMensais
  final Map<String, Map<int, Map<int, MetricasMensais>>> _dados = {};

  // registra leituras individuais organizando-as pela hierarquia de tempo e localização
  void registrarDadosNoMes({
    required String uf,
    required int ano,
    required int mes,
    required double temp,
    required double umidade,
    required double velVento,
    required double direcaoVento,
    required int hora,
  }) {
    uf = uf.toUpperCase();
    _dados.putIfAbsent(uf, () => {});
    final mapaDoEstado = _dados[uf]!;

    mapaDoEstado.putIfAbsent(ano, () => {});
    final mapaDoAno = mapaDoEstado[ano]!;

    mapaDoAno.putIfAbsent(mes, () => MetricasMensais());
    final metricas = mapaDoAno[mes]!;

    metricas.registrarLeitura(
      temp: temp,
      umidade: umidade,
      velVento: velVento,
      direcaoVento: direcaoVento,
      hora: hora,
    );
  }

  // Retorna as métricas registradas para um período e estado específicos
  MetricasMensais? obterMetricas(String uf, int ano, int mes) {
    return _dados[uf.toUpperCase()]?[ano]?[mes];
  }

  // Agrega todas as métricas mensais de um ano para gerar o relatório consolidado
  MetricasMensais calcularConsolidadoAnual(String uf, int ano) {
    final mapaAno = _dados[uf.toUpperCase()]?[ano];
    final consolidado = MetricasMensais();

    // Inicialização de extremos para garantir a correta comparação durante a iteração
    consolidado.tempMax = double.negativeInfinity;
    consolidado.tempMin = double.infinity;
    consolidado.umiMax = double.negativeInfinity;
    consolidado.umiMin = double.infinity;
    consolidado.velVentoMax = double.negativeInfinity;
    consolidado.velVentoMin = double.infinity;

    if (mapaAno == null || mapaAno.isEmpty) return consolidado;

    // Iteração pelos meses do ano para acumular totais e encontrar valores extremos
    for (final m in mapaAno.values) {
      consolidado.tempSoma += m.tempSoma;
      consolidado.tempQtd += m.tempQtd;
      consolidado.umiSoma += m.umiSoma;
      consolidado.umiQtd += m.umiQtd;
      consolidado.velVentoSoma += m.velVentoSoma;
      consolidado.velVentoQtd += m.velVentoQtd;

      if (m.tempMax > consolidado.tempMax) consolidado.tempMax = m.tempMax;
      if (m.tempMin < consolidado.tempMin) consolidado.tempMin = m.tempMin;
      if (m.umiMax > consolidado.umiMax) consolidado.umiMax = m.umiMax;
      if (m.umiMin < consolidado.umiMin) consolidado.umiMin = m.umiMin;
      if (m.velVentoMax > consolidado.velVentoMax)
        consolidado.velVentoMax = m.velVentoMax;
      if (m.velVentoMin < consolidado.velVentoMin)
        consolidado.velVentoMin = m.velVentoMin;

      // atualização das frequências e médias horárias via atualização de mapas
      m.tempSomaPorHora.forEach((h, v) => consolidado.tempSomaPorHora
          .update(h, (x) => x + v, ifAbsent: () => v));

      m.tempQtdPorHora.forEach((h, v) => consolidado.tempQtdPorHora
          .update(h, (x) => x + v, ifAbsent: () => v));

      m.frequenciaVento.forEach((g, q) => consolidado.frequenciaVento
          .update(g, (x) => x + q, ifAbsent: () => q));
    }
    return consolidado;
  }
}