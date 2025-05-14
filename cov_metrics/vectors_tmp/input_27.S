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
_p0:    csrrsi x10, pmpaddr4, 19                  ;
_p1:    csrrwi x10, satp, 29                      ;
_p2:    csrrci x11, sscratch, 0                   ;
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
_l2:    fcvt.lu.s x24, f16, rne                    ;
_l3:    la x25, d_1_1                    ;
      addi x25, x25, 0         ;
      amomax.d x11, x12, (x25)         ;
_l4:    addi x0, x1, 0                    ;
_l5:    la x18, d_1_23                    ;
      srai x18, x18, 1         ;
      csrrw x7, pmpaddr3, x18         ;
_l6:    srliw x18, x15, 2                    ;
_l7:    addw x2, x9, x4                    ;
_l8:    la x27, d_4_18                    ;
      sh x22, -24(x27)         ;
_l9:    flt.s x11, f28, f5                    ;
_l10:    fcvt.w.s x18, f6, rne                    ;
_l11:    fcvt.lu.s x28, f2, rne                    ;
_l12:    fnmsub.s f11, f19, f11, f22, rne                    ;
_l13:    la x23, d_2_23                    ;
      addi x23, x23, 20         ;
      amoxor.w x7, x18, (x23)         ;
_l14:    la x4, d_1_0                    ;
      flw f19, 20(x4)         ;
_l15:    fcvt.lu.s x3, f30, rne                    ;
_l16:    fmul.s f1, f8, f16, rne                    ;
_l17:    la x26, d_5_14                    ;
      addi x26, x26, 12         ;
      amomax.w x30, x8, (x26)         ;
_l18:    ori x19, x30, 418                    ;
_l19:    la x1, d_5_22                    ;
      addi x1, x1, 0         ;
      amomin.d x23, x7, (x1)         ;
_l20:    la x12, d_5_25                    ;
      addi x12, x12, 16         ;
      amoxor.d x19, x29, (x12)         ;
_l21:    fsgnjn.s f2, f6, f8                    ;
_l22:    srai x22, x1, 63                    ;
_l23:    fsqrt.s f30, f18, rne                    ;
_l24:    la x7, d_1_7                    ;
      addi x7, x7, 20         ;
      amomax.w x2, x17, (x7)         ;
_l25:    la x28, _l71                    ;
      ld x14, -0(x28)         ;
_l26:    la x7, d_2_22                    ;
      addi x7, x7, -24         ;
      amoadd.d x20, x25, (x7)         ;
_l27:    auipc x2, 919504                    ;
_l28:    slliw x13, x27, 6                    ;
_l29:    fdiv.s f7, f31, f7, rne                    ;
_l30:    xor x16, x16, x16                    ;
      addi x8, zero, 3         ;
      slli x8, x8, 10         ;
      add x16, x16, x8         ;
      addi x30, zero, 1         ;
      slli x30, x30, 2         ;
      add x16, x16, x30         ;
      csrrc x4, scause, x16         ;
_l31:    la x22, d_4_12                    ;
      sd x30, 8(x22)         ;
_l32:    la x14, d_1_14                    ;
      addi x14, x14, -20         ;
      amoxor.w x29, x27, (x14)         ;
_l33:    la x18, _l39                    ;
      lbu x26, 28(x18)         ;
_l34:    la x10, d_1_1                    ;
      addi x10, x10, 8         ;
      amoswap.w x3, x29, (x10)         ;
_l35:    la x22, d_0_12                    ;
      addi x22, x22, -8         ;
      amomin.w x15, x3, (x22)         ;
_l36:    la x6, d_2_3                    ;
      lui x29, 0xffe00         ;
      xor x6, x6, x29         ;
      sd x7, -0(x6)         ;
_l37:    la x19, d_1_9                    ;
      lhu x6, 30(x19)         ;
_l38:    sltiu x25, x19, -1264                    ;
_l39:    srlw x3, x7, x3                    ;
_l40:    fcvt.s.l f14, x30, rne                    ;
_l41:    fcvt.s.w f1, x6, rne                    ;
_l42:    la x2, d_1_13                    ;
      addi x2, x2, -16         ;
      lui x16, 0xffe00         ;
      xor x2, x2, x16         ;
      amomin.w x14, x16, (x2)         ;
_l43:    xor x24, x24, x24                    ;
      csrrw x7, sstatus, x24         ;
_l44:    la x1, d_2_14                    ;
      srai x1, x1, 1         ;
      csrrc x13, pmpaddr4, x1         ;
_l45:    addi x21, x12, 8                    ;
_l46:    sllw x15, x5, x15                    ;
_l47:    la x8, d_3_23                    ;
      addi x8, x8, 0         ;
      amoand.w x10, x3, (x8)         ;
_l48:    fmax.s f30, f14, f17                    ;
_l49:    xor x17, x17, x17                    ;
      addi x19, zero, 3         ;
      slli x19, x19, 31         ;
      add x17, x17, x19         ;
      csrrc x8, sstatus, x17         ;
_l50:    la x16, d_0_14                    ;
      lui x18, 0xffe00         ;
      xor x16, x16, x18         ;
      lhu x1, 22(x16)         ;
_l51:    fmax.s f14, f4, f19                    ;
_l52:    la x24, d_4_4                    ;
      addi x24, x24, 12         ;
      amomin.w x15, x14, (x24)         ;
_l53:    csrrci x6, fcsr, 27                    ;
_l54:    csrrsi x27, fcsr, 25                    ;
_l55:    la x1, d_2_18                    ;
      addi x1, x1, -0         ;
      sc.w x18, x22, (x1)         ;
_l56:    la x12, d_4_2                    ;
      addi x12, x12, -16         ;
      lui x21, 0xffe00         ;
      xor x12, x12, x21         ;
      amoxor.d x18, x21, (x12)         ;
_l57:    fnmsub.s f22, f24, f5, f13, rne                    ;
_l58:    la x5, d_2_8                    ;
      addi x5, x5, 24         ;
      amomaxu.d x23, x4, (x5)         ;
_l59:    fcvt.s.wu f22, x2, rne                    ;
_l60:    xor x3, x3, x3                    ;
      csrrs x19, sscratch, x3         ;
_l61:    sltiu x24, x5, -29                    ;
_l62:    sraiw x3, x14, 5                    ;
_l63:    srai x15, x30, 17                    ;
_l64:    la x8, d_3_9                    ;
      fsw f1, -12(x8)         ;
_l65:    la x4, d_5_20                    ;
      addi x4, x4, -8         ;
      amoadd.d x8, x15, (x4)         ;
_l66:    fmin.s f13, f23, f11                    ;
_l67:    la x16, d_5_0                    ;
      addi x16, x16, -0         ;
      amomin.d x29, x20, (x16)         ;
_l68:    la x15, d_1_0                    ;
      addi x15, x15, -24         ;
      lui x17, 0xffe00         ;
      xor x15, x15, x17         ;
      amomin.d x27, x17, (x15)         ;
_l69:    lui x1, 465564                    ;
_l70:    la x6, d_0_3                    ;
      srai x6, x6, 1         ;
      csrrw x12, pmpaddr4, x6         ;
_l71:    la x27, d_2_19                    ;
      lhu x13, -2(x27)         ;
_l72:    feq.s x8, f22, f0                    ;
_l73:    la x17, d_0_22                    ;
      lb x30, -16(x17)         ;
_l74:    la x6, d_3_23                    ;
      addi x6, x6, 8         ;
      sc.w x1, x18, (x6)         ;
_l75:    fcvt.s.wu f6, x0, rne                    ;
_l76:    fsqrt.s f13, f23, rne                    ;
_l77:    fcvt.s.w f17, x0, rne                    ;
_l78:    la x18, d_5_24                    ;
      addi x18, x18, 0         ;
      amoxor.d x28, x28, (x18)         ;
_l79:    la x4, d_1_26                    ;
      addi x4, x4, 0         ;
      amominu.w x21, x29, (x4)         ;
_l80:    addw x2, x5, x16                    ;
_l81:    la x2, d_3_7                    ;
      addi x2, x2, -0         ;
      amoswap.d x7, x24, (x2)         ;
_l82:    fcvt.s.l f19, x5, rne                    ;
_l83:    sltiu x16, x4, 2047                    ;
_l84:    sltiu x1, x28, 19                    ;
_l85:    fadd.s f0, f6, f22, rne                    ;
_l86:    xor x6, x6, x6                    ;
      addi x5, zero, 3         ;
      slli x5, x5, 28         ;
      add x6, x6, x5         ;
      addi x28, zero, 1         ;
      slli x28, x28, 11         ;
      add x6, x6, x28         ;
      addi x11, zero, 3         ;
      slli x11, x11, 7         ;
      add x6, x6, x11         ;
      csrrs x1, sscratch, x6         ;
_l87:    la x16, d_5_27                    ;
      addi x16, x16, -16         ;
      amomax.w x3, x28, (x16)         ;
_l88:    la x2, d_3_25                    ;
      addi x2, x2, -0         ;
      lr.d x12, (x2)         ;
_l89:    fdiv.s f4, f23, f13, rne                    ;
_l90:    fmin.s f7, f1, f9                    ;
_l91:    srli x12, x24, 41                    ;
_l92:    lui x20, 726996                    ;
_l93:    ori x8, x19, 0                    ;
_l94:    la x22, d_1_15                    ;
      lbu x16, 0(x22)         ;
_l95:    la x30, d_3_1                    ;
      addi x30, x30, -16         ;
      amomaxu.w x6, x5, (x30)         ;
_l96:    sraiw x3, x16, 2                    ;
_l97:    fnmadd.s f27, f6, f8, f18, rne                    ;
_l98:    mret                    ;
_l99:    fadd.s f7, f30, f2, rne                    ;
_l100:    addw x15, x5, x1                    ;
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
                .dword 0xdad1af68a064a604, 0x85b1c9e8be7a41a3
                .dword 0x97ee5cffc47bd9a6, 0x9d6c3841979a1eee
d_0_0:          .dword 0xbddc195f3833c6fc, 0xf3096f0046f7f45f
d_0_1:          .dword 0x7f11e80dd52b0627, 0xa80f0a40bd9462a6
d_0_2:          .dword 0x1291f9b30a4149dd, 0x711fb75ae72a1e1b
d_0_3:          .dword 0x93c7ecb8f7ffdd21, 0x6277c6913a242200
d_0_4:          .dword 0xc8838199928339d3, 0x6c21d9b38e0265fe
d_0_5:          .dword 0xfe09d97ad7440c3d, 0x11e7530b51b477b1
d_0_6:          .dword 0x7be42756031f5ba0, 0x591f58609571f35f
d_0_7:          .dword 0x4387cbd6f0dfa7d7, 0xd555539cb98ff5bb
d_0_8:          .dword 0xdc118c647f1dfd7c, 0x29112c9fd1cf1710
d_0_9:          .dword 0xa17e8ccab20c08f9, 0xc12282d511d6746e
d_0_10:         .dword 0x78f8b0101e623e73, 0x824fff74e29b6681
d_0_11:         .dword 0xc59df908c8e0e8c0, 0x6717ea38c5ec4161
d_0_12:         .dword 0x032245e3d2949759, 0x68e418a7aa0b34d5
d_0_13:         .dword 0x543b629ff307395d, 0x482452ba3735f26c
d_0_14:         .dword 0xbfb348233183f2e7, 0x4267abc4f0b658d3
d_0_15:         .dword 0xb95eb3bfd78f1d2b, 0xf1be3952b681645d
d_0_16:         .dword 0xf3a570df3ac84212, 0x753b19eb2ae2a161
d_0_17:         .dword 0xf7148a2882aef6a7, 0xe0f5c556ae3a70c9
d_0_18:         .dword 0x4310f10cb11d565e, 0x99f522630f60877f
d_0_19:         .dword 0xb360b033510d0c34, 0x18eb9ff4c4ced188
d_0_20:         .dword 0x7b900711d4a5dcab, 0x3285034ab2a83043
d_0_21:         .dword 0xc73ce036b5070c23, 0x269dfa3f4f6a9d0e
d_0_22:         .dword 0x72d3d1243b7dfef7, 0x92b014181b97b399
d_0_23:         .dword 0xc37d55d0598849e4, 0x913e3443badd4b57
d_0_24:         .dword 0x9d329e42ff3f00a0, 0xdc19c6bfb2a2d36e
d_0_25:         .dword 0xbb376d63d55b7529, 0xc17e31f5ea71f99d
d_0_26:         .dword 0xcdda4e69210a992d, 0xc3d3c6b403fef4be
d_0_27:         .dword 0x15fad711296a9db5, 0x63746c66fc43c97b
                .dword 0x454bb17e0da7e8a3, 0xcd97e85a0a786b79
                .dword 0x67b657935a4cdca7, 0xe58e01e2116c7784
        /* Random data */
_end_data0:
                 

    .section .data.random1;
    .align  8;

_random_data1:
                .dword 0x22da2de4bb3a90a4, 0xaa0c27309dbcdbc8
                .dword 0x8ea8cdb71c03476f, 0x122d31c736125a4b
d_1_0:          .dword 0xce1367784834d90a, 0x28dba8906351db55
d_1_1:          .dword 0x3830b67e4ae4a62c, 0xa02bb54a74ab7efe
d_1_2:          .dword 0x9dc90c47712751c6, 0x34f0fff58e81ab65
d_1_3:          .dword 0xb914954044bc8385, 0x10ce93779ecfc5db
d_1_4:          .dword 0x86fd8e25fe65fb99, 0x6a71db32fc62ef30
d_1_5:          .dword 0x355e970929a199d8, 0xaef7d519801487df
d_1_6:          .dword 0x7d6259aeea3d0b2b, 0x7b424663bc812790
d_1_7:          .dword 0xe3476ce5e85a992a, 0x5a2a0545b7e57b84
d_1_8:          .dword 0x55ce66cd2aef0833, 0x0b51cd792f59f5e2
d_1_9:          .dword 0x4744e9e0eac0f331, 0x99c0c53b0c86e009
d_1_10:         .dword 0xf343a7404d2c79d2, 0x9fa9ad0b2fbcf201
d_1_11:         .dword 0x15ce458b7c570c1e, 0xf14dd4326496ae7f
d_1_12:         .dword 0xe23e6b3572b33a1e, 0xacb6a1707bbaf4a2
d_1_13:         .dword 0x4047294f075c12bf, 0x9e7bda717b03ec5a
d_1_14:         .dword 0xd2317c37c63ec5d6, 0x9856d4437f4738c9
d_1_15:         .dword 0x584478d14a84e2f9, 0x55946e013d39f681
d_1_16:         .dword 0xc07c37a8967f753f, 0xa03714e9e27e9ad4
d_1_17:         .dword 0x9ae102e8e36d5cb7, 0xf80b2faf5271d245
d_1_18:         .dword 0x2838fbb94cf493d1, 0xf9e8cba1b22fd538
d_1_19:         .dword 0x0f1cc6279123cde3, 0x513977a438b244e1
d_1_20:         .dword 0x22cba93e22465146, 0xf687ad63b2ba0bb3
d_1_21:         .dword 0xb79d141f2aeed968, 0x42cec251b7b507f0
d_1_22:         .dword 0xd5137da7422b6685, 0x2f9cbfdb624661d3
d_1_23:         .dword 0x781f47a08d576215, 0x3fb01504b7df439a
d_1_24:         .dword 0x2c90ad008f0b7935, 0x430803ca8e76961d
d_1_25:         .dword 0xadcdcb1580285a20, 0x1efd9772a393cf7d
d_1_26:         .dword 0x67d8af2d9f432d98, 0x2e0994d5e5ed9c77
d_1_27:         .dword 0x5c49f7b12f4105b6, 0xdd73cc34cfb93e77
                .dword 0x3abffce14b5cab17, 0x9d502dcfa2d20436
                .dword 0xadd812791e24636f, 0x1f640707061ff860
        /* Random data */
_end_data1:


    .section .data.random2;
    .align  8;

_random_data2:
                .dword 0xeb8a2d000adfe99d, 0x8676021e182eca73
                .dword 0xf62d884eeef0f71a, 0xc9cfe98d40e6d6ef
d_2_0:          .dword 0xe50c8c24b0ff9cdd, 0x6e67715142c116fd
d_2_1:          .dword 0x9b9f886c011c4b9d, 0x00563fb46fdd7ac2
d_2_2:          .dword 0xa5c7abbf6c1e1f23, 0xf16f2a4f2012bbcb
d_2_3:          .dword 0x7aa3634174ddb275, 0xc24f434d03bfa264
d_2_4:          .dword 0x7752c8a32a6fe7a4, 0x95caeee9311fe168
d_2_5:          .dword 0xcbfc6953f74c518e, 0xa21257246508e033
d_2_6:          .dword 0x1f8fe36891258987, 0x1bb023d6a52b6b1a
d_2_7:          .dword 0x90fff86aa6447f7f, 0xad428b7b76b698ce
d_2_8:          .dword 0xda6a309929e5824b, 0x9fde7f3f4aa24ebf
d_2_9:          .dword 0x1e53ea6d456841ad, 0xae2a90e6dd0d76a6
d_2_10:         .dword 0x9c064108a2fab957, 0x046058977c737f9d
d_2_11:         .dword 0x14c25ea2db9ca67f, 0x43131eca7dd4d017
d_2_12:         .dword 0xbce88b3a1e3d1bf1, 0xa3c74ed0355e951a
d_2_13:         .dword 0xf64d96d9eb4fdfdf, 0xd1a5481c1be1c6c2
d_2_14:         .dword 0x6c79f87f0c1fad30, 0x7264c365b1f12d7d
d_2_15:         .dword 0xc5466e0ec4fa7899, 0x5755fd070bba69d0
d_2_16:         .dword 0x940adad3c537f8f4, 0x274cd292b8fc976f
d_2_17:         .dword 0xdec3bb6ecfffdcd7, 0x35a33efb685f8be3
d_2_18:         .dword 0x2f019122eb9252a8, 0x409e9d8ce1c5ffc7
d_2_19:         .dword 0xe2601eac108f3408, 0xc81a10361f7abf1a
d_2_20:         .dword 0x92067aee2956edde, 0xe709928c4818c069
d_2_21:         .dword 0xb1c1a61864d8096e, 0xa74e25097337eb9d
d_2_22:         .dword 0x091ea969dc735546, 0x3bac992218b7e34f
d_2_23:         .dword 0x01136b32070ef7d8, 0x5d58ff968c29b4f3
d_2_24:         .dword 0xe89b7cbccd54f2d1, 0x5e5a0132fbee9f44
d_2_25:         .dword 0xb0e963f95b432b78, 0x34a7f5f3225b5ae3
d_2_26:         .dword 0xae75f876bf3fef85, 0x9516e24ef55a1795
d_2_27:         .dword 0x5785443a076cfbe5, 0xe5b47f4d76d68ac4
                .dword 0xd0377fe121502320, 0x5cba0bb17811130e
                .dword 0x22ceb55bbc32d011, 0x24b069c36254f780
         /* Random data */
_end_data2:
                

    .section .data.random3;
    .align  8;

_random_data3:
                .dword 0xe2432b5f91fe2058, 0xac953a05a9c220bd
                .dword 0x046bffc9d925723f, 0x5d0d4710462eeebe
d_3_0:          .dword 0x99bf2638b44c6339, 0xf4c6a647670f0e4f
d_3_1:          .dword 0x4fa49e098bb62b59, 0x370523c90c9fb705
d_3_2:          .dword 0x1016459da7318cc7, 0xa42a7a619a679901
d_3_3:          .dword 0x2c32d837648b6806, 0x24e8e435f1ebb9bc
d_3_4:          .dword 0xa0ad1250d79d4044, 0x7b923866630d7da5
d_3_5:          .dword 0xaafe9b609ccd444f, 0x233491455d49789d
d_3_6:          .dword 0xe48e59a0450cd8f5, 0x9a70cfd8b94acfd7
d_3_7:          .dword 0x151d78694349918b, 0x43f374ca726b31ea
d_3_8:          .dword 0x4af5ca002d9fedf8, 0xb6bbb7f0bfe9d631
d_3_9:          .dword 0x4ab20d0d5b043d85, 0x737f695c7a8d7382
d_3_10:         .dword 0x993f834a122ab3e6, 0xc40231a571e734e2
d_3_11:         .dword 0x04c13bacb967f6af, 0xd988922be9665b3c
d_3_12:         .dword 0xb38a6c6e32160105, 0x9f2273c8126f8b9e
d_3_13:         .dword 0x27e1ca82c9ba91d5, 0xf13c20596b861b90
d_3_14:         .dword 0x9d342500c017d3e7, 0x3b00aa81a8f98ed9
d_3_15:         .dword 0xb97c1f00a0177573, 0x3a5a4ffbc34393ab
d_3_16:         .dword 0x7da14aa5b0f4c89a, 0xfe5a7b223a09001a
d_3_17:         .dword 0x7667d27ded88eaf1, 0x14761c8d4f2a47dc
d_3_18:         .dword 0x030c7dda50e84076, 0x8a22912550eaf405
d_3_19:         .dword 0x7d303a1563cdec68, 0x986f816f6a5ae236
d_3_20:         .dword 0x6ffe76abbf353c00, 0xe1edcb4e68d8a42b
d_3_21:         .dword 0x72dc441a7ba4eb59, 0x6c7ae982dd2a6ee8
d_3_22:         .dword 0xbab21719e0c7da56, 0x2e6ca77f4cc8eefc
d_3_23:         .dword 0xd68eef8915352161, 0x77c42edf7ac1bcba
d_3_24:         .dword 0x2500cfbaaa240b0c, 0xf59cc486d8ea0262
d_3_25:         .dword 0xdc32d8d763a7d1e3, 0x8558e89c042620bc
d_3_26:         .dword 0x8eb41d716c1d5370, 0x0f7d9d913b819e46
d_3_27:         .dword 0xea03168a2e3b8fcd, 0xdf1da3d3fb33ce6a
                .dword 0x36ee3c2b2444d1d8, 0x0052979d8ad825c2
                .dword 0xfdf35672468a0559, 0x17c072a86f8ded47
        /* Random data */
_end_data3:


    .section .data.random4;
    .align  8;

_random_data4:
                .dword 0xc670a1fd82dce248, 0x04ef8418a4a8a632
                .dword 0xa12430a1c9e6b73d, 0x76a7ad9d9c2fedef
d_4_0:          .dword 0x0daa2bce877d952a, 0x7a9b19f809222811
d_4_1:          .dword 0x2e7444249140be61, 0x91b18269bc937a0a
d_4_2:          .dword 0x294dfcc452b4d009, 0xcc8dc2bb457183b6
d_4_3:          .dword 0xea0acb77dad5487c, 0x193d46b1a58314cd
d_4_4:          .dword 0x7f25cf86aa29225b, 0x0f585be65713f976
d_4_5:          .dword 0xdfee9c332edbaa07, 0x0966878fb4e3f408
d_4_6:          .dword 0x08559c30601af2ab, 0xd60672035c1289fd
d_4_7:          .dword 0xa31820e92041825d, 0xe2ce7d8c54c36e4c
d_4_8:          .dword 0x4d3166249bb16b4d, 0x85bf46c677bc34bf
d_4_9:          .dword 0xaeb60caf6e349e23, 0x3cb29f1811619290
d_4_10:         .dword 0xc18c05ec6b37d0b2, 0xb2f9071bfe5bfe95
d_4_11:         .dword 0xa77e5cc0c99d9c90, 0x52f585dc4713f244
d_4_12:         .dword 0x6525156205bd1fc6, 0x9df979ead9789942
d_4_13:         .dword 0x78ee010b81a362a5, 0xe0c2f22c3e861232
d_4_14:         .dword 0x789c0c1958a67a58, 0xc1e282cb7a8cdc8e
d_4_15:         .dword 0x1703175dec95d95a, 0x27fa0e369a9f8cc7
d_4_16:         .dword 0xd12fa5252082bfe8, 0x6833b37b70b758eb
d_4_17:         .dword 0x4f00e0b0f8ffb267, 0x35cc52fa55fc102e
d_4_18:         .dword 0x64a1a451948f407e, 0x7f82f466b96ac9d9
d_4_19:         .dword 0x68727bccca47e3bc, 0xb2d638b47439b924
d_4_20:         .dword 0xd3d7e1a50e802c2b, 0x9f9f0f7b89d0b84a
d_4_21:         .dword 0xbbad21c8778ffe6c, 0x88ea0c86eca9d20d
d_4_22:         .dword 0x5d549577c87ffa6c, 0xbc98afea6c8218d4
d_4_23:         .dword 0xd5bbc21a6d847c00, 0x8e32d17987a147eb
d_4_24:         .dword 0x48123bc4ec08fbb2, 0x8cae96c97b548aa3
d_4_25:         .dword 0x0ada6af1afdbde86, 0xb891f4a0686ee5f0
d_4_26:         .dword 0x600c35644262afe4, 0x0fdd8d69983d750b
d_4_27:         .dword 0xc39706c2ef49a834, 0x0c9749bd2ed564cc
                .dword 0x6c4c405934287206, 0x2399eaca6ebf6104
                .dword 0xcb157559265591e6, 0xe80bd6783b49a995
        /* Random data */
_end_data4:


    .section .data.random5;
    .align  8;

_random_data5:
                .dword 0x2547e78c344eb615, 0xc1a3d5f60c0447df
                .dword 0xb049f959d70299e8, 0xde49f984041e8c08
d_5_0:          .dword 0x3fbfa5c720841cff, 0x281ab525c3163b5e
d_5_1:          .dword 0xd83df4393e454f5c, 0xd9f15df446eaf881
d_5_2:          .dword 0x9aaee3ba9cdd6b44, 0x430ad953c5351da2
d_5_3:          .dword 0xbf84e87dd967da93, 0x2fa42275d682be6e
d_5_4:          .dword 0x8fa597331e20e9ed, 0x156a17cbf53dfea0
d_5_5:          .dword 0x8fc8541e62ac2488, 0xd67fa7e5e6c3732a
d_5_6:          .dword 0x5b6cc6488cae7af9, 0xec6de5935e497155
d_5_7:          .dword 0x2c66fbd1491b1504, 0x22cd277b4571b99c
d_5_8:          .dword 0xc201aac5535d0cc0, 0x91a32f67e7da3573
d_5_9:          .dword 0x9d42699e77fade95, 0x017660e7d9fd36d5
d_5_10:         .dword 0x5a79881d582b7c6a, 0x6c068969e682e03a
d_5_11:         .dword 0x2be30f1bcd41e788, 0x4d6104b87ae8f2db
d_5_12:         .dword 0xef565214946c0eaa, 0x46d025db945302f8
d_5_13:         .dword 0xa4f21114c8afd046, 0xca7d9a31dccee86c
d_5_14:         .dword 0x7147259638543845, 0x9908b4fe799050ca
d_5_15:         .dword 0xc152a0196c2c65ef, 0x339805d93c605987
d_5_16:         .dword 0xa2bf45917a145301, 0xf35310d7877a1864
d_5_17:         .dword 0x8726d7cee6265c21, 0x3f63aca81e58632a
d_5_18:         .dword 0x172b90a61ea7a6b3, 0x409e12ac88689be3
d_5_19:         .dword 0x13c528403b34e9c1, 0xb51d5b76804da1e1
d_5_20:         .dword 0x154085097bf0a6a3, 0xdbc782236243fdad
d_5_21:         .dword 0x142b6b38dfc08839, 0xd6c4e5cd7eb264ba
d_5_22:         .dword 0xa630f4e300905d90, 0xa5bc8ea2d6cf1054
d_5_23:         .dword 0xc258b902b5005186, 0x6729337fbfb80b75
d_5_24:         .dword 0x33f1ca374285dae4, 0x501c284324856bf6
d_5_25:         .dword 0x9d341df1cb393009, 0x1c805f3bb5e2cef0
d_5_26:         .dword 0x4aedbb915c1a71c6, 0xfad86e9a7c9a4359
d_5_27:         .dword 0x9a8d95ae965ad29c, 0x1e08758fe4359346
                .dword 0xf434636785953f78, 0xad3d209f2f26db4c
                .dword 0xfa203986253df0db, 0x398d1f927e5fef32
         /* Random data */
_end_data5:
              
                 
