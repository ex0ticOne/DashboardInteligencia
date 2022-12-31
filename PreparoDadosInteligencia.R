library(shiny)
library(prophet)
library(shinydashboard)
library(shinyWidgets)
library(dygraphs)
library(readr)

options(warn = -1)
options(scipen = 999999)

DADOS_RAMOS <- read_delim("NOMES_RAMOS.CSV", 
                          delim = ",", escape_double = FALSE, 
                        trim_ws = TRUE)

DADOS_RAMOS <- DADOS_RAMOS[DADOS_RAMOS$escolhido == 1, ]

