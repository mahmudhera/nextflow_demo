from sourmash import fig 
from matplotlib import pyplot as plt
import seaborn as sns
import sys

# get matrix name from command line arg
matrix_name = sys.argv[1]
output_filename = sys.argv[2]

matrix, labels = fig.load_matrix_and_labels(matrix_name)
f, reordered_labels, reordered_matrix = fig.plot_composite_matrix(matrix, labels)

sns.clustermap(reordered_matrix, cmap='inferno', xticklabels=reordered_labels, yticklabels=reordered_labels)
plt.savefig(output_filename)
