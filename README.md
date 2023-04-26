
# {surveyDesigner} <img src="https://raw.githubusercontent.com/unhcr-americas/surveyDesigner/master/inst/hex-surveyDesigner.png" align="right" width="120"/>

<!-- badges: start -->
[![Codecov test coverage](https://codecov.io/gh/unhcr-americas/surveyDesigner/branch/main/graph/badge.svg)](https://codecov.io/gh/unhcr-americas/surveyDesigner?branch=main)
[![Lifecycle: experimental](https://img.shields.io/badge/lifecycle-experimental-orange.svg)](https://lifecycle.r-lib.org/articles/stages.html#experimental)
<!-- badges: end -->

`{surveyDesigner}` is a shinyApp to parse a master referential of questions and indicators to generate a contextualized series of [xlsform](http://xlsform.org) questionnaires.


For the end-user, aka the Survey Coordinator at Operation level, the application is expected to: 

  1. Enforce a questionnaire design process that starts from a selection of indicators that needs to be measured and pre-select automatically all the required standardized survey modules and questions in order to measure them. Not only this ensure that standards are actually used, but it will also minimize the risk of questionnaire design mistakes: "_collect what you need, use what you collect_"  
  
  2. Ease the contextualization process from the global referential to the actual implementation in each country (i.e translating and adjusting the labels as per the specific context) and facilitate the feedback loop so that if the same ad-hoc questions are used in multiple context, they can be considered for inclusion in the global referential 
  
  3. Support the usage of [mixed-mode (CAPI/CATI?CAWI)](https://www.youtube.com/watch?v=qRmy2OAnyWc) and multiple data collection waves to collect the final dataset within an __annual survey data collection cycle__, all of this allowing both to promote survey integration and to maximize the financial resources invested in those activities  


Read more on the rationale for this app in the [vignette](https://unhcr-americas.github.io/surveyDesigner/docs/articles/surveyDesigner.html)

## Installation

You can install the development version from [GitHub](https://github.com/Thinkr-open/golem) with:

``` r
# install.packages("remotes")
remotes::install_github("unhcr-americas/surveyDesigner")
```

## Run the app  
This script allows you to display the app

``` r
# Run the application
surveyDesigner::run_app()
```

## Update the app  
This script allows you to quickly rebuild and display the app

``` r
# Detach all loaded packages and clean your environment
golem::detach_all_attached()

# rm(list=ls(all.names = TRUE))

# Document and reload your package
golem::document_and_reload()

# Run the application
surveyDesigner::run_app()
```



## Update the package documentation

This script allows to update the package documentation

``` r
devtools::document()

devtools::check(document = FALSE)

pkgdown::build_site()
```

## As dev :



The app is build using [`{golem}` framework](https://thinkr-open.github.io/golem) and following the tutorial: [Engineering Production-Grade Shiny Apps](https://engineering-shiny.org//).

Please use template commit and MR :

``` r
project_path <- "path_to_surveyDesigner"
gert::git_config_set(repo = project_path, name = "commit.template", value = ".github/template_commit")
```

## Code of Conduct

Please note that the surveyDesigner project is released with a [Contributor Code of Conduct](https://contributor-covenant.org/version/2/0/CODE_OF_CONDUCT.html). By contributing to this project, you agree to abide by its terms.
