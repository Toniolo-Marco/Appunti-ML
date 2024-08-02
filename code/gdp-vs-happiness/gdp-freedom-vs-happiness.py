import pandas as pd
import matplotlib.pyplot as plt
from mpl_toolkits.mplot3d import Axes3D
from sklearn.model_selection import train_test_split
from sklearn.linear_model import LinearRegression
from sklearn.metrics import mean_squared_error, r2_score

# Load the CSV files
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

ax.scatter(X.iloc[:, 0], X.iloc[:, 1], y, c='r', marker='o')

ax.set_xlabel('GDP per capita (PPP)')
ax.set_ylabel('Freedom Index')
ax.set_zlabel('Cantril ladder score')

plt.title('3D Scatter Plot of GDP per capita, Freedom Index, and Cantril ladder score')
plt.savefig('./img/gdp-freedom-vs-happiness-3d-scatter.png')
plt.close()

# Creating and training the linear regression model
model = LinearRegression()
model.fit(X, y)

# Making predictions on Austria's GDP per capita and Freedom Index
austria_features = austria[['GDP per capita, PPP (constant 2017 international $)', 'Freedom Index']]
if not austria_features.empty:
    y_pred = model.predict(austria_features)
    print(f'Predicted happiness score for Austria: {y_pred[0]:.2f}')
else:
    print("No valid data for Austria to make predictions.")