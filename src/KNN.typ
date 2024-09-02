= KNN

#grid(
    columns: (2fr,3fr),
    [

      Il K-Nearest Neighbors (KNN) è un modello *supervised*, utilizzato per la classificazione, che si basa sulla distanza tra i punti del dataset. Al momento della predizione, il modello calcola la distanza tra il nuovo punto ed altri $k$ punti del dataset, e predice la classe del nuovo punto basandosi sulla classe più frequente tra i $k$ punti più vicini.
    ],
    image("../img/example-knn.png", width: 100%))

Il KNN ha alcuni aspetti caratteristici:
#footnote[Se la differenza tra _lazy_ e _instance-based_ non è chiara ora lo sarà nel capitolo dell'SVM.]

- È un modello *non parametrico*, cioè non necessita di assunzioni sulla distribuzione dei dati. La complessità del modello cresce con la dimensione del dataset.

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

Il fatto che overfitti si nota dalla presenza di molteplici "isole" all'interno delle diverse categorie (idealmente vorremmo che fosse a fasce); mentre l'underfitting si nota dalla presenza di una sola categoria o dall'assenza di alcune. Da questo esempio possiamo inoltre dedurre che il KNN può funzionare senza modifiche anche per la classificazione multi-classe.

Come sempre per questi esempi il dataset è troppo piccolo ed il tempo è poco, per non complicarci troppo le cose evitiamo di utilizzare un validation set, impostiamo $K = 11$ e vediamo come si comporta il modello.
#footnote("Sfortunatamente con questo dataset, utilizzando valori maggiori, si perdono categorie")

#quote(attribution: [Il web])[Una buona regola empirica se non sai quali valori prendere in considerazione per la scelta di K è $K = sqrt(n)$]

#image("../code/height-weight/img/decision_boundaries_male.png")
#image("../code/height-weight/img/decision_boundaries_female.png")

== Standardization and Scaling <standardization> <scaling>

Poiché KNN si basa sulla distanza tra i punti, se una feature ha un range molto più ampio rispetto ad un'altra, la distanza sarà dominata dalla feature con il range più ampio. Per evitare questo problema, è necessario standardizzare o scalare i dati. Gli strumenti presentati durante il corso sono la standardizzazione (o Z-score normalization) e il Min-Max scaling.

=== Z-score normalization

Questa procedura scala i dati in modo che abbiano una media di 0 e una deviazione standard di 1. La formula è la seguente:

$ z = frac(x - mu, sigma) $

Dove $x$ è il valore della feature, $mu$ è la media della feature e $sigma$ è la deviazione standard della feature.

Tornando all'esempio precedente, possiamo vedere come la standardizzazione influenzi la densità del dataset:

#grid(
  columns: (1fr,1fr),
  column-gutter: 0pt,
  image("../code/height-weight/img/z-score_male_k=8.png"), 
  image("../code/height-weight/img/z-score_female_k=8.png")
)

=== Min-Max scaling

Questa procedura scala i dati in modo che siano compresi tra 0 e 1. La formula è la seguente:

$ x_"scaled" = frac(x - min(x), max(x) - min(x)) $

Di seguito possiamo vedere come il Min-Max scaling influenzi la densità del dataset:

#grid(
  columns: (1fr,1fr),
  column-gutter: 0pt,
  image("../code/height-weight/img/min-max_male_k=8.png"),
  image("../code/height-weight/img/min-max_female_k=8.png")
)

== Distance Metrics

Contrariamente a quanto si possa pensare esistono diverse metriche che possono essere utilizzate per determinare la distanza da i data-points (indichiamo con $x$ e $y$ due punti nello spazio $n$-dimensionale e con $x_1, x_2, ..., x_n$ e $y_1, y_2, ..., y_n$ le loro coordinate):

#grid(
    columns: (1fr,2fr),
    rows: 2,
    column-gutter: 25pt,
    row-gutter: 25pt,
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
    grid.cell(
      colspan: 2,    
      [
        - *Cosine distance*: la cosine distance è derivata dalla _cosine similarity_, che misura quanto due vettori sono orientati nella stessa direzione. La formula per la cosine similarity tra due vettori $bold(A)$ e $bold(B)$ è: 

        $ "Cosine Similarity"(bold(A),bold(B)) = frac(bold(A) dot bold(B),||bold(A)|| ||bold(B)||) $
        
        dove $bold(A) dot bold(B)$ è il prodotto scalare, mentre $||bold(A)|| ||bold(B)||$ sono le norme dei vettori. La cosine similarity varia tra $-1$ e $1$, dove $1$ indica che i vettori puntano esattamente nella stessa direzione, $0$ indica che sono ortogonali (non correlati), e $-1$ indica che puntano in direzioni opposte.

        La cosine distance è semplicemente definita come:

        $ "Cosine Distance"(bold(A),bold(B)) = 1 - "Cosine Similarity"(bold(A),bold(B)) $ 

        Dunque, la cosine distance varia tra $0$ e $2$. Un valore di 0 indica che i vettori sono identici in termini di direzione, mentre un valore di $1$ indica che sono ortogonali.

        La cosine distance è particolarmente utile in applicazioni come l'analisi di testi e il riconoscimento di immagini, dove i dati possono essere vettori di caratteristiche normalizzati. Per esempio nell'analisi dei testi ogni elento del vettore può rappresentare il numero di occorrenze di una certa parola.
    ]
    )
)


== Curse of Dimensionality

Il problema principale dell'utilizzo delle distanze è che queste crescono esponenzialmente al crescere delle dimensioni; questo problema è noto come *Curse of Dimensionality*. Con KNN è necessario avere un dataset denso, i data-point dello stesso gruppo devono essere vicini *in ogni dimensione*; a differenza di altri algoritmi. Inoltre, per ottenere una buona performance, il numero di dati deve crescere esponenzialmente con il numero delle dimensioni.

Possiamo osservare le distribuzioni delle distanze tra due punti in 1,2,3 dimensioni:

#image("../code/curse-of-dimensionality/img/plot.png")

Per evidenziare l'andamento esponenziale trovate qui un grafico che indica la distanza media di due punti con coordinate $[0;100]$, in un sample composto da 1000 elementi, nelle dimensioni da 1D a 100D.
 
#image("../code/curse-of-dimensionality/img/trend.png")


== Computational Cost

Il fatto che KNN sia un _lazy learner_ non implica che non ci sia un costo computazionale; anzi il costo compotuzionale pesa solo sulla fase di predizione (_inferece phase_).
L'algoritmo è  lineare, il calcolo della distanza per tutti i $k$ punti del dataset: $O(k N)$. Alcune strutture dati possono essere utilizzate per ridurre il costo computazionale, come il KD-Tree o il Ball-Tree, che permettono di ridurre il costo computazionale a $O(log(N))$. Di seguito presentiamo una carrellata delle strutture dati più comuni:

=== KD-Tree

La struttura richiede un pre-processing dei dati e si presenta come un albero binario. Ogni nodo dell'albero rappresenta un iperpiano che divide lo spazio in due parti, o più semplicemente impone un vincolo tra i due nodi figli successivi. I nodi foglia contengono i punti del dataset. La _"k"_ nel nome si riferisce appunto al numero di features presenti. La ricerca di un punto nel KD-Tree è simile alla ricerca di un punto in un albero binario di ricerca. La ricerca di un punto in un KD-Tree ha un costo computazionale di $O(log(N))$.

Sempre utilizzando l'esempio pratico, osserviamo la struttura del KD-Tree dopo l'applicazione del Min-Max scaling:


=== Ball-Tree
=== Cover Tree

=== R-Tree
=== VP-Tree

=== Approximate Nearest Neighbor Search (ANN) Techniques
=== Locality Sensitive Hashing (LSH)
=== Annoy

=== Hierarchical Navigable Small World (HNSW) Graphs
=== Lattice-based Methods
=== FLANN (Fast Library for Approximate Nearest Neighbors)

/*TODO: terminare queste sezioni*/
