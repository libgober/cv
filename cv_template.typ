#import "@preview/datify:1.0.1": *

// page

// font
#set text(font: ("Libertinus Serif"), size: 12pt)

// header block
#let tight-stack(body) = par(leading: 0.5em)[#body]

#let cv-header(name: none, l: none, r: none) = {
  set text(size: 24pt, weight: "bold")
  [ #name]

  v(-0.5em)
  
  set text(size: 12pt, weight:"regular")
  grid(
    columns: (1fr, 1fr),
    column-gutter: 1em,
    [
      #align(left)[ #tight-stack[#l]]
    ],
    [
      #align(right)[ #tight-stack[#r]]
    ],
  )
}
// customize how sections look
#let cv(body) = {
  set page(numbering: "1")
  set text(size: 11pt)
  show heading.where(level: 1): it => block(
    above: 1.5em,
    below: 1em,
  )[
    #text(size: 14pt, weight: "bold")[
      #upper(it.body)
    ]
  ]

    show heading.where(level: 2): it => block(
    above: 1.5em,
    below: 1em,
  )[
    #text(size: 14pt, weight: "semibold")[
      #smallcaps(it.body)
    ]
  ]

    show heading.where(level: 3): it => block(
    above: 1em,
    below: 1em,
  )[
    #text(size: 14pt, weight: "regular")[
      #it.body
    ]
  ]
  
  body
}

#let render-education-item(item) = {

    // collect content
    let parts = ()

    if "institution" in item {
      parts.push(item.institution)
    }
  
    if "field" in item {
      parts.push(item.field)
    }

    if "honors" in item{
      parts.push(emph(item.honors))
    }
  
    if "year" in item {
      parts.push(str(item.year))
    }

  grid(
    columns: (3.3em, 1fr),
    column-gutter: 0.8em,
    align(left)[#strong(item.degree)],
    [ 
      #parts.join[, ]
      #if "details" in item {
        [\ #item.details]
      }
    ]
  )
}

#let render-dates(item) = {
  if item.date_end == none {
    [#str(item.date_start)--]
  } else {
    [#str(item.date_start)--#str(item.date_end)]
  }
}

#let render-appointment-item(item) = {
  grid(
    columns: (4.8em, 1fr),
    column-gutter: 0.8em,
    align(left)[#render-dates(item)],
    [
      #item.institution 
      #for a in item.affiliations {
        if "dept" in a {
          [\ #a.title, #a.dept]
        } else {
          [\ #a.title]
        }
        
      }
      

    ],
  )
  
}

#let render-peer-pub-item(item) = {
  let key = item.key
  par(hanging-indent: 1.5em)[
  #cite(label(key) ,form: "full",style: "chicago-notes"). 
  #if "status" in item {[(#item.status)]}
]
}



#let render-name-list(names) = {
  let n = names.len()

  if n == 0 {
    []
  } else if n == 1 {
    names.at(0)
  } else if n == 2 {
    [#names.at(0) and #names.at(1)]
  } else {
    let parts = ()

    for i in range(0, n - 1) {
      parts.push(names.at(i))
    }

    parts.push([and #names.at(n - 1)])
    parts.join[, ]
  }
}

#let render-coauthors(item) = {
  if "coauthors" in item and item.coauthors != none and item.coauthors.len() > 0 {
    [#emph[with] #render-name-list(item.coauthors)]
  } else {
    []
  }
}

#let render_working_paper(item) = {
  par(hanging-indent: 1.5em)["#item.title" #render-coauthors(item).
  #if "notes" in item and item.notes != none  {
    emph()[#item.notes]
  }]
}


#let parse-date(d) = {
  let parts = d.split("-")
  datetime(
    year: int(parts.at(0)),
    month: int(parts.at(1)),
    day: int(parts.at(2)),
  )
}

#let date-year(d) = custom-date-format(parse-date(d), pattern: "yyyy")

#let date-short(d) = custom-date-format(parse-date(d), pattern: "MMM d")

#let date-full(d) = custom-date-format(parse-date(d), pattern: "MMM d, yyyy")

#let render_talk(item) = {
  let parts = ()
  
  parts.push(strong[#item.host.])
  
  parts.push(["#item.title."])

  if "role" in item {
    parts.push([#item.role.])
  }
  
  let ds = if "date" in item {
    item.date
  } else {
    item.date_start
  }

  let de = if "date" in item {
    item.date
  } else {
    item.date_end
  }

  if ds == de {
    parts.push(date-short(ds))
  } else {
    let tmp = ()
    tmp.push(date-short(ds))
    tmp.push(date-short(de))
    parts.push(tmp.join([-]))
  }

  
  block(below: 1em, breakable: false)[
  #grid( 
      columns: (2em, 1fr),
      column-gutter: 0.9em,
      align(left)[#date-year(ds)],
      [#parts.join([ ]).]
    )
  ]

}

// advising



#let has-field(item, key) = {
  key in item and item.at(key) != none and item.at(key) != ""
}

#let linked-name(item) = {
  if has-field(item, "website") {
    link(item.website)[#item.name]
  } else {
    item.name
  }
}

#let render-current-committee(item) = {
  let parts = ()

  parts.push(linked-name(item))

  if has-field(item, "institution") {
    parts.push(item.institution)
  }

  block(below: 0.5em, breakable: false)[
    #parts.join[, ].
  ]
}

// teaching


#let render-course(item) = {
  let parts = ()

  parts.push(item.title)

  if has-field(item, "level") {
    parts.push(item.level)
  }

  if has-field(item, "role") {
    parts.push(item.role)
  }

  if has-field(item, "term") {
    parts.push([(#item.term)])
  }

  block(below: 0.5em, breakable: false)[
    #grid(
      columns: (3em, 1fr),
      column-gutter: 0.9em,
      align(left)[#item.year],
      [
        #parts.join[. ].
      ],
    )
  ]
}

// service


#let render-service-dates(item) = {
  if has-field(item, "ongoing") and item.ongoing {
    [#item.date_start\--]
  } else if has-field(item, "date_end") and item.date_start != item.date_end {
    [#item.date_start\--#item.date_end]
  } else {
    [#item.date_start]
  }
}

#let render-service-item(item) = {
  let parts = ()

  if has-field(item, "role") {
    parts.push(item.role)
  }

  if has-field(item, "unit") {
    parts.push([“#item.unit”])
  }

  if has-field(item, "organization") {
    parts.push(item.organization)
  }

  block(below: 0.5em, breakable: false)[
    #grid(
      columns: (5em, 1fr),
      column-gutter: 0.9em,
      align(left)[#render-service-dates(item)],
      [
        #parts.join[, ].
      ],
    )
  ]
}



#let render-advising-date(item) = {
  if has-field(item, "date") {
    item.date
  } else if has-field(item, "date_end") {
    [#item.date_start\-#item.date_end]
  } else if has-field(item, "date_start") {
    [#item.date_start\-]
  } else {
    []
  }
}

#let render-undergrad-item(item) = block(below: 0.5em, breakable: false)[
  #let parts = ()
  #parts.push(item.name)

  #if has-field(item, "institution") {
      parts.push([, #item.institution])
      }
  #block(below: 1em, breakable: false)[
    #grid(
      columns: (6em, 1fr),
      column-gutter: 0em,
      align(left)[#render-advising-date(item)],
      [#parts.join().]
    )
  ]
]


#let render-placement(p) = {
  if has-field(p, "title") and has-field(p, "employer") {
    [#p.title, #p.employer]
  } else if has-field(p, "title") {
    [#p.title]
  } else if has-field(p, "employer") {
    [#p.employer]
  } else {
    []
  }
}

#let render-placements(placements) = {
  let parts = ()

  for p in placements {
    parts.push(render-placement(p))
  }

  parts.join[; ]
}

#let render-former-committee(item) = block(below: 0.5em, breakable: false)[
  #grid(
    columns: (2em, 1fr),
    column-gutter: 0.9em,
    align(left)[#item.year],
    [
      #linked-name(item), #item.phd_institution\
      #if has-field(item, "placements") and item.placements.len() > 0 {
        [#render-placements(item.placements)]
      }
    ],
  )
]



#let has-field(item, key) = {
  key in item and item.at(key) != none and item.at(key) != ""
}

#let date-range(item) = {
  if has-field(item, "date_end") {
    if item.date_start == item.date_end {
      [#item.date_start]
    } else {
        [#item.date_start - #item.date_end]
    }
  } else {
    [#item.date_start]
  }
}


#let render-quoted-title(item, has-following: false) = {
  if has-following {
    ["#item.name,"]
  } else {
    ["#item.name"]
  }
}

#let render-award(item) = {
  let parts = ()

  if has-field(item, "organization") {
    parts.push(strong(item.organization))
  }
  
  if has-field(item, "name") {
    parts.push([-- #item.name])
}

  if has-field(item, "award_number") {
    parts.push(item.award_number)
  }

  
  if has-field(item, "amount") {
    parts.push([-- #item.amount])
  }

  block(below: 1em, breakable: false)[
    #grid(
      columns: (4.8em, 1fr),
      column-gutter: 0.9em,
      align(left)[#date-range(item)],
      [
        #parts.join[ ].
      ],
    )
  ]
}
