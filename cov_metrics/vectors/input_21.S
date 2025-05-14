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
_p0:    la x11, d_5_22                            ;
        srai x11, x11, 1                          ;
        csrrw x10, pmpaddr3, x11                  ;
_p1:    csrrci x12, stval, 15                     ;
_p2:    csrrwi x11, pmpaddr6, 4                   ;
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
_l3:    la x5, d_5_15                    ;
      addi x5, x5, 0         ;
      lr.w x18, (x5)         ;
_l4:    la x3, d_2_3                    ;
      lb x20, 0(x3)         ;
_l5:    auipc x30, 992                    ;
_l6:    la x25, d_1_1                    ;
      addi x25, x25, 0         ;
      amomax.d x11, x12, (x25)         ;
_l7:    fcvt.s.lu f22, x28, rne                    ;
_l8:    fnmadd.s f25, f9, f9, f17, rne                    ;
_l9:    la x21, d_0_0                    ;
      lb x6, -31(x21)         ;
_l10:    sllw x11, x24, x25                    ;
_l11:    la x13, d_5_17                    ;
      addi x13, x13, 16         ;
      amoxor.d x6, x23, (x13)         ;
_l12:    xor x22, x22, x22                    ;
      addi x2, zero, 3         ;
      slli x2, x2, 1         ;
      add x22, x22, x2         ;
      csrrc x30, sstatus, x22         ;
_l13:    la x30, d_0_26                    ;
      addi x30, x30, -8         ;
      amoxor.d x18, x17, (x30)         ;
_l14:    fnmadd.s f8, f29, f21, f11, rne                    ;
_l15:    la x3, d_5_2                    ;
      sb x2, 0(x3)         ;
_l16:    feq.s x28, f26, f5                    ;
_l17:    sraw x11, x14, x13                    ;
_l18:    fmadd.s f12, f23, f29, f4, rne                    ;
_l19:    lui x1, 465564                    ;
_l20:    la x18, d_1_23                    ;
      srai x18, x18, 1         ;
      csrrw x7, pmpaddr3, x18         ;
_l21:    fmadd.s f21, f7, f28, f4, rne                    ;
_l22:    fcvt.s.lu f18, x17, rne                    ;
_l23:    li x4, 1                    ;
      la x14, pt1         ;
      addi x14, x14, 40         ;
      sfence.vma x4, x14         ;
_l24:    fnmadd.s f22, f13, f14, f23, rne                    ;
_l25:    la x18, d_4_12                    ;
      addi x18, x18, 8         ;
      amomin.d x20, x24, (x18)         ;
_l26:    li x12, 0                    ;
      la x14, pt3         ;
      addi x14, x14, 56         ;
      sfence.vma x12, x14         ;
_l27:    flt.s x29, f0, f6                    ;
_l28:    addi x0, x1, 0                    ;
_l29:    srlw x26, x5, x28                    ;
_l30:    la x18, d_1_23                    ;
      srai x18, x18, 1         ;
      csrrw x7, pmpaddr3, x18         ;
_l31:    la x6, d_0_19                    ;
      addi x6, x6, -8         ;
      amoand.w x14, x14, (x6)         ;
_l32:    fmax.s f1, f9, f29                    ;
_l33:    la x4, d_3_22                    ;
      addi x4, x4, -20         ;
      amoand.w x6, x11, (x4)         ;
_l34:    addw x2, x9, x4                    ;
_l35:    la x26, d_3_14                    ;
      addi x26, x26, -28         ;
      amomax.w x8, x10, (x26)         ;
_l36:    la x13, d_4_0                    ;
      lh x23, 20(x13)         ;
_l37:    sraw x8, x13, x7                    ;
_l38:    la x27, d_4_18                    ;
      sh x22, -24(x27)         ;
_l39:    mret                    ;
_l40:    fcvt.w.s x18, f6, rne                    ;
_l41:    fcvt.lu.s x3, f30, rne                    ;
_l42:    xori x19, x25, 728                    ;
_l43:    addi x15, x10, -2047                    ;
_l44:    csrrwi x14, pmpaddr3, 31                    ;
_l45:    fnmsub.s f23, f18, f27, f5, rne                    ;
_l46:    fnmadd.s f23, f20, f22, f30, rne                    ;
_l47:    la x26, d_5_14                    ;
      addi x26, x26, 12         ;
      amomax.w x30, x8, (x26)         ;
_l48:    ori x19, x30, 418                    ;
_l49:    la x15, d_2_18                    ;
      addi x15, x15, 0         ;
      sc.d x30, x15, (x15)         ;
_l50:    fdiv.s f19, f13, f14, rne                    ;
_l51:    slliw x17, x0, 24                    ;
_l52:    la x1, d_5_22                    ;
      addi x1, x1, 0         ;
      amomin.d x23, x7, (x1)         ;
_l53:    fmv.x.w x18, f27                    ;
_l54:    fmadd.s f21, f19, f12, f31, rne                    ;
_l55:    srai x15, x10, 6                    ;
_l56:    auipc x2, 919504                    ;
_l57:    sllw x14, x16, x0                    ;
_l58:    xor x16, x16, x16                    ;
      addi x8, zero, 3         ;
      slli x8, x8, 10         ;
      add x16, x16, x8         ;
      addi x30, zero, 1         ;
      slli x30, x30, 2         ;
      add x16, x16, x30         ;
      csrrc x4, scause, x16         ;
_l59:    la x3, d_1_9                    ;
      sh x3, -22(x3)         ;
_l60:    fsqrt.s f12, f30, rne                    ;
_l61:    la x18, _l39                    ;
      lbu x26, 28(x18)         ;
_l62:    la x22, d_0_12                    ;
      addi x22, x22, -8         ;
      amomin.w x15, x3, (x22)         ;
_l63:    la x6, d_2_3                    ;
      lui x29, 0xffe00         ;
      xor x6, x6, x29         ;
      sd x7, -0(x6)         ;
_l64:    la x15, d_3_10                    ;
      lhu x18, 0(x15)         ;
_l65:    fcvt.s.wu f27, x12, rne                    ;
_l66:    subw x21, x1, x14                    ;
_l67:    fsgnjx.s f11, f5, f17                    ;
_l68:    la x19, d_1_9                    ;
      lhu x6, 30(x19)         ;
_l69:    srlw x3, x7, x3                    ;
_l70:    fcvt.s.l f14, x30, rne                    ;
_l71:    la x3, d_0_7                    ;
      addi x3, x3, 16         ;
      lr.d x22, (x3)         ;
_l72:    srai x11, x9, 63                    ;
_l73:    la x25, d_3_16                    ;
      addi x25, x25, 8         ;
      amomax.d x3, x20, (x25)         ;
_l74:    fsgnjx.s f11, f22, f7                    ;
_l75:    sraw x23, x1, x26                    ;
_l76:    la x10, d_2_19                    ;
      flw f9, 0(x10)         ;
_l77:    la x2, d_1_13                    ;
      addi x2, x2, -16         ;
      lui x16, 0xffe00         ;
      xor x2, x2, x16         ;
      amomin.w x14, x16, (x2)         ;
_l78:    la x13, d_5_26                    ;
      addi x13, x13, 0         ;
      amoswap.w x28, x25, (x13)         ;
_l79:    fmax.s f4, f19, f2                    ;
_l80:    slti x20, x2, 17                    ;
_l81:    li x25, 1                    ;
      la x4, pt3         ;
      addi x4, x4, 0         ;
      sfence.vma x25, x4         ;
_l82:    addi x21, x12, 8                    ;
_l83:    sllw x14, x16, x0                    ;
_l84:    la x8, d_3_23                    ;
      addi x8, x8, 0         ;
      amoand.w x10, x3, (x8)         ;
_l85:    fmax.s f30, f14, f17                    ;
_l86:    slli x15, x18, 19                    ;
_l87:    la x15, d_4_1                    ;
      sb x19, 7(x15)         ;
_l88:    la x11, d_2_3                    ;
      lui x29, 0xffe00         ;
      xor x11, x11, x29         ;
      sh x25, -12(x11)         ;
_l89:    fsgnjn.s f22, f30, f21                    ;
_l90:    la x19, d_0_8                    ;
      addi x19, x19, 4         ;
      amoor.w x15, x25, (x19)         ;
_l91:    fle.s x3, f17, f26                    ;
_l92:    la x9, _l77                    ;
      srai x9, x9, 1         ;
      csrrw x7, pmpaddr3, x9         ;
_l93:    la x12, d_2_12                    ;
      addi x12, x12, 12         ;
      lr.w x11, (x12)         ;
_l94:    fsub.s f13, f29, f4, rne                    ;
_l95:    sraiw x3, x16, 31                    ;
_l96:    la x7, d_2_18                    ;
      sh x20, 0(x7)         ;
_l97:    xor x17, x17, x17                    ;
      addi x19, zero, 3         ;
      slli x19, x19, 31         ;
      add x17, x17, x19         ;
      csrrc x8, sstatus, x17         ;
_l98:    la x14, d_5_0                    ;
      addi x14, x14, 8         ;
      amoadd.d x22, x26, (x14)         ;
_l99:    sret                    ;
_l100:    addi x0, x1, 0                    ;
      flw f20, 24(x26)         ;
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
                .dword 0xfb93d245f540f505, 0x27a7559e467811a7
                .dword 0x406793544dd8ede5, 0x174ad78a05b6b361
d_0_0:          .dword 0x719536ee15caf73f, 0x541e1a5f7ddce3ae
d_0_1:          .dword 0xc88c29ea2fc60dcb, 0xf1303bd12d0b6d3e
d_0_2:          .dword 0x1b4af98d9ae9301c, 0xe067749fbf1557a1
d_0_3:          .dword 0x5749b7766da23ecd, 0x793298f66a266dec
d_0_4:          .dword 0x70ff152d24fda862, 0xb30c1dceee1211ee
d_0_5:          .dword 0xf6a0067d08f1a9df, 0xb1bb6141f79e3c39
d_0_6:          .dword 0xa7fd7b88c3aa4df3, 0x56da37eda4eb7c6d
d_0_7:          .dword 0xe7da1f75b4db6e77, 0x97be49719afa173f
d_0_8:          .dword 0xdb7f1164d81e6f76, 0x792eee7de50a5d53
d_0_9:          .dword 0xdc09cdac301f4995, 0x17d9efa21aa01249
d_0_10:         .dword 0x21aa7a6f793a23e5, 0xdd7cf8836a9b2056
d_0_11:         .dword 0xba9ff33410eb9c56, 0x27bbb19cdb1acfe6
d_0_12:         .dword 0x8068c687e4d9f4ea, 0x577bec565b879cc8
d_0_13:         .dword 0x940f38bd1ac87329, 0xce2aba4fc59fb6c3
d_0_14:         .dword 0x07a3d82c617cdf0b, 0xaec1055620cd55ce
d_0_15:         .dword 0xe5f2be32e81a7fc6, 0xd37c1ac47b2a7f16
d_0_16:         .dword 0x97babeecd1b50047, 0xc0ae3e13d9fbde72
d_0_17:         .dword 0x44be908c37e5983b, 0xe1fde10d213a2385
d_0_18:         .dword 0x1d289d37200a5892, 0xb81a9d2f1c756862
d_0_19:         .dword 0xbf7192538133212f, 0x69b22fbd4e4bb722
d_0_20:         .dword 0x139024c736974301, 0xc5bfa23385ee7246
d_0_21:         .dword 0xaae4fb138bab9f6a, 0x5c135edbebf858b3
d_0_22:         .dword 0x9286b66e88eae8ef, 0xf214566c3eba7ad5
d_0_23:         .dword 0x6f95ce8e3a5230aa, 0x85461132e099bc8f
d_0_24:         .dword 0x49a562d6e2a6e553, 0x69b1054a281d7ff7
d_0_25:         .dword 0xec08c120ee5ce565, 0xa5ff94fbc379f8a7
d_0_26:         .dword 0xacd217e94f3de7c8, 0x2026d0e0c5d3b96a
d_0_27:         .dword 0xf25f51918f697c4e, 0xb4c66bc465b91d02
                .dword 0x7da447ef7616e208, 0x64565b18321e55f8
                .dword 0xf4933c66e4865d34, 0x9c3af08e88cf6eb3
        /* Random data */
_end_data0:
                 

    .section .data.random1;
    .align  8;

_random_data1:
                .dword 0x9f5ed58cd27635f0, 0xb466b938d75d2df7
                .dword 0x3cae00a27e90cb0a, 0xc4ef3fc023c3bebb
d_1_0:          .dword 0xc640e08f6e5218d1, 0xcd14419abc4d8072
d_1_1:          .dword 0x675853028a84724f, 0xf80fcf9c4ea0e736
d_1_2:          .dword 0x005db4a839f505f6, 0xe693375bf068fc70
d_1_3:          .dword 0x5056c92a8bbf4f8b, 0xa9c667646575e0bf
d_1_4:          .dword 0x826a90858140de59, 0xc197c4f5a62cd491
d_1_5:          .dword 0xa208cdd79809b286, 0x8a5bb07a65147916
d_1_6:          .dword 0x152055f96b1f35f7, 0xadcc2f816a74ce41
d_1_7:          .dword 0xc004f94ba681c092, 0x6867a94b70face37
d_1_8:          .dword 0x8ab1f9f00d2e9720, 0xfbfc2bfe9df531a5
d_1_9:          .dword 0x98132f2df6ac6481, 0xf1a327f405a746aa
d_1_10:         .dword 0x66420351ba9ffd18, 0x3fc206e794971ca6
d_1_11:         .dword 0xacd92a6fbfe115d6, 0xca8a853028fc7460
d_1_12:         .dword 0xa313cf7c147bf062, 0x933f42ed748579ae
d_1_13:         .dword 0xe509c86824af5758, 0xc33bdfbe254ee55e
d_1_14:         .dword 0x2e913045ebd52452, 0x0a32c12acfcdbe4d
d_1_15:         .dword 0x5d8239dcd0d544a7, 0xc2406f2750398ce7
d_1_16:         .dword 0x63840a34d48763c0, 0x7f4a4233dfa4d5e9
d_1_17:         .dword 0x152725e128f66994, 0xbe2c9ae528181b96
d_1_18:         .dword 0xca2e8809ed0e692a, 0xc7937235b05ad832
d_1_19:         .dword 0x260fe103bb266905, 0xc4f6414058baceb0
d_1_20:         .dword 0x6c29e23222e955b9, 0x8e49035e519a7fed
d_1_21:         .dword 0x478ebfbea330fe73, 0x990ec9439affde3c
d_1_22:         .dword 0x6873a2f9e1e3188e, 0x8fa6a1ce4fbb44a9
d_1_23:         .dword 0x1e1d5b79f0bd1573, 0x593b98331259db84
d_1_24:         .dword 0x3ac7128fe1d050e5, 0xf3dc8a9625ffa6d4
d_1_25:         .dword 0x339828d12f917eb8, 0x3197fbb6d4306254
d_1_26:         .dword 0x5ff800d2b2ac205d, 0x9fdb994880c6a62d
d_1_27:         .dword 0x458aae1ef0957eaf, 0xe6f5c404ad7f798b
                .dword 0x00288fa4c86f23d3, 0x217d142507286e90
                .dword 0xebdef8e5957d57f2, 0xa2a95c88d998af46
        /* Random data */
_end_data1:


    .section .data.random2;
    .align  8;

_random_data2:
                .dword 0xc1ae45be68e5f6b7, 0xb4d2fb822b9ff067
                .dword 0xb06d9a217e3a14e7, 0xa3fe146dfa3cb374
d_2_0:          .dword 0x6446c6a9aedd925e, 0xb7b2d5aad9b36230
d_2_1:          .dword 0x6b121b6b9c56f018, 0xb619c16ecab182c9
d_2_2:          .dword 0xb146fb447715ef6b, 0xb9601291a11d1633
d_2_3:          .dword 0xbe8e459ba01e482b, 0x4e092e09c45990f3
d_2_4:          .dword 0x6a1a5dcbdc05f5d5, 0x0f9b6155b6a70ab1
d_2_5:          .dword 0xec4a27b36a4110d4, 0x832320edc14fea98
d_2_6:          .dword 0x57dde6a87e56f3fc, 0x1da882ccf72df49a
d_2_7:          .dword 0x9f538241d6f1579f, 0xdd79c0f131c932e1
d_2_8:          .dword 0x09557259d4fa001e, 0x9563e575836be48b
d_2_9:          .dword 0x1b2d4094cca3d154, 0x5ee34e594601a5b8
d_2_10:         .dword 0x7ebafba89d7b86f6, 0x80fdd5b6e8ae50af
d_2_11:         .dword 0x3da2594289fd669b, 0x455c9d3010e038c8
d_2_12:         .dword 0x673eef3468c07838, 0x8cd3f9e23e3afd04
d_2_13:         .dword 0x287e3e34fa307126, 0xf7e2a43a81dbb259
d_2_14:         .dword 0x0632ca029493d781, 0x96c623446354f20f
d_2_15:         .dword 0x1b146fb34e2b9df4, 0x5c8c40693be73ae8
d_2_16:         .dword 0x6a656b113033fa9b, 0x18562cfbc66e7a5c
d_2_17:         .dword 0x7abf8bbe106c47d4, 0xe22a1fbba70dcf3a
d_2_18:         .dword 0x8d72ceac97db738f, 0x6214e4952bc8484f
d_2_19:         .dword 0x49bd383f39177653, 0x319576b69fc4b42f
d_2_20:         .dword 0xa50500c947a7bc32, 0x1f86b665f4e4c055
d_2_21:         .dword 0x374383f0357e4103, 0x56a63f362d0d9916
d_2_22:         .dword 0xc9390f47fc78ac7c, 0x101957aa5b9f0681
d_2_23:         .dword 0x5bdd1bb6b28df84d, 0x0a14bfa04b60f90f
d_2_24:         .dword 0x3f21e0e09ce662a2, 0x928679e8dea21aed
d_2_25:         .dword 0x98b21c80af1c9fe4, 0x995a8b7bc760c9b1
d_2_26:         .dword 0x12e59abe01f9546a, 0x05cdcd07a41f6eb6
d_2_27:         .dword 0xf6462235f66969ae, 0x030ac961854687c2
                .dword 0xe7807fbfbd0c97ce, 0x957e619396247f97
                .dword 0xccaba5326944c574, 0x8838f9f0314c30b9
         /* Random data */
_end_data2:
                

    .section .data.random3;
    .align  8;

_random_data3:
                .dword 0x82c4cd07555ae399, 0x593075af60c097d4
                .dword 0x024f82f2b2e903be, 0xdbeec5a5759f5f9e
d_3_0:          .dword 0x51f7ff82a7a307d2, 0x3c2c283c247b28fe
d_3_1:          .dword 0xc195e8233cd7d059, 0x13faa2f7a9b32dd1
d_3_2:          .dword 0x72c27b6ca83e68f9, 0x73996c86a70cb509
d_3_3:          .dword 0xe34bfb709b3a902e, 0x7d850854a807045b
d_3_4:          .dword 0x13624173eef256a8, 0x9ac2f7a2d679706d
d_3_5:          .dword 0x797f58c934b93bea, 0x2a12c7b125692886
d_3_6:          .dword 0x64242cc15639144b, 0xef43aae9a39553fa
d_3_7:          .dword 0xf963167b997f857d, 0xd006e499f7570d13
d_3_8:          .dword 0xb8488cf808500506, 0xc53b75f4ac78f73e
d_3_9:          .dword 0x2281dd9dac44455e, 0xf5b8dd90db26e801
d_3_10:         .dword 0xffc0af3e1d2eb3f7, 0x8e8a251b980997c4
d_3_11:         .dword 0xd7e1a0fbf3cc5d07, 0x266b2c48d77fda57
d_3_12:         .dword 0x52501b23e08feddb, 0xc87338a55693e701
d_3_13:         .dword 0x845f1212a3f5620c, 0x52f417e53ed944e9
d_3_14:         .dword 0xd684b81eb931b289, 0x32f60c503b7203fc
d_3_15:         .dword 0x25b2ae0a4531a7f1, 0xdff586743feb7b6f
d_3_16:         .dword 0x3910e0cc67e4290f, 0xcfcf09565eec95d8
d_3_17:         .dword 0x289800d8e8332e9f, 0x909d35a630b10eb2
d_3_18:         .dword 0x2422e8e06cbd0c43, 0x67bd7908db628df5
d_3_19:         .dword 0xb096924d10e7d3a5, 0x0d37b97ae2b7b977
d_3_20:         .dword 0x83decc26297f47eb, 0x00e5fef8cfb72331
d_3_21:         .dword 0xf01cee13e2a83426, 0xd304cf4f1bba2973
d_3_22:         .dword 0x1c84500c703d76df, 0x5201d53792167fed
d_3_23:         .dword 0x029ad533df6c3ab6, 0x603c3782ba804d9c
d_3_24:         .dword 0x081c7037943c246d, 0xee77f05643400531
d_3_25:         .dword 0xfa0d189f36f4a796, 0xa23c7db2de195f56
d_3_26:         .dword 0x7bc7250e6778ae69, 0x3941a324d92a0d48
d_3_27:         .dword 0x1818eb699d57fbc7, 0x9b56b089010a1f79
                .dword 0x9be392ce22e416ba, 0x0952a2f11a32ae36
                .dword 0x6f4fa647cdc7978b, 0x9b930e552f0a5290
        /* Random data */
_end_data3:


    .section .data.random4;
    .align  8;

_random_data4:
                .dword 0x0d079b5d75a2038c, 0x34e581d910b2f3bc
                .dword 0x6f98130218180e89, 0xf1798c2e7adc90d8
d_4_0:          .dword 0x4e318bcd89146e1b, 0x487258e69ef97beb
d_4_1:          .dword 0x8afcc83410815af4, 0xe5a2ae1703cf56a2
d_4_2:          .dword 0x6e58920acf533a3b, 0x943e777b6a24f781
d_4_3:          .dword 0x590d07e355e86a63, 0xba5d65769bb27932
d_4_4:          .dword 0x0a05735e5dfd37b2, 0x82fa5a5df18d339f
d_4_5:          .dword 0x2346ca918b8d33d7, 0x47b97d4296774bf0
d_4_6:          .dword 0xb40d9d57fc0fc9a9, 0xbae5b7c4d2f1f467
d_4_7:          .dword 0xc9b9714503723426, 0x6dbd78db88caa26d
d_4_8:          .dword 0xdac749e42573dad1, 0x4b95ca62858652ca
d_4_9:          .dword 0xc9ea6b4cf3517d6f, 0x06805311e8cd5506
d_4_10:         .dword 0x702b146d08d670c5, 0x9db63dd0083b3f01
d_4_11:         .dword 0x1c27d4bb509156a5, 0x8da29e3174d8dbdc
d_4_12:         .dword 0x5dcf5106d23474c5, 0x77941533729109cb
d_4_13:         .dword 0x742559ef5f0922a8, 0x7396f4f07dbc12ca
d_4_14:         .dword 0x644884e772354d64, 0xca258ac723a48e1d
d_4_15:         .dword 0x4da9574428e4ca52, 0x64269ad5b4c8e7a5
d_4_16:         .dword 0x78471a992a3790a0, 0x7eb892ec1d479a5e
d_4_17:         .dword 0x90135a337c73854d, 0xdbe16edf44298c2a
d_4_18:         .dword 0x6d16cf388839f372, 0xc554173690ed4d86
d_4_19:         .dword 0xa70339f6aca0553b, 0x3fb1e676b4537280
d_4_20:         .dword 0x8cc57734d3e5079d, 0x2af881d800d6dede
d_4_21:         .dword 0x05b863a9ff9bc1a7, 0x621f22094b890fcc
d_4_22:         .dword 0x0bdfcf2089cde40c, 0xa628f186fe60169d
d_4_23:         .dword 0x1c6ff5237b581df9, 0x82aac0dd0031f636
d_4_24:         .dword 0x8409d66098e60f14, 0xf912a3140f2d8f9d
d_4_25:         .dword 0x7aedd7a5f82e1c9e, 0x3906bd6de51152ee
d_4_26:         .dword 0x2a15476c9ba4a204, 0xebba3215e25e5937
d_4_27:         .dword 0x2e9bd3fa0403a3be, 0xd53b021e312e52ea
                .dword 0xb7f41b58cd9758a4, 0xc883053bfbf02e0c
                .dword 0x834d90fb5a75b5a8, 0xf165a6c411bbdffa
        /* Random data */
_end_data4:


    .section .data.random5;
    .align  8;

_random_data5:
                .dword 0x2f544d7a81d8867a, 0x95cdabd031468d67
                .dword 0xbd37c1275e1a6c4c, 0xb37784713c660e59
d_5_0:          .dword 0xb234ec86daceb8ae, 0xe0843ab965c500ab
d_5_1:          .dword 0x51b06ea938e134cd, 0x9bdaff3a1fc13394
d_5_2:          .dword 0xce912314ba4785e4, 0xf12e78ef2852b33e
d_5_3:          .dword 0xc0d3a02f0aa7de31, 0x427611835d4a738a
d_5_4:          .dword 0x55546a3731eb0e55, 0x5a9d2993dcd4bb17
d_5_5:          .dword 0xef064129587f9534, 0x8a8021465e788bf4
d_5_6:          .dword 0xe679e1676bffc86b, 0x04ad60cce1e5db99
d_5_7:          .dword 0x61452ac7e49ee45f, 0xc0aace43b15e4b8a
d_5_8:          .dword 0x43fe0f77369db191, 0xe146028c3074c055
d_5_9:          .dword 0xa33ba06bf7a6b9d9, 0x7328efd71e64344d
d_5_10:         .dword 0x83fdcd389514f317, 0x62605ee9cd22ccc6
d_5_11:         .dword 0x66db60f35abb86b8, 0x9342b9f4ba563357
d_5_12:         .dword 0x4db6bf4672c19bb3, 0xe67d6cf406f381ea
d_5_13:         .dword 0x8e077e4f258707b3, 0x669ef047cd6becce
d_5_14:         .dword 0xaf668f34e3dec0d7, 0xb8c9fcffc5acfce5
d_5_15:         .dword 0x8d42b3e5ee390dd1, 0xe842f46788b143dd
d_5_16:         .dword 0x9e449df9ca4a19ce, 0x8974b8e6458a89d2
d_5_17:         .dword 0x5dc2f9bd48847b04, 0x1a3874a324670475
d_5_18:         .dword 0xe9e274ace425e27b, 0x79f19f0738c49725
d_5_19:         .dword 0x6bf1615415c4bae3, 0xab1b05d4e8fb0005
d_5_20:         .dword 0xa3e92249f8a899bf, 0x26f59e3f75b9f5f2
d_5_21:         .dword 0x39d65c50aaa21214, 0xb512d66925922767
d_5_22:         .dword 0xcc5ec5ba6a3960fc, 0x0868f654c1a1eb7e
d_5_23:         .dword 0x852e1926f2fe2378, 0xb0e2bdc40ecd76c3
d_5_24:         .dword 0x933f250be8e364b7, 0x25c90e0479609204
d_5_25:         .dword 0xd0642d50682a96da, 0xb06ef0438e2109b6
d_5_26:         .dword 0x8930c32b328314e7, 0xc28aaefffd3c9a96
d_5_27:         .dword 0xb1d29a8a64a9d727, 0x6f44e75d232cffaa
                .dword 0x7639072ea18c7c1d, 0x9049bf183be1e2ea
                .dword 0xe5fdbdf31c99e036, 0x88de9165d97e1380
         /* Random data */
_end_data5:
              
                 
