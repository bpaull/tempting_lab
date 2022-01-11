## App pour experience laboratoire tentation et interaction strategique
## Bettega Paul
## 2018_11_16
###################################################################################################
####################################################################################### Common ----
###################################################################################################
## METAPARAMETRE ----
R <- 0.03             # parametre de ralentissement
nb_sujet <- 2       # nombre de sujet
num_session <- paste0("CHANGEME", Sys.time())
c_commit <- 0.1
temps_counting <- 0.25
temps_choix    <- 1
payoff_interac <- matrix(c(0,   1,   3.5, 
                           0.5, 2,   3.6,
                           3,   3.4, 4),
                         ncol = 3)
## Dependance ----
source("Mes_fonctions.R") # ; P 
library(shiny)
library(shinyjs)
source("help.R")
source_dir(dir_path = "interface/", recursive = TRUE) # ; P
log_it <- loggeur(paste0("output/log/", num_session, ".log"))      # ; P

auto_invalide <- reactiveTimer(1000*R)
# paramete ----
source("parametre.R", local = TRUE)
## variable de deroulement expe ----
rv <- reactiveValues()
rv$t_ident <- F
rv$t_comp_0 <- F
rv$t_comp_1 <- F
rv$t_comp_2 <- F
rv$t_comp_3 <- F

## State ----
rv$state <- rep("continue", nb_sujet) 


#==================================================================================================
## Timer  ----
#==================================================================================================
## Lancement du timer et de l'indice de tache
rv$timer <- max(duree)*60+1
observe({
  auto_invalide()
  rv$timer <- isolate(rv$timer) + 1
})


###################################################################################################
## UI ----
ui <- fluidPage(
  useShinyjs(),
  extendShinyjs(script = "MyJS.js", functions = c("toggleFullScreen", "init")),
  
  identification,
  hidden(consigne_O),
  hidden(consigne_1),
  hidden(consigne_2),
  hidden(consigne_3),
  hidden(consigne_4),
  hidden(attente),
  hidden(choix),
  hidden(decompte),
  hidden(web),
  hidden(fin)
)
###################################################################################################
## Server ----
server <- function(input, output) {
srv <- reactiveValues()
srv$tache <- 0
srv$dec_part <- NA
srv$num_choix <- 0
srv$num_count <- 0
srv$table <- genere_compte()

#==================================================================================================
## Variables serveur ----
#==================================================================================================
  id <- NA

## Ajout d'une fonction pour suivre le deroulement
##  ----
indique <- function(commentaire, identifiant = id) {
  textes <- paste0(stringr::str_sub(Sys.time(),12), 
                   "----", identifiant, "----", rv$timer,
                   "----", rv$state, "====",
                   commentaire, "\n")
  cat(textes, file = "avancement.txt", append = TRUE)
}
#==================================================================================================
## Login des participants ----
#==================================================================================================
  observeEvent(input$start_ok, {
    disable("start_ok")
    user_ok <- input$id_sujet %in% available_id
    if(user_ok){
      id <<- input$id_sujet
      available_id <<- available_id[-which(input$id_sujet == available_id)]
      sujet_identifier[as.character(input$id_sujet)] <<- T
      rv$t_ident <- all(sujet_identifier)
      show("login_waiting")

    } else {
      reset("identification")
      show("login_error")

      enable("start_ok")
    }
    indique("tentative authentification")
  })
  
  observeEvent(req(rv$t_ident),{
    hide("identification")
    #reset("identification")
    show("consigne_1")

  })
  
  
#==================================================================================================
## Lecture des consignes general ----
#==================================================================================================
  observeEvent(input$compris_0, {
    disable("compris_0")
    sujet_compris_0[as.character(input$id_sujet)] <<- T
    rv$t_comp_0 <- all(sujet_compris_0)
    show("cons_0_waiting")

  })
  
  observeEvent(req(rv$t_comp_0), {
    hide("consigne_0")
    reset("consigne_0")
    show("consigne_1")
  })
  
#==================================================================================================
## Lecture des consignes de la taches 1 ----
#==================================================================================================
  observeEvent(input$compris_1, {
    disable("compris_1")
    sujet_compris_1[as.character(input$id_sujet)] <<- T
    rv$t_comp_1 <- all(sujet_compris_1)
    show("cons_1_waiting")
    
    indique("consigne 1")
  })
  
  observeEvent(req(rv$t_comp_1), {
    hide("consigne_1")
    reset("consigne_1")
    show("attente")
    
    indique("##### Debut 1 #####")
  })
  
#==================================================================================================
## Lecture des consignes de la taches 2 ----
#==================================================================================================
  observeEvent(input$compris_2, {
    disable("compris_2")
    sujet_compris_2[as.character(input$id_sujet)] <<- T
    rv$t_comp_2 <- all(sujet_compris_2)
    show("cons_2_waiting")
    
    indique("consigne 2")

  })
  
  observeEvent(req(rv$t_comp_2), {
    hide("consigne_2")
    reset("consigne_2")
    show("attente")
    
    indique("##### Debut 2 #####")
  })
  
  
#==================================================================================================
## Lecture des consignes de la taches 3 ----
#==================================================================================================
  observeEvent(input$compris_3, {
    disable("compris_3")
    sujet_compris_3[as.character(input$id_sujet)] <<- T
    rv$t_comp_3 <- all(sujet_compris_3)
    show("cons_3_waiting")
    
    indique("consigne 3")
  })
  
  observeEvent(req(rv$t_comp_3), {
    hide("consigne_3")
    reset("consigne_3")
    show("attente")
    
    indique("##### Debut 3 #####")
  })
  
#==================================================================================================
## Valeur afficher calculer serveur ----
#==================================================================================================
## Variable de temps a afficher pour l'attente
  output$current_time <- renderText({
    invalidateLater(1000)
    paste("Il est actuellement : ", stringr::str_sub(Sys.time(),12))
  })
  # Table de nombre pour la tache de decompte
  output$table_compte <- renderTable(srv$table,
                                     striped = TRUE,
                                     colnames = FALSE)
  
  output$dec_partenaire <- renderText({
    if (srv$num_choix < 2){
      paste("Pas encore d'information")

    } else {
      
      if (decision[s_appar[id], srv$num_choix - 1] !="NR"){ 
        srv$dec_part <- decision[s_appar[id], srv$num_choix - 1]
      }
      
      if(srv$dec_part == "surf"){  
        paste("Votre partenaire a arrété la tâche de décompte.")
        
      } else if(srv$dec_part == "commit") { 
        paste("L'autre joueur a choisi de continuer sans revoir l'écran de choix.")
        
      } else if(srv$dec_part == "continue") {  
        paste("L'autre joueur a choisi de continuer normalement.")
        
      }
    }
  })
  
## Initialisation de la tache 1 ----  
observeEvent(req(rv$t_comp_1), {
  srv$tache <- 1
  rv$timer <- 0
  ## Stockage des instant de decompte et de choix
  wait  <<- (wait_ind_t[[srv$tache]][["wait"]])*60
  ind_t <<- wait_ind_t[[srv$tache]][["ind_t"]]
  d_t <<- duree[srv$tache]*60
})

## tache 2_1 ----  
observeEvent(req(rv$t_comp_2), {
  rv$timer <- 0
  rv$state[id] <- "continue"
})  

## tache 3_1 ----  
observeEvent(req(rv$t_comp_3), {
  rv$timer <- 0
  rv$state[id] <- "continue"
})  

## tache sans consigne ----  
observeEvent(req(srv$tache %in% c(3,5)), {
  rv$timer <- 0
})  


#=================================================================================================
## TACHE ----
#=================================================================================================
## Suivie du nombre de count et de choix


  
  observeEvent(req(rv$timer %in% wait[!ind_t]), {
    srv$num_count <- srv$num_count +1
    
  })
  
  observeEvent(req(rv$timer %in% wait[ind_t]), {
    srv$num_choix <- srv$num_choix +1
    log_it("At : ", srv$num_choix, " sujet : ", id, " srv$dec_part = ", isolate(srv$dec_part))
#    log_it("At : ", srv$num_choix, " sujet : ", id, " decision = ", stringr::str_c(decision, collapse = ", "))

  })  
  
  
## Declenchement d'une tache de decompte ----
  observeEvent(req((rv$timer %in% wait[!ind_t]) && (rv$state[id] != "surf")), {
    hide("attente")
    show("decompte")
    srv$table <- genere_compte()
    true_count[id, srv$num_count] <<- sum(isolate(srv$table))

    delay(temps_counting*60000*R, {
      counting[id, srv$num_count] <<- input$reponse

      hide("decompte")
      hide("count_waiting")
      delay(10, {
      enable("reponse")
      enable("dec_att")
      reset("decompte")
      })
      show("attente")
    })
    
  })

## Declenchement d'une tache de choix ----
  observeEvent(req((rv$timer %in% wait[ind_t]) && (rv$state[id] == "continue")), {
    hide("attente")
    show("choix")
    if(srv$tache > 3) show("rappel_payoff")
    if(srv$num_choix > 5) show("dec_part")

    delay(temps_choix*60000*R, {
      decision[id, srv$num_choix] <<- isolate(input$choix)
      rv$state[id] <<- isolate(input$choix)
      hide("choix")
      if(input$choix == "surf"){
        show("web")
      } else{
        show("attente")
      }
      hide("choix_waiting")
      delay(10, {
      enable("cho_att")
      enable("choix")
      reset("choix")
      })
    })
  })

## Declenchement de la fin d'une tâche ----
observeEvent(req(rv$timer == d_t), {
  # print("######################")
  # print(paste("le numero de tache est", srv$tache))
  # print(paste("le numero de compte est", srv$num_count))
  # print(paste("l'etat de", id, "est", rv$state[id]))
  indique("fin d'une tâche")
  hide("attente")
  if(srv$tache %in% c(3,5)) {
    hide("web")
    enable("go_web")
  }
  
  save(decision, t_decision, counting, t_counting, true_count, s_appar,  
       file = paste0("output/data/", num_session, "_resultat.Rdata"))
  delay(1000*R, {
  srv$tache <- isolate(srv$tache) + 1
## Stockage des instant de decompte et de choix
  if(srv$tache < 5) {
  wait  <<- wait_ind_t[[srv$tache]][["wait"]]*60
  ind_t <<- wait_ind_t[[srv$tache]][["ind_t"]]
  d_t <<- duree[srv$tache]*60
  }
  next_step <- ifelse(srv$tache%%2 == 0,
                      paste0("consigne_", srv$tache%/%2 +1 ),
                      "attente")
  if(!(srv$tache %in% c(3,5)) || (rv$state[id] != "surf")){
  show(next_step)
  }
  })
})
  
#=================================================================================================
## Temps reponse ----
#=================================================================================================
  observeEvent(req(input$cho_att), {
    disable("cho_att")
    disable("choix")
    show("choix_waiting")
    t_decision[id, srv$num_choix] <<- wait[max(which(wait <= isolate(rv$timer)))] + 
                                  temps_choix*60 - 
                                  isolate(rv$timer)

  })
  
  observeEvent(req(input$dec_att), {
    disable("dec_att")
    disable("reponse")
    show("count_waiting")
    t_counting[id, srv$num_count] <<- wait[max(which(wait <= isolate(rv$timer)))] +
                                  temps_counting*60 - 
                                  isolate(rv$timer)
    
  })

  observeEvent(req(input$rep_quest_fin), {
    payoff <- calcul_payoff(1:nb_sujet, decision, counting, true_count, s_appar, payoff_interac)
    save(payoff, decision, t_decision, counting, t_counting, true_count, 
         file = paste0("output/data/", num_session, "_resultat.Rdata"))
    save(payoff, decision, t_decision, counting, t_counting, true_count, s_appar,
         file = "output/data/last_resultat.Rdata")
    
    indique("resultat sauvegarder##########################")
  })
#==================================================================================================
## Controlleur questionnaire ----
#==================================================================================================
reponse_A <- list(0, 30, 2, "Faux")
reponse_B <- list(3, 4, 3.4, c(3, 4))
srv$nb_erreur <- 0
    observeEvent(input$"A_submit", {
      srv$nb_erreur <- 0
      for (i in 1:4) {
        if(input[[paste0("A_", i, "_rep")]] != reponse_A[[i]]) {
          show(paste0("A_", i, "_message_erreur"))
          srv$nb_erreur <- srv$nb_erreur + 1
        } else {
          disable(paste0("A_", i, "_rep"))
          hide(paste0("A_", i, "_message_erreur"))
        }
      }
      if(srv$nb_erreur != 0){
        show("A_message_erreur")
      } else {
        hide("A_message_erreur")
        show("A_ok")
      }
      
    })
    
    observeEvent(input$"B_submit", {
      srv$nb_erreur <- 0
      for (i in 1:4) {
        if(!(input[[paste0("B_", i, "_rep")]] %in% reponse_B[[i]])) {
          show(paste0("B_", i, "_message_erreur"))
          srv$nb_erreur <- srv$nb_erreur + 1
        } else {
          disable(paste0("B_", i, "_rep"))
          hide(paste0("B_", i, "_message_erreur"))
        }
      }
      if(srv$nb_erreur != 0){
        show("B_message_erreur")
      } else {
        hide("B_message_erreur")
        show("B_ok")
      }
      
    })
    
#==================================================================================================
## Enregistrement du questionnaire final ----
#==================================================================================================
reponse_questionaire <- as.list(1:7)
    observeEvent(input$rep_quest_fin, {
      for (i in seq_along(reponse_questionaire)) {
        reponse_questionaire[i] <- input[[paste0(i, "_final")]]
      }
      save(reponse_questionaire, file = paste0("output/questionnaire/", 
                                               paste(id, num_session, "questionnaire_fin", sep = "_"), 
                                               ".Rdata"))
      hide("consigne_4")
      show("fin")
      indique("SUR ECRAN DE FIN")
    })

  
###################################################################################################    
}

###################################################################################################
########################################################################## Run the application ----
###################################################################################################
shinyApp(ui = ui, server = server)
