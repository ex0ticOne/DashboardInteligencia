

#Prepara os dados
source('PreparoDadosInteligencia.R')

#UI
  estilo <- tags$head(tags$style(HTML(".shiny-output-error-validation {color: black;font-size: 30px; text-align: center; font-weight: bold;}")))

  cabecalho <- dashboardHeader(title = "Dashboard de Inteligência em Sinistros", titleWidth = "500")

  lateral <- dashboardSidebar(
    sidebarMenu(menuItem("Consumo de Tickets", 
                  uiOutput("selecao_corretora"),
                  menuSubItem("Por Corretora", tabName = "PROJECAO_CONSUMO_CORRETORAS"), startExpanded = TRUE),
                menuItem("Sinistralidade",
                  uiOutput("selecao_ramo"),
                  menuSubItem("Nacional", tabName = "PROJECOES_NACIONAL"),
                  uiOutput("selecao_UF_sinistralidade"),
                  menuSubItem("Por UF", tabName = "PROJECOES_UF"), startExpanded = FALSE),
                menuItem("Abertura de Corretoras", 
                        uiOutput("selecao_UF_corretoras"),
                        menuSubItem("Por UF", tabName = "ABERTURA_CORRETORAS_UF"), startExpanded = FALSE),
                menuItem("Acionamento de Seguro Auto",
                  uiOutput("selecao_cobertura"),
                  uiOutput("selecao_UF_seguroauto"),
                  menuSubItem("Por UF", tabName = "ACIONAMENTO_SEGURO_AUTO_UF"), 
                  uiOutput("selecao_regiaotarifaria"),
                  menuSubItem("Por Região de tarifação", tabName = "ACIONAMENTO_SEGURO_AUTO_REGIAO"), startExpanded = FALSE),
                menuItem("Predição de Inadimplentes", 
                         menuSubItem("Clientes atuais", tabName = "SCORE_INADIMPLENTES_INTERNO"),
                         menuSubItem("No mercado", tabName = "SCORE_INADIMPLENTES_EXTERNO"), startExpanded = FALSE),
                menuItem("Sentimento do Segurado", 
                         menuSubItem("Resultados em lista", tabName = "DADOS_COMENTARIOS_CLASSIFICADOS"))))

  corpo <- dashboardBody(estilo,
            tabItems(
              tabItem(tabName = "PROJECAO_CONSUMO_CORRETORAS",
                      fluidRow(htmlOutput("PLOT_CONSUMO_CORRETORAS"))),
              tabItem(tabName = "PROJECOES_NACIONAL",
                      fluidRow(htmlOutput("PLOT_PROJECAO_NACIONAL"),
                      tableOutput("DADOS_PROJECAO_NACIONAL"))),
              tabItem(tabName = "PROJECOES_UF", 
                      fluidRow(htmlOutput("PLOT_PROJECAO_UF"),
                      tableOutput("DADOS_PROJECAO_UF"))),
              tabItem(tabName = "ABERTURA_CORRETORAS_UF", 
                      htmlOutput("PLOT_ABERTURA_CORRETORAS_UF")),
              tabItem(tabName = "ACIONAMENTO_SEGURO_AUTO_UF", 
                      htmlOutput("PLOT_ACIONAMENTO_SEGURO_AUTO_UF")),
              tabItem(tabName = "ACIONAMENTO_SEGURO_AUTO_REGIAO", 
                      htmlOutput("PLOT_ACIONAMENTO_SEGURO_AUTO_REGIAO")),
              tabItem(tabName = "SCORE_INADIMPLENTES_INTERNO",
                      box(dataTableOutput("DADOS_INADIMPLENTES_INTERNO"),
                          title = "Quem são os possíveis inadimplentes dentro da Regula Sinistros?", 
                          solidHeader = TRUE, 
                          width = "100%")),
              tabItem(tabName = "SCORE_INADIMPLENTES_EXTERNO",
                      box(dataTableOutput("DADOS_INADIMPLENTES_EXTERNO"), 
                          title = "Quem são os possíveis inadimplentes no mercado dos corretores?", 
                          solidHeader = TRUE,
                          width = "100%")),
              tabItem(tabName = "DADOS_COMENTARIOS_CLASSIFICADOS",
                      box(dataTableOutput("DADOS_COMENTARIOS_CLASSIFICADOS"), 
                          title = "Qual o sentimento do segurado atendido pela Regula Sinistros?", 
                          solidHeader = TRUE, 
                          width = "100%"))
              )
            ) 
        

ui <- dashboardPage(cabecalho, lateral, corpo, skin = "purple")

server <- function(input, output) {

  output$selecao_ramo <- renderUI(selectInput("selecao_ramo", label = "Selecione o ramo", choices = lista_ramos, selected = "Automóvel - Casco"))
  
  output$selecao_UF_sinistralidade <- renderUI(selectInput("selecao_UF_sinistralidade", label = "Selecione a UF", choices = lista_UF))
  
  output$selecao_UF_seguroauto <- renderUI(selectInput("selecao_UF_seguroauto", label = "Selecione a UF", choices = lista_UF))
  
  output$selecao_UF_corretoras <- renderUI(selectInput("selecao_UF_corretoras", label = "Selecione a UF", choices = lista_UF))
  
  output$selecao_regiaotarifaria <- renderUI(selectInput("selecao_regiaotarifaria", label = "Selecione a Região", choices = lista_regioes))
  
  output$selecao_cobertura <- renderUI(selectInput("selecao_cobertura", label = "Selecione a Cobertura", choices = c("APP", "CASCO", "RCDM", "RCDP")))
  
  output$selecao_corretora <- renderUI(selectInput("selecao_corretora", label = "Selecione a Corretora", choices = lista_corretoras))
  
  output$PLOT_PROJECAO_NACIONAL <- renderUI(tags$iframe(seamless = "seamless", 
                                                        src = paste0("PROJECOES_SINISTRALIDADE/RESULTADOS_NACIONAL/Projeção de Sinistralidade - ", input$selecao_ramo, " - Nacional.html"), 
                                                        width = "100%", 
                                                        height = "600"))
  
  
  output$PLOT_PROJECAO_UF <- renderUI(tags$iframe(seamless = "seamless", 
                                          src = paste0("PROJECOES_SINISTRALIDADE/RESULTADOS_UF/Projeção de Sinistralidade - ", input$selecao_ramo, " - ", input$selecao_UF_sinistralidade, ".html"), 
                                          width = "100%", 
                                          height = "600"))
  
  output$PLOT_ABERTURA_CORRETORAS_UF <- renderUI(tags$iframe(seamless = "seamless", 
                                                  src = paste0("ABERTURA_CORRETORAS/Projeção de Abertura de Corretoras - ", input$selecao_UF_corretoras, ".html"), 
                                                  width = "100%", 
                                                  height = "600"))
  
  output$PLOT_ACIONAMENTO_SEGURO_AUTO_UF <- renderUI(tags$iframe(seamless = "seamless", 
                                                  src = paste0("ACIONAMENTO_AUTO/UF/", input$selecao_cobertura, "/Projeção de Quantidade de Sinistros Seguro Auto - ", input$selecao_UF_seguroauto, " - ", input$selecao_cobertura, ".html"), 
                                                  width = "100%", 
                                                  height = "600"))
  
  output$PLOT_ACIONAMENTO_SEGURO_AUTO_REGIAO <- renderUI(tags$iframe(seamless = "seamless", 
                                                                 src = paste0("ACIONAMENTO_AUTO/REGIAO/", input$selecao_cobertura, "/Projeção de Quantidade de Sinistros Seguro Auto - ", input$selecao_regiaotarifaria, " - ", input$selecao_cobertura, ".html"), 
                                                                 width = "100%", 
                                                                 height = "600"))
  
  output$PLOT_CONSUMO_CORRETORAS <- renderUI(tags$iframe(seamless = "seamless", 
                                                         src = paste0("CONSUMO_CORRETORAS/Projeção de Uso de Tickets - ", input$selecao_corretora, " - Mensal" , ".html"), 
                                                         width = "100%", 
                                                         height = "600"))
  
  output$DADOS_COMENTARIOS_CLASSIFICADOS <- renderDataTable(COMENTARIOS_CLASSIFICADOS)
  
  output$DADOS_INADIMPLENTES_INTERNO <- renderDataTable(TOP10_INADIMPLENTES_CLIENTES)
  
  output$DADOS_INADIMPLENTES_EXTERNO <- renderDataTable(POSSIVEIS_INADIMPLENTES_MERCADO)
    
  }

# Run the application 
shinyApp(ui = ui, server = server)
