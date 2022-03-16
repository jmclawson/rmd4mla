#' pdf_document
#'
#' R Markdown output for typesetting MLA-style document as a PDF, using biblatex-mla for citations and references.
#'
#' @export
pdf_document <- function(){
  mla_document("pdf")
}

#' latex_document
#'
#' R Markdown output for typesetting MLA-style document as a Latex file, using biblatex-mla for citations and references.
#'
#' @export
latex_document <- function(){
  mla_document("tex")
}

#' word_document
#'
#' R Markdown output for typesetting MLA-style document as a Word file. This format does not use biblatex-mla for styling citations.
#'
#' @export
word_document <- function(){
  mla_document("doc")
}

#' mla_document
#'
#' Main function for converting R Markdown documents into various file formats using something close to MLA-style layout.
#'
#' @export

mla_document <- function(format="pdf") {
  # locations of resource files in the package
  pkg_file <- function(...) system.file(..., package = "rmd4mla")

  pkg_file_template <- function(...) pkg_file("rmarkdown", "templates", ...)

  find_resource <- function(template, file = 'template.tex') {
    res <- pkg_file_template(template, "resources", file)
    if (res == "") stop(
      "Couldn't find template file ", template, "/resources/", file, call. = FALSE
    )
    res
  }

  # call the base x_document function
  if (format == "pdf") {
    rmarkdown::pdf_document(
      template = find_resource("mla",
                               "template.tex"),
      keep_tex = TRUE,
      citation_package = "biblatex"
    )
  } else if (format == "doc") {
    rmarkdown::word_document(
      reference_docx = find_resource("mla", "template.docx"),
      number_sections = TRUE,
      df_print = "kable"
    )
  } else {
    rmarkdown::latex_document(
      template = find_resource("mla",
                               "template.tex"),
      citation_package = "biblatex"
    )
  }
}

#' chicago_document
#'
#' Main function for converting R Markdown documents into various file formats using something close to MLA-style layout and Chicago-style citations.
#'
#' @export

chicago_document <- function(format="pdf") {
  # locations of resource files in the package
  pkg_file <- function(...) system.file(..., package = "rmd4mla")
  
  pkg_file_template <- function(...) pkg_file("rmarkdown", "templates", ...)
  
  find_resource <- function(template, file = 'template.tex') {
    res <- pkg_file_template(template, "resources", file)
    if (res == "") stop(
      "Couldn't find template file ", template, "/resources/", file, call. = FALSE
    )
    res
  }
  
  # call the base x_document function
  if (format == "pdf") {
    rmarkdown::pdf_document(
      template = find_resource("mla",
                               "chitemplate.tex"),
      keep_tex = TRUE,
      citation_package = "biblatex"
    )
  } else if (format == "doc") {
    rmarkdown::word_document(
      reference_docx = find_resource("mla", "template.docx"),
      number_sections = TRUE,
      df_print = "kable"
    )
  } else {
    rmarkdown::latex_document(
      template = find_resource("mla",
                               "chitemplate.tex"),
      citation_package = "biblatex"
    )
  }
}

#' create_odt
#'
#' Use make4ht to convert R Markdown with biblatex-mla references into an .odt file for opening in Microsoft Word.
#'
#' @export

create_odt <- function(input,
                     clean=TRUE,
                     ...){
  # locations of resource files in the package
  pkg_file <- function(...) system.file(..., package = "rmd4mla")

  pkg_file_template <- function(...) pkg_file("rmarkdown", "templates", ...)

  find_resource <- function(template, file = 'template.tex') {
    res <- pkg_file_template(template, "resources", file)
    if (res == "") stop(
      "Couldn't find template file ", template, "/resources/", file, call. = FALSE
    )
    res
  }
  cfg_file <-
    find_resource("mla",
                  "template.cfg")
  mk4_engine <-
    find_resource("mla",
                  "mlabuild.mk4")
  # tex_file <- gsub("rmd$", "tex", input)
  odt_template <-
    find_resource("mla",
                  "template.odt")
  make_cmd <- paste0(
    "make4ht",
    " -c ",
    cfg_file,
    " -e ",
    mk4_engine,
    " -f odt+odttemplate+preprocess_input ",
    input,
    ' "odttemplate=',
    odt_template,
    '"'
  )

  system(make_cmd)

  if (clean) {
    regex <- "(.*)/([a-zA-Z0-9 _-]+.[a-zA-Z]{1,3})$"
    the_dir <- gsub(regex, "\\1", input)
    the_basename <- gsub(regex, "\\2", input) |>
      strsplit("\\.") |>
      sapply(`[`, 1)
    all_files <- the_dir |>
      list.files(full.names = TRUE)
    df_files <- all_files |>
      file.info() |>
      data.frame() |>
      tibble::rownames_to_column("file")
    compile_time <- df_files |>
      dplyr::filter(file == input) |>
      dplyr::pull(ctime)
    delete_me <- df_files |>
      dplyr::filter(ctime > compile_time) |>
      dplyr::filter(!grepl("odt$", file),
                    !grepl("rmd$", file),
                    !grepl("Rmd$", file),
                    !grepl("bib$", file),
                    # !grepl("log$", file),
                    !grepl("tex$", file),
                    !grepl("pdf$", file),
                    grepl(the_basename, file)) |>
      dplyr::pull(file)

    # message("Input: ", input)
    # message("Directory: ", the_dir)
    # message("Base name: ", the_basename)

    message("To be deleted:\n")

    message(paste(delete_me,
                  collapse = "\n"))

    for (i in delete_me) {
      delete_cmd <- paste0("rm ", i)
      system(delete_cmd)
    }
  }
}

#' create_odt_keep
#'
#' A variation of create_odt that doesn't clean extra files, which may be useful for troubleshooting.
#'
#' @export

create_odt_keep <- function(input,
                     ...) {
  create_odt(input, clean=FALSE, ...)
}
