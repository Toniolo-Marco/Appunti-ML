import numpy as np
import matplotlib.pyplot as plt

# Function to calculate the Minkowski distance between two random points in n-dimensional space
def minkowski_distance_in_n_dimensions(dimensions,rand_min,rand_max,num_samples):
    p = dimensions  # Set p equal to the number of dimensions
    distances = []
    for _ in range(num_samples):
        # Generate random integer points between 0 and 100 for each dimension
        point1 = np.random.randint(rand_min,rand_max, size=dimensions)
        point2 = np.random.randint(rand_min,rand_max, size=dimensions)
        distance = np.sum(np.abs(point1 - point2) ** p) ** (1 / p)
        distances.append(distance)
    return distances

# Plotting function for 1D, 2D, and 3D cases with Minkowski distance
def plot_minkowski_distances(rand_min,rand_max,num_samples):
    dimensions = [1, 2, 3]
    all_distances = []
    max_y = 0  # Initialize max y value to 0

    # Calculate distances for each dimension and collect all distances
    for dim in dimensions:
        distances = minkowski_distance_in_n_dimensions(dim,rand_min,rand_max,num_samples)
        all_distances.append(distances)

    # Determine the global max distance for setting the x-axis limit
    max_distance = max(max(distances) for distances in all_distances)

    fig, axs = plt.subplots(1, 3, figsize=(18, 5))

    for i, dim in enumerate(dimensions):
        # Create a histogram and capture the bin heights to determine max y value
        counts, bins, patches = axs[i].hist(all_distances[i], bins=30, alpha=0.75, color='blue', edgecolor='black')
        axs[i].set_title(f'Minkowski Distances in {dim}D (p={dim})')
        axs[i].set_xlabel('Distance')
        axs[i].set_ylabel('Frequency')
        axs[i].set_xlim(0, max_distance)  # Set the same x-axis range for all plots
        max_y = max(max_y, max(counts))  # Update max_y with the maximum count from the current histogram

    # Set the same y-axis limit for all plots
    for ax in axs:
        ax.set_ylim(0, max_y + (num_samples/100))

    plt.tight_layout()
    plt.savefig(f"./img/plot.png")
    plt.close()

# Run the plotting function with different p values
plot_minkowski_distances(rand_min=0,rand_max=101, num_samples=1000)
