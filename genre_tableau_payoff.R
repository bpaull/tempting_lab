
load("output/data/last_resultat.Rdata")

payment <- cbind.data.frame(participants = seq_along(payoff), gain_total = payoff)

write.csv(payment, file = "tableau_des_payments.csv")
