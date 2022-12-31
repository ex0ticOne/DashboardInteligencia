

#Prepara os dados
source('PreparoDadosInteligencia.R')
source('ProphetPersonalizado.R')

#UI
  estilo <- tags$head(tags$style(HTML(".shiny-output-error-validation {color: black;font-size: 30px; text-align: center; font-weight: bold;}")))

  cabecalho <- dashboardHeader(title = "Dashboard de Inteligência em Mercado de Seguros", 
                               titleWidth = "500")

  lateral <- dashboardSidebar(sidebarMenu(
    uiOutput("selecao_periodo"),
    menuItem("Projeções de Sinistralidade",
             uiOutput("selecao_ramo"),
             menuSubItem("Nacional",
                         tabName = "PROJECOES_NACIONAL"),
             uiOutput("selecao_UF_sinistralidade"),
             menuSubItem("Por UF", 
                         tabName = "PROJECOES_UF"), startExpanded = TRUE),
    menuItem("Projeção de Abertura de Corretoras", 
             uiOutput("selecao_UF_corretoras"),
             menuSubItem("Por UF", 
                         tabName = "ABERTURA_CORRETORAS_UF"), startExpanded = TRUE), 
    width = 300), width = 300)

  corpo <- dashboardBody(estilo,
            tabItems(
              tabItem(tabName = "PROJECOES_NACIONAL",
                      dygraphOutput("PLOT_PROJECAO_NACIONAL", height = 700)),
              tabItem(tabName = "PROJECOES_UF", 
                      dygraphOutput("PLOT_PROJECAO_UF", height = 700)),
              tabItem(tabName = "ABERTURA_CORRETORAS_UF", 
                      dygraphOutput("PLOT_ABERTURA_CORRETORAS_UF", height = 700))))
        

ui <- dashboardPage(cabecalho, lateral, corpo, skin = "purple")

server <- function(input, output) {

  output$selecao_ramo <- renderUI(selectInput("ramo_selecionado_sinistralidade", 
                                              label = "Selecione o Ramo", 
                                              choices = DADOS_RAMOS$nome_ramo))
  
  output$selecao_periodo <- renderUI(noUiSliderInput("periodo_selecionado", 
                                                     label = "Selecione a quantidade de anos para as projeções", 
                                                     min = 1, 
                                                     max = 50, 
                                                     value = 2, 
                                                     step = 1, 
                                                     height = 200, 
                                                     orientation = "vertical",
                                                     direction = "rtl", 
                                                     format = wNumbFormat(decimals = 0)))
  
  output$selecao_UF_sinistralidade <- renderUI(selectInput("UF_selecionada_sinistralidade", 
                                                           label = "Selecione a UF", 
                                                           choices = c("AC", "AL", "AM", "BA", "CE",
                                                                       "DF", "ES", "GO", "MA", "MG", 
                                                                       "MS", "MT", "PA", "PB", "PE",
                                                                       "PI", "PR", "RJ", "RN", "RO",
                                                                       "RR","RS", "SC", "SE", "SP", 
                                                                       "TO"), 
                                                           selected = "SP"))
  
  output$selecao_UF_corretoras <- renderUI(selectInput("UF_selecionada_corretora", 
                                                       label = "Selecione a UF", 
                                                       choices = c("AC", "AL", "AM", "BA", "CE",
                                                                   "DF", "ES", "GO", "MA", "MG", 
                                                                   "MS", "MT", "PA", "PB", "PE",
                                                                   "PI", "PR", "RJ", "RN", "RO",
                                                                   "RR","RS", "SC", "SE", "SP", 
                                                                   "TO"), 
                                                       selected = "SP"))
  
  renderiza_plot_nacional <- reactive({
    
    modelo_sinistralidade <- read_rds(paste0(getwd(), "/modelos_nacional/", 
                                             DADOS_RAMOS$coramo[DADOS_RAMOS$nome_ramo == input$ramo_selecionado_sinistralidade], 
                                             ".rds"))
    
    periodo_futuro <- make_future_dataframe(modelo_sinistralidade, periods = input$periodo_selecionado * 12, freq = "month")
    
    projecao <- predict(modelo_sinistralidade, periodo_futuro)
    
    plot_sinistralidade <- dyplot.prophet(modelo_sinistralidade, projecao, uncertainty = TRUE, 
                                          main = paste0(input$ramo_selecionado_sinistralidade, " -  Nacional"),
                                          xlab = "Linha Temporal",
                                          ylab = "Escala Logarítmica de Sinistralidade")
    
    return(plot_sinistralidade)
    
  })
  
  output$PLOT_PROJECAO_NACIONAL <- renderDygraph(renderiza_plot_nacional())
  
  renderiza_plot_UF <- reactive({
    
    modelo_sinistralidade <- read_rds(paste0(getwd(), "/modelos_uf/", 
                                             DADOS_RAMOS$coramo[DADOS_RAMOS$nome_ramo == input$ramo_selecionado_sinistralidade], 
                                             "-", 
                                             input$UF_selecionada_sinistralidade,
                                             ".rds"))
    
    periodo_futuro <- make_future_dataframe(modelo_sinistralidade, periods = input$periodo_selecionado * 12, freq = "month")
    
    projecao <- predict(modelo_sinistralidade, periodo_futuro)
    
    plot_sinistralidade <- dyplot.prophet(modelo_sinistralidade, projecao, uncertainty = TRUE, 
                                          main = paste0(input$ramo_selecionado_sinistralidade, " - ", input$UF_selecionada_sinistralidade),
                                          xlab = "Linha Temporal",
                                          ylab = "Escala Logarítmica de Sinistralidade")
    
    return(plot_sinistralidade)
    
  })
  
  output$PLOT_PROJECAO_UF <- renderDygraph(renderiza_plot_UF())
  
  renderiza_plot_corretoras <- reactive({
    
    modelo_corretora <- read_rds(paste0(getwd(), "/modelos_corretoras/", 
                                             input$UF_selecionada_corretora,
                                             ".rds"))
    
    periodo_futuro <- make_future_dataframe(modelo_corretora, periods = input$periodo_selecionado * 12, freq = "month")
    
    projecao <- predict(modelo_corretora, periodo_futuro)
    
    plot_corretora <- dyplot.prophet(modelo_corretora, projecao, uncertainty = TRUE, 
                                          main = paste0("Projeção de Abertura de Corretoras - ", input$UF_selecionada_corretora),
                                          xlab = "Linha Temporal",
                                          ylab = "Quantidade de Corretoras")
    
    return(plot_corretora)
    
  })
  
  output$PLOT_ABERTURA_CORRETORAS_UF <- renderDygraph(renderiza_plot_corretoras())
  
  }

# Run the application 
shinyApp(ui = ui, server = server)
