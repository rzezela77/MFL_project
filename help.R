# 1.0 Loading Libraries ---------------------------------------------------

library(tidyverse)
library(readxl)

# library(pander)

library(highcharter)

# 1.1 Loading Data --------------------------------------------------------

mfl_data <- read_excel(path = 'data/MFL_v28Abril2020.xlsx', sheet = 'RSP2020')

# examine the data
mfl_data %>% glimpse()

mfl_data[is.na(mfl_data$PROVINCIA), ]

# rename the variables
colnames(mfl_data) <- c('CODIGO', 'PROVINCIA', 'DISTRITO', 'UNIDADE_SANITARIA', 'CLASSIFICACAO', 'NIVEL', 'TIPO_US', 'TIPO', 'MATERNIDADE', 'NUM_CAMAS_MATERNIDADE', 'NUM_CAMAS_INTERNAMENTO', 'TOTAL', 'BS')

mfl_data %>% glimpse()




# # 1.2 convert all character columns to factor: --------------------------
# mfl_data <- mutate_if(mfl_data, is.character, as.factor)


# rename some provinces name: ZAMBÉZIA to ZAMBEZIA and MAPUTO PROVÍNCIA to MAPUTO PROVINCIA
mfl_data$PROVINCIA[which(mfl_data$PROVINCIA == 'ZAMBÉZIA')] <- 'ZAMBEZIA'
mfl_data$PROVINCIA[which(mfl_data$PROVINCIA == 'MAPUTO PROVÍNCIA')] <- 'MAPUTO PROVINCIA'

# re-order Province from north to south

mfl_data$PROVINCIA <- factor(
    x = mfl_data$PROVINCIA,
    levels = c(
        'CABO DELGADO',
        'NIASSA',
        'NAMPULA',
        'ZAMBEZIA',
        'TETE',
        'MANICA',
        'SOFALA',
        'INHAMBANE',
        'GAZA',
        'MAPUTO PROVINCIA',
        'MAPUTO CIDADE'
    )
)

# re-order tipo unidade sanitaria

mfl_data$TIPO_US <- factor(
    x = mfl_data$TIPO_US,
    levels = c(
        'Hospital Central',
        'Hospital Geral',
        'Hospital Provincial',
        'Hospital Distrital',
        'Hospital Rural',
        'Hospital Militar',
        'Hospital Psiquiatrico',
        'Centro de Saúde Urbano',
        'Centro de Saúde Rural',
        'Posto de Saúde'
    )
)


mfl_data$TIPO <- factor(
    x = mfl_data$TIPO,
    levels = c('HC', 'HG', 'HP', 'HD', 'HR', 'HM', 'HPsi', 'CS', 'PS')
)


# summary

mfl_data %>% summary()



# 2.0 Aggregate data ------------------------------------------------------

# aggr_tipo_US_tbl <- 
#     mfl_data %>%
#     group_by(PROVINCIA) %>%
#     count(TIPO_US, name = "n_US") %>%
#     pivot_wider(names_from = TIPO_US, values_from = n_US, values_fill = list(n_US = 0)) %>% 
#     ungroup() 
# 
# # Podemos adicionar o valor total das unidades sanitárias por provincia.
# aggr_tipo_US_tbl$TOTAL <- rowSums(aggr_tipo_US_tbl[ , -1])
# 
# aggr_tipo_US_tbl

# adicionar mais uma variavel para agrupar os dados por Unidades Sanitarias
mfl_data$TIPO_US_GRUPO <- NA

mfl_data$TIPO_US_GRUPO[which(mfl_data$TIPO_US %in% 
    c('Hospital Central',
    'Hospital Geral',
    'Hospital Provincial',
    'Hospital Distrital',
    'Hospital Rural',
    'Hospital Militar',
    'Hospital Psiquiatrico'))] <- 'Hospitais'

mfl_data$TIPO_US_GRUPO[which(mfl_data$TIPO_US %in% c('Centro de Saúde Urbano',
                                                     'Centro de Saúde Rural'))] <- 'Centros_Saude'
mfl_data$TIPO_US_GRUPO[which(mfl_data$TIPO_US == 'Posto de Saúde')] <- 'Postos_Saude'


# validate the groups
mfl_data[is.na(mfl_data$TIPO_US_GRUPO),]

mfl_data %>% glimpse()

# re-order the TIPO_US_GRUPO
mfl_data$TIPO_US_GRUPO <- factor(
    x = mfl_data$TIPO_US_GRUPO,
    levels = c('Hospitais', 'Centros_Saude', 'Postos_Saude')
)

# calcular o número de unidades sanitárias por província

mfl_data[is.na(mfl_data$PROVINCIA), ]

grupos_unid_sanitaria_tbl <- 
mfl_data %>%
    group_by(PROVINCIA, DISTRITO) %>%
    count(TIPO_US_GRUPO, name = "numero_US") %>%
    pivot_wider(names_from = TIPO_US_GRUPO, values_from = numero_US, values_fill = list(numero_US = 0)) %>% 
    ungroup()

grupos_unid_sanitaria_tbl$Total <- rowSums(grupos_unid_sanitaria_tbl[, -c(1, 2)])

grupos_unid_sanitaria_tbl[is.na(grupos_unid_sanitaria_tbl$PROVINCIA), ]

# grupos_unid_sanitaria_tbl[, -c(1,2)]

levels(grupos_unid_sanitaria_tbl$PROVINCIA)

total_unid_sanitaria_tbl <- 
grupos_unid_sanitaria_tbl %>% 
    summarise(total_hospital = sum(Hospitais),
              total_centro_saude = sum(Centros_Saude),
              total_posto_saude = sum(Postos_Saude),
              grand_total = sum(Total))

total_unid_sanitaria_tbl

# total_unid_sanitaria_tbl <- data.frame(grupos = names(grupos_unid_sanitaria_tbl[ , -1]), Total_grupo = colSums(grupos_unid_sanitaria_tbl[ , -1])) 
# 
# total_unid_sanitaria_tbl <- data.frame(Total_grupo = colSums(grupos_unid_sanitaria_tbl[ , -1])) 
# 
# colnames(total_unid_sanitaria_tbl) <- c('grupos', 'Total_grupo')
# 
# class(total_unid_sanitaria_tbl)


# total_unid_sanitaria_tbl$grupos




# 3.0 Visualization -------------------------------------------------------


# plot for ALL
plot_data <- 
grupos_unid_sanitaria_tbl %>% 
    group_by(PROVINCIA) %>% 
    summarise(total_hospital = sum(Hospitais),
              total_centro_saude = sum(Centros_Saude),
              total_posto_saude = sum(Postos_Saude),
              grand_total = sum(Total))


# plot for Provinces
plot_data <- 
grupos_unid_sanitaria_tbl %>% 
    filter(PROVINCIA == 'NAMPULA') %>% 
    group_by(DISTRITO) %>% 
    summarise(total_hospital = sum(Hospitais),
              total_centro_saude = sum(Centros_Saude),
              total_posto_saude = sum(Postos_Saude),
              grand_total = sum(Total))



# chart All
highchart() %>% 
    hc_chart(type = "column") %>% 
    hc_xAxis(categories = plot_data$PROVINCIA) %>% 
    # hc_xAxis(categories = plot_data$DISTRITO) %>% 
    hc_add_series(data = plot_data$total_hospital, name = "Hospitais", dataLabels = list(enabled = TRUE)) %>% 
    hc_add_series(data = plot_data$total_centro_saude, name = "Centros de Saude", dataLabels = list(enabled = TRUE)) %>% 
    hc_add_series(data = plot_data$total_posto_saude, name = "Postos de Saude", dataLabels = list(enabled = TRUE)) %>% 
    hc_add_series(data = plot_data$grand_total, name = "Grand Total", dataLabels = list(enabled = TRUE)) %>% 
    hc_tooltip(crosshairs = TRUE, shared = TRUE) %>% 
    hc_exporting(enabled = TRUE)

# visualization by district

grupos_unid_sanitaria_tbl %>% glimpse()

grupos_unid_sanitaria_tbl %>% 
    filter(PROVINCIA == 'NAMPULA') %>% 
    group_by(DISTRITO) %>% 
    summarise(total_hospital = sum(Hospitais),
              total_centro_saude = sum(Centros_Saude),
              total_posto_saude = sum(Postos_Saude),
              grand_total = sum(Total))
    

getCountUS(data = grupos_unid_sanitaria_tbl, provincia = 'Todas', tipoUS = 'Hospitais')

getCountUS(data = grupos_unid_sanitaria_tbl, provincia = 'Todas', tipoUS = 'Total')

getCountUS(data = grupos_unid_sanitaria_tbl, provincia = 'NAMPULA', tipoUS = 'Hospitais')

getCountUS(data = grupos_unid_sanitaria_tbl, provincia = 'NAMPULA', tipoUS = 'Centros_Saude')

getCountUS(data = grupos_unid_sanitaria_tbl, provincia = 'NAMPULA', tipoUS = 'Postos_Saude')

# plotting using function

hc_plot_US(data = grupos_unid_sanitaria_tbl, provincia = 'Todas')

hc_plot_US(data = grupos_unid_sanitaria_tbl, provincia = 'NAMPULA')

hc_plot_US(data = grupos_unid_sanitaria_tbl, provincia = 'ZAMBEZIA')
                  