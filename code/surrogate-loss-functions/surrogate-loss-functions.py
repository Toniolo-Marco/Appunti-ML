import numpy as np
import matplotlib.pyplot as plt

# Definire l'intervallo di y' (predizioni del modello)
y_prime = np.linspace(-3, 3, 400)

# 0/1 Loss
def zero_one_loss(y, y_prime):
    return np.where(y * y_prime <= 0, 1, 0)

# Hinge Loss
def hinge_loss(y, y_prime):
    return np.maximum(0, 1 - y * y_prime)

# Squared Loss
def squared_loss(y, y_prime):
    return (y - y_prime) ** 2

# Exponential Loss
def exponential_loss(y, y_prime):
    return np.exp(-y * y_prime)

# Log Loss
def log_loss(y, y_prime):
    return np.log(1 + np.exp(-y * y_prime))

# Predizioni per la classe positiva (y = 1)
y = 1

# Calcolare le perdite per le diverse funzioni di loss
zero_one = zero_one_loss(y, y_prime)
hinge = hinge_loss(y, y_prime)
squared = squared_loss(y, y_prime)
exponential = exponential_loss(y, y_prime)
log = log_loss(y, y_prime)

# Definire i nomi dei file
filenames = ["zero_one_loss.png", "hinge_loss.png", "squared_loss.png", 
             "exponential_loss.png", "log_loss.png", "all_losses_comparison.png"]

# Plottare e salvare ogni loss function in un file diverso
plt.figure()
plt.plot(y_prime, zero_one, label="0/1 Loss", color="blue")
# plt.title("0/1 Loss")
plt.xlabel("y'")
plt.ylabel("Loss")
plt.grid()
plt.tight_layout()
plt.savefig(filenames[0])

plt.figure()
plt.plot(y_prime, hinge, label="Hinge Loss", color="orange")
# plt.title("Hinge Loss")
plt.xlabel("y'")
plt.ylabel("Loss")
plt.grid()
plt.tight_layout()
plt.savefig(filenames[1])

plt.figure()
plt.plot(y_prime, squared, label="Squared Loss", color="green")
# plt.title("Squared Loss")
plt.xlabel("y'")
plt.ylabel("Loss")
plt.grid()
plt.tight_layout()
plt.savefig(filenames[2])

plt.figure()
plt.plot(y_prime, exponential, label="Exponential Loss", color="red")
# plt.title("Exponential Loss")
plt.xlabel("y'")
plt.ylabel("Loss")
plt.grid()
plt.tight_layout()
plt.savefig(filenames[3])

plt.figure()
plt.plot(y_prime, log, label="Log Loss", color="purple")
# plt.title("Log Loss")
plt.xlabel("y'")
plt.ylabel("Loss")
plt.grid()
plt.tight_layout()
plt.savefig(filenames[4])

# Plottare tutte le loss function in un singolo grafico
plt.figure(figsize=(10, 6))
plt.plot(y_prime, zero_one, label="0/1 Loss", color="blue")
plt.plot(y_prime, hinge, label="Hinge Loss", color="orange")
plt.plot(y_prime, squared, label="Squared Loss", color="green")
plt.plot(y_prime, exponential, label="Exponential Loss", color="red")
plt.plot(y_prime, log, label="Log Loss", color="purple")
plt.title("Comparison of Loss Functions")
plt.xlabel("y'")
plt.ylabel("Loss")
plt.legend()
plt.grid()
plt.savefig(filenames[5])
plt.close()
