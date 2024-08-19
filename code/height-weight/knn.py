import pandas as pd
import numpy as np
import matplotlib.pyplot as plt
from matplotlib.colors import ListedColormap
from matplotlib.patches import Patch
from sklearn.neighbors import KNeighborsClassifier
from sklearn.preprocessing import LabelEncoder
from sklearn.inspection import DecisionBoundaryDisplay

# Carica il dataset
file_path = './dataset/500_Person_Gender_Height_Weight_Index.csv'
df = pd.read_csv(file_path)

# Convertiamo la colonna "Gender" in valori numerici
le = LabelEncoder()
df['Gender'] = le.fit_transform(df['Gender'])

# Mappa Colori
index_colors = {
    0: 'blue',          # 0 - Extremely Weak
    1: 'lightblue',     # 1 - Weak
    2: 'green',         # 2 - Normal
    3: 'yellow',        # 3 - Overweight
    4: 'orange',        # 4 - Obesity
    5: 'red'            # 5 - Extreme Obesity
}

# Creazione della colormap personalizzata
cmap = ListedColormap([index_colors[i] for i in sorted(index_colors.keys())])

# Separiamo i dati per genere
df_male = df[df['Gender'] == 1]
df_female = df[df['Gender'] == 0]

# Funzione per generare il grafico e salvarlo
def plot_and_save_decision_boundaries(gender_df, gender_name, file_name, model: KNeighborsClassifier):
    X = gender_df[['Weight', 'Height']]
    y = gender_df['Index']
    
    # Addestriamo il modello
    knn.fit(X, y)
    
    # Crea il grafico
    fig, ax = plt.subplots(figsize=(12, 6))
    
    # Generiamo i decision boundaries
    disp = DecisionBoundaryDisplay.from_estimator(
        knn,
        X,
        response_method="predict",
        plot_method="pcolormesh",
        cmap=cmap,
        xlabel='Weight',
        ylabel='Height',
        shading="auto",
        alpha=0.5,
        ax=ax,
    )
    scatter = disp.ax_.scatter(X['Weight'], X['Height'], c=y, cmap=cmap, edgecolors="k")
    #_ = disp.ax_.set_title(f"Decision Boundaries ({gender_name}), K={model.get_params()['n_neighbors']}, Metric={model.get_params()['metric']}")
    
    # Legenda personalizzata
    # handles = [Patch(color=index_colors[i], label=f'{i} - {label}') for i, label in index_colors.items()]
    # ax.legend(handles=handles, loc='upper right', title="Classes")
    
    # Salva il grafico
    plt.savefig(f"{file_name}_{gender_name.lower()}_k={model.get_params()['n_neighbors']}_metric={model.get_params()['metric']}.png")
    plt.close()
    
# Funzione per fare una predizione
def predict_index(gender, height, weight, model: KNeighborsClassifier):
    gender_value = le.transform([gender])[0]  # Converti il genere in valore numerico
    X_new = pd.DataFrame([[weight, height]], columns=['Weight', 'Height'])  # Crea un DataFrame con peso e altezza
    
    # Scegli il dataset in base al genere
    if gender_value == 1:
        knn.fit(df_male[['Weight', 'Height']], df_male['Index'])
    else:
        knn.fit(df_female[['Weight', 'Height']], df_female['Index'])
    
    prediction = knn.predict(X_new)
    return prediction[0]



# Definiamo il modello KNN
k = 245
weights='uniform'
metric='minkowski'

knn = KNeighborsClassifier(n_neighbors=k,weights=weights,metric=metric)

# Genera e salva il grafico per i maschi
plot_and_save_decision_boundaries(df_male, "Male", "./img/decision_boundaries", knn)

# Genera e salva il grafico per le femmine
plot_and_save_decision_boundaries(df_female, "Female", "./img/decision_boundaries", knn)

# Predizione
result = predict_index('Male', 178, 78, knn)
print(f"Prediction: {result}")