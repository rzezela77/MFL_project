

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

library(DT)

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


# 3.0 Mapa ----------------------------------------------------------------

# preparing mapdata
df_mapdata <- 
    grupos_unid_sanitaria_tbl %>% 
    group_by(PROVINCIA) %>% 
    mutate(province_name = case_when(
        as.character(PROVINCIA)  == 'CABO DELGADO' ~ 'Cabo Delgado',
        as.character(PROVINCIA) == 'NIASSA' ~ 'Niassa',
        as.character(PROVINCIA) == 'NAMPULA' ~ 'Nampula',
        as.character(PROVINCIA) == 'ZAMBÉZIA' ~ 'Zambezia',
        as.character(PROVINCIA) == 'TETE' ~ 'Tete',
        as.character(PROVINCIA) == 'MANICA' ~ 'Manica',
        as.character(PROVINCIA) == 'SOFALA' ~ 'Sofala',
        as.character(PROVINCIA) == 'INHAMBANE' ~ 'Inhambane',
        as.character(PROVINCIA) == 'GAZA' ~ 'Gaza',
        as.character(PROVINCIA) == 'MAPUTO PROVÍNCIA' ~ 'Maputo',
        as.character(PROVINCIA) == 'MAPUTO CIDADE' ~ 'Maputo',
        TRUE ~ as.character(PROVINCIA))
    )

df_mapdata <-
    df_mapdata %>%
    select(-DISTRITO) %>% 
    group_by(province_name) %>%
    # select(2:11) %>%
    summarise_if(is.numeric, sum)
# summarise_all(sum)

df_mapdata <- 
    df_mapdata %>% 
    rename(value = Total)


