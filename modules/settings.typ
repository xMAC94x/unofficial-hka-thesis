#import "check-helpers.typ": *

#let validate-settings(s) = {
  // Helper: check type + explanation
  let check = (path, expected, explanation) => {
    let value = get-path(s, path)
    assert(type(value) == expected,
      message: explanation + " (expected " + type-to-str(expected) + ", got " + type-to-str(type(value)) + ")"
    )
  }

  check("language", str, "language of the text in this document, e.g. `en`")
  check("font-body", str, "name of the font used within the document body")
  check("font-body-size", length, "font size used within the document body")
  check("font-figures-subtitle-size", length, "")
  check("font-heading", str, "name of the font used within the document heading")
  check("font-heading-size", length, "font size used within the document heading")
  check("headings-numbering-style", str, "number style of headings, e.g. '1.1.'")
  check("headings-spacing.above", length, "")
  check("headings-spacing.below", length, "")
  check("citation-style", str, "used citation style within this work")
  check("space-before-paragraph", length, "")
  check("distance-between-lines", length, "")
  check("list-indentation", length, "")
  check("page-margins.top", length, "")
  check("page-margins.bottom", length, "")
  check("page-margins.left", length, "")
  check("page-margins.right", length, "")

  s
}
