#  Aggregate all country information into a single frame ######
library(tidyverse)
library(readxl)

### List the file ##########
# with the Indicator reporting based on pattern in file name
listfile <-
  fs::dir_ls( here::here("data-raw",""),
              recurse = TRUE,
              regexp = "MoV and 2022 Indicator Reporting.xlsx") |>
  set_names()
## How many files is that?
length(listfile)
listfile
# pattern <-  "ABC_.*\\.csv"
# 
# regexp = fs::path(path, pattern)

## get the list with only plan id..
ops <- as.data.frame(listfile) |>
  dplyr::mutate(file = stringr::str_remove(listfile, paste0(here::here(),"/"))) |>
  dplyr::mutate(Operation = stringr::str_remove(file, "_MoV and 2022 Indicator Reporting.xlsx")) |>
  dplyr::mutate(Operation = stringr::str_remove(Operation, "data-raw/")) |>
  dplyr::select(Operation) 
ops$path <- row.names(ops)
ops$Operation


### Now let's get the list of Country ready for aggregation... ##############
QA_Ops <- read_excel(here::here("data", "QA.xlsx"), 
                     sheet = "QA per operation", skip = 1) |>
  janitor::clean_names()

#names(QA_Ops)

### List data ready for consolidation
toreview <- QA_Ops |> 
  dplyr::filter( !(is.na(link_to_share_point_document_where_feedback_should_be_included))) |>
  dplyr::pull(code)
opsfile <- ops |>
  dplyr::filter( Operation %in% c(toreview  )) |>
  dplyr::pull(path) |>
  set_names()



## Function to load and collate all spreadsheet.. ############## 
#   janitor::clean_names( "lower_camel") |>
read_mov <- function(f) {
  dplyr::bind_rows(ImpactCore = possibly(read_excel, 
                                         otherwise = tibble())(f,  
                                                               sheet = "MoV Table_Impact", 
                                                               skip = 1 )|>
                     janitor::clean_names() |>
                     ## Add country var if it does not exist...  ##
                     dplyr::mutate( country_countries =  if("country_countries" %in% colnames(across(everything())) ) country_countries else "") |>
                     dplyr::select(country_countries, impact_area, indicator_type, core_impact_indicator,
                                   user_defined_impact_indicator, population_type, 
                                   disaggregation, data_source, additional_data_source,
                                   data_sources_comment, m_e_activity, m_e_activity_comment,
                                   data_collection_frequency, responsibility_internal,
                                   responsibility_external, baseline_2022_numerator,
                                   baseline_2022_denominator, baseline_2022_percent,
                                   baseline_2022_data_limitations_operations_notes_on_data_quality,
                                   actual_2022_numerator, actual_2022_denominator, 
                                   actual_2022_percent, 
                                   actual_2022_data_limitations_operations_notes_on_data_quality,
                                   # baseline_2023_numerator, baseline_2023_denominator, 
                                   # baseline_2023_percent, 
                                   # baseline_2023_data_limitations_operations_notes_on_data_quality,
                                   # programme_monitoring_and_dima_feedback_technical,
                                   # technical_lead_operations_team_or_other_mft_member_feedback_strategic, 
                                   regional_bureau_feedback,
                                   operation_response_to_bureau_feedback)  |>
                     dplyr::mutate(across(everything(), as.character)) |>
                     dplyr::mutate_at(c('baseline_2022_numerator',
                                        'baseline_2022_denominator', 
                                        'baseline_2022_percent',  
                                        'actual_2022_numerator', 
                                        'actual_2022_denominator', 
                                        'actual_2022_percent'#, 
                                        #'baseline_2023_numerator', 
                                        #'baseline_2023_denominator', 
                                        #'baseline_2023_percent'
                     ), as.numeric) ,
                   
                   OutcomeCore = possibly(read_excel, otherwise = tibble())(f, 
                                                                            sheet = "MoV Table_Outcome",
                                                                            skip = 1)|>
                     janitor::clean_names() |>
                     ## Add country var if it does not exist...  ##
                     dplyr::mutate( country_countries =  if("country_countries" %in% colnames(across(everything())) ) country_countries else "") |>
                     dplyr::select(country_countries, impact_area, outcome_area, indicator_type,
                                   core_outcome_indicator, user_defined_outcome_indicator,
                                   population_type, disaggregation, data_source, 
                                   additional_data_source, data_sources_comment, 
                                   m_e_activity, m_e_activity_comment, 
                                   data_collection_frequency, responsibility_internal,
                                   responsibility_external, 
                                   baseline_2022_numerator, 
                                   baseline_2022_denominator, 
                                   baseline_2022_percent, 
                                   baseline_2022_data_limitations_operations_notes_on_data_quality,
                                   actual_2022_numerator, 
                                   actual_2022_denominator, 
                                   actual_2022_percent, 
                                   actual_2022_data_limitations_operations_notes_on_data_quality,
                                   # baseline_2023_numerator, 
                                   # baseline_2023_denominator, 
                                   # baseline_2023_percent, 
                                   # baseline_2023_data_limitations_operations_notes_on_data_quality,
                                   op_target_2022, 
                                   # op_target_2023,
                                   # programme_monitoring_and_dima_feedback_technical,
                                   # technical_lead_operations_team_or_other_mft_member_feedback_strategic, 
                                   regional_bureau_feedback,
                                   operation_response_to_bureau_feedback)  |>
                     dplyr::mutate(across(everything(), as.character)) |>
                     dplyr::mutate_at(c('baseline_2022_numerator',
                                        'baseline_2022_denominator', 
                                        'baseline_2022_percent',  
                                        'actual_2022_numerator', 
                                        'actual_2022_denominator', 
                                        'actual_2022_percent', 
                                        # 'baseline_2023_numerator', 
                                        # 'baseline_2023_denominator', 
                                        # 'baseline_2023_percent',
                                        'op_target_2022'#,
                                        #'op_target_2023'
                     ), as.numeric)  ,
                   
                   # Output = possibly(read_excel, otherwise = tibble())(f,
                   #                                                     sheet = "MoV Table_Output",
                   #                                                     skip = 1)|>
                   #   janitor::clean_names() |>
                   #   ## Add country var if it does not exist...  ##
                   #   dplyr::mutate( country_countries =  if("country_countries" %in% colnames(across(everything())) ) country_countries else "") |>
                   #   dplyr::select(country_countries, impact_area, outcome_area, 
                   #                 output_statement_or_short_description, 
                   #                 output_code, user_defined_output_indicator,
                   #                 reporting_requirements_r4v_rba_hrp_unsdcf_msm_etc,
                   #                 relevant_sites_offices_or_field_locations, 
                   #                 partners_direct_implementation, 
                   #                 population_type, disaggregation, 
                   #                 data_source, additional_data_source,
                   #                 data_sources_comment, m_e_activity,
                   #                 m_e_activity_comment, data_collection_frequency, 
                   #                 responsibility_internal, 
                   #                 responsibility_external, 
                   #                 op_target_2022, 
                   #                 ol_target_2022, 
                   #                 numerator_actual_2022, 
                   #                 denominator_actual_2022, 
                   #                 percent_actual_2022,
                   #                 actual_2022_data_limitations_operations_notes_on_data_quality,
                   #                 # programme_monitoring_and_dima_feedback_technical,
                   #                 # technical_lead_operations_team_or_other_mft_member_feedback_strategic, 
                   #                 regional_bureau_feedback,
                   #                 operation_response_to_bureau_feedback) |>
                   #   dplyr::rename(actual_2022_numerator = numerator_actual_2022, 
                   #                 actual_2022_denominator = denominator_actual_2022, 
                   #                 actual_2022_percent = percent_actual_2022 ) |>
                   #   dplyr::mutate(across(everything(), as.character)) |>
                   #   dplyr::mutate_at(c('actual_2022_numerator', 
                   #                      'actual_2022_denominator', 
                   #                      'actual_2022_percent', 
                   #                      'op_target_2022',
                   #                      'ol_target_2022'), as.numeric),
                   
                   .id = "Level")
}


## Testing the common file format to enforce it ####
## Test with Files....

#opsfile
#debugonce(read_mov)
for (i in (1:length(opsfile))) {
  file <- opsfile[i]
  cat(paste0(i," - ", opsfile[i], "\n"))
  # ## test the function with one op..
  data_test2 <- read_mov(file)
}

#' 
#' file <- opsfile[17]
#' # impact
#' TableImpact <- read_excel(file ,
#'                           sheet = "MoV Table_Impact",
#'                           skip = 1) |>
#'   janitor::clean_names() |>    
#'   dplyr::mutate( country_countries =  if("country_countries" %in% colnames(across(everything())) ) country_countries else "") |>
#' 
#'    dplyr::select(  country_countries,  impact_area, indicator_type, core_impact_indicator,
#'                 user_defined_impact_indicator, population_type,
#'                 disaggregation, data_source, additional_data_source,
#'                 data_sources_comment, m_e_activity, m_e_activity_comment,
#'                 data_collection_frequency, responsibility_internal,
#'                 responsibility_external, baseline_2022_numerator,
#'                 baseline_2022_denominator, baseline_2022_percent,
#'                 baseline_2022_data_limitations_operations_notes_on_data_quality,
#'                 actual_2022_numerator, actual_2022_denominator,
#'                 actual_2022_percent,
#'                 actual_2022_data_limitations_operations_notes_on_data_quality,
#'                 # baseline_2023_numerator, baseline_2023_denominator,
#'                 # baseline_2023_percent,
#'                 # baseline_2023_data_limitations_operations_notes_on_data_quality,
#'                 # programme_monitoring_and_dima_feedback_technical,
#'                 # technical_lead_operations_team_or_other_mft_member_feedback_strategic, 
#'                 regional_bureau_feedback,
#'                 operation_response_to_bureau_feedback)|>
#'   dplyr::mutate_at(c('baseline_2022_numerator',
#'                      'baseline_2022_denominator',
#'                      'baseline_2022_percent',
#'                      'actual_2022_numerator',
#'                      'actual_2022_denominator',
#'                      'actual_2022_percent'#,
#'                      #'baseline_2023_numerator',
#'                      #'baseline_2023_denominator',
#'                      #'baseline_2023_percent'
#'   ), as.numeric)
#' paste(noquote(names(TableImpact)), collapse = ', ') %>% cat()
#' 
#' # outcome
#' TableOutcome <- read_excel(file ,
#'                            sheet = "MoV Table_Outcome",
#'                            skip = 1)|>
#'   janitor::clean_names()   |>
#'   dplyr::select(impact_area, outcome_area, indicator_type,
#'                 core_outcome_indicator, user_defined_outcome_indicator,
#'                 population_type, disaggregation, data_source,
#'                 additional_data_source, data_sources_comment,
#'                 m_e_activity, m_e_activity_comment,
#'                 data_collection_frequency, responsibility_internal,
#'                 responsibility_external,
#'                 baseline_2022_numerator,
#'                 baseline_2022_denominator,
#'                 baseline_2022_percent,
#'                 baseline_2022_data_limitations_operations_notes_on_data_quality,
#'                 actual_2022_numerator,
#'                 actual_2022_denominator,
#'                 actual_2022_percent,
#'                 actual_2022_data_limitations_operations_notes_on_data_quality,
#'                 # baseline_2023_numerator,
#'                 # baseline_2023_denominator,
#'                 # baseline_2023_percent,
#'                # baseline_2023_data_limitations_operations_notes_on_data_quality,
#'                 op_target_2022,
#'               #  op_target_2023,
#'               # programme_monitoring_and_dima_feedback_technical,
#'               # technical_lead_operations_team_or_other_mft_member_feedback_strategic, 
#'               regional_bureau_feedback,
#'                 operation_response_to_bureau_feedback) |>
#'   dplyr::mutate_at(c('baseline_2022_numerator',
#'                      'baseline_2022_denominator',
#'                      'baseline_2022_percent',
#'                      'actual_2022_numerator',
#'                      'actual_2022_denominator',
#'                      'actual_2022_percent',
#'                      # 'baseline_2023_numerator',
#'                      # 'baseline_2023_denominator',
#'                      # 'baseline_2023_percent',
#'                      'op_target_2022'#,
#'                      #'op_target_2023'
#'                      ), as.numeric)
#' # paste(noquote(names(TableOutcome)), collapse = ', ') %>% cat()
#' 
#' # output
#' TableOutput <- read_excel(file ,
#'                           sheet = "MoV Table_Output",
#'                           skip = 1)|>
#'   janitor::clean_names() |>
#'   dplyr::select(impact_area, outcome_area,
#'                 output_statement_or_short_description,
#'                 output_code, user_defined_output_indicator,
#'                 reporting_requirements_r4v_rba_hrp_unsdcf_msm_etc,
#'                 relevant_sites_offices_or_field_locations,
#'                 partners_direct_implementation,
#'                 population_type, disaggregation,
#'                 data_source, additional_data_source,
#'                 data_sources_comment, m_e_activity,
#'                 m_e_activity_comment, data_collection_frequency,
#'                 responsibility_internal,
#'                 responsibility_external,
#'                 op_target_2022,
#'                 ol_target_2022,
#'                 numerator_actual_2022,
#'                 denominator_actual_2022,
#'                 percent_actual_2022,
#'                 actual_2022_data_limitations_operations_notes_on_data_quality,
#'                 # programme_monitoring_and_dima_feedback_technical,
#'                 # technical_lead_operations_team_or_other_mft_member_feedback_strategic, 
#'                 regional_bureau_feedback,
#'                 operation_response_to_bureau_feedback)|>
#'   dplyr::rename(actual_2022_numerator = numerator_actual_2022,
#'                 actual_2022_denominator = denominator_actual_2022,
#'                 actual_2022_percent = percent_actual_2022 ) |>
#'   dplyr::mutate_at(c('actual_2022_numerator',
#'                      'actual_2022_denominator',
#'                      'actual_2022_percent',
#'                      'op_target_2022',
#'                      'ol_target_2022'), as.numeric)
#' paste(noquote(names(TableOutput)), collapse = ', ') %>% cat()
#' 
#' data_test1 <-  dplyr::bind_rows( TableImpact, TableOutcome , TableOutput)



# ## aggregate and add the name of the file together... 
# data_test3 <- file |> 
#    map_dfr(possibly(read_mov, tibble()), .id = "Operation")

## Simple function for na
all_na <- function(x) any(!is.na(x))


#debugonce(read_mov)
## Now getting everything together... 
data <- opsfile |> 
  map_dfr(possibly(read_mov, tibble()), .id = "Operation") |>
  dplyr::mutate(Operation = stringr::str_remove(Operation, paste0(here::here(),"/"))) |>
  dplyr::mutate(Operation = stringr::str_remove(Operation, "_MoV and 2022 Indicator Reporting.xlsx")) |>
  dplyr::select_if(all_na)  |>
  #names(data)
  tidyr::unite(col =  "Indicator", 
               all_of( c("core_impact_indicator", "user_defined_impact_indicator",
                         "core_outcome_indicator", "user_defined_outcome_indicator"#,
                         #"user_defined_output_indicator"
               ) ), 
               na.rm = TRUE, 
               sep = "") |>
  # tidyr::unite( col = "Area" , 
  #             all_of( c("impact_area",
  #                     "outcome_area" ) ), 
  #             na.rm = TRUE, 
  #             sep = "") |>
  # paste(noquote(names(data)), collapse = ', ') %>% cat()
  dplyr::select( Operation,
                 country_countries,
                 impact_area,outcome_area,  Level,
                 indicator_type,   Indicator, 
                 population_type,
                 baseline_2022_numerator, 
                 baseline_2022_denominator, 
                 baseline_2022_percent, 
                 actual_2022_numerator, 
                 actual_2022_denominator, 
                 actual_2022_percent, 
                 # baseline_2023_numerator, 
                 # baseline_2023_denominator, 
                 # baseline_2023_percent, 
                 op_target_2022, 
                 #op_target_2023, 
                 # ol_target_2022 , 
                 disaggregation, 
                 data_source, additional_data_source, 
                 data_sources_comment,
                 m_e_activity, m_e_activity_comment, 
                 data_collection_frequency, responsibility_internal, 
                 responsibility_external, 
                 baseline_2022_data_limitations_operations_notes_on_data_quality,
                 actual_2022_data_limitations_operations_notes_on_data_quality,
                 #  baseline_2023_data_limitations_operations_notes_on_data_quality, 
                 # programme_monitoring_and_dima_feedback_technical,
                 # technical_lead_operations_team_or_other_mft_member_feedback_strategic, 
                 regional_bureau_feedback#,
                 #  output_statement_or_short_description, 
                 #  output_code, 
                 #  reporting_requirements_r4v_rba_hrp_unsdcf_msm_etc, 
                 #  relevant_sites_offices_or_field_locations, 
                 #  partners_direct_implementation 
  ) |>
  dplyr::mutate( indicator_type = if_else( Level == "Output","User-Defined", indicator_type )  )



## Check that we have all Ops that we would expect from the import.... #######
# table(data$Operation, useNA = "ifany")
# 
check <- QA_Ops |>
  dplyr::filter( !(is.na(link_to_share_point_document_where_feedback_should_be_included))) |>
  dplyr::select(country, code) |>
  dplyr::full_join ( as.data.frame(table(data$Operation, useNA = "ifany")),
                     by = c("code" = "Var1"))

check
table(data$Operation, data$indicator_type, useNA = "ifany")
table(data$Operation, data$Level, useNA = "ifany")

# check2 <- QA_Ops |>
#   dplyr::filter( !(is.na(link_to_share_point_document_where_feedback_should_be_included))) |>
#   dplyr::select(country, code) |>
#   dplyr::full_join ( as.data.frame(table(data$Operation, data$indicator_type, useNA = "ifany")),
#                      by = c("code" = "Var1"))
# 
# check2


# Step 3 -  Data cleaning ###############
## Writing the csv for cleaning lookup ######### 
### Need to clean the Indicator 
# names(data)# 
LookupIndic1 <- data |>
  dplyr::filter(Level %in% c( "ImpactCore", "OutcomeCore") )  |>
  dplyr::select(Indicator ) |>
  dplyr::distinct() |>
  dplyr::arrange(Indicator)
write.csv(LookupIndic1, here::here("data", "LookupIndic.csv"),
          row.names = TRUE)

## Cleaning Population_type  
#table(data$population_type, useNA = "ifany")
LookupAggreg1 <- data |>
  dplyr::select(population_type) |>
  dplyr::distinct() |>
  dplyr::arrange(population_type)
write.csv(LookupAggreg1, here::here("data", "LookupAggreg.csv"),
          row.names = TRUE)

## Cleaning aggregation   
#table(data$disaggregation, useNA = "ifany")
LookupDisaggregation1 <- data |>
  dplyr::select(disaggregation) |>
  dplyr::distinct() |>
  dplyr::arrange(disaggregation)

write.csv(LookupDisaggregation1, here::here("data", "LookupDisaggregation.csv"),
          row.names = TRUE)



##  After manual cleaning all of this goes intot the excel cleaning look up  ######### 
CleanIndi <- read_excel(here::here("data", "CleanLookup.xlsx"), 
                        sheet = "clean_indicator" ) #|>
# dplyr::mutate(Indicator = stringr::str_trim(Indicator))
# dplyr::select(Indicator) |>
# dplyr::distinct()
## Check if there's missed cleaning.. 
if(nrow(CleanIndi) < nrow(LookupIndic1)){ cat("Review Indicator Lookup for cleaning!")}

CleanPopType <- read_excel(here::here("data", "CleanLookup.xlsx"), 
                           sheet = "clean_poptype" )
#paste(noquote(names(CleanPopType)), collapse = ', ') %>% cat()
if(nrow(CleanPopType) < nrow(LookupAggreg1)){ cat("Review PopType Lookup for cleaning!")}

Cleandisaggregation <- read_excel(here::here("data", "CleanLookup.xlsx"), 
                                  sheet = "clean_disaggregation" )  |>
  dplyr::distinct()

#paste(noquote(names(Cleandisaggregation)), collapse = ', ') %>% cat()
if(nrow(Cleandisaggregation) < nrow(LookupDisaggregation1)){ cat("Review Indicator Lookup for cleaning!")}


## adding country name   ######### 
## 
ctrcode <- as.data.frame(levels(as.factor(data$Operation)))
names(ctrcode)[1] <- "code"
ctrname <- ForcedDisplacementStat::reference |>
  dplyr::select( iso_3, UNHCRcode, ctryname, SUBREGION) |>
  dplyr::filter (iso_3 %in% ctrcode$code)
#names(ctrname)

## and now we join back!  #########  
data2 <- data |>
  #dplyr::mutate(Indicator = stringr::str_trim(Indicator)) |>
  left_join(CleanIndi , by = c("Indicator")) |>
  left_join(CleanPopType , by = c("population_type")) |>
  left_join(Cleandisaggregation , by = c("disaggregation")) |> 
  left_join(ctrname , by = c("Operation"="iso_3")) |>
  ## Let's put the country name where it not there...
  dplyr::mutate( country = if_else( is.na(country_countries) | country_countries =="" ,
                                    ctryname, 
                                    country_countries )  )|> 
  ## Second turn to clean when MCO
  dplyr::mutate( country = if_else( is.na(country)   ,
                                    Operation, 
                                    country )  )|> 
  dplyr::select( Operation,
                 country_countries,
                 country, SUBREGION,
                 impact_area,outcome_area,  Level,
                 indicator_type,   Indicator, Ind_clean,
                 Area, Ind_num, Ind_id,# Ind_seq,
                 population_type, 
                 population_type_clean,
                 population_label,
                 baseline_2022_numerator, 
                 baseline_2022_denominator, 
                 baseline_2022_percent, 
                 actual_2022_numerator, 
                 actual_2022_denominator, 
                 actual_2022_percent, 
                 # baseline_2023_numerator, 
                 # baseline_2023_denominator, 
                 # baseline_2023_percent, 
                 op_target_2022, 
                 #op_target_2023, 
                 #ol_target_2022 , 
                 disaggregation, 
                 disag_PopulationType, disag_Age, disag_Gender, disag_Disability, disag_Origin, disag_Nation,
                 data_source, additional_data_source, 
                 data_sources_comment,
                 m_e_activity, m_e_activity_comment, 
                 data_collection_frequency, responsibility_internal, 
                 responsibility_external, 
                 baseline_2022_data_limitations_operations_notes_on_data_quality,
                 actual_2022_data_limitations_operations_notes_on_data_quality,
                 #  baseline_2023_data_limitations_operations_notes_on_data_quality, 
                 # programme_monitoring_and_dima_feedback_technical,
                 # technical_lead_operations_team_or_other_mft_member_feedback_strategic, 
                 regional_bureau_feedback,
                 # output_statement_or_short_description, 
                 # output_code, 
                 # reporting_requirements_r4v_rba_hrp_unsdcf_msm_etc, 
                 # relevant_sites_offices_or_field_locations, 
                 # partners_direct_implementation
  )|>
  ## Based on this we clean indicator type -- as it can be only Core   or User-Defined
  dplyr::mutate( indicator_type = if_else( is.na(Ind_clean),"User-Defined", "Core" )  )




## Quick tabulation to double check everything is ok! 
table(data2$indicator_type, useNA = "ifany")
table(data2$population_type_clean, useNA = "ifany")




## Need to remove lines that are partly empty.... ################
## This is linked to cells with prefilled formula in the original excel template
#names(data)
#table(data$Indicator, useNA = "ifany")
data3a <- data2  #|>
## Need further cleaning for all the cellls that go left with a formula... 
# dplyr::filter( ! ( is.na(Indicator )) &  ! ( is.na(indicator_type)) )
# dplyr::filter( ! ( Indicator =="" &  is.na(actual_2022_percent) ) ) 


# names(data3a)
# View(data3a |> dplyr::filter( country == "Mexico"))

# View(data3a |> dplyr::filter( country == "Mexico") |>
#        dplyr::select(Operation,
#                      country_countries,
#                      country, SUBREGION,
#                      impact_area,outcome_area,  Level,
#                      indicator_type,   Indicator, Ind_clean,
#                      Area, Ind_num, Ind_id))





