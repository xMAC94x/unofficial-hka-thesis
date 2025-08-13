// Helper: get nested value by path "a.b.c"
#let get-path(obj, path) = {
  // Empty path just yields the object itself.
  if path == "" { return obj }

  // Split on dots and ignore empty segments (e.g. accidental "..")
  let parts = path.split(".").filter(it => it != "")
  let cur = obj

  for key in parts {
    if type(cur) != dictionary { return none }
    let next = cur.at(key, default: none)
    if next == none { return none }
    cur = next
  }

  cur
}

#let type-to-str(type) = {
  if type == int {
    return "int"
  } else if type == float {
    return "float"
  } else if type == str {
    return "str"
  } else if type == label {
    return "label"
  } else if type == content {
    return "content"
  } else if type == function {
    return "function"
  } else if type == type {
    return "type"
  } else if type == length {
    return "length"
  }
  return ""
}
