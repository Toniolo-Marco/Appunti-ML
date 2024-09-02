= Gradient Descent

Arrivati a questo punto è necessario sviscerare i passi generali che compongono il model-based machine learning.

1. Scegliere un modello: la prima fase è selezionare un modello appropriato per la task.
2. Scegliere un criterio da ottimizzare: la *Object Function* è l'espressione che vogliamo minimizzare o massimizzare durante l'addestramento del modello.
3. Sviluppare un algoritmo di apprendimento: è necessario utilizzare questo algoritmo per definire i parametri che massimizzano o minimizzano la funzione obiettivo.



Il *Gradient Descent* è un algoritmo di ottimizzazione utilizzato per trovare il *minimo locale* nella *loss function* di un modello. L'algoritmo funziona calcolando il gradiente della loss function rispetto ai parametri del modello e muovendosi nella direzione opposta al gradiente. Questo processo viene ripetuto fino a quando non si raggiunge un minimo locale.

#quote()[Il *gradiente* è ]

$ w_j = w_j - eta frac(d,"dw"_i) "loss"(w) $

Dove $eta$ rappresenta il *learning rate*,

Per questioni di ottimizzazione una *loss function* dovrebbe essere una funzione *convessa differenziabile ovunque*, avere un *minimmo globale* e nessun altro *minimo locale*. Non esistendo una funzione di questo tipo, si utilizzano funzioni dette *surrogate loss function*.

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


