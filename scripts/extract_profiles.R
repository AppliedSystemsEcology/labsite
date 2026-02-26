library(tidyverse)
source("scripts/make_profile.R")

peoplepath <- "people/people.csv"
peopledir <- "people"

people <- read.csv(peoplepath)

## USE CAUTION: CLEAR CONTENTS OF people/ DIRECTORY EXCEPT FOR backup/
current.dirs <- list.dirs(peopledir, recursive = FALSE)
clear.dirs <- current.dirs[which(current.dirs != "people/_images")]
unlink(clear.dirs, recursive = TRUE)

## LOOP THROUGH PEOPLE TABLE AND CREATE PEOPLE PAGES

image.index <- list.files("people/_images")

for(i in seq_len(nrow(people))){
  full_name <- c(people$First[i], people$Middle[i], people$Last[i]) |> omit.empty() |> paste(collapse=" ")

  edu1 <- c(people$edu1_degree[i], people$edu1_institution[i]) |> omit.empty() |> paste(collapse=" | ")
  edu2 <- c(people$edu2_degree[i], people$edu2_institution[i]) |> omit.empty() |> paste(collapse=" | ")
  edu3 <- c(people$edu3_degree[i], people$edu3_institution[i]) |> omit.empty() |> paste(collapse=" | ")

  edu.all <- c(edu1, edu2, edu3) |> omit.empty() |> paste(collapse = " <br> ")

  file_path.i <- paste0("people/", people$Last[i],"-",people$First[i]) |> tolower()

  if(!dir.exists(file_path.i)){
    dir.create(file_path.i)
  }

  person.image <- tolower(paste0(people$Last[i],"-",people$First[i],".jpg"))

  if(person.image %in% image.index){
    use.image <- person.image
  }else{
    use.image <- "_template.jpg"
  }

  profile.i <- list(
    title = full_name,
    last = people$Last[i],
    middle = people$Middle[i],
    first = people$First[i],
    people_group = people$people_group[i],
    email = people$email[i],
    education = edu.all,
    role = people$role[i],
    blurb = people$blurb[i],
    image = paste0("../_images/",use.image),
    orcid = people$orcid[i],
    github = people$github[i],
    researchgate = people$researchgate[i],
    linkedin = people$linkedin[i],
    personal_website = people$personal_website[i],
    file_path = file.path(file_path.i,"index.qmd")
  )

  do.call(make_profile, profile.i)

  cat(glue::glue(
    '<hr>

    ::: {{#about}}

    {{{{< meta blurb >}}}}

    ## Education

    {{{{< meta education >}}}}

    <br>
    :::

    ## {{{{< meta first >}}}}\'s Group Publications

    ::: {{#pubs}}
    :::', .trim = TRUE
  ), file = file.path(file_path.i,"index.qmd"), append = TRUE)

}
