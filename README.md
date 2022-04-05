# rmd4mla
R Markdown templates for MLA-document formatting and functions for easy OpenDocument exporting with make4ht.

## Installation
Use `remotes::install_github("jmclawson/rmd4mla")` to install the R Markdown template file.

In addition to `R`, `rmarkdown`, `knitr`, `tibble`, `dplyr`, and `remotes`, you'll need to have a working setup of `LaTeX`. Conversion to OpenDocument requires `tex4ht` and `make4ht`, so you'll probably need more than `TinyTex`. The package was developed and tested using an installation of [TexLive 2021](https://www.tug.org/texlive/), along with most recent updates available in late February 2022. It might be necessary to manually change one `make4ht` file for preprocessing `.Rmd` files for output as `.odt`, since this change may not have been distributed to the CTAN network; see the [February 28th commit](https://github.com/michal-h21/make4ht/commit/a7ed9e73948ce8fd9749e94bd84a7607cca07f9c) for details.

Once these are set up, cross your fingers and proceed. Things work well on my laptop, but the functions calling `make4ht` have only been tested on this one computer.

## Description
Bundling together templates and common defaults, the `rmd4mla` package is designed to make it easy to use R Markdown for preparing MLA-formatted documents. For a quick start, R Markdown templates are provided for use with R Studio's "New File" > "R Markdown..." wizard, including one optimized for class assignments and another for publications.

### Three Output Formats
Three MLA-style output formats are defined:

1. `mla_document` prepares a PDF document with MLA-style formatting: text is set in a 12-point serif font face, double-spaced, with running headers, appropriate margins, and [MLA-style citations](https://ctan.org/pkg/biblatex-mla). As an alias to `mla_document`, `pdf_document` does exactly the same thing and is provided to make things easier for anyone with R Markdown experience.
2. `latex_document` exposes the Latex code prepared before the above format. At the moment, this Latex code is kludgey, so the format is provided to help with troubleshooting.
3. Least recommended of the three, `word_document` sets font faces, sizes, spacing, and margins, but it does not prepare document headers or citations. If you must prepare something in Microsoft Word format---and if you're writing in the humanities, you probably do---it's recommended instead to use the `create_odt` function with the `knit:` parameter in the header, described below.

In addition to these MLA-style formats, there's a bonus Chicago-style PDF output defined by `chicago_document`. This format differs from `mla_document` only in the way it prepares citations.

### Exporting to Microsoft Word

Using the `knit: rmd4mla::create_odt` parameter in the YAML header will prepare a file in the OpenDocument `.odt` file format. The resulting file can be opened by LibreOffice and saved as a `.docx` file. Running headers and page numbers will need to be added manually.

When converting a file called `example.Rmd`, `make4ht` creates many extra files along the way, and `create_odt` follows along after it with a broom to clean things up. In doing so, it will delete files in the project folder based on name and modification date, targeting files named `example.XXX` with a modification date later than the R Markdown file. To keep all of these, instead use `create_odt_keep`.

### YAML Parameters
In addition to setting the document's title, author, date, and bibliography, the R Markdown header adds additional parameters: 

- `lastname` defines a running header; if this option is not set, the package will print the title beside the page number.
- `professor` adds a line for indicating an instructor's name for an assignment.
- `class` sets the name of a class for an assignment.
- `postal` may be useful for indicating your address when submitting manuscripts, and it will bizarrely only accept single-line entry. (Sorry, I'm still working on that.)
- `email` and `telephone` may also be useful for submitting manuscripts.
- `titlepage` is a logical toggle for shifting the first-page header to a title page.
- `anonymous` is a logical toggle for adding a title page and changing the running header to use the title.
- `biblio-style` allows for other Biblatex-provided citation styles to be set. Setting nothing defaults to MLA, but APA and others work well, too. When using `chicago_document` output, this parameter switches among the options provided by the biblatex-chicago package: `authortitle`, `notes`, etc.

Here's an example with some typical parameters:

```
---
title: Galatea and Spain's Rainy Plains
author: Londyn Britches
date: 16 March 2022
output: rmd4mla::mla_document
bibliography: sources.bib
lastname: Britches
professor: Dr. Falon Downe
class: English 101
# knit: rmd4mla::create_odt
---
```

The header of the resulting PDF document will be styled like this:

<kbd>
  <img src="https://jmclawson.net/rmd4mla_header.png", alt="an image of the top of a PDF document prepared using rmd4mla">
</kbd>


To convert to `.odt`, uncomment the final line by removing both the octothorpe and the space (`# `).
