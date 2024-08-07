= Introduzione <intro>

== Prefazione <prefazione>

#grid(
    columns: 2,
    [
      Questi appunti si rifanno alle lezioni 2023/2024 del corso Introduction to Machine Learning tenuto dalla docente Elisa Ricci, 
      al libro 'Deep Learning' di Ian Goodfellow e Yoshua Bengio; ed infine al libro 'Hands on machine learning' di Aurélien Géron pubblicato da O'Reilly.
      
      Gli appunti sono scritti con #link("https://typst.app/docs")[typst], senza una panoramica sui diversi argomenti, ma affrontandoli uno ad uno a seconda della necessità.
      All'interno di questa introduzione troverete solo i concetti basilari, utili alla comprensione dei successivi argomenti.
    ],
    
    figure(
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
Ogni modello ha le sue peculiarità, e la scelta del modello giusto dipende dal problema (_task_) che si vuole risolvere.
I modelli possono essere divisi in categorie, anche se con eccezioni e sfumature, a seconda del tipo di apprendimento:

- Supervised Learning: il modello apprende da un training set etichettato precedentemente.
- Unsupervised Learning: il modello apprende pattern o strutture dai dati senza etichette.
- Reinforcement Learning: il modello apprende attraverso il feedback di un ambiente.
- Semi-Supervised Learning: il modello apprende sia da dati etichettati che non etichettati. 
  Viene utilizzato in sostituzione al supervised learning nei casi in cui etichettare i dati risulti troppo costoso o, richieda troppo tempo.

== Task <task>

Le principali task per cui viene adottato il Machine Learning sono:
- Classification: classificare un input in una delle classi predefinite.
- Regression: predire un valore numerico (continuo), dato un input.
- Transcription: convertire un input in testo. L'input può essere un'immagine, un audio, ecc.
- Machine Translation: tradurre un testo in un'altra lingua.
- Anomaly Detection: identificare pattern anomali nei dati.
- Synthesis: generare nuovi dati che seguano la stessa distribuzione dei dati originali. (_e.g._ textures, speech, ecc.)
- Denoising: in questo task il modello, ha come input un dato corrotto $bold(accent(x,~))$ e deve predire il dato originale bold(x); o meglio la distribuzione di probabilità $p(bold(x)|bold(accent(x,~)))$.
- Density Estimation:
- assd 


/*TODO: terminare questo trafiletto*/
/*TODO: elencare gli attributi del modello*/