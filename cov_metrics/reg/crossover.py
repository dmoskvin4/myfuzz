import re
import os
import random
import pandas as pd
import shutil

from mux import prepare_input
from src import input_generator
from src import preprocessor
from src import utils
from launch_spike import *

MUTATE_SECTIONS = 10
SPIKE = os.getcwd() + "/cov_metrics/reg/spike"

ROUND_FILE = os.getcwd() + "/cov_metrics/artifacts/ROUND.txt"

RANDOM_S = os.getcwd() + "/cov_metrics/artifacts/random"
RANDOM_LOG =  os.getcwd() + "/cov_metrics/artifacts/random.log"

HAL_FILE =  os.getcwd() + "/cov_metrics/artifacts/hall_of_fame.csv"
CROSSOVER_SELECTION_FILE = os.getcwd() + "/cov_metrics/artifacts/crossover_select.csv"
VECTORS_DIR = os.getcwd() + "/cov_metrics/artifacts/vectors/"
VECTORS_TMP_DIR = os.getcwd() + "/cov_metrics/artifacts/vectors_tmp"

import random

def parse_fuzz_main_labels(file_path):
    in_fuzz_main = False
    result = []

    with open(file_path, 'r') as f:
        for line in f:
            # Начало секции _fuzz_main
            if line.startswith("_l0:"):
                in_fuzz_main = True
            
            # Метка вида _l1:, _l2:, ...
            if in_fuzz_main and re.match(r'_l\d+:', line.strip()):
                current_line = line.split(':')
            
                command = current_line[1].strip()
                command = command.split(';')[0]
                command = command.strip() 
                result.append([command])

                if line.startswith("_l100:"):
                    result[-1] = ["addi x0, x1, 0"]
                    return result

            # Сохраняем инструкции
            elif in_fuzz_main:
                command = line.split(';')[0]
                command = command.strip()
                result[-1].append(command)

    return result

def crossover_parents(sections_a, sections_b):
    # Целевая длина потомка: случайное число от min до max
    target_length = len(sections_a)

    child = sections_a.copy()
    indices = random.sample(range(len(sections_a)), 50)
    for i in indices:
        child[i] = sections_b[i]

    return child

def shuffle_sections(sections, p_shuffle):
    shuffled = sections.copy()
    if random.random() < p_shuffle and len(shuffled) >= 2:
        i, j = random.sample(range(len(shuffled)), 2)
        shuffled[i], shuffled[j] = shuffled[j], shuffled[i]
    return shuffled

def delete_random_section(sections, p_delete):
    mutated = sections.copy()
    if random.random() < p_delete and len(mutated) >= 1:
        idx = random.randint(0, len(mutated) - 1)
        del mutated[idx]
        mutated.append(["addi x0, x1, 0"])
    return mutated

def get_random_section(lines, label):
    """
    Извлекает инструкции из секции с заданной меткой, например 'l34'.
    Поддерживает как многострочные, так и однострочные секции.
    """
    section_name = "_l" + str(random.randint(1, 99)) + ":"
    section_lines = []
    inside = False

    for line in lines:
        stripped = line.strip()
        if stripped.startswith(section_name):
            inside = True
            # Проверим, есть ли код на той же строке после метки
            code_after_colon = stripped[len(section_name):].strip()
            if code_after_colon:
                line_clean = code_after_colon.split(';')[0].strip()
                if line_clean:
                    section_lines.append(line_clean)
            continue
        elif inside and stripped.startswith('_l'):
            break  # Следующая секция началась
        if inside:
            line_clean = line.split(';')[0].strip()
            if line_clean:
                section_lines.append(line_clean)
    return section_lines
    
def create_random_section():
    
    input_generator, preprocessor, _ = utils.setup(100, "", "", "")
    while True:
        asm = prepare_input(input_generator, preprocessor, RANDOM_S, 1)
        is_ok, _ = run_spike_with_log(SPIKE, RANDOM_S, RANDOM_LOG)
        if is_ok:
            return asm
    
    return asm

def mutate_random_section(child, asm, p_add_random=0.2):
    
    mutated = child.copy()
    if random.random() < p_add_random:
        for i in range(0, MUTATE_SECTIONS):
            section = get_random_section(asm, random.randint(1, 99))
            idx = random.randint(0, len(mutated) - 1)
            mutated[idx] = section
    return mutated

def remove_fuzz_main_to_end_marker(lines):
    """
    Удаляет все строки между `_fuzz_main:` и `// RVTEST_CODE_END` включительно.
    """
    result = []
    inside_section = False

    for line in lines:
        if line.startswith("_l0:"):
            inside_section = True
            continue
        if inside_section and line.startswith("_l100:"):
            inside_section = False
            continue
        if not inside_section:
            result.append(line)

    return result

def insert_code_blocks(lines, new_code_blocks):
    start_idx = None
    end_idx = None

    # Найти индекс начала и конца вставки
    for i, line in enumerate(lines):
        if "_fuzz_main:" in line:
            start_idx = i
            end_idx = i + 1
            break

    if start_idx is None or end_idx is None:
        raise ValueError("Не найдены метки _fuzz_main или // RVTEST_CODE_END")

    # Генерация новых строк с метками
    generated_lines = []
    for i, block in enumerate(new_code_blocks):
        generated_lines.append(f"_l{i}:    {block[0]}                    ;\n")
        for instruction in block[1:]:
            generated_lines.append(f"      {instruction.strip()}         ;\n")

    # Вставка новых строк
    prefix = lines[:start_idx + 1]
    suffix = lines[end_idx:]
    prefix[:] = [f'{p}\n' for p in prefix]
    suffix[:] = [f'{p}\n' for p in suffix]
    
    updated_lines = prefix + generated_lines + suffix
    return updated_lines

def compile_mutated(path, asm_lines):
    input_generator, preprocessor, isa_host = utils.setup(100, "", "", "")
    return preprocessor.compile(path, asm_lines)

def copy_hall_of_fame():
    hof_df = pd.read_csv(HAL_FILE)

    pattern = re.compile(r'^input_.*\.elf$')
    elf_files = hof_df['file'].dropna().tolist()
    elf_files = [os.path.splitext(path)[0] for path in elf_files]

    for f in elf_files:
        shutil.copy(f + ".S", VECTORS_TMP_DIR)
        shutil.copy(f + ".elf", VECTORS_TMP_DIR)
        
# =====================================================


if __name__ == "__main__":

    asm_path = os.getcwd() + "/reg/output/input_2.S"

    asm = create_random_section()

    with open(ROUND_FILE, 'r') as f:
        current_round = int(f.read().strip())

    # Загружаем таблицу скрещиваний
    df = pd.read_csv(CROSSOVER_SELECTION_FILE)

    # Фильтруем по текущему раунду
    current_round_crossovers = df[df['round'] == current_round]
    
    os.mkdir(VECTORS_TMP_DIR)

    # Проходим по каждой строке и читаем родителей
    for idx, row in current_round_crossovers.iterrows():
        mom_file = row['mom']
        dad_file = row['dad']
        child_file = row['child']

        # Проверка на существование файлов
        if not os.path.isfile(mom_file):
            print(f"File {mom_file} was not found.")
            continue

        if not os.path.isfile(dad_file):
            print(f"File {dad_file} was not found.")
            continue

        # Чтение содержимого родителей
        with open(mom_file, 'r') as f1:
            mom_l_sections = parse_fuzz_main_labels(mom_file)

        with open(dad_file, 'r') as f2:
            dad_l_sections = parse_fuzz_main_labels(dad_file)

        child = crossover_parents(mom_l_sections, dad_l_sections)
        shuffled = shuffle_sections(child, 0.3)
        deleted = delete_random_section(shuffled, 0.2)
        mutated = mutate_random_section(deleted, asm, 0.5)

        with open(dad_file, 'r') as f2:
            dad_all_lines = [line.rstrip('\n') for line in f2]

        empty_fuzz_main = remove_fuzz_main_to_end_marker(dad_all_lines)
        all_mutated_lines = insert_code_blocks(empty_fuzz_main, mutated)
        
        child_name, dot, lol = child_file.rpartition('.') 
        res = compile_mutated(child_name, all_mutated_lines)
        if res != 0:
            print("failed")

        #print(f"✅ Vector: ", mom_file, " and ", dad_file, " have child ", child_name)

    copy_hall_of_fame()
    shutil.rmtree(VECTORS_DIR)
    os.rename(VECTORS_TMP_DIR, VECTORS_DIR)
    

        


