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
_p0:    csrrsi x11, pmpaddr1, 13                  ;
_p1:    csrrsi x10, pmpaddr7, 27                  ;
_p2:    la x10, d_3_14                            ;
        srai x10, x10, 1                          ;
        csrrc x14, pmpaddr4, x10                  ;
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
_l1:    addi x0, x1, 0                    ;
_l2:    la x16, d_3_20                    ;
      addi x16, x16, -28         ;
      amomin.w x4, x6, (x16)         ;
_l3:    fle.s x14, f16, f27                    ;
_l4:    xor x28, x28, x28                    ;
      addi x12, zero, 1         ;
      slli x12, x12, 3         ;
      add x28, x28, x12         ;
      addi x21, zero, 1         ;
      slli x21, x21, 16         ;
      add x28, x28, x21         ;
      csrrc x5, sip, x28         ;
_l5:    addi x0, x1, 0                    ;
_l6:    fcvt.w.s x3, f21, rne                    ;
_l7:    la x30, d_1_24                    ;
      addi x30, x30, 0         ;
      amominu.d x6, x28, (x30)         ;
_l8:    srlw x10, x22, x21                    ;
_l9:    la x7, d_5_26                    ;
      addi x7, x7, -16         ;
      amominu.d x5, x21, (x7)         ;
_l10:    la x13, d_2_11                    ;
      addi x13, x13, 24         ;
      amoswap.w x29, x15, (x13)         ;
_l11:    andi x10, x24, -1668                    ;
_l12:    flt.s x29, f12, f28                    ;
_l13:    xor x11, x11, x11                    ;
      addi x16, zero, 1         ;
      slli x16, x16, 11         ;
      add x11, x11, x16         ;
      csrrs x9, sip, x11         ;
_l14:    lui x15, 1004835                    ;
_l15:    feq.s x6, f21, f19                    ;
_l16:    la x6, d_0_22                    ;
      addi x6, x6, 28         ;
      amoxor.w x19, x30, (x6)         ;
_l17:    la x24, d_1_21                    ;
      addi x24, x24, -16         ;
      amomax.w x10, x2, (x24)         ;
_l18:    la x6, d_0_19                    ;
      addi x6, x6, -16         ;
      lui x17, 0xffe00         ;
      xor x6, x6, x17         ;
      amoswap.d x29, x17, (x6)         ;
_l19:    sret                    ;
_l20:    la x18, d_2_25                    ;
      sb x12, 0(x18)         ;
_l21:    fadd.s f5, f22, f10, rne                    ;
_l22:    la x24, d_3_18                    ;
      addi x24, x24, 24         ;
      amoand.w x20, x1, (x24)         ;
_l23:    la x10, d_3_4                    ;
      lb x26, 16(x10)         ;
_l24:    la x10, d_1_1                    ;
      addi x10, x10, 16         ;
      amoxor.d x11, x6, (x10)         ;
_l25:    fcvt.wu.s x22, f0, rne                    ;
_l26:    slti x15, x0, 2044                    ;
_l27:    fcvt.s.w f11, x19, rne                    ;
_l28:    fcvt.lu.s x22, f5, rne                    ;
_l29:    la x1, d_1_17                    ;
      addi x1, x1, 24         ;
      sc.w x30, x16, (x1)         ;
_l30:    sraiw x20, x29, 31                    ;
_l31:    la x30, d_5_17                    ;
      lui x8, 0xffe00         ;
      xor x30, x30, x8         ;
      lb x14, -7(x30)         ;
_l32:    sllw x7, x29, x3                    ;
_l33:    fmsub.s f6, f4, f28, f16, rne                    ;
_l34:    fsqrt.s f24, f19, rne                    ;
_l35:    la x2, d_0_16                    ;
      lhu x28, -28(x2)         ;
_l36:    la x2, d_3_23                    ;
      addi x2, x2, 20         ;
      amoswap.w x2, x30, (x2)         ;
_l37:    fsgnj.s f5, f7, f14                    ;
_l38:    la x1, d_3_13                    ;
      addi x1, x1, 16         ;
      sc.d x18, x1, (x1)         ;
_l39:    la x5, d_1_16                    ;
      addi x5, x5, -24         ;
      amoand.w x6, x22, (x5)         ;
_l40:    la x25, d_4_1                    ;
      ld x20, -0(x25)         ;
_l41:    sraw x0, x3, x18                    ;
_l42:    la x2, d_3_25                    ;
      addi x2, x2, -8         ;
      amomax.w x2, x12, (x2)         ;
_l43:    uret                    ;
_l44:    fsgnj.s f5, f24, f10                    ;
_l45:    slliw x5, x30, 24                    ;
_l46:    la x8, d_3_18                    ;
      srai x8, x8, 1         ;
      csrrc x23, pmpaddr1, x8         ;
_l47:    fcvt.lu.s x21, f25, rne                    ;
_l48:    addw x21, x7, x11                    ;
_l49:    la x10, d_5_27                    ;
      sb x25, -19(x10)         ;
_l50:    sraiw x2, x28, 10                    ;
_l51:    flt.s x11, f17, f16                    ;
_l52:    la x27, d_3_9                    ;
      addi x27, x27, 24         ;
      amoxor.d x29, x2, (x27)         ;
_l53:    auipc x16, 1048575                    ;
_l54:    fcvt.lu.s x13, f11, rne                    ;
_l55:    la x25, d_5_1                    ;
      addi x25, x25, 28         ;
      amoand.w x3, x9, (x25)         ;
_l56:    xor x28, x28, x28                    ;
      csrrs x28, satp, x28         ;
_l57:    fclass.s x3, f25                    ;
_l58:    la x11, d_0_7                    ;
      addi x11, x11, -24         ;
      amoswap.d x8, x6, (x11)         ;
_l59:    la x9, d_1_10                    ;
      fsw f6, -28(x9)         ;
_l60:    fmin.s f14, f11, f14                    ;
_l61:    mret                    ;
_l62:    csrrci x10, sie, 20                    ;
_l63:    la x12, d_1_7                    ;
      srai x12, x12, 1         ;
      csrrc x7, pmpaddr5, x12         ;
_l64:    la x21, d_3_13                    ;
      addi x21, x21, 20         ;
      amoswap.w x15, x6, (x21)         ;
_l65:    srlw x3, x11, x7                    ;
_l66:    addw x22, x26, x7                    ;
_l67:    la x5, d_3_13                    ;
      addi x5, x5, 4         ;
      amoand.w x13, x25, (x5)         ;
_l68:    la x18, d_0_4                    ;
      addi x18, x18, -24         ;
      amoor.d x18, x7, (x18)         ;
_l69:    fsub.s f31, f2, f10, rne                    ;
_l70:    sraw x10, x25, x12                    ;
_l71:    addiw x30, x7, -738                    ;
_l72:    la x10, d_4_1                    ;
      addi x10, x10, 16         ;
      lr.d x7, (x10)         ;
_l73:    la x30, d_0_11                    ;
      addi x30, x30, 0         ;
      amoadd.d x25, x29, (x30)         ;
_l74:    la x12, d_3_20                    ;
      addi x12, x12, -16         ;
      amoxor.d x26, x10, (x12)         ;
_l75:    slliw x23, x30, 20                    ;
_l76:    la x22, d_5_6                    ;
      ld x15, 0(x22)         ;
_l77:    la x26, d_3_17                    ;
      addi x26, x26, -0         ;
      lr.d x29, (x26)         ;
_l78:    fcvt.s.wu f22, x11, rne                    ;
_l79:    la x14, d_0_14                    ;
      addi x14, x14, 16         ;
      lr.d x4, (x14)         ;
_l80:    la x3, d_3_13                    ;
      sw x5, 20(x3)         ;
_l81:    la x18, d_0_2                    ;
      flw f27, 4(x18)         ;
_l82:    li x24, 1                    ;
      la x9, pt3         ;
      addi x9, x9, 56         ;
      sfence.vma x24, x9         ;
_l83:    slliw x9, x3, 0                    ;
_l84:    lui x18, 103598                    ;
_l85:    la x23, d_1_11                    ;
      addi x23, x23, 24         ;
      amoxor.d x6, x10, (x23)         ;
_l86:    la x14, d_5_0                    ;
      addi x14, x14, 8         ;
      amoadd.d x22, x26, (x14)         ;
_l87:    sraw x8, x13, x7                    ;
_l88:    la x3, d_1_9                    ;
      sh x3, -22(x3)         ;
_l89:    fsub.s f14, f8, f19, rne                    ;
_l90:    fsqrt.s f12, f30, rne                    ;
_l91:    fcvt.lu.s x27, f21, rne                    ;
_l92:    la x7, d_0_17                    ;
      addi x7, x7, 8         ;
      amomin.d x25, x30, (x7)         ;
_l93:    la x17, d_4_9                    ;
      addi x17, x17, -0         ;
      lr.d x24, (x17)         ;
_l94:    la x13, d_5_26                    ;
      addi x13, x13, 0         ;
      amoswap.w x28, x25, (x13)         ;
_l95:    la x5, d_3_10                    ;
      addi x5, x5, 0         ;
      lr.d x24, (x5)         ;
_l96:    la x3, d_5_27                    ;
      lh x14, -2(x3)         ;
_l97:    fcvt.s.lu f0, x30, rne                    ;
_l98:    la x14, d_5_19                    ;
      addi x14, x14, -16         ;
      amoadd.d x13, x30, (x14)         ;
_l99:    la x23, d_3_3                    ;
      fsw f25, 8(x23)         ;
_l100:    la x29, d_3_25                    ;
      addi x29, x29, -0         ;
      lui x18, 0xffe00         ;
      xor x29, x29, x18         ;
      amominu.d x3, x18, (x29)         ;
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
                .dword 0xac1cef9975a0986c, 0x1dbf7362b7cc752c
                .dword 0x6e5c7a4807697be3, 0xe17c680acf5d5cef
d_0_0:          .dword 0xedd2de87cac372f8, 0xe0d781c5448dafcb
d_0_1:          .dword 0x03bdc8b3900e8a75, 0x526724861abf3928
d_0_2:          .dword 0xb5c093a2fa498a28, 0x81a5f3ac07e53b71
d_0_3:          .dword 0x72b3521dbc8aba3a, 0xcb088453f974e15b
d_0_4:          .dword 0xee2eefe655410fd1, 0x9c9f9b956535842e
d_0_5:          .dword 0x08b9ea6ce297a394, 0xba973e9cfcea787f
d_0_6:          .dword 0x7d67224fa213208f, 0x19a1b56b6b819301
d_0_7:          .dword 0x6a56d8e19b8f1e63, 0xdddc45babbf9d0cb
d_0_8:          .dword 0xdcdf00c1c6894d71, 0x5391261bc78a2811
d_0_9:          .dword 0xdfc1e4613b23eb31, 0x675a4f28210dab0c
d_0_10:         .dword 0xfb070e8dc094932d, 0x62d100b226450c69
d_0_11:         .dword 0x4aeaa828c3453f5e, 0x42a879e3c3f8d367
d_0_12:         .dword 0xd37afe4ef2b29a65, 0x275e04be4c23d5e5
d_0_13:         .dword 0x7a21f41a51d31de3, 0x977cfc37cd86c425
d_0_14:         .dword 0x11c61b164c83cd24, 0xdf7f079c40d5a0c0
d_0_15:         .dword 0x0606ddf0c43a8cfd, 0x47d75725bd6adb8f
d_0_16:         .dword 0xd10c1325a4ca1a83, 0x332d3aa0f0699d76
d_0_17:         .dword 0x118630b86185b7ad, 0xfd77ed354c5856a0
d_0_18:         .dword 0x143e3b0684ef3b59, 0xfb60b16b2b9adfa9
d_0_19:         .dword 0x038b47af8726d2ec, 0xe50561e66f41b19f
d_0_20:         .dword 0x4d54b1eff853d2f3, 0xda722114c55f281a
d_0_21:         .dword 0x15839e22fbf1e63b, 0xcde737f21b662560
d_0_22:         .dword 0xc53aa136192c3afb, 0x371f40a4aab789d2
d_0_23:         .dword 0xfd972cec8bdaadc2, 0xc561b5d9ea11e022
d_0_24:         .dword 0xef1029805dbd5d5c, 0x305f482d0952f67a
d_0_25:         .dword 0x516676bab15c73ef, 0x855740709ab88d99
d_0_26:         .dword 0x90ea8d26e962890a, 0xc3ce481dccd5a13f
d_0_27:         .dword 0x2aee22ee8094c473, 0x487bbb55949e977d
                .dword 0x3a8654a09b877a73, 0x6b26f642f427627d
                .dword 0x45dc5d34ed993b9f, 0x985b06ba0347b78a
        /* Random data */
_end_data0:
                 

    .section .data.random1;
    .align  8;

_random_data1:
                .dword 0xffcfb8fb54a9e6a7, 0x778b2ad68588bb2f
                .dword 0xd4d6c1ba8efa5d5e, 0x20c93aee482245d8
d_1_0:          .dword 0xfebd18e5d3ab0ad7, 0x85c670bfda6f9567
d_1_1:          .dword 0x9c9561a5464cbd27, 0xc2d99dce1898f615
d_1_2:          .dword 0x44bf817f6e68f014, 0x26357025dfd41137
d_1_3:          .dword 0x5263216b7261cbaa, 0xcefb22d5c4878104
d_1_4:          .dword 0xedd95366887df156, 0xe70b12d2b6ec46f4
d_1_5:          .dword 0x3eb4bc3137024cc0, 0xb492221438516f06
d_1_6:          .dword 0x665515ec72f62c87, 0x1066db52ef4389bb
d_1_7:          .dword 0x765d683e4ae8eef0, 0xee6aa041628b2ebd
d_1_8:          .dword 0x2d8875990f419868, 0x0e7088f2d553b4d1
d_1_9:          .dword 0xf03eb80736d69e72, 0xe42f807a8282c17e
d_1_10:         .dword 0xf7131f1626aa25e1, 0x6a38b45a0a72102e
d_1_11:         .dword 0x058f7f94b52ee5bb, 0x8147eea258829ad8
d_1_12:         .dword 0xc320a689c1f840af, 0xba955edd0fa2614e
d_1_13:         .dword 0x0c840fc7771b270f, 0x7a37e0e97bf26960
d_1_14:         .dword 0x1adf13f5c223f7c1, 0x95a5d4c483c46f7d
d_1_15:         .dword 0x0d830d428cf03ef7, 0xafeedf6b27fee8db
d_1_16:         .dword 0x7268c53cf8ae49fb, 0x68d0e233bc76c914
d_1_17:         .dword 0x54a3e6044de959cb, 0xa12c75b6ca6cfe8b
d_1_18:         .dword 0x478b27cbe67d4e58, 0xe963b7a6f8e9f565
d_1_19:         .dword 0x0d71867d5d50f2e5, 0x596c1dc202864790
d_1_20:         .dword 0xf4ee05af6d1ad80e, 0x3fdd4ee5ad963596
d_1_21:         .dword 0x1ea64b981e51b365, 0xf06924ac4cc88080
d_1_22:         .dword 0xcd15b0e092bab41c, 0xfd00ff858f1273fc
d_1_23:         .dword 0xb5f3a88df174b61b, 0xc6f9d27446ff3c2d
d_1_24:         .dword 0xf620d465dbe472b8, 0x682e63c7ebb11373
d_1_25:         .dword 0x450ade896c1e5bd7, 0x42b8cbeab1bf3e9c
d_1_26:         .dword 0xf47006b6a3e1d436, 0xf140f2dc02f3d3c6
d_1_27:         .dword 0x92045141ca933213, 0x63dc1c548063d4a9
                .dword 0x5e92154dafab64cb, 0x6b833ad60f9d400b
                .dword 0xb9b6dd99902ffbcc, 0x9dc9006e1476d7b8
        /* Random data */
_end_data1:


    .section .data.random2;
    .align  8;

_random_data2:
                .dword 0xcdf012b0de09bade, 0x47e6b0d6541822e4
                .dword 0x79043ace3c9ba37f, 0xde8ca1f5a1cd1d5e
d_2_0:          .dword 0x3aac0e74fb3c06c4, 0x75b8d35c718a16e6
d_2_1:          .dword 0x7b3635207b644588, 0xe2892b9da54294d8
d_2_2:          .dword 0x060220ce1511ee89, 0x562b13eabc9aa14b
d_2_3:          .dword 0x16607fda752a7cd1, 0x933d96fe484090dd
d_2_4:          .dword 0x12a7f428621b2da2, 0x2499a313bed0e5a5
d_2_5:          .dword 0xe69f1118c4230364, 0x3d5b16c1a8f732f5
d_2_6:          .dword 0xa8559aa73bfc24f8, 0xc0bd8706df87c80e
d_2_7:          .dword 0xc89d81b7e970417f, 0xe9a69f9a73add4e2
d_2_8:          .dword 0xb82b93347a3704b2, 0x1a212e407a85ea10
d_2_9:          .dword 0x36f06811c2f2c8df, 0xfdac4ac839c72116
d_2_10:         .dword 0xa6335cb675cc31cc, 0xd8b8749bf9e0470b
d_2_11:         .dword 0xe675010898286c8c, 0x3d2a39fbe3452a87
d_2_12:         .dword 0x7b1d172e4409dd59, 0xdaab7a39a2666afc
d_2_13:         .dword 0x0d863fb63ff7cbbb, 0x17effe2eb12e78b2
d_2_14:         .dword 0xc4ca23aaaf117046, 0xa5f6f903a2c61a32
d_2_15:         .dword 0x1a606820f82274aa, 0x2203eb6f67c187f2
d_2_16:         .dword 0xa6f8417d46d50736, 0xe1ca1ada7addaf81
d_2_17:         .dword 0x5ffa707d83ae31c0, 0x5d76d203c4ecf259
d_2_18:         .dword 0xefdbd31c77219789, 0xc98ae5acaf4199a4
d_2_19:         .dword 0x53d6efa6e5d5768c, 0x5b94782b7537a579
d_2_20:         .dword 0x827a0909cdb3fb9c, 0x4a8684a97d2768d6
d_2_21:         .dword 0xb9cbd4ec8641c4eb, 0x6dc91f0a3c7746b1
d_2_22:         .dword 0xab00f1c8669e72c5, 0x252166c1f0a89df0
d_2_23:         .dword 0x4b7c1313a98bb9f1, 0xb698de973e04d034
d_2_24:         .dword 0xdeeaed8b5e308094, 0x828b22d614da1fa9
d_2_25:         .dword 0x3becad3fc20caf37, 0x868416b49b10ab2c
d_2_26:         .dword 0xff627d1a5d58d1ce, 0x54bd8337b62adc1e
d_2_27:         .dword 0x893876b80d41998b, 0x084a90f115d7e59d
                .dword 0x0e6e7884dd55806c, 0x94463c413a0ba744
                .dword 0x7b6932cfbb79aff7, 0x13c0669d2f4c8feb
         /* Random data */
_end_data2:
                

    .section .data.random3;
    .align  8;

_random_data3:
                .dword 0x03a74eb036f5db4b, 0x6a1bf5e72885ddf7
                .dword 0xfea2816a4e5f01c8, 0xf0b6e637fa5f5ffa
d_3_0:          .dword 0xb62b72e72395bea7, 0x6f31301b9c998598
d_3_1:          .dword 0x299bfaf8c4814c66, 0x011b5e3e3712341d
d_3_2:          .dword 0x48dd67fdc719667f, 0x0f89e64abd66c394
d_3_3:          .dword 0xd675f7d082df86a0, 0xbfb2e0169e17ce66
d_3_4:          .dword 0xc04b697c6dde6bb7, 0x7e14002a01997b78
d_3_5:          .dword 0x337c0a7ab43223d2, 0xf510ccedc3337c52
d_3_6:          .dword 0xa148cda7e396b524, 0x1b4924180818a61a
d_3_7:          .dword 0x38b30c610d379ca7, 0x6d71bfe5d4ce0f94
d_3_8:          .dword 0x02649dd3c41aa744, 0x769cd65d6d65b31b
d_3_9:          .dword 0x5e514f268d988c3a, 0xc8754794ad3e30e5
d_3_10:         .dword 0xad0c29566a9ca102, 0xf7337e536de42e41
d_3_11:         .dword 0x603c2049f5f70349, 0x457c07c23ee8f86b
d_3_12:         .dword 0x8ad8291ae039a8f1, 0x224a4ee9963df24c
d_3_13:         .dword 0xb8c4a94fd30e9878, 0xc2edd0fee3b43e48
d_3_14:         .dword 0xcde3d59509f8c1eb, 0x7fb67a15b306c4f4
d_3_15:         .dword 0xe33ff21f610f6220, 0xa564cd7e105300d5
d_3_16:         .dword 0xbb2b77e3a1d286f9, 0x140e6098e8274095
d_3_17:         .dword 0xeb60538e1aa64628, 0xa86bd1db3930062f
d_3_18:         .dword 0x80d45e76a4115db3, 0x8bdeda2c931fd4ab
d_3_19:         .dword 0x158a8519efda0524, 0x5922072c0a5c9a87
d_3_20:         .dword 0xa24ebfa38a2b8922, 0xa90cc5171833f656
d_3_21:         .dword 0x9b1d74871346ace3, 0x0c8c0ee46e1b0dbf
d_3_22:         .dword 0x239263d925f04483, 0xc2770cf93974095c
d_3_23:         .dword 0x1d2fa64f0eb2f3ab, 0x15410e3b3cec407d
d_3_24:         .dword 0xf9515281bdde3569, 0x7fd18570f95dcc63
d_3_25:         .dword 0x7970ed2e9eee22cd, 0x63ab8d03be4f59b9
d_3_26:         .dword 0x49d49e10cfb9d670, 0x06ec759caf08ba94
d_3_27:         .dword 0xaad1d09ba1315f33, 0x0e8c5eaceba5cc9f
                .dword 0xca773f86f2406908, 0x627f206c0c4843f7
                .dword 0x82ec6646a972e349, 0x8d7a12282ad9de99
        /* Random data */
_end_data3:


    .section .data.random4;
    .align  8;

_random_data4:
                .dword 0x44d98a6113435e9b, 0x2c65af9d21b5c825
                .dword 0xeeced4b2e18b4997, 0xf59efe6b56a80e9b
d_4_0:          .dword 0xf94015616fcf23dc, 0xe0528cecee44ba12
d_4_1:          .dword 0x5444b2eae29cf93b, 0xc12149b67592ee0d
d_4_2:          .dword 0xfe6e035bdf441c37, 0x31c605714da90150
d_4_3:          .dword 0xf59935e87e7f8953, 0x540232784f228d81
d_4_4:          .dword 0x1b105bb75637670e, 0x590ad1a50ff05678
d_4_5:          .dword 0xf94b7bf9c3392af7, 0x1b06aaa82d4f537e
d_4_6:          .dword 0x8edcf141a0330b11, 0xb9352b40ba223a6e
d_4_7:          .dword 0x1b7032f7829e69bb, 0x0abad0d44c571eb9
d_4_8:          .dword 0xd17658adb99b7406, 0x45fea3101aba217f
d_4_9:          .dword 0x7f3a85e4b0b4b72a, 0x858fae336c10e8c8
d_4_10:         .dword 0xbaf7ca819d218e39, 0xf477c1c40f5600a7
d_4_11:         .dword 0x66fac5c3d9ce5e7e, 0xd9d51f52002d5659
d_4_12:         .dword 0x1ade61cdb7747251, 0x8a80f55b814ce166
d_4_13:         .dword 0x83582e95a3fdaee2, 0x9fc279f523a74cc8
d_4_14:         .dword 0xbaa7c72332bf9fdf, 0x2a79d997b473a690
d_4_15:         .dword 0x90e525bf7ecfb642, 0xe09a5540c49058bc
d_4_16:         .dword 0x2ad5169719b296b0, 0xdf771819f2ad0959
d_4_17:         .dword 0x9b523bb1c3ad4826, 0xf61a5b04c93a9d87
d_4_18:         .dword 0x06d78534b6351473, 0x82d6183fbec3b05c
d_4_19:         .dword 0x38e11b78ddf610f5, 0xe586dcdf6257f67b
d_4_20:         .dword 0x84d40c459f6ad2c8, 0x8115baf5fbb6960d
d_4_21:         .dword 0xbdb200ecf155a531, 0x5c504174b3bcad28
d_4_22:         .dword 0xdd25baccc1d6efdc, 0x4c121695ba061e0e
d_4_23:         .dword 0x7496a0c77df1f7be, 0x44573f9b97ce7348
d_4_24:         .dword 0x72e6c2d3ec118c10, 0x234a7c425db5eb52
d_4_25:         .dword 0xf9472dd2dd44d533, 0x4b90ce4515a91df4
d_4_26:         .dword 0x13dda41695acb0a5, 0x362b128304ea1b94
d_4_27:         .dword 0x4eec2aa5a63d5e5f, 0x1bdc6d2ab140ce75
                .dword 0x45da63022cfa4852, 0xd38c74faca34d764
                .dword 0x46b38d3ec38ecb52, 0x9243e606e50ff662
        /* Random data */
_end_data4:


    .section .data.random5;
    .align  8;

_random_data5:
                .dword 0x6d769e5f3bdc34bf, 0xc5fc38c916325a1f
                .dword 0x608d41bb89367818, 0x6c302d0768b7399b
d_5_0:          .dword 0x492942c2bd8c76aa, 0x4bdf225fef7d4625
d_5_1:          .dword 0x7af56033479b591a, 0x9a8680d3d4396caf
d_5_2:          .dword 0x9c8e027399469eb1, 0xadbe2590b3b7a1fe
d_5_3:          .dword 0xa537628db4332e27, 0x3cec51c24bddebca
d_5_4:          .dword 0xee3f82396d1d726d, 0x1f6c9bc7692c8ceb
d_5_5:          .dword 0x02eafe482bf819e8, 0x74ce0b4aee0369fe
d_5_6:          .dword 0xdb928e7239a28ccb, 0x6a8ffe5c11a8280a
d_5_7:          .dword 0x278b279e338dd236, 0x2cf8fe17d7fccdcb
d_5_8:          .dword 0xfbf9056478a88144, 0x28e29c438aa2b18d
d_5_9:          .dword 0x4fa6e51067a3a085, 0x61f3376b5fc314f6
d_5_10:         .dword 0xb6d4c950a3c564c1, 0x65454b837bdae710
d_5_11:         .dword 0x59aa3710bafc4437, 0xdd0058c0636193af
d_5_12:         .dword 0xb9256cdc079e350a, 0x0ac112cb1a451401
d_5_13:         .dword 0x4b1cfa38393b9bc2, 0x4d30415af898d156
d_5_14:         .dword 0x151c75973b98d5f4, 0x42e4d60ffc4d35d4
d_5_15:         .dword 0xa60f738177b2168f, 0xc81bbe69dd078dbb
d_5_16:         .dword 0x8975ad85ca62fc29, 0xee8c26d7071f9d56
d_5_17:         .dword 0x9c4ba7870b4c8709, 0x831e5c4578d0fea4
d_5_18:         .dword 0x0268b4bce2d70255, 0xff53875e8b9704dc
d_5_19:         .dword 0xdb33924c2787696a, 0xe2eedc6d9c14a841
d_5_20:         .dword 0xddd7746e5a6dc43f, 0xdce8c0af66c713b3
d_5_21:         .dword 0xbe5798fb23991063, 0x5cf131067d3081e6
d_5_22:         .dword 0x233b0bbd9c1b91d3, 0x14751cabc3cf9544
d_5_23:         .dword 0x72b39d4e950c46f6, 0x65904df55e1fa80d
d_5_24:         .dword 0x0600e63d23f0a7be, 0xa144d1ddaf774bc6
d_5_25:         .dword 0x6d19fb90aebfe312, 0x01aff0160c0cd7c2
d_5_26:         .dword 0x311581aec7a1ee96, 0x77d8a19cd7df2677
d_5_27:         .dword 0xcc96848f5518edbe, 0xca50278192fecb7a
                .dword 0xafc1c1db991e3c56, 0x09759a107f2d19d8
                .dword 0xd0fff67992a1771e, 0x760597d164c0f0b1
         /* Random data */
_end_data5:
              
                 
