import os
import re
import glob
import sys

import pandas as pd

#e   0: 0x00000000800004d4 (0xd5090797) auipc   a5, 0xd5090
#core   0: >>>>  _l10
##core   0: 0x00000000800004d8 (0xf00900d3) fmv.w.x ft1, s2
##ore   0: >>>>  _l11
#core   0: 0x00000000800004dc (0x29238a53) fmin.s  fs4, ft7, fs2
#core   0: >>>>  _l12
#core   0: 0x00000000800004e0 (0x580f87d3) fsqrt.s fa5, ft11
#core   0: >>>>  _l13
#core   0: 0x00000000800004e4 (0xa14790d3) flt.s   ra, fa5, fs4
#core   0: >>>>  _l14
#core   0: 0x00000000800004e8 (0x00000c93) li      s9, 0
#core   0: 0x00000000800004ec (0x00002917) auipc   s2, 0x2
#core   0: 0x00000000800004f0 (0xef490913) addi    s2, s2, -268
#core   0: 0x00000000800004f4 (0x02890913) addi    s2, s2, 40
#core   0: 0x00000000800004f8 (0x132c8073) sfence.vma s9, s2
#core   0: >>>>  _l15
#core   0: 0x00000000800004fc (0x00020397) auipc   t2, 0x20
#core   0: 0x0000000080000500 (0xc5438393) addi    t2, t2, -940
#core   0: 0x0000000080000504 (0xff239483) lh      s1, -14(t2)
#core   0: >>>>  _l16
#core   0: 0x0000000080000508 (0x4119013b) subw    sp, s2, a7
#core   0: >>>>  _l17
#core   0: 0x000000008000050c (0x00060597) auipc   a1, 0x60
#core   0: 0x0000000080000510 (0xbf458593) addi    a1, a1, -1036
#core   0: 0x0000000080000514 (0xffe004b7) lui     s1, 0xffe00
#core   0: 0x0000000080000518 (0x0095c5b3) xor     a1, a1, s1
#core   0: 0x000000008000051c (0xff95a823) sw      s9, -16(a1)
#
# auipc   a1, 0x20
# Паттерн, с которым сравниваем

pattern = [
    {"opcode": r"add", "rd": r".*", "rs1": r".*"},
    {"opcode": r"addi", "rd": r".*", "rs1": r".*"},
    {"opcode": r"auipc", "rd": r".*", "rs1": r".*"},
    {"opcode": r"lui", "rd": r".*", "rs1": r".*"},
    {"opcode": r"xor", "rd": r".*", "rs1": r".*"},
    {"opcode": r"xori", "rd": r".*", "rs1": r".*"},
    {"opcode": r"sw", "rd": r".*", "rs1": r".*"},
    {"opcode": r"amomax.d", "rd": r".*", "rs1": r".*"}
    {"opcode": r"lh", "rd": r".*", "rs1": r".*"}
]

ROUND_FILE = os.getcwd() + "/cov_metrics/artifacts/ROUND.txt"
STOP_FILE = os.getcwd() + "/cov_metrics/artifacts/STOP.txt"

def get_next_round():
    if not os.path.exists(ROUND_FILE):
        with open(ROUND_FILE, 'w') as f:
            f.write("1")
        return 1
    else:
        with open(ROUND_FILE, 'r+') as f:
            current = int(f.read().strip())
            f.seek(0)
            f.write(str(current + 1))
            f.truncate()
        return current + 1

def score_line(line, pat):
    match = re.match(r"core\s+\d+:\s+0x[0-9a-f]+ \([^)]+\)\s+(\S+)\s+(.*)", line)
    if not match:
        return 0.0

    opcode, operands = match.group(1), match.group(2)
    opcode_re = re.compile(pat["opcode"])
    rd_re = re.compile(pat.get("rd", r".*"))
    rs1_re = re.compile(pat.get("rs1", r".*"))

    score = 0.0
    if not opcode_re.fullmatch(opcode):
        return 0.0
    score += 0.5

    try:
        ops = [op.strip() for op in operands.split(',')]
        rd, rs1 = ops[0], ops[1] if len(ops) > 1 else ""
        if rd_re.fullmatch(rd):
            score += 0.25
        if rs1_re.fullmatch(rs1):
            score += 0.25
    except Exception:
        pass

    return score

def filter_fuzz_main_instructions(lines):
    in_fuzz = False
    filtered = []
    for line in lines:
        if ">>>>  csr_dump" in line:
            return filtered
        if ">>>>  _fuzz_main" in line:
            in_fuzz = True
            continue
        if in_fuzz:
            if ">>>>  _l" in line or re.match(r"core\s+\d+:\s+0x", line):
                filtered.append(line)
            elif ">>>>" in line and not line.startswith(">>>>  _l"):
                in_fuzz = False  # вышли из _fuzz_main секции
    return filtered

def match_pattern_soft(log_lines, pattern):
    filtered_lines = filter_fuzz_main_instructions(log_lines)
    matched_lines = []

    i = 0  # индекс в трассе
    j = 0  # индекс в паттерне
    scores = []
    instr_count = 0

    while i < len(filtered_lines):
        line = filtered_lines[i]
        score = score_line(line, pattern[j])
        if score > 0:
            scores.append(score)
            matched_lines.append(line)
            j += 1
            if j == len(pattern):
                break
        i += 1

    instr_count = len([line for line in filtered_lines if re.match(r"core\s+\d+:\s+0x", line)])

    base_score = sum(scores) / len(pattern)

    score = min(base_score, 1.0)

    if score >= 1.0:
        with open(STOP_FILE, "w") as f:
           f.write("stop") 

    return min(base_score, 1.0), instr_count

def main():
    pwd = os.getcwd()
    round_num = get_next_round()
    log_files = sorted(glob.glob(pwd + "/cov_metrics/artifacts/vectors/input_*.log"))
    top_fitness = 0.0
    top_fitness_file = ""
    rows = []
    for file in log_files:
        with open(file, 'r') as f:
            lines = f.readlines()
        fitness, instr_count = match_pattern_soft(lines, pattern)
        rows.append({
            "round": round_num,
            "file": os.path.splitext(file)[0] + ".S",
            "fitness": round(fitness, 4),
            "instructions": instr_count
        })
        file_path, file_name = os.path.split(file)
        if fitness > top_fitness:
            top_fitness = fitness
            top_fitness_file = os.path.splitext(file)[0] + ".S"

        #print(f"🧮 Vector", file_name, "Fitness:", fitness, "Instructions:", instr_count)

    df = pd.DataFrame(rows)

    cov_summary = pwd + "/cov_metrics/artifacts/coverage_summary.csv"
    if os.path.exists(cov_summary):
        df.to_csv(cov_summary, index=False, mode='a', header=False)
    else:
        df.to_csv(cov_summary, index=False)

    print(f"✅ Top coverage for round #{round_num} is {top_fitness} file {top_fitness_file}")

if __name__ == "__main__":
    main()
