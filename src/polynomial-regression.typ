= Polynomial Regression <polynomial-regression>

Nel caso in cui non avessimo altre features a disposizione, o la distribuzione dei dati non fosse lineare, potremmo utilizzare una regressione polinomiale. Nel caso preso in esempio, abbiamo visto come la retta non fosse in grado di generalizzare particolarmente bene i dati. Prima di procedere con la pratica vediamo la formula della regressione polinomiale, anche se è abbastanza intuitiva e non ci dovrebbe essere nulla da spiegare:

$ hat(y) = w x + b 
attach(arrow.r.long,b:italic("polinomiale")) 
hat(y) = b + sum_(italic("i = 1"))^n w_i x^i
$

Applicando la regressione polinomiale con grado del polinomio: $n=2$ all'esempio visto in precedenza otteniamo:

#figure(
  image("../code/gdp-vs-life-satisfaction/img/gdp-vs-life-satisfaction-poly-regression-degree-2.png", width: 90%),
  caption: [Plot dei dati GDP vs Life satisfaction con la regressione lineare e grado 2]
)

Ora il modello predice un valore di 7,01 per l'Austria, più vicino al valore reale. Proviamo con gradi ancora più alti:

#figure(
  grid(
    columns: 2,
    image("../code/gdp-vs-life-satisfaction/img/gdp-vs-life-satisfaction-poly-regression-degree-3.png", width: 100%),
    image("../code/gdp-vs-life-satisfaction/img/gdp-vs-life-satisfaction-poly-regression-degree-5.png", width: 100%)
  ),
  caption: [Plot dei dati GDP vs Life satisfaction con la regressione lineare e grado 3 e 5]
)

Con un grado 3 il modello predice un valore di 6,79, mentre con un grado 5 il modello predice un valore di 7,21. 


#figure(
  grid(
    columns: 2,
    image("../code/gdp-vs-life-satisfaction/img/gdp-vs-life-satisfaction-poly-regression-degree-15.png", width: 100%),
    image("../code/gdp-vs-life-satisfaction/img/gdp-vs-life-satisfaction-poly-regression-degree-60.png", width: 100%),
    ),
  caption: [Plot dei dati GDP vs Life satisfaction con la regressione lineare e grado 15 e 60]
)

Se alzialiamo ulteriormente il grado del polinomio, il modello non migliorerà; anzi dalla tabella di seguito e dalle immagini precedenti dovrebbe essere chiaro come avere un grado del polinomio più alto non implichi che il modello generalizzi meglio.

#figure(
  table(
    columns: 11,
    [grado],[1],[2],[3],[5],[15],[20],[30],[40],[50],[60],

    [predizione],[6.66],[7.01],[6.79],[7.21],[5.43],[5.43],[5.43],[5.43],[5.43],[5.43],
  
    [errore],[±0.44],[±0.09],[±0.31],[±0.11],[±1.67],[±1.67],[±1.67],[±1.67],[±1.67],[±1.67]
  )
)

Dopo questi due capitoli, dovrebbero sorgere al lettore almeno due domande:

+ Com'è possibile che la regressione lineare performi meglio della regressione polinomiale con grado $>= 15$? 

  Innanzitutto è necessario precisare che come "test set" abbiamo utilizzato un solo data point. Tuttavia questo è un esempio del *Tradeoff tra Bias e Varianza*: nonostante la regressione lineare abbia un *training error* maggiore della regressione polinomiale in alcuni casi, è in grado di *generalizzare* meglio a causa della alta variabilità dei modelli con gradi più alti.

+ Come possiamo valutare il modello in modo rigoroso?

  Per valutare il modello in maniera sistematica dovremmo innanzitutto dividere il dataset in training set e test set; in quanto il test set d'esempio è composto solo dall'Austria.
  Successivamente dobbiamo decidere come valutare l'errore del modello, una delle metriche più diffuse per la task di regressione è l'*errore quadratico medio* (MSE).  

+ Come possiamo capire quale grado del polinomio è il migliore?

  Il grado del polinomio è un *iperparametro* del modello; e per essere selzionato al meglio viene utilizzato un *validation set*.

Nel prossimo capitolo vedremo come valutare un modello di regressione, come selezionare il grado del polinomio.