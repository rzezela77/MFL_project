#############################################################
### MFL projects
############################################################


# 1.0 Loading Libraries ---------------------------------------------------

library(tidyverse)
library(readxl)

library(pander)

library(highcharter)


# 1.1 Loading Data --------------------------------------------------------

mfl_data <- read_excel(path = 'data/MFL_v28Abril2020.xlsx', sheet = 'RSP2020')

# examine the data
mfl_data %>% glimpse()

mfl_data %>% head()

colnames(mfl_data) <- c('CODIGO', 'PROVINCIA', 'DISTRITO', 'UNIDADE_SANITARIA', 'CLASSIFICACAO', 'NIVEL', 'TIPO_US', 'TIPO', 'MATERNIDADE', 'NUM_CAMAS_MATERNIDADE', 'NUM_CAMAS_INTERNAMENTO', 'TOTAL', 'BS')

#  convert all character columns to factor:
mfl_data <- mutate_if(mfl_data, is.character, as.factor)

# re-order Province from north to south

mfl_data$PROVINCIA <- factor(
    x = mfl_data$PROVINCIA,
    levels = c(
        'CABO DELGADO',
        'NIASSA',
        'NAMPULA',
        'ZAMBÉZIA',
        'TETE',
        'MANICA',
        'SOFALA',
        'INHAMBANE',
        'GAZA',
        'MAPUTO PROVÍNCIA',
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

mfl_data %>% summary()




# 2.0 Agreggate data ------------------------------------------------------


# 2.2 Tipo de Unidade -----------------------------------------------------

mfl_tbl <- 
mfl_data %>%
    group_by(PROVINCIA, DISTRITO, TIPO_US, TIPO, NIVEL) %>%
    summarise(
        TOTAL_CAMAS_MATERNIDADE = sum(NUM_CAMAS_MATERNIDADE),
        TOTAL_CAMAS_INTERNAMENTO = sum(NUM_CAMAS_INTERNAMENTO),
        TOTAL = sum(TOTAL)
    ) %>% 
    ungroup()


mfl_tbl %>% 
    group_by(PROVINCIA) %>%
    summarise(
        TOTAL_CAMAS_MATERNIDADE = sum(TOTAL_CAMAS_MATERNIDADE, na.rm = TRUE),
        TOTAL_CAMAS_INTERNAMENTO = sum(TOTAL_CAMAS_INTERNAMENTO, na.rm = TRUE),
        TOTAL = sum(TOTAL, na.rm = TRUE)
    ) %>% 
    mutate(RACIO = round((TOTAL/sum(TOTAL))*100, 1))


aggr_tipo_US_tbl <- 
mfl_data %>%
    group_by(PROVINCIA) %>%
    count(TIPO_US, name = "n_US") %>%
    pivot_wider(names_from = TIPO_US, values_from = n_US, values_fill = list(n_US = 0)) %>% 
    ungroup() 

# aggr_tipo_US_tbl[ , -2] %>% 
#     group_by(PROVINCIA) %>% 
#     summarise()


aggr_tipo_US_tbl$TOTAL <- rowSums(aggr_tipo_US_tbl[ , -1])

aggr_tipo_US_tbl %>% pander() 
# %>% wrap(c("Hospital Provincial", "Hospital Distrital", "Hospital Rural", "Centro de Saúde Urbano"), "_")

mfl_data_aggr <- 
mfl_data %>%
    group_by(PROVINCIA) %>%
    count(TIPO, name = "n_US") %>%
    pivot_wider(names_from = TIPO, values_from = n_US, values_fill = list(n_US = 0)) %>% 
    ungroup()

mfl_data_aggr$TOTAL <- rowSums(mfl_data_aggr[, -1])

colSums(mfl_data_aggr[ , -1])


mfl_data_aggr

aggregate(
    x = mfl_data_aggr[, -1],
    by = list(mfl_data_aggr$PROVINCIA),
    sum)



mfl_data %>% 
    distinct(TIPO)
          

# 2.2 Classificação -------------------------------------------------------

mfl_data %>% summary


mfl_data %>% 
    group_by(PROVINCIA) %>% 
    count(CLASSIFICACAO, name = "No_Unidade") %>% 
    pivot_wider(names_from = CLASSIFICACAO, values_from = No_Unidade, values_fill = list(No_Unidade = 0))
    
    
    

# 3.0 Mapa ----------------------------------------------------------------

mapdata <- get_data_from_map(download_map_data("countries/mz/mz-all"))

mapdata %>% glimpse()    

mapdata %>% 
    select('woe-name')

df_mapdata <- 
mfl_data_aggr %>% 
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

df_mapdata %>% glimpse()

df_mapdata[ , 2:11]

df_mapdata <-
    df_mapdata %>%
    group_by(province_name) %>%
    # select(2:11) %>%
    summarise_if(is.numeric, sum)
# summarise_all(sum)
   
df_mapdata <- 
df_mapdata %>% 
    rename(value = TOTAL)

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
                                    Hospital Provincial: <b> {point.HP:,0f} </b><br>
                                    Hospital Distrital: <b> {point.HD:,0f} </b><br>
                                    Centro de Saúde: <b> {point.CS:,0f} </b><br>') ) %>% 
    hc_title(text = "UNIDADE SANITÁRIA")
