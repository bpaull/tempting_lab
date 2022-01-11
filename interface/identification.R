identification <- div(id = "identification",
                      #titlePanel("Authentification"),
                      fluidRow(column(8,
                                      h3("Bonjour, merci de participer à notre expérience. Afin 
                       que tout se déroule bien nous vous invitons à vous 
                       authentifier avec le numéro qui vous a été remis à 
                       l'entrée."),
                                      offset = 2)),
                      fluidRow(column(4,
                                      numericInput("id_sujet",
                                                   "Numéro d'authentification",
                                                   value = NA),
                                      offset = 4)),
                      fluidRow(column(2, 
                                      actionButton("start_ok",
                                                   "Je suis prêt!"),
                                      offset = 5)),
                      hidden(
                        div(
                          id = "login_error",
                          span("Votre numéro d'authentification présente un problème, merci de réessayer. 
             Si le problème persiste, levez la main", 
                               style = "color:red")
                        )
                      ),
                      hidden(
                        div(
                          id = "login_waiting",
                          span("Vous êtes bien enregistré, veuillez attendre les autres participants", 
                               style = "color:green")
                        )))