# rmd4mla
R Markdown templates for MLA-formatted .odt output

## Installation
Use `remotes::install_github("jmclawson/rmd4mla")` to install the R Markdown template file.

In addition to `R`, `rmarkdown`, `knitr`, `tibble`, `dplyr`, and `remotes`, you'll need to have a working setup of `LaTex`, and it'll probably need to be more full-featured than `TinyTex`. Find something that includes `tex4ht`, `make4ht`, `biblatex`, and [`biblatex-mla`](https://ctan.org/pkg/biblatex-mla?lang=en). The package was developed and tested using an installation of [TexLive 2021](https://www.tug.org/texlive/), along with most recent updates available in late February 2022. It might be necessary to manually change one `make4ht` file for preprocessing `.rmd` files for output as `.odt`, since this change may not have been distributed to the CTAN network; see the [February 28th commit](https://github.com/michal-h21/make4ht/commit/a7ed9e73948ce8fd9749e94bd84a7607cca07f9c) for details.

Once these are set up, please cross your fingers and proceed. Things work well on my Mac, but something will certainly go wrong on another system. The functions calling `make4ht` are particularly fragile: they pull together a simple bash command and send it to the system terminal. Who knows whether this will work on Windows, or indeed anywhere outside the limited test environment?

## Description
Bundling together templates and common defaults, the `rmd4mla` package is designed to make it easy to use R Markdown for preparing MLA-formatted documents. For a quick start, three R Markdown templates are provided for use with R Studio's "New File" > "R Markdown..." wizard.

### Three Output Formats

1. `mla_document` prepares a PDF document with MLA-style formatting: text is set in a 12-point serif font face, double-spaced, with running headers, appropriate margins, and [MLA-style citations](https://ctan.org/pkg/biblatex-mla). As an alias to `mla_document`, `pdf_document` does exactly the same thing and is provided to make things easier for anyone with experience using R Markdown.
2. `latex_document` exposes the Latex code prepared before the above format. At the moment, this Latex code is pretty kludgey, so the format is provided to help with troubleshooting.
3. Last recommended of the three, `word_document` sets font faces, sizes, spacing, and margins, but it does not prepare document headers or citations. If you must prepare something in Microsoft Word format---and if you're writing in the humanities, you probably do---you're recommended instead to use the `create_odt` function with the `knit:` parameter in the header, described below.

### Exporting to Microsoft Word

A fourth output format is available using the `knit: rmd4mla::create_odt` parameter in the YAML header. This option will prepare a file in the OpenDocument `.odt` file format, which can be opened by Microsoft Word. The resulting file will lack running headers and page numbers, so you'll have to add these manually. This `.odt` file also seems strangely formed, so please open it using LibreOffice, ignoring your computer's prompt to open it in Microsoft Word. From LibreOffice, it can be exported as a `.docx` file.

When working with a file called `example.rmd`, the typical behavior of `create_odt` will be to delete nearly every file in the project folder named `example.XXX` if it has a modification date later than the R Markdown file. To keep all of these, instead use `create_odt_keep`.

### YAML Parameters
In addition to setting the document's title, author, date, and bibliography, the R Markdown header adds additional parameters: 

- `lastname` defines a running header; if this option is not set, the package will print the title beside the page number.
- `professor` adds a line for indicating an instructor's name for an assignment.
- `class` sets the name of a class for an assignment.
- `postal` may be useful for indicating your address when submitting manuscripts, and it will bizarrely only accept single-line entry. (Sorry, I'm still working on that.)
- `email` and `telephone` may also be useful for submitting manuscripts.
- `titlepage` is a logical toggle for shifting the first-page header to a title page.
- `anonymous` is a logical toggle for adding a title page and changing the running header to use the title.

Here's an example of some of the parameters in action:

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

To convert to `.odt`, uncomment the final line by removing the `# ` before `knit: rmd4mla::create_odt`.