= KNN

#grid(
    columns: (2fr,3fr),
    [

      Il K-Nearest Neighbors (KNN) è un modello *supervised*, utilizzato per la classificazione, che si basa sulla distanza tra i punti del dataset. Al momento della predizione, il modello calcola la distanza tra il nuovo punto ed altri $k$ punti del dataset, e predice la classe del nuovo punto basandosi sulla classe più frequente tra i $k$ punti più vicini.
    ],
    image("../img/example-knn.png", width: 100%))

Il KNN ha alcuni aspetti caratteristici:
#footnote[Se la differenza tra _lazy_ e _instance-based_ non è chiara ora lo sarà nel capitolo dell'SVM.]

- È un modello *non parametrico*, cioè non necessita di assunzioni sulla distribuzione dei dati.

- È un *lazy learner*. Il termine _lazy learning_ si riferisce all'approccio dell'apprendimento in cui il modello non fa praticamente nulla durante la fase di addestramento. In altre parole, l'algoritmo rimanda il processo di apprendimento fino a quando non è necessario fare una previsione. 

- È un modello *instance-based*. L'_instance-based learning_ è un tipo di apprendimento dove il modello memorizza semplicemente i dati di addestramento e non costruisce un modello esplicito per fare previsioni. Quando si richiede una previsione, il modello confronta il nuovo esempio con gli esempi memorizzati per fare una stima.

- *K* è appunto l'hyperparametro che determina il numero di data-points "vicini" da tenere in considerazione durante la predizione. Ne segue che se $K = n$, dove $n$ è la cardinalità del mio dataset, allora verrà sempre predetta la classe con più elementi (underfitting). Se al contrario, viene impostato $k=1$ si ottiene un modello che sicuramente overfitta. Un valore di $K$ dispari aiuta ad evitare situazioni di ambiguità. Come per tutti gli altri hyperparametri, si utilizza il validation set per determinare il $K$ migliore.

Per l'esempio pratico di questo modello non useremo il classico dataset _Iris_, ma questo #link("https://www.kaggle.com/datasets/yersever/500-person-gender-height-weight-bodymassindex?resource=download")[dataset generato artificialmente], contenente informazioni riguardo il sesso, l'altezza, il peso e l'indice corporeo di 500 persone:
#footnote("Gli autori degli appunti non credono che possano esistere persone alte 200cm e pesanti 45kg; perlomeno non vive.")

#image("../code/height-weight/img/plot_dataset.png")

Per riprendere ciò che abbiamo detto sopra, ecco qui un esempio di overfitting e underfitting con KNN:

#show grid.cell.where(y: 0): strong

#grid(
    columns: (1fr,1fr),
    row-gutter: 5pt,
    column-gutter: 0pt,
    inset: 0pt,

    grid.header(
      grid.cell(
        [Male],
        align: center,
      ),

      grid.cell(
        [Female],
        align: center,
      )

    ),

    grid.cell(
      colspan: 2,
      [Overfitting: $K = 1$],
      align: center,
    ),

    grid.cell(
      inset: 0pt,
    image("../code/height-weight/img/decision_boundaries_male_k=1_metric=minkowski.png"),
    ),

    image("../code/height-weight/img/decision_boundaries_female_k=1_metric=minkowski.png"),

    grid.cell(
      colspan: 2,
      [
        Underfitting: $K = 245$
      ],
      align: center,
    ),
    
    image("../code/height-weight/img/decision_boundaries_male_k=245_metric=minkowski.png"),

    image("../code/height-weight/img/decision_boundaries_female_k=245_metric=minkowski.png"),
)
      

Come sempre per questi esempi il dataset è troppo piccolo ed il tempo è poco, per non complicarci troppo le cose evitiamo di utilizzare un validation set, impostiamo $K = 11$ e vediamo come si comporta il modello.
#footnote("Sfortunatamente con questo dataset, utilizzando valori maggiori, si perdono categorie")

#quote(attribution: [Il web])[Una buona regola empirica se non sai quali valori prendere in considerazione per la scelta di K è $K = sqrt(n)$]

#image("../code/height-weight/img/decision_boundaries_male.png")
#image("../code/height-weight/img/decision_boundaries_female.png")

Fortunatamente per me, un maschio di 178cm che pesa 77kg rientra nella categoria 2 (Normal).

Contrariamente a quanto si possa pensare esistono diverse metriche che possono essere utilizzate per determinare la distanza da i data-points (indichiamo con $x$ e $y$ due punti nello spazio $n$-dimensionale e con $x_1, x_2, ..., x_n$ e $y_1, y_2, ..., y_n$ le loro coordinate):

#grid(
    columns: (1fr,2fr),
    rows: 2,
    column-gutter: 25pt,
    figure(
      image("../img/2D_distance.png", width: 100%), 
      caption: "La lunghezza della linea blu, rossa e gialla è la medesima e rappresenta la Manhattan distance tra i due punti (12). La lunghezza della linea verde rappresenta la Euclidean distance tra i due punti (6√2)",
      numbering: none,
      ),
    [
      - #text(blue)[Manhattan distance]: la distanza di Manhattan è la somma delle differenze assolute tra le coordinate dei punti. La formula è la seguente:
      $ D(x, y) = sum_(i=1)^n |x_i - y_i| $

      - #text(green)[Euclidean distance]: la distanza euclidea è la radice quadrata della somma dei quadrati delle differenze tra le coordinate dei punti. La formula è la seguente:
      $ D(x,y) = sqrt(sum_(i=1)^n (x_i - y_i)^2) $

      - *Minkowski distance*: una generalizzazione della distanza euclidea e della distanza di Manhattan. La formula è la seguente:
      $ D(x, y) = ( sum_(i=1)^n |x_i - y_i|^p )^(1/p) " con " p>= 1 $
    ],

)


== Esempio


