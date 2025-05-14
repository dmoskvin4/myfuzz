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
_s0:    la x27, d_1_10                            ;
        lb x6, 12(x27)                            ;
_s1:    fmv.w.x f13, x28                          ;
_s2:    fcvt.s.w f24, x8, rne                     ;
_s3:    fdiv.s f24, f21, f23, rne                 ;
_s4:    fsub.s f30, f8, f5, rne                   ;
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
_p0:    csrrci x13, pmpaddr6, 31                  ;
_p1:    csrrwi x10, sscratch, 0                   ;
_p2:    la x13, d_2_9                             ;
        srai x13, x13, 1                          ;
        csrrs x13, pmpaddr1, x13                  ;
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
_l0:    xor x18, x18, x18                    ;
      addi x22, zero, 1         ;
      slli x22, x22, 1         ;
      add x18, x18, x22         ;
      csrrw x29, scause, x18         ;
_l1:    addi x0, x1, 0                    ;
_l2:    fclass.s x11, f7                    ;
_l3:    addi x0, x1, 0                    ;
_l4:    la x7, d_2_25                    ;
      addi x7, x7, -8         ;
      amomaxu.d x2, x21, (x7)         ;
_l5:    fcvt.s.w f30, x26, rne                    ;
_l6:    fmv.w.x f29, x19                    ;
_l7:    la x11, d_4_19                    ;
      ld x22, 8(x11)         ;
_l8:    slliw x2, x11, 23                    ;
_l9:    la x15, d_1_7                    ;
      lhu x7, -30(x15)         ;
_l10:    ori x20, x10, -1854                    ;
_l11:    la x21, d_5_25                    ;
      addi x21, x21, -16         ;
      lui x22, 0xffe00         ;
      xor x21, x21, x22         ;
      amomin.d x18, x22, (x21)         ;
_l12:    csrrci x20, scause, 18                    ;
_l13:    sllw x15, x5, x15                    ;
_l14:    csrrsi x21, sstatus, 12                    ;
_l15:    fmv.x.w x29, f10                    ;
_l16:    addi x0, x1, 0                    ;
_l17:    la x28, d_5_16                    ;
      addi x28, x28, -0         ;
      lui x19, 0xffe00         ;
      xor x28, x28, x19         ;
      amoor.d x12, x19, (x28)         ;
_l18:    la x18, d_3_1                    ;
      addi x18, x18, 0         ;
      amoswap.d x9, x4, (x18)         ;
_l19:    srli x0, x12, 63                    ;
_l20:    fsgnjn.s f28, f1, f5                    ;
_l21:    la x23, d_5_6                    ;
      lbu x21, -27(x23)         ;
_l22:    fmadd.s f19, f11, f10, f3, rne                    ;
_l23:    la x7, d_1_1                    ;
      srai x7, x7, 1         ;
      csrrs x27, pmpaddr5, x7         ;
_l24:    la x20, d_4_20                    ;
      lb x24, -24(x20)         ;
_l25:    srliw x14, x19, 18                    ;
_l26:    la x19, d_2_16                    ;
      addi x19, x19, 20         ;
      amomaxu.w x3, x22, (x19)         ;
_l27:    slti x26, x11, 1925                    ;
_l28:    fmadd.s f8, f5, f14, f31, rne                    ;
_l29:    la x5, d_3_14                    ;
      addi x5, x5, -0         ;
      amoand.d x5, x26, (x5)         ;
_l30:    sraiw x2, x23, 31                    ;
_l31:    fsqrt.s f22, f12, rne                    ;
_l32:    la x16, d_3_12                    ;
      addi x16, x16, 16         ;
      lui x26, 0xffe00         ;
      xor x16, x16, x26         ;
      amominu.d x30, x26, (x16)         ;
_l33:    la x18, d_1_14                    ;
      addi x18, x18, -24         ;
      amoadd.w x30, x29, (x18)         ;
_l34:    srli x6, x21, 60                    ;
_l35:    fmsub.s f17, f2, f14, f21, rne                    ;
_l36:    fmul.s f24, f24, f23, rne                    ;
_l37:    la x6, d_1_25                    ;
      addi x6, x6, 24         ;
      sc.w x25, x19, (x6)         ;
_l38:    sret                    ;
_l39:    la x4, d_5_1                    ;
      flw f27, 0(x4)         ;
_l40:    la x10, d_5_12                    ;
      addi x10, x10, -24         ;
      amomin.d x11, x11, (x10)         ;
_l41:    fnmadd.s f16, f6, f12, f26, rne                    ;
_l42:    fmin.s f25, f0, f25                    ;
_l43:    sret                    ;
_l44:    la x26, d_5_9                    ;
      addi x26, x26, -0         ;
      sc.w x30, x10, (x26)         ;
_l45:    la x18, d_5_11                    ;
      fsw f12, 28(x18)         ;
_l46:    mret                    ;
_l47:    fmul.s f12, f0, f20, rne                    ;
_l48:    slliw x17, x23, 13                    ;
_l49:    fmax.s f3, f26, f11                    ;
_l50:    addi x0, x1, 0                    ;
_l51:    la x8, d_4_12                    ;
      addi x8, x8, 16         ;
      lui x30, 0xffe00         ;
      xor x8, x8, x30         ;
      lr.d x4, (x8)         ;
_l52:    fsgnjx.s f6, f0, f14                    ;
_l53:    la x12, d_3_15                    ;
      addi x12, x12, 24         ;
      amomin.d x30, x2, (x12)         ;
_l54:    la x2, d_3_2                    ;
      addi x2, x2, -20         ;
      amoor.w x9, x21, (x2)         ;
_l55:    fcvt.s.lu f16, x14, rne                    ;
_l56:    addi x0, x1, 0                    ;
_l57:    sraw x0, x2, x21                    ;
_l58:    fclass.s x23, f30                    ;
_l59:    srliw x27, x7, 18                    ;
_l60:    flt.s x14, f10, f2                    ;
_l61:    la x8, d_1_8                    ;
      sd x10, -16(x8)         ;
_l62:    la x2, _l70                    ;
      lbu x6, -15(x2)         ;
_l63:    la x15, d_4_16                    ;
      addi x15, x15, 20         ;
      sc.w x5, x13, (x15)         ;
_l64:    xor x16, x16, x16                    ;
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
_l65:    la x26, d_5_24                    ;
      sh x19, 4(x26)         ;
_l66:    fcvt.w.s x9, f0, rne                    ;
_l67:    addw x21, x27, x1                    ;
_l68:    la x20, d_1_14                    ;
      addi x20, x20, -8         ;
      amoadd.d x11, x30, (x20)         ;
_l69:    ori x18, x3, 633                    ;
_l70:    csrrwi x21, frm, 25                    ;
_l71:    fnmsub.s f22, f5, f11, f31, rne                    ;
_l72:    la x19, d_3_8                    ;
      addi x19, x19, -8         ;
      amoand.w x21, x6, (x19)         ;
_l73:    la x10, _l26                    ;
      lw x25, 28(x10)         ;
_l74:    la x7, d_1_8                    ;
      addi x7, x7, 24         ;
      amoand.d x24, x14, (x7)         ;
_l75:    la x24, d_0_16                    ;
      ld x10, -0(x24)         ;
_l76:    la x12, d_2_12                    ;
      addi x12, x12, 12         ;
      lr.w x11, (x12)         ;
_l77:    subw x24, x27, x28                    ;
_l78:    sraiw x3, x16, 31                    ;
_l79:    fnmadd.s f15, f15, f7, f11, rne                    ;
_l80:    fle.s x3, f17, f26                    ;
_l81:    la x19, d_0_8                    ;
      addi x19, x19, 4         ;
      amoor.w x15, x25, (x19)         ;
_l82:    la x10, d_2_19                    ;
      flw f9, 0(x10)         ;
_l83:    srai x18, x0, 18                    ;
_l84:    subw x12, x18, x14                    ;
_l85:    uret                    ;
_l86:    la x18, d_4_27                    ;
      addi x18, x18, 24         ;
      amomaxu.w x8, x8, (x18)         ;
_l87:    csrrci x11, pmpaddr7, 0                    ;
_l88:    fsgnjx.s f11, f5, f17                    ;
_l89:    sltiu x23, x29, -890                    ;
_l90:    la x30, d_1_4                    ;
      addi x30, x30, 0         ;
      lui x10, 0xffe00         ;
      xor x30, x30, x10         ;
      amomaxu.d x30, x10, (x30)         ;
_l91:    fmul.s f10, f2, f29, rne                    ;
_l92:    la x15, d_3_10                    ;
      lhu x18, 0(x15)         ;
_l93:    fclass.s x18, f24                    ;
_l94:    fmul.s f5, f1, f29, rne                    ;
_l95:    feq.s x20, f25, f22                    ;
_l96:    la x30, d_1_17                    ;
      addi x30, x30, -24         ;
      sc.d x7, x30, (x30)         ;
_l97:    fmadd.s f2, f25, f24, f27, rne                    ;
_l98:    la x27, d_2_18                    ;
      lw x13, 20(x27)         ;
_l99:    la x1, d_0_15                    ;
      lw x27, 16(x1)         ;
_l100:    addi x0, x1, 0                    ;
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
                .dword 0x25e1fbcc12b13db1, 0x5f4d348498761411
                .dword 0x9eee9f8121397bbf, 0xb5228fd0864a6ddb
d_0_0:          .dword 0x9e88c86abf21df5c, 0xf99364c900113db6
d_0_1:          .dword 0xf0de1cac76503e9d, 0x91973510f56aff10
d_0_2:          .dword 0xc3355cf16e204f88, 0x7a90e9f20b27aa84
d_0_3:          .dword 0x61c2951a9c82ab0c, 0x2cb427dc64be831a
d_0_4:          .dword 0xebd8c3b2c8967c83, 0x2615ee3c50817721
d_0_5:          .dword 0x29a8671eb73da69c, 0xe99c2d1b6c76d89f
d_0_6:          .dword 0x9d3fa74b2069d90f, 0x6e98e221932f5930
d_0_7:          .dword 0x6eadfcbd556f0d71, 0x68d56a246ffaee8c
d_0_8:          .dword 0x15c3401c857d72e4, 0x0278bc1dae966c2e
d_0_9:          .dword 0x5d7db96d36ba5ac0, 0xd2b12da9fe371e05
d_0_10:         .dword 0x187e0e87b2d636ec, 0x07abfa9619b5c662
d_0_11:         .dword 0x3e08a785ef1f373a, 0x0d9811637abed161
d_0_12:         .dword 0xeeece47acc062e26, 0xcf9c9ecfe188b4d9
d_0_13:         .dword 0x544c1371f944c47d, 0x5191874eecc4ef73
d_0_14:         .dword 0xf66bdbcbaea94ed5, 0x72ef6769330537bb
d_0_15:         .dword 0x2bb125cb85e4d459, 0xe8a48bdd27365f3a
d_0_16:         .dword 0x160051ca74ae10bc, 0x904b6dd6ef38cdd9
d_0_17:         .dword 0x56d394e079470771, 0x24bc0102b23814fb
d_0_18:         .dword 0xa9c5cf9f4e47dafb, 0x2dda34c405416e4e
d_0_19:         .dword 0xe1b83eda66b3d746, 0x3a24cf3237452ea7
d_0_20:         .dword 0x066b1f6da8a6ada1, 0x631fdc6b05e28617
d_0_21:         .dword 0x61800be4e7b40499, 0x0511bd5122e737f8
d_0_22:         .dword 0xa57706d821fe5b13, 0xd16466c16893336d
d_0_23:         .dword 0xebecf2cc99941249, 0xb1c60b6bba24546a
d_0_24:         .dword 0xaecfd92efeb7787c, 0x9f83173a0a742010
d_0_25:         .dword 0x4ab7f5f8e4e92b22, 0x15198f1f8f947cc5
d_0_26:         .dword 0x1b1389d4f4776e3c, 0x33c7a4bcde803610
d_0_27:         .dword 0x356bb7843372cc7f, 0x1128b1d007d59888
                .dword 0x7c791d3d55326b27, 0x368b697bde9f20fa
                .dword 0xbb9b944faf3bef18, 0x11e30bcb7b6a32fb
        /* Random data */
_end_data0:
                 

    .section .data.random1;
    .align  8;

_random_data1:
                .dword 0xaf60be96ff8f7b83, 0xba4c1f70a16c9859
                .dword 0xc06c12d2351a558c, 0xe34864d4a417be63
d_1_0:          .dword 0x81b31b970fca2423, 0xeebf15a9bb518d5a
d_1_1:          .dword 0xbf1f71ca067b76d6, 0x5f841d499f215006
d_1_2:          .dword 0x6b2ba0f65e9d4f85, 0xe50bd4101d0b3b33
d_1_3:          .dword 0x361cad9908cc6ed6, 0x4f1e7e0408186756
d_1_4:          .dword 0xf807f6a1ddedc80b, 0x005d023bcbbb789c
d_1_5:          .dword 0xfa68564f90d1403d, 0xec6ec9647d9577d1
d_1_6:          .dword 0x22a337e9fb8078c4, 0xf5b64b8a8a64f759
d_1_7:          .dword 0xb858742f354da6f1, 0x8e9a8708c5d69fc6
d_1_8:          .dword 0x838a47413cf1dc0c, 0x309adf3ff0c88f89
d_1_9:          .dword 0x0ee23b9301df1c03, 0x55310a241f2a51a9
d_1_10:         .dword 0xbd7dcc5350664e0c, 0x44d2543bd3a47e73
d_1_11:         .dword 0x3259067a91a71aad, 0xb3845c6590717956
d_1_12:         .dword 0xe87c9fcdf22835b1, 0x23eff223d7decf03
d_1_13:         .dword 0xc859ab7b1cc34ab1, 0x3714e787565fcf3f
d_1_14:         .dword 0xa0845b88ed78ed4b, 0x121330dc046aac4d
d_1_15:         .dword 0x904b41f8aaef79aa, 0x9a5583e2886e8dcd
d_1_16:         .dword 0xeb5542278831d5cd, 0xb835b75af042067f
d_1_17:         .dword 0xb7d432b8204da28f, 0x5cfc18ad7e5a53e4
d_1_18:         .dword 0x8d1778561fc8284b, 0xc822685fdbc4f8be
d_1_19:         .dword 0x58004bc19931eb99, 0x54e44956ae37f19f
d_1_20:         .dword 0xd6f08b501f380b1e, 0xbf0a6484dae7b06a
d_1_21:         .dword 0x80b6f59a26f10328, 0x661c2d2fe2a306c3
d_1_22:         .dword 0xe7d93981b3945ef1, 0x77db906b42c04b50
d_1_23:         .dword 0x161ccfb05eb26246, 0x5c7412d413194fd3
d_1_24:         .dword 0x0439d5ee1dd22bcf, 0x2bee3ff057ea68dc
d_1_25:         .dword 0x95e52dd0ede3a217, 0xa3caffed8289f1d7
d_1_26:         .dword 0x7c66607f790bdbbc, 0x3b9cbd3d0e19a59e
d_1_27:         .dword 0x86aafc5f810b3207, 0x0eb8ee89ca49c62a
                .dword 0x8e23eb9376ebe4b4, 0x6d6c2af3d95ef2ab
                .dword 0xa5c25d3f6e162fa5, 0x785af68fb466cab9
        /* Random data */
_end_data1:


    .section .data.random2;
    .align  8;

_random_data2:
                .dword 0xff904fb86545609b, 0x274b10cc8176b1b9
                .dword 0xdb2e01569636963d, 0x0a02803c52bd026d
d_2_0:          .dword 0x63a345853689cbe2, 0x2857ea57e4779ec6
d_2_1:          .dword 0xb17a38af34c6c593, 0x48d913596737101d
d_2_2:          .dword 0x79c3a0cdac437748, 0x1f1acdde28dbaf74
d_2_3:          .dword 0xafc5a9fb2d779f8b, 0x80de3f359a77406c
d_2_4:          .dword 0xb89c153cc5cfb311, 0x146c292452dadbcc
d_2_5:          .dword 0x3697cc016882fbc4, 0x2d612469320cdb57
d_2_6:          .dword 0x218e2757b7d3d104, 0xcf215d3cc6b67ca1
d_2_7:          .dword 0x89d86c459bb2f8d2, 0x3ae22cc16e13eb07
d_2_8:          .dword 0xba2e117840c6c45a, 0xce26c363eedc091d
d_2_9:          .dword 0xe8351201457b75cd, 0xe513a4b6c61dd5f6
d_2_10:         .dword 0x854b4cb3e7175611, 0x040428b0829d91e2
d_2_11:         .dword 0xaadbf5b4dd6d96ec, 0x92ad021b678359e5
d_2_12:         .dword 0x1eeb82a393e1ef2e, 0x702bfa9ccedd2fb1
d_2_13:         .dword 0x4f22a5cdbe13643c, 0x983f125d124c7f8b
d_2_14:         .dword 0xd0d2b2c7f3547cab, 0xa741f7b2956f2c5f
d_2_15:         .dword 0xf0b882b8967f99ee, 0xdc0abd16cb046c56
d_2_16:         .dword 0x6d287b88ec26c4cc, 0xfb758d72f695ac32
d_2_17:         .dword 0xa4480f11aaa6a14e, 0xc849d0a188ade531
d_2_18:         .dword 0xd7f3cd9b5c33032e, 0xb9f0f1e8da692bb3
d_2_19:         .dword 0x8d93aabaff96307e, 0x083a46a2405d62a0
d_2_20:         .dword 0x8ebbd553ef4da881, 0xa4c8afc6829cb252
d_2_21:         .dword 0x4159eed34204d98e, 0x656d1db51000261c
d_2_22:         .dword 0xaecc6c3a1bba520e, 0x92de7c35189c2a40
d_2_23:         .dword 0x5bec62d8169e7258, 0x4079eb028ba9b569
d_2_24:         .dword 0xe8c4c97f0d705543, 0x100019d0589783a0
d_2_25:         .dword 0x236aac8e73181daf, 0x10318478ce49323c
d_2_26:         .dword 0x445ee21a4e1ca5a1, 0x7833f0cc16bd808a
d_2_27:         .dword 0x136de516e87f6d32, 0xbbf831f603b5256e
                .dword 0x4248f95a0b1988c4, 0xcc0f7dc0eadef7b3
                .dword 0x537f02a5780b336d, 0x621494f5d4e9ccbb
         /* Random data */
_end_data2:
                

    .section .data.random3;
    .align  8;

_random_data3:
                .dword 0x4abb4e909caad23f, 0xfc7777bd7dad6eaf
                .dword 0x1ab837d37dc1dd92, 0x0f200648f6fdc2ee
d_3_0:          .dword 0x2922f5b59bb44907, 0x67b09367b37d35a1
d_3_1:          .dword 0xc595065e50a5e856, 0xdd1ffa0122955522
d_3_2:          .dword 0x576bd056b3d58922, 0xf83f4588a58100f4
d_3_3:          .dword 0x5443aba3adebc05c, 0x0cb27c01620bdd0c
d_3_4:          .dword 0xbfbc568d4763869f, 0x1ebe27790b100800
d_3_5:          .dword 0xee62f936a3839089, 0xf705b7f98b116415
d_3_6:          .dword 0xf289c97171b44c11, 0x1b138076cd9560ad
d_3_7:          .dword 0xe3f1064e7fd65f62, 0x3f83eee394156e29
d_3_8:          .dword 0xd39432ec719ff322, 0x799d097c9f2b1282
d_3_9:          .dword 0x612e02c753152086, 0xddbe25e91a7a3aa3
d_3_10:         .dword 0x707925588ba0b89a, 0x3b51e7848ca4904c
d_3_11:         .dword 0x338075fef83e76eb, 0x969a18a0cc17caed
d_3_12:         .dword 0x2770072f2dc04d97, 0xdaa7f64b0e04e215
d_3_13:         .dword 0x74442ccfd8004810, 0x706cb14b37c9cd7e
d_3_14:         .dword 0x35df9af8688d801e, 0x279e0df88a54505a
d_3_15:         .dword 0xda1a2459bcf13554, 0x8419affbed8f1934
d_3_16:         .dword 0xfe639b0b64e2063a, 0x5f363d2823a687a6
d_3_17:         .dword 0x720d544282acce58, 0x6e2ac76bcb143b60
d_3_18:         .dword 0x3ce116e7dc2ba429, 0x51fc75d65f4c8b20
d_3_19:         .dword 0xf04d22a229574912, 0x92965e0c6d0f75dd
d_3_20:         .dword 0xff1840c84b7c2895, 0x84c410ac0f3d4db9
d_3_21:         .dword 0x47b3b15524f7f709, 0xa00fcd2f1a3914f4
d_3_22:         .dword 0x61569b131c88406d, 0x9a15888e7ca2d1fc
d_3_23:         .dword 0x480d05b59187a23b, 0x795443ffc421a360
d_3_24:         .dword 0x2d69ea5397d92d5d, 0xac6054c52964c6a4
d_3_25:         .dword 0xa92b78f1f5393089, 0xdff62ff21e92ec6b
d_3_26:         .dword 0xbed4a670a97d7ef3, 0x27b927cc06558b62
d_3_27:         .dword 0x86102f1208304b6a, 0x7951749c9fe7de1e
                .dword 0x4da6a2b816a72a2e, 0x7f04ab80e79a2794
                .dword 0xd2447faaf9d89eb7, 0x13c04a8ae40eee96
        /* Random data */
_end_data3:


    .section .data.random4;
    .align  8;

_random_data4:
                .dword 0x326f3a96efa67ab1, 0x8c56bf442e9033bd
                .dword 0x44d9330bfad2af17, 0x07866f2610fabb89
d_4_0:          .dword 0x60f173620df884bd, 0x5582119c974a8b5c
d_4_1:          .dword 0x13144ff989fd0e4d, 0x1d9bb1d770863ddd
d_4_2:          .dword 0x3bdd64c25296da27, 0x2094533f10aa00c0
d_4_3:          .dword 0x635439197dded91f, 0x48e0a2faf4106b15
d_4_4:          .dword 0xead01d68a6813eed, 0x4a6af6359f9f93e6
d_4_5:          .dword 0x1e29b6f72eee9eba, 0x12cca3887831337c
d_4_6:          .dword 0xaf0950eaf10cae7c, 0xcefeb7e4b1500fc6
d_4_7:          .dword 0x889a6f0425d6f64d, 0x629cd87eeb955551
d_4_8:          .dword 0xd31065bd7b90af84, 0x2ddad202cb005767
d_4_9:          .dword 0x95f84d9519ba217d, 0xb4d6dce3e6b8d95e
d_4_10:         .dword 0x68dc436d93cc8588, 0x0f09dd3ecb95728f
d_4_11:         .dword 0xcf3a557672836912, 0x108125453a6d5160
d_4_12:         .dword 0x66a8b1c6e5f914d1, 0x5cb2ec0cb5432584
d_4_13:         .dword 0xb17d43f81285e0d2, 0xa6dad6a928e97462
d_4_14:         .dword 0xb9bea6c0bcc38820, 0xa7067460bc17b790
d_4_15:         .dword 0xd85f7b357065e86f, 0x0860c78beecd3d31
d_4_16:         .dword 0x63c277a8428f1a4f, 0xc052079a48b314f9
d_4_17:         .dword 0x0d6f606a4964e992, 0x30ec7b92a52224da
d_4_18:         .dword 0x7b1209ae4328b9dd, 0x719215321bbd6859
d_4_19:         .dword 0xf3d0de431c299255, 0x362ead4eba3cee21
d_4_20:         .dword 0xcc21592d7c0b0d3c, 0xf7c07e67510a015f
d_4_21:         .dword 0x75bd37b05e11ccbc, 0x465066de96ffa326
d_4_22:         .dword 0x615b6e3304229ab4, 0x078d6c450b3d6206
d_4_23:         .dword 0x334e76f4c43dd0b9, 0x1f98cece85c2dafb
d_4_24:         .dword 0xd194ee350e0d06e9, 0xf1f9a3d68c95edd8
d_4_25:         .dword 0x3736a45bc7343c9f, 0x2b9d91974961111f
d_4_26:         .dword 0x95d1c4d28b4e054f, 0xf3066a989341fe1d
d_4_27:         .dword 0x7cac64646603cb28, 0x36ec76c945464429
                .dword 0x15a8ed17ed6447bf, 0x63eea34c208677be
                .dword 0x916d5294ea0c26e6, 0x934c58c7f2dfc8df
        /* Random data */
_end_data4:


    .section .data.random5;
    .align  8;

_random_data5:
                .dword 0x5d6d6d2a5971438b, 0x29d734f33a144f5a
                .dword 0x3b36a39c0ff93001, 0xcde1af38d382d7eb
d_5_0:          .dword 0xe3a0658137f1375d, 0x5f173d0e10db6c5b
d_5_1:          .dword 0x14e7b07f8a7de589, 0xbd2cccb1fa2b39b0
d_5_2:          .dword 0x4df1322b241be89c, 0xbe28dcdbc2e5a6f6
d_5_3:          .dword 0x5b74a239fd113d8b, 0xace6be716acae705
d_5_4:          .dword 0x5659a04efd07e8a0, 0x56e3336dc20c5b85
d_5_5:          .dword 0x93c14be1d24f0b28, 0xb1ae9a82c8427a7b
d_5_6:          .dword 0x22012b408a0a68fa, 0xe701f2dc76af85e2
d_5_7:          .dword 0xf4b0fb4d0a64be4a, 0x1b514922e1159a00
d_5_8:          .dword 0x049ed4fd152c651c, 0x7e2db66601a20df7
d_5_9:          .dword 0x38b45c902f2b083b, 0xcdf3c76a4e761145
d_5_10:         .dword 0xd6c687d1e758997c, 0x343094deda52f670
d_5_11:         .dword 0x9634565594335bd1, 0xc8d2833b7097c683
d_5_12:         .dword 0x1a8804d2973cae1e, 0x3ab792c20bddb88d
d_5_13:         .dword 0x0d3f3d2945721b5c, 0x2d1790f21931c1b3
d_5_14:         .dword 0xd7f25b1728aed419, 0x795dff3125602594
d_5_15:         .dword 0x4bd05943c8ea597e, 0xeadd54f5bf164fd6
d_5_16:         .dword 0x8c57253d0e9a4f84, 0xd6ece2763c831775
d_5_17:         .dword 0x95ee986a2e82322a, 0x3488ab6c293cdf41
d_5_18:         .dword 0x9f0dce624a2b100e, 0x1b1b4be016ad9039
d_5_19:         .dword 0x8d8a490ad9a6d48f, 0xc8993cb60aa4ed0a
d_5_20:         .dword 0x7f9bbc1d40148442, 0xd905afd424e0d9db
d_5_21:         .dword 0x9e0218da2f6c637d, 0x72483517bb9ee60b
d_5_22:         .dword 0x08890464106e030c, 0xd5447e5d5b5eb146
d_5_23:         .dword 0xaff7ccf03963d964, 0xe714365c716f92ea
d_5_24:         .dword 0x6a2af58a07be668b, 0x88dbfae2b0aaf4a4
d_5_25:         .dword 0xdc557f95fe2ff5b1, 0xa6caeee2bd8ab0e6
d_5_26:         .dword 0x1f6d8264cd6b22b8, 0x4fdda916b6fbd699
d_5_27:         .dword 0x27a2641cda95e8cb, 0x32639d5cce6c94bd
                .dword 0xfe7110881d8c54b6, 0xc8fd2e3b7384f666
                .dword 0x3d337a0469249379, 0x35294615a2104481
         /* Random data */
_end_data5:
              
                 
