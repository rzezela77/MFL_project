header <- argonDashHeader(
    gradient = TRUE,
    color = "primary",
    separator = TRUE,
    separator_color = "info",
    top_padding = 1,
    bottom_padding = 0,
    # height = 70,
    
    # #options
    # gradient = TRUE, 
    # # color = "default",
    # # color = "primary",
    # color = "warning",
    # # separator = FALSE, 
    # separator = TRUE,
    # separator_color = "secondary",
    # # bottom_padding = 4, 
    # # top_padding = 6, 
    # background_img = NULL,
    # mask = FALSE, 
    # opacity = 8, 
    # # height = 600,
    # top_padding = 2,
    # bottom_padding = 0,
    # # background_img = "coronavirus.jpg",
    # height = 70,
    argonH1("Projecto MFL", display = 1) %>% argonTextColor(color = "white"),
    argonLead(strong("#FiqueEmCasa.")) %>% argonTextColor(color = "white")
    
    # # elements
    # stabilityUi(id = "stability")
)