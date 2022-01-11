consigne_O <- div(id = "consigne_0",
                  fluidRow(column(8,
                                  includeMarkdown("texte/consigne_general.Rmd"),
                                  offset = 2)),
                  fluidRow(column(2, 
                                  actionButton("compris_0",
                                               "Je suis prêt!"),
                                  offset = 5)
                  ),
                  hidden(div(
                      id = "cons_0_waiting",
                      span("Merci d'attendre les autres participants", 
                           style = "color:green")
                    ))
                  )