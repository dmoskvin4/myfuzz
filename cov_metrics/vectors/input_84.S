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
_p0:    xor x14, x14, x14                         ;
        csrrc x12, satp, x14                      ;
_p1:    xor x11, x11, x11                         ;
        addi x13, zero, 3                         ;
        slli x13, x13, 0                          ;
        add x11, x11, x13                         ;
        addi x11, zero, 1                         ;
        slli x11, x11, 5                          ;
        add x11, x11, x11                         ;
        csrrc x13, satp, x11                      ;
_p2:    csrrwi x11, frm, 13                       ;
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
_l2:    feq.s x17, f12, f12                    ;
_l3:    ori x18, x5, -12                    ;
_l4:    la x27, d_2_20                    ;
      addi x27, x27, -0         ;
      lr.d x5, (x27)         ;
_l5:    fclass.s x5, f0                    ;
_l6:    addi x0, x1, 0                    ;
_l7:    la x24, d_1_8                    ;
      srai x24, x24, 1         ;
      csrrw x28, pmpaddr3, x24         ;
_l8:    fnmsub.s f31, f4, f20, f4, rne                    ;
_l9:    srai x15, x10, 6                    ;
_l10:    la x26, d_5_11                    ;
      addi x26, x26, -20         ;
      lr.w x20, (x26)         ;
_l11:    addi x0, x1, 0                    ;
_l12:    fmadd.s f21, f19, f12, f31, rne                    ;
_l13:    la x9, d_3_7                    ;
      fsw f24, 4(x9)         ;
_l14:    ori x19, x30, 418                    ;
_l15:    xor x18, x18, x18                    ;
      addi x22, zero, 1         ;
      slli x22, x22, 1         ;
      add x18, x18, x22         ;
      csrrw x29, scause, x18         ;
_l16:    fnmadd.s f9, f28, f16, f6, rne                    ;
_l17:    csrrci x5, fcsr, 16                    ;
_l18:    la x24, d_4_21                    ;
      addi x24, x24, 8         ;
      amoand.d x10, x19, (x24)         ;
_l19:    flt.s x16, f23, f2                    ;
_l20:    la x25, d_1_12                    ;
      addi x25, x25, -16         ;
      amomin.d x24, x30, (x25)         ;
_l21:    la x20, d_4_3                    ;
      addi x20, x20, -4         ;
      amomax.w x9, x8, (x20)         ;
_l22:    la x11, d_1_27                    ;
      addi x11, x11, -0         ;
      amomaxu.d x11, x7, (x11)         ;
_l23:    fmv.x.w x18, f27                    ;
_l24:    fmax.s f3, f26, f11                    ;
_l25:    addi x0, x1, 0                    ;
_l26:    la x27, d_2_15                    ;
      addi x27, x27, 16         ;
      lr.d x1, (x27)         ;
_l27:    la x2, d_3_2                    ;
      addi x2, x2, -20         ;
      amoor.w x9, x21, (x2)         ;
_l28:    la x27, d_2_19                    ;
      lhu x13, -2(x27)         ;
_l29:    fnmadd.s f10, f10, f19, f30, rne                    ;
_l30:    fcvt.s.l f14, x30, rne                    ;
_l31:    la x19, d_5_27                    ;
      addi x19, x19, 8         ;
      amominu.w x19, x27, (x19)         ;
_l32:    xor x16, x16, x16                    ;
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
_l33:    la x5, d_3_16                    ;
      sw x13, 20(x5)         ;
_l34:    la x16, d_3_25                    ;
      addi x16, x16, 0         ;
      amoxor.d x23, x15, (x16)         ;
_l35:    la x20, d_3_21                    ;
      addi x20, x20, 12         ;
      amomaxu.w x26, x27, (x20)         ;
_l36:    auipc x8, 9                    ;
_l37:    la x2, d_0_16                    ;
      lhu x28, -28(x2)         ;
_l38:    fadd.s f11, f2, f16, rne                    ;
_l39:    fcvt.lu.s x15, f1, rne                    ;
_l40:    fnmadd.s f26, f16, f21, f23, rne                    ;
_l41:    la x19, d_1_9                    ;
      lhu x6, 30(x19)         ;
_l42:    fsub.s f1, f26, f5, rne                    ;
_l43:    la x28, d_3_25                    ;
      addi x28, x28, -16         ;
      lr.d x15, (x28)         ;
_l44:    addw x21, x27, x1                    ;
_l45:    la x4, d_1_7                    ;
      addi x4, x4, -8         ;
      sc.d x17, x4, (x4)         ;
_l46:    fcvt.l.s x25, f14, rne                    ;
_l47:    slliw x17, x0, 24                    ;
_l48:    la x1, d_5_8                    ;
      addi x1, x1, 8         ;
      amoor.w x8, x16, (x1)         ;
_l49:    la x25, d_4_4                    ;
      addi x25, x25, -8         ;
      amoand.d x2, x28, (x25)         ;
_l50:    la x1, d_4_22                    ;
      addi x1, x1, 20         ;
      amomin.w x21, x1, (x1)         ;
_l51:    feq.s x3, f9, f0                    ;
_l52:    sllw x9, x13, x13                    ;
_l53:    la x8, d_3_26                    ;
      lh x13, -14(x8)         ;
_l54:    flt.s x3, f2, f31                    ;
_l55:    fmv.x.w x5, f26                    ;
_l56:    la x19, d_3_8                    ;
      addi x19, x19, -8         ;
      amoand.w x21, x6, (x19)         ;
_l57:    fnmadd.s f3, f28, f5, f24, rne                    ;
_l58:    fcvt.s.w f4, x10, rne                    ;
_l59:    la x28, d_1_4                    ;
      lw x28, -16(x28)         ;
_l60:    fmadd.s f25, f8, f18, f21, rne                    ;
_l61:    srli x28, x2, 52                    ;
_l62:    addiw x25, x11, 436                    ;
_l63:    fadd.s f10, f20, f8, rne                    ;
_l64:    fdiv.s f19, f13, f14, rne                    ;
_l65:    la x15, d_2_18                    ;
      addi x15, x15, 0         ;
      sc.d x30, x15, (x15)         ;
_l66:    la x9, d_4_13                    ;
      addi x9, x9, 24         ;
      sc.w x14, x18, (x9)         ;
_l67:    fmadd.s f13, f14, f23, f12, rne                    ;
_l68:    srli x28, x2, 52                    ;
_l69:    la x11, d_1_24                    ;
      lw x5, -4(x11)         ;
_l70:    la x25, d_0_19                    ;
      addi x25, x25, -16         ;
      sc.w x6, x20, (x25)         ;
_l71:    la x9, d_3_22                    ;
      addi x9, x9, -0         ;
      amoxor.w x7, x25, (x9)         ;
_l72:    ori x0, x6, 594                    ;
_l73:    sllw x2, x24, x7                    ;
_l74:    ori x19, x30, 418                    ;
_l75:    la x24, d_4_0                    ;
      lh x2, 10(x24)         ;
_l76:    addi x21, x12, 8                    ;
_l77:    la x26, d_5_14                    ;
      addi x26, x26, 12         ;
      amomax.w x30, x8, (x26)         ;
_l78:    sltiu x22, x22, -2047                    ;
_l79:    la x4, d_2_21                    ;
      addi x4, x4, -28         ;
      amoor.w x24, x25, (x4)         ;
_l80:    la x8, _l35                    ;
      lhu x11, 14(x8)         ;
_l81:    fnmsub.s f22, f24, f5, f13, rne                    ;
_l82:    fcvt.s.l f15, x24, rne                    ;
_l83:    fcvt.l.s x21, f29, rne                    ;
_l84:    la x26, d_5_14                    ;
      addi x26, x26, 12         ;
      amomax.w x30, x8, (x26)         ;
_l85:    la x18, d_2_17                    ;
      addi x18, x18, -0         ;
      amoxor.w x5, x16, (x18)         ;
_l86:    fsqrt.s f1, f20, rne                    ;
_l87:    ori x19, x30, 418                    ;
_l88:    fcvt.s.l f14, x30, rne                    ;
_l89:    fcvt.lu.s x15, f1, rne                    ;
_l90:    subw x29, x15, x12                    ;
_l91:    la x11, d_2_3                    ;
      lui x29, 0xffe00         ;
      xor x11, x11, x29         ;
      sh x25, -12(x11)         ;
_l92:    fsgnjn.s f26, f27, f1                    ;
_l93:    slliw x29, x3, 0                    ;
_l94:    fsgnj.s f25, f16, f28                    ;
_l95:    flt.s x3, f2, f31                    ;
_l96:    slti x19, x8, 1395                    ;
_l97:    subw x22, x0, x25                    ;
_l98:    addi x21, x12, 8                    ;
_l99:    fnmadd.s f23, f20, f22, f30, rne                    ;
_l100:    fnmsub.s f22, f24, f5, f13, rne                    ;
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
                .dword 0x4dd0478e47000b57, 0x2f33f975e4555f6d
                .dword 0xdd0108ac66a313e6, 0x1531e072823694af
d_0_0:          .dword 0xee4eb266cfd963a5, 0x9a220ff7ae76fb8e
d_0_1:          .dword 0xeb200a043b83f5cb, 0x83cbedb3850ac64e
d_0_2:          .dword 0xb4e105efaf9e10e7, 0x3e8ee435a01bff4c
d_0_3:          .dword 0x29781016533f1bf1, 0x0882348bce14e4c5
d_0_4:          .dword 0xbd5df4d004c87627, 0x8c81d264f91170fc
d_0_5:          .dword 0xc572abeb8a61cbf7, 0xe39c8abc5d5ca886
d_0_6:          .dword 0xb684d31475ac7aa0, 0x1ae8e8a1138cfd6f
d_0_7:          .dword 0x3ef802a111ffbc64, 0xc6dea6f64bc42160
d_0_8:          .dword 0x81c597297a888243, 0x62a81ebe8e4bf3dd
d_0_9:          .dword 0xcd8f0184a07212e9, 0xb36095c2560dd64e
d_0_10:         .dword 0x577c2012b897c8c9, 0x673186f2f51292d9
d_0_11:         .dword 0x0c63ea7517b3d49b, 0x79cb8ceb7243c74e
d_0_12:         .dword 0x2ba32927ee0d6464, 0xc5702c84603181e3
d_0_13:         .dword 0x5c85939124633a3d, 0x30db2de421f6be4b
d_0_14:         .dword 0x3bba0dab0c553802, 0xd22dbdaef24c2a96
d_0_15:         .dword 0x5e0a95b195066580, 0x019631e67bff45d0
d_0_16:         .dword 0x09c6fbab5455bb21, 0x1de5f7025118d5d8
d_0_17:         .dword 0x5210f29e4b2de1bc, 0x418df9f1c63039c0
d_0_18:         .dword 0x474c08d6b70b07c2, 0x45b983c2d7668aa1
d_0_19:         .dword 0xd9f029f5a862ae82, 0x6e46696c378975ed
d_0_20:         .dword 0xb757f64360f83c4d, 0x3ac1364cbe3c1bae
d_0_21:         .dword 0xd234496a713c0cc0, 0xb18a1b8952e97b0d
d_0_22:         .dword 0xc00ac7537b756ed1, 0x6933bd591429dd6c
d_0_23:         .dword 0x9b1b62a3ee704bf7, 0x91eb77063f2f3cc5
d_0_24:         .dword 0x31b239b885bf1324, 0xc95b8a6d096bb0fd
d_0_25:         .dword 0xdad9feca6161934b, 0xa5cbf3ae91290b97
d_0_26:         .dword 0x563a53d9d674cb4d, 0x0dbfc05728f095ff
d_0_27:         .dword 0xd7b68a6bc709a29f, 0x840018b1dd99cc13
                .dword 0x3ae17847beb9fb4d, 0xc42278c851e6e78c
                .dword 0xb6e180b6867f12a4, 0xfd1dcc194530b700
        /* Random data */
_end_data0:
                 

    .section .data.random1;
    .align  8;

_random_data1:
                .dword 0x10df2acd00799c8e, 0x4dea61f7350dd137
                .dword 0xe1e0a7c71f091e5f, 0xb2091f9d74c7ec1b
d_1_0:          .dword 0x4b0b10fa2e59d1cd, 0xcd28fddd1cb0ff97
d_1_1:          .dword 0x72aa09969f1cdb34, 0x83dc63cfc7458360
d_1_2:          .dword 0xfb1ed3d095edb3c3, 0x6534ff22eada3dab
d_1_3:          .dword 0xa5d9afcd8158fe68, 0x8ed887572054a063
d_1_4:          .dword 0x6b1436703fe58fbd, 0x287c958d85654468
d_1_5:          .dword 0xb4d2b4b6c6071c41, 0x3d1d6c7c49d4d08b
d_1_6:          .dword 0x64f2552e8ce704cb, 0x3cbd86524aa7153a
d_1_7:          .dword 0x9430bbdeff2fad63, 0xf0604978b91e8634
d_1_8:          .dword 0x0f657d096e32fe62, 0xbe65d65ee09280e7
d_1_9:          .dword 0x01945876776706e7, 0x8f0577482ed863ae
d_1_10:         .dword 0x46e9901fdd46c163, 0xf7f28e41432e1fa0
d_1_11:         .dword 0x54b061d2bc2c9b3f, 0xeb3f98736e3edd43
d_1_12:         .dword 0x82ad48eda21436cd, 0xfb7db8ad83dff935
d_1_13:         .dword 0x9957652e9f65d703, 0x1c33d963de54485a
d_1_14:         .dword 0xeb74f989ba343340, 0x6e8720e3a2222ab5
d_1_15:         .dword 0x44f3d349c78b9096, 0x5df1d335de77e728
d_1_16:         .dword 0x61796869bad40f8a, 0xc4414933920e2bb3
d_1_17:         .dword 0xe689123244db2f4d, 0x749a6d7b4626b15c
d_1_18:         .dword 0x00676f27ec0bf578, 0xa0851e8c3d77a456
d_1_19:         .dword 0x3f030c6df0086f02, 0x3bcf9ac593822d29
d_1_20:         .dword 0xbcadbc655f8c3a08, 0xf7046c2778ce1923
d_1_21:         .dword 0xfe267fbc1c2de2f6, 0x57e5276973c1814d
d_1_22:         .dword 0xa57bb223a7461835, 0x7516016e7468a91d
d_1_23:         .dword 0xa2fdffa48a2ca0a0, 0x3ec0ef53e44592ee
d_1_24:         .dword 0x3fae94f60ae7a78b, 0x5331d19020c17a38
d_1_25:         .dword 0x5474fd8cdd4d021c, 0xec2680fd056359db
d_1_26:         .dword 0xfe711992edda9d4f, 0x642f8fb46ef414f8
d_1_27:         .dword 0x8def7e3fc1214141, 0x1716f8d1b9bfb28e
                .dword 0xa43e7edd33d8133d, 0x25f091e4c1e27efd
                .dword 0xcaea6149554679ea, 0xb2b3842f981ea83b
        /* Random data */
_end_data1:


    .section .data.random2;
    .align  8;

_random_data2:
                .dword 0x4f52dcef9e48747f, 0xfbb92637c25d8c97
                .dword 0xdd3a0d1164353059, 0x5bc0d8588a55233f
d_2_0:          .dword 0xbee09cabf23be19d, 0x8fadfbad9484c3f1
d_2_1:          .dword 0x56d04f30509e03ef, 0xd987a2fc6799b7ba
d_2_2:          .dword 0x3ef24b99180aa2bb, 0x3ddbf2caeedcb451
d_2_3:          .dword 0x596dc7d9d535e323, 0x835752daf4132040
d_2_4:          .dword 0x82337726fbb6863d, 0x489843f642e61769
d_2_5:          .dword 0x14176da6385758f6, 0x5b19e2e80b3d58ee
d_2_6:          .dword 0xc4c6e4d041689b98, 0x5fd8d06a5659f526
d_2_7:          .dword 0xa5ee756210934dcb, 0x8c64cdfda1e12a44
d_2_8:          .dword 0xd485d84c177788fa, 0x8b76f42ef2ab6757
d_2_9:          .dword 0x97ac7d6f6acfd031, 0xf1239d2db97b0d7e
d_2_10:         .dword 0x1d9bb5a606f519df, 0xeed62e72735e4dc4
d_2_11:         .dword 0x5368472eeb38dd0e, 0x1d7a4bb58a55bda7
d_2_12:         .dword 0x34de66a22d1cfee1, 0xd5b86f6ee5d6a083
d_2_13:         .dword 0x5b8a6a96e0677e6e, 0x7d1caf6f2809be13
d_2_14:         .dword 0x1ed096e5f306ccba, 0xca73c714d2ca9e10
d_2_15:         .dword 0x122f5e82772f0c64, 0x2dba0ef85df30773
d_2_16:         .dword 0x0b132fee5741d977, 0x61ada01f7dc6769a
d_2_17:         .dword 0x0ddd250fd04c0f30, 0x98cce57783563d71
d_2_18:         .dword 0xdea6271f64d47359, 0xbb618de575d008b5
d_2_19:         .dword 0x892750d9015e00f4, 0x687f515455117cf1
d_2_20:         .dword 0x3a5b24a253334b26, 0x3efe50eebb59b202
d_2_21:         .dword 0x9ea99995c63ff264, 0xf5694581481fc004
d_2_22:         .dword 0xdc05cdf24bbcba37, 0xdefa283446b53155
d_2_23:         .dword 0x546d0aec89b46d4c, 0xcedd78a819f033ea
d_2_24:         .dword 0xa0b483794bc37461, 0x420efa2254274254
d_2_25:         .dword 0xe113275c889e9e52, 0x37076c874d17a94c
d_2_26:         .dword 0x3296d042ff3b5352, 0xc632b52e12d2fd44
d_2_27:         .dword 0xd0cb03b441bcea45, 0x9882d4aa34918b05
                .dword 0xcbe30752379980da, 0x24236c3802128832
                .dword 0x76c6758c87f9500e, 0x3413d06dd0b96228
         /* Random data */
_end_data2:
                

    .section .data.random3;
    .align  8;

_random_data3:
                .dword 0xcaebfe7bc4614cd9, 0x089264e7f75f5354
                .dword 0xf6798ddbbd4cc9da, 0xf48fc0c4a0fa81fb
d_3_0:          .dword 0x04047e3a50529a96, 0xe40fb0e796ed4758
d_3_1:          .dword 0xad4e27db9717b5ca, 0x4968e0e8f6a82902
d_3_2:          .dword 0xcb24adadb55c714c, 0x3f8f118e311b5eb3
d_3_3:          .dword 0x8e5350547fc3fc22, 0xa311b53e70a037e6
d_3_4:          .dword 0x602f6ad32cd711e1, 0x444f15300f8565b3
d_3_5:          .dword 0x73d0d929391eb082, 0xebb2b8cb72816a09
d_3_6:          .dword 0xf31bf3b4ccd8c03b, 0x1c784e7e72db164c
d_3_7:          .dword 0xbc0a3ca9613ea5f2, 0xd4b89ee0c7a89255
d_3_8:          .dword 0x82ea65c7bc118cd6, 0x8dbf5364f9680322
d_3_9:          .dword 0x58a61a54d330aa01, 0x28c0983071472edb
d_3_10:         .dword 0x57b5ae9638772dc1, 0xfe5f402cd71b236a
d_3_11:         .dword 0x0c65c73aaef29dd6, 0x07be6b105d73208a
d_3_12:         .dword 0xe2337a864f545f98, 0x7c749ea7f61155d3
d_3_13:         .dword 0x4f9310b3442d4ac2, 0xadf4005c0b963910
d_3_14:         .dword 0xd52dc8df3c186c94, 0xf5e49738f070fdd7
d_3_15:         .dword 0x605fe59dd1d593ac, 0x0a1d1e649cf20479
d_3_16:         .dword 0xef12bc791960df1d, 0x393178a998c5510c
d_3_17:         .dword 0x5ee56e5cc73df48f, 0x1e8c3293d7b34a68
d_3_18:         .dword 0x3c029c20479ceece, 0x5b6a548e5e8c5771
d_3_19:         .dword 0x744d9166ceed05b5, 0x8b468e568ded000b
d_3_20:         .dword 0xa026171f3fc16039, 0x41dfadb20c13f3c8
d_3_21:         .dword 0x5e1e541fce656dcd, 0x7897272e4513b3a7
d_3_22:         .dword 0x63d6fb345e84f2f8, 0x8ddc8f712c44237b
d_3_23:         .dword 0xbfe2025a7eace5ca, 0xe59f290dc0f49f80
d_3_24:         .dword 0x956f1804814bb573, 0x06f8431f5490ee11
d_3_25:         .dword 0x12196a4b818ee45a, 0x99f00abd82a24da4
d_3_26:         .dword 0x70df865a647ff412, 0x1e4e8b8270d3f3b8
d_3_27:         .dword 0x14a311ec9be2f96d, 0x869e803375074853
                .dword 0xdd283c3c7a461658, 0xc7080105716dd7aa
                .dword 0xf70c52f360c11ba7, 0x8b30c3157cc38b07
        /* Random data */
_end_data3:


    .section .data.random4;
    .align  8;

_random_data4:
                .dword 0x6e45133620c33b88, 0xbf21c4de62d4e58e
                .dword 0xf51ce09e3ad8c7e6, 0x44229e3a543abdbc
d_4_0:          .dword 0x10855d0a5e3ee056, 0x0c5723178b5b0eff
d_4_1:          .dword 0xe71a496054c0259b, 0xfbfca717bab85e81
d_4_2:          .dword 0xe5620b91854bf072, 0x6b2d7c100ab131c8
d_4_3:          .dword 0x4ad699c22e1a5984, 0xbd697d67fd162094
d_4_4:          .dword 0x9c5888bca446c473, 0x811e93f6bbbce53b
d_4_5:          .dword 0xc20c84854cbdc6b3, 0xad4222c92b1367e9
d_4_6:          .dword 0x8f4aad2dd4879f47, 0x1cc6e8e52353d2a4
d_4_7:          .dword 0x898b413b73caa8c2, 0x47ec6dd9803eb8d5
d_4_8:          .dword 0x14438a4a222edf72, 0x97bc42474afa9626
d_4_9:          .dword 0x2cf47a91863c7b02, 0x9d99c075b9b8de94
d_4_10:         .dword 0xdd6bc437fe4bd7bd, 0x5c42f10d1bc6a53e
d_4_11:         .dword 0xcae6924ba7b74a78, 0xf7c3ccc729990908
d_4_12:         .dword 0x78c0e595e84e74b2, 0xcffd16c6a03eaff5
d_4_13:         .dword 0x62f634af7a4868db, 0xc9715bee9981b7c8
d_4_14:         .dword 0x811e4a5b1e75ddc2, 0xcb4802468e07bf86
d_4_15:         .dword 0xa577e641b7393c69, 0xe6e9262e23ba3274
d_4_16:         .dword 0x9e3bf4b75c3e60c1, 0xa24aaaba635ca227
d_4_17:         .dword 0x8638a41f9a8e7ff8, 0x46b3b1496f277d99
d_4_18:         .dword 0x066d0fb4ed45f021, 0xd5275c367f828591
d_4_19:         .dword 0xc9024308e1a16701, 0x3f49facf080b45e6
d_4_20:         .dword 0x770c87b087ae9b72, 0x7b934d76a64a7afa
d_4_21:         .dword 0x8a72445fa32ac837, 0xea2bdc9650851dff
d_4_22:         .dword 0x534767b62e74c875, 0xf1f11e6744a759a5
d_4_23:         .dword 0xf17f0b7e8695f2b9, 0x9b24498b7236aca7
d_4_24:         .dword 0xe576226002c88f80, 0x85249bee7f15cce5
d_4_25:         .dword 0xc8fed8010132306b, 0x12330e822bfc37a9
d_4_26:         .dword 0x0d4c9e1e2420cf5f, 0xcff3cd4316eea8c2
d_4_27:         .dword 0xa699e6f94fb03644, 0x40bbd893b0c3a1f5
                .dword 0x6d3306efb7e5f713, 0x0ab445707d94f49b
                .dword 0x5c3e1f995630a743, 0xd4027b1b7ec4ea8a
        /* Random data */
_end_data4:


    .section .data.random5;
    .align  8;

_random_data5:
                .dword 0xe47153616646142b, 0xacf2189fd630b98c
                .dword 0x6f516f5771e92d7e, 0x3f4b4b7432528918
d_5_0:          .dword 0x32174068bd5ed1a0, 0x819b33f302c7d7b0
d_5_1:          .dword 0x611305e83c602320, 0x43ba5b61d27359e3
d_5_2:          .dword 0xdc969e11a911969c, 0xd28a31118311683c
d_5_3:          .dword 0xa871658e44880e8e, 0x5b7a9e400340fcc6
d_5_4:          .dword 0xceac398b02b69597, 0x2e06413168bde443
d_5_5:          .dword 0x0fe63b960fbe7a1a, 0x67e1a90927c4ab6f
d_5_6:          .dword 0x45382c2aa4803be3, 0x80da5653cf0b3904
d_5_7:          .dword 0x069348b9abf519f0, 0xe1e583a7a2907bf6
d_5_8:          .dword 0xba56481215d5dc7b, 0xde0510615aec1620
d_5_9:          .dword 0x695dd1bd6ebee1f3, 0x3e1964acd039cbb4
d_5_10:         .dword 0xc78d5552e9dd62ea, 0x71c7a7bfa703d6ac
d_5_11:         .dword 0x412de2aa1966956e, 0x2c9fef789471a53c
d_5_12:         .dword 0xffe352fbbd65d30f, 0xcf2deec17a879d38
d_5_13:         .dword 0xf30bef48e133c3f2, 0x7b6610022e7d9956
d_5_14:         .dword 0xcfb4c1d87b5beba4, 0x2e7d2d63b067dbfa
d_5_15:         .dword 0x41069513bb13cd59, 0x94fbdf6d2d7fd14c
d_5_16:         .dword 0xaf35b356ffce2173, 0x3a74923b6bc33244
d_5_17:         .dword 0xac31faf942cded57, 0x48e86c7e75f25852
d_5_18:         .dword 0x981765f688fb3bd7, 0x85cc520636facd1c
d_5_19:         .dword 0x27cc9dfa352d5d32, 0xf4f95feee787630c
d_5_20:         .dword 0x6c3595cb4cd90708, 0xd171d15774d2f664
d_5_21:         .dword 0xf327c4996ee49c88, 0x6d47b09518e1fe6f
d_5_22:         .dword 0x98f9789af38d5266, 0x616ab389705e92c3
d_5_23:         .dword 0x56e10ea0c268e795, 0xbe2d5adef91df6a1
d_5_24:         .dword 0x8156bc49eb08ac35, 0xc096789920b1fd59
d_5_25:         .dword 0x56932cc7a50d11fd, 0x4c2bdfa92fc1a1c2
d_5_26:         .dword 0x1261bc440a979ae0, 0xf39f7e6132e6ab11
d_5_27:         .dword 0xfb9f340584c32df0, 0x3e41f172e5021321
                .dword 0x5f62d70373af0353, 0xce0fce58ae04c50c
                .dword 0xcc0dc1403548243d, 0xe4388150064efb96
         /* Random data */
_end_data5:
              
                 
