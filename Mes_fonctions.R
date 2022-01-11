#function for log result ----
loggeur <- function(file = "log.txt", affiche = FALSE){
  log <- function(..., start = FALSE, affiche. = affiche){
    textes <- paste0(..., "\n")
    cat(textes, file = file, append = !start)
    if(affiche) print(textes)
    invisible(textes)
  }
  log
}
## log_event ----
event_loggeur <- function(file = "log.txt", timer, id, affiche = FALSE){
  log_event <- function(event, affiche. = affiche){
    textes <- paste0("At : ", timer, " subject : ", id, " ==== ", event, "\n")
    cat(textes, file = file, append = TRUE)
    if(affiche) print(textes)
    invisible(textes)
  }
  log_event
}

## source_dir ---
## function for source all .R from a directory
source_dir <- function(dir_path = ".", pattern = "\\.R$", recursive = FALSE){
  fichiers <- list.files(dir_path, recursive = recursive)
  fichiers <- fichiers[stringr::str_detect(fichiers, pattern)]
  paths <- stringr::str_c(dir_path, fichiers, sep = "")
  sapply(paths, source)
  invisible(paths)
}

missing_fixer <- function(na_value){
  function(x){
    x[x == na_value] <- NA
    x
  }
}
remplace_NA <- function(value_na) {
  function(x){
    x[is.na(x)] <- value_na
    x
  }
}
val_fixer <- function(wrong_val, wright_val){
  function(x){
    x[x == wrong_val] <- wright_val
    x
  }
}

## question ----
## A personal html coteneur for question
question <- function(id, enonce, reponse){
  fluidRow(column(5,
                  enonce,
                  offset = 1),
           column(2,
                  selectInput(inputId = paste0(id, "_rep"),
                              label = NA,
                              reponse)),
           column(3,
                  hidden(div(id = paste0(id, "_message_erreur"),
                             span("La réponse à cette question n'est pas correcte.",
                                  style = "color:red")
                  ))
           )
  )
}

## questionnaire ----
## A personal html coteneur for questionnaire
questionnaire <- function(id, Enonce, Reponse, enTete = 'default'){
  Id <- as.list(paste0(id, "_", seq_along(Enonce)))
  if(enTete == 'default'){
    enTete <- div(id = paste0(id, "header"),
                  br(),
                  h4("Pour pouvoir continuer merci de répondre au question suivante. Attention, 
               à répondre au question en partant du principe que le taux de décompte juste
               est supérieur à 70%."),
                  br(),
                  br())
  } else if(enTete == 'void'){
    enTete <- div(id = paste0(id, "header"))
  }
  resultat <- div(id = id,
                  fluidRow(column(8, enTete, offset = 2)),
                  Map(question, Id, Enonce, Reponse),
                  fluidRow(column(2, 
                                  actionButton(inputId = paste0(id, "_submit"),
                                               "Je répond !"),
                                  offset = 5)),
                  fluidRow(column(2, 
                                  hidden(div(id = paste0(id, "_message_erreur"),
                                             span("Certaine réponse sont incorecte.",
                                                  style = "color:red"))),
                                  offset = 5))
  )
  
  resultat
}