= Decision Tree

Il *Decision Tree* è un modello di apprendimento supervisionato, che come suggerisce il nome ha una struttura ad albero. Ogni nodo dell'albero può essere:
- Non Terminale: dunque avere 2 o più figli ed implementare una _routing function_.
- Foglia: dunque non avere alcun figlio (_leaf node_) ed implementare una _prediction function_.

Il Decision Tree è un modello molto semplice e interpretabile (_explainability_); questa caratteristica è uno dei suoi più grandi vantaggi. Inoltre, è un modello molto versatile, in quanto può essere utilizzato sia per problemi di classificazione che di regressione. 

prende in input un vettore di features $x$ e questo viene passato attraverso l'albero fino ad arrivare ad una foglia, che restituirà una predizione.