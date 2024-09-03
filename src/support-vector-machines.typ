= Support Vector Machines (SVM)

// TODO: Aggiungere immagini.


Le *Support Vector Machines (SVM)* sono un modello di apprendimento supervisionato largamente utilizzato sia per la classificazione che per la regressione. La loro diffusione è dovuta alla tolleranza verso dataset non linearmente separabili, diversamente dal perceptron.

Infatti le maggiori carenze del perceptron sono:
1. Se il dataset è linearmente separabile, il perceptron trova un iperpiano che separa i dati, ma non è unico.
2. Se il dataset non è linearmente separabile, il perceptron continuerà le iterazioni aggiornando i pesi; ma l'iperpiano finale dipenderà dagli esempi visti per ultimi.
#grid(
  columns: (1fr, 1fr),
  [I *Support Vector* sono i datapoint più vicini all'iperpiano di separazione. Per $n$ dimensioni ci sono almeno $n+1$ support vector. 
  Un'altra ragione per cui le SVM sono così popolari è che, finita la fase di addestramento, il modello è definito solo dai *support vector*, ovvero i punti più vicini all'iperpiano di separazione. Questo ha il vantaggio di velocizzare la fase di predizione in quanto si vanno ad escludere tutti gli altri datapoint del training set.
  La distanza tra l'iperpiano e i support vector è chiamata *margine*; e viene descritta matematicamente così: $ frac(w dot x_i + b,||w||) = frac(1,||w||) $
  Dove $w$ è il vettore dei pesi, $x_i$ è il support vector e $b$ è il bias.
  ],

  image("../img/support-vectors.png", width: 100%),
)



== Large Margin Classifier

L'idea alla base dei Large Margin Classifier è quella di trovare l'iperpiano che massimizza il margine tra le classi. Empiricamente, l'iperpiano con il margine più grande è quello che generalizza meglio sui dati di test, per questo è così rilevante. Trovare questo iperpiano equivale a risolvere il seguente problema di ottimizzazione:

$ max_(w,b) space "margin"(w,b) quad = max_(w,b) space frac(1,||w||) $

Questo problema è soggetto al vincolo:

$ y_i (w dot x_i + b) >= 1 $

Dove $y_i$ è l'etichetta del datapoint $x_i$, $w$ è il vettore dei pesi, $b$ è il bias. Questo vincolo impone che i punti siano classificati correttamente. Infatti se $y_i = 1$ (cioè $x_i$ appartiene alla classe $+1$), allora la condizione diventa: $w dot x_i + b >= 1$; se $y_i = -1$ (cioè x_i appartiene alla classe $-1$), viceversa, la condizione diventa: $w dot x_i + b <= -1$.

In poche parole:
- Tutti i punti di classe +1 si trovino al di sopra o sul bordo del margine positivo dell'iperpiano.
- Tutti i punti di classe -1 si trovino al di sotto o sul bordo del margine negativo dell'iperpiano.

Ne deduciamo che il punto più vicino all'iperpiano potrà avrà un'equazione del tipo: $ w dot x_i + b = 1$, se appartenente alla classe $+1$ e posizionato sul margine.

Masimizzare il margine equivale a minimizzare la norma dei pesi $w$, e per motivi computazionali si preferisce (il vincolo permane):

$ min_(w,b) space ||w|| quad | quad y_i (w dot x_i + b) >= 1 quad forall i $

Inoltre se eleviamo al quadrato la norma dei pesi, otteniamo una funzione obiettivo più semplice da minimizzare:

$ min_(w,b) space ||w||^2 quad | quad y_i (w dot x_i + b) >= 1 quad forall i $

Questo ci porta ad un problema di ottimizzazione quadratico, soggetto ad un vincolo lineare.

== Soft Margin Classification

Il vincolo imposto in precedenza è molto rigido, e se il dataset non è linearmente separabile, non è possibile trovare un iperpiano che soddisfi il vincolo. Per ovviare a questo problema, si introduce la *slack variable*, idicata con il simbolo $zeta$ per ogni datapoint:

$ min_(w,b) space ||w||^2 + C sum_(i=1)^n zeta_i quad | quad y_i (w dot x_i + b) >= 1 - zeta_i quad forall i, zeta_i >= 0 $

Il valore $C$ è un iperparametro che regola il tradeoff tra la massimizzazione del margine e la penalizzazione per la violazione del vincolo.

Valori di $C$ più piccoli permettono di ignorare il vincolo, ottenendo margini più ampi. Valori di $C$ più grandi penalizzano maggiormente le violazioni del vincolo, ottenendo margini più stretti. Ne segue che $C=infinity$ equivale al caso di *hard margin classification*.

#image("../img/svm-C-hyperparameter.png", width: 100%)

È importante notare che questo problema rimane comunqe un problema di ottimizzazione quadratico, e che generalmente il termina $zeta_i$ sarà uguale a $0$ in quanto la maggior parte dei punti si troverà dal lato "corretto" dell'iperpiano.

Per i punti non classificati correttamente, il valore di $zeta_i$ sarà maggiore di $0$ ed otterremo $zeta_i = 1 - y_i (w dot x_i + b)$, che rappresenta la distanza tra il punto e il margine (corretto).

Possiamo riscrivere il valore di $zeta_i$ come:

$ zeta_i =  cases( 
  0 && " if" quad y_i (w dot x_i + b) >= 1,
  1 - y_i (w dot x_i + b) && " otherwise"
) $

Questo ci permette di riscrivere ulteriormente il problema di ottimizzazione senza vincoli:

$ zeta_i  &= max(0, 1 - y_i (w dot x_i + b)) \ 
      &= max(0,1 - y y') $

Dove $y'$ ricordiamo essere la predizione del modello.

#quote()[L'espressione $max(0,1 - y y')$, che abbiamo appena ottenuto, è già stata affrontata in precedenza, ed è chiamata *hinge loss*.]

Dunque il problema di ottimizzazione diventa:

$
& min_(w,b) space ||w||^2 + C sum_(i=1)^n max(0,1 - y_i y_i ') \
&= min_(w,b) space ||w||^2 + C sum_(i=1)^n "loss"_"hinge" (y_i, y_i ') $

Questo problema di ottimizzazione è noto come *primal problem* e coincide con la generica forma già vista, semplicemente scamabiando l'ordine degli addendi:

$ "argmin"_(w,b) sum_(i=1)^n "loss"(y y') + lambda "regularizer"(w,b) $

== Dual Problem

Il problema di ottimizzazione appena visto è un problema di ottimizzazione quadratica con vincoli lineari, e può essere risolto con il metodo dei moltiplicatori di Lagrange. Applicando questo metodo, si ottiene il *dual problem*:

$ f(x) = sum_i^n alpha_i y_i X_i^T  + b$

// TODO: Terminare la spiegazione del dual problem.

== Kernel Trick

Il *Kernel Trick* è una tecnica che permette di rendere il dataset linearmente separabile in uno spazio di dimensione maggiore, senza dover effettivamente trasformare l'intero dataset ad una dimensione maggiore; ma calcolando il rapporto tra i punti del dataset. Questo è possibile grazie al concetto di *Kernel Function*.

#grid(columns: (1fr, 1fr),

    image("../img/svm-kernel-trick_1.png", width: 90%),

  
    image("../img/svm-kernel-trick_2.png", width: 100%),
  
)

Le *Kernel Function* disponibili sono moltissime, le più comuni sono:
- *Linear Kernel*: $K(x_i, x_j) = x_i^T x_j$
- *Polynomial Kernel*: $K(x_i, x_j) = (x_i^T x_j + c)^d$
  Dove $c$ e $d$ sono iperparametri. In particolare, $d$ è il grado del polinomio. 
- *Gaussian Kernel*: $K(x_i, x_j) = e^(- frac(||x_i - x_j||^2, 2 sigma^2))$
