#set heading(numbering: "1.")
#set page(numbering: "1")
#set page(margin: (
  top: 1.5cm,
  bottom: 1.5cm,
  x: 1.5cm,
))

#set document(
  title: [Appunti del corso "Introduction to Machine Learning"],
  author: ("Toniolo Marco"),
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

#include "linear-classifier.typ"

#include "KNN.typ"

#include "gradient-descent.typ"

#include "support-vector-machines.typ"

#include "decision-tree.typ"