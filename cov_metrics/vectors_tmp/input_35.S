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
_s0:    fle.s x19, f15, f24                       ;
_s1:    la x22, d_0_14                            ;
        addi x22, x22, -0                         ;
        amomin.w x12, x29, (x22)                  ;
_s2:    xori x25, x2, -717                        ;
_s3:    fcvt.w.s x10, f9, rne                     ;
_s4:    la x7, d_1_19                             ;
        addi x7, x7, -24                          ;
        amoand.w x29, x1, (x7)                    ;
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
_p0:    xor x10, x10, x10                         ;
        addi x12, zero, 3                         ;
        slli x12, x12, 22                         ;
        add x10, x10, x12                         ;
        csrrc x14, sscratch, x10                  ;
_p1:    la x14, d_3_9                             ;
        srai x14, x14, 1                          ;
        csrrc x13, pmpaddr5, x14                  ;
_p2:    csrrci x11, pmpaddr2, 29                  ;
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
_l1:    la x9, d_5_1                    ;
      sw x5, 24(x9)         ;
_l2:    addi x10, x0, -0                    ;
_l3:    addi x0, x1, 0                    ;
_l4:    addi x0, x1, 0                    ;
_l5:    fcvt.s.wu f7, x28, rne                    ;
_l6:    csrrci x9, sstatus, 20                    ;
_l7:    fle.s x16, f26, f21                    ;
_l8:    la x16, d_5_12                    ;
      addi x16, x16, -24         ;
      lui x18, 0xffe00         ;
      xor x16, x16, x18         ;
      amomin.w x18, x18, (x16)         ;
_l9:    la x17, d_4_14                    ;
      sw x25, -12(x17)         ;
_l10:    addi x0, x1, 0                    ;
_l11:    sraw x0, x2, x21                    ;
_l12:    la x9, d_3_22                    ;
      addi x9, x9, -0         ;
      amoxor.w x7, x25, (x9)         ;
_l13:    la x8, d_3_20                    ;
      addi x8, x8, -0         ;
      amomin.d x27, x11, (x8)         ;
_l14:    la x5, d_0_22                    ;
      addi x5, x5, -0         ;
      amoor.d x23, x19, (x5)         ;
_l15:    srli x21, x14, 17                    ;
_l16:    fcvt.lu.s x17, f25, rne                    ;
_l17:    la x18, _l39                    ;
      lbu x26, 28(x18)         ;
_l18:    la x9, _l18                    ;
      ld x24, 0(x9)         ;
_l19:    xor x18, x18, x18                    ;
      addi x22, zero, 1         ;
      slli x22, x22, 1         ;
      add x18, x18, x22         ;
      csrrw x29, scause, x18         ;
_l20:    mret                    ;
_l21:    fnmsub.s f3, f14, f20, f5, rne                    ;
_l22:    la x2, d_0_4                    ;
      addi x2, x2, 16         ;
      lr.d x18, (x2)         ;
_l23:    la x11, d_4_10                    ;
      sh x5, -10(x11)         ;
_l24:    srliw x9, x12, 31                    ;
_l25:    la x26, d_4_17                    ;
      addi x26, x26, -8         ;
      lui x25, 0xffe00         ;
      xor x26, x26, x25         ;
      amoxor.w x27, x25, (x26)         ;
_l26:    la x21, d_5_12                    ;
      sw x10, -8(x21)         ;
_l27:    fcvt.lu.s x11, f9, rne                    ;
_l28:    li x15, 1                    ;
      la x17, pt1         ;
      addi x17, x17, 32         ;
      sfence.vma x15, x17         ;
_l29:    fmv.w.x f9, x28                    ;
_l30:    fmin.s f8, f25, f15                    ;
_l31:    la x22, d_0_12                    ;
      addi x22, x22, -8         ;
      amomin.w x15, x3, (x22)         ;
_l32:    la x24, d_2_2                    ;
      addi x24, x24, -0         ;
      amomax.d x3, x30, (x24)         ;
_l33:    la x8, d_0_16                    ;
      addi x8, x8, 8         ;
      amomax.d x2, x4, (x8)         ;
_l34:    addi x0, x1, 0                    ;
_l35:    fcvt.l.s x10, f5, rne                    ;
_l36:    la x15, d_3_12                    ;
      addi x15, x15, -20         ;
      amoadd.w x29, x19, (x15)         ;
_l37:    fmin.s f14, f19, f30                    ;
_l38:    srlw x3, x7, x3                    ;
_l39:    la x27, d_5_22                    ;
      sd x7, 0(x27)         ;
_l40:    fnmadd.s f16, f6, f12, f26, rne                    ;
_l41:    xor x22, x22, x22                    ;
      addi x25, zero, 1         ;
      slli x25, x25, 3         ;
      add x22, x22, x25         ;
      addi x14, zero, 3         ;
      slli x14, x14, 26         ;
      add x22, x22, x14         ;
      addi x30, zero, 3         ;
      slli x30, x30, 2         ;
      add x22, x22, x30         ;
      csrrc x21, stval, x22         ;
_l42:    fsgnjx.s f10, f29, f25                    ;
_l43:    la x10, d_4_10                    ;
      addi x10, x10, 0         ;
      amominu.w x29, x6, (x10)         ;
_l44:    addi x0, x1, 0                    ;
_l45:    la x14, d_3_7                    ;
      addi x14, x14, -8         ;
      sc.d x16, x14, (x14)         ;
_l46:    la x26, d_1_27                    ;
      addi x26, x26, -28         ;
      amomin.w x29, x18, (x26)         ;
_l47:    la x13, d_2_12                    ;
      addi x13, x13, -16         ;
      sc.w x23, x1, (x13)         ;
_l48:    srli x16, x23, 7                    ;
_l49:    la x5, d_3_3                    ;
      addi x5, x5, 0         ;
      amominu.d x21, x29, (x5)         ;
_l50:    lui x20, 9                    ;
_l51:    la x7, d_2_25                    ;
      addi x7, x7, -8         ;
      amomaxu.d x2, x21, (x7)         ;
_l52:    fcvt.s.l f31, x24, rne                    ;
_l53:    la x30, d_3_19                    ;
      addi x30, x30, -16         ;
      sc.d x13, x30, (x30)         ;
_l54:    fsgnjx.s f28, f16, f20                    ;
_l55:    la x23, d_3_11                    ;
      addi x23, x23, 8         ;
      amoswap.d x25, x11, (x23)         ;
_l56:    addi x0, x1, 0                    ;
_l57:    flt.s x16, f23, f2                    ;
_l58:    sraiw x28, x4, 19                    ;
_l59:    slliw x23, x25, 15                    ;
_l60:    la x30, d_2_3                    ;
      lh x17, -30(x30)         ;
_l61:    fmadd.s f8, f5, f14, f31, rne                    ;
_l62:    sraw x22, x3, x26                    ;
_l63:    sltiu x29, x30, 2047                    ;
_l64:    fcvt.s.lu f26, x30, rne                    ;
_l65:    la x10, d_5_3                    ;
      addi x10, x10, -16         ;
      sc.d x2, x10, (x10)         ;
_l66:    la x12, d_2_8                    ;
      addi x12, x12, -16         ;
      lr.d x26, (x12)         ;
_l67:    fcvt.s.wu f27, x12, rne                    ;
_l68:    xor x4, x4, x4                    ;
      csrrw x5, sip, x4         ;
_l69:    fnmadd.s f22, f13, f14, f23, rne                    ;
_l70:    ori x13, x9, 2047                    ;
_l71:    fmsub.s f25, f30, f28, f18, rne                    ;
_l72:    la x21, d_4_0                    ;
      addi x21, x21, -8         ;
      sc.d x23, x21, (x21)         ;
_l73:    addi x0, x1, 0                    ;
_l74:    la x13, d_2_9                    ;
      lhu x27, 24(x13)         ;
_l75:    subw x13, x3, x9                    ;
_l76:    sltiu x11, x4, -6                    ;
_l77:    la x26, d_3_9                    ;
      addi x26, x26, 0         ;
      amoxor.w x20, x3, (x26)         ;
_l78:    srlw x19, x7, x29                    ;
_l79:    sltiu x12, x27, -1144                    ;
_l80:    subw x21, x1, x14                    ;
_l81:    mret                    ;
_l82:    fsgnjn.s f18, f7, f18                    ;
_l83:    fmv.x.w x15, f17                    ;
_l84:    fsgnjn.s f0, f23, f7                    ;
_l85:    la x3, d_2_6                    ;
      addi x3, x3, 16         ;
      lr.w x16, (x3)         ;
_l86:    la x16, d_0_25                    ;
      addi x16, x16, 8         ;
      amomax.d x11, x4, (x16)         ;
_l87:    la x13, d_2_2                    ;
      addi x13, x13, 4         ;
      amoor.w x15, x7, (x13)         ;
_l88:    li x9, 1                    ;
      la x10, pt0         ;
      addi x10, x10, 0         ;
      sfence.vma x9, x10         ;
_l89:    la x26, d_0_0                    ;
      addi x26, x26, 24         ;
      lui x20, 0xffe00         ;
      xor x26, x26, x20         ;
      amoor.w x6, x20, (x26)         ;
_l90:    addiw x21, x15, 742                    ;
_l91:    addiw x30, x12, -52                    ;
_l92:    fcvt.s.wu f19, x6, rne                    ;
_l93:    la x12, d_5_26                    ;
      addi x12, x12, 0         ;
      amomax.w x8, x20, (x12)         ;
_l94:    fsgnjx.s f28, f16, f17                    ;
_l95:    la x16, d_2_10                    ;
      addi x16, x16, -0         ;
      sc.w x27, x16, (x16)         ;
_l96:    fmv.x.w x17, f22                    ;
_l97:    fsgnjx.s f11, f5, f17                    ;
_l98:    srli x19, x22, 0                    ;
_l99:    la x11, d_2_10                    ;
      addi x11, x11, -8         ;
      amominu.w x8, x21, (x11)         ;
_l100:    la x5, d_4_0                    ;
      lui x19, 0xffe00         ;
      xor x5, x5, x19         ;
      sb x9, 23(x5)         ;
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
                .dword 0x120bc199711c2efd, 0x1c22efa7221e23b0
                .dword 0x26a61a12dd323519, 0x8b424a53e249e5bd
d_0_0:          .dword 0x5e7a6bd5dcb5f903, 0xe25903eb272a2089
d_0_1:          .dword 0xd511ac3d2b5717ee, 0xf84cc9d889557197
d_0_2:          .dword 0x5f9d6021fcf567a1, 0x537e1249c979d7bf
d_0_3:          .dword 0x1043a06bcf873b76, 0xd91c6589404a96d2
d_0_4:          .dword 0xbf8d503076a4c4ba, 0x87c9dda8e9dad1a5
d_0_5:          .dword 0x1c70377a4ef4672c, 0xf56a07f6d0223c57
d_0_6:          .dword 0x3c99bb4c1e9c1dd8, 0x7d3dd484303179d3
d_0_7:          .dword 0x1f3a06a8ac14be5a, 0x3cbad72ccbd65fd6
d_0_8:          .dword 0x17abeb8a4bb100f9, 0x431be1f6b85c53b0
d_0_9:          .dword 0x99a3b2a77acf6fd7, 0xd29ac7f62c417c36
d_0_10:         .dword 0xe50ed9613a56762e, 0xfffaa1c5ef9908fe
d_0_11:         .dword 0x459ce3b69d0329b5, 0xf756862f6f8633fe
d_0_12:         .dword 0x1e3386a0a996c201, 0x8ea97a1dcf88eb9d
d_0_13:         .dword 0xbba7175034f6dc58, 0xf394a70be8d15bb1
d_0_14:         .dword 0x7a9f1278cba9374b, 0x104c253d373ba0a3
d_0_15:         .dword 0xc3a401ba15450718, 0xde48b44a554ed0ee
d_0_16:         .dword 0xff41de56e7a93076, 0xde106af7f97c85a2
d_0_17:         .dword 0xdcff32ff1ee0a8b4, 0xd5b759aa3fe318f3
d_0_18:         .dword 0x2675a8350b4da505, 0x26bc6865b8770c54
d_0_19:         .dword 0xd6ae5414c13c270b, 0x2837b4e5387305d9
d_0_20:         .dword 0xee3042253294d66e, 0xce9b2defb673224f
d_0_21:         .dword 0x40472b95489a11d5, 0xcacb1bd24f514da7
d_0_22:         .dword 0x84dd2676845ac523, 0x8f4d108d1c8005f8
d_0_23:         .dword 0x05073de12ffeba9b, 0xf367dc562a9f2d06
d_0_24:         .dword 0xc6570a936e768cd4, 0xa87d5713146b0611
d_0_25:         .dword 0x8944ab7b29369c4a, 0x73972ea8f60c6500
d_0_26:         .dword 0xadcd713951f71635, 0xb2c506d01dd75ca7
d_0_27:         .dword 0x1bfd29f2a640701e, 0x36b8aa98f95bf5aa
                .dword 0xfa25fcacff8b61f8, 0xd50f747e19f29876
                .dword 0x5d16f89d25c5e9c3, 0x079c33acbec276b1
        /* Random data */
_end_data0:
                 

    .section .data.random1;
    .align  8;

_random_data1:
                .dword 0x2424eb223b16288a, 0xf78796603e164d63
                .dword 0x2517d4d9ee2ca1f5, 0x833c694c74003917
d_1_0:          .dword 0xd315e52bca83e6bf, 0xe44c5444022de861
d_1_1:          .dword 0x9132897592972d85, 0x87aa22310a659b4b
d_1_2:          .dword 0x2bde8a058f8f4ddd, 0x4006cd543ad9981f
d_1_3:          .dword 0x6cf52e300c935f72, 0x864aecc7789d733e
d_1_4:          .dword 0x6cff8145c7591d02, 0x000a19fdbd961fb1
d_1_5:          .dword 0x9ab6d49583837ee2, 0x3d1e242ba4cd667d
d_1_6:          .dword 0xe4669fd38205a67b, 0x3738ce1f5ef257da
d_1_7:          .dword 0x39ebf79ee949534b, 0x7ae8da47437721c2
d_1_8:          .dword 0xb9531b42d47d4030, 0x8c6b45c66a375cc5
d_1_9:          .dword 0xcdf4884958e83802, 0x6d86134d6e2e72a1
d_1_10:         .dword 0xb61950246204026c, 0x52d32d281ad2b7a9
d_1_11:         .dword 0x3305f58ed53a0d45, 0xcea9f15d2b1cc32a
d_1_12:         .dword 0xd7acc8b1c47093ad, 0x89beb697a130df4f
d_1_13:         .dword 0x1a9048c853df468f, 0x3c6dc7a362e64571
d_1_14:         .dword 0x40e5eaec0667bcca, 0x6ca7a84673ac4687
d_1_15:         .dword 0x84706d4a95c5775f, 0x80dfcd48e7970985
d_1_16:         .dword 0x95eaff1aede62219, 0x3a6ab57a76fb204a
d_1_17:         .dword 0x0e7f9ae7e4cf4ff8, 0x230f8d48269a4aeb
d_1_18:         .dword 0xf08ae6db6d2bf80c, 0x1435af90b91d7052
d_1_19:         .dword 0x8b4e35bbf7b77c75, 0x143f70cfcf476190
d_1_20:         .dword 0x828be6c12108c9b8, 0x7e276b739972d4ab
d_1_21:         .dword 0x2328a3cc634fe97a, 0x42f2b942f6425c98
d_1_22:         .dword 0x88737851ecb54da6, 0x2874613fbbae02a3
d_1_23:         .dword 0x7a59002439a095f8, 0xfc8ebf92cccae367
d_1_24:         .dword 0x8446de4380fcacb1, 0x0e84953be421c7a1
d_1_25:         .dword 0xc3d52294c32b88f2, 0xe1ed6600cc548ff1
d_1_26:         .dword 0x7f96d3d8c93621a0, 0x1e6dd412476d4bf0
d_1_27:         .dword 0xca81b6e66c551a46, 0xe0360f6daedc7cd5
                .dword 0x67b19a47d7cb3402, 0xc4d48d091cf39a79
                .dword 0x46ba55a2194a1b9c, 0x1040616377a3d5ca
        /* Random data */
_end_data1:


    .section .data.random2;
    .align  8;

_random_data2:
                .dword 0xf91799a7dc2e1683, 0x8ea612d2f8e5b6b4
                .dword 0xe0c2c4052fc36e9e, 0xb0c65fe72e3cf3a8
d_2_0:          .dword 0xc6ca93c88969a9d1, 0xd3896135fed56ac9
d_2_1:          .dword 0x7bf57797d6bf935c, 0x5863b5ecc05167f0
d_2_2:          .dword 0x87438fd20c746b94, 0x946cc2a683fb2d04
d_2_3:          .dword 0x54af0550f769ae03, 0x51d0768da065c7de
d_2_4:          .dword 0x1daaff7493630ef2, 0xb488a9371f5cfaed
d_2_5:          .dword 0x547b74797ba1605f, 0x7c81a3faff853604
d_2_6:          .dword 0x6f5baf0cd7db3268, 0xad30168368716f93
d_2_7:          .dword 0xafe4bd3040dff9a1, 0x75cea27256973188
d_2_8:          .dword 0x9253f09a9c3c29c9, 0xfee39ad69c2811a5
d_2_9:          .dword 0x389992f03c058d79, 0xe3fe0bf33a53bf86
d_2_10:         .dword 0x811d4079bba721e3, 0x9e1704b095351cae
d_2_11:         .dword 0xc980f891f8e59d96, 0x20fe816cf38b66f5
d_2_12:         .dword 0x97ce89d51bf5a673, 0xeb7bb31743ae8779
d_2_13:         .dword 0x2512384e3fdbeef7, 0x22da3854248e3359
d_2_14:         .dword 0x87835595c4344e53, 0x99087c0c44fedd63
d_2_15:         .dword 0xdec1c4c782cb03a9, 0x0a5cb8b2c5407587
d_2_16:         .dword 0xf796df528a337ee9, 0x2525ae6a4aac447e
d_2_17:         .dword 0x2c3a9924e7453180, 0x03de361f1b077443
d_2_18:         .dword 0xaecd9f7de9468846, 0x5ea5fe0bd747ce37
d_2_19:         .dword 0xe4833dc98f28760e, 0xa2861a2857e83952
d_2_20:         .dword 0x342e050667f0a8be, 0x9611dfc14047eb45
d_2_21:         .dword 0x5b0f3fe6233b09d2, 0xb1c8644ca918a615
d_2_22:         .dword 0x28c6d0c76569cdf4, 0x1e33202a2f756197
d_2_23:         .dword 0x59514c0bf157bd70, 0x5a4fbe530b91ea73
d_2_24:         .dword 0x58cbc97fd8357506, 0xa2c034fb47a50670
d_2_25:         .dword 0x36675687870c4772, 0x3f07ff50362b378b
d_2_26:         .dword 0x19c35a114e878027, 0x7f3947678c4c5a51
d_2_27:         .dword 0xe62f9f9a879b8f89, 0x949d5b64721d0827
                .dword 0x61043f715198740b, 0x78259d808b2b4509
                .dword 0xdd00c6cd05c1cd18, 0x0974aafa0fac0284
         /* Random data */
_end_data2:
                

    .section .data.random3;
    .align  8;

_random_data3:
                .dword 0x577ebb813e27d86d, 0x3ac00bde310a41c7
                .dword 0x0482e4ae9f8ad952, 0x3f9720713252a6ca
d_3_0:          .dword 0x5058daaf903afb2b, 0xb966cdae687518bc
d_3_1:          .dword 0x957a0974943fb668, 0x4921e51c161996e4
d_3_2:          .dword 0x5d786daac2641c9b, 0x310c8b06b34c61c4
d_3_3:          .dword 0xb9972b18d4856223, 0x007fb7b2b49a5fbb
d_3_4:          .dword 0xe985c8fefd12b2c7, 0xbc0d11d085221633
d_3_5:          .dword 0xbd71bf44e29cdbec, 0xf733042fa8f41585
d_3_6:          .dword 0x587cdff3dacd1e5b, 0x6345e36776bed24f
d_3_7:          .dword 0x5208a5687ee89567, 0xa38d49a4d8e679a1
d_3_8:          .dword 0x781a0a5b99b1884c, 0xbd95392ef7d49c3c
d_3_9:          .dword 0xbc23bedff540d9dc, 0xe2c95d30d9e80cc1
d_3_10:         .dword 0xa20ebb7b6bb37cb1, 0x6a43cfbf81474023
d_3_11:         .dword 0xd72d7f1861480dab, 0x4458485a70ee294c
d_3_12:         .dword 0x0dbcdb6367b1a879, 0x417fca7aa1ffc4d8
d_3_13:         .dword 0x1a60e4e28fe071b0, 0x581ce6373f165d1e
d_3_14:         .dword 0x6405ab9d4f2a1bca, 0x383ee8cbc8b0b2b1
d_3_15:         .dword 0x0a0d175fe4f7776b, 0xaddadaa8f781041d
d_3_16:         .dword 0xd5e7502218819a9d, 0x979923d70bf3b0ec
d_3_17:         .dword 0xd587e447ec32886e, 0x03fef9c164f2fdf0
d_3_18:         .dword 0xcdecaa439684ce04, 0x220bc150e314dce1
d_3_19:         .dword 0x00ba405007c0d4f7, 0xb22fcc38c9421fb3
d_3_20:         .dword 0x240383584dc3c867, 0xdcfd16fd85a5290c
d_3_21:         .dword 0xbeb74d302efa1dbe, 0x89387b9d899e2d65
d_3_22:         .dword 0x098dce7986e9baa1, 0x3c914424fa1cb3fb
d_3_23:         .dword 0xb9ff82ec4efa6cf3, 0xb830d86c56a3deb9
d_3_24:         .dword 0x6c81c9d1ccc886e2, 0x02ae7fc081874730
d_3_25:         .dword 0x90b6436e42637621, 0x2c6463f171142944
d_3_26:         .dword 0x71d1700a1d25d447, 0xc8fc8a8d0bb690aa
d_3_27:         .dword 0x64f27bbfea0a5c87, 0x45f5516f7e628d0b
                .dword 0xa1fff99cc0e09255, 0x4a0cb210a676a7ae
                .dword 0x456b4d925f23b430, 0xa8cf90418edaac40
        /* Random data */
_end_data3:


    .section .data.random4;
    .align  8;

_random_data4:
                .dword 0xc847f5b429c30673, 0xa15ce61000e97b64
                .dword 0x8bcad5a81c2f6419, 0x431c02787ab6924d
d_4_0:          .dword 0xc42154df252a1de7, 0x69c9c7ab00f7a75c
d_4_1:          .dword 0x44a579cd304e9bbf, 0xc0e6c3d8dba45153
d_4_2:          .dword 0x47698988896aa776, 0x0fd18f8e6872006b
d_4_3:          .dword 0x3d6beff08b557e94, 0xd813a5ff4a86d833
d_4_4:          .dword 0xa780b4564476453d, 0x71ba81ca37e466de
d_4_5:          .dword 0xbe6f698f24169d93, 0xdc33c53629684243
d_4_6:          .dword 0x55c42da62f2819f7, 0x265a23c3840407c1
d_4_7:          .dword 0x6f95be21bca7f828, 0x5e45cf95047fde2e
d_4_8:          .dword 0xdd81a53d88ad4f53, 0x957342399015914c
d_4_9:          .dword 0xb2660a7c83e543f3, 0x3746cf1bfcd8b45f
d_4_10:         .dword 0xca2bd3af19edbbe8, 0x1bc0530ad7b8be9a
d_4_11:         .dword 0x4d613ec2d1a47399, 0xad35505a5ca9ee9e
d_4_12:         .dword 0x79c22cac1b081504, 0x196655b2b974cf1c
d_4_13:         .dword 0x5f2959cb5fb57638, 0x4705f6f8734fc5a9
d_4_14:         .dword 0xdd4a90bb5cde25fa, 0x5177743b66659842
d_4_15:         .dword 0xd4b2820a98a81b64, 0x3111350905ebb391
d_4_16:         .dword 0x4be5d51eec092852, 0x14fb7b55fb878a26
d_4_17:         .dword 0x56ca4b105c6ea67f, 0xdc72549fc96febe2
d_4_18:         .dword 0xf2cfd3e318e5bae7, 0x5cd19e30d918ab18
d_4_19:         .dword 0x0533a1515bd4a222, 0xb8e7b25e4afec018
d_4_20:         .dword 0x8eb9eadddfe26f52, 0x26ba57e3b61c2295
d_4_21:         .dword 0xd966d418073ba3cb, 0xff50eda895f032c2
d_4_22:         .dword 0x65cc353dcc986a73, 0xbad50b9af5682046
d_4_23:         .dword 0x957458e03b3805a0, 0xe0158d11246a0de8
d_4_24:         .dword 0x9998dde50a79f230, 0x177d22b51e6d91b1
d_4_25:         .dword 0x372347d793489c38, 0x8b064be92cbf7a14
d_4_26:         .dword 0x5b58ec9de550f5b8, 0x402cb04d8409d355
d_4_27:         .dword 0xa2c767a2b15439e2, 0x78409c228f113e9f
                .dword 0x009118e8cd3aeeaa, 0xf96641378ad2fb3b
                .dword 0xfc4850d9ad33173d, 0x7297da6c6a746767
        /* Random data */
_end_data4:


    .section .data.random5;
    .align  8;

_random_data5:
                .dword 0xb5cedcb9212fa8e1, 0xc14f057787383475
                .dword 0x6e46734f280261c3, 0x74f4a77824f9ab17
d_5_0:          .dword 0xb6903ad7a58bcb85, 0xae1f23841d955db3
d_5_1:          .dword 0xaf46284dd45ce7ee, 0xb72232c17c05c728
d_5_2:          .dword 0xea1d1ef60c39a533, 0x81169854a4ccc084
d_5_3:          .dword 0x8609b1b907ca804b, 0xc60ebcf9ccbeae75
d_5_4:          .dword 0xc7f32f91e795dd51, 0x8d34d9ea047b5672
d_5_5:          .dword 0xaaf0426433c3c579, 0x264d2f42fae8b6f0
d_5_6:          .dword 0x265009cb67758a3d, 0x5d080561a754d2bf
d_5_7:          .dword 0x9799d4c907a88aff, 0xee3b95c2918b4c02
d_5_8:          .dword 0x1cd618fc84d4d735, 0x52bc481b54936739
d_5_9:          .dword 0xe03e12fa010e5171, 0x2d3dc2eafb8a49ef
d_5_10:         .dword 0x9da089a870a47582, 0x562b9614e2189ab1
d_5_11:         .dword 0x218935a0b3eb67da, 0x1f7183fcff5a86b0
d_5_12:         .dword 0x9f98989c6ba892a5, 0x7666cd942a0fc8aa
d_5_13:         .dword 0x37eada668f3aa11e, 0xb282e0677a89f3fe
d_5_14:         .dword 0xe90af38aca95f827, 0x14af7e6b6eef3798
d_5_15:         .dword 0xc43b2847c65b8d3c, 0x001470af42e1b6eb
d_5_16:         .dword 0x0ec1537f26812ba1, 0xdd5ee709ee945414
d_5_17:         .dword 0x343867cf75dfa368, 0xe8063c4d4d8cb620
d_5_18:         .dword 0xb9c39f372e62c876, 0x4fdd8748133755a4
d_5_19:         .dword 0xb689a6efe8138c20, 0x048a8ea0b5d525ac
d_5_20:         .dword 0x4a90cb93c37b2332, 0xf8e5fa23bfd60f1b
d_5_21:         .dword 0x359a59340e6e86ea, 0xb5fc7f20c161e0d0
d_5_22:         .dword 0x63e629d88d1f50ff, 0x3569f7da7edb5724
d_5_23:         .dword 0x85ccbd5ad98861a5, 0xd753dfc8695c36ec
d_5_24:         .dword 0xe839251621812ecf, 0x549777ed4e67581a
d_5_25:         .dword 0xa9675ac31b0fee32, 0xee0a2f15b8582870
d_5_26:         .dword 0xa22ca23502b48c50, 0x2a62462f84c5b5c4
d_5_27:         .dword 0x14b49933476a22a6, 0x96d083ee9a60358a
                .dword 0x769a416861447cd9, 0x18d11ba8c0292ccc
                .dword 0x0d8230bf6809d842, 0x8d7643b8df8a732e
         /* Random data */
_end_data5:
              
                 
