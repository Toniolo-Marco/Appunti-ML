import matplotlib.pyplot as plt
import pandas as pd
from sklearn.linear_model import LinearRegression
from sklearn.preprocessing import PolynomialFeatures
import numpy as np
import seaborn as sns

# Carica il dataset
file_path = './dataset/500_Person_Gender_Height_Weight_Index.csv'
df = pd.read_csv(file_path)

# Imposta lo stile della visualizzazione
sns.set_theme(style="whitegrid")

index_colors = {
    '0 - Extremely Weak': 'blue', 
    '1 - Weak': 'lightblue', 
    '2 - Normal': 'green', 
    '3 - Overweight': 'yellow', 
    '4 - Obesity': 'orange', 
    '5 - Extreme Obesity': 'red'
}

index_labels = {
    0: '0 - Extremely Weak',
    1: '1 - Weak',
    2: '2 - Normal',
    3: '3 - Overweight',
    4: '4 - Obesity',
    5: '5 - Extreme Obesity'
}

# Sostituisci i valori nell'Index con le descrizioni
df['Index'] = df['Index'].map(index_labels)

gender_markers = {'Male': 'X', 'Female': 'o'}

# Crea il grafico a dispersione con le specifiche dei colori e delle forme
plt.figure(figsize=(12, 6))
sns.scatterplot(
    data=df, 
    x="Weight", 
    y="Height", 
    hue="Index", 
    palette=index_colors, 
    style="Gender", 
    markers=gender_markers,
    s=100  # dimensione dei marker
)

# Titolo e etichette
plt.title("Scatter Plot of Weight vs Height by Gender and Index")
plt.xlabel("Weight (kg)")
plt.ylabel("Height (cm)")

# Posiziona la legenda al di fuori della griglia
plt.legend(bbox_to_anchor=(1.05, 1), loc='upper left')

# Salva il grafico come immagine
image_path = "./img/plot_dataset.png"
plt.savefig(image_path, bbox_inches='tight')

# Mostra il percorso dell'immagine salvata
print(f"L'immagine è stata salvata in: {image_path}")
