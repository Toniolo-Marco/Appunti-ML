
#set heading(numbering: "1.")
#set document(
  title: [Appunti del corso "Introduction to Machine Learning"],
  author: ("Toniolo Marco","Federico Frigerio"),
  keywords: ("Introduction", "Machine Learning", "ML", "Appunti", "Riassunto"),
  date: (auto)
)

#let imageonside(lefttext, rightimage, bottomtext: none, marginleft: 0em, margintop: 0.5em) = {
  set par(justify: true)
  grid(columns: 2, column-gutter: 1em, (lefttext), rightimage)
  set par(justify: false)
  block(inset: (left: marginleft, top: -margintop), bottomtext)
}

#show link: underline

= Introduzione <intro>

#imageonside(
    "Questi appunti si rifanno alle lezioni 2023/2024 del corso Introduction to Machine Learning tenuto dalla docente Elisa Ricci, al libro 'Deep Learning' di Ian Goodfellow e Yoshua Bengio; ed infine al libro 'Hands on machine learning' di Aurélien Géron pubblicato da O'Reilly. " 
    ,figure(
    image("../img/diagramma-ai-machine-learning-nn-and-deep-learning.png", width: 90%),
    caption: [
      La relazione tra intelligenza artificiale, machine learning e deep learning.
    ],
  )
)


== Dataset <dataset>
Il dataset è l'insieme dei dati disponibili per l'analisi. 
Su questo dataset si effettuano le operazioni di training e testing. 

Il training set è il sottoinsieme del dataset utilizzato per addestrare il modello; mentre il test set è il sottoinsieme utilizzato per testare il modello.
Il validation set è un sottoinsieme del training set utilizzato per regolare gli iperparametri del modello, prima della fase di testing.

Per generare questi sottinsiemi è necessario fare due assunzioni sui dati (_i.i.d. assumption_), ovvero che siano:

- *indipendenti* (non ci sia correlazione tra i dati del training set e del test set)
- *identicamente distribuiti* (prelevati dalla stessa distribuzione di probabilità $p_(italic("data"))$ )

== Modello <modello>

L'obbiettivo, nel Machine Learning, è che il nostro modello performi bene su dati che non ha mai visto prima; questa abilità è detta _generalizzazione_.

Durante la fase di training, (durante la quale abbiamo accesso solo al training set) possiamo misurare l'errore

/*TODO: terminare questo trafiletto*/
/*TODO: elencare gli attributi del modello*/

== Underfitting e Overfitting <underfitting-overfitting>

L'Underfitting si verifica quando il modello non ottiene buone prestazioni ne sul training set, ne sul test set. 

L'Overfitting si verifica quando il modello ottiene buone prestazioni sul training set ma non sul test set. 

== The No Free Lunch Theorem <no-free-lunch-theorem>

Contrariamente a quanto si possa pensare, non esiste un modello che sia il migliore in assoluto per tutti i problemi.


= Regressione Lineare <regressione-lineare>

Come suggerisce il nome, la regressione lineare è un modello che risolve un problema di regressione, ovvero dato un vettore $bold(x) in bb(R)^n$ in input, restituisce un valore $y in bb(R)$ in output. L'output della regressione lineare è una funzione lineare dell'input.

Definiamo $hat(y)$ come il valore che il nostro modello predice, definiamo dunque l'output come:

$ hat(y) = bold(w)^tack.b   bold(x) $

Dove: $bold(w)$ è un vettore di parametri.

Questi parametri, anche chiamati pesi, determinano il comportamento del sistema; in questo specifico caso si tratta del coefficiente per cui moltiplichiamo il vettore di input $bold(x)$.

$ hat(y) = bold(w)^tack.b   bold(x) + b $

Questa è una _affine function_, ovvero una funzione lineare con una traslazione ($b$ è noto come _intercept term_ o _bias_). Come si può notare, inoltre, l'equazione assomiglia molto a quella di una retta in due dimensioni: $y = m x + q$. Infatti per un grado $n=1$ la regressione lineare è proprio una retta. 

Facciamo un breve esempio pratico: supponiamo di avere un #link("https://ourworldindata.org/grapher/gdp-vs-happiness")[dataset con GDP per capita e un valore di soddisfazione della vita] per ogni paese del mondo e volessimo costruire un modello che preveda quest'ultimo valore #footnote[Questo valore viene misurato con la #link("https://news.gallup.com/poll/122453/understanding-gallup-uses-cantril-scale.aspx")[scala di Cantril].].

Prima di tutto plottiamo i dati:

#figure(
  image("../code/gdp-vs-life-satisfaction/img/gdp-vs-life-satisfaction.png", width: 90%),
  caption: [Plot dei dati GDP vs Life-satisfaction degli ultimi dati disponibili per ogni paese. (ex Austria)]
)

Ora proviamo ad utilizzare la regressione lineare per prevedere il livello di soddisfazione della vita in Austria, che abbiamo escluso dal training set, dato il suo GDP per capita:

#figure(
  image("../code/gdp-vs-life-satisfaction/img/gdp-vs-life-satisfaction-linear-regression.png", width: 90%),
  caption: [Plot dei dati GDP vs Life-satisfaction con la regressione lineare e grado 1]
) 

L'austria nel 2022 aveva un GDP per capita di \$55,867 e un livello di felicità di 7,09. Il modello di regressione lineare ci dice che il livello di felicità previsto è di 6,66. Forse possiamo fare di meglio.

Torniamo sulla formula della regressione lineare, possiamo generalizzarla come:

$ hat(y) = b + w_1 x_1 + w_2 x_2 + ... + w_n x_n $

Dalla formula generalizzata capiamo che la regressione lineare può funzionare anche in più dimensioni, non solo con una variabile indipendente; ed in questo caso si dice "multivariata". Per esempio con $2$ variabili indipendenti avremo un piano. Dunque se aggiungessimo lo #link("https://worldpopulationreview.com/country-rankings/freedom-index-by-country")[Human Freedom Index] come feature, avremmo un modello tridimensionale:

#figure(
  image("../code/gdp-and-freedom-vs-life-satisfaction/img/gdp-freedom-vs-life-satisfaction-3d-scatter-with-model.png", width: 100%),
  caption: [Plot dei dati GDP e Freedom vs Life satisfaction in 3D]
)

In questo caso la predizione del modello per l'Austria è di 6,80, più vicina al valore reale. 


= Polinomial Regression <polinomial-regression>

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

Quindi come possiamo capire quale grado del polinomio è il migliore?

Il grado del polinomio è un *iperparametro* del modello; e per essere determinato correttamente viene utilizzato un *validation set*.



== Regulaization / Regolarizzazione <regolarizzazione>

La regolarizzazione è una qualsiasi modifica che apportiamo al modello per ridurre l'errore di generalizzazione (ma non il training error).

Il comportamento dell'algoritmo è influenzato infatti, non solo dalla capacità del modello (spazio delle ipotesi); ma anche dall'identità delle funzioni utilizzate. Per esempio, la regressione lineare ha uno spazio delle ipotesi composto esclusivamente da funzioni lineari e, nel caso non ci sia relazione lineare tra i dati (_e.g._ $sin(x)$), non sarà in grado di generalizzare bene.

Potremmo modificare il criterio di ottimizzazione per la regressione lineare includendo un termine regolarizzatore (denotato con $ohm(w)$) nella funzione di costo. 

Nello specifico caso del weight decay il rego è uguale a: $ohm(w) = bold(w)^tack.b bold(w)$. Dunque il criterio sarà:

$ J(bold(w)) = "MSE"_("train") + lambda bold(w)^tack.b bold(w) $

in questo modo minimiziamo una somma che comprende sia l'errore quadratico medio sul training set, sia il termine di regolarizzazione. In questo caso il termine $lambda$ è un iperparametro che regola l'importanza del termine di regolarizzazione. Con $lambda = 0$ il modello si comporta come una regressione lineare standard, mentre con $lambda > 0$ il modello tenderà a preferire pesi più piccoli, da questo il nome weight decay.

#figure(
  image("../img/example-of-the-effect-of-weight-decay.png", width: 90%),
  caption: ["Il modello utilizzato ha solo funzioni di grado 9, mentre il dataset è generato da una funzione quadratica."]
)


/*General Stuff*/

Nel campo del Machine Learning esistono diverse varianti per quanto riguarda le tecniche di regolarizzazione. 

Famiglia delle $L^p$ norme; generalizzata con la formula:
$ ||bold(x)||_p = (sum^n_(i = 1) |x_i|^p )^frac(1,p) $ 
con $n$ ad indicare le dimensioni e $p in [1,+infinity)$. 

- La norma 1 è banalmente la somma dei valori assoluti dei componenti.
- La norma 2 o Norma Euclidea, è la radice quadrata della somma dei quadrati dei valori: $ ||bold(x)||_2 = sqrt(sum^n_(i = 1) x_i^2) $. 

== Dataset Augmentation <dataset-augmentation>

Il miglior modo per avere un modello che generalizza bene è trainarlo su più dati e, spesso, il dataset a disposizione non è abbastanza grande. Un modo per risolvere questo problema sono le tecniche di dataset augmentation. Questo approccio è molto efficace con le task di classificazione, object recognition e speech recognition. Com'è facile immaginare per quanto concerne l'object recognition, possiamo ruotare, scalare, e traslare le immagini; per lo speech recognition possiamo aggiungere rumore alle registrazioni.

L'iniezione di rumore è alla base di alcuni modelli unsupervised, come il denoising autoencoder. La noise injection può inoltre essere implementata negli hidden layer. 

== Hyperparameters <hyperparameters>

Gli iperparametri sono parametri che non vengono appresi durante il training, ma che influenzano il comportamento del modello.

Molti modelli di Machine Learning hanno iperparametri, per quanto riguarda la regressione lineare, di base, ha solo il grado del polinomio. Il grado del polinomio, come abbiamo visto precedentemente determina la capacità del modello.

Allo stesso modo $lambda$ nella regolarizzazione è un iperparametro.