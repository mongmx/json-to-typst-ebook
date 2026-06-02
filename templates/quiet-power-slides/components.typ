#import "theme.typ": *

#let slide-num = state("slide-num", 1)

#let next-slide() = {
  slide-num.update(n => n + 1)
  pagebreak()
}

#let current-slide() = context slide-num.get()

#let footer(label: "json-to-typst-ebook") = [
  #place(bottom + left, dx: margin-x, dy: -0.28in)[
    #text(size: 8pt, weight: 650, fill: muted)[#label]
  ]
  #place(bottom + right, dx: -margin-x, dy: -0.28in)[
    #text(size: 8pt, weight: 700, fill: muted)[#current-slide()]
  ]
]

#let slide-shell(title: none, footer-label: "json-to-typst-ebook", body) = {
  box(width: 100%, height: 100%)[
    #if title != none [
      #place(top + left, dx: margin-x, dy: margin-y)[
        #text(size: 11pt, weight: 800, fill: gold)[#upper(title)]
      ]
    ]
    #body
    #footer(label: footer-label)
  ]
}

#let bullet-list(items, size: 18pt) = [
  #for item in items [
    #grid(columns: (0.18in, 1fr), gutter: 0.11in, align: (left, top))[
      #rect(width: 0.07in, height: 0.07in, radius: 0.035in, fill: blue)
    ][
      #text(size: size, fill: ink)[#item]
    ]
    #v(0.13in)
  ]
]

#let step-node(label, index, fill: panel) = rect(
  width: 1.42in,
  height: 0.76in,
  radius: 5pt,
  fill: fill,
  stroke: 0.65pt + rule,
  inset: 0.12in,
)[
  #text(size: 8.5pt, weight: 800, fill: gold)[#str(index + 1).]
  #v(0.04in)
  #text(size: 12.5pt, weight: 760, fill: ink)[#label]
]

#let arrow() = text(size: 17pt, weight: 800, fill: muted)[->]

#let comparison-card(label, items, color: blue, fill: panel) = rect(
  width: 100%,
  height: 4.7in,
  fill: fill,
  stroke: 0.7pt + rule,
  radius: 6pt,
  inset: 0.32in,
)[
  #text(size: 17pt, weight: 850, fill: color)[#label]
  #v(0.24in)
  #bullet-list(items, size: 18pt)
]

#let definition-point(body) = [
  #rect(width: 0.2in, height: 0.05in, fill: gold, radius: 2pt)
  #v(0.13in)
  #text(size: 16pt, weight: 650)[#body]
]

#let flow-row(steps) = {
  let count = steps.len()
  grid(
    columns: (1fr,) * (count * 2 - 1),
    gutter: 0.08in,
    align: (center, horizon),
    ..steps.enumerate().map(pair => (
      step-node(pair.at(1), pair.at(0), fill: if calc.rem(pair.at(0), 2) == 0 { panel } else { blue-soft }),
      if pair.at(0) < count - 1 { arrow() } else { none },
    )).flatten().filter(item => item != none)
  )
}

#let timeline-card(stage, description, number) = rect(
  width: 100%,
  height: 4.35in,
  fill: panel,
  stroke: 0.65pt + rule,
  radius: 6pt,
  inset: 0.3in,
)[
  #text(size: 12pt, weight: 850, fill: gold)[#number]
  #v(0.55in)
  #text(size: 27pt, weight: 850, fill: ink)[#stage]
  #v(0.18in)
  #text(size: 17pt, fill: muted)[#description]
]

#let mapping-card(concept, role) = rect(
  width: 100%,
  height: 2.35in,
  fill: gold-soft,
  stroke: 0.65pt + gold,
  radius: 6pt,
  inset: 0.28in,
)[
  #text(size: 25pt, weight: 850, fill: ink)[#concept]
  #v(0.16in)
  #text(size: 15pt, weight: 760, fill: gold)[#role]
]

#let use-card(label, index) = rect(
  width: 100%,
  height: 1.12in,
  fill: if calc.rem(index, 2) == 0 { panel } else { green-soft },
  stroke: 0.55pt + rule,
  radius: 6pt,
  inset: 0.18in,
)[
  #text(size: 15pt, weight: 760, fill: ink)[#label]
]

#let pipeline-card(label, index) = rect(
  width: 100%,
  height: 1.45in,
  fill: if index < 4 { blue-soft } else { panel },
  stroke: 0.55pt + rule,
  radius: 6pt,
  inset: 0.18in,
)[
  #text(size: 9pt, weight: 850, fill: gold)[#str(index + 1).]
  #v(0.1in)
  #text(size: 15pt, weight: 760)[#label]
]

#let slide-hero(kicker, title, subtitle, footer-text) = slide-shell(footer-label: footer-text)[
  #rect(width: 100%, height: 100%, fill: coal)[
    #place(top + left, dx: margin-x, dy: 0.55in)[
      #rect(fill: gold, radius: 3pt, inset: (x: 0.14in, y: 0.05in))[
        #text(size: 10pt, weight: 850, fill: coal)[#upper(kicker)]
      ]
    ]
    #place(left + horizon, dx: margin-x, dy: -0.15in)[
      #box(width: 8.9in)[
        #text(size: 62pt, weight: 900, fill: white)[#title]
        #v(0.18in)
        #text(size: 25pt, weight: 600, fill: rgb("#d6dbe6"))[#subtitle]
      ]
    ]
    #place(bottom + left, dx: margin-x, dy: -0.52in)[
      #text(size: 10pt, weight: 750, fill: gold)[#footer-text]
    ]
  ]
]

#let slide-poster(background-image, brand-kicker, brand-name, quote, subtitle, footer: "", overlay: 62%) = [
  #box(width: 100%, height: 100%)[
    #place(top + left)[
      #image(background-image, width: page-w, height: page-h, fit: "cover")
    ]
    #place(top + left)[
      #rect(
        width: page-w,
        height: page-h,
        fill: rgb("#000000").transparentize(overlay),
      )
    ]
    #place(bottom + left)[
      #rect(
        width: page-w,
        height: 2.75in,
        fill: rgb("#000000").transparentize(18%),
      )
    ]
    #place(top + left, dx: margin-x, dy: 0.52in)[
      #text(font: "Georgia", size: 15pt, weight: 700, fill: white)[
        #text(fill: gold, size: 10pt)[#brand-kicker]
        #linebreak()
        #brand-name
      ]
    ]
    #place(bottom + left, dx: margin-x + 0.55in, dy: -0.72in)[
      #grid(columns: (0.05in, 1fr), gutter: 0.34in, align: (left, top))[
        #rect(width: 0.05in, height: 1.72in, fill: white)
      ][
        #box(width: 9.6in)[
          #text(font: "Arial", size: 36pt, weight: 650, fill: white)[#quote]
          #v(0.15in)
          #text(font: "Arial", size: 18pt, weight: 400, fill: rgb("#f1f3f5"))[#subtitle]
        ]
      ]
    ]
    #if footer != "" [
      #place(bottom + right, dx: -margin-x, dy: -0.35in)[
        #text(size: 8pt, weight: 650, fill: rgb("#d6dbe6"))[#footer]
      ]
    ]
  ]
]

#let slide-headline-list(title, headline, items, tone: "system") = {
  let accent = if tone == "alert" { red } else { blue }
  let accent-soft = if tone == "alert" { red-soft } else { blue-soft }
  slide-shell(title: title)[
    #box(width: 100%, inset: (x: margin-x, top: 1.06in))[
      #grid(columns: (5.4in, 1fr), gutter: 0.54in, align: (left, top))[
        #text(size: 34pt, weight: 850, fill: ink)[#headline]
      ][
        #rect(width: 100%, fill: accent-soft, stroke: 0.8pt + accent, radius: 6pt, inset: 0.25in)[
          #bullet-list(items, size: 17pt)
        ]
      ]
    ]
  ]
}

#let slide-comparison(title, columns) = slide-shell(title: title)[
  #box(width: 100%, inset: (x: margin-x, top: 1.15in))[
    #grid(columns: (1fr, 1fr), gutter: 0.38in)[
      #comparison-card(columns.at(0).at(0), columns.at(0).at(1), color: muted, fill: panel)
    ][
      #comparison-card(columns.at(1).at(0), columns.at(1).at(1), color: blue, fill: blue-soft)
    ]
  ]
]

#let slide-definition(title, statement, items) = slide-shell(title: title)[
  #box(width: 100%, inset: (x: margin-x, top: 1.06in))[
    #text(size: 36pt, weight: 850, fill: ink)[#statement]
    #v(0.36in)
    #rect(width: 100%, fill: panel, stroke: 0.65pt + rule, radius: 6pt, inset: 0.27in)[
      #grid(columns: (1fr, 1fr, 1fr), gutter: 0.22in)[
        #definition-point(items.at(0))
      ][
        #definition-point(items.at(1))
      ][
        #definition-point(items.at(2))
      ]
    ]
  ]
]

#let slide-flow(title, steps, caption: "") = slide-shell(title: title)[
  #box(width: 100%, inset: (x: margin-x, top: 1.35in))[
    #flow-row(steps)
    #if caption != "" [
      #v(0.54in)
      #align(center)[
        #box(width: 7.3in)[#text(size: 17pt, fill: muted)[#caption]]
      ]
    ]
  ]
]

#let slide-timeline(title, timeline) = slide-shell(title: title)[
  #box(width: 100%, inset: (x: margin-x, top: 1.14in))[
    #grid(columns: (1fr, 1fr, 1fr), gutter: 0.26in)[
      #timeline-card(timeline.at(0).at(0), timeline.at(0).at(1), "01")
    ][
      #timeline-card(timeline.at(1).at(0), timeline.at(1).at(1), "02")
    ][
      #timeline-card(timeline.at(2).at(0), timeline.at(2).at(1), "03")
    ]
  ]
]

#let slide-mapping(title, mapping, statement) = slide-shell(title: title)[
  #box(width: 100%, inset: (x: margin-x, top: 1.02in))[
    #grid(columns: (1fr, 1fr, 1fr), gutter: 0.2in)[
      #mapping-card(mapping.at(0).at(0), mapping.at(0).at(1))
    ][
      #mapping-card(mapping.at(1).at(0), mapping.at(1).at(1))
    ][
      #mapping-card(mapping.at(2).at(0), mapping.at(2).at(1))
    ]
    #v(0.35in)
    #rect(width: 100%, fill: coal, radius: 6pt, inset: 0.26in)[
      #text(size: 21pt, weight: 700, fill: white)[#statement]
    ]
  ]
]

#let slide-grid-list(title, items) = slide-shell(title: title)[
  #box(width: 100%, inset: (x: margin-x, top: 1.05in))[
    #grid(columns: (1fr, 1fr, 1fr), gutter: 0.16in, row-gutter: 0.16in, ..items.enumerate().map(pair => use-card(pair.at(1), pair.at(0))))
  ]
]

#let slide-pipeline(title, steps) = slide-shell(title: title)[
  #box(width: 100%, inset: (x: margin-x, top: 1.0in))[
    #grid(columns: (1fr, 1fr, 1fr, 1fr), gutter: 0.14in, row-gutter: 0.18in, ..steps.enumerate().map(pair => pipeline-card(pair.at(1), pair.at(0))))
  ]
]

#let slide-statement(title, statement, footer: "") = slide-shell(title: title)[
  #box(width: 100%, inset: (x: margin-x, top: 1.22in))[
    #box(width: 10.1in)[
      #text(size: 42pt, weight: 850, fill: ink)[#statement]
    ]
    #if footer != "" [
      #v(0.48in)
      #rect(fill: gold-soft, stroke: 0.6pt + gold, radius: 6pt, inset: (x: 0.24in, y: 0.11in))[
        #text(size: 16pt, weight: 800, fill: gold)[#footer]
      ]
    ]
  ]
]

#let slide-closing(title, subtitle, cta, url) = slide-shell(footer-label: url)[
  #rect(width: 100%, height: 100%, fill: coal)[
    #place(left + horizon, dx: margin-x, dy: -0.12in)[
      #box(width: 9.4in)[
        #text(size: 48pt, weight: 900, fill: white)[#title]
        #v(0.18in)
        #text(size: 22pt, weight: 600, fill: rgb("#d6dbe6"))[#subtitle]
        #v(0.52in)
        #rect(fill: gold, radius: 4pt, inset: (x: 0.24in, y: 0.11in))[
          #text(size: 18pt, weight: 850, fill: coal)[#cta]
        ]
      ]
    ]
    #place(bottom + left, dx: margin-x, dy: -0.52in)[
      #text(size: 12pt, weight: 750, fill: gold)[#url]
    ]
  ]
]
