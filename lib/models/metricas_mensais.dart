class MetricasMensais {
  // Acumuladores e limites para cálculos estatísticos de temperatura
  double tempSoma = 0.0;
  int tempQtd = 0;
  double tempMax = double.negativeInfinity;
  double tempMin = double.infinity;

  // Acumuladores e limites para cálculos estatísticos de umidade
  double umiSoma = 0.0;
  int umiQtd = 0;
  double umiMax = double.negativeInfinity;
  double umiMin = double.infinity;

  // Acumuladores e limites para cálculos estatísticos de velocidade do vento
  double velVentoSoma = 0.0;
  int velVentoQtd = 0;
  double velVentoMax = double.negativeInfinity;
  double velVentoMin = double.infinity;

  // Estruturas de dados para agregações específicas (moda e médias horárias)
  final Map<double, double> frequenciaVento = {};
  final Map<int, double> tempSomaPorHora = {};
  final Map<int, int> tempQtdPorHora = {};

  MetricasMensais();

  // Processa uma nova leitura, atualizando somas, contagens e valores extremos
  void registrarLeitura({
    required double temp,
    required double umidade,
    required double velVento,
    required double direcaoVento,
    required int hora,
  }) {
    // Atualização de métricas de temperatura
    tempSoma += temp;
    tempQtd++;
    if (temp > tempMax) tempMax = temp;
    if (temp < tempMin) tempMin = temp;

    // Atualização de métricas de umidade
    umiSoma += umidade;
    umiQtd++;
    if (umidade > umiMax) umiMax = umidade;
    if (umidade < umiMin) umiMin = umidade;

    // Atualização de métricas de vento
    velVentoSoma += velVento;
    velVentoQtd++;
    if (velVento > velVentoMax) velVentoMax = velVento;
    if (velVento < velVentoMin) velVentoMin = velVento;

    // Registro de frequência de direção (arredondado para garantir consistência)
    if (direcaoVento > 0) {
      final double direcaoChave = direcaoVento.roundToDouble();
      frequenciaVento.update(direcaoChave, (qtd) => qtd + 1, ifAbsent: () => 1.0);
    }

    // Registro de temperatura por hora para cálculo de média horária posterior
    tempSomaPorHora.update(hora, (soma) => soma + temp, ifAbsent: () => temp);
    tempQtdPorHora.update(hora, (qtd) => qtd + 1, ifAbsent: () => 1);
  }

  // Métodos de cálculo para médias gerais
  double calcularTempMedia() => tempQtd > 0 ? tempSoma / tempQtd : 0.0;
  double calcularUmiMedia() => umiQtd > 0 ? umiSoma / umiQtd : 0.0;
  double calcularVelVentoMedia() =>
      velVentoQtd > 0 ? velVentoSoma / velVentoQtd : 0.0;

  // Cálculo de média específica para uma determinada hora
  double calcularTempMediaPorHora(int hora) {
    final soma = tempSomaPorHora[hora] ?? 0.0;
    final qtd = tempQtdPorHora[hora] ?? 0;
    return qtd > 0 ? soma / qtd : 0.0;
  }

  // Identificação da direção de vento com maior ocorrência (moda)
  double calcularModaDirecaoVento() {
    double direcaoMaisFrequente = 0.0;
    double maiorOcorrencia = 0.0;

    frequenciaVento.forEach((grau, qtd) {
      if (qtd > maiorOcorrencia) {
        maiorOcorrencia = qtd;
        direcaoMaisFrequente = grau;
      }
    });
    return direcaoMaisFrequente;
  }
}