#import "theme.typ": *

#let page-num = state("page-num", 1)

#let next-page() = {
  page-num.update(n => n + 1)
  pagebreak()
}

#let page-number() = context page-num.get()

#let hairline(color: border) = line(length: 100%, stroke: 0.45pt + color)

#let title-text(body) = text(weight: 700, tracking: 0pt, body)

#let label(body, color: muted) = text(size: 7.6pt, weight: 700, fill: color, tracking: 0.6pt)[#upper(body)]

#let section-title(body) = block(spacing: 10pt)[
  #label(body, color: ink)
  #v(3pt)
  #hairline()
]

#let footer() = place(bottom + left, dx: margin-x, dy: -9mm)[
  #text(size: 6.8pt, fill: muted)[Habit Design Workbook]
]

#let footer-number() = place(bottom + right, dx: -margin-x, dy: -9mm)[
  #text(size: 6.8pt, fill: muted)[#page-number()]
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
    columns: (12mm, 1fr),
    gutter: 5mm,
    align: (left, horizon),
    text(size: 8.2pt, weight: 700, fill: muted)[#number],
    [
      #label[Chapter #number]
      #linebreak()
      #text(size: 12.5pt, weight: 700, fill: ink)[#title]
    ]
  )
  #v(3mm)
  #hairline()
]

#let icon-bubble(label-text, fill: wash, color: accent, size: 13mm) = rect(
  width: size,
  height: size,
  radius: 1.5mm,
  fill: fill,
  stroke: 0.45pt + border,
)[
  #align(center + horizon)[
    #text(size: size * 0.32, weight: 700, fill: color)[#label-text]
  ]
]

#let cover() = sheet[
  #box(width: 100%, inset: (x: margin-x, top: 27mm))[
    #hairline()
    #v(35mm)
    #label[A Modern Classic Textbook]
    #v(13mm)
    #text(size: 33pt, weight: 750, fill: ink)[Habit Design]
    #v(4mm)
    #text(size: 17pt, weight: 400, fill: muted)[Workbook]
    #v(11mm)
    #box(width: 118mm)[
      #text(size: 11.2pt, fill: muted)[
        Small systems for habits that survive real schedules, low motivation, and busy weeks.
      ]
    ]
    #v(23mm)
    #rect(width: 34mm, height: 0.65pt, fill: rule)
    #v(10mm)
    #label[Volume 1]
    #v(63mm)
    #hairline()
  ]
]

#let toc-page(entries) = sheet[
  #box(width: 100%, inset: (x: margin-x, top: margin-y))[
    #label[Contents]
    #v(8mm)
    #text(size: 25pt, weight: 750)[Contents]
    #v(13mm)
    #for entry in entries [
      #grid(
        columns: (12mm, 1fr),
        gutter: 5mm,
        align: (left, horizon),
        text(size: 8.6pt, weight: 700, fill: muted)[#entry.at(0)],
        text(size: 11pt, weight: 600)[#entry.at(1)]
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
    #grid(columns: (4mm, 1fr), gutter: 1.4mm, align: (left, top))[
      #text(size: size, fill: muted)[-]
    ][
      #text(size: size)[#item]
    ]
    #v(1.7mm)
  ]
]

#let ordered-stack(items, size: 8.8pt) = [
  #for pair in items.enumerate() [
    #grid(columns: (6mm, 1fr), gutter: 1.4mm, align: (left, top))[
      #text(size: size, weight: 700, fill: muted)[#str(pair.at(0) + 1).]
    ][
      #text(size: size)[#pair.at(1)]
    ]
    #v(1.7mm)
  ]
]

#let chapter-opener(number, title, hook, definition) = sheet[
  #box(width: 100%, inset: (x: margin-x, top: 24mm))[
    #label[Chapter #number]
    #v(8mm)
    #box(width: 140mm)[
      #text(size: 28pt, weight: 750)[#title]
    ]
    #v(8mm)
    #box(width: 126mm)[#text(size: 11.6pt, fill: muted)[#hook]]
    #v(23mm)
    #section-title[Core Idea]
    #v(6mm)
    #grid(
      columns: (15mm, 1fr),
      gutter: 6mm,
      align: (center, top),
      icon-bubble(number, fill: wash, color: accent, size: 12mm),
      definition
    )
  ]
]

#let callout-page(number, title, intro, quote, insight) = sheet[
  #box(width: 100%, inset: (x: margin-x, top: margin-y))[
    #top-rule(number, title)
    #v(16mm)
    #box(width: 132mm)[#intro]
    #v(14mm)
    #rect(width: 100%, fill: wash, stroke: 0.45pt + border, radius: 1.5mm, inset: 7mm)[
      #text(size: 11.6pt, weight: 500, fill: ink)[#quote]
    ]
    #v(10mm)
    #rect(width: 100%, fill: panel, stroke: 0.45pt + border, radius: 1.5mm, inset: 7mm)[
      #grid(columns: (14mm, 1fr), gutter: 6mm, align: (center, horizon),
        icon-bubble("@", fill: wash, color: accent, size: 11mm),
        text(size: 10.8pt, weight: 650)[#insight],
      )
    ]
  ]
]

#let example-card(title, label-text, tint, body) = rect(
  width: 100%,
  stroke: 0.45pt + border,
  fill: panel,
  radius: 1.5mm,
  inset: 5mm,
)[
  #grid(
    columns: (15mm, 1fr),
    gutter: 5mm,
    icon-bubble(label-text, fill: tint, color: accent, size: 12mm),
    [
      #label(title)
      #v(2mm)
      #text(size: 8.6pt)[#body]
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
    #v(6mm)
    #grid(columns: (12mm, 1fr), gutter: 6mm, align: (left, horizon),
      text(size: 13.5pt, weight: 650, fill: muted)[#number],
      text(size: 18pt, weight: 750)[#title],
    )
    #v(7mm)
    #lead
    #v(4mm)
    #examples
    #v(7mm)
    #rect(width: 100%, fill: wash, stroke: 0.45pt + border, radius: 1.5mm, inset: 5mm)[
      #text(size: 10.2pt, weight: 650)[#prompt]
    ]
    #v(8mm)
    #rows
    #if note != none [
      #v(5mm)
      #text(size: 8.8pt, fill: muted)[#note]
    ]
  ]
]

#let examples-strip(left, right) = rect(width: 100%, stroke: 0.45pt + border, fill: panel, radius: 1.5mm, inset: 5mm)[
  #label[Examples]
  #v(2mm)
  #grid(columns: (1fr, 1fr), gutter: 8mm)[
    #text(size: 8.7pt)[#left]
  ][
    #text(size: 8.7pt)[#right]
  ]
]

#let write-row(label-text, body) = [
  #grid(columns: (12mm, 1fr), gutter: 5mm, align: (center, horizon),
    text(size: 7.8pt, weight: 700, fill: muted)[#label-text],
    [
      #text(size: 9.2pt, fill: muted)[#body]
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
      #text(size: 9.4pt, weight: 650)[#prompt]
      #v(8mm)
      #hairline()
      #v(7mm)
      #hairline()
      #v(7mm)
      #hairline()
      #v(10mm)
    ]
    #v(2mm)
    #rect(width: 100%, fill: wash, stroke: 0.45pt + border, radius: 1.5mm, inset: 6mm)[
      #text(size: 9.8pt, weight: 650)[#closing]
    ]
  ]
]
