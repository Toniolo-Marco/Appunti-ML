#set heading(numbering: "1.")
#set page(numbering: "1")
#set page(margin: (
  top: 1.5cm,
  bottom: 1.5cm,
  x: 1.5cm,
))

#set document(
  title: [Appunti del corso "Introduction to Machine Learning"],
  author: ("Toniolo Marco","Federico Frigerio"),
  keywords: ("Introduction", "Machine Learning", "ML", "Appunti", "Riassunto"),
  date: (auto)
)

#set quote(block: true)
#show quote: set align(center)


#show link: underline

#include "introduzione.typ"

#include "regressione-lineare.typ"

#include "polynomial-regression.typ"

#include "valutazione-ed-errori.typ"

#include "KNN.typ"