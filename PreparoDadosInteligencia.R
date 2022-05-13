library(shiny)
library(ggplot2)
library(shinydashboard)
library(prophet)
library(readr)
library(dplyr)
library(tidyr)

options(warn = -1)
options(scipen = 999999)

#unzip('BaseCompleta.zip', files = 'SES_UF2.csv')

#DADOS_UF_MES_CIA <- read_delim("SES_UF2.csv", delim = ";", 
                     # escape_double = FALSE, trim_ws = TRUE,  )

DADOS_RAMOS <- read_delim("NOMES_RAMOS.CSV", 
                          delim = ",", escape_double = FALSE, 
                        trim_ws = TRUE)

DADOS_UF_MES_CIA$UF <- toupper(DADOS_UF_MES_CIA$UF)
DADOS_UF_MES_CIA$ramos <- as.numeric(DADOS_UF_MES_CIA$ramos)

DADOS_RAMOS$coramo <- as.numeric(DADOS_RAMOS$coramo)

DADOS_SINISTRO <- DADOS_UF_MES_CIA[, c("coenti", "damesano", "sin_dir", "UF", "ramos")]


SINISTROS_MES_RAMO_UF <- DADOS_SINISTRO %>%
  group_by(damesano, ramos, UF) %>%
  summarise(SinistrosDiretos = sum(sin_dir))

SINISTROS_MES_RAMO_UF <- SINISTROS_MES_RAMO_UF[SINISTROS_MES_RAMO_UF$SinistrosDiretos > 0, ]
SINISTROS_MES_RAMO_UF$SinistrosDiretos <- log10(SINISTROS_MES_RAMO_UF$SinistrosDiretos)

SINISTROS_MES_RAMO_NACIONAL <- DADOS_SINISTRO %>%
  group_by(damesano, ramos) %>%
  summarise(SinistrosDiretos = sum(sin_dir))

SINISTROS_MES_RAMO_NACIONAL <- SINISTROS_MES_RAMO_NACIONAL[SINISTROS_MES_RAMO_NACIONAL$SinistrosDiretos > 0, ]
SINISTROS_MES_RAMO_NACIONAL$SinistrosDiretos <- log10(SINISTROS_MES_RAMO_NACIONAL$SinistrosDiretos)

lista_ramos <- data.frame(table(DADOS_RAMOS$coramo))
lista_ramos <- as.factor(lista_ramos$Var1[lista_ramos$Freq != ""])

lista_UF <- data.frame(table(DADOS_SINISTRO$UF))
lista_UF <- as.factor(lista_UF$Var1[lista_UF$Freq != ""])

lista_periodos <- data.frame(table(DADOS_SINISTRO$damesano))
lista_periodos <- as.factor(lista_periodos$Var1[lista_periodos$Freq != ""])

plot <- SINISTROS_MES_RAMO_UF[SINISTROS_MES_RAMO_UF$ramos == 114 & 
                              SINISTROS_MES_RAMO_UF$UF == 'SP' & 
                              SINISTROS_MES_RAMO_UF$damesano >= 202001 & SINISTROS_MES_RAMO_UF$damesano <= 202112, ] %>% 
  ggplot(aes(x = damesano)) +
  geom_line(aes(y = SinistrosDiretos)) + 
  theme_classic()
