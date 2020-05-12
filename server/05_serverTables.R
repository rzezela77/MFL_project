###########################################################
## serverTables.R
##########################################################

output$tablesUI <- renderUI({
    
    DT::dataTableOutput(outputId = "dataTable_out")
})


output$dataTable_out <- DT::renderDataTable({
    
    dataset <- grupos_unid_sanitaria_tbl
    
    DT::datatable(
        dataset,
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
})