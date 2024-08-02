import matplotlib.pyplot as plt
import pandas as pd
from sklearn.linear_model import LinearRegression
from sklearn.preprocessing import PolynomialFeatures
import numpy as np

def plot_data_and_model(X, y, model=None, poly_features=None, degree=None, title='', xlabel='', ylabel='', filename=''):
    plt.figure(figsize=(10, 6))
    plt.scatter(X, y, alpha=0.5)
    
    if model is not None:
        X_plot = np.linspace(X.min(), X.max(), 500).reshape(-1, 1)
        
        if poly_features is not None:
            X_plot = poly_features.transform(X_plot)
        
        X_plot_sorted = np.sort(X_plot[:, 0]) if degree is not None else X_plot[:, 0]
        plt.plot(X_plot_sorted, 
                 model.predict(X_plot)[np.argsort(X_plot[:, 0])], 
                 color='red', linewidth=2)
    
    plt.title(title)
    plt.xlabel(xlabel)
    plt.ylabel(ylabel)
    plt.ylim(0, y.max() + 1)
    plt.xlim(0, X.max().item() + 1000)  # Extract scalar value with .item()
    plt.grid(True)
    plt.savefig(f'./img/{filename}')
    plt.close()

def linear_regression(X, y):
    model = LinearRegression()
    model.fit(X, y)
    
    plot_data_and_model(X, y, 
                        model=model, 
                        title='GDP per capita vs. Happiness Score (Linear Regression)', 
                        xlabel='GDP per capita (USD $)', 
                        ylabel='Cantril ladder score', 
                        filename='gdp-vs-happiness-linear-regression.png')
    
    return model

def polynomial_regression(X, y, degree):
    poly_features = PolynomialFeatures(degree=degree, include_bias=False)
    X_poly = poly_features.fit_transform(X)
    model = LinearRegression()
    model.fit(X_poly, y)
    
    plot_data_and_model(X, y,
                        model=model, 
                        poly_features=poly_features, 
                        degree=degree, 
                        title=f'GDP per capita vs. Happiness Score (Polynomial Regression, degree={degree})', 
                        xlabel='GDP per capita (USD $)', 
                        ylabel='Cantril ladder score', 
                        filename=f'gdp-vs-happiness-poly-regression-degree-{degree}.png')
    
    return model, poly_features

# Load the combined dataset
file_path = './dataset/gdp-happiness-population.csv'
df = pd.read_csv(file_path)

# Print Austria's GDP per capita and happiness score
austria = df[df['Entity'] == 'Austria']
print(austria)

# Remove Austria and World rows
df = df[(df['Entity'] != 'Austria') & (df['Entity'] != 'World')]

X = df[['GDP per capita, PPP (constant 2017 international $)']]
y = df['Cantril ladder score']

# Plot GDP per capita vs. Happiness score
plot_data_and_model(X.values, y.values,
                    title='GDP per capita vs. Happiness Score', 
                    xlabel='GDP per capita (USD $)', 
                    ylabel='Cantril ladder score', 
                    filename='gdp-vs-happiness.png')

# Plot and model
linear_regression_model = linear_regression(X.values, y.values)

# Predict the happiness score for Austria
austria_gdp = pd.DataFrame({'GDP per capita, PPP (constant 2017 international $)': [austria['GDP per capita, PPP (constant 2017 international $)'].values[0]]})
predicted_happiness_score_linear = linear_regression_model.predict(austria_gdp.values)
print('Predicted Happiness Score for Austria (Linear Regression):', predicted_happiness_score_linear[0])

# i = 2
# while i <= 60:
#     polynomial_regression_model, poly_features = polynomial_regression(X.values, y.values, degree=i)

#     austria_gdp_poly = poly_features.transform(austria_gdp.values)
#     predicted_happiness_score_poly = polynomial_regression_model.predict(austria_gdp_poly)
#     print(f'Predicted Happiness Score for Austria (Polynomial Regression degree {i}):', predicted_happiness_score_poly[0])
    
#     if i == 2:
#         i = 3
#     else:
#         i = i + 2