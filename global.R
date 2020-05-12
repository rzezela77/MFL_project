

# 1.0 Loading Libraries ---------------------------------------------------



library(shiny)
library(argonR)
library(argonDash)

# library(tidyverse)
library(shinycssloaders)
library(shinyWidgets)

library(tidyverse)
library(readxl)

# library(pander)

library(highcharter)

# 1.1 Loading Data --------------------------------------------------------

mfl_data <- read_excel(path = 'data/MFL_v28Abril2020.xlsx', sheet = 'RSP2020')

# mfl_data <- as_data_frame(mfl_data)


# # examine the data
# mfl_data %>% glimpse()
# 
# mfl_data[is.na(mfl_data$PROVINCIA), ]

# rename the variables
# mfl_tbl <- mfl_data
colnames(mfl_data) <- c('CODIGO', 'PROVINCIA', 'DISTRITO', 'UNIDADE_SANITARIA', 'CLASSIFICACAO', 'NIVEL', 'TIPO_US', 'TIPO', 'MATERNIDADE', 'NUM_CAMAS_MATERNIDADE', 'NUM_CAMAS_INTERNAMENTO', 'TOTAL', 'BS')


# # 1.2 convert all character columns to factor: --------------------------
# mfl_data <- mutate_if(mfl_data, is.character, as.factor)


# adicionar mais uma variavel para agrupar os dados por Unidades Sanitarias
mfl_data$TIPO_US_GRUPO <- NA

# mfl_data$TIPO_US_GRUPO[which(mfl_data$TIPO_US %in% 
#                                  c('Hospital Central',
#                                    'Hospital Geral',
#                                    'Hospital Provincial',
#                                    'Hospital Distrital',
#                                    'Hospital Rural',
#                                    'Hospital Militar',
#                                    'Hospital Psiquiatrico'))] <- 'Hospitais'
# 
# mfl_data$TIPO_US_GRUPO[which(mfl_data$TIPO_US %in% c('Centro de Saúde Urbano',
#                                                      'Centro de Saúde Rural'))] <- 'Centros_Saude'
# mfl_data$TIPO_US_GRUPO[which(mfl_data$TIPO_US == 'Posto de Saúde')] <- 'Postos_Saude'


mfl_data$TIPO_US_GRUPO[which(mfl_data$TIPO %in%
                                 c('HC',
                                   'HG',
                                   'HP',
                                   'HD',
                                   'HR',
                                   'HM',
                                   'HPsi'))] <- 'Hospitais'

mfl_data$TIPO_US_GRUPO[which(mfl_data$TIPO == 'CS')] <- 'Centros_Saude'
mfl_data$TIPO_US_GRUPO[which(mfl_data$TIPO == 'PS')] <- 'Postos_Saude'



# # calcular o número de unidades sanitárias por província
# mfl_data[is.na(mfl_data$PROVINCIA), ]

grupos_unid_sanitaria_tbl <- 
    mfl_data %>%
    group_by(PROVINCIA, DISTRITO) %>%
    count(TIPO_US_GRUPO, name = "numero_US") %>%
    pivot_wider(names_from = TIPO_US_GRUPO, values_from = numero_US, values_fill = list(numero_US = 0)) %>% 
    ungroup()

grupos_unid_sanitaria_tbl$Total <- rowSums(grupos_unid_sanitaria_tbl[, -c(1, 2)])



# # re-order Province from north to south
# grupos_unid_sanitaria_tbl$PROVINCIA <- factor(
#     x = grupos_unid_sanitaria_tbl$PROVINCIA,
#     levels = c(
#         'CABO DELGADO',
#         'NIASSA',
#         'NAMPULA',
#         'ZAMBÉZIA',
#         'TETE',
#         'MANICA',
#         'SOFALA',
#         'INHAMBANE',
#         'GAZA',
#         'MAPUTO PROVÍNCIA',
#         'MAPUTO CIDADE'
#     )
# )


# # rename some provinces name: ZAMBÉZIA to ZAMBEZIA and MAPUTO PROVÍNCIA to MAPUTO PROVINCIA
# grupos_unid_sanitaria_tbl$PROVINCIA[which(grupos_unid_sanitaria_tbl$PROVINCIA == 'ZAMBÉZIA')] <- 'ZAMBEZIA'
# grupos_unid_sanitaria_tbl$PROVINCIA[which(grupos_unid_sanitaria_tbl$PROVINCIA == 'MAPUTO PROVÍNCIA')] <- 'MAPUTO PROVINCIA'
# # 
# grupos_unid_sanitaria_tbl$PROVINCIA <- as.factor(grupos_unid_sanitaria_tbl$PROVINCIA)

# # re-order Province from north to south
# mfl_data$PROVINCIA <- factor(
#     x = mfl_data$PROVINCIA,
#     levels = c(
#         'CABO DELGADO',
#         'NIASSA',
#         'NAMPULA',
#         'ZAMBEZIA',
#         'TETE',
#         'MANICA',
#         'SOFALA',
#         'INHAMBANE',
#         'GAZA',
#         'MAPUTO PROVINCIA',
#         'MAPUTO CIDADE'
#     )
# )



