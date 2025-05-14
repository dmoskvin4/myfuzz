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
_fuzz_suffix:
_s0:    la x9, d_0_15                             ;
        sh x3, 12(x9)                             ;
_s1:    la x30, d_4_16                            ;
        addi x30, x30, 24                         ;
        sc.d x19, x30, (x30)                      ;
_s2:    xori x9, x24, 1051                        ;
_s3:    sraw x16, x7, x5                          ;
_s4:    ori x3, x25, -245                         ;
_s5:;
        /* Fuzz trap */
        /**/
_end_suffix:
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
                (MSTATUS_MPP & (MSTATUS_MPP >> 1));
        csrs mstatus, a0;
        init_mie;
        csrwi fcsr, 0;
        call init_freg
        csrw minstret,zero
        csrr a0, mhartid;
_fuzz_prefix:
_p0:    xor x11, x11, x11                         ;
        addi x11, zero, 3                         ;
        slli x11, x11, 0                          ;
        add x11, x11, x11                         ;
        csrrs x14, sip, x11                       ;
_p1:    csrrci x14, satp, 2                       ;
_p2:    csrrsi x14, pmpaddr7, 25                  ;
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
_l2:    xori x24, x19, -344                    ;
_l3:    xor x18, x18, x18                    ;
      addi x22, zero, 1         ;
      slli x22, x22, 1         ;
      add x18, x18, x22         ;
      csrrw x29, scause, x18         ;
_l4:    addi x0, x1, 0                    ;
_l5:    srlw x25, x12, x6                    ;
_l6:    addi x0, x1, 0                    ;
_l7:    slli x14, x12, 63                    ;
_l8:    la x26, d_0_21                    ;
      flw f20, 24(x26)         ;
_l9:    fcvt.s.lu f14, x17, rne                    ;
_l10:    slliw x1, x0, 25                    ;
_l11:    fdiv.s f7, f31, f7, rne                    ;
_l12:    srai x15, x10, 6                    ;
_l13:    la x11, d_4_19                    ;
      ld x22, 8(x11)         ;
_l14:    addw x13, x22, x2                    ;
_l15:    fcvt.s.l f23, x23, rne                    ;
_l16:    la x18, d_5_11                    ;
      fsw f12, 28(x18)         ;
_l17:    xor x15, x15, x15                    ;
      addi x19, zero, 1         ;
      slli x19, x19, 10         ;
      add x15, x15, x19         ;
      addi x16, zero, 3         ;
      slli x16, x16, 28         ;
      add x15, x15, x16         ;
      addi x3, zero, 1         ;
      slli x3, x3, 31         ;
      add x15, x15, x3         ;
      csrrc x18, fflags, x15         ;
_l18:    andi x28, x3, -1854                    ;
_l19:    srliw x5, x30, 0                    ;
_l20:    la x13, d_2_10                    ;
      fsw f26, 20(x13)         ;
_l21:    la x30, d_0_16                    ;
      addi x30, x30, 24         ;
      lr.w x19, (x30)         ;
_l22:    fle.s x7, f31, f25                    ;
_l23:    la x21, d_3_13                    ;
      addi x21, x21, 20         ;
      amoswap.w x15, x6, (x21)         ;
_l24:    la x26, d_3_26                    ;
      sw x26, 0(x26)         ;
_l25:    la x27, d_4_18                    ;
      lbu x12, 31(x27)         ;
_l26:    srlw x16, x18, x24                    ;
_l27:    la x18, d_0_4                    ;
      addi x18, x18, -24         ;
      amoor.d x18, x7, (x18)         ;
_l28:    la x19, d_0_8                    ;
      addi x19, x19, 4         ;
      amoor.w x15, x25, (x19)         ;
_l29:    fadd.s f5, f7, f27, rne                    ;
_l30:    la x19, d_1_1                    ;
      sd x19, -8(x19)         ;
_l31:    fle.s x26, f11, f8                    ;
_l32:    la x26, d_3_10                    ;
      addi x26, x26, 12         ;
      amomin.w x19, x26, (x26)         ;
_l33:    addi x0, x1, 0                    ;
_l34:    srai x15, x30, 17                    ;
_l35:    la x23, d_2_23                    ;
      addi x23, x23, 20         ;
      amoxor.w x7, x18, (x23)         ;
_l36:    la x30, d_5_8                    ;
      addi x30, x30, 20         ;
      sc.w x18, x19, (x30)         ;
_l37:    la x7, d_1_7                    ;
      addi x7, x7, 20         ;
      amomax.w x2, x17, (x7)         ;
_l38:    fmsub.s f16, f25, f31, f19, rne                    ;
_l39:    srli x22, x8, 42                    ;
_l40:    la x7, d_4_3                    ;
      addi x7, x7, -0         ;
      amoswap.d x7, x12, (x7)         ;
_l41:    addi x0, x1, 0                    ;
_l42:    la x6, d_2_17                    ;
      addi x6, x6, -28         ;
      amoand.w x10, x30, (x6)         ;
_l43:    sllw x26, x29, x26                    ;
_l44:    andi x4, x19, -2047                    ;
_l45:    la x30, d_5_8                    ;
      addi x30, x30, 20         ;
      sc.w x18, x19, (x30)         ;
_l46:    li x29, 0                    ;
      la x4, pt0         ;
      addi x4, x4, 0         ;
      sfence.vma x29, x4         ;
_l47:    la x19, d_1_10                    ;
      addi x19, x19, -0         ;
      amoand.d x2, x1, (x19)         ;
_l48:    fclass.s x22, f30                    ;
_l49:    fcvt.s.l f25, x12, rne                    ;
_l50:    la x11, d_1_24                    ;
      lw x5, -4(x11)         ;
_l51:    la x17, d_5_22                    ;
      lb x9, -25(x17)         ;
_l52:    la x30, d_3_10                    ;
      addi x30, x30, 24         ;
      amoxor.w x25, x6, (x30)         ;
_l53:    srlw x4, x29, x14                    ;
_l54:    srli x16, x5, 43                    ;
_l55:    li x27, 1                    ;
      la x5, pt0         ;
      addi x5, x5, 0         ;
      sfence.vma x27, x5         ;
_l56:    fsub.s f31, f2, f10, rne                    ;
_l57:    fmin.s f22, f22, f29                    ;
_l58:    la x30, d_5_8                    ;
      addi x30, x30, 20         ;
      sc.w x18, x19, (x30)         ;
_l59:    la x20, d_1_26                    ;
      lhu x12, -10(x20)         ;
_l60:    auipc x11, 753113                    ;
_l61:    fcvt.lu.s x18, f15, rne                    ;
_l62:    la x6, d_2_10                    ;
      lbu x29, 0(x6)         ;
_l63:    fmul.s f28, f7, f13, rne                    ;
_l64:    sraw x10, x25, x12                    ;
_l65:    la x1, d_5_0                    ;
      addi x1, x1, -8         ;
      amomax.w x22, x28, (x1)         ;
_l66:    fmul.s f4, f20, f8, rne                    ;
_l67:    fadd.s f10, f20, f8, rne                    ;
_l68:    la x28, d_1_9                    ;
      lui x5, 0xffe00         ;
      xor x28, x28, x5         ;
      sb x8, 0(x28)         ;
_l69:    la x6, d_4_15                    ;
      addi x6, x6, 16         ;
      amomin.d x9, x25, (x6)         ;
_l70:    fcvt.l.s x25, f14, rne                    ;
_l71:    la x23, d_1_10                    ;
      addi x23, x23, -0         ;
      lr.d x11, (x23)         ;
_l72:    la x19, d_0_14                    ;
      addi x19, x19, 8         ;
      amominu.d x17, x13, (x19)         ;
_l73:    la x12, d_3_20                    ;
      addi x12, x12, -16         ;
      amoxor.d x26, x10, (x12)         ;
_l74:    fcvt.w.s x4, f30, rne                    ;
_l75:    la x5, d_3_16                    ;
      sw x13, 20(x5)         ;
_l76:    la x5, d_5_5                    ;
      addi x5, x5, 24         ;
      sc.d x4, x5, (x5)         ;
_l77:    la x9, d_3_7                    ;
      fsw f24, 4(x9)         ;
_l78:    feq.s x28, f26, f5                    ;
_l79:    la x21, d_5_25                    ;
      addi x21, x21, -16         ;
      lui x22, 0xffe00         ;
      xor x21, x21, x22         ;
      amomin.d x18, x22, (x21)         ;
_l80:    xor x24, x24, x24                    ;
      addi x27, zero, 3         ;
      slli x27, x27, 15         ;
      add x24, x24, x27         ;
      csrrs x6, scause, x24         ;
_l81:    la x27, d_5_18                    ;
      flw f31, 24(x27)         ;
_l82:    la x28, d_0_20                    ;
      addi x28, x28, 8         ;
      amoswap.d x5, x15, (x28)         ;
_l83:    addi x0, x1, 0                    ;
_l84:    slliw x23, x30, 20                    ;
_l85:    fmv.x.w x22, f16                    ;
_l86:    la x26, d_3_17                    ;
      addi x26, x26, -0         ;
      lr.d x29, (x26)         ;
_l87:    la x27, d_2_19                    ;
      addi x27, x27, -0         ;
      amomaxu.d x24, x25, (x27)         ;
_l88:    la x4, d_4_17                    ;
      addi x4, x4, -20         ;
      amoor.w x9, x17, (x4)         ;
_l89:    la x27, d_0_7                    ;
      addi x27, x27, -20         ;
      amoor.w x17, x30, (x27)         ;
_l90:    la x13, d_5_6                    ;
      addi x13, x13, -8         ;
      amoand.d x16, x11, (x13)         ;
_l91:    fnmsub.s f22, f24, f5, f13, rne                    ;
_l92:    la x27, d_2_20                    ;
      addi x27, x27, -0         ;
      lr.d x5, (x27)         ;
_l93:    fclass.s x5, f0                    ;
_l94:    la x19, d_1_1                    ;
      sd x19, -8(x19)         ;
_l95:    la x10, d_1_2                    ;
      addi x10, x10, -8         ;
      sc.d x20, x10, (x10)         ;
_l96:    sltiu x0, x14, -117                    ;
_l97:    lui x21, 9                    ;
_l98:    fsqrt.s f30, f18, rne                    ;
_l99:    la x24, d_5_18                    ;
      fsw f10, 4(x24)         ;
_l100:    la x11, d_4_1                    ;
      addi x11, x11, -8         ;
      amoand.w x5, x9, (x11)         ;
      lhu x27, 26(x3)         ;
      lbu x28, -19(x15)         ;
      addi x25, x25, 20         ;
      amoand.w x17, x1, (x25)         ;
      addi x23, x23, 12         ;
      sc.w x24, x13, (x23)         ;
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
                .dword 0xa85810876ba09df0, 0xaa1a611d6e22ffc1
                .dword 0xdc5671872f2c006a, 0x3cf0cbeddfb092b3
d_0_0:          .dword 0xfa37a4ec98075237, 0x9d8c061fa978d21a
d_0_1:          .dword 0x692b30de5b22e6c8, 0x8289107f7d1a3d77
d_0_2:          .dword 0xdef21fb13ab0d2d7, 0x92184412445f359d
d_0_3:          .dword 0xdd273c949aadd706, 0xbc16fdd78d842b15
d_0_4:          .dword 0x2b8ad8375aabd623, 0xad6d410ef2e8ba38
d_0_5:          .dword 0x7994a4745b0912f9, 0x2829015da169eb38
d_0_6:          .dword 0x62dca15e5dadb15e, 0x5a77309771f4c6da
d_0_7:          .dword 0xf3ff88f597a368d4, 0x2973a8477afdfcc8
d_0_8:          .dword 0x40d486511be4fba7, 0xa79b5df295f3fc3f
d_0_9:          .dword 0xa3af3e6728b77534, 0x6a2050351fbf4e4f
d_0_10:         .dword 0x9e1ca51b636021f8, 0x5d390fd0fff470a5
d_0_11:         .dword 0x190cc69af6bf1f3c, 0xfad66d39fb8b25cf
d_0_12:         .dword 0x9fc8d353a37d981f, 0x3da81f977453ae09
d_0_13:         .dword 0x555f79cc1c6a18d6, 0x0348f8e48a40a61c
d_0_14:         .dword 0x8f626b13a11409a5, 0xf87a23625b5ac150
d_0_15:         .dword 0xddd10f7ca9b2e3e2, 0x5f7b176f5fdafc8a
d_0_16:         .dword 0xead883a89eb212c2, 0xb2a1c3bd120ade80
d_0_17:         .dword 0xe2378e236c9ad906, 0x824338c132a1e5d6
d_0_18:         .dword 0x206250403c003116, 0x2105b991e2e500a4
d_0_19:         .dword 0xa33c0dadd5150e06, 0x6d925fb11516c0e8
d_0_20:         .dword 0x795649b44fd77f8b, 0xeee546231164dc04
d_0_21:         .dword 0x747e207f09753b9e, 0x57e042dcffa204a8
d_0_22:         .dword 0x19714fdeaf6d6587, 0xf9119a507c71cc0e
d_0_23:         .dword 0xf641cacbb0085522, 0xbc3ad845c4d1951a
d_0_24:         .dword 0xc8fa90b88f285a70, 0x91948e55e8a0c22e
d_0_25:         .dword 0xe7398e6a75f32b42, 0x7abfa6dfd9725a23
d_0_26:         .dword 0xc2ebea05a202a94b, 0x968a9565af629c8f
d_0_27:         .dword 0xc6114452d1526539, 0x6b89ce9dcf91943b
                .dword 0x750f250f8c108003, 0x60378b282f38910e
                .dword 0xfee032b58fef5c2e, 0x3f2f648463b5d5bd
        /* Random data */
_end_data0:
                 

    .section .data.random1;
    .align  8;

_random_data1:
                .dword 0x09a89ff5512f1ba8, 0x213e677e5452ed1c
                .dword 0x7be787c42cf83987, 0x535651f022b67375
d_1_0:          .dword 0x38896ef7fffbce81, 0x1e954f1fd8428c46
d_1_1:          .dword 0xf54f41de7d01a92a, 0xa09c1e66e9c1f2f6
d_1_2:          .dword 0x9b3ea2b34b971db2, 0x048e236f865db824
d_1_3:          .dword 0xdd53461917a113fa, 0xe4a3bfe8dceb1c8c
d_1_4:          .dword 0x71e8a46a6d28e04d, 0x802db687f0bb125d
d_1_5:          .dword 0xe88ce8226ead5932, 0xd5688b1dcd76f548
d_1_6:          .dword 0xb550d9cbc6d31890, 0xf2832e53a3d8e8e3
d_1_7:          .dword 0xd8df1658ee02a9d8, 0xd17e7c239b472852
d_1_8:          .dword 0x5a52e6a020c62ce9, 0x67cc6fb435c2ed91
d_1_9:          .dword 0xeff3f788eaf55341, 0xc32519ed26392c3b
d_1_10:         .dword 0xe841c08ee8853d4d, 0x296ade7c1b000ca4
d_1_11:         .dword 0x94b414d0887bf578, 0xe649248982dadc5f
d_1_12:         .dword 0xcdac9261ed449a25, 0xd638463b29951ed7
d_1_13:         .dword 0xc0472404977c06ea, 0xcc9ea856531c8902
d_1_14:         .dword 0x26d7e333b56e1691, 0x5969ae55c5c9a1bd
d_1_15:         .dword 0xd3ceca6593a4005f, 0x310b52a32b51181a
d_1_16:         .dword 0xa8b53623cb663547, 0x457dc2cd0746b838
d_1_17:         .dword 0x7656e86a37a6bb20, 0x576bc4e7db2ccfdc
d_1_18:         .dword 0x117d509efada0279, 0x773b9ce9c61e365f
d_1_19:         .dword 0x6221c99578aed29b, 0x1485b9397e5b1c30
d_1_20:         .dword 0x71ff3e7817d9f3c7, 0xd94189c7bede1a5a
d_1_21:         .dword 0xa171d667650d964a, 0xdf270381783e3ddd
d_1_22:         .dword 0x8f153d3f88f2431a, 0x4abeddac0ab0309c
d_1_23:         .dword 0x92563b22c4f930d1, 0x1f082dbf432ad794
d_1_24:         .dword 0x248e7b1923b16374, 0xfe89f155eca8768d
d_1_25:         .dword 0xaee4b7f870a3ac76, 0x0d650355d0211045
d_1_26:         .dword 0xa11a8501bd53f0ac, 0x242d75d8fc7bf5a0
d_1_27:         .dword 0xd2fd478e587a5ad5, 0x08af7a7769df9a73
                .dword 0x53ddad1a67890923, 0xdc53312d827c1705
                .dword 0x091e32cc3fe06d82, 0x6c768551f49dcd59
        /* Random data */
_end_data1:


    .section .data.random2;
    .align  8;

_random_data2:
                .dword 0x22ed50789b60ea67, 0x8b7a4a005b24c7af
                .dword 0x77a9a30b6d8ecb86, 0x8405c1bc0eab0364
d_2_0:          .dword 0xcdaf581f4354c362, 0xf2f189ce4b4b1d8e
d_2_1:          .dword 0x7df04612e7c01a1a, 0x26222f8f55b2dcf8
d_2_2:          .dword 0x67eef54030530225, 0xfab9e47b5f5c42e9
d_2_3:          .dword 0xf835eb8398c5c1a8, 0xc816d7c3162e08f4
d_2_4:          .dword 0xf2a2f7c3b9986ef2, 0x69fbcc45cbc4dbe0
d_2_5:          .dword 0xd91cace6ca7c1fff, 0x2d35476b428989b8
d_2_6:          .dword 0x00490efb9f2488f2, 0x7a177a67d47b73ff
d_2_7:          .dword 0xe941639cd2aaeab3, 0x68f2601361fb13bd
d_2_8:          .dword 0x44db6d373bfa9990, 0x87f830448f99c989
d_2_9:          .dword 0xa21d3ed918622358, 0x5e7af021e8ef3c05
d_2_10:         .dword 0x4f21ac4f75307a5d, 0xeea74dc6dd4e9685
d_2_11:         .dword 0x500af0f70fd1df83, 0x9d579db3fb97ef20
d_2_12:         .dword 0x296192f8ea7c7d02, 0x3175f397a3e84fb1
d_2_13:         .dword 0xcb33c337d2c57b9f, 0xdc76ace56089ed0a
d_2_14:         .dword 0x06c23e21806e18b7, 0x1a3eaae979c018da
d_2_15:         .dword 0x35ad593e795bd485, 0x6669b12de70bed49
d_2_16:         .dword 0xe112d6d473896632, 0x34bf48731457dd6a
d_2_17:         .dword 0x3a98be1b050e2cb0, 0x527cc5d721d8f446
d_2_18:         .dword 0x7d4d3cd78cd6947e, 0x0db28bb154abd916
d_2_19:         .dword 0x8c5297834a217ae8, 0xbd6c0a15bc407c89
d_2_20:         .dword 0x940dfd45435ae678, 0x69ac1467b5c3c73c
d_2_21:         .dword 0x1a9db31e79364705, 0x3dacf1f88d22fa15
d_2_22:         .dword 0x73730673dccdf8c2, 0x1ca9818a74c4d61f
d_2_23:         .dword 0xd799112367d7b7c4, 0xeb19f5db85b7ab6d
d_2_24:         .dword 0x0b168f9f4a565117, 0xce5bb4ea34ff0669
d_2_25:         .dword 0x7027e42ba51b61b0, 0x36dbbcfa118be1b3
d_2_26:         .dword 0x790503bc79583548, 0xc90adeb5c51d5b46
d_2_27:         .dword 0x125191f95f847734, 0x82829d0bac47e1d1
                .dword 0x7d000a455623640f, 0xb80d6c9eab2b8daa
                .dword 0x845e2038040be079, 0x0a32f2e4182a59c9
         /* Random data */
_end_data2:
                

    .section .data.random3;
    .align  8;

_random_data3:
                .dword 0x640bd7e72b6bb370, 0xed16bddceae8c7a3
                .dword 0xe537162718bcf2df, 0x6f1b1085f77ea0a5
d_3_0:          .dword 0x74f68db198fa4102, 0x5b8c0ee14d038a42
d_3_1:          .dword 0xffc0f3a0a758a42f, 0xf4327d6ec81ab767
d_3_2:          .dword 0x7f87f9de3a25f76e, 0x7c6635819a496579
d_3_3:          .dword 0xcd34cbe1e40ab482, 0x20602f99c2fb4acf
d_3_4:          .dword 0xda6cd4eb74bc8028, 0x42e32b824530382c
d_3_5:          .dword 0x3fce20030f366f53, 0xcedd7c0e21c52a97
d_3_6:          .dword 0xfff9f878e8058209, 0xb3e26cd384958754
d_3_7:          .dword 0x467f661e67cbe377, 0xa6a92b7d367f135d
d_3_8:          .dword 0x4ed01c6b5ada459f, 0x68de0aee5c41dad7
d_3_9:          .dword 0xd2e646823b3b482f, 0xf3db8612d67d7fb8
d_3_10:         .dword 0xf2c1e35ddcb16dfb, 0x1b283527a9925714
d_3_11:         .dword 0x53d44caeb3791574, 0x1cfb01f4180ec5b2
d_3_12:         .dword 0xb276a55778e09e0c, 0xf719d41ccb6da5e3
d_3_13:         .dword 0xa020a2d838acc677, 0x48c0e58f90a8ca13
d_3_14:         .dword 0xc100d8579001a658, 0x6a09e128fd0dbea7
d_3_15:         .dword 0x4dfa35b3f9b757da, 0x7ef45526c0e305aa
d_3_16:         .dword 0xb54b94aa102be948, 0x4e2653da44278408
d_3_17:         .dword 0x4be4ec422799d1ba, 0xed212824c95c80d5
d_3_18:         .dword 0x0e1e9bec6713814b, 0x34935f0d8ff69188
d_3_19:         .dword 0x4dd0501e25f68788, 0xe5305125ef16ca3a
d_3_20:         .dword 0xb28ada51a958e656, 0x1beaeb04c0e71412
d_3_21:         .dword 0xda0449c6c88137b5, 0xaf5d429ab9da4586
d_3_22:         .dword 0xb0855e592bceda09, 0xfdf6a5058e9af521
d_3_23:         .dword 0x1f410f5c7725f72c, 0xb891dc65e6ddb0ed
d_3_24:         .dword 0x4ebb8770e0dc8757, 0xcf5aef0a139ff480
d_3_25:         .dword 0xbe28188016b3c57a, 0x76bf2761a64be89a
d_3_26:         .dword 0x1a65a697893ff73e, 0x4e5580b077c0374d
d_3_27:         .dword 0xba31b48b0c9fa610, 0x141cb85a0ec6cf7a
                .dword 0xd55483db761cfe0d, 0x843646e85b82c886
                .dword 0xb6cc1fc5aaa6699f, 0xd2142af2b2ce6e56
        /* Random data */
_end_data3:


    .section .data.random4;
    .align  8;

_random_data4:
                .dword 0xddf1d47ee6b72544, 0x82607ae7e34c9b8e
                .dword 0x26cec3ecd14c0318, 0xec7942918134eafe
d_4_0:          .dword 0x0bd2498eb2b2f6ea, 0xdd25bd0508989dd3
d_4_1:          .dword 0x87efbb92bf10e19a, 0x982d6cf913919fbb
d_4_2:          .dword 0xc4837f39582651e1, 0xf2edfb18e55166c5
d_4_3:          .dword 0xcba07e36fbfeb491, 0x5b5732dde2073154
d_4_4:          .dword 0x8d4a51a0de06e949, 0xb8a847c1fd92ed0f
d_4_5:          .dword 0x971e14f13873457e, 0x276141a0566d4cd4
d_4_6:          .dword 0xb355156b31ab969b, 0xb21dcb357cee3a04
d_4_7:          .dword 0x2b9331a4e03cabf4, 0x47e7e0a1d8c7dd4d
d_4_8:          .dword 0xd9fb005afc33986b, 0x0244f817e5a47991
d_4_9:          .dword 0x7de7ba59536a6bde, 0x8fa274428b34fb83
d_4_10:         .dword 0x15a6578005cb77a4, 0xe7ab7bdd9c3e1f94
d_4_11:         .dword 0xbe17b6649fce0533, 0xc863ab340a8f15b9
d_4_12:         .dword 0x852dffef169753d2, 0xc8635a10d62de4d9
d_4_13:         .dword 0xf315b573cdba5e64, 0x2651c49babab9777
d_4_14:         .dword 0xb1507df56c28b901, 0x6088d80879047f53
d_4_15:         .dword 0x0e7d7043285f98b6, 0x0bcfead9920dcd83
d_4_16:         .dword 0x380ba34e366afa27, 0x676b770354b3b587
d_4_17:         .dword 0x76bfd28c3f4b48e8, 0xcf4e2038de8f4b03
d_4_18:         .dword 0x60c70d26c76940de, 0x8814561951624d1d
d_4_19:         .dword 0xd13ddc7a3e993098, 0xda123b71ff6a9f9d
d_4_20:         .dword 0x54fdfbb12789bdb2, 0xb0e39677e9f3c218
d_4_21:         .dword 0x90f66b620d199181, 0x0e9c6408019c4103
d_4_22:         .dword 0x81ece4b3cb9198f8, 0x5278f04451824701
d_4_23:         .dword 0x02e567dfdb35c262, 0xce85d18c667a9ecd
d_4_24:         .dword 0x65266010a7179133, 0xdc3718608d662ee8
d_4_25:         .dword 0x89a558cce705ebe3, 0xd1441df6e1433a6e
d_4_26:         .dword 0xe827686ec81be8c7, 0xa475169e98ea344d
d_4_27:         .dword 0xedde3670c6754094, 0x30dc591da53467d9
                .dword 0xf243162a70f9b30b, 0xfe13b785075ae440
                .dword 0x164a1b5c1f697536, 0x149b50a30eec6d4f
        /* Random data */
_end_data4:


    .section .data.random5;
    .align  8;

_random_data5:
                .dword 0xee93ebcb1c573104, 0x712dcaa7004c7d3c
                .dword 0x86eec6371e96829f, 0x24f966606a102775
d_5_0:          .dword 0x6e95ab3db03d0b39, 0x2069755d63ac7d0a
d_5_1:          .dword 0x9ec0871f19cf1b37, 0xf82719476c6093d2
d_5_2:          .dword 0x5551e33c5731943d, 0xc51f8154fb56fb74
d_5_3:          .dword 0x194e931706e77b19, 0xea83891139609bdd
d_5_4:          .dword 0x0cd3266dcb24b10e, 0x64a02519414d5687
d_5_5:          .dword 0x613e0940bdc8e4d7, 0x76dd3a1fe4e5d2e3
d_5_6:          .dword 0x89bcfc93ef145233, 0x4719f4ef9661afc9
d_5_7:          .dword 0xf8a51e4028f821a7, 0xfb886f040a49215f
d_5_8:          .dword 0x3686f87d5d2b3522, 0xeceeddab0b0a9bf7
d_5_9:          .dword 0xf9612a96322cf4ce, 0xf2830ef11a49d9ba
d_5_10:         .dword 0x45e25e8313db9687, 0x56b1fa2a97d5566b
d_5_11:         .dword 0x110e3372c885db23, 0xc4d4d3440e70311a
d_5_12:         .dword 0x5b31def5f7d44fac, 0xc81052869b722788
d_5_13:         .dword 0x6287d8bf59170b29, 0xa94b8c29e02fbc7c
d_5_14:         .dword 0x2d8a8dc69e18d71e, 0x094a405c4cba5651
d_5_15:         .dword 0x0560596d7fb49ade, 0xb09c70fe43b03601
d_5_16:         .dword 0xacfee44eabaf38c7, 0x8b497a7df73382d1
d_5_17:         .dword 0xa7cf30213525d678, 0x2040b33773063efb
d_5_18:         .dword 0x398532199e738fc4, 0x17da89e400eeeac3
d_5_19:         .dword 0x83249577d2e230c9, 0x445ca3c66f6931e9
d_5_20:         .dword 0xa317df398b754993, 0x1fe1962286b37cd6
d_5_21:         .dword 0xccc91fcc999d3146, 0x2967be004419ac0e
d_5_22:         .dword 0x16a2ea948f949b50, 0x66e50fa92e66292e
d_5_23:         .dword 0x6af3f3ff97e06aec, 0xf4db29eff0b6708e
d_5_24:         .dword 0x4a3f31bf1ab90e81, 0x7facd4d74d261235
d_5_25:         .dword 0x23055b3613333659, 0x257769cd93d3306b
d_5_26:         .dword 0xd4c0b44fcdd98671, 0xafd88f96b5fc1beb
d_5_27:         .dword 0x587ebf3e8fb2f1a6, 0xbe40ecbe4363ba49
                .dword 0x6f625feeb9f50f66, 0x81d2a3498e4c8e95
                .dword 0x5fc746e5a9cf61dd, 0x1c5b6814f6bc7a82
         /* Random data */
_end_data5:
              
                 
