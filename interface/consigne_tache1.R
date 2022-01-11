consigne_1 <- div(id = "consigne_1",
                  br(),
                  br(),
                  fluidRow(column(8,
                                  includeMarkdown("texte/consigne_tache1.Rmd"),
                                  offset = 2)),
                  fluidRow(column(2, 
                                  actionButton("compris_1",
                                               "Je suis prêt!",
                                               onclick = "shinyjs.toggleFullScreen();"),
                                  offset = 5)
                  ),
                  hidden(div(
                      id = "cons_1_waiting",
                      span("Merci d'attendre les autres participants", 
                           style = "color:green")
                    ))
                  )