#import "config.typ": page-width, page-height

#let ink = rgb("#111827")
#let muted = rgb("#667085")
#let paper = rgb("#fbfaf7")
#let panel = rgb("#ffffff")
#let rule = rgb("#d7dde6")
#let coal = rgb("#172033")
#let blue = rgb("#2f6fed")
#let blue-soft = rgb("#e9f1ff")
#let gold = rgb("#d49a2a")
#let gold-soft = rgb("#fff3d8")
#let green = rgb("#257a55")
#let green-soft = rgb("#e7f5ee")
#let red = rgb("#b94a48")
#let red-soft = rgb("#fff0ef")

#let page-w = page-width
#let page-h = page-height
#let margin-x = 0.72in
#let margin-y = 0.48in

#let setup(body) = {
  set page(width: page-w, height: page-h, margin: 0pt, fill: paper)
  set text(font: "Arial", fill: ink, size: 18pt)
  set par(leading: 0.72em, justify: false)
  body
}
