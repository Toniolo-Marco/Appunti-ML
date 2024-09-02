import pandas as pd
import numpy as np
import matplotlib.pyplot as plt
from matplotlib.colors import ListedColormap
from sklearn.neighbors import KDTree
from sklearn.preprocessing import LabelEncoder, MinMaxScaler

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

# Define a function to apply min-max scaling
def normalize_min_max(df, features):
    scaler = MinMaxScaler()
    df[features] = scaler.fit_transform(df[features])
    return df

# Function to plot decision boundaries using KD-Tree
def plot_and_save_decision_boundaries_kdtree(gender_df, gender_name, file_name, n_neighbors=8, scaling_method='min-max'):
    X = gender_df[['Weight', 'Height']].values
    y = gender_df['Index'].values

    # Train KD-Tree
    kdtree = KDTree(X, leaf_size=30, metric='euclidean')

    # Create a mesh grid over the feature space
    x_min, x_max = X[:, 0].min() - 0.1, X[:, 0].max() + 0.1
    y_min, y_max = X[:, 1].min() - 0.1, X[:, 1].max() + 0.1
    xx, yy = np.meshgrid(np.arange(x_min, x_max, 0.01), np.arange(y_min, y_max, 0.01))
    grid_points = np.c_[xx.ravel(), yy.ravel()]

    # Predict class labels for all grid points using KD-Tree KNN
    dist, indices = kdtree.query(grid_points, k=n_neighbors)
    y_pred_grid = np.array([np.bincount(y[neighbors]).argmax() for neighbors in indices])

    # Reshape prediction to match the grid
    y_pred_grid = y_pred_grid.reshape(xx.shape)

    # Create the plot
    fig, ax = plt.subplots(figsize=(8, 8))

    # Plot the decision boundary
    ax.contourf(xx, yy, y_pred_grid, alpha=0.3, cmap=cmap)

    # Plot the original data points
    scatter = ax.scatter(X[:, 0], X[:, 1], c=y, cmap=cmap, edgecolors="k")
    ax.set_xlabel('Weight')
    ax.set_ylabel('Height')
    ax.set_title(f"Decision Boundaries ({gender_name}), K={n_neighbors}")

    # Adjust axis limits based on scaling method
    if scaling_method == 'min-max':
        ax.set_xlim(0, 1)
        ax.set_ylim(0, 1)

    # Set aspect ratio to 1:1
    ax.set_aspect('equal', adjustable='box')

    # Reduce whitespace around the plot
    plt.tight_layout()

    # Save the plot
    plt.savefig(f"{file_name}_{gender_name.lower()}_k={n_neighbors}.png", bbox_inches='tight')
    plt.close()

# Function to plot the KD-Tree structure with filled areas and single category number
def plot_kdtree_structure_single_label(kdtree, X, y, ax, depth=0, x_min=0, x_max=1, y_min=0, y_max=1):
    if len(X) == 0:
        return
    
    # Choose axis based on depth
    axis = depth % X.shape[1]
    
    # Sort data and choose median point as pivot
    sorted_idx = np.argsort(X[:, axis])
    median_idx = len(sorted_idx) // 2
    median_point = X[sorted_idx[median_idx]]

    # Determine the region's color based on the majority class in this region
    region_class = np.bincount(y).argmax()
    color = index_colors[region_class]

    # Check if this is a leaf node (no further split)
    if len(X) == 1 or (x_max - x_min < 0.01 and y_max - y_min < 0.01):
        # Fill the region with the corresponding color
        ax.fill_between([x_min, x_max], y_min, y_max, color=color, alpha=0.5)
        # Label the region with the predicted class
        ax.text((x_min + x_max) / 2, (y_min + y_max) / 2, str(region_class), color='black', fontsize=10, ha='center', va='center')
        return

    # Fill the region with the corresponding color
    if axis == 0:
        ax.fill_betweenx([y_min, y_max], x_min, median_point[0], color=color, alpha=0.5)
        plot_kdtree_structure_single_label(kdtree, X[sorted_idx[:median_idx]], y[sorted_idx[:median_idx]], ax, depth + 1, x_min, median_point[0], y_min, y_max)
        plot_kdtree_structure_single_label(kdtree, X[sorted_idx[median_idx + 1:]], y[sorted_idx[median_idx + 1:]], ax, depth + 1, median_point[0], x_max, y_min, y_max)
    else:
        ax.fill_between([x_min, x_max], y_min, median_point[1], color=color, alpha=0.5)
        plot_kdtree_structure_single_label(kdtree, X[sorted_idx[:median_idx]], y[sorted_idx[:median_idx]], ax, depth + 1, x_min, x_max, y_min, median_point[1])
        plot_kdtree_structure_single_label(kdtree, X[sorted_idx[median_idx + 1:]], y[sorted_idx[median_idx + 1:]], ax, depth + 1, x_min, x_max, median_point[1], y_max)

    # Draw the splitting line
    if axis == 0:
        ax.plot([median_point[0], median_point[0]], [y_min, y_max], 'k-', lw=1)
    else:
        ax.plot([x_min, x_max], [median_point[1], median_point[1]], 'k-', lw=1)

# Normalize data with min-max scaling
df_minmax = normalize_min_max(df.copy(), ['Weight', 'Height'])
df_male_minmax = df_minmax[df_minmax['Gender'] == 1]
df_female_minmax = df_minmax[df_minmax['Gender'] == 0]

# Generate and save the plot for males using KD-Tree KNN
plot_and_save_decision_boundaries_kdtree(df_male_minmax, "Male", "./img/KD-tree", n_neighbors=8, scaling_method='min-max')

# Generate and save the plot for females using KD-Tree KNN
plot_and_save_decision_boundaries_kdtree(df_female_minmax, "Female", "./img/KD-tree", n_neighbors=8, scaling_method='min-max')

# Plot the KD-Tree structure for males with filled areas and single category number
fig, ax = plt.subplots(figsize=(8, 8))
ax.scatter(df_male_minmax['Weight'], df_male_minmax['Height'], c='b', s=20, edgecolor='k')
plot_kdtree_structure_single_label(KDTree(df_male_minmax[['Weight', 'Height']].values, leaf_size=30, metric='euclidean'), 
                                   df_male_minmax[['Weight', 'Height']].values, df_male_minmax['Index'].values, ax)
ax.set_xlim(0, 1)
ax.set_ylim(0, 1)
ax.set_xlabel('Weight')
ax.set_ylabel('Height')
ax.set_title('KD-Tree Structure (Male) with Filled Areas and Single Category Number')
plt.tight_layout()
plt.savefig("./img/kdtree_structure_filled_male_single_number.png", bbox_inches='tight')
plt.close()

# Plot the KD-Tree structure for females with filled areas and single category number
fig, ax = plt.subplots(figsize=(8, 8))
ax.scatter(df_female_minmax['Weight'], df_female_minmax['Height'], c='r', s=20, edgecolor='k')
plot_kdtree_structure_single_label(KDTree(df_female_minmax[['Weight', 'Height']].values, leaf_size=30, metric='euclidean'), 
                                   df_female_minmax[['Weight', 'Height']].values, df_female_minmax['Index'].values, ax)
ax.set_xlim(0, 1)
ax.set_ylim(0, 1)
ax.set_xlabel('Weight')
ax.set_ylabel('Height')
ax.set_title('KD-Tree Structure (Female) with Filled Areas and Single Category Number')
plt.tight_layout()
plt.savefig("./img/kdtree_structure_filled_female_single_number.png", bbox_inches='tight')
plt.close()
