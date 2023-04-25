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



main_dir <- getwd()
sub_dir <- "data-raw"
## Provide the dir name(i.e sub dir) that you want to create under main dir:
output_dir <- file.path(main_dir, sub_dir)

if (!dir.exists(output_dir)){
  dir.create(output_dir)
} else {
  print("Dir already exists!")
}



## Getting all country files ##########

#drv$list_files("02 Operations/04. RBM - COMPASS/07. Results Framework and M&E/05. Indicators/03. Core Indicator Quality Assurance/2022 Year-End Reporting/Argentina MCO 2022 Indicators", full_names=TRUE)
fileARG <- "02 Operations/04. RBM - COMPASS/07. Results Framework and M&E/05. Indicators/03. Core Indicator Quality Assurance/2022 Year-End Reporting/Argentina MCO 2022 Indicators/ARG_MCO_MoV and 2022 Indicator Reporting.xlsx"
drv$download_file(fileARG ,
                  dest = here::here("data-raw", "ARG_MCO_MoV and 2022 Indicator Reporting.xlsx"),
                  overwrite = TRUE)

#drv$list_files("02 Operations/04. RBM - COMPASS/07. Results Framework and M&E/05. Indicators/03. Core Indicator Quality Assurance/2022 Year-End Reporting/Brazil Year-End 2022 Indicators", full_names=TRUE)
fileBRA <- "02 Operations/04. RBM - COMPASS/07. Results Framework and M&E/05. Indicators/03. Core Indicator Quality Assurance/2022 Year-End Reporting/Brazil Year-End 2022 Indicators/BRA_MoV and 2022 Indicator Reporting.xlsx"
drv$download_file(fileBRA ,
                  dest = here::here("data-raw", "BRA_MoV and 2022 Indicator Reporting.xlsx"),
                  overwrite = TRUE)

#drv$list_files("02 Operations/04. RBM - COMPASS/07. Results Framework and M&E/05. Indicators/03. Core Indicator Quality Assurance/2022 Year-End Reporting/Canada Year-End 2022 Indicators", full_names=TRUE)
fileCAN <- "02 Operations/04. RBM - COMPASS/07. Results Framework and M&E/05. Indicators/03. Core Indicator Quality Assurance/2022 Year-End Reporting/Canada Year-End 2022 Indicators/CAN_MoV and 2022 Indicator Reporting.xlsx"
drv$download_file(fileCAN ,
                  dest = here::here("data-raw", "CAN_MoV and 2022 Indicator Reporting.xlsx"),
                  overwrite = TRUE)

#drv$list_files("02 Operations/04. RBM - COMPASS/07. Results Framework and M&E/05. Indicators/03. Core Indicator Quality Assurance/2022 Year-End Reporting/Chile Year-End 2022 Indicators", full_names=TRUE)
fileCHL <- "02 Operations/04. RBM - COMPASS/07. Results Framework and M&E/05. Indicators/03. Core Indicator Quality Assurance/2022 Year-End Reporting/Chile Year-End 2022 Indicators/CHL_MoV and 2022 Indicator Reporting.xlsx"
drv$download_file(fileCHL,
                  dest = here::here("data-raw", "CHL_MoV and 2022 Indicator Reporting.xlsx"),
                  overwrite = TRUE)

#drv$list_files("02 Operations/04. RBM - COMPASS/07. Results Framework and M&E/05. Indicators/03. Core Indicator Quality Assurance/2022 Year-End Reporting/Colombia Year-End 2022 Indicators", full_names=TRUE)
fileCOL <- "02 Operations/04. RBM - COMPASS/07. Results Framework and M&E/05. Indicators/03. Core Indicator Quality Assurance/2022 Year-End Reporting/Colombia Year-End 2022 Indicators/COL_MoV and 2022 Indicator Reporting.xlsx"
drv$download_file(fileCOL,
                  dest = here::here("data-raw", "COL_MoV and 2022 Indicator Reporting.xlsx"),
                  overwrite = TRUE)

#drv$list_files("02 Operations/04. RBM - COMPASS/07. Results Framework and M&E/05. Indicators/03. Core Indicator Quality Assurance/2022 Year-End Reporting/Costa Rica Year-End 2022 Indicators", full_names=TRUE)
fileCRI <- "02 Operations/04. RBM - COMPASS/07. Results Framework and M&E/05. Indicators/03. Core Indicator Quality Assurance/2022 Year-End Reporting/Costa Rica Year-End 2022 Indicators/CRI_MoV and 2022 Indicator Reporting.xlsx"
drv$download_file(fileCRI ,
                  dest = here::here("data-raw", "CRI_MoV and 2022 Indicator Reporting.xlsx"),
                  overwrite = TRUE)

#drv$list_files("02 Operations/04. RBM - COMPASS/07. Results Framework and M&E/05. Indicators/03. Core Indicator Quality Assurance/2022 Year-End Reporting/Dominican Republic 2022 Indicators", full_names=TRUE)
fileDOM <- "02 Operations/04. RBM - COMPASS/07. Results Framework and M&E/05. Indicators/03. Core Indicator Quality Assurance/2022 Year-End Reporting/Dominican Republic 2022 Indicators/DOM_MoV and 2022 Indicator Reporting.xlsx"
drv$download_file(fileDOM ,
                  dest = here::here("data-raw", "DOM_MoV and 2022 Indicator Reporting.xlsx"),
                  overwrite = TRUE)

#drv$list_files("02 Operations/04. RBM - COMPASS/07. Results Framework and M&E/05. Indicators/03. Core Indicator Quality Assurance/2022 Year-End Reporting/Ecuador Year-End 2022 Indicators", full_names=TRUE)
fileECU <- "02 Operations/04. RBM - COMPASS/07. Results Framework and M&E/05. Indicators/03. Core Indicator Quality Assurance/2022 Year-End Reporting/Ecuador Year-End 2022 Indicators/ECU_MoV and 2022 Indicator Reporting.xlsx"
drv$download_file(fileECU ,
                  dest = here::here("data-raw", "ECU_MoV and 2022 Indicator Reporting.xlsx"),
                  overwrite = TRUE)

#drv$list_files("02 Operations/04. RBM - COMPASS/07. Results Framework and M&E/05. Indicators/03. Core Indicator Quality Assurance/2022 Year-End Reporting/El Salvador Year-End 2022 Indicators", full_names=TRUE)
fileSLV <- "02 Operations/04. RBM - COMPASS/07. Results Framework and M&E/05. Indicators/03. Core Indicator Quality Assurance/2022 Year-End Reporting/El Salvador Year-End 2022 Indicators/SLV_MoV and 2022 Indicator Reporting.xlsx"
drv$download_file(fileSLV,
                  dest = here::here("data-raw", "SLV_MoV and 2022 Indicator Reporting.xlsx"),
                  overwrite = TRUE)

#drv$list_files("02 Operations/04. RBM - COMPASS/07. Results Framework and M&E/05. Indicators/03. Core Indicator Quality Assurance/2022 Year-End Reporting/Guatemala Year-End 2022 Indicators", full_names=TRUE)
fileGTM <- "02 Operations/04. RBM - COMPASS/07. Results Framework and M&E/05. Indicators/03. Core Indicator Quality Assurance/2022 Year-End Reporting/Guatemala Year-End 2022 Indicators/GTM_MoV and 2022 Indicator Reporting.xlsx"
drv$download_file(fileGTM ,
                  dest = here::here("data-raw", "GTM_MoV and 2022 Indicator Reporting.xlsx"),
                  overwrite = TRUE)

#drv$list_files("02 Operations/04. RBM - COMPASS/07. Results Framework and M&E/05. Indicators/03. Core Indicator Quality Assurance/2022 Year-End Reporting/Honduras Year-End 2022 Indicators", full_names=TRUE)
fileHND <- "02 Operations/04. RBM - COMPASS/07. Results Framework and M&E/05. Indicators/03. Core Indicator Quality Assurance/2022 Year-End Reporting/Honduras Year-End 2022 Indicators/HND_MoV and 2022 Indicator Reporting.xlsx"
drv$download_file(fileHND ,
                  dest = here::here("data-raw", "HND_MoV and 2022 Indicator Reporting.xlsx"),
                  overwrite = TRUE)

# drv$list_files("02 Operations/04. RBM - COMPASS/07. Results Framework and M&E/05. Indicators/03. Core Indicator Quality Assurance/2022 Year-End Reporting/Mexico Year-End 2022 Indicators", full_names=TRUE)
fileMEX <- "02 Operations/04. RBM - COMPASS/07. Results Framework and M&E/05. Indicators/03. Core Indicator Quality Assurance/2022 Year-End Reporting/Mexico Year-End 2022 Indicators/MEX_MoV and 2022 Indicator Reporting.xlsx"
drv$download_file(fileMEX ,
                  dest = here::here("data-raw", "MEX_MoV and 2022 Indicator Reporting.xlsx"),
                  overwrite = TRUE)

# drv$list_files("02 Operations/04. RBM - COMPASS/07. Results Framework and M&E/05. Indicators/03. Core Indicator Quality Assurance/2022 Year-End Reporting/Panama MCO 2022 Indicators", full_names=TRUE)
filePANMCO <- "02 Operations/04. RBM - COMPASS/07. Results Framework and M&E/05. Indicators/03. Core Indicator Quality Assurance/2022 Year-End Reporting/Panama MCO 2022 Indicators/PAN_MCO_MoV and 2022 Indicator Reporting.xlsx"
drv$download_file(filePANMCO ,
                  dest = here::here("data-raw", "PAN_MCO_MoV and 2022 Indicator Reporting.xlsx"),
                  overwrite = TRUE)
filePAN <- "02 Operations/04. RBM - COMPASS/07. Results Framework and M&E/05. Indicators/03. Core Indicator Quality Assurance/2022 Year-End Reporting/Panama MCO 2022 Indicators/PAN_MoV and 2022 Indicator Reporting.xlsx"
drv$download_file(filePAN ,
                  dest = here::here("data-raw", "PAN_MoV and 2022 Indicator Reporting.xlsx"),
                  overwrite = TRUE)
fileTTO <- "02 Operations/04. RBM - COMPASS/07. Results Framework and M&E/05. Indicators/03. Core Indicator Quality Assurance/2022 Year-End Reporting/Panama MCO 2022 Indicators/TTO_MoV and 2022 Indicator Reporting.xlsx"
drv$download_file(fileTTO,
                  dest = here::here("data-raw", "TTO_MoV and 2022 Indicator Reporting.xlsx"),
                  overwrite = TRUE)

# drv$list_files("02 Operations/04. RBM - COMPASS/07. Results Framework and M&E/05. Indicators/03. Core Indicator Quality Assurance/2022 Year-End Reporting/Peru Year-End 2022 Indicators", full_names=TRUE)
filePER <- "02 Operations/04. RBM - COMPASS/07. Results Framework and M&E/05. Indicators/03. Core Indicator Quality Assurance/2022 Year-End Reporting/Peru Year-End 2022 Indicators/PER_MoV and 2022 Indicator Reporting.xlsx"
drv$download_file(filePER ,
                  dest = here::here("data-raw", "PER_MoV and 2022 Indicator Reporting.xlsx"),
                  overwrite = TRUE)

# drv$list_files("02 Operations/04. RBM - COMPASS/07. Results Framework and M&E/05. Indicators/03. Core Indicator Quality Assurance/2022 Year-End Reporting/United States MCO 2022 Indicators", full_names=TRUE)
fileUSA <- "02 Operations/04. RBM - COMPASS/07. Results Framework and M&E/05. Indicators/03. Core Indicator Quality Assurance/2022 Year-End Reporting/United States MCO 2022 Indicators/USA_MCO_MoV and 2022 Indicator Reporting.xlsx"
drv$download_file(fileUSA ,
                  dest = here::here("data-raw", "USA_MCO_MoV and 2022 Indicator Reporting.xlsx"),
                  overwrite = TRUE)

# drv$list_files("02 Operations/04. RBM - COMPASS/07. Results Framework and M&E/05. Indicators/03. Core Indicator Quality Assurance/2022 Year-End Reporting/Venezuela Year-End 2022 Indicators", full_names=TRUE)
fileVEN <- "02 Operations/04. RBM - COMPASS/07. Results Framework and M&E/05. Indicators/03. Core Indicator Quality Assurance/2022 Year-End Reporting/Venezuela Year-End 2022 Indicators/VEN_MoV and 2022 Indicator Reporting.xlsx"
drv$download_file(fileVEN ,
                  dest = here::here("data-raw", "VEN_MoV and 2022 Indicator Reporting.xlsx"),
                  overwrite = TRUE)


### Clean everything    except drive connection
rm(list = setdiff(ls(), "drv"))
