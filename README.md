# tempting laboratory

This project store the code for the experiment run in GAEL Viallet laboratory in Grenoble, France the 2018/12/17.
The code consist of an R Shiny web app (file app.R) aim to run on computer with shy-server install.

The goal of this experiment is to replicate [Houser et al.](https://doi.org/10.1016/j.geb.2017.10.025) result in
the first part of the experiment and to test a model of temptation with strategic interaction build on 
[multiple-self models](https://doi.org/10.1257/aer.96.5.1449).

The data collect from this experiment can be found at: **PROVIDELINK**


## Structure file

- **app.R** is the main file it contain the global structure of the app.
the server and the ui part and load the different function and parameters.
- **avancement.txt** is a text file that is filled during the experiment and 
keep trace of the evolution of the subject.
- **genre_tableau_payoff.R** script that generate **tableau_des_payments.csv** 
who summarise payoff of subjects.
- **help.R** function use inside server part of the application.
- **Mes_fonctions.R** more generics functions use in the application.
- **MyJS.js** JavaScript functions load in the UI.
- **parametre.R** R script that generate parameters for the application.
- **interface** each file in this directory contains definition in R for the 
different ui part of the application.
- **output** directories containing the different result of the experiemnet 
this directory must containt 3 directory **data**, **log**, **questionnaire**.
- **texte** directory containing the different txt display to subjects in HTML 
format.

## Global Parameters

- **R** *positive numeric* slow down parameter. multiplier for time allow to 
subject to answer. use mainly for testing purpose.
- **nb_sujet** *integer* the number of subject in the session. Must be even.
- **num_session** *character* specifying prefix for identify the session. Must 
be unique to avoid data suppression.
- **c_commit** *positive numeric* defining the cost for subject to commit.
- **temps_counting** *positive numeric* time allow to subject to count each 
array in seconde.
- **temps_choix** *positive numeric* time allow to subject to choose to commit 
or continue in seconde.
- **payoff_interac** *numeric matrix* of the payoff for the interaction period.


## Result

Result of the app are keep in the **output** directory who contain 3 
sub-directory:

1. **log** who keep for each session a log file logging for each subject 
different stage of the subject progression.
2. **questionnaire** keep for each subject and each session a .Rdata file 
recording their answer of the final survey.
3. **data** keep for each session a .Rdata recording the choice of subject 
**EXECEPT THE PAIRRING OF SUBJECTS** . Their is also a recording 
*last_resultat.Rdata* keeping the result for the last or current session.


