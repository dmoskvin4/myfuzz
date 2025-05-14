import time
import os
import subprocess
import shutil
import random

#from ISASim.host import isaInput
from src.input_generator import simInput, templates, P_M, P_S, P_U, V_U

class rvPreProcessor():
    def __init__(self, cc, elf2hex, out_base, template='/home/mda/study/hse/genfuzz/GenFuzz/cov_metrics/reg/Template'):
        self.cc = cc
        self.elf2hex = "/usr/local/bin/riscv64-unknown-elf-elf2hex"
        self.template = template
        self.base = out_base

        self.er_num = 0
        self.cc_args = [ "/opt/riscv/bin/riscv64-unknown-elf-gcc", '-march=rv64g', '-mabi=lp64', '-static', '-mcmodel=medany',
                         '-fvisibility=hidden', '-nostdlib', '-nostartfiles',
                         '-I', '{}/include'.format(template),
                         '-T', '{}/include/link.ld'.format(template) ]

        self.elf2hex_args = [ "/usr/local/bin/riscv64-unknown-elf-elf2hex", '--bit-width', '64', '--input' ]

    def get_symbols(self, elf_name, sym_name):
        # symbol_file = self.base + '/.input.symbols'
        fd = open(sym_name, 'w')
        subprocess.call([ 'nm', elf_name], stdout=fd )
        fd.close()

        symbols = {}
        fd = open(sym_name, 'r')
        lines = fd.readlines()
        fd.close()

        for line in lines:
            symbol = line.split(' ')[2]
            addr = line.split(' ')[0]
            symbols[symbol[:-1]] = int(addr, 16)

        return symbols

    def write_isa_intr(self, isa_input, rtl_input, epc):
        fd = open(rtl_input.intrfile, 'r')
        tuples = [ line.split(':') for line in fd.readlines() ]
        fd.close()

        # TODO, assert interrupt multiple time
        assert len(tuples) == 1, 'Interrupt must be asserted only one time'
        val = int(tuples[0][1], 2)

        fd = open(isa_input.intrfile, 'w')
        fd.write('{:016x}:{:04b}\n'.format(epc, val))
        fd.close()

    def process(self, output, sim_input: simInput, data: list, intr: bool, num_data_sections=6):

        section_size = len(data) // num_data_sections

        assert data, 'Empty data can not be pDatagardenrocessed'
        assert (section_size & (section_size - 1)) == 0, \
            'Number of memory blocks should be power of 2'

        version = sim_input.get_template()
        test_template = self.template + '/rv64-{}.S'.format(templates[version])

        if intr: DINTR = ['-DINTERRUPT']
        else: DINTR = []
        extra_args = DINTR + [ '-I', '{}/include/p'.format(self.template) ]
        if version in [ V_U ]:
            rand = data[0] & 0xffffffff
            extra_args = DINTR + [ '-DENTROPY=0x{:08x}'.format(rand), '-std=gnu99', '-O2',
                                   '-I', '{}/include/v'.format(self.template),
                                   '{}/include/v/string.c'.format(self.template),
                                   '{}/include/v/vm.c'.format(self.template) ]

        asm_name = output + '.S'
        elf_name = output + '.elf'
        hex_name = output + '.hex'
        sym_name = output + '.symbols'
        isa_intr_name = output + '.isa.intr'
        cc_args_name = output + '.cc.args'

        prefix_insts = sim_input.get_prefix()
        insts = sim_input.get_insts()
        suffix_insts = sim_input.get_suffix()
        sim_input_ints = sim_input.ints.copy()

        ints = []
        for inst in insts[:-1]:
            INT = sim_input_ints.pop(0)
            if 'la' in inst:
                ints.append(INT)
                ints.append(0)
            else:
                ints.append(INT)
        
        fd = open(test_template, 'r')
        template_lines = fd.readlines()
        fd.close()
        
        assembly = []
        for line in template_lines:
            assembly.append(line)
            if '_fuzz_prefix:' in line:
                for inst in prefix_insts:
                    assembly.append(inst + ';\n')

            if '_fuzz_main:' in line:
                for inst in insts:
                    assembly.append(inst + ';\n')

            if '_fuzz_suffix:' in line:
                for inst in suffix_insts:
                    assembly.append(inst + ';\n')

            for n in range(num_data_sections):
                start = n * section_size
                end = start + section_size
                if '_random_data{}'.format(n) in line:
                    k = 0
                    for i in range(start, end, 2):
                        label = ''
                        if i > start + 2 and i < end - 4:
                            label = 'd_{}_{}:'.format(n, k)
                            k += 1

                        assembly.append('{:<16}.dword 0x{:016x}, 0x{:016x}\n'.\
                                        format(label, data[i], data[i+1]))

        fd = open(asm_name, 'w+')
        fd.writelines(assembly)
        fd.close()

        cc_args = self.cc_args + extra_args + [ asm_name, '-o', elf_name ]
        cc_ret = -1

        while True:
            cc_ret = subprocess.call(cc_args)
            if cc_ret != -9: break
        end_t = time.time()

        if cc_ret == 0:
            
            fd = open(cc_args_name, 'w+')
            fd.writelines(self.cc_args + extra_args)
            fd.close()
            
            subprocess.call(cc_args)
            elf2hex_args = self.elf2hex_args + [ elf_name, '--output', hex_name]
            subprocess.call(elf2hex_args)
            symbols= self.get_symbols(elf_name, sym_name)
            #isa_input = isaInput(elf_name, isa_intr_name)

        else:
            isa_input = None
            symbols = None

        return (cc_ret == 0, symbols, assembly)

    def compile(self, asm_path, lines):

        extra_args =  [ '-DENTROPY=0x{:08x}'.format(5), '-std=gnu99', '-O2',
                                   '-I', '{}/include/v'.format(self.template),
                                   '{}/include/v/string.c'.format(self.template),
                                   '{}/include/v/vm.c'.format(self.template) ]
    
        asm_name = asm_path + '.S'
        elf_name = asm_path + '.elf'

        fd = open(asm_name, 'w+')
        fd.writelines(lines)
        fd.close()
        
        cc_args = "/opt/riscv/bin/riscv64-unknown-elf-gcc -march=rv64g -mabi=lp64 -static -mcmodel=medany  -fvisibility=hidden -nostdlib -nostartfiles -I /home/mda/study/hse/genfuzz/GenFuzz/cov_metrics/reg/Template/include -T /home/mda/study/hse/genfuzz/GenFuzz/cov_metrics/reg/Template/include/link.ld -I /home/mda/study/hse/genfuzz/GenFuzz/cov_metrics/reg/Template/include/p " + \
              asm_name + " -o " + elf_name
        
        return subprocess.call(cc_args, shell=True)