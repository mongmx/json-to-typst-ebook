#let ink = rgb("#1d1d1b")
#let muted = rgb("#66635d")
#let paper = rgb("#ffffff")
#let panel = rgb("#ffffff")
#let rule = rgb("#2a2926")
#let border = rgb("#d8d1c4")
#let wash = rgb("#f3eee4")
#let blue-soft = rgb("#edf2f7")
#let green-soft = rgb("#edf5ee")
#let red-soft = rgb("#f8eeee")
#let purple-soft = rgb("#f2eef7")

#let page-w = 210mm
#let page-h = 297mm
#let margin-x = 21mm
#let margin-y = 18mm

#let setup(body) = {
  set page(width: page-w, height: page-h, margin: 0pt, fill: paper)
  set text(font: "New Computer Modern", fill: ink, size: 10.8pt)
  set par(leading: 0.66em, justify: true)
  body
}
