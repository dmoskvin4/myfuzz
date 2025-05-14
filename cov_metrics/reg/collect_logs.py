import os
from launch_spike import *

VECTORS_DIR = os.getcwd() + "/cov_metrics/artifacts/vectors/"
SPIKE = os.getcwd() + "/cov_metrics/reg/spike"


def run_spike_for_all_elf(directory="."):
    for root, _, files in os.walk(directory):
        for elf_file in files:
            if elf_file.endswith(".elf"):
                #print("Calculating log for " + elf_file)
                elf_full_path = os.path.join(root, elf_file)
                log_full_path = base = os.path.splitext(elf_full_path)[0] + ".log"
                run_spike_with_log(SPIKE, elf_full_path, log_full_path) 

# Запускаем
if __name__ == "__main__":
    run_spike_for_all_elf(VECTORS_DIR)
