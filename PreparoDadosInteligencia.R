library(shiny)
library(ggplot2)
library(shinydashboard)
library(prophet)
library(htmltools)
library(readr)
library(dplyr)
library(tidyr)

options(warn = -1)
options(scipen = 999999)

DADOS_RAMOS <- read_delim("NOMES_RAMOS.CSV", 
                          delim = ",", escape_double = FALSE, 
                        trim_ws = TRUE)

DADOS_RAMOS$coramo <- as.numeric(DADOS_RAMOS$coramo)

lista_ramos <- data.frame(table(DADOS_RAMOS$nome_ramo))
lista_ramos <- as.factor(lista_ramos$Var1[lista_ramos$Freq != ""])

lista_UF <- as.factor(c("AC", "AL", "AM", "BA", "CE",
                      "DF", "ES", "GO", "MA", "MG", 
                      "MS", "MT", "PA", "PB", "PE",
                      "PI", "PR", "RJ", "RN", "RO",
                      "RR","RS", "SC", "SE", "SP", 
                      "TO"))

