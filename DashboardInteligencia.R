

#Prepara os dados
source('PreparoDadosInteligencia.R')

#UI
  estilo <- tags$head(tags$style(HTML(".shiny-output-error-validation {color: black;font-size: 30px; text-align: center; font-weight: bold;}")))

  cabecalho <- dashboardHeader(title = "Dashboard de Inteligência em Sinistros", titleWidth = "500")

  lateral <- dashboardSidebar(
    sidebarMenu(uiOutput("selecao_ramo"), 
                uiOutput("selecao_UF"), 
                menuItem("Projeções de Sinistralidade", 
                  menuSubItem("Nacional", tabName = "PROJECOES_NACIONAL"),
                  menuSubItem("Por UF", tabName = "PROJECOES_UF"), startExpanded = TRUE),
                menuItem("Abertura de Corretoras por UF", tabName = "ABERTURA_CORRETORAS_UF"),
                menuItem("Projeções Acionamento Seguro Auto por UF", tabName = "ACIONAMENTO_SEGURO_AUTO_UF")))

  corpo <- dashboardBody(estilo,
            tabItems( 
              tabItem(tabName = "PROJECOES_NACIONAL",
                      htmlOutput("PLOT_PROJECAO_NACIONAL")),
              tabItem(tabName = "PROJECOES_UF", 
                      htmlOutput("PLOT_PROJECAO_UF")),
              tabItem(tabName = "ABERTURA_CORRETORAS_UF", 
                       htmlOutput("PLOT_ABERTURA_CORRETORAS_UF")),
              tabItem(tabName = "ACIONAMENTO_SEGURO_AUTO_UF", 
                       htmlOutput("PLOT_ACIONAMENTO_SEGURO_AUTO_UF"))
              )
            ) 
        

ui <- dashboardPage(cabecalho, lateral, corpo, skin = "purple")

server <- function(input, output) {

  output$selecao_ramo <- renderUI(selectInput("selecao_ramo", label = "Selecione o ramo", choices = lista_ramos, selected = "Automóvel - Casco"))
  
  output$selecao_UF <- renderUI(selectInput("selecao_UF", label = "Selecione a UF", choices = lista_UF))
  
  output$PLOT_PROJECAO_NACIONAL <- renderUI(tags$iframe(seamless = "seamless", 
                                                        src = paste0("PROJECOES/RESULTADOS_NACIONAL/Projeção de Sinistralidade - ", input$selecao_ramo, " - Nacional.html"), 
                                                        width = "100%", 
                                                        height = "600"))
  
  
  output$PLOT_PROJECAO_UF <- renderUI(tags$iframe(seamless = "seamless", 
                                          src = paste0("PROJECOES/RESULTADOS_UF/Projeção de Sinistralidade - ", input$selecao_ramo, " - ", input$selecao_UF, ".html"), 
                                          width = "100%", 
                                          height = "600"))
  
  output$PLOT_ABERTURA_CORRETORAS_UF <- renderUI(tags$iframe(seamless = "seamless", 
                                                  src = paste0("ABERTURA_CORRETORAS/Projeção de Abertura de Corretoras - ", input$selecao_UF, ".html"), 
                                                  width = "100%", 
                                                  height = "600"))
  
  output$PLOT_ACIONAMENTO_SEGURO_AUTO_UF <- renderUI(tags$iframe(seamless = "seamless", 
                                                  src = paste0("ACIONAMENTO_AUTO/Projeção de Quantidade de Sinistros Seguro Auto - ", input$selecao_UF, " - TOTAL.html"), 
                                                  width = "100%", 
                                                  height = "600"))
  
    
  }

# Run the application 
shinyApp(ui = ui, server = server)
