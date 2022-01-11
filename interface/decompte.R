decompte <- div(id = "decompte",
                br(),
                br(),
                br(),
                fluidRow(
                  ## Sidebar
                  column(3,
                         numericInput("reponse",
                                      "Nombre de 1",
                                      value = NA,
                                      min = 0,
                                      max = 9,
                                      step = 1)),
                  ## Main panel
                  column(6,
                         tableOutput("table_compte"),
                         offset = 5)),
                br(),
                br(),
                ## Bouton de validation
                fluidRow(
                  column(2,
                         actionButton("dec_att",
                                      "Je valide ma réponse"),
                         offset = 5)
                ),
                hidden(div(
                    id = "count_waiting",
                    span("Votre réponse a bien été enregistrée",
                         style = "color:green")
                  ))
                )
