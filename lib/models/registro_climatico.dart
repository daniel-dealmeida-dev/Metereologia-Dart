class RegistroClimatico {
  final String uf;
  final DateTime dataHora;
  final double temperatura;
  final double umidade;
  final double velocidadeVento;
  final double direcaoVento;

  RegistroClimatico({
    required this.uf,
    required this.dataHora,
    required this.umidade,
    required this.temperatura,
    required this.velocidadeVento,
    required this.direcaoVento,
  });

  /// factory para conversão de linha CSV em objeto de domínio.
  /// Realiza o tratamento de strings e extração de valores baseados no mapa de índices.
  factory RegistroClimatico.fromDinamico({
    required List<String> colunas,
    required Map<String, int> indices,
    required String uf,
    required int ano,
  }) {
    // função utilitária para normalização e conversão de dados numéricos
    double parse(int i) {
      if (i < 0 || i >= colunas.length) return 0.0;

      // Limpeza de caracteres não numéricos e padronização do separador decimal
      final txt = colunas[i]
          .trim()
          .toLowerCase()
          .replaceAll(',', '.')
          .replaceAll(RegExp(r'[^0-9\.\-]'), '');

      return double.tryParse(txt) ?? 0.0;
    }

    // extração e conversão de componentes de data e hora
    int mes = int.parse(colunas[indices['mes']!].trim());
    int dia = int.parse(colunas[indices['dia']!].trim());
    int hora = int.parse(colunas[indices['hora']!].trim());

    return RegistroClimatico(
      uf: uf,
      dataHora: DateTime(ano, mes, dia, hora),
      temperatura: parse(indices['temperatura'] ?? -1),
      umidade: parse(indices['umidade'] ?? -1),
      velocidadeVento: parse(indices['velocidadevento'] ?? -1),
      direcaoVento: parse(indices['direcaovento'] ?? -1),
    );
  }
}