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
_p0:    xor x10, x10, x10                         ;
        addi x14, zero, 3                         ;
        slli x14, x14, 27                         ;
        add x10, x10, x14                         ;
        csrrc x14, frm, x10                       ;
_p1:    la x10, d_4_22                            ;
        srai x10, x10, 1                          ;
        csrrc x12, pmpaddr3, x10                  ;
_p2:    la x14, d_1_11                            ;
        srai x14, x14, 1                          ;
        csrrc x12, pmpaddr2, x14                  ;
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
_l0:    la x28, d_3_26                    ;
      sw x8, 24(x28)         ;
_l1:    la x25, d_2_2                    ;
      addi x25, x25, -4         ;
      amoor.w x10, x21, (x25)         ;
_l2:    addi x0, x1, 0                    ;
_l3:    la x17, d_4_13                    ;
      lhu x6, -30(x17)         ;
_l4:    addi x0, x1, 0                    ;
_l5:    fmv.x.w x22, f10                    ;
_l6:    fle.s x17, f26, f1                    ;
_l7:    fsqrt.s f24, f26, rne                    ;
_l8:    slti x15, x11, 1297                    ;
_l9:    fmv.w.x f12, x10                    ;
_l10:    la x13, _l7                    ;
      lw x27, 16(x13)         ;
_l11:    fcvt.l.s x17, f27, rne                    ;
_l12:    la x28, d_5_22                    ;
      addi x28, x28, 16         ;
      amoswap.d x22, x14, (x28)         ;
_l13:    xor x9, x9, x9                    ;
      addi x2, zero, 3         ;
      slli x2, x2, 4         ;
      add x9, x9, x2         ;
      csrrc x7, sepc, x9         ;
_l14:    addi x0, x1, 0                    ;
_l15:    la x26, d_4_25                    ;
      addi x26, x26, 0         ;
      amoswap.w x11, x22, (x26)         ;
_l16:    la x14, d_5_20                    ;
      lbu x5, 21(x14)         ;
_l17:    fsgnjn.s f22, f30, f21                    ;
_l18:    la x2, d_0_9                    ;
      addi x2, x2, 12         ;
      amoor.w x2, x17, (x2)         ;
_l19:    sraw x16, x28, x11                    ;
_l20:    fcvt.s.lu f8, x10, rne                    ;
_l21:    srai x15, x10, 6                    ;
_l22:    fcvt.s.l f27, x12, rne                    ;
_l23:    fcvt.s.lu f26, x15, rne                    ;
_l24:    la x15, d_0_4                    ;
      addi x15, x15, 8         ;
      amoand.d x10, x15, (x15)         ;
_l25:    la x21, d_1_26                    ;
      addi x21, x21, -0         ;
      amoand.d x1, x2, (x21)         ;
_l26:    fsqrt.s f24, f13, rne                    ;
_l27:    la x7, d_5_18                    ;
      addi x7, x7, -16         ;
      amoor.d x9, x6, (x7)         ;
_l28:    la x2, d_5_21                    ;
      flw f12, -12(x2)         ;
_l29:    fsqrt.s f31, f26, rne                    ;
_l30:    la x19, d_3_22                    ;
      lh x26, -28(x19)         ;
_l31:    la x26, d_0_13                    ;
      addi x26, x26, -0         ;
      lr.w x20, (x26)         ;
_l32:    la x30, d_5_24                    ;
      lh x26, -8(x30)         ;
_l33:    la x4, d_3_9                    ;
      addi x4, x4, -0         ;
      amoor.d x11, x11, (x4)         ;
_l34:    sraiw x3, x16, 31                    ;
_l35:    fle.s x3, f17, f26                    ;
_l36:    la x9, _l91                    ;
      lbu x19, 8(x9)         ;
_l37:    xor x11, x11, x11                    ;
      addi x20, zero, 1         ;
      slli x20, x20, 29         ;
      add x11, x11, x20         ;
      addi x20, zero, 3         ;
      slli x20, x20, 4         ;
      add x11, x11, x20         ;
      addi x13, zero, 3         ;
      slli x13, x13, 6         ;
      add x11, x11, x13         ;
      csrrc x15, sepc, x11         ;
_l38:    fmsub.s f2, f8, f23, f29, rne                    ;
_l39:    la x29, d_3_16                    ;
      addi x29, x29, 16         ;
      amominu.d x11, x16, (x29)         ;
_l40:    la x4, d_1_2                    ;
      addi x4, x4, 0         ;
      amoand.d x22, x20, (x4)         ;
_l41:    la x10, d_1_27                    ;
      addi x10, x10, 16         ;
      amomin.w x19, x20, (x10)         ;
_l42:    la x24, d_1_10                    ;
      lbu x27, 0(x24)         ;
_l43:    fclass.s x22, f8                    ;
_l44:    la x28, d_3_1                    ;
      flw f19, -4(x28)         ;
_l45:    lui x14, 636                    ;
_l46:    fmv.w.x f13, x25                    ;
_l47:    xori x19, x6, -0                    ;
_l48:    la x18, d_1_24                    ;
      srai x18, x18, 1         ;
      csrrw x24, pmpaddr0, x18         ;
_l49:    auipc x8, 9                    ;
_l50:    srli x28, x2, 52                    ;
_l51:    fmadd.s f13, f14, f23, f12, rne                    ;
_l52:    la x11, d_2_3                    ;
      lui x29, 0xffe00         ;
      xor x11, x11, x29         ;
      sh x25, -12(x11)         ;
_l53:    ori x0, x6, 594                    ;
_l54:    la x15, d_2_18                    ;
      addi x15, x15, 0         ;
      sc.d x30, x15, (x15)         ;
_l55:    srlw x30, x17, x10                    ;
_l56:    ori x19, x30, 418                    ;
_l57:    fadd.s f10, f24, f1, rne                    ;
_l58:    slliw x22, x23, 19                    ;
_l59:    la x17, d_1_12                    ;
      addi x17, x17, 4         ;
      lr.w x16, (x17)         ;
_l60:    fclass.s x5, f23                    ;
_l61:    la x12, _l78                    ;
      lh x10, -26(x12)         ;
_l62:    la x9, d_4_24                    ;
      addi x9, x9, 0         ;
      amomin.w x3, x3, (x9)         ;
_l63:    sret                    ;
_l64:    fsgnjx.s f22, f14, f22                    ;
_l65:    fsgnjn.s f10, f11, f15                    ;
_l66:    fmin.s f24, f29, f3                    ;
_l67:    la x5, d_0_11                    ;
      srai x5, x5, 1         ;
      csrrw x25, pmpaddr4, x5         ;
_l68:    fmul.s f22, f19, f27, rne                    ;
_l69:    fmsub.s f17, f31, f8, f3, rne                    ;
_l70:    xor x8, x8, x8                    ;
      addi x20, zero, 3         ;
      slli x20, x20, 2         ;
      add x8, x8, x20         ;
      addi x14, zero, 1         ;
      slli x14, x14, 22         ;
      add x8, x8, x14         ;
      addi x5, zero, 3         ;
      slli x5, x5, 24         ;
      add x8, x8, x5         ;
      csrrs x6, sstatus, x8         ;
_l71:    fcvt.s.lu f18, x14, rne                    ;
_l72:    flt.s x20, f18, f26                    ;
_l73:    srlw x2, x24, x15                    ;
_l74:    la x11, d_5_21                    ;
      addi x11, x11, -16         ;
      amoswap.d x12, x11, (x11)         ;
_l75:    la x24, d_4_0                    ;
      lh x2, 10(x24)         ;
_l76:    auipc x0, 608170                    ;
_l77:    fnmadd.s f0, f16, f24, f11, rne                    ;
_l78:    la x26, d_5_14                    ;
      addi x26, x26, 12         ;
      amomax.w x30, x8, (x26)         ;
_l79:    la x2, d_1_18                    ;
      lb x25, 0(x2)         ;
_l80:    la x3, d_5_27                    ;
      lh x14, -2(x3)         ;
_l81:    fcvt.w.s x17, f11, rne                    ;
_l82:    fsgnjx.s f17, f21, f22                    ;
_l83:    la x15, d_2_8                    ;
      sw x9, -12(x15)         ;
_l84:    la x30, d_0_25                    ;
      addi x30, x30, 8         ;
      lr.d x1, (x30)         ;
_l85:    srlw x28, x6, x5                    ;
_l86:    la x15, d_4_22                    ;
      fsw f6, -0(x15)         ;
_l87:    fnmadd.s f5, f6, f22, f0, rne                    ;
_l88:    la x5, d_3_10                    ;
      addi x5, x5, 0         ;
      lr.d x24, (x5)         ;
_l89:    subw x15, x21, x28                    ;
_l90:    la x26, d_1_19                    ;
      addi x26, x26, 28         ;
      amoswap.w x9, x2, (x26)         ;
_l91:    csrrci x24, pmpaddr3, 10                    ;
_l92:    la x2, d_5_14                    ;
      addi x2, x2, -24         ;
      amoswap.w x4, x4, (x2)         ;
_l93:    fsub.s f14, f8, f19, rne                    ;
_l94:    fnmsub.s f21, f22, f7, f1, rne                    ;
_l95:    la x23, d_1_11                    ;
      addi x23, x23, 24         ;
      amoxor.d x6, x10, (x23)         ;
_l96:    la x27, d_4_2                    ;
      addi x27, x27, 8         ;
      sc.d x21, x27, (x27)         ;
_l97:    sltiu x21, x8, -214                    ;
_l98:    la x3, d_3_13                    ;
      sw x5, 20(x3)         ;
_l99:    la x15, d_4_1                    ;
      sb x19, 7(x15)         ;
_l100:    la x4, d_0_1                    ;
      addi x4, x4, -16         ;
      amoor.w x30, x30, (x4)         ;
      sw x5, -4(x8)         ;
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
                .dword 0x7ed8153e1f262740, 0xc8a795ad23ee60e6
                .dword 0xdcf0b4a694ac2e2c, 0xd0303c2aca45d96d
d_0_0:          .dword 0xd2af4af7392d91ff, 0x8096598eb785b41f
d_0_1:          .dword 0x5891a49e00ba0a14, 0xb3c074f9039cc86e
d_0_2:          .dword 0x31267e101257588b, 0x51da9aa7eb127ec3
d_0_3:          .dword 0x44f99180350b8e6c, 0xa1e660d54bdc6860
d_0_4:          .dword 0x294001af0f9c6163, 0x36578755d495a00f
d_0_5:          .dword 0xd48b4f538cd6cd8d, 0x96cebf0703623954
d_0_6:          .dword 0xa5c5c92564ff412a, 0xe1e7415c532b1c72
d_0_7:          .dword 0x4269687b50d6915d, 0x26b9df7269d71094
d_0_8:          .dword 0x6c662d8a22405de7, 0x468fe2e559b29ca7
d_0_9:          .dword 0xb4725bebf8432898, 0x90d7f0486b555295
d_0_10:         .dword 0x9e49e9e1d20b024f, 0x913f041ed57b28d9
d_0_11:         .dword 0x79abd4f126fb1635, 0x85474e4c1c30a5ca
d_0_12:         .dword 0x9282d32293700ae3, 0xc9bce72a7d7f8ea1
d_0_13:         .dword 0xdf4fa3a234b3612c, 0xcdbeeb16de6a9e01
d_0_14:         .dword 0x3d8c098b1a67fe1e, 0xe23878a308344bd6
d_0_15:         .dword 0x343e4ab2266a2b9e, 0xf7162c574adf9d8b
d_0_16:         .dword 0xfe422305b89adb75, 0x8877997293a2f3a9
d_0_17:         .dword 0x59978de8b6fba0b1, 0x9ceadfa69e31ef5d
d_0_18:         .dword 0x400bebb23b49fa41, 0x57b0bf0f213ec9a8
d_0_19:         .dword 0xec52c633432183ff, 0x7c44607866aab6b8
d_0_20:         .dword 0xd4107905d73c4d33, 0x78fff92db67a227a
d_0_21:         .dword 0x2b4b904153f779b3, 0xecfdac7e1d01bce5
d_0_22:         .dword 0x321bad4af0130b01, 0x2d471a74f4fea655
d_0_23:         .dword 0xf482097b5c54893d, 0x70838ca9113d7dfb
d_0_24:         .dword 0x603aa88777418e66, 0xaaf29e0a4110942b
d_0_25:         .dword 0xe3de2af31e5a4375, 0xc05190851724c478
d_0_26:         .dword 0x92398a315246700c, 0x345f7c4759c92363
d_0_27:         .dword 0x0fcbfc730841c1be, 0xe27a36038d161556
                .dword 0x21b25d32eefd7d93, 0x619ef34eda6e05d2
                .dword 0xd8edaab7e079a8e1, 0x4cc4241ca19b34df
        /* Random data */
_end_data0:
                 

    .section .data.random1;
    .align  8;

_random_data1:
                .dword 0xaf2a07e4612a7d79, 0x0bc2ce31a1c6f6e9
                .dword 0xa25729bd3bd4efa2, 0xab33c29a6d7faec3
d_1_0:          .dword 0x69c686b205e107b8, 0xaaf34b369490f0b3
d_1_1:          .dword 0x5eb4af999f8e8055, 0x3c319500a354462f
d_1_2:          .dword 0xa95718eb1565641d, 0xb43541dca2e4f89c
d_1_3:          .dword 0xf485bc4f6180acfb, 0x48b8de33558ac101
d_1_4:          .dword 0x3b7796a575feba93, 0x0c7d74cf7404ba29
d_1_5:          .dword 0xc2d6fa2a053843d9, 0xa763cd82bf2d537d
d_1_6:          .dword 0xc451e8a8b7386b65, 0xaa6b82556f03b2e0
d_1_7:          .dword 0x4f7037738ae3603e, 0x117627ddc8241dde
d_1_8:          .dword 0xfeb09386c2186ed9, 0xb590c7197863966e
d_1_9:          .dword 0xd4d320644cd5d3d4, 0x1a1e967326d66ad9
d_1_10:         .dword 0x3a6de5f1f2095763, 0x2155336d1b0b5473
d_1_11:         .dword 0xf718d9d3ed6dcfdc, 0x23601cc68496be15
d_1_12:         .dword 0xbbd091d1c366f8c5, 0xd69d6b3d585c42b6
d_1_13:         .dword 0xaafd6b75ef4f4eb5, 0x85cb12c8c43488b7
d_1_14:         .dword 0xb870d3040c09474a, 0xa8a4bf4cdc7105e2
d_1_15:         .dword 0x42a37e87c15ead2d, 0x601bc0d72374bed9
d_1_16:         .dword 0x5f1a6863495821c3, 0x8dfae3e7a1363450
d_1_17:         .dword 0x8a7bebd9a59b638e, 0xadedd6b569d26ffb
d_1_18:         .dword 0x71e971f94c54e517, 0x24fceb39a97b8529
d_1_19:         .dword 0x593e80d8b579e3d2, 0x4d0b23a188a73a79
d_1_20:         .dword 0x5c28b09ef5ac3a04, 0xccef386cb21fedd0
d_1_21:         .dword 0x1fb339994504ef10, 0x171c5da3c34567ca
d_1_22:         .dword 0x6f6cbb7f2be5a16f, 0x7b0b90d366685085
d_1_23:         .dword 0x6f590583854be0c8, 0x4b7308fb5f5bc15a
d_1_24:         .dword 0xeff5d7fa0c50d643, 0xf1fc552b861e1cd0
d_1_25:         .dword 0x7eb4149d7843a6dc, 0x3a3393a3c58555a5
d_1_26:         .dword 0xbabeecb2e219f0a5, 0xffd5ac05edc6e9b8
d_1_27:         .dword 0x236074b91cb6cd79, 0x5b75987b630124c5
                .dword 0xb89d15612f712e3b, 0xd51e36c0fd2bf91b
                .dword 0x959f85e28b7df020, 0xc1081b042922e1c5
        /* Random data */
_end_data1:


    .section .data.random2;
    .align  8;

_random_data2:
                .dword 0x8a5fbff341165060, 0x864f3a5f68f29fa6
                .dword 0x149a5c74522eec4f, 0x0e46f111aabd0db8
d_2_0:          .dword 0xaa33a1b954285a70, 0x563442ab350f6c31
d_2_1:          .dword 0x04b6ab9442142544, 0x611fab1f01a75eca
d_2_2:          .dword 0x13cfaabab1fd545e, 0xd78864b9daa41d39
d_2_3:          .dword 0xc8d33e9a7aca9ea0, 0xaf512f7610ddf020
d_2_4:          .dword 0x63d03f3a058e7683, 0xf7213f3990fb45ef
d_2_5:          .dword 0xadba3c097d0bd1a2, 0x7e6a32097e31f674
d_2_6:          .dword 0x00279844dab93439, 0x61f3254ca36e943f
d_2_7:          .dword 0xef4e0bce95ab1326, 0x0d62dbe01ece4cf8
d_2_8:          .dword 0x27df95f5a9ff938b, 0xe48d3632adb2e221
d_2_9:          .dword 0xc4c265ad7e04b349, 0xd2e2941822053ae4
d_2_10:         .dword 0x425f862eb8001424, 0x2bc6379b390f676e
d_2_11:         .dword 0x2daef5590c6fcb2a, 0xcdced6c2f6965fac
d_2_12:         .dword 0x8dca623b9871c5a0, 0x19f7d6a2a34313a3
d_2_13:         .dword 0x4bfac16c343232c1, 0x80e2ad307cb5ec32
d_2_14:         .dword 0xbfb42f77510d10fc, 0x84e0929b3365498b
d_2_15:         .dword 0x3521bffcbfb92d49, 0x686af2d190ffbb1e
d_2_16:         .dword 0xe1623f0d58516584, 0xdd81286fbb89db88
d_2_17:         .dword 0x619eab7f35a916b3, 0x93655205e96bad5a
d_2_18:         .dword 0xc91233ce55bd34ac, 0x24d30c07194ca942
d_2_19:         .dword 0x4df7e32088093101, 0x88bf1896fd6c7241
d_2_20:         .dword 0x5687234f5a38bc39, 0x374587626acd7977
d_2_21:         .dword 0xa8118f94d42dc3e7, 0xef6b498071d73528
d_2_22:         .dword 0x77edfdc775b1e1c2, 0xcfa288d218e631b0
d_2_23:         .dword 0x0c1f89d42c432223, 0x3c161d7db524655d
d_2_24:         .dword 0xa9913815feea1ee7, 0x18a486c4b10f9c3e
d_2_25:         .dword 0x2e3a60d2456341f7, 0xcc75080fd7bff8e5
d_2_26:         .dword 0x40c3f0e4a61569d3, 0x797c49b84d11c31a
d_2_27:         .dword 0xd2163ecdb6c47f4a, 0x6cbb6bf192d6127a
                .dword 0xfb0f9bfb2efda016, 0xe5e06d1783f84346
                .dword 0x3965b807d7a0221e, 0x404c3b060b4b6b75
         /* Random data */
_end_data2:
                

    .section .data.random3;
    .align  8;

_random_data3:
                .dword 0xe611ba76642e555e, 0x81a498b04b67cd98
                .dword 0xbe624211180deedd, 0x63987360ae25b6d1
d_3_0:          .dword 0x7f2be0ee0f8fc83e, 0xce8d5898c9d31e64
d_3_1:          .dword 0x0c061c7e318ee01f, 0xf61445a0afb1bbe7
d_3_2:          .dword 0x65fde60e71901530, 0xc49e35237897c758
d_3_3:          .dword 0xfc6a21d736b612ed, 0x1ca9f7fab2c58a50
d_3_4:          .dword 0x4f06bd0f1ef77cbf, 0x34416a8de8c0025e
d_3_5:          .dword 0x7a8a6cef30eacf74, 0xc2ede382f3788f63
d_3_6:          .dword 0xab4f954fc0117289, 0xec1c247073bf31f2
d_3_7:          .dword 0x3ecb8e91611dc555, 0x43e2d85d54918543
d_3_8:          .dword 0x2b791ce9f280a3fd, 0xfb1faad2308db670
d_3_9:          .dword 0xb956b15593991196, 0x1b2681a91df9dc46
d_3_10:         .dword 0x9f2cae452aca0e82, 0x74d020912f975874
d_3_11:         .dword 0x32f84e1e88fbf5ae, 0x30baaed6ceb656ef
d_3_12:         .dword 0x9cb4b8a0dd9104b8, 0x321554cdbc72257e
d_3_13:         .dword 0x8fc8688bd04b8f44, 0x66d680fd43d33e41
d_3_14:         .dword 0xb11e42b697182d04, 0xb12d873a737f7dcc
d_3_15:         .dword 0x190062c408b60eaf, 0x96d26d001cae2da4
d_3_16:         .dword 0xdbbf3065957c37aa, 0x2658a71b915ebcc1
d_3_17:         .dword 0xbc577c83144fbba3, 0x9bdcd12ce1dfcbc1
d_3_18:         .dword 0xeea6f70b399aa990, 0x482ba9e27e6c4207
d_3_19:         .dword 0x183cbb5a0c0d7506, 0x9fd9893ab1daeb9c
d_3_20:         .dword 0xade61f950cd91e9c, 0x71291d8f72436773
d_3_21:         .dword 0xa6acbadb8843fab9, 0x870611335e8bb791
d_3_22:         .dword 0x953101fd3a644692, 0xe52f8dc5f399fd72
d_3_23:         .dword 0x231b17042df54afc, 0x1f83f60a737c7076
d_3_24:         .dword 0xa7951c352b8efc91, 0x94457fc035a557db
d_3_25:         .dword 0xe327193989d465b4, 0x182ff83069a8b90f
d_3_26:         .dword 0x237a9fe57f12405a, 0x772cf2bef3e433d1
d_3_27:         .dword 0x1cae83503763e2d5, 0xcb84246bf007a27a
                .dword 0x91b25cd1796a948a, 0xef9486efd619b7ff
                .dword 0xa6219283e168e636, 0xe84d199c358fa384
        /* Random data */
_end_data3:


    .section .data.random4;
    .align  8;

_random_data4:
                .dword 0xada63b5c56a4073d, 0x89fb3d3ad8e91289
                .dword 0xc5d1e664c6ffeec2, 0x666cf3438f78ae84
d_4_0:          .dword 0x0f88638a930285f4, 0x903a341416871221
d_4_1:          .dword 0xe2d6379869be8dc6, 0xf93382d252a18fe7
d_4_2:          .dword 0x386e9ec8db233f10, 0xb1d72d81f6f75768
d_4_3:          .dword 0xcfa640b31021937a, 0x87c27ccc05ebff29
d_4_4:          .dword 0x2bbda7598831618a, 0x200131e6930f8709
d_4_5:          .dword 0xaa90a739ec1a3911, 0x05a909dce3e36993
d_4_6:          .dword 0xab1947775aa99f11, 0x5980a4892d9f9d18
d_4_7:          .dword 0x2fcdc9c42e739745, 0x17964f71e281a298
d_4_8:          .dword 0xc4a4b65d2058c3a8, 0x02d9c7f1f79c3719
d_4_9:          .dword 0xab5aeda8b2cc795a, 0x9804f2cffa88be95
d_4_10:         .dword 0xbdc3e0954aea8dbe, 0xfe0346948769e511
d_4_11:         .dword 0xd3c18ca765f5d299, 0x1c709740b9147ff2
d_4_12:         .dword 0xc5813adcf05135b3, 0x047904d8089dfea5
d_4_13:         .dword 0xa6cfc2444bf5cefa, 0x4475bc21f14b8b63
d_4_14:         .dword 0xd53a68df5449ace3, 0x52cd69a742ed9deb
d_4_15:         .dword 0x41b62f77c54f4bd5, 0x9ccfd0acc0df4601
d_4_16:         .dword 0x37bb3bd0f221fef8, 0x2188ae81a7a384e9
d_4_17:         .dword 0x9626b77f708e37a5, 0xbff7ac79a7d0d971
d_4_18:         .dword 0x6d2ad24c3130e2e1, 0xba29ecb94a3ee4bb
d_4_19:         .dword 0x8852ae3141091d6c, 0xdee4a1a873d44cd4
d_4_20:         .dword 0x9384ae14ae4227d4, 0xabc6a63b14bd4159
d_4_21:         .dword 0x97f6fc26acded02e, 0xcba614feb1bc997e
d_4_22:         .dword 0x1fa6daf5ec57ce78, 0x05e0c1f64437e8ee
d_4_23:         .dword 0xc7b1285430739a3d, 0x770cd040fd66c4e3
d_4_24:         .dword 0x765bd5c7c091b239, 0x071deb4a7c47d0cb
d_4_25:         .dword 0x22d64d03492a644b, 0x691329cd7742a2e7
d_4_26:         .dword 0x29dfa1589fcb868b, 0xcb2aab7e11d0d04e
d_4_27:         .dword 0x485b0cc39d86af4d, 0xa0a880e4bc2f64c0
                .dword 0x7d061bc50a415f8a, 0xd39501257d587240
                .dword 0x0e56dcbd9f19dfd3, 0xaca10f9af5a5f989
        /* Random data */
_end_data4:


    .section .data.random5;
    .align  8;

_random_data5:
                .dword 0xed256b4ae0ecd9d5, 0x34ec40ab7ce6396c
                .dword 0xdd8cd27cfcd65118, 0x9727e26be83dbed1
d_5_0:          .dword 0x47fc60f472b43338, 0xfc2265d2ba4fed5e
d_5_1:          .dword 0x9190ad6165a4e257, 0x78b81ee8c1b5554a
d_5_2:          .dword 0x120b388a6e78e8cf, 0xe65bf3e3f06151d9
d_5_3:          .dword 0xc8ee52c8bd023b50, 0x812ffd06a534ba87
d_5_4:          .dword 0x4059a3ddbb356fb4, 0x1fb13b3d905bd324
d_5_5:          .dword 0x09f552c0d016d7e0, 0x4ee3ec5511ff692c
d_5_6:          .dword 0xe581e520001a22bf, 0x8d8b9edd30046ba0
d_5_7:          .dword 0x777d201a1a69814e, 0x2bad8dd0eb78fb93
d_5_8:          .dword 0x2a0a165e7b0ee03f, 0x4cfc4012ed9f0488
d_5_9:          .dword 0xde70a472ab05b0ae, 0x047c824beed1489d
d_5_10:         .dword 0x59f26ffd65186ded, 0xf41d84cd1c563cac
d_5_11:         .dword 0x9d345749b1bf1b73, 0x35aa3324f921f7ac
d_5_12:         .dword 0x16628255c5766d5b, 0x565a346685e23557
d_5_13:         .dword 0xe6557ff853f07e7c, 0x5999bc63358956a3
d_5_14:         .dword 0x1da807a68261d96e, 0x5bd748d5a3e64d4b
d_5_15:         .dword 0x44be8cce2eebe0d8, 0x1cf0a93f5a5c54a3
d_5_16:         .dword 0x0438310595d56650, 0x37be661d499bd9c1
d_5_17:         .dword 0xe05f85eb882d5f8d, 0x783aac358af3f4ec
d_5_18:         .dword 0xcdfa238b2df739e7, 0x0ca385b00ce89f85
d_5_19:         .dword 0x15a3981203d005f6, 0x53f4b1338d11bf02
d_5_20:         .dword 0xb7e256573433479d, 0xdb62ed1803d5c8df
d_5_21:         .dword 0xb163bd4d1bb92b88, 0xb255e33b99dd773c
d_5_22:         .dword 0xcd8558bfb45ce69b, 0x242bd62f6ed44970
d_5_23:         .dword 0x3562bbc78cec9381, 0xad87d44e0e319d31
d_5_24:         .dword 0x73c1e21b9d137e2c, 0x87e0ac46e34234a8
d_5_25:         .dword 0x18f6c32eef90217a, 0x755cae1e660e0577
d_5_26:         .dword 0x1e8cb845342a7891, 0x2ece916e423512b1
d_5_27:         .dword 0xb4b91a214625f6c6, 0xf0a5e89cf04bc099
                .dword 0x4233e7ecae265e55, 0xdcffabcd6d586039
                .dword 0x1feda01e3b363418, 0xc662ecce659efe76
         /* Random data */
_end_data5:
              
                 
