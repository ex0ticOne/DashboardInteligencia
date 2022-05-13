

#Prepara os dados
source('PreparoDadosInteligencia.R')

#UI
cabecalho <- dashboardHeader(title = "Dashboard de Inteligência em Sinistros")

  lateral <- dashboardSidebar(
    sidebarMenu(uiOutput("selecao_ramo"), 
                uiOutput("selecao_UF"), 
                uiOutput("selecao_inicio_periodo"), 
                uiOutput("selecao_fim_periodo"),
                menuItem("Nacional por Ramo", tabName = "SINISTROS_BRASIL_RAMO"),
                menuItem("Por UF e Ramo", tabName = "SINISTROS_UF_RAMO")))

  corpo <- dashboardBody(
              tabItem(tabName = "SINISTROS_BRASIL_RAMO", 
                      plotOutput("PLOT_SINISTROS_BRASIL_RAMO")), 
              tabItem(tabName = "SINISTROS_UF_RAMO", 
                      plotOutput("PLOT_SINISTROS_UF_RAMO")) 
        )

ui <- dashboardPage(cabecalho, lateral, corpo, skin = "purple")

server <- function(input, output) {

  output$selecao_ramo <- renderUI(selectInput("selecao_ramo", label = "Selecione o ramo", choices = lista_ramos))
  
  output$selecao_UF <- renderUI(selectInput("selecao_UF", label = "Selecione a UF", choices = lista_UF))
  
  output$selecao_inicio_periodo <- renderUI(selectInput("selecao_inicio_periodo", label = "Início do Período", lista_periodos))

  output$selecao_fim_periodo <- renderUI(selectInput("selecao_fim_periodo", label = "Fim do Período", lista_periodos))
  
  output$PLOT_SINISTROS_BRASIL_RAMO <- renderPlot({ggplot(SINISTROS_MES_RAMO_NACIONAL[SINISTROS_MES_RAMO_NACIONAL$ramos == input$selecao_ramo & 
                                   SINISTROS_MES_RAMO_NACIONAL$damesano >= input$selecao_inicio_periodo & 
                                   SINISTROS_MES_RAMO_NACIONAL$damesano <= input$selecao_fim_periodo, ], 
                                   aes(x = damesano)) +
                                      geom_line(aes(y = SinistrosDiretos)) + 
                                      theme_classic()})
  
    }

# Run the application 
shinyApp(ui = ui, server = server)
