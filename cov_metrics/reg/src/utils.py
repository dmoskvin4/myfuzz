import os
import shutil
import psutil
import signal
from threading import Timer

from ISASim.host import rvISAhost

from src.preprocessor import rvPreProcessor
from src.input_generator import simInput, InputGenerator

ISA_TIME_LIMIT = 1



def debug_print(message, debug, highlight=False):
    if highlight:
        print('\x1b[1;31m' + message + '\x1b[1;m')
    elif debug:
        print(message)

def save_file(file_name, mode, line):
    fd = open(file_name, mode)
    fd.write(line)
    fd.close()

def save_mismatch(base, idx, out, sim_input: simInput, data: list): #, elf, asm, hexfile, mNum):
    sim_input.save(out + '/sim_input/id_{}.si'.format(idx), data)

    elf = base + '/input_{}.elf'.format(idx)
    asm = base + '/input_{}.S'.format(idx)
    hexfile = base + '/input_{}.hex'.format(idx)

    shutil.copy(elf, out + '/elf/id_{}.elf'.format(idx))
    shutil.copy(asm, out + '/asm/id_{}.S'.format(idx))
    shutil.copy(hexfile, out + '/hex/id_{}.hex'.format(idx))

def setup(num_inputs, out, isa_sigdir, coverage_map=' '):

    input_generator = InputGenerator(num_inputs)

    cc = 'riscv64-unknown-elf-gcc'
    elf2hex = 'riscv64-unknown-elf-elf2hex'
    preprocessor = rvPreProcessor(cc, elf2hex, out)

    spike = "" 
    spike_arg = []

    isaHost = rvISAhost(spike, spike_arg, isa_sigdir)
    return (input_generator, preprocessor, isaHost)
