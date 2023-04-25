# Merging that with the Referential for Quality Control ############## 

### Master file 
QA_Indic <- read_excel(here::here("data", "QA.xlsx"), 
                       sheet = "QA per Indicator", skip = 1) |>
  janitor::clean_names()
#names(QA_Indic)
## Check ind_id is unique for further merge..
#nrow(QA_Indic)
#nrow(QA_Indic |> dplyr::select(ind_id) |> dplyr::distinct())

data3a  |>
  left_join(QA_Indic , by = c("Ind_id" = "ind_id"))  |>
  dplyr::filter( is.na(indicator_code )) |>
  dplyr::distinct(Indicator) |> 
  write.csv("data/LookupIndic2.csv")


data3b <- data3a  |>
  left_join(QA_Indic , by = c("Ind_id" = "ind_id"))  |>
  dplyr::filter(!(is.na(indicator_code))) |>
  tidyr::unite(col =  "keyctr", 
               all_of( c("Operation", "country" ) ), 
               na.rm = TRUE, 
               sep = "-",
               remove = FALSE) |>
  tidyr::unite(col =  "key", 
               all_of( c("keyctr", "indicator_code", "population_label") ), 
               na.rm = TRUE, 
               sep = "-",
               remove = FALSE) 



## Review in relation with the PBI extract
dataPBI1 <- readxl::read_excel(here::here("data","data_Result_Portal4.xlsx"),
                               sheet = "Export") |>
  dplyr::rename( "Outcome_Target_or_Ouput_Target_OP" = "Outcome_Target_or_Ouput_Target _OP") |>
  ### Remove Percent and cast to numeric
  dplyr::mutate( Outcome_Target_or_Ouput_Target_OP = as.numeric(stringr::str_remove(Outcome_Target_or_Ouput_Target_OP, "%"))) |>
  
  dplyr::filter(Year == 2022) |>
  dplyr::filter( Indicator_Type == "Core") |> 
  ## Prepare a single key.. based on concat
  #   "ABCCode", "Plan", "Country", "Indicator_Code", "Population_Type"
  tidyr::unite(col =  "keyctr", 
               all_of( c("ABC_Code", "Plan",
                         "Country" ) ), 
               na.rm = TRUE, 
               sep = "-",
               remove = FALSE)  |>
  tidyr::unite(col =  "keyctra", 
               all_of( c("ABC_Code",  
                         "Country" ) ), 
               na.rm = TRUE, 
               sep = "-",
               remove = FALSE)  |>
  
  dplyr::mutate(keyctr2 = dplyr::case_when( 
    keyctra == "ARG MC ABC-Argentina"    ~ "ARG_MCO-Argentina",
    keyctra ==   "ARG MC ABC-Bolivia"   ~ "ARG_MCO-Bolivia",
    keyctra ==  "ARG MC ABC-Chile"   ~ "CHL-Chile",
    keyctra ==     "ARG MC ABC-Paraguay"   ~ "ARG_MCO-Paraguay",
    keyctra ==  "ARG MC ABC-Uruguay"   ~ "ARG_MCO-Uruguay",
    keyctra ==     "BRA ABC-Brazil"     ~ "BRA-Brazil",
    keyctra ==   "CAN ABC-Canada"    ~ "CAN-Canada",
    keyctra ==    "COL ABC-Colombia"    ~ "COL-Colombia",
    keyctra ==   "CRI ABC-Costa Rica"   ~ "CRI-Costa Rica",
    keyctra ==   "ECU ABC-Ecuador"      ~ "ECU-Ecuador",
    keyctra ==  "GTM ABC-Guatemala"    ~ "GTM-Guatemala",
    keyctra ==   "HND ABC-Honduras"    ~ "HND-Honduras",
    keyctra ==  "MEX ABC-Mexico"    ~ "MEX-Mexico",
    keyctra ==    "PAN MC ABC-Aruba"      ~ "PAN_MCO-Aruba",
    keyctra ==  "PAN MC ABC-Cuba"     ~ "PAN_MCO-Cuba",
    keyctra ==   "PAN MC ABC-Curacao"     ~ "PAN_MCO-Curacao",
    keyctra ==  "PAN MC ABC-Guyana"    ~ "PAN_MCO-Guyana",
    keyctra ==    "PAN MC ABC-Panama"     ~ "PAN-Panama",
    keyctra ==  "PAN MC ABC-Trinidad and Tobago"   ~ "TTO-Trinidad and Tobago",
    keyctra ==   "PER ABC-Peru"   ~ "PER-Peru",
    keyctra ==  "SLV ABC-El Salvador"   ~ "SLV-El Salvador",
    keyctra ==   "USA MC ABC-Dominican Republic"   ~ "DOM-Dominican Rep.",
    keyctra ==   "VEN ABC-Venezuela"    ~ "VEN-Venezuela (Bolivarian Republic of)",
    TRUE ~ "NoMatch" ) ) |>
  
  dplyr::mutate(Population_Type2 = dplyr::case_when( 
    Population_Type == "Host Community"    ~ "Host Communities", 
    Population_Type == "Refugees and Asylum-seekers"    ~ "Refugees & Asylum-seekers", 
    Population_Type == "Stateless Persons"    ~ "Stateless", 
    Population_Type == "IDPs"    ~ "IDPs", 
    Population_Type == "Others of Concern"    ~ "Others of Concern", 
    TRUE ~ "NoMatch" ) ) |>
  
  
  tidyr::unite(col =  "key", 
               all_of( c("keyctr2", "Indicator_Code", "Population_Type2") ), 
               na.rm = TRUE, 
               sep = "-",
               remove = FALSE)  |>
  dplyr::filter(Region == "The Americas")

str(dataPBI1)

dataPBI1$Outcome_Target_or_Ouput_Target_OP

### Compare between PBI to Excel... ####


## A few check below - to make sure the match is ok now... que porqueria...
# table(dataPBI1$keyctr, useNA = "ifany")
# table(dataPBI1$keyctra, useNA = "ifany")
# levels(as.factor(dataPBI1$keyctra))
# levels(as.factor(data3b$keyctr))
# table(dataPBI1$keyctr2, useNA = "ifany")
# table(data3b$keyctr, useNA = "ifany")
# compare_ctr <- cbind( 
#     as.data.frame(table(dataPBI1$keyctr2, useNA = "ifany")),
#     as.data.frame(table(data3b$keyctr, useNA = "ifany")))
# names(compare_ctr)[1] <- "Ops"
# names(compare_ctr)[2] <- "Compass"
# names(compare_ctr)[4] <- "Sharepoint"
# compare_ctr[,3] <- NULL
# compare_ctr |> write.csv( "data/compare_indic_country_compass_sharepoint.csv")
#  
# as.data.frame(table(dataPBI1$Indicator_Code, useNA = "ifany")) 
# as.data.frame(table(data3b$indicator_code, useNA = "ifany"))
# 
# 
# table(data3b$population_label, useNA = "ifany")
# table(dataPBI1$Population_Type, useNA = "ifany")
# table(dataPBI1$Population_Type2, useNA = "ifany")
# 
# table(data3b$key, useNA = "ifany")
# table(dataPBI1$key, useNA = "ifany")


# levels(as.factor(data3$key))
# names(data3)
#paste(noquote(names(data3)), collapse = ', ') %>% cat()



# levels(as.factor(dataPBI1$keyctr  ))
# levels(as.factor(dataPBI1$key  ))
# #table(dataPBI1$key, useNA = "ifany" )
# 
# namesPBI <- as.data.frame(names(dataPBI1 ))

# compare_PBI_excelName <-  read_excel("data/compare_PBI_excel.xlsx", 
#                                        sheet = "Sheet1", 
#                                      skip = 1)|>
#   janitor::clean_names(  )  
# names(compare_PBI_excelName)

#paste(noquote(names(compare_PBI_excelName)), collapse = ', ') %>% cat()

compare_PBI_excel <- data3b  |> 
  dplyr::rename( "OperationSharePoint" = "Operation",
                 "keyctrSharePoint"= "keyctr") |>
  dplyr::full_join(dataPBI1 , by = c("key"  ))  |>
  dplyr::arrange(keyctr) |>
  dplyr::select(key, 
                keyctrSharePoint, 
                keyctr2,
                Indicator_Code,
                indicator_code,
                Indicator.y, Indicator.x,
                #OperationSharePoint, 
                #Operation,
                impact_area, 
                Impact_Area,
                outcome_area, 
                Outcome_Area,
                Ind_id, 
                Indicator_Code, indicator_code,
                population_label, Population_Type2,
                
                Baseline_Numerator, Baseline_Denominator, Baseline, Baseline_Data_Limitation, 
                Actual, Actual_Numerator, Actual_Denominator, Actual_Data_Limitation,
                Target_OL, 
                Outcome_Target_or_Ouput_Target_OP,
                baseline_2022_numerator, baseline_2022_denominator, baseline_2022_percent, 
                actual_2022_numerator, actual_2022_denominator, actual_2022_percent, 
                
                op_target_2022,
                baseline_2022_data_limitations_operations_notes_on_data_quality, 
                actual_2022_data_limitations_operations_notes_on_data_quality,
                Population_Type2, population_label
  )|>
  tidyr::unite(col =  "Indicator_Code1", 
               all_of( c("Indicator_Code", "indicator_code") ), 
               na.rm = TRUE, 
               sep = "-",
               remove = FALSE)  |>  
  tidyr::unite(col =  "country", 
               all_of( c("keyctrSharePoint", "keyctr2") ), 
               na.rm = TRUE, 
               sep = "-",
               remove = TRUE)  |>
  tidyr::unite(col =  "result_level", 
               all_of( c("impact_area", "Impact_Area", "outcome_area","Outcome_Area" ) ), 
               na.rm = TRUE, 
               sep = "-",
               remove = TRUE)  |>
  tidyr::unite(col =  "core_indicator", 
               all_of( c("Indicator.y", "Indicator.x") ), 
               na.rm = TRUE, 
               sep = "-",
               remove = FALSE)  |> 
  tidyr::unite(col =  "group", 
               all_of( c("Population_Type2", "population_label") ), 
               na.rm = TRUE, 
               sep = "-",
               remove = FALSE)  |>
  dplyr::rename(                      
    "compass_2022_baseline_numerator"= "Baseline_Numerator" ,      
    "excel_2022_baseline_numerator"=  "baseline_2022_numerator" ,        
    "compass_2022_baseline_denominator" = "Baseline_Denominator"  ,   
    "excel_2022_baseline_denominator"= "baseline_2022_denominator" ,     
    "compass_2022_baseline_data_limitations" = "Baseline_Data_Limitation",
    "excel_2022_baseline_data_limitations"="baseline_2022_data_limitations_operations_notes_on_data_quality"  ,
    "compass_2022_target" ="Outcome_Target_or_Ouput_Target_OP"  ,                
    "excel_2022_target" ="op_target_2022"  ,                  
    "compass_2022_actual_numerator"= "Actual_Numerator",         
    "excel_2022_actual_numerator"= "actual_2022_numerator"  ,         
    "compass_2022_actual_denominator"= "Actual_Denominator" ,      
    "excel_2022_actual_denominator" = "actual_2022_denominator",         
    "compass_2022_actual_data_limitations" = "Actual_Data_Limitation" , 
    "excel_2022_actual_data_limitations" ="actual_2022_data_limitations_operations_notes_on_data_quality",         
    "compass_ind" = "Indicator_Code" , 
    "excel_ind" ="indicator_code",         
    "compass_popgroup" = "Population_Type2" , 
    "excel_popgroup" ="population_label" )
#levels(as.factor(compare_PBI_excel$compass_2022_baseline_data_limitations))



## Compile the full match check

compare_PBI_excel2 <-compare_PBI_excel |>
  dplyr::select(key,Indicator_Code1, country, result_level, core_indicator,
                compass_2022_baseline_numerator, excel_2022_baseline_numerator, 
                compass_2022_baseline_denominator, excel_2022_baseline_denominator, 
                compass_2022_baseline_data_limitations,
                excel_2022_baseline_data_limitations,
                compass_2022_target, excel_2022_target, 
                compass_2022_actual_numerator, excel_2022_actual_numerator, 
                compass_2022_actual_denominator, excel_2022_actual_denominator, 
                compass_2022_actual_data_limitations, excel_2022_actual_data_limitations,
                compass_ind, excel_ind, 
                compass_popgroup, excel_popgroup)  |>
  dplyr::mutate(not_match_Indicators = dplyr::if_else( compass_ind == excel_ind &
                                                         !is.na(compass_ind)&
                                                         !is.na(excel_ind)|
                                                         (is.na(compass_ind) & is.na(excel_ind)) ,
                                                       NA,1 ) ) |>
  dplyr::mutate(not_match_PopGroup = dplyr::if_else( compass_popgroup == excel_popgroup &
                                                       !is.na(compass_popgroup )&
                                                       !is.na(excel_popgroup)|
                                                       (is.na(compass_popgroup) & is.na(excel_popgroup)) ,
                                                     NA,1 ) ) |>
  dplyr::mutate(not_match_target = dplyr::if_else( (round(compass_2022_target, 0) == round(excel_2022_target, 0) &
                                                                 !is.na(excel_2022_target) &
                                                                 !is.na(compass_2022_target)) |
                                                     (is.na(excel_2022_target) & is.na(compass_2022_target)) ,
                                                               NA,1 ) ) |>
  dplyr::mutate(not_match_baseline_numerator = dplyr::if_else( round(compass_2022_baseline_numerator, 0)== round(excel_2022_baseline_numerator, 0) &
                                                                 !is.na(compass_2022_baseline_numerator) &
                                                                 !is.na(excel_2022_baseline_numerator)|
                                                                 (is.na(excel_2022_baseline_numerator) & is.na(compass_2022_baseline_numerator)) ,
                                                               NA,1 ) ) |>
  dplyr::mutate(not_match_baseline_denominator = dplyr::if_else( round(compass_2022_baseline_denominator, 0)== round(excel_2022_baseline_denominator, 0) &
                                                                   !is.na(compass_2022_baseline_denominator) &
                                                                   !is.na(excel_2022_baseline_denominator)|
                                                                   (is.na(excel_2022_baseline_denominator) & is.na(compass_2022_baseline_denominator)) ,
                                                                 NA,1 ) ) |>
  dplyr::mutate(not_match_baseline_data_limitations = dplyr::if_else(compass_2022_baseline_data_limitations == excel_2022_baseline_data_limitations &
                                                                       !is.na(compass_2022_baseline_data_limitations) &
                                                                       !is.na(excel_2022_baseline_data_limitations)|
                                                                       (is.na(excel_2022_baseline_data_limitations) & is.na(compass_2022_baseline_data_limitations)) ,
                                                                     NA,1 ) ) |>
  dplyr::mutate(not_match_actual_numerator = dplyr::if_else( round(compass_2022_actual_numerator, 0)== round(excel_2022_actual_numerator, 0) &
                                                               !is.na(compass_2022_actual_numerator) &
                                                               !is.na(excel_2022_actual_numerator)|
                                                               (is.na(compass_2022_actual_numerator) & is.na(excel_2022_actual_numerator)) ,
                                                             NA,1 ) ) |>
  dplyr::mutate(not_match_actual_denominator = dplyr::if_else( round(compass_2022_actual_denominator, 0)== round(excel_2022_actual_denominator, 0) &
                                                                 !is.na(compass_2022_actual_denominator) &
                                                                 !is.na(excel_2022_actual_denominator)|
                                                                 (is.na(excel_2022_actual_denominator) & is.na(compass_2022_actual_denominator)) ,
                                                               NA,1 ) ) |>
  dplyr::mutate(not_match_actual_data_limitations = dplyr::if_else(compass_2022_actual_data_limitations == excel_2022_actual_data_limitations &
                                                                     !is.na(compass_2022_actual_data_limitations) &
                                                                     !is.na(excel_2022_actual_data_limitations)|
                                                                     (is.na(excel_2022_actual_data_limitations) & is.na(compass_2022_actual_data_limitations)) ,
                                                                   NA,1 ) )   |>
  dplyr::select(key, Indicator_Code1, country, 
               result_level, core_indicator, 
               
               not_match_baseline_numerator,
               compass_2022_baseline_numerator, excel_2022_baseline_numerator, 
               not_match_baseline_denominator,
               compass_2022_baseline_denominator, excel_2022_baseline_denominator, 
               not_match_baseline_data_limitations,
               compass_2022_baseline_data_limitations, excel_2022_baseline_data_limitations, 
               
               not_match_target,
               compass_2022_target, excel_2022_target, 
               
               not_match_actual_numerator,
               compass_2022_actual_numerator, excel_2022_actual_numerator, 
               not_match_actual_denominator, 
               compass_2022_actual_denominator, excel_2022_actual_denominator, 
               not_match_actual_data_limitations,
               compass_2022_actual_data_limitations, excel_2022_actual_data_limitations, 
               
               not_match_Indicators, 
               compass_ind, excel_ind, 
               
               not_match_PopGroup, 
               compass_popgroup, excel_popgroup)


#paste(noquote(names(compare_PBI_excel2)), collapse = ', ') %>% cat()





##merge PBI and excel 
data3 <- data3b  |> 
  dplyr::rename( "Operation1" = "Operation",
                 "keyctr1"= "keyctr") |>
  left_join(dataPBI1 , by = c("key"  )) 

names(data3)
## Merging back


# names(dataPBI)
# table(dataPBI$Operation)
# 
# 
# Ref <- dataPBI1 |>
#   dplyr::filter(Indicator_Type == "Core") |>
#   dplyr::select(Indicator_Code, Indicator,
#                 Impact_Area,
#                 #Impact_Statement,
#                 Outcome_Area,
#   #Outcome_Statement, Output_Statement, Output_Statement_COMPASS_Code,  Pillar,
#   #Situation,
#   Results_Level, Show_As,
#   #Indicator_Type,
#    Reverse_Indicator,
#   Reporting_Frequency#,
#   #Population_Type, Age, Gender, Disability
#   ) |>
#   dplyr::distinct() |>
#   dplyr::arrange(Indicator_Code)
# write.csv(Ref, here::here("data", "IndicReference.csv"),
#           row.names = FALSE)




# table(data3$Operation1, data3$results_level, useNA = "ifany")
# table(data3$Operation1, useNA = "ifany")
# paste(noquote(names(data3)), collapse = ', ') %>% cat()
# View(data3 |> dplyr::filter(Operation1 == "HND") |>  
#        dplyr::select( Operation1, results_level, impact_area, outcome_area, Level,
#                       indicator_type, Indicator.x, Ind_clean, Area, 
#                       Ind_id, population_type, population_type_clean,
#                       population_label,
#                       baseline_2022_numerator, baseline_2022_denominator, baseline_2022_percent, 
#                       actual_2022_numerator, actual_2022_denominator, actual_2022_percent,
#                       op_target_2022, op_target_2023, ol_target_2022)) 
# table(data3$Operation1, useNA = "ifany")
# table(data2$Operation, useNA = "ifany")




## Getting Population Data ###############

## Planning figure extracted from Compass
## https://unhcr-c1.board.com/#/screen/?capsulePath=RBM%20Planning%5CRBM%20Planning.bcps&screenId=19f6ec5a-5b48-4e37-9f0f-6a79f471a66c 
planningcompass <- readxl::read_excel(here::here("data","DataView.xlsx"), 
                                      sheet = "Layout 1")|>
  janitor::clean_names( "lower_camel") |>
  dplyr::filter( totalAssisted == "Total" ) |>
  # dplyr::select(country, countryOfOrigin, populationTypeStatistical, x2022) |>
  ## Creating the type used for Indicator reporting|>
  dplyr::mutate(populationIndicator = dplyr::case_when(
    populationTypeStatistical == "Asylum-Seekers" ~ "RAS",
    populationTypeStatistical == "Host Communities" ~ "HCT",
    populationTypeStatistical == "Internally Displaced Persons"   ~ "IDP",
    populationTypeStatistical == "Other People in need of International Protection" ~ "RAS",
    populationTypeStatistical == "Others of Concern" ~ "OOC",
    populationTypeStatistical == "Persons in IDP-like Situations" ~ "IDP",
    populationTypeStatistical == "Persons in refugee-like situations"  ~ "RAS",
    populationTypeStatistical == "Refugees"  ~ "RAS",
    populationTypeStatistical == "Returned IDPs"  ~ "RET",
    populationTypeStatistical == "Returned Refugees" ~ "RET",
    populationTypeStatistical == "Stateless" ~ "STA",
    TRUE ~ "" ) ) |>
  dplyr::group_by(country, populationIndicator )|>
  dplyr::summarise( ppf2022 = as.integer(sum(x2022, na.rm = TRUE)),
                    ppf2023 = as.integer(sum(x2023, na.rm = TRUE))) |>
  dplyr::ungroup() |>
  dplyr::mutate( keyPop = paste0(country, "_", populationIndicator)) |>
  dplyr::select(keyPop, ppf2022 , ppf2023)

compare <-  dplyr::left_join( x= ForcedDisplacementStat::end_year_population_totals_long, 
                              y= ForcedDisplacementStat::reference, 
                              by = c("CountryAsylumCode" = "iso_3")) |> 
  dplyr::filter( Year == 2022 &
                   UNHCRBureau  == "Americas" )|>
  dplyr::group_by(SUBREGION, code_op, CountryAsylumCode, CountryAsylumName, Population.type.label)|>
  dplyr::summarise( asr2022 = sum(Value, na.rm = TRUE)) |>
  dplyr::mutate(populationIndicator = dplyr::case_when(
    Population.type.label == "Asylum seekers" ~  "RAS",
    Population.type.label == "Host community" ~  "HCT",
    Population.type.label == "Internally displaced persons" ~  "IDP",
    Population.type.label == "Other people in need of international protection"~  "RAS",
    Population.type.label == "Others of concern to UNHCR"  ~  "OOC",
    Population.type.label ==  "Refugees" ~  "RAS",
    Population.type.label ==  "Stateless Persons" ~  "STA",
    TRUE ~ "Strange" ) ) |>
  dplyr::group_by(SUBREGION, code_op, CountryAsylumName, populationIndicator )|>
  dplyr::summarise( asr2022= as.integer(sum( asr2022, na.rm = TRUE)) ) |>
  dplyr::ungroup() |>
  ## Adjust a few country name for proper matching - Venezuela_  (Plurinational State of) 	United States of America
  
  dplyr::mutate(CountryAsylumName2 = stringr::str_replace(CountryAsylumName, " \\(Bolivarian Republic of\\)", ""),
                CountryAsylumName2 = stringr::str_replace(CountryAsylumName2, " \\(Plurinational State of\\)", ""),
                CountryAsylumName2 = stringr::str_replace(CountryAsylumName2, " of America", "")) |>
  dplyr::mutate( keyPop = paste0(CountryAsylumName2, "_", populationIndicator)) |>
  
  ## Now preparing PPF data           
  dplyr::left_join(planningcompass , by = c( "keyPop" )) |>
  dplyr::mutate( Operation = paste0(code_op, "/",CountryAsylumName)) |> 
  dplyr::select(SUBREGION, Operation, populationIndicator, asr2022, ppf2022 , keyPop ) |>
  ## Calculation person     
  dplyr::mutate(change_PPF_ASR = paste0(round( (ppf2022- asr2022)/asr2022*100,1), " %"),
                PPF_ASR =  ppf2022- asr2022 ) |>
  #dplyr::mutate(key2 =   paste0(Operation, "_",populationIndicator ) ) |>
  dplyr::mutate(Operation =  dplyr::if_else( is.na(PPF_ASR ), 
                                             paste0(Operation, " -> No PPF"), 
                                             paste0(Operation, " -> Planning ",
                                                    dplyr::if_else( PPF_ASR > 0, "+", ""), 
                                                    change_PPF_ASR) ) ) |>
  dplyr::filter( populationIndicator != "HCT")


#  Quality Assurance check ###############

data <- data3 |>
  # readxl::read_excel(here::here("data", "all_indicators.xlsx"), 
  #                          sheet = "RBA_indicators_consolidated") |>
  
  ## Match with asr /ppf 
  dplyr::mutate(Country_rename = stringr::str_replace(country, " \\(Bolivarian Republic of\\)", ""),
                Country_rename = stringr::str_replace(Country_rename, " \\(Plurinational State of\\)", ""),
                Country_rename = stringr::str_replace(Country_rename, " of America", ""),
                Country_rename = stringr::str_replace(Country_rename, "ublic", ".")) |>
  dplyr::mutate(keyPop = paste0(Country_rename, "_", population_type_clean)) |>
  dplyr::left_join(compare,    by = c( "keyPop" ) ) |>
  
  ## Match for population group
  dplyr::mutate( ras = as.character(ras),
                 sta = as.character(sta),
                 idp = as.character(idp),
                 ret = as.character(ret),
                 ooc = as.character(ooc),
                 ras = dplyr::if_else( ras == "1", "RAS", ras),
                 sta = dplyr::if_else( sta == "1", "STA", sta),
                 idp = dplyr::if_else( idp == "1", "IDP", idp),
                 ret = dplyr::if_else( ret == "1", "RET", ret),
                 ooc = dplyr::if_else( ooc == "1", "OOC", ooc)) |>
  
  tidyr::unite(col =  "popmatch", 
               all_of( c("ras", "sta", "idp", "ret", "ooc" ) ), 
               na.rm = TRUE, 
               sep = " ",
               remove = FALSE) |>
  
  ## Get all population type   "ras"   "sta"     "idp"     "ret"    "ooc"    
  
  ## Implement QA automatic Check 
  
  # __Comp1.__ All mandatory core impact indicators and core outcome indicators from relevant outcome areas have been selected for all relevant population groups
  dplyr::mutate(Comp1_1 = dplyr::if_else( is.na(population_type_clean), "Missing Population Type", NA ),
                Comp1_2 = dplyr::if_else( !( is.na(population_type_clean)) & 
                                            stringr::str_detect(population_type_clean ,popmatch),
                                          "Population Type not matching indicator", NA ) ) |>
  
  # __Comp2.__ Values for baselines, targets and actuals have been entered for all selected indicators and all relevant population groups
  dplyr::mutate(Comp2_1 = dplyr::if_else( is.na(actual_2022_percent), "Missing Actual", NA ),
                Comp2_2 = dplyr::if_else( is.na(baseline_2022_percent), "Missing Baseline", NA ),
                Comp2_3 = dplyr::if_else( is.na(op_target_2022) & results_level == "Outcome", "Missing Target", NA ) ) |>
  
  # __Comp3.__ Appropriate means of verification have been selected - aka data source is not empty
  dplyr::mutate(Comp3 = dplyr::if_else( is.na(data_source), "Missing Data Source", NA ) ) |>
  
  # __Comp4.__ Data limitations have been recorded for each indicator, as applicable - when no data is provided, while that indicator was selected for that population group 
  dplyr::mutate(Comp4 = dplyr::if_else( is.na(actual_2022_percent)   & 
                                          is.na(actual_2022_data_limitations_operations_notes_on_data_quality) ,
                                        "Missing Data limitations while there's no data", NA ) ) |> 
  
  # __Acc1.__ Percentage indicators are correctly calculated, when both numerator and baseline
  dplyr::mutate(Acc1_1 = dplyr::if_else( show_as == "Percent"   & 
                                           is.na(actual_2022_numerator) ,
                                         "Numerator for Actual is missing", NA ),
                Acc1_2 = dplyr::if_else( show_as == "Percent"   & 
                                           is.na(actual_2022_denominator) ,
                                         "Denominator for Actual is missing", NA ),
                Acc1_3 = dplyr::if_else( show_as == "Percent"   & 
                                           !( is.na(actual_2022_denominator)& 
                                                is.na(actual_2022_numerator) & 
                                                is.na(actual_2022_percent)) &
                                           round(actual_2022_percent,0) != round((actual_2022_numerator/actual_2022_denominator *100),0),
                                         "Percentage Calculation for Actual is not correct", NA ),
                Acc1_4 = dplyr::if_else( show_as == "Percent"   & 
                                           is.na(baseline_2022_numerator) ,
                                         "Numerator for baseline is missing", NA ),
                Acc1_5 = dplyr::if_else( show_as == "Percent"   & 
                                           is.na(baseline_2022_denominator) ,
                                         "Denominator for baseline is missing", NA ),
                Acc1_6 = dplyr::if_else( show_as == "Percent"   & 
                                           !( is.na(baseline_2022_denominator)& 
                                                is.na(baseline_2022_numerator) & 
                                                is.na(baseline_2022_percent)) &
                                           round(baseline_2022_percent,0) != round((baseline_2022_numerator/baseline_2022_denominator *100),0),
                                         "Percentage Calculation for baseline is not correct", NA ) ) |> 
  
  # __Acc2.__ Appropriate scales are used for text indicators. If a text unit, should be between 1 & 3
  dplyr::mutate(Acc2_1 = dplyr::if_else( show_as == "Text"   &  
                                           !( is.na(actual_2022_percent)) &
                                           !( actual_2022_percent %in% c(1,2,3)) ,
                                         "Appropriate scales is not used for actual text indicators", NA ),
                Acc2_2 = dplyr::if_else( show_as == "Text"   & 
                                           !( is.na(baseline_2022_percent)) &
                                           !( baseline_2022_percent %in% c(1,2,3)) ,
                                         "Appropriate scales is not used for baseline text indicators", NA ) ) |> 
  
  # __Acc3.__ Units of measurements are consistently used for baselines, actuals and targets. , if pecent between 0 & 100, if a number no denominator 
  dplyr::mutate(Acc3_1 = dplyr::if_else( show_as == "Percent"   &  
                                           !( is.na(actual_2022_percent)) &
                                           ( actual_2022_percent < 0 | actual_2022_percent >100) ,
                                         "Appropriate scales is not used for actual percent indicators", NA ),
                Acc3_2 = dplyr::if_else( show_as == "Percent"   & 
                                           !( is.na(baseline_2022_percent)) &
                                           ( baseline_2022_percent <0 | baseline_2022_percent >100) ,
                                         "Appropriate scales is not used for baseline percent indicators", NA ) ) |> 
  
  # __Acc4.__ The approach to missing values is correct, i.e., the use of “0” vs NA
  
  # __Acc5.__ The relationship between baseline and target data is logical, e.g., targets are equal to or higher than the baselines
  dplyr::mutate(Acc5_1 = dplyr::if_else( standard_direction == "more_or_equal"   &  
                                           results_level == "Outcome" &
                                           !( is.na(baseline_2022_percent)) & 
                                           !( is.na(op_target_2022)) &
                                           op_target_2022 < baseline_2022_percent ,
                                         "Target value is below the baseline", NA ) ,
                Acc5_2 = dplyr::if_else( standard_direction == "less_or_equal"   &  
                                           results_level == "Outcome" & 
                                           !( is.na(baseline_2022_percent)) & 
                                           !( is.na(op_target_2022)) &
                                           op_target_2022 > baseline_2022_percent ,
                                         "Target value is above the baseline", NA ) ,
                Acc5_3 = dplyr::if_else( standard_direction == "more_or_equal"   &  
                                           results_level == "Outcome" & 
                                           !( is.na(threshold_green)) & 
                                           !( is.na(op_target_2022)) &
                                           op_target_2022 < threshold_green ,
                                         "Target value is below acceptable standard", NA ) ,
                Acc5_4 = dplyr::if_else( standard_direction == "less_or_equal"   &  
                                           results_level == "Outcome" & 
                                           !( is.na(threshold_green)) & 
                                           !( is.na(op_target_2022)) &
                                           op_target_2022 > threshold_green ,
                                         "Target value is above acceptable standard", NA )  )   |>
  
  # __Cons1.__ Detect strange issue
  dplyr::mutate(Cons1_1 = dplyr::if_else( show_as == "Percent"    &  
                                            results_level == "Outcome" &
                                            !( is.na(baseline_2022_percent)) & 
                                            !( is.na(op_target_2022)) &
                                            abs(op_target_2022 - baseline_2022_percent) > 40 ,
                                          "More than 40% difference between Target and Baseline", NA ) ,
                Cons1_2 = dplyr::if_else( show_as == "Percent"  & 
                                            !( is.na(baseline_2022_percent)) & 
                                            !( is.na(actual_2022_percent)) &
                                            abs(actual_2022_percent - baseline_2022_percent) > 40 ,
                                          "More than 20% difference between Actual and Baseline", NA ) ,
                Cons1_3 = dplyr::if_else( show_as == "Percent"   & 
                                            !( is.na(baseline_2022_denominator) ) &
                                            !( is.na(asr2022)) &
                                            baseline_2022_denominator > asr2022 ,
                                          "Baseline Denominator is superior to last public release of ASR data", NA ) ,
                Cons1_4 = dplyr::if_else( show_as == "Percent"   & 
                                            !( is.na(actual_2022_denominator) ) &
                                            !( is.na(asr2022)) &
                                            actual_2022_denominator > asr2022 ,
                                          "Actual Denominator is superior to last public release of ASR data", NA )  )   |>
  
  
  ## Summary QA
  tidyr::unite(col =  "QA_logical", 
               all_of( c("Comp2_1","Comp2_2","Comp2_3", 
                         "Comp3",
                         "Comp4",
                         "Acc1_1","Acc1_2","Acc1_3",
                         "Acc1_4","Acc1_5","Acc1_6",
                         "Acc2_1","Acc2_2",  
                         "Acc3_1","Acc3_2", 
                         "Acc5_1","Acc5_2","Acc5_3","Acc5_4", 
                         "Cons1_1","Cons1_2","Cons1_3","Cons1_4" ) ), 
               na.rm = TRUE, 
               sep = " - ",
               remove = FALSE) 


### Sot Check Control -- 
# names(data)
# paste(noquote(names(data)), collapse = ', ') %>% cat()
# 
# View(data |> dplyr::select(Operation1,  country, indicator, show_as, actual_2022_numerator, actual_2022_denominator, actual_2022_percent, Acc1_3))
# 
# 
# 
# View(data |> dplyr::select(Operation1,  country, indicator, show_as, actual_2022_numerator, actual_2022_denominator, actual_2022_percent,  asr2022, Cons1_4, Cons1_3))


# View(data |> 
#        dplyr::filter(Operation1 == "HND") |>
#        dplyr::select(Operation1,  country, indicator, show_as, actual_2022_numerator, actual_2022_denominator, actual_2022_percent, Acc3_1))



dataQA <- data |>
  #dplyr::select( key, keyctr1, Operation1, country_countries, country, SUBREGION, 
  #impact_area, outcome_area, Level, indicator_type, Indicator.x, Ind_clean, Area,
  #Ind_num, Ind_id, population_type, population_type_clean, population_label, baseline_2022_numerator, baseline_2022_denominator, baseline_2022_percent, actual_2022_numerator, actual_2022_denominator, actual_2022_percent, op_target_2022, op_target_2023, ol_target_2022, disaggregation, disag_PopulationType, disag_Age, disag_Gender, disag_Disability, disag_Origin, disag_Nation, data_source, additional_data_source, data_sources_comment, m_e_activity, m_e_activity_comment, data_collection_frequency, responsibility_internal, responsibility_external, baseline_2022_data_limitations_operations_notes_on_data_quality, actual_2022_data_limitations_operations_notes_on_data_quality, programme_monitoring_and_dima_feedback_technical, technical_lead_operations_team_or_other_mft_member_feedback_strategic, output_statement_or_short_description, output_code, reporting_requirements_r4v_rba_hrp_unsdcf_msm_etc, relevant_sites_offices_or_field_locations, partners_direct_implementation, area_of_work, theme, subtheme, rba_focal_point, results_level, area_id, area, number, indicator, show_as, indicator_code, reverse, reporting_frequency, indicator_lab2, indicator_unit2, unitcheck, acceptable_standard, threshold_red, threshold_orange, threshold_green, standard_direction, survey, relevant_population_types, popmatch, ras, sta, idp, ret, ooc, all, den, max, denominator_for_baselines_and_actuals, contextual_sectoral_or_thematic_considerations_for_baselines_and_actuals, targets, Region, SubRegion, Operation, Operation_Type, Strategy, keyctr, Plan, ABCCode, Country, Year, Impact_Area, Impact_Statement, Outcome_Area, Outcome_Statement, Output_Statement, Output_Statement_COMPASS_Code, Pillar, Situation, Results_Level, Show_As, Indicator_Type, Indicator_Code, Reverse, Reporting_Frequency, Indicator.y, Population_Type, Age, Gender, Disability, Site, Baseline, Baseline_Numerator, Baseline_Denominator, Baseline_Data_Limitation, Actual, Actual_Numerator, Actual_Denominator, Actual_Data_Limitation, Outcome_Target_or_Ouput_Target _OP, Target_OL, Data_Sources, Additional_Data_Sources, Data_Sources_Comment, M&E_Activity, Comment, Data_Collection_Frequency, Responsibility_Internal, Responsibility_External, keyctr2, Comp1_1, Comp1_2, QA_logical, Comp2_1, Comp2_2, Comp2_3, Comp3, Comp4, Acc1_1, Acc1_2, Acc1_3, Acc2_1, Acc2_2, Acc3_1, Acc3_2, Acc5_1, Acc5_2, Acc5_3, Acc5_4)
  dplyr::select( SUBREGION.x, Operation1,  country, impact_area, outcome_area, Level, 
                 indicator_type,   area,  
                 indicator, show_as, indicator_code, Ind_id,  theme, subtheme, rba_focal_point, 
                 QA_logical,
                 baseline_2022_numerator, baseline_2022_denominator, 
                 baseline_2022_percent, 
                 actual_2022_numerator, actual_2022_denominator, actual_2022_percent, 
                 op_target_2022, #op_target_2023, 
                # ol_target_2022, 
                 
                 population_type_clean, population_label,
                 disag_PopulationType, disag_Age, disag_Gender, disag_Disability, disag_Origin, disag_Nation, 
                 data_source, additional_data_source, data_sources_comment, m_e_activity, m_e_activity_comment,
                 data_collection_frequency, responsibility_internal, responsibility_external, 
                 baseline_2022_data_limitations_operations_notes_on_data_quality,
                 actual_2022_data_limitations_operations_notes_on_data_quality, 
                 
                 #relevant_sites_offices_or_field_locations, partners_direct_implementation, area_of_work, results_level, area_id, 
                 
                 threshold_red, threshold_orange, threshold_green, standard_direction, survey, 
                 popmatch, 
                 Comp1_1, Comp1_2,  Comp2_1, Comp2_2, Comp2_3, Comp3, Comp4, Acc1_1, Acc1_2,
                 Acc1_3, Acc2_1, Acc2_2, Acc3_1, Acc3_2, Acc5_1, Acc5_2, Acc5_3, Acc5_4,
                 Cons1_1, Cons1_2, Cons1_3, Cons1_4)





## Review coverage in terms of population type and disag 
## This needs to be re-calculated anyway...
# QA_PopType <- read_excel(here::here("data", "QA.xlsx"), 
#                          sheet = "QA by Pop Types", skip = 1)|>
#   janitor::clean_names()
# Pop_type_Coverage <- data3 |>  
#   dplyr::select(Operation, country_countries, population_type_clean, indicator_type) |>
#   dplyr::filter(indicator_type == "Core") |>
#   #dplyr::distinct( ) |>
#   dplyr::group_by(Operation, country_countries, population_type_clean) |>
#   dplyr::summarise( CoreInd_num = dplyr::n())
# 
# 
# 
# #names(data)
# #levels(as.factor(data$indicator_type))
# Disag_Coverage <- data3 |>  
#   #dplyr::filter(indicator_type == "Core") |>
#   dplyr::filter(Level == "OutcomeCore") |>
#   # dplyr::filter( stringr::str_detect(indicator_type , 'OA')) |>
#   # dplyr::filter( substr(  indicator_type , "OA")) |>
#   dplyr::group_by(Operation, outcome_area, disaggregation, population_type) |>
#   dplyr::summarise( nind = dplyr::n())



## Check indicator selection based on what is defined by country  


# paste(names(QA_OutcomeArea), collapse = '", "') %>% cat()
# 
# OutComeIndic <- QA_Indic |>
#   #dplyr::filter(indicator_type == "Core") |>
#   dplyr::filter(results_level == "Outcome") |>
#   dplyr::group_by(area) |>
#   dplyr::summarise( CoreInd_num = dplyr::n())
# 
# ## Outcome coverage by Country  
# QA_OutcomeArea <- read_excel(here::here("data", "QA.xlsx"), 
#                              sheet = "QA by OA", skip = 2) |>
# #  janitor::clean_names()   |> 
#  tidyr::pivot_longer(
#    cols=c("ARG_MCO", "CHL", "BRA", "CAN", "COL", "CRI", "ECU", "SLV", "GTM", 
#           "HND", "MEX", "PAN_MCO", "PAN", "TTO", "PER", "USA_MCO", "DOM", "VEN"),
#    names_to='Operation',
#    values_to='TO_Select',
#    values_drop_na = TRUE
#  ) |>
#   dplyr::filter(!(is.na(Area))) |>
#   dplyr::left_join( OutComeIndic, by = c("Area"= "area")) #|>
#  # dplyr::left_join( QA_Indic, by = c("Area"= "area"))

# paste(noquote(names(QA_OutcomeArea)), collapse = ', ') %>% cat()



#paste(noquote(names(thisdata)), collapse = ', ') %>% cat()


#paste(noquote(names(data3)), collapse = ', ') %>% cat()




#  Save files ###############

## Saving the merged excel and upload for review ###############

all_indicators <- "out/all_indicators.xlsx"
sheetname <- "RBA_indicators_consolidated" 

wb <- openxlsx::createWorkbook()
openxlsx::addWorksheet(wb, sheetname)
openxlsx::writeData(wb, 
                    sheet = sheetname, 
                    x = data3, 
                    withFilter = TRUE)

openxlsx::setColWidths(wb, sheetname, cols = 1:ncol(data3), widths = "auto")

#For better legibility create specific styles for rows that defines header
headerSt <- openxlsx::createStyle( textDecoration = "bold", fontColour = "white", fontSize = 13, fgFill = "grey50",
                                   border = "TopBottom", borderColour = "grey80", borderStyle = "thin")

hdr.rows <- 1
openxlsx::addStyle(wb, sheetname, headerSt, hdr.rows, 1:ncol(data3), gridExpand = TRUE) 
if (file.exists( all_indicators)) file.remove( all_indicators)
openxlsx::saveWorkbook(wb,  all_indicators)









## Save with QA ############

all_indicatorsQA <- "out/QAindicators.xlsx"
sheetname <- "RBA_indicators_CoreQAd" 

wb <- openxlsx::createWorkbook()
openxlsx::addWorksheet(wb, sheetname)
openxlsx::writeData(wb, 
                    sheet = sheetname, 
                    x = dataQA, 
                    withFilter = TRUE)

openxlsx::setColWidths(wb, sheetname, cols = 1:ncol(dataQA), widths = "auto")

#For better legibility create specific styles for rows that defines header
headerSt <- openxlsx::createStyle( textDecoration = "bold", fontColour = "white", fontSize = 13, fgFill = "grey50",
                                   border = "TopBottom", borderColour = "grey80", borderStyle = "thin")

hdr.rows <- 1
openxlsx::addStyle(wb, sheetname, headerSt, hdr.rows, 1:ncol(dataQA), gridExpand = TRUE) 
if (file.exists( all_indicatorsQA)) file.remove( all_indicatorsQA)
openxlsx::saveWorkbook(wb,  all_indicatorsQA)



## Save PBI Compare #####
compare_PBI_excel3 <- "out/compare_PBI_excel4.xlsx"
sheetname <- "compare_PBI_excel" 

wb <- openxlsx::createWorkbook()
openxlsx::addWorksheet(wb, sheetname)
openxlsx::writeData(wb, 
                    sheet = sheetname, 
                    x = compare_PBI_excel2, 
                    withFilter = TRUE)

openxlsx::setColWidths(wb, sheetname, cols = 1:ncol(compare_PBI_excel2), widths = "auto")

#For better legibility create specific styles for rows that defines header
headerSt <- openxlsx::createStyle( textDecoration = "bold", fontColour = "white", fontSize = 13, fgFill = "grey50",
                                   border = "TopBottom", borderColour = "grey80", borderStyle = "thin")

hdr.rows <- 1
openxlsx::addStyle(wb, sheetname, headerSt, hdr.rows, 1:ncol(compare_PBI_excel2), gridExpand = TRUE) 
if (file.exists( compare_PBI_excel3)) file.remove( compare_PBI_excel3)
openxlsx::saveWorkbook(wb,  compare_PBI_excel3)



## Upload back to Sharepoint 

#  Archive all Results in sharepoint ######
url <- "https://unhcr365.sharepoint.com/teams/amer-rbap"
site <- Microsoft365R::get_sharepoint_site(site_url= url)

## List of all sharepoint items directly in the root folder of the site... 
drv <- site$get_drive()


## PBI Excel comparison
drv$upload_file(src = "out/compare_PBI_excel4.xlsx", 
                dest = paste0("02 Operations/04. RBM - COMPASS/07. Results Framework and M&E/05. Indicators/03. Core Indicator Quality Assurance/2022 Year-End Reporting/02_Data_Consolidated/Compare_PBI_excel_v_",
                              format(Sys.Date(),
                                     '%d %B %Y'), 
                              ".xlsx") )

drv$upload_file(src =  "out/all_indicators.xlsx", 
                dest = paste0("02 Operations/04. RBM - COMPASS/07. Results Framework and M&E/05. Indicators/03. Core Indicator Quality Assurance/2022 Year-End Reporting/02_Data_Consolidated/all_indicators_v_",
                              format(Sys.Date(),
                                     '%d %B %Y'), 
                              ".xlsx") )

drv$upload_file(src =  "out/QAindicators.xlsx", 
                dest = paste0("02 Operations/04. RBM - COMPASS/07. Results Framework and M&E/05. Indicators/03. Core Indicator Quality Assurance/2022 Year-End Reporting/02_Data_Consolidated/all_indicatorsQA_v_",
                              format(Sys.Date(),
                                     '%d %B %Y'), 
                              ".xlsx") )

