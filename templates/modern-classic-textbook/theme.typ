#let ink = rgb("#202124")
#let muted = rgb("#6b7280")
#let paper = rgb("#ffffff")
#let panel = rgb("#ffffff")
#let rule = rgb("#222222")
#let border = rgb("#e5e7eb")
#let wash = rgb("#f7f8fa")
#let blue-soft = rgb("#eef4ff")
#let green-soft = rgb("#eff8f3")
#let red-soft = rgb("#fff1f2")
#let purple-soft = rgb("#f5f3ff")
#let accent = rgb("#4b5563")

#let page-w = 210mm
#let page-h = 297mm
#let margin-x = 22mm
#let margin-y = 18mm

#let setup(body) = {
  set page(width: page-w, height: page-h, margin: 0pt, fill: paper)
  set text(font: "Avenir", fill: ink, size: 10.4pt)
  set par(leading: 0.68em, justify: false)
  body
}
