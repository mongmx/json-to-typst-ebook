#import "theme.typ": *

#let page-num = state("page-num", 1)

#let next-page() = {
  page-num.update(n => n + 1)
  pagebreak()
}

#let page-number() = context page-num.get()

#let hairline(color: border) = line(length: 100%, stroke: 0.45pt + color)

#let title-text(body) = text(weight: 700, body)

#let small-caps(body, color: muted) = text(size: 8pt, weight: 700, fill: color)[#upper(body)]

#let section-title(body) = block(spacing: 10pt)[
  #small-caps(body, color: ink)
  #v(3pt)
  #hairline(color: rule)
]

#let footer() = place(bottom + left, dx: margin-x, dy: -9mm)[
  #text(size: 7pt, fill: muted)[Habit Design Workbook]
]

#let footer-number() = place(bottom + right, dx: -margin-x, dy: -9mm)[
  #text(size: 7pt, fill: muted)[#page-number()]
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
    columns: (14mm, 1fr),
    gutter: 5mm,
    align: (left, horizon),
    text(size: 9pt, weight: 700, fill: muted)[#number],
    [
      #small-caps[Chapter #number]
      #linebreak()
      #text(size: 12pt, weight: 700, fill: ink)[#title]
    ]
  )
  #v(3mm)
  #hairline(color: rule)
]

#let icon-bubble(label, fill: wash, color: ink, size: 15mm) = rect(
  width: size,
  height: size,
  radius: 0pt,
  fill: fill,
  stroke: 0.45pt + border,
)[
  #align(center + horizon)[
    #text(size: size * 0.34, weight: 700, fill: color)[#label]
  ]
]

#let cover() = sheet[
  #box(width: 100%, inset: (x: margin-x, top: 25mm))[
    #align(center)[
      #hairline(color: rule)
      #v(18mm)
      #small-caps[A Practical Textbook]
      #v(14mm)
      #text(size: 34pt, weight: 700, fill: ink)[HABIT DESIGN]
      #v(5mm)
      #text(size: 18pt, fill: muted)[Workbook]
      #v(14mm)
      #box(width: 112mm)[
        #align(center)[
          #text(size: 11.4pt, fill: muted)[
            Small systems for habits that survive real schedules, low motivation, and busy weeks.
          ]
        ]
      ]
      #v(22mm)
      #rect(width: 46mm, height: 0.65pt, fill: rule)
      #v(12mm)
      #small-caps[Volume 1]
      #v(58mm)
      #hairline(color: rule)
    ]
  ]
]

#let toc-page(entries) = sheet[
  #box(width: 100%, inset: (x: margin-x, top: margin-y))[
    #small-caps[Contents]
    #v(8mm)
    #text(size: 26pt, weight: 700)[Contents]
    #v(11mm)
    #for entry in entries [
      #grid(
        columns: (12mm, 1fr),
        gutter: 5mm,
        align: (left, horizon),
        text(size: 9.5pt, weight: 700, fill: muted)[#entry.at(0)],
        text(size: 11.2pt, weight: 600)[#entry.at(1)]
      )
      #v(3mm)
      #hairline()
      #v(4mm)
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
      #text(size: size)[-]
    ][
      #text(size: size)[#item]
    ]
    #v(1.6mm)
  ]
]

#let ordered-stack(items, size: 8.8pt) = [
  #for pair in items.enumerate() [
    #grid(columns: (6mm, 1fr), gutter: 1.5mm, align: (left, top))[
      #text(size: size, weight: 700)[#str(pair.at(0) + 1).]
    ][
      #text(size: size)[#pair.at(1)]
    ]
    #v(1.6mm)
  ]
]

#let chapter-opener(number, title, hook, definition) = sheet[
  #box(width: 100%, inset: (x: margin-x, top: 23mm))[
    #align(center)[
      #small-caps[Chapter #number]
      #v(7mm)
      #text(size: 28pt, weight: 700)[#title]
      #v(5mm)
      #rect(width: 32mm, height: 0.55pt, fill: rule)
      #v(11mm)
      #box(width: 128mm)[#align(center)[#text(size: 12pt, fill: muted)[#hook]]]
    ]
    #v(24mm)
    #section-title[Core Idea]
    #v(5mm)
    #grid(
      columns: (17mm, 1fr),
      gutter: 6mm,
      align: (center, top),
      icon-bubble(number, fill: wash, color: ink, size: 14mm),
      definition
    )
  ]
]

#let callout-page(number, title, intro, quote, insight) = sheet[
  #box(width: 100%, inset: (x: margin-x, top: margin-y))[
    #top-rule(number, title)
    #v(15mm)
    #box(width: 132mm)[#intro]
    #v(13mm)
    #rect(width: 100%, fill: wash, stroke: 0.45pt + border, inset: 7mm)[
      #text(size: 12pt, style: "italic")[#quote]
    ]
    #v(11mm)
    #rect(width: 100%, fill: panel, stroke: 0.45pt + border, inset: 7mm)[
      #grid(columns: (15mm, 1fr), gutter: 6mm, align: (center, horizon),
        icon-bubble("@", fill: paper, color: ink, size: 12mm),
        text(size: 11pt, weight: 600)[#insight],
      )
    ]
  ]
]

#let example-card(title, label, tint, body) = rect(
  width: 100%,
  stroke: 0.45pt + border,
  fill: panel,
  inset: 5mm,
)[
  #grid(
    columns: (16mm, 1fr),
    gutter: 5mm,
    icon-bubble(label, fill: tint, color: ink, size: 13mm),
    [
      #small-caps(title)
      #v(2mm)
      #text(size: 8.7pt)[#body]
    ],
  )
]

#let examples-page(examples) = sheet[
  #box(width: 100%, inset: (x: margin-x, top: margin-y))[
    #section-title[Field Examples]
    #v(5mm)
    #examples
  ]
]

#let drill-page(number, title, lead, prompt, examples, rows, note: none) = sheet[
  #box(width: 100%, inset: (x: margin-x, top: margin-y))[
    #section-title[Practice]
    #v(5mm)
    #grid(columns: (13mm, 1fr), gutter: 6mm, align: (left, horizon),
      text(size: 15pt, weight: 700, fill: muted)[#number],
      text(size: 17pt, weight: 700)[#title],
    )
    #v(7mm)
    #lead
    #v(4mm)
    #examples
    #v(7mm)
    #rect(width: 100%, fill: wash, stroke: 0.45pt + border, inset: 5mm)[
      #text(size: 10.5pt, weight: 600)[#prompt]
    ]
    #v(8mm)
    #rows
    #if note != none [
      #v(5mm)
      #text(size: 8.8pt, fill: muted)[#note]
    ]
  ]
]

#let examples-strip(left, right) = rect(width: 100%, stroke: 0.45pt + border, fill: panel, inset: 5mm)[
  #small-caps[Examples]
  #v(2mm)
  #grid(columns: (1fr, 1fr), gutter: 8mm)[
    #text(size: 8.8pt)[#left]
  ][
    #text(size: 8.8pt)[#right]
  ]
]

#let write-row(label, body) = [
  #grid(columns: (12mm, 1fr), gutter: 5mm, align: (center, horizon),
    text(size: 8pt, weight: 700, fill: muted)[#label],
    [
      #text(size: 9.4pt, fill: muted)[#body]
      #v(3mm)
      #hairline()
    ],
  )
  #v(5mm)
]

#let reflection-page(prompts, closing) = sheet[
  #box(width: 100%, inset: (x: margin-x, top: margin-y))[
    #section-title[Notes and Reflection]
    #v(10mm)
    #for prompt in prompts [
      #text(size: 9.6pt, weight: 600)[#prompt]
      #v(8mm)
      #hairline()
      #v(7mm)
      #hairline()
      #v(7mm)
      #hairline()
      #v(10mm)
    ]
    #v(2mm)
    #rect(width: 100%, fill: wash, stroke: 0.45pt + border, inset: 6mm)[
      #text(size: 10.2pt, weight: 600)[#closing]
    ]
  ]
]
