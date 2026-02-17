library(quarto)

make_publication <- function(
    title = "",
    author = list(),
    journal = "",
    volume = "",
    issue = "",
    page = "",
    year = "",
    categories = list(),
    doi = "",
    url_source = "",
    url_preprint = "",
    file_path
    ){
  
  yaml.args <- list(
    title = title,
    author = author,
    categories = categories,
    url_source = url_source,
    url_preprint = url_preprint,
    journ = journal,
    volume = volume,
    issue = issue,
    page = page,
    year = year,
    doi = doi
  )
  
  yaml.args <- yaml.args[!is.na(yaml.args)]

  pubyaml <- do.call(quarto::write_yaml_metadata_block, yaml.args)
  
  writeLines(pubyaml, file_path)
}

abbreviate_names <- function(authors){
  lastfirstnames <- strsplit(authors, "; ") |> unlist()
  abbrevfirstname <- strsplit(lastfirstnames, ", ") |>
    lapply(
      \(x){  # function for abbreviating non-firstnames
        name.out <- x[1]
        for(p in 2:length(x)){
          name.p <- strsplit(x[p], " ") |> unlist() |>
            sapply(\(a) paste0(substr(a[1],1,1),".")) |>
            paste(collapse = " ")
          name.out[p] <- name.p
        }
        paste(name.out, collapse = ", ")
      }
    )
  unlist(abbrevfirstname)
}
