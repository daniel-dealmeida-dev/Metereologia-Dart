Sistema de Análise Meteorológica (Dart CLI)

Aplicação de linha de comando desenvolvida em Dart para processamento, análise e exportação de dados meteorológicos. O sistema processa arquivos CSV e gera relatórios estatísticos comparando dados climáticos entre estados brasileiros.

Funcionalidades:
  Leitura de arquivos CSV por estado, ano e mês
Cálculo de estatísticas:
Média
Mínimo
Máximo
Moda do vento
Conversão de unidades:
Celsius, Fahrenheit e Kelvin
m/s, km/h e mph
 Interface CLI interativa com feedback visual (yaansi)
 Exportação de relatórios em .txt
 Limpeza automática de caracteres ANSI nos arquivos
Linguagem

Dart

Arquitetura

MVC (Model-View-Controller)
Separação de responsabilidades

Conceitos

Programação assíncrona (async/await, Future)
Estruturas de dados (Map hierárquico)
Manipulação de arquivos (CSV / TXT)
Tratamento de exceções (try/catch)
Otimização com StringBuffer

Arquitetura do Projeto

```text
/
├── bin/
│   └── main.dart           # Ponto de entrada da aplicação
├── lib/
│   ├── controllers/
│   │   └── meteorologia_controller.dart
│   ├── models/
│   │   ├── metricas_mensais.dart
│   │   └── registro_climatico.dart
│   ├── services/
│   │   └── processador_estatico.dart
│   ├── utils/
│   │   ├── helpers.dart
│   │   └── mensagens.dart
│   └── views/
│       └── relatorio_view.dart
├── pubspec.yaml            # Gerenciamento de dependências
└── README.md
```
 Destaques Técnicos
🔹 Parsing dinâmico de CSV com mapeamento automático de colunas
🔹 Processamento eficiente em memória com Map hierárquico
🔹 Arquitetura MVC desacoplada e modular
🔹 Execução assíncrona para leitura de arquivos grandes
🔹 Geração otimizada de relatórios com StringBuffer
🔹 Sistema resiliente com tratamento de erros por camada

Fluxo do Sistema
flowchart TD

A[Leitura CSV] --> B[Parser de Dados]
B --> C[Mapeamento por Estado]
C --> D[Cálculo Estatístico]
D --> E[Geração de Relatório]
E --> F[Exportação TXT]


Melhorias Futuras
📈 Geração de gráficos estatísticos
🗄️ Integração com banco de dados
🌐 Interface web para visualização dos dados
⚡ Otimização para grandes volumes de CSV
🔍 Filtros avançados por região e período
