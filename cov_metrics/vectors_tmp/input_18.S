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
_s0:    la x3, d_1_8                              ;
        lbu x30, -16(x3)                          ;
_s1:    la x2, d_1_22                             ;
        addi x2, x2, -20                          ;
        lui x6, 0xffe00                           ;
        xor x2, x2, x6                            ;
        sc.w x9, x6, (x2)                         ;
_s2:    la x29, d_4_13                            ;
        addi x29, x29, 16                         ;
        amoxor.w x1, x15, (x29)                   ;
_s3:    la x24, d_1_14                            ;
        flw f27, 0(x24)                           ;
_s4:    sltiu x26, x11, -821                      ;
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
_p0:    csrrci x13, pmpaddr1, 1                   ;
_p1:    xor x12, x12, x12                         ;
        addi x10, zero, 1                         ;
        slli x10, x10, 26                         ;
        add x12, x12, x10                         ;
        addi x11, zero, 1                         ;
        slli x11, x11, 30                         ;
        add x12, x12, x11                         ;
        csrrw x12, sepc, x12                      ;
_p2:    la x12, _p1                               ;
        srai x12, x12, 1                          ;
        csrrs x13, pmpaddr4, x12                  ;
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
_l2:    addi x0, x1, 0                    ;
_l3:    fmin.s f5, f22, f5                    ;
_l4:    la x26, d_3_15                    ;
      addi x26, x26, 4         ;
      lr.w x17, (x26)         ;
_l5:    addi x21, x12, 8                    ;
_l6:    fsgnjn.s f11, f10, f17                    ;
_l7:    auipc x2, 919504                    ;
_l8:    la x2, d_5_2                    ;
      addi x2, x2, 20         ;
      sc.w x3, x12, (x2)         ;
_l9:    feq.s x0, f5, f2                    ;
_l10:    ori x19, x30, 418                    ;
_l11:    flt.s x3, f2, f31                    ;
_l12:    la x26, d_5_14                    ;
      addi x26, x26, 12         ;
      amomax.w x30, x8, (x26)         ;
_l13:    la x14, d_4_21                    ;
      addi x14, x14, 0         ;
      amomaxu.w x10, x14, (x14)         ;
_l14:    fcvt.lu.s x15, f1, rne                    ;
_l15:    fmv.x.w x2, f3                    ;
_l16:    la x29, d_0_20                    ;
      lb x27, 22(x29)         ;
_l17:    xor x18, x18, x18                    ;
      addi x22, zero, 1         ;
      slli x22, x22, 1         ;
      add x18, x18, x22         ;
      csrrw x29, scause, x18         ;
_l18:    la x25, d_1_1                    ;
      addi x25, x25, 0         ;
      amomax.d x11, x12, (x25)         ;
_l19:    sret                    ;
_l20:    la x28, d_1_10                    ;
      addi x28, x28, -0         ;
      amoand.d x12, x1, (x28)         ;
_l21:    la x21, d_5_25                    ;
      addi x21, x21, -16         ;
      lui x22, 0xffe00         ;
      xor x21, x21, x22         ;
      amomin.d x18, x22, (x21)         ;
_l22:    la x23, d_3_27                    ;
      addi x23, x23, 28         ;
      lr.w x14, (x23)         ;
_l23:    fmsub.s f15, f2, f28, f28, rne                    ;
_l24:    ori x0, x6, 594                    ;
_l25:    srli x28, x2, 52                    ;
_l26:    la x2, d_5_14                    ;
      sd x7, -0(x2)         ;
_l27:    andi x14, x25, 0                    ;
_l28:    uret                    ;
_l29:    la x14, _l66                    ;
      lui x15, 0xffe00         ;
      xor x14, x14, x15         ;
      ld x24, 0(x14)         ;
_l30:    slli x6, x6, 3                    ;
_l31:    xor x4, x4, x4                    ;
      addi x29, zero, 3         ;
      slli x29, x29, 23         ;
      add x4, x4, x29         ;
      csrrc x14, fcsr, x4         ;
_l32:    fcvt.l.s x23, f8, rne                    ;
_l33:    sret                    ;
_l34:    srai x21, x1, 63                    ;
_l35:    fmul.s f17, f1, f29, rne                    ;
_l36:    la x15, d_1_0                    ;
      addi x15, x15, -16         ;
      amomaxu.d x23, x25, (x15)         ;
_l37:    slli x6, x11, 6                    ;
_l38:    fmul.s f24, f24, f23, rne                    ;
_l39:    xor x16, x16, x16                    ;
      addi x8, zero, 1         ;
      slli x8, x8, 3         ;
      add x16, x16, x8         ;
      addi x18, zero, 1         ;
      slli x18, x18, 28         ;
      add x16, x16, x18         ;
      addi x30, zero, 3         ;
      slli x30, x30, 8         ;
      add x16, x16, x30         ;
      csrrs x28, sscratch, x16         ;
_l40:    feq.s x23, f8, f3                    ;
_l41:    xor x16, x16, x16                    ;
      csrrw x27, sscratch, x16         ;
_l42:    sret                    ;
_l43:    la x26, d_5_15                    ;
      fsw f23, -24(x26)         ;
_l44:    la x27, d_5_18                    ;
      flw f31, 24(x27)         ;
_l45:    sret                    ;
_l46:    csrrwi x7, satp, 31                    ;
_l47:    fcvt.s.lu f23, x15, rne                    ;
_l48:    la x18, d_5_11                    ;
      fsw f12, 28(x18)         ;
_l49:    sret                    ;
_l50:    fmax.s f3, f26, f11                    ;
_l51:    xor x3, x3, x3                    ;
      addi x16, zero, 1         ;
      slli x16, x16, 30         ;
      add x3, x3, x16         ;
      addi x15, zero, 1         ;
      slli x15, x15, 27         ;
      add x3, x3, x15         ;
      addi x17, zero, 3         ;
      slli x17, x17, 22         ;
      add x3, x3, x17         ;
      csrrw x24, sepc, x3         ;
_l52:    la x7, d_1_17                    ;
      addi x7, x7, -0         ;
      amoswap.d x28, x25, (x7)         ;
_l53:    uret                    ;
_l54:    la x10, d_1_2                    ;
      lbu x1, 4(x10)         ;
_l55:    fmin.s f29, f9, f3                    ;
_l56:    fnmsub.s f20, f24, f23, f9, rne                    ;
_l57:    fsgnjx.s f9, f2, f4                    ;
_l58:    la x8, d_4_12                    ;
      addi x8, x8, 16         ;
      lui x30, 0xffe00         ;
      xor x8, x8, x30         ;
      lr.d x4, (x8)         ;
_l59:    fdiv.s f10, f2, f8, rne                    ;
_l60:    la x7, d_1_8                    ;
      addi x7, x7, 24         ;
      amoand.d x24, x14, (x7)         ;
_l61:    la x2, d_4_2                    ;
      srai x2, x2, 1         ;
      csrrw x10, pmpaddr1, x2         ;
_l62:    srli x3, x17, 35                    ;
_l63:    la x24, d_4_21                    ;
      addi x24, x24, 8         ;
      amoand.d x10, x19, (x24)         ;
_l64:    la x24, d_0_16                    ;
      ld x10, -0(x24)         ;
_l65:    la x29, d_3_1                    ;
      addi x29, x29, -20         ;
      lui x9, 0xffe00         ;
      xor x29, x29, x9         ;
      lr.w x22, (x29)         ;
_l66:    la x21, d_1_17                    ;
      addi x21, x21, 12         ;
      amominu.w x14, x3, (x21)         ;
_l67:    la x14, d_1_7                    ;
      addi x14, x14, 0         ;
      lr.w x24, (x14)         ;
_l68:    ori x3, x21, -2047                    ;
_l69:    fnmadd.s f24, f15, f29, f9, rne                    ;
_l70:    subw x24, x27, x28                    ;
_l71:    fcvt.s.l f14, x30, rne                    ;
_l72:    fcvt.w.s x5, f27, rne                    ;
_l73:    fsqrt.s f24, f13, rne                    ;
_l74:    flt.s x19, f5, f24                    ;
_l75:    csrrwi x29, stval, 23                    ;
_l76:    sraiw x3, x16, 31                    ;
_l77:    csrrwi x11, sscratch, 7                    ;
_l78:    ori x19, x30, 418                    ;
_l79:    la x1, d_0_20                    ;
      addi x1, x1, 16         ;
      amoswap.w x30, x11, (x1)         ;
_l80:    la x16, d_3_26                    ;
      addi x16, x16, -24         ;
      amomax.w x11, x16, (x16)         ;
_l81:    fcvt.s.w f14, x29, rne                    ;
_l82:    fcvt.lu.s x21, f31, rne                    ;
_l83:    la x20, d_0_15                    ;
      lbu x3, -19(x20)         ;
_l84:    la x28, d_4_21                    ;
      addi x28, x28, 0         ;
      sc.w x2, x31, (x28)         ;
_l85:    la x18, d_2_17                    ;
      addi x18, x18, -0         ;
      amoxor.w x5, x16, (x18)         ;
_l86:    la x18, d_1_4                    ;
      addi x18, x18, 0         ;
      amominu.d x11, x27, (x18)         ;
_l87:    fcvt.w.s x17, f8, rne                    ;
_l88:    la x28, d_5_6                    ;
      addi x28, x28, 8         ;
      amoadd.d x28, x17, (x28)         ;
_l89:    la x24, d_1_8                    ;
      srai x24, x24, 1         ;
      csrrw x28, pmpaddr3, x24         ;
_l90:    la x8, _l35                    ;
      lhu x11, 14(x8)         ;
_l91:    la x26, d_5_14                    ;
      addi x26, x26, 12         ;
      amomax.w x30, x8, (x26)         ;
_l92:    srai x4, x25, 0                    ;
_l93:    fle.s x3, f17, f26                    ;
_l94:    fmsub.s f7, f16, f5, f0, rne                    ;
_l95:    fcvt.lu.s x3, f30, rne                    ;
_l96:    la x19, d_0_8                    ;
      addi x19, x19, 4         ;
      amoor.w x15, x25, (x19)         ;
_l97:    fnmadd.s f19, f4, f13, f4, rne                    ;
_l98:    la x10, d_2_19                    ;
      flw f9, 0(x10)         ;
_l99:    sraw x5, x20, x22                    ;
_l100:    srai x6, x15, 28                    ;
      addi x21, x21, -0         ;
      amoswap.d x28, x26, (x21)         ;
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
                .dword 0x05e4c2156f7ab7b5, 0x4c7a7bc4c03ba06e
                .dword 0x447335e4492366db, 0x569076e3a434d888
d_0_0:          .dword 0x31c47579c61b52ce, 0xa5de6cd5d897e8f2
d_0_1:          .dword 0xf30a8eac765bedd9, 0x90585c56c91b1f10
d_0_2:          .dword 0x53132d0df322c893, 0x5e262bec8e6010fc
d_0_3:          .dword 0x8dda926a669de024, 0x4e3b5fb3fc93f945
d_0_4:          .dword 0x1a5628f5f55361bf, 0x0a380b9414967d50
d_0_5:          .dword 0x827386e3b4520296, 0x09983689b5e85bda
d_0_6:          .dword 0x39f671cc8e0e3476, 0x81d1a0e2c0b7e68d
d_0_7:          .dword 0x5d8381f18d0018cd, 0x8e39f760c93a6d56
d_0_8:          .dword 0x399498be6956028e, 0x8c256bf47e656a30
d_0_9:          .dword 0x72dca7eea94b8a49, 0x66226d32da09a173
d_0_10:         .dword 0x1ab9c8849951f049, 0xbafc9b6331ddc7d2
d_0_11:         .dword 0x24548c08189f2d21, 0xd048b3145301eb42
d_0_12:         .dword 0x735c2b3d8cc39845, 0xab311d8ee777c31c
d_0_13:         .dword 0x7ab9653f7ed8b734, 0x5aac00f89f906baf
d_0_14:         .dword 0x4bd4c07b46396dd6, 0xfee5eb2edb3c6ac0
d_0_15:         .dword 0x6833cefd1e20f39d, 0x4c7ab29ccbae7c20
d_0_16:         .dword 0x3ccee8205d65d903, 0x611b971d9bf79885
d_0_17:         .dword 0xc3981479a9822f9b, 0x4430a3f0b8df6e3f
d_0_18:         .dword 0x72bf3be29360a4be, 0xc9bd6bd938ea4869
d_0_19:         .dword 0x0a5306082d35291f, 0xf62720160b91ffac
d_0_20:         .dword 0xddffa3f9aceb649c, 0xea59bf35a32a263c
d_0_21:         .dword 0x7bf20aa866fbbd5c, 0x842cb93319c54d89
d_0_22:         .dword 0x65b9f874871642ba, 0x07ba1cee01ecd824
d_0_23:         .dword 0x8417a56ea3060fa1, 0x0d30219bb297ba02
d_0_24:         .dword 0x5f5544c621a561d8, 0xf6a6d4ade5fa1a23
d_0_25:         .dword 0xddbddd78df5af8b1, 0x709d49d4c41142d9
d_0_26:         .dword 0xab13a1bdb934c992, 0x6e0885bd27f4ffbf
d_0_27:         .dword 0x83bd102f1f0eaf7a, 0x57943eb987c3e0d9
                .dword 0xaa59cb83965c175e, 0x22933e7d47801eeb
                .dword 0x227b747cfab33773, 0x7ce2233487fc393e
        /* Random data */
_end_data0:
                 

    .section .data.random1;
    .align  8;

_random_data1:
                .dword 0x3f689a164962d2c9, 0x7549189cddf3aa77
                .dword 0x4f10704fcca2de5b, 0x432933daa8937d45
d_1_0:          .dword 0xb4170fee5f90d86d, 0xb01b9b71aea62e27
d_1_1:          .dword 0x7b2ba2b55dda0c49, 0x114b2858baece53b
d_1_2:          .dword 0xd75defccd5b7540f, 0x4dbd87789e8dcff8
d_1_3:          .dword 0x0a64d9c57c0a06e2, 0xfe900903343aa9c5
d_1_4:          .dword 0x51a68c3ba5e1ebbe, 0x36a26369688b2844
d_1_5:          .dword 0x7f67afbb7264c153, 0x75a44d234f04639b
d_1_6:          .dword 0xf65838f9d76b5744, 0xfaa56f642fbd3827
d_1_7:          .dword 0xc808de3140b48a8d, 0x0eb08d74da5a527f
d_1_8:          .dword 0xdd48be9b7573fea5, 0x3d73718ef3349348
d_1_9:          .dword 0xae7d7d7b541d5d4c, 0x927fdf0262a2e003
d_1_10:         .dword 0x098f4a9ce245ed1c, 0xa09550bb93c8a84a
d_1_11:         .dword 0x08cee722c18f8be9, 0xd1610f0cba7498ed
d_1_12:         .dword 0x4a4708f5c1a6cb9d, 0x4f535452ef78c21f
d_1_13:         .dword 0x0509526901c8c6d1, 0x4fce599ac89100a0
d_1_14:         .dword 0x4af220895ee0b460, 0x779023b0011e98e2
d_1_15:         .dword 0xa791811aa25adba2, 0xa1e9e1d14691b856
d_1_16:         .dword 0x5f93184f200f6a43, 0x25b4ede9adede67a
d_1_17:         .dword 0xf27feafe12c52778, 0x70ea3c9c232d3a91
d_1_18:         .dword 0xecad89c055afbbf1, 0x401cce6ed940dcdc
d_1_19:         .dword 0x9fc4c740baa26696, 0xee4961cd2548efa5
d_1_20:         .dword 0xa45f55713dd56a96, 0x4bfbc433c942915f
d_1_21:         .dword 0x37b370e891c5f01d, 0x38568162e442c402
d_1_22:         .dword 0x26fd9b31456267f5, 0xc4980c769a824e34
d_1_23:         .dword 0x94078fcc5341da15, 0x849187c0c8e51424
d_1_24:         .dword 0xe109760ffd47ae2b, 0x5d67998e6300d3eb
d_1_25:         .dword 0x7b55aecdf3a62e4c, 0xc5cc08577e2b11ea
d_1_26:         .dword 0x591287648d3d5313, 0x89204cd05ef671ec
d_1_27:         .dword 0xcf2b808b2c25c173, 0x13d09e530884c8c0
                .dword 0xeaab3d832aa7a3bf, 0x99f7ad79368f3ac3
                .dword 0xf2e0c8f766ad040c, 0x9ce9dfcd56368a68
        /* Random data */
_end_data1:


    .section .data.random2;
    .align  8;

_random_data2:
                .dword 0x36587b492007ec6b, 0x0bda314590f0c21b
                .dword 0xad2368b5b0d1df7e, 0x472b1d4b71d6adcb
d_2_0:          .dword 0xe2b27083f3925e1f, 0xc7b3a114ffbe67f1
d_2_1:          .dword 0x235e06df6a703f4b, 0xc2cd4db06be397c1
d_2_2:          .dword 0x66e31c7c3562102c, 0x4ef30c45a80b33cb
d_2_3:          .dword 0x9158fc31908c19bb, 0x6fea438b461cd9a0
d_2_4:          .dword 0x1ac9259c94e3b4a3, 0xea3d866dabefabca
d_2_5:          .dword 0xef2f8d0640273adb, 0x61c133244b24ba9b
d_2_6:          .dword 0xb849d0fc34a00698, 0x8b1c70274b25c762
d_2_7:          .dword 0x2701798e42db3ee2, 0x9669b29b93a3cd60
d_2_8:          .dword 0x5651802d72e49eef, 0xdcdfaf47162f4554
d_2_9:          .dword 0x1fcf1d4d0fa7dbec, 0x4a0628f67684cd14
d_2_10:         .dword 0xec6be78eec1b64c1, 0x98dfae111a2fd304
d_2_11:         .dword 0xd48085c6cdd00f97, 0x4af80bbed17474d1
d_2_12:         .dword 0x1b9ab47bfa42ebb8, 0x38e7035ab2324610
d_2_13:         .dword 0x56016fe32e030e2f, 0xd46bc4b114feca22
d_2_14:         .dword 0x0957ddc1c32608e6, 0xbf77c33e8e02f9bd
d_2_15:         .dword 0xd409141cdf665e29, 0xba15f0b78b214e85
d_2_16:         .dword 0xf2f681f206612a84, 0x32fc20e7df89539d
d_2_17:         .dword 0x89fc650bd71db9c2, 0xc2b13f6f5e07d755
d_2_18:         .dword 0xe43efd73f107d430, 0x150196738bc8a7c6
d_2_19:         .dword 0x167628201ceb995c, 0x92fef884bb02a8d9
d_2_20:         .dword 0x6a1b3dc6bed95cb1, 0x2c2712d9ff6f43fb
d_2_21:         .dword 0xa5f445715e0569da, 0x6a51997df955de9c
d_2_22:         .dword 0x81840015a79978c9, 0x24483325fe03f2fa
d_2_23:         .dword 0x5de4fbd80b96a8fd, 0xff88f46c44363538
d_2_24:         .dword 0xcf2f8faca06b0c12, 0x98542ebc3b062f1f
d_2_25:         .dword 0x50a4c7a338f52448, 0xf9833818eb9e50a2
d_2_26:         .dword 0x7b1dd7369563f280, 0x06d1e0111ad78e5f
d_2_27:         .dword 0xc632fbb3831eb5b6, 0xf9a6ed501701838d
                .dword 0x938a801670a37b01, 0x943f04c54e5e1e33
                .dword 0xb6995f40a87252f9, 0x755f8f0a6b01beba
         /* Random data */
_end_data2:
                

    .section .data.random3;
    .align  8;

_random_data3:
                .dword 0xf34a64353df88a2f, 0xe5592bf9ffae8653
                .dword 0xe1ff67cf7288af46, 0xab332d26ec3715ad
d_3_0:          .dword 0x51522e1ccd85fe4f, 0xf55ba8d504f3e81f
d_3_1:          .dword 0xdc0a24568a5070a9, 0xddf6725e09128b51
d_3_2:          .dword 0x24ef11464b4348e9, 0x080f0b554b457be7
d_3_3:          .dword 0xfe47ab50ff99c2e6, 0x3f1a8d8427f77c4d
d_3_4:          .dword 0x816711db8ec445fd, 0x546ba76133bedfae
d_3_5:          .dword 0xf91d5bc267489386, 0x7323a01cdbc259ea
d_3_6:          .dword 0x1c013fa7065216f7, 0x01b831780df1e8b5
d_3_7:          .dword 0x55b32ba7670f5aa0, 0x32766697f4849403
d_3_8:          .dword 0x39b500520a77604f, 0x371614bf5e9fcd46
d_3_9:          .dword 0xd647dd108876afc3, 0x4347d3c108728a59
d_3_10:         .dword 0x2405f14732923b36, 0x34928a3a3e2b4a66
d_3_11:         .dword 0x3b98c762d713db9b, 0x85bc879b8c0bbc59
d_3_12:         .dword 0xc615dfbf19ffd2ac, 0x367a40e3413e5403
d_3_13:         .dword 0xdb0548711deda812, 0x108fdaa1a0497164
d_3_14:         .dword 0x91aed730da429304, 0x157d13a04c84ca52
d_3_15:         .dword 0x711ec4fa0e27e569, 0x8dc565c0c4132386
d_3_16:         .dword 0xdbc65b516ff58c71, 0xa270369a3eefc63b
d_3_17:         .dword 0x6e56edff87c8c75a, 0x7f81a70a0ad4431c
d_3_18:         .dword 0xeb48c550fe0f7135, 0x3cc101472db29831
d_3_19:         .dword 0x7b3670bb526f052b, 0x8cb092a79ef8944d
d_3_20:         .dword 0x75ca37b0285e62ec, 0xc47a59b8a6e5c234
d_3_21:         .dword 0xcf36f135e0208d15, 0xd6421f8d3330adf0
d_3_22:         .dword 0x0e98273e6fb6c95b, 0x64f532ace5936dc7
d_3_23:         .dword 0x763d91fff2c00b2f, 0xa9a74c96decd2061
d_3_24:         .dword 0x95df39c6b9f9bc83, 0x680507a949151450
d_3_25:         .dword 0xf3520e54e6115a1b, 0x20159856f57dc646
d_3_26:         .dword 0xe3e158978af54cac, 0xce15fc7285a92c3c
d_3_27:         .dword 0x04860de69992e80f, 0xded5b0117211ee74
                .dword 0x033fab606ff65d9e, 0xe66b8944ec326770
                .dword 0x9ddb51c9a49b88e3, 0x5239690937f2188f
        /* Random data */
_end_data3:


    .section .data.random4;
    .align  8;

_random_data4:
                .dword 0x63ae5dfa910b47b6, 0x26f5488be7f9453e
                .dword 0x7e94107706d871c0, 0x92d1dab6f4c180fb
d_4_0:          .dword 0x30b94f793c6e2147, 0xc0b2231bcd2179d0
d_4_1:          .dword 0xe42a7c846eddfd70, 0x96fab3aaadd8befc
d_4_2:          .dword 0x6d008520cec9edd4, 0x503ff0f690b42f44
d_4_3:          .dword 0x7ccf70adb5c58ca0, 0x9580dde65e6c7c04
d_4_4:          .dword 0x48f9a79944a4b929, 0x570756cbd0c0a8ab
d_4_5:          .dword 0xdca8d21bf685a032, 0x879474a817c91f89
d_4_6:          .dword 0xfcd3007025a0babb, 0xfb88ff49a0b6a91c
d_4_7:          .dword 0x49440f57991a41f9, 0xf6ab0d38f6f842ed
d_4_8:          .dword 0xcf55ab6ae78b312e, 0xa6410cdcb6967624
d_4_9:          .dword 0x552ba59504331ae8, 0x4105c42f7c8350af
d_4_10:         .dword 0x215f6246e04f4ff8, 0xf2639c1051f53e97
d_4_11:         .dword 0x0e7960f321fa4c80, 0x9c40c0f8340d5143
d_4_12:         .dword 0xffe9a1b11df7cd15, 0xf763ec6afa18dbe7
d_4_13:         .dword 0x1c7c33db33ffa411, 0xd2d1b4ef0da84f18
d_4_14:         .dword 0xf8ab65bf3162e50d, 0xd14e80cb03a5c0dc
d_4_15:         .dword 0xa9e517a7d1df4ac7, 0x23d56dc3d48e7641
d_4_16:         .dword 0x35009802e15167e3, 0xc4b36050f02aaea5
d_4_17:         .dword 0xf62c692639658c1f, 0xfbbe3f5693bbaa88
d_4_18:         .dword 0x818200f6a6dbf1dd, 0x394f9b173b25c12b
d_4_19:         .dword 0xa2119e49957edc3b, 0x99d0a954724ffa5f
d_4_20:         .dword 0x89875e574eaab213, 0x69786e9726be75b4
d_4_21:         .dword 0x3e9a2b3145b57b22, 0x78264b7b1b942d73
d_4_22:         .dword 0xd0cb669abafd1ab7, 0xef080bd110bcafad
d_4_23:         .dword 0x7c2ea2ee0a2ef4cc, 0xa3fd3f80d8fe08e1
d_4_24:         .dword 0x635b8a69d96d59bc, 0x3df623af2b46e4c6
d_4_25:         .dword 0x5d6e9373580f8d98, 0x91108b6712664785
d_4_26:         .dword 0xa2360c1cfe0dda20, 0x74c23e46cc4fb689
d_4_27:         .dword 0xec58b8e7a7571e0f, 0x8c470e9c5d27c819
                .dword 0xdb36ab3c1cb9833d, 0xa884d40100d8505b
                .dword 0xe52591273f657c35, 0xf0d09be4561dd444
        /* Random data */
_end_data4:


    .section .data.random5;
    .align  8;

_random_data5:
                .dword 0x56798a0484d95773, 0x1bf2eeeed56ff8b7
                .dword 0x595e80ce87d96cfd, 0x638e580d71c7972f
d_5_0:          .dword 0x3eca6b8ce315efa7, 0x4b47778a0f0fd5bb
d_5_1:          .dword 0xf727a084708f348d, 0x08f2b63ecb2e5079
d_5_2:          .dword 0x2c6151a4e2f77825, 0xe21cd6171d3b5a92
d_5_3:          .dword 0x5faa87b5c0ba7bd8, 0x4fdd14e8de5419e4
d_5_4:          .dword 0x0994c6d604507ebc, 0x7d514ee7d3f1d989
d_5_5:          .dword 0xa1f4969ff20f8ee0, 0x7f051ec217d03505
d_5_6:          .dword 0x4c053338f4de3c9b, 0xc97728707e8904e2
d_5_7:          .dword 0xac8cc5b9ff957726, 0x36e3cf4cf9283e2e
d_5_8:          .dword 0xa73a42d1a1e3da84, 0x44179dac6034da38
d_5_9:          .dword 0xa318d448d500f522, 0x83dd1006ca5faded
d_5_10:         .dword 0x562733f569632742, 0x479c5ca37ba653a4
d_5_11:         .dword 0x06b687f66976fdfd, 0xcdb0f74cce6d20f0
d_5_12:         .dword 0x907492e23a1ec6aa, 0xb1f53e5b337182f0
d_5_13:         .dword 0x4b23818cccb7dbd0, 0xf235fe9112eaecda
d_5_14:         .dword 0x3f03f14de0e4b5f0, 0x215f96d4271ae68c
d_5_15:         .dword 0x244ec404cfda03e2, 0x61e79f5d3e158e43
d_5_16:         .dword 0xbfa5e332de757429, 0x03273ec8afb60577
d_5_17:         .dword 0x1c69a4e4d353e929, 0x4e1aad1691dca895
d_5_18:         .dword 0x2ea3adbbdee93dbc, 0xabd74e9c16dc79b3
d_5_19:         .dword 0x0f3143269d4eb601, 0xe043c2f581124ac0
d_5_20:         .dword 0x7d0fec2997812564, 0x7f6a0da8395b06f4
d_5_21:         .dword 0xa666ec8214bad3ea, 0xab7f959072bb2120
d_5_22:         .dword 0x834d613f6cf719bf, 0xa7a98bda1b9c9d34
d_5_23:         .dword 0xd77c128f562f6832, 0xabe8ad9663dbe849
d_5_24:         .dword 0x1a7e50f3e58fe1e5, 0xfd93b4cef27a60f2
d_5_25:         .dword 0xc2e9e6fee76a7681, 0xbdfc1bb26ed48f93
d_5_26:         .dword 0xc2c8ff9ff0e9392a, 0x87538e477e01ffe0
d_5_27:         .dword 0xa5b62160c57ac854, 0x707b1e3b58e8c111
                .dword 0x26434f807be8dba4, 0x32b6c9d94ca155e2
                .dword 0x60b5130bfa03e00f, 0x596f7d6f2d628b70
         /* Random data */
_end_data5:
              
                 
