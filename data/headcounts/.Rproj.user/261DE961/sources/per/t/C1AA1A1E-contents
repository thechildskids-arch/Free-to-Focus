# F2F starter: safe inventory of downloaded Excel files.
# Run with RStudio project opened at Free_to_Focus_2026.
packages <- c('readxl','readr','dplyr','purrr','tibble','stringr')
for (pkg in packages) if (!requireNamespace(pkg, quietly=TRUE)) install.packages(pkg)
library(readxl); library(readr); library(dplyr); library(purrr); library(tibble); library(stringr)
dir.create('outputs', showWarnings=FALSE)
folders <- c('data/eocep','data/report_cards','data/headcounts')
paths <- unlist(lapply(folders, function(f) list.files(f, pattern='\\.(xlsx|xls)$', full.names=TRUE, ignore.case=TRUE)))
if (length(paths)==0) message('No Excel downloads yet. Download the files and run again.')
sheet_inventory <- map_dfr(paths, function(p) {
  sh <- tryCatch(excel_sheets(p), error=function(e) character())
  if (!length(sh)) return(tibble(file=p, sheet=NA_character_, rows_preview=NA_integer_, columns=NA_character_))
  map_dfr(sh, function(s) {
    x <- tryCatch(read_excel(p, sheet=s, n_max=5), error=function(e) NULL)
    tibble(file=p, sheet=s, rows_preview=if (is.null(x)) NA_integer_ else nrow(x),
           columns=if (is.null(x)) 'READ ERROR' else paste(names(x), collapse=' | '))
  })
})
write_csv(sheet_inventory,'outputs/excel_inventory.csv')
print(sheet_inventory, n=100)
message('Saved: outputs/excel_inventory.csv (review before deciding column mappings)')


library(readxl)

file <- "data/eocep/EOCEP2021-22-WEBFILE 922.xlsx"

# Show test and demographic code definitions
codes <- read_excel(
  file,
  sheet = "TestID and DemoID Details"
)

View(codes)

# Open school-level test data
eocep <- read_excel(
  file,
  sheet = "EOCEP_2021_22_SCHOOL"
)

View(eocep)