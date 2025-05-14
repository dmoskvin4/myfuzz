import os
import pandas as pd
import matplotlib.pyplot as plt


NORMALIZED_COVERAGE_FILE = os.getcwd() + "/cov_metrics/artifacts/normalized_fitness.csv"
FITNESS_PLOT_FILE = os.getcwd() + "/cov_metrics/artifacts/fitness_plot.png"


def main():
    # Загрузка данных
    df = pd.read_csv(NORMALIZED_COVERAGE_FILE)

    # Проверим, что есть нужные столбцы
    if "round" not in df.columns or "fitness" not in df.columns:
        raise ValueError("Ожидаются столбцы 'round' и 'fitness' в файле.")
    
    # Группировка по раундам
    grouped = df.groupby("round")["fitness"]
    
    # Вычисляем средний и максимальный фитнес по раундам
    mean_fitness = grouped.mean()
    max_fitness = grouped.max()
    
    # Построение графика
    plt.figure(figsize=(10, 6))
    plt.plot(mean_fitness.index, mean_fitness.values, marker='o', label="Средний фитнес")
    plt.plot(max_fitness.index, max_fitness.values, marker='s', label="Максимальный фитнес")
    plt.xlabel("Раунд")
    plt.ylabel("Фитнес")
    plt.title("Динамика фитнеса по раундам")
    plt.legend()
    plt.grid(True)
    plt.tight_layout()
    plt.savefig(FITNESS_PLOT_FILE)

if __name__ == "__main__":
    main()