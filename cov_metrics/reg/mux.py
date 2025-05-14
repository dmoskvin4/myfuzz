import time
import random

from src.utils import *

random.seed(time.time())

def prepare_input(input_generator, preprocessor, file_path, is_init=0, cov_log=None):

    (input_generator, preprocessor, isaHost) = setup('', '', '')

    sim_inputs = []
    datas = []
    while True:
        (sim_input, data) = input_generator.get(False)
        is_ok, symbols, asm = preprocessor.process(file_path, sim_input, data, False)
        if is_ok:
            sim_inputs.append(sim_input)
            datas.append(data)
            print(f"✅ Vector: ", file_path, " created and compiled")
            return asm
        else:
            print(f"❌ Vector: ", file_path, " compiled with error")
    

#def prepare_inputs(num_inputs, toplevel, coverage_map=' ', out='~/output', is_init=0, cov_log=None):
#    idxs = [i for i in range(num_inputs)]
#    i = 0
#    #with futures.ProcessPoolExecutor(max_workers=1) as executor:
#    #    pstart_t = time.time()
#    while i != num_inputs:
#            #for isa_input, symbols in executor.map(preprocessor.process, idxs, sim_inputs, datas, assert_intrs):
#        print("---- prcessing", )
#        is_ok, isa_input, symbols = preprocessor.process(i, out, sim_inputs[i], datas[i], assert_intrs[i])
#        if is_ok:
#            i = i + 1
#        else:
#            (sim_input, data) = input_generator.get(False)
#            sim_inputs[i] =  sim_input
#            datas[i] = data
#            continue         
#        print("---- prcessed", i)
#        isa_inputs.append(isa_input)
#                #rtl_inputs.append(rtl_input)
#        symbolss.append(symbols)
#            #pend_t = time.time()

#    # end of process siminput into rtl/isa inputs ====================================================================


#    # begin of isa simulation ========================================================================================
#    # 
#    # if isa fails, create a new siminput

#    isa_rets = [None for _ in range(num_inputs) ]

#    isastart_t = time.time()
#    for i in range(num_inputs):
#        if isa_inputs[i]:
#            isa_ret = run_isa_test(isaHost, i, isa_inputs[i], stop, "/home/mda/output")

#            isa_rets.append(isa_ret)
#            # print("run isa")
#            # TODO: check ERR?
#            #while isa_ret == proc_state.ERR_ISA_TIMEOUT or isa_ret == proc_state.ERR_ISA_ASSERT: 
#            #    # print("isa error, find another one")
#            #    (sim_input, data) = input_generator.get(assert_intr)
#            #    sim_inputs[i] = sim_input
#            #    datas[i] = data
#  fd = open(asm_path, 'w+'):
        
#        fd.writelines(lines)
#        fd.close()

#        cc_args = self.cc_args + self.extra_args + [ self.asm_name, '-o', self.elf_name ]
#        cc_ret = -1

#        while True:
#            cc_ret = subprocess.call(cc_args)
#            if cc_ret != -9: break
#        end_t = time.time()#            #    (is_ok, isa_input, symbols) = preprocessor.process(i, out, sim_inputs[i], datas[i], assert_intr)

#            #    isa_inputs[i] = isa_input
#            #    symbolss[i] = symbols
#            #    isa_ret = run_isa_test(isaHost, i, isa_inputs[i], stop, out)
#            #isa_rets[i] = isa_ret
#    isaend_t = time.time()

#    # end of isa simulation ===========================================================================================

#   rstart_t = time.time()
#    #rtl_rets = rtlHost.run_test(rtl_inputs, assert_intr)
#    rend_t = time.time()
#    # print ("=============rtl time " + str(rend_t - rstart_t))
