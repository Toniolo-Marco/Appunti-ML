import pandas as pd
import numpy as np
import matplotlib.pyplot as plt
from mpl_toolkits.mplot3d import Axes3D
from sklearn.linear_model import LinearRegression

# Load the combined dataset
df = pd.read_csv('./dataset/combined-dataset.csv')

# Filter for Austria and exclude rows with NaN values for prediction
austria = df[df['Entity'] == 'Austria'].dropna(subset=['GDP per capita, PPP (constant 2017 international $)', 'Freedom Index'])

# Drop rows with NaN values in the required columns for training
cleaned_df = df.dropna(subset=['GDP per capita, PPP (constant 2017 international $)', 'Freedom Index', 'Cantril ladder score'])

# Extracting the features and target variable
X = cleaned_df[['GDP per capita, PPP (constant 2017 international $)', 'Freedom Index']]
y = cleaned_df['Cantril ladder score']

# Plotting the data in a 3D scatter plot
fig = plt.figure(figsize=(10, 7))
ax = fig.add_subplot(111, projection='3d')

# Scatter plot
ax.scatter(X.iloc[:, 0], X.iloc[:, 1], y, c='r', marker='o')

# Labels
ax.set_xlabel('GDP per capita (PPP)')
ax.set_ylabel('Freedom Index')
ax.set_zlabel('Cantril ladder score')

plt.title('3D Scatter Plot of GDP per capita, Freedom Index, and Cantril ladder score')

# Creating and training the linear regression model
model = LinearRegression()
model.fit(X, y)

# Creating a meshgrid for plotting the linear model
x_surf, y_surf = np.meshgrid(np.linspace(X.iloc[:, 0].min(), X.iloc[:, 0].max(), 100), 
                             np.linspace(X.iloc[:, 1].min(), X.iloc[:, 1].max(), 100))
z_surf = model.predict(np.c_[x_surf.ravel(), y_surf.ravel()]).reshape(x_surf.shape)

# Plotting the linear model surface
ax.plot_surface(x_surf, y_surf, z_surf, color='b', alpha=0.3, rstride=100, cstride=100)

# Save the plot
plt.savefig('./img/gdp-freedom-vs-life-satisfaction-3d-scatter-with-model.png')
plt.close()

# Making predictions on Austria's GDP per capita and Freedom Index
austria_features = austria[['GDP per capita, PPP (constant 2017 international $)', 'Freedom Index']]
if not austria_features.empty:
    y_pred = model.predict(austria_features)
    print(f'Predicted life satisfaction score for Austria: {y_pred[0]:.2f}')
else:
    print("No valid data for Austria to make predictions.")