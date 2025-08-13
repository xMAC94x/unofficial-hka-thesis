#import "@preview/unofficial-hka-thesis:1.0.2": *
#import "abbreviations.typ": abbreviations
#import "settings/metadata.typ": *
#import "settings/settings.typ": *
#import "@preview/glossarium:0.5.4": make-glossary, register-glossary

#show: make-glossary
#register-glossary(abbreviations)

#set document(title: metadata.title.main, author: metadata.author)
#title-page(
  settings: settings,
  metadata: metadata,
  [#grid(
    columns: (1fr, auto, 15pt, auto),
    align(left)[
      #image("/logo/company.svg", height: 1.5cm)
    ],
    align(right)[
      #image("/logo/hka_text.svg", height: 1.0cm)
    ],
    box(width: auto),
    align(right)[
      #image("/logo/hka_horizontal.svg", height: 1.0cm)
    ]
  )]
)

#show: preface.with(settings: settings)

// Citations - applied here so that you are able to use a local CSL file to define the citation style
#set cite(style: settings.citation-style)

// Statutory Declaration
#include "supplementary/statutoryDeclaration.typ"

#pagebreak()

// Abstract
#include "supplementary/abstract.typ"
#pagebreak()

// Abstract German
#include "supplementary/abstractGerman.typ"
#pagebreak()

#listings(abbreviations: abbreviations)

#show: main-body.with(
  settings: settings
)

#include "chapters/1_introduction.typ"

#include "chapters/2_foundations.typ"

//Bibliography
#pagebreak()
#bibliography("bibliography/thesis.bib")

//Appendix
#appendix()[
  #include "chapters/A1_Material.typ"

  #include "chapters/A2_Transcripts.typ"
]
