#let title-page(
  settings: (),
  metadata: (),
  content) = {
  set page(
    paper: "a4",
    margin: (left: 30mm, right: 30mm, top: 40mm, bottom: 40mm),
    numbering: "I",
    number-align: center,
    footer: ""
  )

  set text(
    font: settings.font-body,
    size: settings.font-body-size,
    lang: "en"
  )

  set par(leading: 1em)

  content

  v(5mm)
  align(center, text(font: settings.font-heading, 1.9em, weight: 700, "University of Applied Sciences Karlsruhe"))

  v(15mm)

  align(center, text(font: settings.font-heading, 1.5em, weight: 100, metadata.degree + " in " + metadata.program))
  v(8mm)

  if (metadata.title.main.len() > 0 and metadata.subtitle.main.len() > 0
    and metadata.title.secondary.len() > 0 and metadata.subtitle.secondary.len() > 0) {
     align(center, text(font: settings.font-heading, 1.2em, weight: 700, metadata.title.main))
     align(center, text(font: settings.font-heading, 1.2em, weight: 500, metadata.subtitle.main))
     v(10mm)
     align(center, text(font: settings.font-heading, 1.2em, weight: 700, metadata.title.secondary))
     align(center, text(font: settings.font-heading, 1.2em, weight: 500, metadata.subtitle.secondary))
  } else if (metadata.title.main.len() > 0 and metadata.subtitle.main.len() > 0) {
    align(center, text(font: settings.font-heading, 1.8em, weight: 700, metadata.title.main))
    v(5mm)
    align(center, text(font: settings.font-heading, 1.4em, weight: 500, metadata.subtitle.main))
  } else if (metadata.title.main.len() > 0 and metadata.title.secondary.len() > 0) {
    align(center, text(font: settings.font-heading, 1.4em, weight: 700, metadata.title.main))
    v(5mm)
    align(center, text(font: settings.font-heading, 1.4em, weight: 700, metadata.title.secondary))
  } else {
    align(center, text(font: settings.font-heading, 2.0em, weight: 700, metadata.title.main))
  }

  pad(
    top: 3em,
    right: 10%,
    left: 10%,
    grid(
      columns: (3fr, 3fr),
      gutter: 1em,
      strong("Author: "), metadata.author,
      strong("Matriculation Number: "), metadata.matriculation-number,
      if metadata.place-of-work != "" [#strong("Place of Work: ")], [#metadata.place-of-work],
      strong("Supervisor: "), metadata.supervisor,
      if metadata.advisor != "" [#strong("Advisor: ")], [#metadata.advisor],
      strong("Start Date: "), metadata.start-date,
      strong("Submission Date: "), metadata.submission-date,
    )
  )

  pagebreak()
}
