
import os
import glob
from datetime import datetime
from src.utils import save_file
from mux import prepare_input
from src.utils import *
from launch_spike import *

num_inputs = 100
out = os.getcwd() + "/cov_metrics/artifacts/vectors/"
spike_path = os.getcwd() + "/cov_metrics/reg/spike"

def prepare_inputs():

    input_generator, preprocessor, isaHost = setup(num_inputs, out, "~/sig_dir/", '')
    print ("========== PREPARING INPUTS ==========")
    for i in range(50):
        prepare_input(input_generator, preprocessor, out + "input_" + str(i), 1)
        is_ok, _ = run_spike_with_log(spike_path, out + "input_" + str(i) + ".elf", out + "input_" + str(i) + ".log")
        if not is_ok:
            i = i - 1
    print ("========== INPUTS PREPARED ==========")

if __name__ == "__main__":
    prepare_inputs()


