payoff_possible <- c(0, 0.1, 0.9, 1, 1.9, 2, 2.9, 3, 3.4, 3.5, 3.6, 3.9, 4)

consigne_3 <- div(id = "consigne_3",
                  fluidRow(column(8,
                                  br(),
                                  br(),
                                  includeMarkdown("texte/consigne_tache3.Rmd"),
                                  offset = 2)),
                  br(),
                  br(),
                  questionnaire("B", 
                                list("Si je choisis d'arrêter les décomptes après 6 minutes et que mon partenaire continue jusqu'au bout, combien d'euros cette tâche va t-elle me rapporter ?",
                                     "Si moi et mon partenaire continuons les décomptes jusqu'à la fin de la tâche, combien cette tâche va t-elle me rapporter ?",
                                     "Si je choisis de payer pour ne plus voir l'écran de choix dès la première fois et que mon partenaire, choisit d'arrêter, combien cette tâche va-elle me rapporter ?",
                                     "Pour que moi et mon partenaire gagnons chacun 2€, à quel choix doit-on tous les deux décider d'arrêter ?"), 
                                list(payoff_possible,
                                     payoff_possible,
                                     payoff_possible,
                                     c(1, 2, 3, 4))),
                  br(),
                  br(),
                  fluidRow(column(2, 
                                  hidden(div( id = "B_ok",
                                              actionButton("compris_3",
                                                           "Je suis prêt!",
                                                           onclick = "shinyjs.toggleFullScreen();"))),
                                  offset = 5
                  )),
                  br(),
                  fluidRow(column(4,
                                  hidden(div(
                                    id = "cons_3_waiting",
                                    span("Merci d'attendre les autres participants", 
                                         style = "color:green"))),
                                  offset = 5))
)