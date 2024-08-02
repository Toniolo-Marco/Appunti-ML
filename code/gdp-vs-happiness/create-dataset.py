
import pandas as pd

# Load the CSV files
gdp_file_path = './dataset/gdp-per-capita-worldbank.csv'
happiness_file_path = './dataset/happiness-cantril-ladder.csv'
population_file_path = './dataset/population.csv'

gdp_df = pd.read_csv(gdp_file_path)
happiness_df = pd.read_csv(happiness_file_path)
population_df = pd.read_csv(population_file_path)

# Merge the two datasets on 'Entity', 'Code', and 'Year'
combined_df = pd.merge(gdp_df, happiness_df, on=['Entity', 'Code', 'Year'], how='inner')

# Merge the combined dataframe with the population dataframe
final_combined_df = pd.merge(combined_df, population_df, on=['Entity', 'Code', 'Year'], how='inner')

# For each country, find the latest available data by selecting the row with the maximum Year
latest_data_df = final_combined_df.sort_values('Year').groupby(['Entity', 'Code'], as_index=False).last()

# Save the combined dataset to a new CSV file
output_file_path = './dataset/gdp-happiness-population.csv'
latest_data_df.to_csv(output_file_path, index=False)
