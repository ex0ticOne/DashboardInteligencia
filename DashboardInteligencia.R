

#Prepara os dados
source('PreparoDadosInteligencia.R')

#UI
  estilo <- tags$head(tags$style(HTML(".shiny-output-error-validation {color: black;font-size: 30px; text-align: center; font-weight: bold;}")))

  cabecalho <- dashboardHeader(title = "Dashboard de Inteligência em Sinistros", titleWidth = "500")

  lateral <- dashboardSidebar(
    sidebarMenu(uiOutput("selecao_ramo"), 
                uiOutput("selecao_UF"),
                menuItem("Projeções Brasil", tabName = "PROJECOES_NACIONAL"),
                menuItem("Projeções por UF", tabName = "PROJECOES_UF")))

  corpo <- dashboardBody(estilo,
            tabItems( 
              tabItem(tabName = "PROJECOES_NACIONAL",
                      htmlOutput("PLOT_PROJECAO_NACIONAL")),
              tabItem(tabName = "PROJECOES_UF", 
                      htmlOutput("PLOT_PROJECAO_UF"))) 
        )

ui <- dashboardPage(cabecalho, lateral, corpo, skin = "purple")

server <- function(input, output) {

  output$selecao_ramo <- renderUI(selectInput("selecao_ramo", label = "Selecione o ramo", choices = lista_ramos, selected = "Automóvel - Casco"))
  
  output$selecao_UF <- renderUI(selectInput("selecao_UF", label = "Selecione a UF", choices = lista_UF))
  
  output$PLOT_PROJECAO_NACIONAL <- renderUI(tags$iframe(seamless = "seamless", 
                                                        src = paste0("RESULTADOS_NACIONAL/Projeção de Sinistralidade - ", input$selecao_ramo, " - Nacional.html"), 
                                                        width = "100%", 
                                                        height = "600"))
  
  
  output$PLOT_PROJECAO_UF <- renderUI(tags$iframe(seamless = "seamless", 
                                          src = paste0("RESULTADOS_UF/Projeção de Sinistralidade - ", input$selecao_ramo, " - ", input$selecao_UF, ".html"), 
                                          width = "100%", 
                                          height = "600"))
  
    
  }

# Run the application 
shinyApp(ui = ui, server = server)
