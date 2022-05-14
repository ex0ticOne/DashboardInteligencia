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

#unzip('BaseCompleta.zip', files = 'SES_UF2.csv')

DADOS_UF_MES_CIA <- read_delim("SES_UF2.csv", delim = ";", 
                    escape_double = FALSE, trim_ws = TRUE)

DADOS_RAMOS <- read_delim("NOMES_RAMOS.CSV", 
                          delim = ",", escape_double = FALSE, 
                        trim_ws = TRUE)

DADOS_UF_MES_CIA$UF <- toupper(DADOS_UF_MES_CIA$UF)
DADOS_UF_MES_CIA$ramos <- as.numeric(DADOS_UF_MES_CIA$ramos)

DADOS_RAMOS$coramo <- as.numeric(DADOS_RAMOS$coramo)

lista_ramos <- data.frame(table(DADOS_RAMOS$nome_ramo))
lista_ramos <- as.factor(lista_ramos$Var1[lista_ramos$Freq != ""])

lista_UF <- data.frame(table(DADOS_UF_MES_CIA$UF))
lista_UF <- as.factor(lista_UF$Var1[lista_UF$Freq != ""])

lista_periodos <- data.frame(table(DADOS_UF_MES_CIA$damesano))
lista_periodos <- as.factor(lista_periodos$Var1[lista_periodos$Freq != ""])

