# Script Settings and Resources
setwd(dirname(rstudioapi::getActiveDocumentContext()$path))
library(tidyverse)

# Data Import
Adata_tbl <- read_delim("../data/Aparticipants.dat", delim="-", col_names = c("casenum", "parnum", "stimver", "datadate", "qs"))
Anotes_tbl <- read_csv("../data/Anotes.csv", col_names=T)
Bdata_tbl <- read_delim("../data/Bparticipants.dat", col_names = c("casenum", "parnum", "stimver", "datadate", "q1", "q2", "q3", "q4", "q5", "q6", "q7", "q8", "q9", "q10"))
Bnotes_tbl <- read_delim("../data/Bnotes.txt", col_names=T)

# Data Cleaning
Aclean_tbl <- Adata_tbl %>%
  separate(col=qs, paste0("q",1:5)) %>%
  mutate(datadate = mdy_hms(datadate)) %>%
  mutate(across(contains("q"), function(x) as.integer(x))) %>%
  inner_join(Anotes_tbl, by="parnum") %>%
  filter(is.na(notes))
ABclean_tbl <-Bdata_tbl %>%
  mutate(datadate=mdy_hms(datadate)) %>%
  mutate(across(contains("q"), function(x) as.integer(x))) %>%
  inner_join(Bnotes_tbl, by = "parnum") %>%
  filter(is.na(notes)) %>%
  bind_rows(Aclean_tbl, .id = "lab") %>% #can I do this with full join?
  select(-notes)