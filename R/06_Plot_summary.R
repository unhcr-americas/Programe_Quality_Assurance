

### Review  data Quality results ###############

#names(dataQA)
# table( dataQA$Operation1, dataQA$Comp1_1, useNA = "ifany")

table( dataQA$Operation1, dataQA$Acc3_1)
prop.table(table( dataQA$Operation1, dataQA$Acc3_1, useNA = "ifany"), margin=1) 
prop.table(table( dataQA$Operation1, dataQA$Acc3_1 ), margin=1) 
t <- round(prop.table(table( dataQA$Operation1, dataQA$Acc3_1, useNA = "ifany"), margin=1)* 100 , 1) |> 
  as.data.frame()|>
  dplyr::filter( !(is.na(Var2)))
class(t)

QASummary <- t(cbind( 
  #  as.data.frame(table( dataQA$Operation1, dataQA$Comp1_1))
  # table( dataQA$Operation1, dataQA$Comp1_1),
  # table( dataQA$Operation1, dataQA$Comp1_2),
  table( dataQA$Operation1, dataQA$Comp2_1),
  table( dataQA$Operation1, dataQA$Comp2_2),
  table( dataQA$Operation1, dataQA$Comp2_3) #,
  # table( dataQA$Operation1, dataQA$Comp3),
  # table( dataQA$Operation1, dataQA$Comp4),
  # table( dataQA$Operation1, dataQA$Acc1_1),
  # table( dataQA$Operation1, dataQA$Acc1_2),
  # table( dataQA$Operation1, dataQA$Acc1_3),
  # table( dataQA$Operation1, dataQA$Acc2_1),
  # table( dataQA$Operation1, dataQA$Acc2_2),
  # table( dataQA$Operation1, dataQA$Acc3_1),
  # table( dataQA$Operation1, dataQA$Acc3_2),
  # table( dataQA$Operation1, dataQA$Acc5_1),
  # table( dataQA$Operation1, dataQA$Acc5_2),
  # table( dataQA$Operation1, dataQA$Acc5_3),
  # table( dataQA$Operation1, dataQA$Acc5_4)
)) |>
  as.data.frame()

#QASummaryprop <- 
# t(cbind( 
# #  as.data.frame(table( dataQA$Operation1, dataQA$Comp1_1))
# round(prop.table(table( dataQA$Operation1, dataQA$Comp1_1) ) * 100 , 1),
# round(prop.table(table( dataQA$Operation1, dataQA$Comp1_2))* 100 , 1),
# round(prop.table(table( dataQA$Operation1, dataQA$Comp2_1))* 100 , 1),
# round(prop.table(table( dataQA$Operation1, dataQA$Comp2_2))* 100 , 1),
# round(prop.table(table( dataQA$Operation1, dataQA$Comp2_3))* 100 , 1),
# round(prop.table(table( dataQA$Operation1, dataQA$Comp3))* 100 , 1),
# round(prop.table(table( dataQA$Operation1, dataQA$Comp4))* 100 , 1),
# round(prop.table(table( dataQA$Operation1, dataQA$Acc1_1))* 100 , 1),
# round(prop.table(table( dataQA$Operation1, dataQA$Acc1_2))* 100 , 1),
# round(prop.table(table( dataQA$Operation1, dataQA$Acc1_3))* 100 , 1),
# round(prop.table(table( dataQA$Operation1, dataQA$Acc2_1))* 100 , 1),
# round(prop.table(table( dataQA$Operation1, dataQA$Acc2_2))* 100 , 1),
# round(prop.table(table( dataQA$Operation1, dataQA$Acc3_1))* 100 , 1),
# round(prop.table(table( dataQA$Operation1, dataQA$Acc3_2))* 100 , 1),
# round(prop.table(table( dataQA$Operation1, dataQA$Acc5_1))* 100 , 1),
# round(prop.table(table( dataQA$Operation1, dataQA$Acc5_2))* 100 , 1),
# round(prop.table(table( dataQA$Operation1, dataQA$Acc5_3))* 100 , 1),
# round(prop.table(table( dataQA$Operation1, dataQA$Acc5_4) ) * 100 , 1) ,
# round(prop.table(table( dataQA$Operation1, dataQA$Cons1_1) ) * 100 , 1) ,
# round(prop.table(table( dataQA$Operation1, dataQA$Cons1_2) ) * 100 , 1) ,
# round(prop.table(table( dataQA$Operation1, dataQA$Cons1_3) ) * 100 , 1) ,
# round(prop.table(table( dataQA$Operation1, dataQA$Cons1_4) ) * 100 , 1) )) |>
# as.data.frame() |>
# rownames_to_column('check') |>
# tidyr::pivot_longer(!check, names_to = "Ops", values_to = "Percent") |>
# dplyr::filter( Percent > 0) |>  
# ggplot(  aes(x = Ops, 
#              y = check, 
#              fill = Percent)) +
#   geom_tile(color = "white",
#             lwd = 1.5,
#             linetype = 1) +
#   coord_fixed() +
#   geom_text(aes(label = Percent), color = "grey75", size = 4) +  
#   #scale_fill_gradient2(low = "#069C56",    mid = "#FF980E",   high = "#D3212C") +
#   scale_fill_gradientn(colors = hcl.colors(7,  palette = "viridis", alpha = 0.6, rev = TRUE)) +
#   coord_fixed() +
#   unhcrthemes::theme_unhcr(font_size = 13, 
#                            rel_small = 8/9,
#                            grid = FALSE, 
#                            axis = FALSE) +
#   theme(legend.position = "none", 
#         axis.text.x = element_text(angle = 45, hjust = 1, vjust = 0.5) ) +
#   labs( x = "", y =  "" ,
#         title = stringr::str_wrap( paste0("RBM Systematic Quality Check: % of indicator with issues") , 60),
#         subtitle = stringr::str_wrap( paste0("Regional Comparison Americas | 2022 Quality Assurance" ) ,
#                                       80),
#         caption = "Source: UNHCR RBM / Compass ") 



rbind(               round(prop.table(table( dataQA$Operation1, dataQA$Comp1_1, useNA = "ifany"), margin=1)* 100 , 1) |> 
                       as.data.frame()|>
                       dplyr::filter( !(is.na(Var2))),
                     round(prop.table(table( dataQA$Operation1, dataQA$Comp1_2, useNA = "ifany"), margin=1)* 100 , 1) |> 
                       as.data.frame()|>
                       dplyr::filter( !(is.na(Var2))),
                     round(prop.table(table( dataQA$Operation1, dataQA$Comp2_1, useNA = "ifany"), margin=1)* 100 , 1) |> 
                       as.data.frame()|>
                       dplyr::filter( !(is.na(Var2))),
                     round(prop.table(table( dataQA$Operation1, dataQA$Comp2_2, useNA = "ifany"), margin=1)* 100 , 1) |> 
                       as.data.frame()|>
                       dplyr::filter( !(is.na(Var2))),
                     round(prop.table(table( dataQA$Operation1, dataQA$Comp2_3, useNA = "ifany"), margin=1)* 100 , 1) |> 
                       as.data.frame()|>
                       dplyr::filter( !(is.na(Var2))),
                     round(prop.table(table( dataQA$Operation1, dataQA$Comp3, useNA = "ifany"), margin=1)* 100 , 1) |> 
                       as.data.frame()|>
                       dplyr::filter( !(is.na(Var2))),
                     round(prop.table(table( dataQA$Operation1, dataQA$Comp4, useNA = "ifany"), margin=1)* 100 , 1) |> 
                       as.data.frame()|>
                       dplyr::filter( !(is.na(Var2))),
                     round(prop.table(table( dataQA$Operation1, dataQA$Acc1_1, useNA = "ifany"), margin=1)* 100 , 1) |> 
                       as.data.frame()|>
                       dplyr::filter( !(is.na(Var2))),
                     round(prop.table(table( dataQA$Operation1, dataQA$Acc1_2, useNA = "ifany"), margin=1)* 100 , 1) |> 
                       as.data.frame()|>
                       dplyr::filter( !(is.na(Var2))),
                     round(prop.table(table( dataQA$Operation1, dataQA$Acc1_3, useNA = "ifany"), margin=1)* 100 , 1) |> 
                       as.data.frame()|>
                       dplyr::filter( !(is.na(Var2))),
                     round(prop.table(table( dataQA$Operation1, dataQA$Acc2_1, useNA = "ifany"), margin=1)* 100 , 1) |> 
                       as.data.frame()|>
                       dplyr::filter( !(is.na(Var2))),
                     round(prop.table(table( dataQA$Operation1, dataQA$Acc2_2, useNA = "ifany"), margin=1)* 100 , 1) |> 
                       as.data.frame()|>
                       dplyr::filter( !(is.na(Var2))),
                     round(prop.table(table( dataQA$Operation1, dataQA$Acc3_1, useNA = "ifany"), margin=1)* 100 , 1) |> 
                       as.data.frame()|>
                       dplyr::filter( !(is.na(Var2))),
                     round(prop.table(table( dataQA$Operation1, dataQA$Acc3_2, useNA = "ifany"), margin=1)* 100 , 1) |> 
                       as.data.frame()|>
                       dplyr::filter( !(is.na(Var2))),
                     round(prop.table(table( dataQA$Operation1, dataQA$Acc5_1, useNA = "ifany"), margin=1)* 100 , 1) |> 
                       as.data.frame()|>
                       dplyr::filter( !(is.na(Var2))),
                     round(prop.table(table( dataQA$Operation1, dataQA$Acc5_2, useNA = "ifany"), margin=1)* 100 , 1) |> 
                       as.data.frame()|>
                       dplyr::filter( !(is.na(Var2))),
                     round(prop.table(table( dataQA$Operation1, dataQA$Acc5_3, useNA = "ifany"), margin=1)* 100 , 1) |> 
                       as.data.frame()|>
                       dplyr::filter( !(is.na(Var2))),
                     round(prop.table(table( dataQA$Operation1, dataQA$Acc5_4, useNA = "ifany"), margin=1)* 100 , 1) |> 
                       as.data.frame()|>
                       dplyr::filter( !(is.na(Var2))),
                     round(prop.table(table( dataQA$Operation1, dataQA$Cons1_1, useNA = "ifany"), margin=1)* 100 , 1) |> 
                       as.data.frame()|>
                       dplyr::filter( !(is.na(Var2))),
                     round(prop.table(table( dataQA$Operation1, dataQA$Cons1_2, useNA = "ifany"), margin=1)* 100 , 1) |> 
                       as.data.frame()|>
                       dplyr::filter( !(is.na(Var2))),
                     round(prop.table(table( dataQA$Operation1, dataQA$Cons1_3, useNA = "ifany"), margin=1)* 100 , 1) |> 
                       as.data.frame()|>
                       dplyr::filter( !(is.na(Var2))),
                     round(prop.table(table( dataQA$Operation1, dataQA$Cons1_4, useNA = "ifany"), margin=1)* 100 , 1) |> 
                       as.data.frame()|>
                       dplyr::filter( !(is.na(Var2))) )   |>
  dplyr::filter(Freq > 0) |>
  ggplot(  aes(x = Var1, 
               y = Var2, 
               fill = Freq)) +
  geom_tile(color = "white",
            lwd = 1.5,
            linetype = 1) +
  coord_fixed() +
  geom_text(aes(label = Freq), color = "grey25", size = 4) +  
  #scale_fill_gradient2(low = "#069C56",    mid = "#FF980E",   high = "#D3212C") +
  scale_fill_gradientn(colors = hcl.colors(7,  palette = "viridis", alpha = 0.6, rev = TRUE)) +
  coord_fixed() +
  unhcrthemes::theme_unhcr(font_size = 13, 
                           rel_small = 8/9,
                           grid = FALSE, 
                           axis = FALSE) +
  theme(legend.position = "none", 
        axis.text.x = element_text(angle = 45, hjust = 1, vjust = 0.5) ) +
  labs( x = "", y =  "" ,
        title = stringr::str_wrap( paste0("RBM Systematic Quality Check: % of indicator with issues") , 60),
        subtitle = stringr::str_wrap( paste0("Regional Comparison Americas | 2022 Quality Assurance" ) ,
                                      80),
        caption = "Source: UNHCR RBM / Compass ") 
