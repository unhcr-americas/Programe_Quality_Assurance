

rmarkdown::render(
  here::here("R/Rmd","QA_report_Notebook.Rmd"),
  output_file = here::here("out","QA_report_Notebook.docx" ))


 
rmarkdown::render(
  here::here("R/Rmd","QA_report_Notebook_light.Rmd"),
  output_file = here::here("out","QA_report_Notebook_light.docx" ))


#  Archive all Results in sharepoint ######
url <- "https://unhcr365.sharepoint.com/teams/amer-rbap"
site <- Microsoft365R::get_sharepoint_site(site_url= url)

## List of all sharepoint items directly in the root folder of the site... 
drv <- site$get_drive()
#  report output 
drv$upload_file(src = "out/QA_report_Notebook.docx",
                dest = paste0("02 Operations/04. RBM - COMPASS/07. Results Framework and M&E/05. Indicators/03. Core Indicator Quality Assurance/2022 Year-End Reporting/01_Generated_QA_Report/QA_report_Generated_v_",
                              format(Sys.Date(),
                                     '%d %B %Y'), 
                              ".docx") )


#  report output Light
drv$upload_file(src = "out/QA_report_Notebook_light.docx",
                dest = paste0("02 Operations/04. RBM - COMPASS/07. Results Framework and M&E/05. Indicators/03. Core Indicator Quality Assurance/2022 Year-End Reporting/01_Generated_QA_Report/Light_QA_report_Generated_v_",
                              format(Sys.Date(),
                                     '%d %B %Y'), 
                              ".docx") )

## and now build the PBI report based on the template for all  regions !
bureaux <- ForcedDisplacementStat::reference |> 
  dplyr::select(UNHCRBureau) |>
  dplyr::filter( ! (is.na(UNHCRBureau)) ) |> 
  dplyr::distinct() |>
  dplyr::pull()

for (region in bureaux) {
  
  outputfile <-  here::here("out", paste0("QA_report_Generated_",
                                         region,
                                         "v_",
                                         format(Sys.Date(),
                                                '%d %B %Y'), 
                                         ".docx"))
                           
  rmarkdown::render(
    ## Report template
    here::here("R/Rmd","QA_report_Notebook_PBIDATA.Rmd"),
    ## geneated file
    output_file = outputfile,
    ## Report parameters
    params = list(region = region))
  
  ## upload the generated report to Sharepoint
  drv$upload_file(src = outputfile,
                  dest = paste0("02 Operations/04. RBM - COMPASS/07. Results Framework and M&E/05. Indicators/03. Core Indicator Quality Assurance/2022 Year-End Reporting/05_Results_PowerBI/QA_report_Generated_",
                                region,
                                "v_",
                                format(Sys.Date(),
                                       '%d %B %Y'), 
                                ".docx") ) 
  }
