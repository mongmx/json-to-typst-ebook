#let navy = rgb("#18202f")
#let navy-soft = rgb("#263247")
#let ink = rgb("#17202c")
#let muted = rgb("#667085")
#let paper = rgb("#f7f8fb")
#let panel = rgb("#ffffff")
#let border = rgb("#d8dee8")
#let yellow = rgb("#f5b942")
#let yellow-soft = rgb("#fff3d6")
#let blue-soft = rgb("#e8f3ff")
#let green-soft = rgb("#e5f7ef")
#let red-soft = rgb("#ffe8e5")
#let purple-soft = rgb("#efeaff")
#let teal = rgb("#20a7a0")
#let teal-soft = rgb("#def7f5")
#let coral = rgb("#ff6f61")
#let lavender = rgb("#7c69ef")

#let page-w = 210mm
#let page-h = 297mm
#let margin-x = 16mm
#let margin-y = 14mm

#let setup(body) = {
  set page(width: page-w, height: page-h, margin: 0pt, fill: paper)
  set text(font: "Arial", fill: ink, size: 10.2pt)
  set par(leading: 0.64em, justify: false)
  body
}
