#import "theme.typ": *

#let page-num = state("page-num", 1)

#let next-page() = {
  page-num.update(n => n + 1)
  pagebreak()
}

#let page-number() = context page-num.get()

#let title-text(body) = text(weight: 900, tracking: 0pt, body)

#let section-title(body) = block(spacing: 10pt)[
  #text(size: 16pt, weight: 850, fill: ink, body)
  #v(4pt)
  #rect(width: 11mm, height: 1.2mm, fill: yellow, radius: 0.6mm)
]

#let footer() = place(bottom + left, dx: margin-x, dy: -9mm)[
  #text(size: 6.6pt, fill: muted)[Small Systems for Everyday Change]
]

#let footer-number() = place(bottom + right, dx: -margin-x, dy: -9mm)[
  #text(size: 7.5pt, weight: 800, fill: ink)[#page-number()]
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
    columns: (8mm, 1fr),
    gutter: 3mm,
    align: (center, horizon),
    rect(width: 8mm, height: 7mm, fill: yellow, radius: 1mm)[
      #align(center + horizon)[#text(size: 7.5pt, weight: 900, fill: navy)[#number]]
    ],
    text(size: 8.7pt, weight: 850, fill: ink)[#upper(title)]
  )
  #v(2.8mm)
  #line(length: 100%, stroke: 0.45pt + rgb("#8290a5"))
]

#let icon-bubble(label, fill: blue-soft, color: navy, size: 17mm) = rect(
  width: size,
  height: size,
  radius: size / 2,
  fill: fill,
  stroke: 0.4pt + border,
)[
  #align(center + horizon)[
    #text(size: size * 0.48, weight: 900, fill: color)[#label]
  ]
]

#let cover() = sheet[
  #rect(width: 100%, height: 100%, fill: navy)[
    #place(center + horizon)[
      #align(center)[
        #rect(fill: yellow, radius: 1.2mm, inset: (x: 5mm, y: 1.8mm))[
          #text(size: 9pt, weight: 900, fill: navy)[PRACTICAL HABIT SYSTEMS]
        ]
        #v(7mm)
        #text(size: 38pt, weight: 900, fill: white)[HABIT]
        #linebreak()
        #text(size: 44pt, weight: 900, fill: yellow)[DESIGN]
        #linebreak()
        #text(size: 34pt, weight: 900, fill: white)[WORKBOOK]
        #v(7mm)
        #rect(width: 92mm, stroke: 0.8pt + white, radius: 1.4mm, inset: (x: 7mm, y: 2.2mm))[
          #text(size: 15pt, weight: 900, fill: white, tracking: 2.8pt)[FOR REAL WEEKS]
        ]
        #v(8mm)
        #box(width: 88mm)[
          #text(size: 10.2pt, weight: 800, fill: white)[
            A WORKBOOK FOR BUILDING SMALL HABITS THAT SURVIVE BUSY DAYS.
          ]
        ]
        #v(14mm)
        #icon-bubble("!", fill: rgb("#f3f8ff"), color: yellow, size: 28mm)
        #v(11mm)
        #rect(fill: yellow, radius: 1.5mm, inset: (x: 7mm, y: 2.2mm))[
          #text(size: 12pt, weight: 900, fill: navy)[VOL. 1]
        ]
      ]
    ]
  ]
]

#let toc-page(entries) = sheet[
  #box(width: 100%, inset: (x: margin-x, top: margin-y))[
    #text(size: 9pt, weight: 900, fill: rgb("#9b6b00"))[WORKBOOK MAP]
    #v(3mm)
    #text(size: 28pt, weight: 900, fill: navy)[CONTENTS]
    #v(9mm)
    #for entry in entries [
      #grid(
        columns: (12mm, 1fr),
        gutter: 4mm,
        align: (center, horizon),
        rect(width: 8mm, height: 7mm, fill: yellow, radius: 1mm)[
          #align(center + horizon)[#text(size: 7.5pt, weight: 900, fill: navy)[#entry.at(0)]]
        ],
        text(size: 11pt, weight: 800, fill: ink)[#entry.at(1)]
      )
      #v(3mm)
      #line(length: 100%, stroke: 0.35pt + border)
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
    #grid(columns: (4mm, 1fr), gutter: 1mm)[
      #text(size: size)[•]
    ][
      #text(size: size)[#item]
    ]
    #v(1.5mm)
  ]
]

#let ordered-stack(items, size: 8.8pt) = [
  #for pair in items.enumerate() [
    #grid(columns: (5mm, 1fr), gutter: 1mm)[
      #text(size: size, weight: 750)[#str(pair.at(0) + 1).]
    ][
      #text(size: size)[#pair.at(1)]
    ]
    #v(1.5mm)
  ]
]

#let chapter-opener(number, title, hook, definition) = sheet[
  #rect(width: 100%, height: 28mm, fill: navy)[
    #place(left + horizon, dx: margin-x, dy: 0pt)[
      #box(width: page-w - margin-x * 2)[
        #grid(
          columns: (18mm, 1fr, 18mm),
          gutter: 5mm,
          align: (center, horizon),
          rect(width: 16mm, height: 16mm, fill: yellow, radius: 2mm)[
            #align(center + horizon)[#text(size: 18pt, weight: 900, fill: navy)[#number]]
          ],
          [
            #text(size: 26pt, weight: 900, fill: white)[#upper(title)]
            #linebreak()
            #text(size: 8pt, weight: 850, fill: yellow)[THINK FROM A SHARPER DIRECTION.]
          ],
          rect(width: 15mm, height: 15mm, radius: 7.5mm, stroke: 0.8pt + white)[
            #align(center + horizon)[#text(size: 12pt, weight: 900, fill: yellow)[<>]]
          ],
        )
      ]
    ]
  ]
  #box(width: 100%, inset: (x: margin-x, top: 10mm))[
    #section-title[HOOK]
    #box(width: 125mm)[#hook]
    #v(11mm)
    #rect(width: 100%, radius: 1.8mm, stroke: 0.45pt + border, fill: panel, inset: 6mm)[
      #grid(
        columns: (20mm, 1fr),
        gutter: 5mm,
        icon-bubble("?", fill: blue-soft, color: navy, size: 15mm),
        [
          #text(size: 11pt, weight: 850)[WHAT IS IT?]
          #v(3mm)
          #definition
        ]
      )
    ]
  ]
]

#let callout-page(number, title, intro, quote, insight) = sheet[
  #box(width: 100%, inset: (x: margin-x, top: 9mm))[
    #top-rule(number, title)
    #v(13mm)
    #align(center)[#box(width: 104mm)[#intro]]
    #v(18mm)
    #align(center)[
      #rect(width: 132mm, radius: 1.8mm, stroke: 0.55pt + yellow, fill: yellow-soft, inset: 8mm)[
        #text(size: 11pt, weight: 750)[#quote]
      ]
    ]
    #v(18mm)
    #align(center)[
      #rect(width: 132mm, radius: 1.8mm, stroke: 0.55pt + yellow, fill: yellow-soft, inset: 8mm)[
        #grid(columns: (20mm, 1fr), gutter: 7mm, align: (center, horizon),
          icon-bubble("@", fill: panel, color: navy, size: 17mm),
          text(size: 11pt, weight: 750)[#insight],
        )
      ]
    ]
  ]
]

#let example-card(title, label, tint, body) = rect(
  width: 100%,
  radius: 1.8mm,
  stroke: 0.45pt + border,
  fill: panel,
  inset: 5mm,
)[
  #grid(
    columns: (20mm, 1fr),
    gutter: 5mm,
    icon-bubble(label, fill: tint, color: navy, size: 16mm),
    [
      #text(size: 8.8pt, weight: 900, fill: navy)[#upper(title)]
      #v(2mm)
      #text(size: 8.3pt)[#body]
    ],
  )
]

#let examples-page(examples) = sheet[
  #box(width: 100%, inset: (x: margin-x, top: margin-y))[
    #section-title[SIMPLE EXAMPLES]
    #examples
  ]
]

#let drill-page(number, title, lead, prompt, examples, rows, note: none) = sheet[
  #box(width: 100%, inset: (x: margin-x, top: margin-y))[
    #section-title[PRACTICE DRILL]
    #v(4mm)
    #grid(columns: (14mm, 1fr), gutter: 8mm, align: (center, horizon),
      icon-bubble(number, fill: navy, color: white, size: 12mm),
      text(size: 15pt, weight: 900)[#upper(title)],
    )
    #v(7mm)
    #align(center)[#box(width: 104mm)[#text(size: 9.3pt)[#lead]]]
    #v(7mm)
    #align(center)[#examples]
    #v(9mm)
    #rect(width: 100%, radius: 1.8mm, stroke: 0.55pt + yellow, fill: yellow-soft, inset: 4.2mm)[
      #grid(columns: (14mm, 1fr), gutter: 4mm, align: (center, horizon),
        icon-bubble("?", fill: yellow, color: navy, size: 11mm),
        text(size: 10.2pt, weight: 850)[#prompt],
      )
    ]
    #v(8mm)
    #rows
    #if note != none [
      #v(7mm)
      #text(size: 8.8pt, weight: 650, fill: muted)[#note]
    ]
  ]
]

#let examples-strip(left, right) = rect(width: 132mm, radius: 1.8mm, stroke: 0.45pt + border, fill: panel, inset: 5mm)[
  #text(size: 8.6pt, weight: 900, fill: rgb("#1752a6"))[EXAMPLES]
  #v(2mm)
  #grid(columns: (1fr, 1fr), gutter: 8mm)[
    #text(size: 8.8pt)[#left]
  ][
    #text(size: 8.8pt)[#right]
  ]
]

#let write-row(label, body) = [
  #grid(columns: (14mm, 1fr), gutter: 5mm, align: (center, horizon),
    rect(width: 12mm, height: 12mm, radius: 1.5mm, stroke: 0.45pt + border, fill: panel)[
      #align(center + horizon)[#text(size: 8pt, weight: 900, fill: navy)[#label]]
    ],
    [
      #text(size: 9.3pt)[#body]
      #v(3mm)
      #line(length: 100%, stroke: 0.55pt + rgb("#aab6c7"))
    ],
  )
  #v(5mm)
]

#let reflection-page(prompts, closing) = sheet[
  #box(width: 100%, inset: (x: margin-x, top: margin-y))[
    #section-title[NOTES & REFLECTION]
    #v(10mm)
    #for prompt in prompts [
      #text(size: 9pt)[#prompt]
      #v(8mm)
      #line(length: 100%, stroke: 0.55pt + rgb("#8796ac"))
      #v(7mm)
      #line(length: 100%, stroke: 0.55pt + rgb("#8796ac"))
      #v(7mm)
      #line(length: 100%, stroke: 0.55pt + rgb("#8796ac"))
      #v(11mm)
    ]
    #v(3mm)
    #rect(width: 100%, radius: 1.8mm, stroke: 0.55pt + yellow, fill: yellow-soft, inset: 6mm)[
      #grid(columns: (18mm, 1fr), gutter: 7mm, align: (center, horizon),
        icon-bubble("*", fill: yellow-soft, color: yellow, size: 14mm),
        text(size: 10pt, weight: 800)[#closing],
      )
    ]
  ]
]
