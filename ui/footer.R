footer = argonDashFooter(
    copyrights = tagList(
        "by SD Data Analytics.",
        "Built with",
        img(src = "https://www.rstudio.com/wp-content/uploads/2014/04/shiny.png", height = "30"),
        "by",
        img(src = "https://www.rstudio.com/wp-content/uploads/2014/07/RStudio-Logo-Blue-Gray.png", height = "30"),
        "and with", img(src = "love.png", height = "30"),
        "."
    ),
    HTML(
        paste(
            "2020,", 
            a(href = "https://reinaldozezela.netlify.com/", "powered by SD Data Analytics", target = "_blank"),
            img(src = "image/logoTchingue_v4.PNG", height = "40")
        )
    )
)