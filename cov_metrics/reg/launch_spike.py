import subprocess

def run_spike_with_log(spike_path, elf_path, log_path, timeout_sec=5):
    try:

        result = subprocess.run(
            [spike_path, "-l", "--isa=rv64g", elf_path],
            stdout=subprocess.PIPE,
            stderr=subprocess.STDOUT,
            timeout=timeout_sec,
            text=True
        )
        
        with open(log_path, "w+") as log_file:
            log_file.write(result.stdout)

        return True, result.returncode

    except subprocess.TimeoutExpired as e:
        with open(log_path, "w+") as log_file:
            log_file.write(f"[TIMEOUT after {timeout_sec} seconds]\n")
        return False, -1 
    
