#  Sistema de Análise Meteorológica (Lince Tech Academy)

Este projeto consiste em uma aplicação de linha de comando (CLI) desenvolvida em **Dart** para processamento, análise e exportação de dados climáticos. O sistema foi desenhado para auxiliar na compilação de relatórios comparativos entre os estados de São Paulo (SP) e Santa Catarina (SC), processando volumes de dados de sensores meteorológicos.

##  Funcionalidades Principais

* **Processamento de Dados:** Leitura assíncrona de arquivos `.csv` organizados por UF, ano e mês.
* **Análise Estatística:** Cálculo de médias, valores máximos, mínimos e moda estatística (direção do vento).
* **Conversão de Unidades:** Suporte nativo para conversões complexas:
    * **Temperatura:** Celsius, Fahrenheit e Kelvin.
    * **Vento:** m/s, km/h e mph.
* **Interface Interativa:** Menu intuitivo com feedback visual via cores no terminal (utilizando `yaansi`).
* **Exportação de Relatórios:** Opção de salvar análises consolidadas em arquivos `.txt` (com limpeza automática de códigos ANSI).

##  Tecnologias e Conceitos Aplicados

* **Linguagem:** Dart (foco em *Clean Code* e tipagem forte).
* **Arquitetura (MVC):** Utilizada para garantir o **baixo acoplamento**. Ao separar a lógica de negócio (Model) da camada de exibição (View), permiti que o sistema fosse modular e facilmente testável, independentemente de onde ou como os dados são apresentados.
* **Assincronismo:** Uso de `Future` e `async/await` para operações de I/O (Entrada/Saída) não bloqueantes. Escolhi esta abordagem para evitar que o programa "trave" enquanto aguarda a leitura de grandes volumes de dados no disco rígido.
* **Manipulação de Dados:** Utilização de `Map` hierárquico. Essa estrutura foi escolhida para otimizar o tempo de busca; com ela, não é necessário reprocessar todos os arquivos a cada consulta, garantindo performance em tempo real.
* **Tratamento de Erros:** Implementação de `try/catch` em camadas críticas. O objetivo foi oferecer uma experiência de uso resiliente, onde falhas em arquivos individuais não interrompem a aplicação.

##  Estrutura do Projeto

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
 ## Jornada de Desenvolvimento
O maior desafio deste projeto foi lidar com a variedade dos dados de entrada. Implementei um mapeador dinâmico de cabeçalhos, tornando o sistema capaz de identificar colunas automaticamente, o que evita erros humanos caso o formato do CSV mude levemente.

Além disso, a escolha por StringBuffer na construção dos relatórios foi para evitar a alocação excessiva de memória durante a concatenação de strings(pensando em um futuro escalonamento), mantendo o consumo de recursos otimizado mesmo com relatórios mais extensos. A organização em camadas (Model-View-Controller) para que, ao evoluir a aplicação (como adicionar uma nova métrica), eu pudesse alterar apenas o Model correspondente, sem impacto na interface ou no Controller.

Tive uma dificuldade especial em relação ao relatório de ventos devido ao método de arredondamento escolhido inicialmente, dessa forma precisei fazer algumas refatorações para corrigir esse tipo de problema relacionado aos dados obtidos em CSV. Por conta disso o modelo MVC se mostrou bastante útil pra debug e principalmente para posteriomente corrigir esses bugs.

Desenvolvido como desafio final para o Lince Tech Academy.