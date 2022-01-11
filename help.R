## Bettega Paul
## 2018_09_24
## Laboratoire tentant
#source("~/ressource/Mes_fonctions.R") # ; P 
NA__10 <- remplace_NA(10)
###############################################################################
#=============================================================================#
###############################################################################
## genere_compte ----
## Fonction de genration des tableau de decompte de 9 0 ou 1
## {} -> DF{1,9}
genere_compte <- function(){
  valeur <- vector(mode = "integer", length = 9)
  for (i in seq_along(valeur)) {
    valeur[i] <- rbinom(1, 1, 1/2)
  }
  t(matrix(valeur))
}

calcul_temps <- function(nb_wait, timer_T, duree, temps_choix, temps_counting){
  total_wait <- duree - length(timer_T)*temps_choix - nb_wait*temps_counting
  wait <- rep(duree, nb_wait)
  temps <- timer_T
  while((sum(wait) >= total_wait)||(is.element(TRUE, timer_T %in% temps))){
    wait <- floor(runif(nb_wait, 1, 4))
    temps <- c(sum_wait(wait, temps_counting), duree)
  }
  ind_t <- rep(FALSE, length(temps)+length(timer_T))
  for (i in seq_along(timer_T)) {
    ind <- Position(function(X) X > timer_T[i], temps)
    temps <- c(temps[1:(ind-1)], 
               timer_T[i], 
               temps[ind:length(temps)]+temps_choix)
    ind_t[ind] <- TRUE
  }
  return(list('wait' = temps[-length(temps)], 'ind_t' = ind_t[-length(ind_t)]))
}

sum_wait <- function(wait, temps_counting){
  result <- vector(mode = "numeric", length(wait))
  for (i in seq_along(wait)) {
    result[i] <- sum(wait[1:i])+(i-1)*temps_counting
  }
  result
}

effort <- function(id, decision){
  if("surf" %in% decision[id, 1:2]) return(0)
  if("surf" %in% decision[id, ])    return(1)
  2
}

payoff_interaction <- function(id, decision, payoff_interac, s_appar){
  payoff_interac[effort(id, decision)+1,
                 effort(s_appar[id], decision)+1]
}

calcul_t_reussite <- function(id, counting, true_count){
  counting <- NA__10(counting)
  result <- sum(counting[id, ] == true_count[id, ]) /
            sum(counting[id, ] != -1)
  result
}

appareille <- function(id){
  if(length(id)%%2 == 1) {
    pair <- id[-1]
    while (is.element(TRUE,  pair == id[-1])) {
      pair <- sample(pair, length(pair))
    }
    result <- c(id[1], pair)
  } else {
    pair <- id
    while (is.element(TRUE,  pair == id)) {
      pair <- sample(pair, length(pair))
    }
    result <- pair
    }
  result
}

calcul_payoff <- function(id, decision, counting, true_count, s_appar, payoff_interac){
  nb_comm <- function(id) {sum(decision[id, ] == "commit")}
  payoff <- 2 +
    4 +
    2 * sapply(id, effort, decision[, 1:4]) +
    sapply(id, payoff_interaction, decision[, 5:8], payoff_interac, s_appar) -
    sapply(id, nb_comm) * 0.1
  
  t_reussite <- sapply(id, calcul_t_reussite, counting, true_count)
  result <- ifelse(t_reussite > 0.7, payoff, 4)
  result
}

#==============================================================================
## TEST
#==============================================================================
# sequence <- function(i) {
#   donne <- get("donne")
#   wait <- get("wait")
#   ind_t <- get("ind_t")
#   input <- get("input")
#   num_session <- get("num_session")
#   temps_choix <- get("temps_choix")
#   temps_counting <- get("temps_counting")
#   nb_counting <- get("nb_counting")
#   
#   
#   debut <- now()
#   ## Situation de temptation ========================================================================
#   if(ind_t[i]) {
#     hide("attente")
#     show("choix")
#     delay(temps_choix*6000, {
#       if(donne[id, 70+sum(ind_t[1:i])] == -1) {
#         donne[id, 70+sum(ind_t[1:i])] <<- 15
#       }
#       donne[id, 62+sum(ind_t[1:i])] <<- input$choix
#       print(input$choix)
#       if(input$choix == "surf") {
#         print(paste0("A l'iteration ", i, "input vaut surf"))
#         hide("choix")
#         save(donne, file = paste0(num_session,"_donne.Rdata"))
#         reset("choix")
#         show("attente")
#       }
#       if(input$choix == "commit") {
#         print(paste0("A l'iteration ", i, "input vaut commit"))
#         hide("choix")
#         save(donne, file = paste0(num_session,"_donne.Rdata"))
#         reset("choix")
#         show("attente")
#       }
#       if(input$choix == "continue") {
#         print(paste0("A l'iteration ", i, "input vaut continue"))
#         hide("choix")
#         save(donne, file = paste0(num_session,"_donne.Rdata"))
#         reset("choix")
#         show("attente")
#       }
#     })
#     ## Situation de decompte ==========================================================================
#   }else {
# 
#     hide("attente")
#     show("decompte")
#     delay(temps_counting*60, {
#       if(donne[id, sum(nb_counting)+sum(!ind_t[1:i])] == -1) {
#         donne[id, sum(nb_counting)+sum(!ind_t[1:i])] <<- temps_counting
#       }
#       donne[id, sum(!ind_t[1:i])] <<- input$reponse
#       hide("decompte")
#       reset("decompte")
#       show("attente")
#     })
#   }
# }
###############################################################################
############################### TEST ZONE #####################################
## 10_10_2018
# nb_wait <- 31
# timer_T <- c(36, 42, 48, 54, 66, 72, 78, 84)
# duree <- 180
# temps_choix <- 1
# temps_counting <- 0.25
# calcul_temps(nb_wait, timer_T, duree, temps_choix, temps_counting)
## 18_10_2018
# nb_wait <- 4
# timer_T <- c(6, 12)
# duree <- 15
# temps_choix <- 1
# temps_counting <- 0.25
## 10_12_2018 ---- test de la fonction de payoff


########################### FIN DE ZONE TEST ##################################