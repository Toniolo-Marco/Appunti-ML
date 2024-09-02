= Linear Classifier

Il classificatore lineare, come il nome suggerisce, è un modello di classificazione che si basa su una funzione lineare per separare le classi. Questo richiede che i dati siano linearmente separabili, ovvero che esista almeno un iperpiano che separi le classi; ciò significa che questo modello è *parametrico* (_high-bias model_). Ovviamente un solo iperpiano potrà separare 2 classi; per questo motivo, in generale, un classificatore lineare è un classificatore binario.

#align( center, image("../img/linearly-vs-not-linearly-separable-datasets.png", width: 90%))

== Online Learning

Durante la fase di training, il classificatore lineare aggiorna i pesi in modo incrementale, utilizzando un solo esempio alla volta. Questo approccio è noto come *online learning*. L'aggiornamento dei pesi è basato sull'errore commesso dal modello rispetto all'etichetta corretta.

L'online learning rappresente un'intera branca del Machine Learning, in cui i modelli vengono addestrati su un flusso continuo di dati. Questo approccio è particolarmente utile quando il dataset è troppo grande per essere caricato in memoria, o quando i dati arrivano in tempo reale.

L'opposto dell'online learning è il *batch learning*, in cui il modello viene addestrato su tutto il dataset in una sola volta.

== Training Phase

Durante la fase di training, il classificatore lineare per prima cosa inizializza i pesi e il bias a valori casuali (o a 0). Successivamente, per ogni esempio del training set, calcola la predizione del modello e, se errata (non corrispondente alla stessa classe della label), aggiorna i pesi in base all'errore commesso. Lo @perceptron-algorithm[pseudocodice dell'algoritmo] di training per un classificatore lineare viene riportato successivamente in questo capitolo.


== Inference Phase

La fase di inferenza di un classificatore lineare è molto semplice: dato un input $x$, il modello calcola il prodotto scalare tra il vettore dei pesi $w$ e il vettore delle features $x$; a questo valore viene sommato il termine di bias $b$.

$ f(x, y) := cases(
  b + sum^n_(i = 1) w_i f_i > 0 "if" "positive",
  b + sum^n_(i=1) w_i f_i < 0 "if" "negative",
)  $

== Perceptron

Il Perceptron è un tipo di classificatore lineare. Alla formula vista in precedenza, viene aggiunta una funzione di attivazione $h$. La funzione di attivazione canonica è la funzione di #link("https://en.wikipedia.org/wiki/Heaviside_step_function")[Heaviside] (o funzione di step), che restituisce 1 se il valore è maggiore di 0, altrimenti 0:

$ h(x) = cases(
  1 "if" x >= 0,
  0 "if" x < 0,
) $

Ne segue che la funzione del Perceptron è:

$ f(x) = h(bold(w) \cdot bold(x) + b) $

=== Perceptron Algorithm <perceptron-algorithm>

L'algoritmo del Perceptron è molto semplice: inizializziamo i pesi e il bias a 0, e iteriamo su tutti gli esempi del training set. Per ogni esempio, calcoliamo la predizione del modello e aggiorniamo i pesi in base all'errore commesso. Di seguito l'algoritmo in pseudocodice; dove `y` è l'etichetta corretta (con valore $1$ o $-1$), `f(x)` è la predizione del modello nello step corrente, e `x_i` è l'elemento i-esimo del vettore delle features.

#block(breakable: false)[
```
repeat until convergence {                    // or for a fixed number of iterations
  for each example in training set {
    if y != f(x) {                            // if the prediction is wrong
      for each weight w_i {
        w_i = w_i + y * x_i
        b = b + y
      }
    }
  }
}
```
]

È importante capire le limitazioni del Perceptron: questo algoritmo funziona solo se i dati sono linearmente separabili; altrimenti l'algoritmo non converge. Inoltre, se i dati non sono linearmente separabili, il Perceptron non restituisce un modello ottimale. Questa limitazione è stata la causa dell'AI 

== Multiclass Classification

Il Perceptron è un classificatore binario, ovvero può classificare un datapoint in una tra due classi. La Multiclass Classification è un'estensione della Binary Classification, in cui il modello deve classificare un datapoint in una tra più classi. Esistono diversi approcci per estendere un classificatore binario a uno multiclasse, tra cui:

=== OVA

L'approccio *One-Versus-All* (OVA) consiste nel creare un classificatore binario per ogni classe. Ad esempio, se abbiamo 3 classi, creiamo 3 classificatori binari; ogni classidicatore sarà allenato per predire se un elemento appartiene o meno a quella classe. Durante la fase di inferenza, il modello restituisce la classe con il classificatore binario che ha restituito il valore più alto. Infatti, nella formula: $b + sum^n_(i = 1) w_i f_i$ possiamo vedere la componente della sommatoria come _confidenza_ del modello per la classe di quel classificatore. Questa componente rappresenta la distanza del punto analizzato dall'iperpiano che separa le due classi.

#block(breakable: false)[

=== Pseudocodice Train OVA 
```c
// D_multiclass is the multiclass dataset 
// K is the number of classes
// BinaryTrain is the binary classifier training function

function OneVsAll(D_multiclass, K, BinaryTrain){    
  classifiers = []                            // initialize an empty list of K classifiers
  for i = 1 to K {                            // K is the number of classes
    D_bin = relabel(D_multiclass)             // so class i is positive and ¬i is negative
    classifiers[i] = BinaryTrain(D_bin)       // train a binary classifier on the binary dataset
  }
  return classifiers
}
```
]

#block(breakable: false)[
=== Pseudocodice Test OVA

```c
// classifiers is the list of K classifiers
// x is the input to classify
// K is the number of classes

function OneVsAllPredict(classifiers, x, K){
  score[K] = 0                                    // initialize K-many scores to zero
  for i = 1 to K{                                 // for each class
    y = classifiers[i].predict(x)                 // predict x using i-th classifier
    score[i] = score[i] + y                       // add the prediction to the score
  }
  return argmax(score)                            // return the class with the highest score
}
```
]

=== AVA

L'approccio *All-Versus-All* (AVA) consiste nel creare un classificatore binario per ogni coppia di classi. Questo approccio è anche noto come *all pairs*. Consiste nell'allenare $K(K-1)/2$ classificatori binari, dove $K$ indica il numero di classi. Ogni classificatore binario discrimina tra due classi diverse; diversamente dall'approccio OVA (dove ogni classificatore binario discrimina tra una classe e tutte le altre). Per questo motivo, se le etichette sono equamente distribuite, l'approccio AVA sarà più veloce in fase di training: il numero di classificatori binari da allenare è maggiore, ma il numero di esempi per classificatore è minore.

Per quanto riguarda la fase di inferenza, con questo approccio è possibile sia restituire la classe con il maggior numero di voti, sia restituire la classe che ha ottenuto score più alto (maggior _confidenza_). Nello pseudocodice che segue, per quanto riguarda la parte di _test_, viene restituita la classe con lo score più alto. Se compariamo questo approccio con l'approccio OVA nella fase di test, l'approccio AVA è generalmente più lento, proprio per il numero maggiore di classificatori.

A causa della sua struttura, l'approccio AVA è meno robusto rispetto all'approccio OVA, nel caso in cui una classe sia sotto-rappresentata all'interno del dataset.


#block(breakable: false)[
=== Pseudocodice Train AVA

```c
// D_multiclass is the multiclass dataset
// K is the number of classes
// BinaryTrain is the binary classifier training function
// i and j are the classes to discriminate, combined, they rapresent a key

function AllVsAll(D_multiclass, K, BinaryTrain){
  classifiers = []                              // initialize a list of K(k-1)/2 classifiers
  for i = 1 to K-1 {
    D_pos = D_multiclass.filter(class == i)     // all instances of class i                    
    for j = i+1 to K {
      D_neg = D_multiclass.filter(class == j)   // all instances of class j
      D_bin = D_pos + D_neg                     // concatenate the two datasets
      classifiers[i,j] = BinaryTrain(D_bin)     // train a binary classifier
    }
  }
  return classifiers
}
      
```
]

#block(breakable: false)[
=== Pseudocodice Test AVA

```c
// classifiers is the list of K classifiers
// x is the input to classify
// K is the number of classes

function AllVsAllPredict(classifiers, x, K){
  score[K] = 0                                    // initialize K-many scores to zero
  for i = 1 to K{                                 // for each class
    for j = i+1 to K{                             // for each other class
      y = classifiers[i,j].predict(x)             // predict x using i-th classifier
      score[i] = score[i] + y                     // add the prediction to the score
      score[j] = score[j] - y                     // subtract the prediction from the score
    }
  }
  return argmax(score)                            // return the class with the highest score
}
```
]

== Micro vs Macro Average

Nel caso di classificazione multiclasse, è possibile utilizare due diversi sistemi per valutare le performance del modello: *Micro Average* e *Macro Average*.

La *Micro Average*: non è altro che l'utilizzo della metrica prescelta su tutte le classi; senza alcuna distinzione tra loro. Se per esempio utilizziamo l'accuratezza come metrica, possiamo calcolarla come segue:

$ A_c = frac(P_c,P_c+P_e) $

Dove $P_c$ rappresenta le predizioni corrette e $P_e$ rappresenta le predizioni errate.

La *Macro Average*: calcola l'accuratezza per ogni classe e ne fa la media. Questo significa che si calcola l'accuratezza per ogni classe e si fa la media di queste accuratezze.
Questa metrica è utile quando si vuole dare lo stesso peso a tutte le classi; ovvero, anche se una classe è sottorappresentata, essa avrà lo stesso peso delle altre classi.

Per utilizare la macro average, si calcola (con la metrica prescelta) lo score per ogni classe, che nomineremo $"Ev"_i$ (dove $i$ rappresenta la classe). Successivamente, si calcola la media di tutti gli score; un esempio con l'accuratezza:

$ A_m = frac(sum_(i=0)^n "Ev"_i,n) $

Dove $A_m$ rappresenta l'accuratezza media e $n$ rappresenta il numero di classi.




#let triangle = polygon.regular(
  fill: green,
  size: 3em,
  vertices: 3,
)

#let square = rect(
  fill: blue,
  width: 2.5em,
  height: 2.5em,
)

#let circle = circle(
  fill: red,
  radius: 1.5em,
)

#let rectangle = rect(
  fill: yellow,
  width: 3em,
  height: 1.5em,
)


#block(breakable: false)[
  
  Un esempio per confrontare le due metriche: (il testo in grassetto rappresenta l'ultimo valore calcolato per quella classe),
  #align(center,
  grid(
    
    columns: (1fr, 1fr, 1fr, 1fr, 1fr),
    rows: (3em),
    align: (center+horizon),
    
    [],[Label],[Prediction],[Micro Average],[Macro Average],
    grid.hline(start: 0),

    circle, [circle], [square], [0], [cirle = 0/1],

    square, [square], [square], [1],[*square = 1/1*],

    circle, [circle], [circle], [1],[*cirle = 1/2*],

    triangle, [triangle], [rectangle], [0], [triangle = 0/1],

    triangle, [triangle], [triangle], [1], [*triangle = 1/2*],

    rectangle, [rectangle], [rectangle], [1], [*rectangle = 1/1*],
    
    grid.hline(start: 0),
    [Score],[],[],[$frac(4,6)$],[$(frac(1,2)+1+frac(1,2)+1)/4 = 3/4$]
  ))
  
]

== Confusion Matrix

La *confusion matrix* è una matrice che, a colpo d'occhio riesce a mostrare le performance di un classificatore. La confusion matrix è così costruita:

- Le righe rappresentano le classi reali (Labels)
- Le colonne rappresentano le classi predette (Predictions)

Spesso si utilizzano valori percentuali, ed in generale è utile per capire su quale classe il nostro modello performa peggio e di conseguenza concentrarci su quella (magari aggiungendo datapoints appartenenti a quella classe nel dataset). Riprendendo l'esempio precedente, possiamo costruire la confusion matrix. Sulla diagonale principale, troviamo i valori corretti, mentre gli altri valori rappresentano gli errori commessi dal modello.

#let diagonal = line(end: (100%,100%), stroke:0.1em)
#let first_cell = box(width: 5em, height: 5em, stroke: none)[
    #show line: place.with(top + left)
    #diagonal
    #rotate(45deg)[#place(center+horizon, dx:0.5em, dy: 1em)[Label]]
    
    #rotate(45deg)[#place(center+horizon, dx:-0.25em, dy: -1.5em)[Prediction]]
  ]
  
#align(center+horizon,
block(breakable: false)[
    #table(
    fill: (x,y) => rgb(
      if (x == y) {"7F8396"}
      else {"EFF0F3"},
    ),
    columns: (5em, 5em,5em,5em,5em),
    rows: (5em),
    align: (center+horizon),
    first_cell
    , [Circle], [Square], [Triangle], [Rectangle],
    [circle],             [1],      [1],      [0],        [0], 
    [square],             [0],      [1],      [0],        [0],
    [triangle],           [0],      [0],      [1],        [1],
    [rectangle],          [0],      [0],      [0],        [1],
  )
]
)
