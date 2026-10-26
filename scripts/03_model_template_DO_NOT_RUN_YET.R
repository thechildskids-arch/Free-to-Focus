# TEMPLATE ONLY. DO NOT RUN until academic_panel.csv exists and variable names are verified.
# A school-subject-year panel with validated outcome/control names is required.
# Model A: 2025 and 2026 treated as post period.
# Control: honor -> honor; treatment: honor -> physical.
# Outcomes run separately by subject (and school type for Algebra 1), then satisfaction separately.
# library(readr); library(dplyr); library(fixest)
# d <- read_csv('cleaned/academic_panel.csv')
# d <- d %>% mutate(post=as.integer(year>=2025), treated=as.integer(group=='treatment'))
# model <- feols(mean_score ~ treated:post + poverty_pp_change +
#                  teacher_spend_share_pp_change + instruction_spend_share_pp_change +
#                  teacher_salary_pct_change + student_teacher_ratio_pct_change +
#                  principal_change | school_id + year,
#                data=filter(d, subject=='English 2'), cluster=~school_id)
# summary(model)
# Important: validate units, missingness, parallel trends, school identifier changes,
# and grading/subject comparability. These names are target names, not CSV field names.
