#import "theme.typ": *

#let page-num = state("page-num", 1)

#let next-page() = {
  page-num.update(n => n + 1)
  pagebreak()
}

#let page-number() = context page-num.get()

#let title-text(body) = text(weight: 850, tracking: 0pt, body)

#let hairline(color: border) = line(length: 100%, stroke: 0.38pt + color)

#let section-title(body) = block(spacing: 10pt)[
  #grid(
    columns: (4mm, 1fr),
    gutter: 3mm,
    align: (left, horizon),
    rect(width: 4mm, height: 4mm, fill: teal, radius: 2mm),
    text(size: 14pt, weight: 850, fill: ink)[#upper(body)]
  )
  #v(3pt)
  #hairline()
]

#let footer() = place(bottom + left, dx: margin-x, dy: -9mm)[
  #text(size: 6.6pt, fill: muted)[Small Systems for Everyday Change]
]

#let footer-number() = place(bottom + right, dx: -margin-x, dy: -9mm)[
  #rect(width: 8mm, height: 6mm, fill: panel, stroke: 0.35pt + border, radius: 3mm)[
    #align(center + horizon)[#text(size: 6.8pt, weight: 750, fill: ink)[#page-number()]]
  ]
]

#let sheet(body) = {
  box(width: 100%, height: 100%)[
    #body
    #footer()
    #footer-number()
  ]
}

#let top-rule(number, title) = [
  #grid(
    columns: (10mm, 1fr),
    gutter: 4mm,
    align: (center, horizon),
    rect(width: 9mm, height: 9mm, fill: ink, radius: 4.5mm)[
      #align(center + horizon)[#text(size: 6.8pt, weight: 850, fill: white)[#number]]
    ],
    [
      #text(size: 8.4pt, weight: 850, fill: muted)[CHAPTER #number]
      #linebreak()
      #text(size: 11pt, weight: 850, fill: ink)[#upper(title)]
    ]
  )
  #v(3mm)
  #hairline()
]

#let icon-bubble(label, fill: teal-soft, color: teal, size: 17mm) = rect(
  width: size,
  height: size,
  radius: size / 3,
  fill: fill,
  stroke: 0.4pt + border,
)[
  #align(center + horizon)[
    #text(size: size * 0.43, weight: 850, fill: color)[#label]
  ]
]

#let metric-card(number, label) = rect(
  width: 100%,
  height: 27mm,
  fill: panel,
  stroke: 0.45pt + border,
  radius: 2.5mm,
  inset: 4mm,
)[
  #text(size: 16pt, weight: 900, fill: teal)[#number]
  #linebreak()
  #text(size: 8pt, weight: 800, fill: muted)[#upper(label)]
]

#let cover() = sheet[
  #rect(width: 100%, height: 100%, fill: paper)[
    #place(top + right, dx: -18mm, dy: 18mm)[
      #rect(width: 44mm, height: 44mm, radius: 22mm, fill: teal-soft)[]
    ]
    #place(bottom + left, dx: 0mm, dy: -20mm)[
      #rect(width: 70mm, height: 70mm, radius: 35mm, fill: yellow-soft)[]
    ]
    #box(width: 100%, inset: (x: 22mm, top: 32mm))[
      #grid(columns: (1fr, 42mm), gutter: 8mm, align: (left, top))[
        #rect(fill: ink, radius: 3mm, inset: (x: 5mm, y: 2mm))[
          #text(size: 8.2pt, weight: 850, fill: white)[MODERN WORKBOOK]
        ]
        #v(18mm)
        #text(size: 48pt, weight: 900, fill: ink)[HABIT]
        #linebreak()
        #text(size: 48pt, weight: 900, fill: teal)[DESIGN]
        #v(8mm)
        #box(width: 116mm)[
          #text(size: 13pt, weight: 650, fill: muted)[
            Small systems for habits that survive real schedules, low motivation, and busy weeks.
          ]
        ]
        #v(20mm)
        #grid(columns: (34mm, 34mm, 34mm), gutter: 5mm)[
          #metric-card("01", "Cue")
        ][
          #metric-card("02", "Start")
        ][
          #metric-card("03", "Review")
        ]
      ][
        #rect(width: 38mm, height: 38mm, radius: 5mm, fill: teal, inset: 5mm)[
          #align(center + horizon)[#text(size: 24pt, weight: 900, fill: white)[VOL. 1]]
        ]
      ]
    ]
  ]
]

#let toc-page(entries) = sheet[
  #box(width: 100%, inset: (x: margin-x, top: margin-y))[
    #text(size: 8pt, weight: 850, fill: teal)[WORKBOOK MAP]
    #v(3mm)
    #text(size: 30pt, weight: 900, fill: ink)[Contents]
    #v(7mm)
    #for entry in entries [
      #rect(width: 100%, fill: panel, stroke: 0.4pt + border, radius: 2mm, inset: 4.2mm)[
        #grid(
          columns: (12mm, 1fr),
          gutter: 4mm,
          align: (center, horizon),
          text(size: 14pt, weight: 900, fill: teal)[#entry.at(0)],
          text(size: 11pt, weight: 750, fill: ink)[#entry.at(1)]
        )
      ]
      #v(3mm)
    ]
  ]
]

#let para-stack(items, size: 9.8pt, width: 100%) = box(width: width)[
  #for item in items [
    #text(size: size)[#item]
    #v(3mm)
  ]
]

#let bullet-stack(items, size: 8.8pt) = [
  #for item in items [
    #grid(columns: (4mm, 1fr), gutter: 1.5mm, align: (left, top))[
      #rect(width: 2mm, height: 2mm, radius: 1mm, fill: teal)
    ][
      #text(size: size)[#item]
    ]
    #v(1.7mm)
  ]
]

#let ordered-stack(items, size: 8.8pt) = [
  #for pair in items.enumerate() [
    #grid(columns: (6mm, 1fr), gutter: 1.5mm)[
      #text(size: size, weight: 850, fill: teal)[#str(pair.at(0) + 1).]
    ][
      #text(size: size)[#pair.at(1)]
    ]
    #v(1.7mm)
  ]
]

#let chapter-opener(number, title, hook, definition) = sheet[
  #box(width: 100%, inset: (x: margin-x, top: 18mm))[
    #grid(columns: (1fr, 24mm), gutter: 8mm, align: (left, top))[
      #text(size: 8pt, weight: 850, fill: teal)[CHAPTER #number]
      #v(5mm)
      #text(size: 32pt, weight: 900, fill: ink)[#upper(title)]
      #v(5mm)
      #box(width: 122mm)[#text(size: 11pt, weight: 550, fill: muted)[#hook]]
    ][
      #rect(width: 22mm, height: 22mm, fill: teal, radius: 6mm)[
        #align(center + horizon)[#text(size: 15pt, weight: 900, fill: white)[#number]]
      ]
    ]
    #v(17mm)
    #rect(width: 100%, fill: panel, stroke: 0.45pt + border, radius: 3mm, inset: 7mm)[
      #grid(
        columns: (20mm, 1fr),
        gutter: 6mm,
        icon-bubble("?", fill: teal-soft, color: teal, size: 16mm),
        [
          #text(size: 8.3pt, weight: 850, fill: muted)[CORE IDEA]
          #v(2mm)
          #definition
        ]
      )
    ]
  ]
]

#let callout-page(number, title, intro, quote, insight) = sheet[
  #box(width: 100%, inset: (x: margin-x, top: margin-y))[
    #top-rule(number, title)
    #v(12mm)
    #align(center)[#box(width: 118mm)[#intro]]
    #v(14mm)
    #align(center)[
      #rect(width: 138mm, radius: 3mm, stroke: 0.5pt + border, fill: panel, inset: 8mm)[
        #text(size: 12pt, weight: 750, fill: ink)[#quote]
      ]
    ]
    #v(12mm)
    #align(center)[
      #rect(width: 138mm, radius: 3mm, stroke: 0.6pt + teal, fill: teal-soft, inset: 8mm)[
        #grid(columns: (18mm, 1fr), gutter: 6mm, align: (center, horizon),
          icon-bubble("@", fill: panel, color: teal, size: 15mm),
          text(size: 11pt, weight: 750, fill: ink)[#insight],
        )
      ]
    ]
  ]
]

#let example-card(title, label, tint, body) = rect(
  width: 100%,
  radius: 3mm,
  stroke: 0.45pt + border,
  fill: panel,
  inset: 5.5mm,
)[
  #grid(
    columns: (18mm, 1fr),
    gutter: 5mm,
    icon-bubble(label, fill: tint, color: ink, size: 15mm),
    [
      #text(size: 8pt, weight: 850, fill: teal)[#upper(title)]
      #v(2mm)
      #text(size: 8.4pt)[#body]
    ],
  )
]

#let examples-page(examples) = sheet[
  #box(width: 100%, inset: (x: margin-x, top: margin-y))[
    #section-title[Field Examples]
    #v(4mm)
    #examples
  ]
]

#let drill-page(number, title, lead, prompt, examples, rows, note: none) = sheet[
  #box(width: 100%, inset: (x: margin-x, top: margin-y))[
    #section-title[Practice]
    #v(4mm)
    #grid(columns: (16mm, 1fr), gutter: 6mm, align: (center, horizon),
      icon-bubble(number, fill: ink, color: white, size: 13mm),
      text(size: 17pt, weight: 900, fill: ink)[#upper(title)],
    )
    #v(6mm)
    #rect(width: 100%, radius: 3mm, fill: panel, stroke: 0.45pt + border, inset: 5mm)[
      #lead
    ]
    #v(5mm)
    #align(center)[#examples]
    #v(7mm)
    #rect(width: 100%, radius: 3mm, stroke: 0.6pt + teal, fill: teal-soft, inset: 5mm)[
      #grid(columns: (13mm, 1fr), gutter: 4mm, align: (center, horizon),
        icon-bubble("?", fill: panel, color: teal, size: 11mm),
        text(size: 10.2pt, weight: 850)[#prompt],
      )
    ]
    #v(7mm)
    #rows
    #if note != none [
      #v(5mm)
      #text(size: 8.6pt, weight: 650, fill: muted)[#note]
    ]
  ]
]

#let examples-strip(left, right) = rect(width: 134mm, radius: 3mm, stroke: 0.45pt + border, fill: panel, inset: 5mm)[
  #text(size: 8pt, weight: 850, fill: teal)[EXAMPLES]
  #v(2mm)
  #grid(columns: (1fr, 1fr), gutter: 8mm)[
    #text(size: 8.8pt)[#left]
  ][
    #text(size: 8.8pt)[#right]
  ]
]

#let write-row(label, body) = [
  #grid(columns: (13mm, 1fr), gutter: 5mm, align: (center, horizon),
    rect(width: 10mm, height: 10mm, radius: 5mm, stroke: 0.45pt + border, fill: panel)[
      #align(center + horizon)[#text(size: 7.2pt, weight: 850, fill: teal)[#label]]
    ],
    [
      #text(size: 9.2pt, fill: muted)[#body]
      #v(3mm)
      #line(length: 100%, stroke: 0.5pt + border)
    ],
  )
  #v(4.5mm)
]

#let reflection-page(prompts, closing) = sheet[
  #box(width: 100%, inset: (x: margin-x, top: margin-y))[
    #section-title[Reflection]
    #v(8mm)
    #for prompt in prompts [
      #rect(width: 100%, fill: panel, stroke: 0.4pt + border, radius: 2.5mm, inset: 4.5mm)[
        #text(size: 9pt, weight: 700)[#prompt]
        #v(7mm)
        #hairline(color: rgb("#c7d0dd"))
        #v(6mm)
        #hairline(color: rgb("#c7d0dd"))
      ]
      #v(5mm)
    ]
    #v(3mm)
    #rect(width: 100%, radius: 3mm, stroke: 0.55pt + teal, fill: teal-soft, inset: 6mm)[
      #grid(columns: (17mm, 1fr), gutter: 6mm, align: (center, horizon),
        icon-bubble("*", fill: panel, color: teal, size: 14mm),
        text(size: 10pt, weight: 800)[#closing],
      )
    ]
  ]
]
