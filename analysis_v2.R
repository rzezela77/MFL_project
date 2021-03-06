# !diagnostics off

# 1.0 Loading Libraries ---------------------------------------------------

# library(shiny)
# library(argonR)
# library(argonDash)
# 
# library(tidyverse)
# library(shinycssloaders)
# library(shinyWidgets)



#!diagnostics off
library(tidyverse)
library(readxl)

# library(pander)

library(highcharter)

library(DT)



# 1.1 Loading Data --------------------------------------------------------

mfl_data <- read_excel(path = 'data/MFL_v28Abril2020.xlsx', sheet = 'RSP2020')

# mfl_data <- as.data.frame(mfl_data)
# 
# class(mfl_data)
# 
# mfl_data$TIPO_US_GRUPO <- NA

# examine the data
mfl_data %>% glimpse()

mfl_data[is.na(mfl_data$PROVINCIA), ]

# rename the variables

# mfl_tbl <- mfl_data
colnames(mfl_data) <- c('CODIGO', 'PROVINCIA', 'DISTRITO', 'UNIDADE_SANITARIA', 'CLASSIFICACAO', 'NIVEL', 'TIPO_US', 'TIPO', 'MATERNIDADE', 'NUM_CAMAS_MATERNIDADE', 'NUM_CAMAS_INTERNAMENTO', 'TOTAL', 'BS')

mfl_data %>% glimpse()


# mfl_data$TIPO <- factor(
#     x = mfl_data$TIPO,
#     levels = c('HC', 'HG', 'HP', 'HD', 'HR', 'HM', 'HPsi', 'CS', 'PS')
# )

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


grupos_unid_sanitaria_tbl %>% glimpse()

grupos_unid_sanitaria_tbl %>% 
    filter(PROVINCIA == 'ZAMBÉZIA')

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


# # re-order tipo unidade sanitaria
# mfl_data$TIPO_US <- factor(
#     x = mfl_data$TIPO_US,
#     levels = c(
#         'Hospital Central',
#         'Hospital Geral',
#         'Hospital Provincial',
#         'Hospital Distrital',
#         'Hospital Rural',
#         'Hospital Militar',
#         'Hospital Psiquiatrico',
#         'Centro de Saúde Urbano',
#         'Centro de Saúde Rural',
#         'Posto de Saúde'
#     )
# )


# mfl_data$TIPO <- factor(
#     x = mfl_data$TIPO,
#     levels = c('HC', 'HG', 'HP', 'HD', 'HR', 'HM', 'HPsi', 'CS', 'PS')
# )


# summary
mfl_data %>% summary()



# 2.0 Aggregate data ------------------------------------------------------






# grupos_unid_sanitaria_tbl[, -c(1,2)]

# levels(grupos_unid_sanitaria_tbl$PROVINCIA)
# 
# total_unid_sanitaria_tbl <- 
# grupos_unid_sanitaria_tbl %>% 
#     summarise(total_hospital = sum(Hospitais),
#               total_centro_saude = sum(Centros_Saude),
#               total_posto_saude = sum(Postos_Saude),
#               grand_total = sum(Total))
# 
# total_unid_sanitaria_tbl

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


# 4.0 DataTable -----------------------------------------------------------

get_datatable(data = grupos_unid_sanitaria_tbl, provincia = 'Todas')

get_datatable(data = grupos_unid_sanitaria_tbl, provincia = 'NAMPULA')

DT::datatable(
    grupos_unid_sanitaria_tbl,
    filter = "top",
    # # class = "stripe cell-border",
    extensions = "Buttons",
    options = list(
        scrollX = TRUE,
        dom = 'Brtip',
        ordering = FALSE,
        buttons = list(list(
            extend = 'collection',
            buttons = c('csv', 'excel', 'pdf'),
            text = 'Download'
        ))
    )
)



# 5.0 Mapa ----------------------------------------------------------------

mapdata <- get_data_from_map(download_map_data("countries/mz/mz-all"))

mapdata %>% 
    select('woe-name')

# preparing mapdata
df_mapdata <- 
    grupos_unid_sanitaria_tbl %>% 
    group_by(PROVINCIA) %>% 
    mutate(province_name = case_when(
        as.character(PROVINCIA) == 'MAPUTO PROVÍNCIA' ~ 'Maputo',
        as.character(PROVINCIA) == 'MAPUTO CIDADE' ~ 'Maputo',
        as.character(PROVINCIA)  == 'CABO DELGADO' ~ 'Cabo Delgado',
        as.character(PROVINCIA) == 'NIASSA' ~ 'Niassa',
        as.character(PROVINCIA) == 'NAMPULA' ~ 'Nampula',
        as.character(PROVINCIA) == 'ZAMBÉZIA' ~ 'Zambezia',
        as.character(PROVINCIA) == 'TETE' ~ 'Tete',
        as.character(PROVINCIA) == 'MANICA' ~ 'Manica',
        as.character(PROVINCIA) == 'SOFALA' ~ 'Sofala',
        as.character(PROVINCIA) == 'INHAMBANE' ~ 'Inhambane',
        as.character(PROVINCIA) == 'GAZA' ~ 'Gaza',
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


# visualization

hcmap("countries/mz/mz-all", name = "Unidade Sanitária", 
      data = df_mapdata, 
      value = "value",
      joinBy = c('woe-name', 'province_name'), 
      # dataLabels = list(
      #                   # enabled = TRUE, 
      #                   format = '{point.name}'),
      borderColor = "#FAFAFA", borderWidth = 0.1,
      tooltip = list(valueDecimals = 0, valuePrefix = "", valueSuffix = "")) %>% 
    # hc_add_theme(hc_theme_db() ) %>% 
    hc_add_theme(hc_theme_sandsignika() ) %>% 
    # hc_add_theme(hc_theme_flat() ) %>% 
    hc_chart(zoomType = "xy") %>%
    hc_mapNavigation(enabled = TRUE) %>% 
    hc_colorAxis(stops = color_stops(5)) %>% 
    # hc_colorAxis(dataClasses = color_classes(c(0, 50, 100, 500, 1000, 10000))) %>%
    hc_exporting(enabled = TRUE) %>% 
    hc_tooltip(useHTML = TRUE,
               headerFormat = '',
               pointFormat = paste0('<b> {point.name} </b> <br>
                                    Total: <b> {point.value} </b><br>
                                    Hospitais: <b> {point.Hospitais:,0f} </b><br>
                                    Centros de Saude: <b> {point.Centros_Saude:,0f} </b><br>
                                    Postos de Saude: <b> {point.Postos_Saude:,0f} </b><br>') ) %>% 
    hc_title(text = "UNIDADE SANITÁRIA")
                  