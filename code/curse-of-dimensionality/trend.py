import matplotlib.pyplot as plt
import numpy as np

# Function to calculate the Minkowski distance between two random points in n-dimensional space
def minkowski_distance_in_n_dimensions(dimensions, num_samples=1000):
    p = dimensions  # Set p equal to the number of dimensions
    distances = []
    epsilon = 1e-10  # Small constant to prevent floating-point issues
    for _ in range(num_samples):
        # Generate random integer points between 0 and 100 for each dimension
        point1 = np.random.randint(0, 101, size=dimensions)
        point2 = np.random.randint(0, 101, size=dimensions)
        
        # Calculate absolute differences and add epsilon
        abs_diff = np.abs(point1 - point2) + epsilon
        
        # Compute Minkowski distance with stability checks
        distance = np.sum(abs_diff ** p) ** (1 / p)
        distances.append(distance)
    return distances

# Function to calculate the mean distance for each dimension from 1D to max_dimensions
def calculate_mean_distances(max_dimensions=100, num_samples=1000):
    mean_distances = []
    for dim in range(1, max_dimensions + 1):
        distances = minkowski_distance_in_n_dimensions(dim, num_samples)
        mean_distance = np.mean(distances)
        mean_distances.append(mean_distance)
    return mean_distances

# Function to plot the growth of mean distance from 1D to max_dimensions
def plot_mean_distance_growth(max_dimensions=100):
    mean_distances = calculate_mean_distances(max_dimensions)

    # Plotting the growth of mean distances
    plt.figure(figsize=(10, 6))
    plt.plot(range(1, max_dimensions + 1), mean_distances, linestyle='-', color='blue')
    plt.title('Growth of Mean Minkowski Distance from 1D to 100D')
    plt.xlabel('Dimensions')
    plt.ylabel('Mean Distance')
    plt.grid(True)
    plt.savefig(f"./img/trend.png")
    plt.close()

# Run the plot function
if __name__ == "__main__":
    plot_mean_distance_growth(100)