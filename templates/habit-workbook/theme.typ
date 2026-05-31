#let navy = rgb("#061f3a")
#let navy-soft = rgb("#092b4c")
#let ink = rgb("#111c2f")
#let muted = rgb("#5f6d82")
#let paper = rgb("#fffdf8")
#let panel = rgb("#ffffff")
#let border = rgb("#d8e0ea")
#let yellow = rgb("#ffc928")
#let yellow-soft = rgb("#fff4cf")
#let blue-soft = rgb("#eaf4ff")
#let green-soft = rgb("#eaf7e7")
#let red-soft = rgb("#fff0f1")
#let purple-soft = rgb("#f2ecff")

#let page-w = 210mm
#let page-h = 297mm
#let margin-x = 17mm
#let margin-y = 15mm

#let setup(body) = {
  set page(width: page-w, height: page-h, margin: 0pt, fill: paper)
  set text(font: "Arial", fill: ink, size: 10.5pt)
  set par(leading: 0.62em, justify: false)
  body
}
