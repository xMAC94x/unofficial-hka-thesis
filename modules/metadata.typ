#import "check-helpers.typ": *

#let ThesisDegree = (
  master: "Master’s Thesis",
  bachelor: "Bachelor’s Thesis",
  expose: "Exposé"
)
#let ThesisDegreeValues = (ThesisDegree.bachelor, ThesisDegree.master, ThesisDegree.expose)

#let validate-metadata(m) = {
  // Helper: check type + explanation
  let check = (path, expected, explanation, optional: false) => {
    let value = get-path(m, path)
    if value == none {
      if optional { return } // skip if optional and missing
      assert(false, explanation + " (missing)")
    }
    assert(type(value) == expected,
      message: explanation + " (expected " + type-to-str(expected) + ", got " + type-to-str(type(value)) + ")"
    )
  }

  // Helper: check against enum values
  let check-enum = (path, allowed, explanation) => {
    let value = get-path(m, path)
    assert(value in allowed,
      message: explanation + "dd" + get-path(m, "program") + " (must be one of: " + allowed.join(", ") + ")"
    )
  }

  check-enum("degree", ThesisDegreeValues, "Enter the thesis and degree")
  check("program", str, "foo")
  check("title.main", str, "Main title of this thesis, e.g. used for primary language")
  check("title.secondary", str, "Subtitle under the main title (optional)", optional: true)
  check("subtitle.main", str, "a secondary title might be used for a international language", optional: true)
  check("subtitle.secondary", str, "Subtitle under the secondary title (optional)", optional: true)
  check("author", str, "Your name")
  check("matriculation-number", str, "Your HKA matricular number")
  check("place", str, "Where did you write the thesis, probably Karlsruhe")
  check("place-of-work", str, "If the thesis was written in a work-place name it here", optional: true)
  check("supervisor", str, "")
  check("advisor", str, "", optional: true)
  check("start-date", str, "Start date of this thesis")
  check("submission-date", str, "The date you submitted this thesis")

  m
}
