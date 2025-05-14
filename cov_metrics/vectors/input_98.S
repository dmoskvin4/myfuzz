# Assembly file template for fuzzing

#*********************************************************************
# test_template.S
#---------------------------------------------------------------------

#include "riscv_test.h"
#include "test_macros.h"
#include "fuzz_test.h"

#define TESTEND gp

RVTEST_RV64UF

// RVTEST_CODE_BEGIN
        .section .text.init;
        .align  6;
        .weak stvec_handler;
        .weak mtvec_handler;
        .global _start;
_start:
        /* reset vector */
INIT_XREGS
        j reset_vector;
        .align;
init_freg:
INIT_FREGS
        ret
        .align;
trap_stvec:
        clear_sie;
        ecall
trap_mtvec: 
        clear_mie;
  DUMP_REGS

  write_tohost:
        li TESTEND, 1
        sw TESTEND, tohost, t5;
  _test_end:
        j _test_end;
reset_vector:
        csrwi mstatus, 0;
        RISCV_MULTICORE_DISABLE;
        DELEGATE_NO_TRAPS;
        INIT_SATP;
        INIT_PMP;
        la t0, trap_mtvec;
        csrw mtvec, t0;
        li TESTEND, 0;
        CHECK_XLEN;
        la t0, trap_stvec;
        csrw stvec, t0;
        li t0, (1 << CAUSE_LOAD_PAGE_FAULT) | \
                (1 << CAUSE_STORE_PAGE_FAULT) | \
                (1 << CAUSE_FETCH_PAGE_FAULT) | \
                (1 << CAUSE_MISALIGNED_FETCH) | \
                (1 << CAUSE_USER_ECALL) | \
                (1 << CAUSE_BREAKPOINT);
        csrs medeleg, t0;
  1:    li a0, (MSTATUS_FS & (MSTATUS_FS >> 0)) | \
                (MSTATUS_MPP & (MSTATUS_MPP >> 0));
        csrs mstatus, a0;
        init_mie;
        csrwi fcsr, 0;
        call init_freg
        csrw minstret,zero
        csrr a0, mhartid;
 _fuzz_prefix:
_p0:    csrrsi x10, sip, 8                        ;
_p1:    csrrwi x13, frm, 8                        ;
_p2:    xor x12, x12, x12                         ;
        addi x10, zero, 3                         ;
        slli x10, x10, 11                         ;
        add x12, x12, x10                         ;
        addi x11, zero, 1                         ;
        slli x11, x11, 0                          ;
        add x12, x12, x11                         ;
        csrrc x14, satp, x12                      ;
_p3:;
        /* Fuzz prefix */
        /**/
_end_prefix:
        la t0, main;
        csrw mepc, t0;
        addi t0, zero, 0;
        mret;
  1:
      
      .align 6;

main:
_fuzz_main:
_l0:    addi x0, x1, 0                    ;
_l1:    fle.s x4, f2, f7                    ;
_l2:    addi x14, x0, -92                    ;
_l3:    fsqrt.s f12, f6, rne                    ;
_l4:    xor x18, x18, x18                    ;
      addi x22, zero, 1         ;
      slli x22, x22, 1         ;
      add x18, x18, x22         ;
      csrrw x29, scause, x18         ;
_l5:    srli x7, x0, 34                    ;
_l6:    la x13, d_5_6                    ;
      sw x24, 8(x13)         ;
_l7:    fle.s x27, f7, f3                    ;
_l8:    addi x0, x1, 0                    ;
_l9:    la x20, d_2_20                    ;
      lhu x1, 26(x20)         ;
_l10:    la x28, d_0_27                    ;
      addi x28, x28, -0         ;
      amomax.w x14, x2, (x28)         ;
_l11:    sraiw x21, x5, 3                    ;
_l12:    fmin.s f17, f24, f4                    ;
_l13:    fsqrt.s f24, f12, rne                    ;
_l14:    la x11, d_4_19                    ;
      ld x22, 8(x11)         ;
_l15:    la x25, d_4_22                    ;
      addi x25, x25, 0         ;
      lui x5, 0xffe00         ;
      xor x25, x25, x5         ;
      amoor.d x5, x5, (x25)         ;
_l16:    addi x0, x1, 0                    ;
_l17:    fmin.s f24, f29, f3                    ;
_l18:    la x24, d_1_10                    ;
      sd x14, -8(x24)         ;
_l19:    la x12, d_5_21                    ;
      addi x12, x12, -8         ;
      lui x21, 0xffe00         ;
      xor x12, x12, x21         ;
      sc.d x9, x12, (x12)         ;
_l20:    la x23, d_1_10                    ;
      addi x23, x23, -0         ;
      lr.d x11, (x23)         ;
_l21:    srlw x30, x17, x10                    ;
_l22:    ori x29, x2, 1476                    ;
_l23:    la x11, d_0_14                    ;
      addi x11, x11, 8         ;
      lr.d x11, (x11)         ;
_l24:    fsqrt.s f25, f19, rne                    ;
_l25:    slti x6, x8, -2047                    ;
_l26:    la x21, d_5_25                    ;
      addi x21, x21, -16         ;
      lui x22, 0xffe00         ;
      xor x21, x21, x22         ;
      amomin.d x18, x22, (x21)         ;
_l27:    la x5, d_4_3                    ;
      addi x5, x5, 28         ;
      amoand.w x17, x8, (x5)         ;
_l28:    la x25, d_5_3                    ;
      addi x25, x25, 20         ;
      amoand.w x17, x1, (x25)         ;
_l29:    la x25, d_2_22                    ;
      lhu x16, -12(x25)         ;
_l30:    la x16, d_4_14                    ;
      addi x16, x16, -0         ;
      amominu.d x30, x13, (x16)         ;
_l31:    la x2, d_0_13                    ;
      addi x2, x2, -0         ;
      amoxor.w x14, x11, (x2)         ;
_l32:    la x11, d_3_12                    ;
      sb x10, -16(x11)         ;
_l33:    xor x30, x30, x30                    ;
      csrrs x16, pmpcfg0, x30         ;
_l34:    addi x9, x24, 597                    ;
_l35:    la x17, d_1_12                    ;
      addi x17, x17, 4         ;
      lr.w x16, (x17)         ;
_l36:    la x19, d_2_16                    ;
      addi x19, x19, 20         ;
      amomaxu.w x3, x22, (x19)         ;
_l37:    fmsub.s f17, f2, f14, f21, rne                    ;
_l38:    la x9, d_3_24                    ;
      addi x9, x9, -8         ;
      amomin.d x5, x23, (x9)         ;
_l39:    lui x1, 952983                    ;
_l40:    la x5, d_2_15                    ;
      addi x5, x5, 8         ;
      amomax.d x24, x18, (x5)         ;
_l41:    srliw x2, x4, 31                    ;
_l42:    la x26, d_3_10                    ;
      addi x26, x26, 12         ;
      amomin.w x19, x26, (x26)         ;
_l43:    fcvt.lu.s x18, f15, rne                    ;
_l44:    fmv.x.w x24, f13                    ;
_l45:    fmul.s f24, f24, f23, rne                    ;
_l46:    la x27, d_3_9                    ;
      addi x27, x27, -12         ;
      lr.w x1, (x27)         ;
_l47:    la x27, d_5_8                    ;
      addi x27, x27, 4         ;
      amoadd.w x7, x4, (x27)         ;
_l48:    fmul.s f12, f6, f27, rne                    ;
_l49:    uret                    ;
_l50:    la x2, _l29                    ;
      lui x18, 0xffe00         ;
      xor x2, x2, x18         ;
      lh x5, -10(x2)         ;
_l51:    fclass.s x14, f17                    ;
_l52:    uret                    ;
_l53:    la x23, d_3_14                    ;
      addi x23, x23, 8         ;
      amomin.d x5, x7, (x23)         ;
_l54:    la x25, d_0_1                    ;
      addi x25, x25, 8         ;
      lui x23, 0xffe00         ;
      xor x25, x25, x23         ;
      amoxor.d x23, x23, (x25)         ;
_l55:    la x2, d_0_6                    ;
      addi x2, x2, -16         ;
      sc.w x19, x13, (x2)         ;
_l56:    la x11, d_5_10                    ;
      sw x14, 24(x11)         ;
_l57:    fcvt.s.l f15, x19, rne                    ;
_l58:    la x21, d_5_22                    ;
      sd x30, 16(x21)         ;
_l59:    fcvt.wu.s x1, f19, rne                    ;
_l60:    la x22, d_2_16                    ;
      lui x4, 0xffe00         ;
      xor x22, x22, x4         ;
      lhu x16, 10(x22)         ;
_l61:    la x27, d_4_14                    ;
      addi x27, x27, 4         ;
      lui x3, 0xffe00         ;
      xor x27, x27, x3         ;
      amoswap.w x14, x3, (x27)         ;
_l62:    sret                    ;
_l63:    sret                    ;
_l64:    la x2, d_1_24                    ;
      srai x2, x2, 1         ;
      csrrw x23, pmpaddr7, x2         ;
_l65:    la x15, d_1_21                    ;
      lui x4, 0xffe00         ;
      xor x15, x15, x4         ;
      lhu x23, -22(x15)         ;
_l66:    la x2, d_1_7                    ;
      addi x2, x2, 24         ;
      lui x11, 0xffe00         ;
      xor x2, x2, x11         ;
      sc.w x14, x11, (x2)         ;
_l67:    fclass.s x5, f17                    ;
_l68:    fle.s x25, f13, f27                    ;
_l69:    fmv.w.x f8, x27                    ;
_l70:    la x18, d_5_11                    ;
      fsw f12, 28(x18)         ;
_l71:    la x24, d_2_7                    ;
      addi x24, x24, 0         ;
      amominu.d x16, x1, (x24)         ;
_l72:    feq.s x19, f26, f1                    ;
_l73:    la x25, d_5_15                    ;
      lhu x13, 22(x25)         ;
_l74:    uret                    ;
_l75:    la x7, d_0_9                    ;
      sw x26, -0(x7)         ;
_l76:    la x9, d_1_11                    ;
      addi x9, x9, 16         ;
      amominu.d x3, x25, (x9)         ;
_l77:    addiw x4, x28, 23                    ;
_l78:    la x29, d_1_25                    ;
      addi x29, x29, 16         ;
      lui x22, 0xffe00         ;
      xor x29, x29, x22         ;
      amoadd.d x22, x22, (x29)         ;
_l79:    fclass.s x13, f17                    ;
_l80:    xor x5, x5, x5                    ;
      addi x6, zero, 3         ;
      slli x6, x6, 2         ;
      add x5, x5, x6         ;
      addi x2, zero, 1         ;
      slli x2, x2, 12         ;
      add x5, x5, x2         ;
      csrrw x28, sscratch, x5         ;
_l81:    auipc x12, 716443                    ;
_l82:    subw x29, x5, x4                    ;
_l83:    fsgnjx.s f9, f7, f27                    ;
_l84:    fmsub.s f0, f1, f28, f28, rne                    ;
_l85:    la x1, d_0_18                    ;
      addi x1, x1, -20         ;
      amoxor.w x5, x10, (x1)         ;
_l86:    uret                    ;
_l87:    csrrwi x29, stval, 26                    ;
_l88:    fmul.s f12, f0, f20, rne                    ;
_l89:    uret                    ;
_l90:    la x2, d_0_16                    ;
      fsw f10, -0(x2)         ;
_l91:    la x25, d_5_22                    ;
      addi x25, x25, 8         ;
      amoand.d x25, x2, (x25)         ;
_l92:    slliw x17, x23, 13                    ;
_l93:    fcvt.l.s x3, f5, rne                    ;
_l94:    fnmadd.s f16, f12, f7, f13, rne                    ;
_l95:    srli x29, x26, 7                    ;
_l96:    srli x7, x22, 0                    ;
_l97:    slti x18, x18, -2047                    ;
_l98:    la x8, d_4_12                    ;
      addi x8, x8, 16         ;
      lui x30, 0xffe00         ;
      xor x8, x8, x30         ;
      lr.d x4, (x8)         ;
_l99:    la x12, d_3_15                    ;
      addi x12, x12, 24         ;
      amomin.d x30, x2, (x12)         ;
_l100:    la x15, d_1_13                    ;
      lbu x28, -19(x15)         ;
      addi x4, x4, -8         ;
      amomin.d x16, x19, (x4)         ;
      addi x6, x6, -16         ;
      amoadd.d x3, x26, (x6)         ;
        /* Fuzz main */
        /**/
// RVTEST_CODE_END
        ecall
        unimp
_end_main:
        unimp
        unimp
        unimp
        unimp
        unimp
        unimp
        unimp
        unimp
        
    .data

RVTEST_DATA_BEGIN

        .align 8
xreg_output_data:
reg_x0_output:  .dword 0x0000000000000000
reg_x1_output:  .dword 0x0000000000000000
reg_x2_output:  .dword 0x0000000000000000
reg_x3_output:  .dword 0x0000000000000000
reg_x4_output:  .dword 0x0000000000000000
reg_x5_output:  .dword 0x0000000000000000
reg_x6_output:  .dword 0x0000000000000000
reg_x7_output:  .dword 0x0000000000000000
reg_x8_output:  .dword 0x0000000000000000
reg_x9_output:  .dword 0x0000000000000000
reg_x10_output: .dword 0x0000000000000000
reg_x11_output: .dword 0x0000000000000000
reg_x12_output: .dword 0x0000000000000000
reg_x13_output: .dword 0x0000000000000000
reg_x14_output: .dword 0x0000000000000000
reg_x15_output: .dword 0x0000000000000000
reg_x16_output: .dword 0x0000000000000000
reg_x17_output: .dword 0x0000000000000000
reg_x18_output: .dword 0x0000000000000000
reg_x19_output: .dword 0x0000000000000000
reg_x20_output: .dword 0x0000000000000000
reg_x21_output: .dword 0x0000000000000000
reg_x22_output: .dword 0x0000000000000000
reg_x23_output: .dword 0x0000000000000000
reg_x24_output: .dword 0x0000000000000000
reg_x25_output: .dword 0x0000000000000000
reg_x26_output: .dword 0x0000000000000000
reg_x27_output: .dword 0x0000000000000000
reg_x28_output: .dword 0x0000000000000000
reg_x29_output: .dword 0x0000000000000000
reg_x30_output: .dword 0x0000000000000000
reg_x31_output: .dword 0x0000000000000000

        .align 8
freg_output_data:
reg_f0_output:  .dword 0x0000000000000000
reg_f1_output:  .dword 0x0000000000000000
reg_f2_output:  .dword 0x0000000000000000
reg_f3_output:  .dword 0x0000000000000000
reg_f4_output:  .dword 0x0000000000000000
reg_f5_output:  .dword 0x0000000000000000
reg_f6_output:  .dword 0x0000000000000000
reg_f7_output:  .dword 0x0000000000000000
reg_f8_output:  .dword 0x0000000000000000
reg_f9_output:  .dword 0x0000000000000000
reg_f10_output: .dword 0x0000000000000000
reg_f11_output: .dword 0x0000000000000000
reg_f12_output: .dword 0x0000000000000000
reg_f13_output: .dword 0x0000000000000000
reg_f14_output: .dword 0x0000000000000000
reg_f15_output: .dword 0x0000000000000000
reg_f16_output: .dword 0x0000000000000000
reg_f17_output: .dword 0x0000000000000000
reg_f18_output: .dword 0x0000000000000000
reg_f19_output: .dword 0x0000000000000000
reg_f20_output: .dword 0x0000000000000000
reg_f21_output: .dword 0x0000000000000000
reg_f22_output: .dword 0x0000000000000000
reg_f23_output: .dword 0x0000000000000000
reg_f24_output: .dword 0x0000000000000000
reg_f25_output: .dword 0x0000000000000000
reg_f26_output: .dword 0x0000000000000000
reg_f27_output: .dword 0x0000000000000000
reg_f28_output: .dword 0x0000000000000000
reg_f29_output: .dword 0x0000000000000000
reg_f30_output: .dword 0x0000000000000000
reg_f31_output: .dword 0x0000000000000000

        .align 8
csr_output_data:
ustatus_output:        .dword 0x0000000000000000                   
uie_output:            .dword 0x0000000000000000               
utvec_output:          .dword 0x0000000000000000                 
uscratch_output:       .dword 0x0000000000000000                    
uepc_output:           .dword 0x0000000000000000                
ucause_output:         .dword 0x0000000000000000                  
utval_output:          .dword 0x0000000000000000                 
uip_output:            .dword 0x0000000000000000               
fflags_output:         .dword 0x0000000000000000                 
frm_output:            .dword 0x0000000000000000               
fcsr_output:           .dword 0x0000000000000000                
sstatus_output:        .dword 0x0000000000000000                   
sedeleg_output:        .dword 0x0000000000000000                   
sideleg_output:        .dword 0x0000000000000000                   
sie_output:            .dword 0x0000000000000000               
stvec_output:          .dword 0x0000000000000000                 
scounteren_output:     .dword 0x0000000000000000                      
sscratch_output:       .dword 0x0000000000000000                    
sepc_output:           .dword 0x0000000000000000                
scause_output:         .dword 0x0000000000000000                  
stval_output:          .dword 0x0000000000000000                 
sip_output:            .dword 0x0000000000000000               
satp_output:           .dword 0x0000000000000000                
mhartid_output:        .dword 0x0000000000000000                   
mstatus_output:        .dword 0x0000000000000000                   
medeleg_output:        .dword 0x0000000000000000                   
mideleg_output:        .dword 0x0000000000000000                   
mie_output:            .dword 0x0000000000000000               
mtvec_output:          .dword 0x0000000000000000                 
mcounteren_output:     .dword 0x0000000000000000                      
mscratch_output:       .dword 0x0000000000000000                    
mepc_output:           .dword 0x0000000000000000                
mcause_output:         .dword 0x0000000000000000                  
mtval_output:          .dword 0x0000000000000000                 
mip_output:            .dword 0x0000000000000000               
pmpcfg0_output:        .dword 0x0000000000000000                   
pmpcfg1_output:        .dword 0x0000000000000000                   
pmpcfg2_output:        .dword 0x0000000000000000                   
pmpcfg3_output:        .dword 0x0000000000000000                   
pmpaddr0_output:       .dword 0x0000000000000000                    
pmpaddr1_output:       .dword 0x0000000000000000                    
pmpaddr2_output:       .dword 0x0000000000000000                    
pmpaddr3_output:       .dword 0x0000000000000000                    
pmpaddr4_output:       .dword 0x0000000000000000                    
pmpaddr5_output:       .dword 0x0000000000000000                    
pmpaddr6_output:       .dword 0x0000000000000000                    
pmpaddr7_output:       .dword 0x0000000000000000                    
pmpaddr8_output:       .dword 0x0000000000000000                    
pmpaddr9_output:       .dword 0x0000000000000000                    
pmpaddr10_output:      .dword 0x0000000000000000                     
pmpaddr11_output:      .dword 0x0000000000000000                     
pmpaddr12_output:      .dword 0x0000000000000000                     
pmpaddr13_output:      .dword 0x0000000000000000                     
pmpaddr14_output:      .dword 0x0000000000000000                     
pmpaddr15_output:      .dword 0x0000000000000000                     
mcycle_output:         .dword 0x0000000000000000                         
minstret_output:       .dword 0x0000000000000000                    
mcycleh_output:        .dword 0x0000000000000000                   
minstreth_output:      .dword 0x0000000000000000                     

RVTEST_DATA_END  

PT_BASES

    .section .data.random0;
    .align  8;

_random_data0:
                .dword 0x14b55d8b45c6845c, 0xf072a8107c16882c
                .dword 0x02118b80ccc264cf, 0x8cea537954969a77
d_0_0:          .dword 0xfc4d06247a0cf26c, 0xde8d96351e39cc23
d_0_1:          .dword 0x75f9956ca813c535, 0x6eeac161397ceb5e
d_0_2:          .dword 0x2335c4cbb0d35e40, 0x36014734d44fe98c
d_0_3:          .dword 0xca9a606cda3afb9e, 0xa4fcd26ceaf701a7
d_0_4:          .dword 0x45c0b313646af2d6, 0x86dc4907b86d518b
d_0_5:          .dword 0xb91f643105f0d392, 0xc4cd06a3485e0dcf
d_0_6:          .dword 0x3057dd2a2e6866fb, 0x4799fd8f0debdcc5
d_0_7:          .dword 0x827ce0d3047775a6, 0xd3aa031fefe75fc5
d_0_8:          .dword 0x5f3373f69fd46b31, 0x262ca5c6a2c3dcf1
d_0_9:          .dword 0x496df43143d1c9bc, 0xd82d12bd8e303efb
d_0_10:         .dword 0xfdfdaa322f2758df, 0xc071d4b086f7edb4
d_0_11:         .dword 0x00efe23b6c2900c7, 0x765e6c565a85e09c
d_0_12:         .dword 0x00fb0df53f4266b4, 0x4268b674994a5f8d
d_0_13:         .dword 0x69263ca8b50bdf19, 0xd024fbf8391cd067
d_0_14:         .dword 0x20748066ea356596, 0x4870ed36ab388963
d_0_15:         .dword 0x57a73e328f191edf, 0x05be91baa527a339
d_0_16:         .dword 0x92398cc03e32e236, 0xf4e2173b900cf87e
d_0_17:         .dword 0xf02f9393e805b6aa, 0xdf3a1004eb1d68e8
d_0_18:         .dword 0x46401d96c39f6acc, 0xc33b50f8e464582b
d_0_19:         .dword 0xa0b7ec67b5dcdb04, 0x4e95103358d9af1b
d_0_20:         .dword 0x46e3caa3bfa97223, 0x3555b39949bca69c
d_0_21:         .dword 0xcad0474035dd8c85, 0x43bdb28340294572
d_0_22:         .dword 0xde9444eff2ed059d, 0xabf9bdb9111a9346
d_0_23:         .dword 0x80058af6d231fa7d, 0x7bffd66411204c14
d_0_24:         .dword 0x53fddf4a165c250a, 0xb5e0a99874485032
d_0_25:         .dword 0x7ec0df58a9cdf0bf, 0xac23dbfc9d9e7bfc
d_0_26:         .dword 0xda310648cda0c691, 0x8c827b95be3c6111
d_0_27:         .dword 0xc5f0683086523fd9, 0x0606761c1a576664
                .dword 0x02efa0da266a592d, 0xb83a27b60c982c51
                .dword 0xbaaa79262b50edca, 0xde09792a06c2304f
        /* Random data */
_end_data0:
                 

    .section .data.random1;
    .align  8;

_random_data1:
                .dword 0x0a42e88d91367ecb, 0x23d72c323d4c1361
                .dword 0x608dbe4b567bfa58, 0x722dc8c3e89c1a90
d_1_0:          .dword 0xb194efaad750c1c6, 0xace22df68b040e61
d_1_1:          .dword 0x08e2d5ac357217c5, 0xc73757beabad0337
d_1_2:          .dword 0xffea6abfba7cfe81, 0x7a6f082610ee4b27
d_1_3:          .dword 0x73d7db39f8b3314f, 0x0a81bcaaa43004d5
d_1_4:          .dword 0x7d08fa2ebf5f25bf, 0xc0fddd128244655a
d_1_5:          .dword 0xbdf94baebc6a4bff, 0x0dbde80ae6d279de
d_1_6:          .dword 0x242d0ddb37e2bf80, 0xf7072d8f6136bed8
d_1_7:          .dword 0x25ddd60492247493, 0xfc623d6c8560b3fd
d_1_8:          .dword 0x349389441c21c5a1, 0x5349328650e0215f
d_1_9:          .dword 0xa4408ea5cf065498, 0x5c1782f4ef505961
d_1_10:         .dword 0x8bff20c30356e1ed, 0x6cd7fe1a0362a9f8
d_1_11:         .dword 0x218cd93fb4ece801, 0x9a06e5b6a260b4bb
d_1_12:         .dword 0x4bcdc52d89f70c5b, 0xfb6056d87eaa3d55
d_1_13:         .dword 0x2d810e398036dc13, 0x8e20b77ded8a32b2
d_1_14:         .dword 0xd16bac784ade1944, 0x5b1923ddef605c11
d_1_15:         .dword 0x25dd1136935923ff, 0x7f350fa0022de372
d_1_16:         .dword 0xbe3e1e32e801669a, 0xbeecc94da86dc906
d_1_17:         .dword 0x0f0a4862fb22fafb, 0xdc9df1c08379770b
d_1_18:         .dword 0x2fcaf7eaa509265d, 0x0ae543f53ae48df7
d_1_19:         .dword 0x67fda1f1abfd7617, 0x48ee73da318a3445
d_1_20:         .dword 0x78b39b64885ccab7, 0xa76796930ec3f3ea
d_1_21:         .dword 0xb341042f5fbe1b1f, 0xb0e5e69429a57fba
d_1_22:         .dword 0xd56934d3d8d80cf2, 0x829bc6a66114fe9f
d_1_23:         .dword 0x39da849841ecd725, 0x4465c96c81ad3155
d_1_24:         .dword 0xbe748c2830e5db51, 0x10c1c850f246ef69
d_1_25:         .dword 0xd1c2eb7903cef88e, 0x23a1c68050edfdc5
d_1_26:         .dword 0xe120c492bb1e78d6, 0xdea9b72ed2ea6bf4
d_1_27:         .dword 0xfd7c35ab7f98fba3, 0x98cc37624e27af60
                .dword 0xbf02f364730f2c69, 0xdaeba650b0f83a47
                .dword 0x67a673db4a9eedfd, 0xaa3ecf9effd56877
        /* Random data */
_end_data1:


    .section .data.random2;
    .align  8;

_random_data2:
                .dword 0x3fe1aba6195b32e0, 0xb3d023ef00eb93b8
                .dword 0x4c344972c9c24c45, 0xf69277c4fd49825a
d_2_0:          .dword 0x0cb436b32352aab1, 0x350dcd6f785b6775
d_2_1:          .dword 0xcab54b065a2356bc, 0x58ed29bd28f6d6d3
d_2_2:          .dword 0x37039d71cdd87743, 0xcf671c4ef3fc49fe
d_2_3:          .dword 0xf60a72863cc716cd, 0xa6f3bf72665ead25
d_2_4:          .dword 0xccf07cacdab00b23, 0x3608ef8ff86ac334
d_2_5:          .dword 0x443cd0944b0ce4db, 0x16a5fd0e08e7646c
d_2_6:          .dword 0xc802053885711df4, 0xd510b98ec3d98641
d_2_7:          .dword 0xcd69d816a3eb4b79, 0xf85a090eba8d48c1
d_2_8:          .dword 0x731c948b7446693f, 0x311aca8152ed40ff
d_2_9:          .dword 0xcd94ea614b0be082, 0x67076aa9e1fa8fbc
d_2_10:         .dword 0xa69b2ca0f96b0bca, 0x2cdb4c9de7a6d906
d_2_11:         .dword 0xbc67a910dcfea91c, 0xc88caf63d2639c43
d_2_12:         .dword 0xa77ed78513f8a622, 0xa288f4a44fffbc71
d_2_13:         .dword 0x9b896239c9db9733, 0x76221fa86618e5ea
d_2_14:         .dword 0x85ea12227c4f7a79, 0x0d7d32554d73c0c6
d_2_15:         .dword 0x88615953e1a69f48, 0x6c214a3587c0477c
d_2_16:         .dword 0xe8c8ec2ffe817c06, 0x1686ea75e2cae9ef
d_2_17:         .dword 0x886a534a699c6ae3, 0x569070289cb783ef
d_2_18:         .dword 0xd12dc6265501d9d7, 0x25c403fc5f55fb14
d_2_19:         .dword 0x1887a3d462eb4b88, 0xa83a20a37b2ec2ed
d_2_20:         .dword 0xf599d7e2f907d024, 0x59a8f0cde195bf24
d_2_21:         .dword 0x9e42fbeb47dcefbd, 0xdb03d1b143adea8c
d_2_22:         .dword 0x7b17bbd08a50f4a4, 0x2fadf274f48f02bf
d_2_23:         .dword 0x6db7493f9cd5c568, 0x0a3298872fdac2e0
d_2_24:         .dword 0xa619ec092e56364a, 0x9a6b6dd7c6e06a49
d_2_25:         .dword 0xd3b7591a529d495d, 0x07e4a1624c20bc23
d_2_26:         .dword 0x8d86f8cea99cc02d, 0x8800f46720f7ba25
d_2_27:         .dword 0x52079a672357242e, 0x205264463a383357
                .dword 0x5d62e602d38606c2, 0xd6afac7d63de3029
                .dword 0xa47a62a06daa24e1, 0x812fa645bf4e69f6
         /* Random data */
_end_data2:
                

    .section .data.random3;
    .align  8;

_random_data3:
                .dword 0x03730585b821942d, 0x25209e5123be35ca
                .dword 0x638df1b353d18855, 0x8d55b04c9c656069
d_3_0:          .dword 0xf2274ace956037a7, 0x7cb55103d8c81a2a
d_3_1:          .dword 0x97e3cc7163cc2d7a, 0x38346e302ea5ed4b
d_3_2:          .dword 0x74d779fc81a8a228, 0x6c4413115496e982
d_3_3:          .dword 0x7cd5ab96d46590f9, 0xfb12e07b3e05e5b9
d_3_4:          .dword 0x6cd94cb6468d0a88, 0xaa9e7d668a138ac6
d_3_5:          .dword 0xaced60728933d9af, 0xa5b324694c8ddf14
d_3_6:          .dword 0xf22e029272957745, 0x855c9c66e02600d2
d_3_7:          .dword 0xbb345601d0bcb6b7, 0x9bfd2d4c119687ad
d_3_8:          .dword 0x589f7eb14d8aa72d, 0xab507f4b2828b81a
d_3_9:          .dword 0x11b5a1f27de3efdd, 0x097e7b797c06bd6b
d_3_10:         .dword 0x76694e454338218f, 0xa84e3b89b8c8bdd5
d_3_11:         .dword 0x1e55cd296f73c857, 0xcfd6b505fcefef35
d_3_12:         .dword 0xcae694d6e3b51753, 0xa1d58d889d6645a9
d_3_13:         .dword 0xce66dfb6d7514c4b, 0xf30d3434323065c5
d_3_14:         .dword 0xf3e56534b93f99f8, 0xfd9ad4f517041091
d_3_15:         .dword 0x5ff8e969292d0de3, 0xdedc84df25e17757
d_3_16:         .dword 0xa44eff2b8ff7a49f, 0xe41ed43e132b04f6
d_3_17:         .dword 0x708202526e54badc, 0xb8870edac016542d
d_3_18:         .dword 0x8098c02e4b97583d, 0x002c673331f1c09f
d_3_19:         .dword 0x12715b583a10fca9, 0x44e6ff96e08a0511
d_3_20:         .dword 0x8bc3fb69a2fa8bac, 0xa2b79e42764e86cb
d_3_21:         .dword 0xec01921908cbea4c, 0xfb1c5434e6ea13db
d_3_22:         .dword 0x02467f715a460c77, 0x12fd0913467f992c
d_3_23:         .dword 0x24edf1a11e7133d7, 0x4178d22b127f64dc
d_3_24:         .dword 0x05d16a63bc2b4d90, 0x0cb01ea534126480
d_3_25:         .dword 0x793259e2ea86fe5f, 0x52f0b4e20ece7fc1
d_3_26:         .dword 0xb5ca3530aa14863f, 0x1e4519187ec91e9e
d_3_27:         .dword 0xd1d3d13cbc1c591d, 0x575f573f512270d8
                .dword 0xbd58faad82969c83, 0x381ddaa5e3b2095c
                .dword 0xfc7095943de40b3a, 0xc7c881793a657088
        /* Random data */
_end_data3:


    .section .data.random4;
    .align  8;

_random_data4:
                .dword 0x521ebf3876e0118d, 0x8afec99aab57ff6d
                .dword 0x137d560196be86f2, 0x316d2eaa24fc92d9
d_4_0:          .dword 0x81ad6a06f96e84d2, 0xcde163277f251e90
d_4_1:          .dword 0x35672788095e6af4, 0xf9e066df19075875
d_4_2:          .dword 0x1ff59265e0ae63bf, 0x75b8b352091b1524
d_4_3:          .dword 0xe51107cb213819c4, 0xf6e0b251a828b200
d_4_4:          .dword 0x3935b7c8c2b83c02, 0x308c55f05648f465
d_4_5:          .dword 0xf6283ab1e97d7abf, 0x3447986572dc88f5
d_4_6:          .dword 0x1b62c174218d222c, 0x1e636768d7398d97
d_4_7:          .dword 0x3103027a1504aed8, 0x432e2dbe02d8e962
d_4_8:          .dword 0x51f5fed87c7ea0f0, 0x528878e8219722cc
d_4_9:          .dword 0x28db246edc8f0e3f, 0xdfaa9be17c6f6f88
d_4_10:         .dword 0x7b19961d672e3e01, 0xbfce086c727d6917
d_4_11:         .dword 0x8114d27478958294, 0x078364a5284de30f
d_4_12:         .dword 0x291b5b010b96b560, 0x036b01f0b0121214
d_4_13:         .dword 0x2d2a7f1cdad2c4e1, 0xef1500a2f1b3e8e7
d_4_14:         .dword 0x37c945fd0d8d39de, 0x9f53956d4f2340a8
d_4_15:         .dword 0xbac185c56f5e0951, 0x2861238955f1af77
d_4_16:         .dword 0xaa7b46aa360ffa77, 0x3cf10ef2901eb6c1
d_4_17:         .dword 0x9840a47db1207d72, 0x155f290e52f53055
d_4_18:         .dword 0x11a33db18368b06a, 0x1979621fa5886ab2
d_4_19:         .dword 0xfdb8f4e5e2351ba8, 0xf80a0baa4d06c418
d_4_20:         .dword 0xf20ccd5b327434a9, 0xdced8e945d56dc81
d_4_21:         .dword 0x6ef00630c5caf357, 0xda7a4e61f36f65a5
d_4_22:         .dword 0x7ada76bc56942829, 0xc8795760a35cbca9
d_4_23:         .dword 0xe41323083ecd0b0d, 0x233db9e5bafa61a9
d_4_24:         .dword 0x9dd78c9877746af2, 0x14c0028f0e16e4eb
d_4_25:         .dword 0xb186a084cf01bb9d, 0x0b945b48ea6b6a4c
d_4_26:         .dword 0x09b6a7372d71cb1a, 0x9c0a34d817de71fe
d_4_27:         .dword 0x36ed876cfedc7d1c, 0x197d359021e22e3c
                .dword 0x2c30db2cf696a563, 0x567f958f1753878b
                .dword 0x623ec96779ea8524, 0x3a37f3436c8dba1b
        /* Random data */
_end_data4:


    .section .data.random5;
    .align  8;

_random_data5:
                .dword 0x8fc13a73c1c83127, 0xbc26e9bfdc843947
                .dword 0x7d2353e5102af766, 0xe7c50b92c3274bd8
d_5_0:          .dword 0xa15f6062802d67fa, 0x07ab4d134171eaca
d_5_1:          .dword 0x0d13007277e1d016, 0x90fd1e6e1b83eb31
d_5_2:          .dword 0xc8bbdf6943ae1526, 0x89dd4d2c4fbea139
d_5_3:          .dword 0xfb51bf24df19a3b1, 0xbccfcb090ba35c36
d_5_4:          .dword 0xae794f018a9266e6, 0x1b119c6f8cb41ac0
d_5_5:          .dword 0x4a2aea6a366c1a34, 0x20192307433a23ba
d_5_6:          .dword 0x8f6135336c1ff442, 0x48906e1c2b42befb
d_5_7:          .dword 0x3ca6051b656858a1, 0xbd061358c0d236e2
d_5_8:          .dword 0x13f0202e3037ffca, 0x428afe852dce8467
d_5_9:          .dword 0x8f0885b25c08a698, 0x44c50d23d1ed5641
d_5_10:         .dword 0x1d50e9f590884f41, 0x0557a1af8b070b30
d_5_11:         .dword 0xdbdcab697d112b9d, 0x78545e7e23e9ed40
d_5_12:         .dword 0x460b5310c4a3cf9f, 0x5412ed93d45fae6a
d_5_13:         .dword 0x8db1680e95508e12, 0x6602aae74e3ee9db
d_5_14:         .dword 0xbdaf77f029597b18, 0xdbe0055857601d40
d_5_15:         .dword 0x871ed23c7208dd2b, 0x123b93d4b1091b21
d_5_16:         .dword 0x5312b128811efcc8, 0x113f5a4890134afb
d_5_17:         .dword 0x45f40f7d42b8a4a7, 0xb6e841c2fac6e9dc
d_5_18:         .dword 0x7665952a55a5f64c, 0xf0df2e3d181dd7dd
d_5_19:         .dword 0x1c4cd459b973aa21, 0xade4e679aa851cb7
d_5_20:         .dword 0xde97b126cb160035, 0xd69bcdabfe112ce7
d_5_21:         .dword 0x0dd0bf966ab9a466, 0x1d9224c1b1d94ad4
d_5_22:         .dword 0xf80bad5bb3ed4976, 0x2274f932e4c434b9
d_5_23:         .dword 0x13a21a94ab4bc723, 0xd2b7e931eb713db9
d_5_24:         .dword 0xb385d0f87cf723db, 0x2b886dcba1a432c5
d_5_25:         .dword 0x0174625e65724211, 0x10647d81fc98b3a8
d_5_26:         .dword 0xef3fac306548869f, 0x4dcff2811c214dd4
d_5_27:         .dword 0x876c0ed4a2855111, 0xca7068c6447dce52
                .dword 0x0d1b011b5ec96893, 0xd93a029a4de7de92
                .dword 0xcfc5a1e75b9ca4d2, 0xf77c880882c2ef76
         /* Random data */
_end_data5:
              
                 
