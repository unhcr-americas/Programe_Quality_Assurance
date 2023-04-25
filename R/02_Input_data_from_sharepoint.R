
## https://unhcr365.sharepoint.com/:f:/t/amer-rbap/El3am9WhD4tEiuDZeb6dAm8BPDbkvyCq-uLsixxGnvVgWA?e=7lnDz5

url <- "https://unhcr365.sharepoint.com/teams/amer-rbap"
site <- Microsoft365R::get_sharepoint_site(site_url= url)

### List of all sharepoint items directly in the root folder of the site... #####
drv <- site$get_drive()
#item <- tibble::as_tibble(site$get_drive()$list_items() )
# list of all document libraries under this site
# site$list_drives()
# site$get_lists()
# site1$list_items()
# item <- tibble::as_tibble(site1$list_items() )

#drv$list_files("02 Operations/04. RBM - COMPASS/", full_names=TRUE)
#drv$list_files("02 Operations/04. RBM - COMPASS/07. Results Framework and M&E/", full_names=TRUE)
#drv$list_files("02 Operations/04. RBM - COMPASS/07. Results Framework and M&E/05. Indicators/03. Core Indicator Quality Assurance/", full_names=TRUE)
# drv$list_files("02 Operations/04. RBM - COMPASS/07. Results Framework and M&E/05. Indicators/03. Core Indicator Quality Assurance/2022 Year-End Reporting", full_names=TRUE)

# This opens in browser
#drv$open_item(file)
# download your file in the current directory
#drv$download_file(file ,overwrite = TRUE)

main_dir <- getwd()
sub_dir <- "data"
## Provide the dir name(i.e sub dir) that you want to create under main dir:
output_dir <- file.path(main_dir, sub_dir)

if (!dir.exists(output_dir)){
  dir.create(output_dir)
} else {
  print("Dir already exists!")
}



### Getting the reference for the review - ############ 
file <- "02 Operations/04. RBM - COMPASS/07. Results Framework and M&E/05. Indicators/03. Core Indicator Quality Assurance/2022 Year-End Reporting/03_Input_Data/2022_ RBA_QA_Checklist_Core_indicators.xlsx" 

drv$download_file(src =file ,
                  dest = here::here("data", "QA.xlsx"),
                  overwrite = TRUE)


## Get the current cleaning file from sharepoint ###########
# to be potentially revised based on lookup above
fileCleanLookup <- "02 Operations/04. RBM - COMPASS/07. Results Framework and M&E/05. Indicators/03. Core Indicator Quality Assurance/2022 Year-End Reporting/03_Input_Data/CleanLookup.xlsx" 
drv$download_file(src =fileCleanLookup ,
                  dest = here::here("data", "CleanLookup.xlsx"),
                  overwrite = TRUE)


## Review in relation with the PBI extract #######
# https://app.powerbi.com/groups/me/apps/0970a707-7dbe-4a56-b90e-dbf0acde2ad5/reports/dc5ca004-8ce8-40fd-9858-59ac0e880f64/ReportSection097fb1a0b5b89c38a37f?ctid=e5c37981-6664-4134-8a0c-6543d2af80be
filePBI <- "02 Operations/04. RBM - COMPASS/07. Results Framework and M&E/05. Indicators/03. Core Indicator Quality Assurance/2022 Year-End Reporting/03_Input_Data//data_Result_Portal4.xlsx" 
drv$download_file(src =filePBI ,
                  dest = here::here("data", "data_Result_Portal4.xlsx"),
                  overwrite = TRUE)


## Getting Population Data ###############
fileDataView <- "02 Operations/04. RBM - COMPASS/07. Results Framework and M&E/05. Indicators/03. Core Indicator Quality Assurance/2022 Year-End Reporting/03_Input_Data/DataView.xlsx" 
drv$download_file(src =fileDataView ,
                  dest = here::here("data", "DataView.xlsx"),
                  overwrite = TRUE)


### Clean everything    except drive connection
rm(list = setdiff(ls(), "drv"))
