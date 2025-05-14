import subprocess
import os

STOP_FILE = os.getcwd() + "/cov_metrics/artifacts/STOP.txt"

if __name__ == "__main__":

    pwd = os.getcwd() + "/cov_metrics/reg"
    subprocess.run(["python3", pwd + "/prepare_inputs.py"])
    while True:
        subprocess.run(["python3", pwd + "/collect_logs.py"])
        subprocess.run(["python3", pwd +  "/calculate_fitness.py"])
        result =  subprocess.run(["python3", pwd +  "/normalize_fitness.py"])
        if os.path.exists(STOP_FILE):
            print("Обнаружен флаг завершения.")
            break
        subprocess.run(["python3", pwd +  "/crossover_select.py"])
        subprocess.run(["python3", pwd +  "/crossover.py"])
    subprocess.run(["python3", pwd +  "/draw_plot.py"])