choix <- div(id = "choix",
             br(),
             br(),
             br(),
             br(),
             br(),
             fluidRow(
               column( 3,
                       radioButtons(inputId = "choix",
                                    label = "Choix",
                                    choices = c("j'arrête le décompte" = "surf",
                                                "je paye pour ne plus voir cet écran" = "commit",
                                                "je continue" = "continue"),
                                    selected = "surf"),
                       offset = 1),
               column(5,
                      p("1. Arréter la tâche et avoir accès à internet.", br(),
                        "2. Dépenser 0.1€ de votre cagnote pour continuer la tâche sans avoir à rechoisir.", br(),
                        "3. Continuer la tâche et refaire un choix dans 6 minutes.",
                        style="font-size:2em"),
                      offset = 1)
             ),
             fluidRow(column(2,
                             actionButton("cho_att",
                                          "J'ai choisi."),
                             offset = 5)),
             br(),
             fluidRow(column(4,
                             hidden(div(
                               id = "choix_waiting",
                               span("Votre réponse a bien été enregistrée",
                                    style = "color:green")
                             )),
                             offset = 5)),
             br(),
             br(),
             
             
             fluidRow(
               column(4,
                      hidden(div(id = "rappel_payoff",
                                 p("Rappel, le tableau de gain :", style="margin-left: 100px"),
                                 br(),
                                 #includeHTML("texte/rappel_payoff.html") HERE IS THE FUCKING PROBLEM
                                 HTML('<table style="text-align:left;border: 1px solid black;">
                                      <tr style="background-color: #4CAF50; color: white; border: 1px solid black;">
                                      <th style="background-color: #FFFFFF; color: white;">  </th>
                                      <th style="border: 1px solid black;"> < 15</th>
                                      <th style="border: 1px solid black;">[15, 30[</th>
                                      <th style="border: 1px solid black;">30</th>
                                      </tr>
                                      <tr style="border: 1px solid black;">
                                      <td style="background-color: #4CAF50; color: white;"> < 15</td>
                                      <td style="border: 1px solid black;">0.0</td>
                                      <td style="border: 1px solid black;">0.5</td>
                                      <td style="border: 1px solid black;">3.0</td>
                                      </tr>
                                      <tr style="border: 1px solid black;">
                                      <td style="background-color: #4CAF50; color: white;">[15, 30[</td>
                                      <td style="border: 1px solid black;">1.0</td>
                                      <td style="border: 1px solid black;">2.0</td>
                                      <td style="border: 1px solid black;">3.4</td>
                                      </tr>
                                      <tr style="border: 1px solid black;">
                                      <td style="background-color: #4CAF50; color: white;">30</td>
                                      <td style="border: 1px solid black;">3.5</td>
                                      <td style="border: 1px solid black;">3.6</td>
                                      <td style="border: 1px solid black;">4.0</td>
                                      </tr>
                                      </table>')
                                 )),
                      offset = 0),
               column(4,
                      hidden(div(id = "dec_part",
                                 br(),
                                 br(),
                                 p(textOutput("dec_partenaire")),
                                 style = "color:red; font-size:2em")),
                      offset = 1)
                      )
                      )
