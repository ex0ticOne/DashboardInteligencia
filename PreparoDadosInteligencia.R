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

DADOS_REGIOES <- read_delim("regioes_tarifacao.csv", 
                            delim = ",", escape_double = FALSE, 
                            trim_ws = TRUE)

SCORE_INADIMPLENCIA <- read_delim("www/SCORE_INADIMPLENTES/SCORE_INADIMPLENCIA.csv", 
                            delim = ",", escape_double = FALSE, 
                            trim_ws = TRUE)

NOMES_CORRETORAS <- read_delim("www/CONSUMO_CORRETORAS/nome_corretoras.csv", 
                               delim = ",", escape_double = FALSE, 
                               trim_ws = TRUE)

COMENTARIOS_CLASSIFICADOS <- read_delim("www/CLASSIFICADOR_NPS/comentarios_classificados.csv", 
                                        delim = ",", escape_double = FALSE, 
                                        trim_ws = TRUE)

lista_corretoras <- as.factor(NOMES_CORRETORAS$nome_corretora)

TOP10_INADIMPLENTES_CLIENTES <- SCORE_INADIMPLENCIA %>% 
  filter(cliente_regula == 1) %>%
  top_n(chance_inadimplencia, n = 10) %>%
  arrange(desc(chance_inadimplencia)) %>%
  select(raiz_cnpj, unidade, dv, razao_social, chance_inadimplencia)

POSSIVEIS_INADIMPLENTES_MERCADO <- SCORE_INADIMPLENCIA %>%
  filter(cliente_regula == 0) %>%
  arrange(desc(chance_inadimplencia)) %>%
  select(raiz_cnpj, unidade, dv, razao_social, chance_inadimplencia)

DADOS_RAMOS$coramo <- as.numeric(DADOS_RAMOS$coramo)

lista_ramos <- data.frame(table(DADOS_RAMOS$nome_ramo))
lista_ramos <- as.factor(lista_ramos$Var1[lista_ramos$Freq != ""])

lista_UF <- as.factor(c("AC", "AL", "AM", "BA", "CE",
                      "DF", "ES", "GO", "MA", "MG", 
                      "MS", "MT", "PA", "PB", "PE",
                      "PI", "PR", "RJ", "RN", "RO",
                      "RR","RS", "SC", "SE", "SP", 
                      "TO"))

lista_regioes <- as.factor(DADOS_REGIOES$regiao)

