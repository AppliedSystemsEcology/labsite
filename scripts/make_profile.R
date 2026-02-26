library(quarto)
source("scripts/make_publication.R")

make_profile <- function(
    title = "",
    last = "",
    middle = "",
    first = "",
    people_group = "",
    email = "",
    education = "",
    role = "",
    description = "",
    blurb = "",
    image = "",
    orcid = "",
    github = "",
    researchgate = "",
    linkedin = "",
    personal_website = "",
    file_path
    ){

  # create links
  orcidlink <- if(orcid!="") paste0("https://orcid.org/",orcid) else ""
  linkscontents <- c(email, orcidlink, github, researchgate, linkedin, personal_website) |>
    setNames(c("email", "orcid", "github", "researchgate", "linkedin", "personal_website"))
  linkscontents <- linkscontents[linkscontents != "" & !is.na(linkscontents)]   # only keep non-empty links
  linkslist <- list()

  for(z in seq_along(linkscontents)){
    linkslist[[z]] <- makelinkinfo(names(linkscontents)[z], linkscontents[z])
  }

  yaml.args <- list(
    title = title,
    last = last,
    middle = middle,
    first = first,
    people_group = people_group,
    education = education,
    subtitle = role,
    blurb = blurb,
    description = description,
    image = image,
    toc = FALSE,
    listing =
      list(
        id = "pubs",
        template = "../../_ejs/publications.ejs",
        contents = "../../publications/**/*.qmd",
        sort = "pub_number desc",
        `filter-ui` = TRUE,
        include = list(author = abbreviate_names(paste(last,first,sep=", ")))
      ),
    `page-layout` = "full",
    about =
      list(
        id = "about",
        template = "trestles",
        `image-shape` = "round",
        image = image,
        links = linkslist
      )
  )

  yaml.args <- yaml.args[!is.na(yaml.args)]

  pubyaml <- do.call(quarto::write_yaml_metadata_block, yaml.args)

  writeLines(pubyaml, file_path)
}

omit.empty <- function(x){
  x[which(!is.na(x) & !is.null(x) & x != "")]
}

makelinkinfo <- function(name, content){
  icon <- switch(name,
                 email = "envelope",
                 orcid = "",
                 github = "github",
                 researchgate = "",
                 linkedin = "linkedin",
                 personal_website ="link")
  text <- switch(name,
                 email = "Email",
                 orcid = "ORCID",
                 github = "GitHub",
                 researchgate = "ResearchGate",
                 linkedin = "LinkedIn",
                 personal_website ="Personal")
  list(icon = icon, text = text, href = content) |> omit.empty()
}

