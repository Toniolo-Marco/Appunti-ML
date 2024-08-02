import matplotlib.pyplot as plt
import pandas as pd
from sklearn.linear_model import LinearRegression
from sklearn.preprocessing import PolynomialFeatures
import numpy as np

def plot_population_vs_happiness(X, y, labels, model=None, poly_features=None, degree=None, title='', xlabel='', ylabel='', filename=''):
    plt.figure(figsize=(10, 6))
    plt.scatter(X, y, alpha=0.5)
    
    # Annotate some points
    for i in range(0, len(X), max(1, len(X) // 20)):  # Adjust the step to select points to label
        plt.text(X[i], y[i], labels[i], size=8, zorder=1, color='k')
    
    if model is not None:
        X_plot = np.linspace(X.min(), X.max(), 500).reshape(-1, 1)
        
        if poly_features is not None:
            X_plot = poly_features.transform(X_plot)
        
        plt.plot(X_plot[:, 0], 
                 model.predict(X_plot), 
                 color='red', linewidth=2)
    
    plt.title(title)
    plt.xlabel(xlabel)
    plt.ylabel(ylabel)
    plt.ylim(0, y.max() + 1)
    plt.xlim(0, X.max() + 10000000)  # Adjust x-axis limit for better visualization
    plt.grid(True)
    plt.savefig(f'./img/{filename}')
    plt.close()

def linear_regression(X, y, labels):
    model = LinearRegression()
    model.fit(X, y)
    
    plot_population_vs_happiness(X, y, labels, 
                                 model=model, 
                                 title='Population vs. Happiness Score (Linear Regression)', 
                                 xlabel='Population', 
                                 ylabel='Cantril ladder score', 
                                 filename='population-vs-happiness-linear-regression.png')
    
    return model

def polynomial_regression(X, y, labels, degree):
    poly_features = PolynomialFeatures(degree=degree, include_bias=False)
    X_poly = poly_features.fit_transform(X)
    model = LinearRegression()
    model.fit(X_poly, y)
    
    plot_population_vs_happiness(X, y, labels,
                                 model=model, 
                                 poly_features=poly_features, 
                                 degree=degree, 
                                 title=f'Population vs. Happiness Score (Polynomial Regression, degree={degree})', 
                                 xlabel='Population', 
                                 ylabel='Cantril ladder score', 
                                 filename=f'population-vs-happiness-poly-regression-degree-{degree}.png')
    
    return model, poly_features

# Load the combined dataset
file_path = './dataset/gdp-happiness-population.csv'
df = pd.read_csv(file_path)

# Print Austria's population and happiness score
austria = df[df['Entity'] == 'Austria']
print(austria)

# Remove Austria and World rows
df = df[(df['Entity'] != 'Austria') & (df['Entity'] != 'World') & (df['Entity'] != 'China') & (df['Entity'] != 'India')]

X = df[['Population (historical)']].values
y = df['Cantril ladder score'].values
labels = df['Entity'].values

# Plot Population vs. Happiness score
plot_population_vs_happiness(X, y, labels,
                             title='Population vs. Happiness Score', 
                             xlabel='Population', 
                             ylabel='Cantril ladder score', 
                             filename='population-vs-happiness.png')

# Plot and model
linear_regression_model = linear_regression(X, y, labels)

# Predict the happiness score for Austria
austria_population = austria[['Population (historical)']].values
predicted_happiness_score_linear = linear_regression_model.predict(austria_population)
print('Predicted Happiness Score for Austria (Linear Regression):', predicted_happiness_score_linear[0])

