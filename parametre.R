# ## METAPARAMETRE ----
# R <- 0.1              # parametre de ralentissement
# nb_sujet <- 2       # nombre de sujet
# num_session <- paste0("test_", Sys.time())
# c_commit <- 0.1
# temps_counting <- 0.25
# temps_choix    <- 1
# payoff_interac <- matrix(c(0,   1,   3.5, 
#                            0.1, 2,   3.6,
#                            3,   3.9, 4),
#                          ncol = 3)
#==============================================================================
## Id sujets ----
## Liste des identifiants distribuer au sujets
id_sujet <- c(1:nb_sujet)
available_id <- id_sujet[1:nb_sujet]
s_appar <- appareille(id_sujet)

## nb decompte & timers choix ----
## Definition du nombre de tache de decompte et des timers des dates de choix
nom_periode <- c("t_1", "t_11", "t_12", "t_21", "t_22")
nb_counting <- setNames(c(15, 4, 4, 4, 4), nom_periode)
date_tempta <- list(c(), c(6, 12), c(3, 9), c(6, 12), c(3, 9))
names(date_tempta) <- nom_periode
duree <- setNames(c(30, 15, 15, 15, 15), nom_periode)
## calcul attente ----
## Calcul à partir des paramètres des sequence t'attente correspondante et 
## des instant pour les periodes de tentations.
wait_ind_t <- list()
for (i in seq_along(nb_counting)) {
  wait_ind_t[i] <- list(calcul_temps(nb_wait = nb_counting[i], 
                                     timer_T = date_tempta[[i]],
                                     duree = duree[i],
                                     temps_choix,
                                     temps_counting))
  wait_ind_t[[i]][["wait"]] <- wait_ind_t[[i]][["wait"]]
}
names(wait_ind_t) <- nom_periode
#==============================================================================
## payoff ----
payoff <- rep(-1, nb_sujet)
## Choix
nb_deci <- nb_sujet*length(unlist(date_tempta))
decision <- matrix(rep("NR", nb_deci), nrow = nb_sujet)
t_decision <- matrix(rep(temps_choix*60, nb_deci), nrow = nb_sujet)
## counting ----
nb_count <- nb_sujet*sum(nb_counting)
counting <- matrix(rep(-1, nb_count), nrow = nb_sujet)
t_counting <- matrix(rep(temps_counting*60, nb_count), nrow = nb_sujet)

## vrai valeur de decompte ----
true_count <- matrix(rep(-1, nb_count), nrow = nb_sujet)
## tout les sujets sont identifier
sujet_identifier <- rep(FALSE, nb_sujet)
names(sujet_identifier) <- id_sujet
## tout les sujets ont compris les consignes générales
sujet_compris_0 <- rep(FALSE, nb_sujet)
names(sujet_compris_0) <- id_sujet
## tout les sujets ont compris les consignes de la tâche 1
sujet_compris_1 <- rep(FALSE, nb_sujet)
names(sujet_compris_1) <- id_sujet
## tout les sujets ont compris les consignes de la tâche 2
sujet_compris_2 <- rep(FALSE, nb_sujet)
names(sujet_compris_2) <- id_sujet
## tout les sujets ont compris les consignes de la tâche 3
sujet_compris_3 <- rep(FALSE, nb_sujet)
names(sujet_compris_3) <- id_sujet

##  ----
wait  <- c()
ind_t <- F
d_t   <- 0
## ----