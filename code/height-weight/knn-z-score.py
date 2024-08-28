import pandas as pd
import numpy as np
import matplotlib.pyplot as plt
from matplotlib.colors import ListedColormap
from sklearn.neighbors import KNeighborsClassifier
from sklearn.preprocessing import LabelEncoder, StandardScaler, MinMaxScaler
from sklearn.inspection import DecisionBoundaryDisplay

# Load the dataset
file_path = './dataset/500_Person_Gender_Height_Weight_Index.csv'
df = pd.read_csv(file_path)

# Convert the "Gender" column to numeric values
le = LabelEncoder()
df['Gender'] = le.fit_transform(df['Gender'])

# Color map
index_colors = {
    0: 'blue',          # 0 - Extremely Weak
    1: 'lightblue',     # 1 - Weak
    2: 'green',         # 2 - Normal
    3: 'yellow',        # 3 - Overweight
    4: 'orange',        # 4 - Obesity
    5: 'red'            # 5 - Extreme Obesity
}

# Create a custom colormap
cmap = ListedColormap([index_colors[i] for i in sorted(index_colors.keys())])

# Define a function to apply z-score normalization
def normalize_z_score(df, features):
    scaler = StandardScaler()
    df[features] = scaler.fit_transform(df[features])
    return df

# Define a function to apply min-max scaling
def normalize_min_max(df, features):
    scaler = MinMaxScaler()
    df[features] = scaler.fit_transform(df[features])
    return df

# Function to generate the plot and save it
def plot_and_save_decision_boundaries(gender_df, gender_name, file_name, model: KNeighborsClassifier, scaling_method='z-score'):
    X = gender_df[['Weight', 'Height']]
    y = gender_df['Index']
    
    # Train the model
    model.fit(X, y)
    
    # Create the plot
    fig, ax = plt.subplots(figsize=(8, 8))  # Set figure size to keep 1:1 ratio

    # Generate decision boundaries
    disp = DecisionBoundaryDisplay.from_estimator(
        model,
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
    disp.ax_.scatter(X['Weight'], X['Height'], c=y, cmap=cmap, edgecolors="k")
    disp.ax_.set_title(f"Decision Boundaries ({gender_name}), K={model.get_params()['n_neighbors']}")
    
    # Adjust axis limits based on scaling method
    if scaling_method == 'z-score':
        x_min, x_max = X['Weight'].min() - 0.5, X['Weight'].max() + 0.5
        y_min, y_max = X['Height'].min() - 0.5, X['Height'].max() + 0.5
    elif scaling_method == 'min-max':
        x_min, x_max = -0.1, 1.1  # Set to cover the range of min-max normalized data (0 to 1)
        y_min, y_max = -0.1, 1.1  # Slightly extend the range for visualization clarity

    ax.set_xlim(x_min, x_max)
    ax.set_ylim(y_min, y_max)

    # Set aspect ratio to 1:1
    ax.set_aspect('equal', adjustable='box')

    # Reduce whitespace around the plot
    plt.tight_layout()

    # Save the plot
    plt.savefig(f"{file_name}_{gender_name.lower()}_k={model.get_params()['n_neighbors']}.png", bbox_inches='tight')
    plt.close()

# Define the KNN model
k = 8
weights = 'uniform'
metric = 'minkowski'

knn = KNeighborsClassifier(n_neighbors=k, weights=weights, metric=metric)

# Normalize data with z-score
df_zscore = normalize_z_score(df.copy(), ['Weight', 'Height'])
df_male_zscore = df_zscore[df_zscore['Gender'] == 1]
df_female_zscore = df_zscore[df_zscore['Gender'] == 0]

# Generate and save the plot for males with z-score normalization
plot_and_save_decision_boundaries(df_male_zscore, "Male", "./img/z-score", knn, scaling_method='z-score')

# Generate and save the plot for females with z-score normalization
plot_and_save_decision_boundaries(df_female_zscore, "Female", "./img/z-score", knn, scaling_method='z-score')

# Normalize data with min-max scaling
df_minmax = normalize_min_max(df.copy(), ['Weight', 'Height'])
df_male_minmax = df_minmax[df_minmax['Gender'] == 1]
df_female_minmax = df_minmax[df_minmax['Gender'] == 0]

# Generate and save the plot for males with min-max scaling
plot_and_save_decision_boundaries(df_male_minmax, "Male", "./img/min-max", knn, scaling_method='min-max')

# Generate and save the plot for females with min-max scaling
plot_and_save_decision_boundaries(df_female_minmax, "Female", "./img/min-max", knn, scaling_method='min-max')
