#import "modules/titlepage.typ": *
#import "modules/metadata.typ": ThesisDegree, ThesisDegreeValues, validate-metadata
#import "modules/settings.typ": validate-settings
#import "@preview/glossarium:0.5.4": print-glossary, register-glossary

#let in-outline = state("in-outline", false)
#let flex-caption(long, short) = context {
  if in-outline.at(here()) { short } else { long }
}

#let preface(
  settings: (),
  preface
) = {
  // Page Setup
  set page(
    margin: (
      left: settings.page-margins.left,
      right: settings.page-margins.right,
      top: settings.page-margins.top,
      bottom: settings.page-margins.bottom
    ),
    numbering: "I",
    number-align: center
  )
  counter(page).update(2)

  // Body Font Family
  set text(
    font: settings.font-body,
    size: settings.font-body-size,
    lang: settings.language
  )

  show math.equation: set text(weight: 400)

  // Headings
  show heading: set block(
    below: settings.headings-spacing.below,
    above: settings.headings-spacing.above
  )
  show heading: set text(font: settings.font-body, size: settings.font-heading-size)
  set heading(numbering: none)

  // Paragraphs
  set par(leading: settings.distance-between-lines, justify: true)

  // Figures
  show figure: set text(size: settings.font-figures-subtitle-size)

  //Indentation of Lists
  set list(indent: settings.list-indentation)
  set enum(indent: settings.list-indentation)

  preface
}

#let listings(
  abbreviations: ()
) = {
  register-glossary(abbreviations)
  // Enable short captions to omit citations
  show outline: it => {
      in-outline.update(true)
      it
      in-outline.update(false)
  }

  // Table of Contents
  outline(
    title: {
      heading(outlined: false, "Table of Contents")

    },
    target: heading.where(supplement: [Chapter], outlined: true),
    indent: auto,
    depth: 3
  )

  v(2.4fr)
  pagebreak(weak: true)

  // List of Figures
  outline(
    title: {
      heading(outlined: false, "List of Figures")

    },
    target: figure.where(kind: image),
  )
  pagebreak(weak: true)

  // List of Tables
  outline(
    title: {
      heading(outlined: false, "List of Tables")

    },
    target: figure.where(kind: table)
  )
  pagebreak(weak: true)

  // List of Listings
  outline(
    title: {
      heading(outlined: false, "List of Listings")

    },
    target: figure.where(kind: raw)
  )
  pagebreak(weak: true)

  // List of Abbreviations
  heading(outlined: false)[List of Abbreviations]

  print-glossary(
    abbreviations,
    show-all: false,
    disable-back-references: true,
  )
}

#let main-body(
  settings: (),
  body
) = {
  // Main Body
  set heading(numbering: settings.headings-numbering-style, supplement: [Chapter])
  show heading.where(level: 1): it => {
    if it.numbering == none {
      [
        #it
      ]
    } else {
      [
        #pagebreak(weak: true)
        #it
      ]
    }

    counter(figure.where(kind: table)).update(0);
    counter(figure.where(kind: image)).update(0);
    counter(figure.where(kind: raw)).update(0);
  }

  set figure(numbering: it => {
    let numbering-of-heading = counter(heading).display();
    let top-level-number = numbering-of-heading.slice(0, numbering-of-heading.position("."))
    [#top-level-number.#it]
  })

  set page(
    // Header with current heading
    header: context {
      let elements = query(
        selector(heading.where(depth: 1)).after(here())
      )

      // Don't show header if a new chapter is starting at the current page
      if elements != () and elements.first().location().page() == here().page() and elements.first().depth == 1 {
          return;
      }

      let display-heading
      let display-numbering
      let element
      elements = query(selector(heading).after(here()))
      if elements != () and elements.first().location().page() == here().page() {
        element = elements.first()
        if element.has("numbering") and element.numbering != none {
          display-numbering = numbering(element.numbering, ..counter(heading).at(element.location()))
        } else {
          display-numbering = numbering(settings.headings-numbering-style, ..counter(heading).at(element.location()))
        }

        display-heading = element.body
      } else {
        // Otherwise take the next heading backwards
        elements = query(
          heading.where().before(here())
        )
        if elements != () {
          element = elements.last()
          if element.has("numbering") and element.numbering != none {
            display-numbering = numbering(element.numbering, ..counter(heading).at(element.location()))
          } else {
            display-numbering = numbering(settings.headings-numbering-style, ..counter(heading).at(element.location()))
          }

          display-heading = element.body
        }
      }

      align(center, display-numbering + " " + display-heading)
      line(length: 100%, stroke: (paint: gray))
    },

    // Footer with Page Numbering
    footer: context {
      let current-page = counter(page).display()
      let final-page = counter(page).final().first()

      line(length: 100%, stroke: (paint: gray))
      align(center)[#current-page / #final-page]
    }
  )

  set page(
    numbering: "1/1",
    number-align: center,
  )
  counter(page).update(1)
  // Set after header and after all initial pages to just apply it to the acutal content
  set par(spacing: settings.space-before-paragraph, justify: true)

  // Actual Content
  body
}

// Appendix
#let appendix(body) = {
  pagebreak()
  outline(
    title: {
      heading("Appendix", outlined: true, numbering: none)
    },
    target: heading.where(supplement: [Appendix], outlined: true),
    indent: auto,
    depth: 3
  )

  counter(heading).update(0)
  set heading(numbering: "A.1.", supplement: [Appendix])
  show heading: it => {
    let prefixed-numbering;
    if it.level == 1 and it.numbering != none {
      prefixed-numbering = [#it.supplement #counter(heading).display()]
    } else if it.numbering != none {
      prefixed-numbering = [#counter(heading).display()]
    }

    block(
      below: 0.85em,
      above: 1.75em
    )[
      #prefixed-numbering #it.body
    ]
  }

  set figure(numbering: it => {
    let alphabet = ("A", "B", "C", "D", "E", "F", "G", "H", "I", "J", "K", "L", "M", "N", "O", "P", "Q", "R", "S", "T", "U", "V", "W", "X", "Y", "Z")
    let numbering-of-heading = counter(heading).display();
    let top-level-number = numbering-of-heading.slice(0, numbering-of-heading.position("."))
    let index = alphabet.position((el) => { el == top-level-number})

    if index == none {
      let numberingToAlphabet = numbering("A", int(top-level-number))
      [#numberingToAlphabet.#it]
    } else {
      [#top-level-number.#it]
    }
  })

  show heading.where(level: 1): it => {
    if it.numbering == none {
      [
        #it
      ]
    } else {
      [
        #pagebreak()
        #it
      ]
    }

    counter(figure.where(kind: table)).update(0);
    counter(figure.where(kind: image)).update(0);
    counter(figure.where(kind: raw)).update(0);
  }

  body
}
