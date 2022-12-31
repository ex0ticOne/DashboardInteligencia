# Dashboard de Inteligência de Mercado de Seguros

Dashboard feito em Shiny para apresentação de estudo de mercado de seguros, com projeções de sinistralidade por ramo, a nível nacional e por UF, e de abertura de corretoras de seguros por UF (levando-se em consideração a data de abertura expressa nos CNPJs).

A programação do dashboard faz projeções em tempo real com modelos pré-treinados, de acordo com a quantidade de anos selecionada pelo usuário.

As fontes dos dados:

-   Dataset do Sistema de Estatísticas da SUSEP, cujos dados são alimentados pelas companhias de seguro do mercado supervisionado;

-   Dataset com CNPJs de todas as corretoras de seguros a nível Brasil, obtido por meio de extração da base geral de pessoas jurídicas fornecida pelo Ministério da Economia no portal de dados abertos.

Os valores apresentados nas projeções de sinistralidade estão em escala logarítmica, na intenção de suavizar a disparidade dos patamares de valores indenizados entre os ramos de seguro, tornando as comparações mais fáceis de serem realizadas (um procedimento comum em análise de preços de ativos negociados em mercado, ao tratar ativos que são negociados em diferentes patamares de preço).

Pacotes usados:

-   shiny, shinydashboard e shinyWidgets;

-   prophet;

-   readr;

-   dygraphs.

Veja esse dashboard funcionando em <https://ricardo-baptista.shinyapps.io/DashboardInteligenciaV2/>
