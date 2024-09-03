= Gradient Descent

Arrivati a questo punto è necessario sviscerare i passi generali che compongono il model-based machine learning. I passi per l'utili

1. Scegliere un modello: la prima fase è selezionare un modello appropriato per la task.
2. Scegliere un criterio da ottimizzare: la *Object Function* è l'espressione che vogliamo minimizzare o massimizzare durante l'addestramento del modello.

  Se per esempio volessimo rendere un quadrato il più grande possibile, l'$"Area"$ sarà l'objective function da massimizzare:

  #let pat = pattern(size: (10pt, 10pt))[
  #place(line(start: (0%, 0%), end: (100%, 100%)))
  #place(line(start: (0%, 100%), end: (100%, 0%)))
]

  #grid(columns: (1fr,1fr), rows: 1, align: center+horizon,
  stack(
    spacing: 5pt,
    dir: ttb, 

    move([$b$],dx: 5pt),

    stack(
    spacing: 5pt,
    dir: ltr,

    move(
      rotate(90deg)[$a$],
      dy: 5pt,
    ),

    box(fill: pat, width: 50pt, height: 50pt, stroke: 2pt, )
  )),

  [$"Area" = a dot b$]
)

  Gli elementi all'interno di una *Object Function* possono essere sommati, moltiplicati, divisi o anche combinati. Generalmente i problemi di ottimizzazione sono scritti come $limits("minimize")_x  f(x)$ dove $f(x)$ è la funzione obiettivo. Altri esempi di funzioni obiettivo potrebbero essere: minimizzare il costo, massimizzare la velocità, minimizzare il peso, massimizzare il profitto, minimizzare lo spreco ecc...

  Le *decision varibles* sono i parametri in input che verraanno ottimizzati per minimizzare o massimizzare la funzione obiettivo. Nell'esempio del quadrato, le decision varibles sono la lunghezza dei lati del quadrato. Questi parametri sono anche chiamati *design variables* o *manipulated variables*. Intuitivamente, più decision varibles ci sono, più complessa diventa la funzione obiettivo: $limits("minimize")_x  f(x_1,x_2,x_3,x_4,x_5...)$.

3. Sviluppare un algoritmo di apprendimento: è necessario utilizzare questo algoritmo per definire i parametri che massimizzano o minimizzano la funzione obiettivo. L'algoritmo può differire a seconda del tipo di dati e del modello utilizzato. Per esempio, con una task di classificazione i la distribuzione dei dati non è continua ma discreta.

Il *Gradient Descent* è uno degli algoritmi di ottimizzazione più utilizzato per trovare il *minimo locale* nella *loss function* di un modello. L'algoritmo funziona calcolando il gradiente della loss function rispetto ai parametri del modello e muovendosi nella direzione opposta al gradiente. Questo processo viene ripetuto fino a quando non si raggiunge un minimo locale o un limite massimo di iterazioni.

#quote()[Le *derivate* indicano l'inclinazione di una funzione in un punto e per un parametro. Il *gradiente* è un vettore di derivate, che contiene le derivate di una funzione rispetto a tutti i parametri del modello.]

$ w_j = w_j - eta frac(d,"dw"_i) "loss"(w) $

Dove $eta$ rappresenta il *learning rate*,

Proprio per l'utilizzo del gradiente, la *loss function* dovrebbe essere una funzione *convessa differenziabile ovunque*, avere un *minimmo globale* e nessun altro *minimo locale*. Non esistendo una funzione di questo tipo, si utilizzano funzioni dette *surrogate loss function*.

== Surrogate Loss Function

Ci sono decine di surrogate loss function, già implementate, ognuna con le proprie caratteristiche. Di seguito sono elencate e descritte alcune delle più comuni.

#align(center,
  grid(
    
    columns: (1fr, 1fr, 3fr),
    align: (center+horizon),
    rows: (5em, 3em, 3em, 220pt),

    grid.cell(
      colspan: 3,
      [
        *Nota*: Le funzioni di loss sono definite in funzione della differenza tra la label $y$ e la predizione $y'$ (anche scritto come $f(x)$).
      ]
    ),

    [*Nome*],[*Formula*],[*Plot*],


    [0/1 Loss],[ $l(y, y') = 1[y y'<=0]$],
    
    grid.cell(
      colspan: 1,
      rowspan: 2,
      image("../code/surrogate-loss-functions/zero_one_loss.png", width: 100%),
    ),
    
    grid.cell(
      colspan: 2,
      rowspan: 1,
      par(justify: true)[
        *Descrizione:* è la funzione di loss ideale per la classificazione, poiché misura semplicemente se la predizione $y'$ ha lo stesso segno del valore reale $y$. Restituisce $1$ se la predizione è errata (cioè se $y dot y' ≤ 0$) e $0$ se la predizione è corretta (cioè se $y dot y'>0$).

        La funzione di loss 0/1 non è differenziabile.
        ],
    ),    
  )
)

#align(center,
  grid(    
    columns: (1fr, 1fr, 3fr),
    align: (center+horizon),
    rows: (3em, 220pt),

    [Hinge Loss],[ $l(y, y') = max(0, 1-y y')$],
    
    grid.cell(
      colspan: 1,
      rowspan: 2,
      image("../code/surrogate-loss-functions/hinge_loss.png", width: 100%),
    ),

    grid.cell(
      colspan: 2,
      rowspan: 1,
      par(justify: true)[
        *Descrizione:* #lorem(50)],
    ),
  )
)

#align(center,
  grid(    
    columns: (1fr, 1fr, 3fr),
    align: (center+horizon),
    rows: (3em, 220pt),


    [Squared Loss],[ $l(y, y') = (y-y')^2$],
    
    grid.cell(
      colspan: 1,
      rowspan: 2,
      image("../code/surrogate-loss-functions/squared_loss.png", width: 100%),
    ),

    grid.cell(
      colspan: 2,
      rowspan: 1,
      par(justify: true)[
        *Descrizione:* #lorem(50)],
    ),
  )
)

#align(center,
  grid(
    columns: (1fr, 1fr, 3fr),
    align: (center+horizon),
    rows: (3em, 220pt),
    
    [Exponential Loss],[ $l(y, y') = exp(-y y')$],
    
    grid.cell(
      colspan: 1,
      rowspan: 2,
      image("../code/surrogate-loss-functions/exponential_loss.png", width: 100%),
    ),
  
    grid.cell(
      colspan: 2,
      rowspan: 1,
      par(justify: true)[
        *Descrizione:* #lorem(50)],
    ),
  )
)

#align(center,
  grid(
    columns: (1fr, 1fr, 3fr),
    align: (center+horizon),
    rows: (3em, 220pt),

    [Log Loss],[ $l(y, y') = log(1+exp(-y y'))$],
    
    grid.cell(
      colspan: 1,
      rowspan: 2,
      image("../code/surrogate-loss-functions/log_loss.png", width: 100%),
    ),

    grid.cell(
      colspan: 2,
      rowspan: 1,
      par(justify: true)[
        *Descrizione:* #lorem(50)],
    ),
  )
)

#align(center,
  image("../code/surrogate-loss-functions/all_losses_comparison.png", width: 100%)
)






// TODO: Terminare


== Regolarizzazione nel Gradient Descent

La regolarizzazione è un criterio aggiuntivo alla loss function, che ci assicura che il modello non overfitti. È un _bias_ che forza il processo di apprendimento a preferire certi tipi di pesi rispetto ad altri. Nel caso del Gradient Descent, la regolarizzazione è implementata aggiungendo un termine alla loss function:

$ "argmin"_(w,b) sum_(i=1)^n "loss"(y y') + lambda "regularizer"(w,b) $

L'aggiornamento del peso $w_j$ diventa:

$ w_j = w_j - eta frac(d,"dw"_j) ("loss"(w) + lambda "regularizer"(w,b)) $

