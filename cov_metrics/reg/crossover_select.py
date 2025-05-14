import pandas as pd
import random
import os

ROUND_FILE = os.getcwd() + "/cov_metrics/artifacts/ROUND.txt"
NORMALIZED_FITNESS_FILE = os.getcwd() + "/cov_metrics/artifacts/normalized_fitness.csv"
HAL_FILE =  os.getcwd() + "/cov_metrics/artifacts/hall_of_fame.csv"
CROSSOVER_SELECTION = os.getcwd() + "/cov_metrics/artifacts/crossover_select.csv"

TOP_N = 10  # Количество лучших особей в зале славы

import pandas as pd
import numpy as np
from pathlib import Path

def read_round_number(path=ROUND_FILE):
    with open(path, "r") as f:
        return int(f.read().strip())

def load_fitness_data(path=NORMALIZED_FITNESS_FILE):
    df = pd.read_csv(path)
    return df

def get_fitness_for_round(df, round_number):
    return df[df['round'] == round_number].copy()

def build_hall_of_fame(df, top_n=10):
    return df.sort_values(by="fitness", ascending=False).head(top_n)

def parents_roulette_selection(normalized_fitness_df, hof_df, pair_count):
    normalized_fitness_sum = normalized_fitness_df['normalized_fitness'].sum()
    probabilities = normalized_fitness_df['normalized_fitness'] / normalized_fitness_sum
    
    files = normalized_fitness_df['file'].tolist()
    probabilites = probabilities.tolist()

    selected = np.random.choice(normalized_fitness_df['file'].tolist(), pair_count * 2, probabilities.tolist())
    selected = [f.replace('.log', '.S') for f in selected]
    parents = [(selected[i], selected[i+1]) for i in range(0, len(selected), 2)]
    childs = []
    
    for child in normalized_fitness_df['file']:
        if child not in hof_df['file'].tolist(): 
            childs.append(child.replace('vectors', 'vectors_tmp'))

    family = [t + (e,) for t, e in zip(parents, childs)]
    df = pd.DataFrame(family, columns = ['mom', 'dad', 'child'])
    return df

def append_to_csv(df, path):
    if Path(path).exists():
        df.to_csv(path, mode='a', header=False, index=False)
    else:
        df.to_csv(path, mode='w', header=True, index=False)

def main():
    round_number = read_round_number()
    fitness_df = load_fitness_data()
    round_df = get_fitness_for_round(fitness_df, round_number)

    hof_df = build_hall_of_fame(round_df)
    print(hof_df.to_markdown())
    append_to_csv(hof_df, HAL_FILE)

    selected_df = parents_roulette_selection(round_df, hof_df, pair_count=len(round_df) - TOP_N)
    selected_df['round'] = round_number
    selected_df = selected_df.loc[:, ['round', 'mom', 'dad', 'child']]  
    append_to_csv(selected_df, CROSSOVER_SELECTION)

if __name__ == "__main__":
    main()