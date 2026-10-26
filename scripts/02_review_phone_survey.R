# Conservative first-pass classification. Never silently classify ambiguous pre-policy responses.
packages <- c('readr','dplyr','stringr')
for (pkg in packages) if (!requireNamespace(pkg, quietly=TRUE)) install.packages(pkg)
library(readr); library(dplyr); library(stringr)
s <- read_csv('data/phone_survey/cellphone_survey.csv', show_col_types=FALSE,
              col_types=cols(.default=col_character()))
stopifnot(ncol(s)==8)
names(s) <- c('school_id','current_rule','current_restriction_timing',
              'other_text','current_physical_method','implementation_date',
              'prior_rule_text','prior_restriction_timing')
clean_text <- function(x) str_squish(str_to_lower(coalesce(x,'')))
s <- s %>% mutate(across(everything(), ~na_if(str_squish(.x),''))) %>%
  mutate(method_normalized=clean_text(current_physical_method),
         prior_normalized=clean_text(prior_rule_text),
         # Dropdown evidence for CURRENT policy only; write-in contradictions require review.
         current_policy_prelim=case_when(
           str_detect(method_normalized,'centralized location|yondr|classroom collection|lockers only') ~ 'physical_removal',
           str_detect(method_normalized,'no-show|no school-wide collection') ~ 'honor_system',
           TRUE ~ 'manual_review'),
         prior_policy_prelim=case_when(
           str_detect(prior_normalized,'^(no rule|none|no prior policy|no policy)[.! ]*$') ~ 'no_rule',
           TRUE ~ 'manual_review'),
         treatment_prelim=NA_character_,
         review_note=case_when(is.na(prior_rule_text) ~ 'Prior rule missing: review',
                               TRUE ~ 'Read prior rule and check conflicting current descriptions'))
# Design decision: prior policy ALWAYS needs manual review, except explicit no-rule text.
# Research group should record reviewed classifications in separate columns and audit exceptions.
write_csv(s, 'cleaned/phone_survey_review.csv', na='')
print(s %>% count(current_policy_prelim))
print(s %>% count(prior_policy_prelim))
message('Saved cleaned/phone_survey_review.csv. Review prior/current entries before defining treatment.')
