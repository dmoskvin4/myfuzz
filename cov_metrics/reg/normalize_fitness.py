import os
import pandas as pd

ROUND_FILE = os.getcwd() + "/cov_metrics/artifacts/ROUND.txt"
COVERAGE_FILE = os.getcwd() + "/cov_metrics/artifacts/coverage_summary.csv"
NORMALIZED_COVERAGE_FILE = os.getcwd() + "/cov_metrics/artifacts/normalized_fitness.csv"


def read_round(filename="ROUND.txt"):
    """Считать номер текущего раунда из файла."""
    with open(filename, "r") as f:
        return int(f.read().strip())

def load_coverage_data(filepath="coverage_summary.csv"):
    """Загрузить CSV-файл покрытия."""
    return pd.read_csv(filepath)

def filter_by_round(df, round_number):
    """Отфильтровать строки по номеру раунда."""
    filtered = df[df["round"] == round_number].copy()
    if filtered.empty:
        raise ValueError(f"Нет данных для раунда {round_number}")
    return filtered

def append_to_csv(df, filename="normalized_fitness.csv"):
    """Дописать данные в CSV без удаления старых строк."""
    if os.path.exists(filename):
        existing = pd.read_csv(filename)
        combined = pd.concat([existing, df], ignore_index=True)
    else:
        combined = df
    combined.to_csv(filename, index=False)
    print(f"✅ Данные для нового раунда добавлены в {filename}")

def save_result(df, filename="normalized_fitness.csv"):
    """Сохранить нормализованный фитнес в файл."""
    df.to_csv(filename, index=False)
    print(f"✅ Normalized fitness сохранён в {filename}")

def normalize_fitness(df):
    """Вычислить нормализованный фитнес с учётом особей с fitness == 0."""
    # Количество особей с нулевым фитнесом
    zero_fitness_mask = df["fitness"] == 0
    zero_fitness_count = zero_fitness_mask.sum()

    # Выделим фиксированную долю фитнеса для нулевых особей
    fixed_fitness = 0.001
    reserved_fitness = zero_fitness_count * fixed_fitness

    # Остаток фитнеса на остальных
    non_zero_total = df.loc[~zero_fitness_mask, "fitness"].sum()

    # Если весь фитнес был нулевым
    if non_zero_total == 0:
        df["normalized_fitness"] = 1 / len(df)
    else:
        df["normalized_fitness"] = 0.0
        # Назначаем 0.01 нулевым
        df.loc[zero_fitness_mask, "normalized_fitness"] = fixed_fitness
        # Остальным — пропорционально, нормализуя на оставшуюся часть
        scale = (1 - reserved_fitness) / non_zero_total
        df.loc[~zero_fitness_mask, "normalized_fitness"] = (
            df.loc[~zero_fitness_mask, "fitness"] * scale
        )

    return df

def main():
    round_num = read_round(ROUND_FILE)
    coverage_df = load_coverage_data(COVERAGE_FILE)
    round_df = filter_by_round(coverage_df, round_num)
    normalized_df = normalize_fitness(round_df)
    append_to_csv(normalized_df, NORMALIZED_COVERAGE_FILE)

if __name__ == "__main__":
    main()