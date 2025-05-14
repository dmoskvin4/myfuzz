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
_p0:    la x14, d_0_8                             ;
        srai x14, x14, 1                          ;
        csrrc x13, pmpaddr3, x14                  ;
_p1:    csrrci x11, sepc, 0                       ;
_p2:    csrrwi x10, fflags, 29                    ;
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
_l2:    sraiw x20, x29, 31                    ;
_l3:    addi x0, x1, 0                    ;
_l4:    sraw x9, x24, x1                    ;
_l5:    la x23, d_3_20                    ;
      ld x19, 0(x23)         ;
_l6:    fmin.s f21, f25, f10                    ;
_l7:    addi x0, x1, 0                    ;
_l8:    la x29, d_1_25                    ;
      addi x29, x29, -8         ;
      amomin.d x20, x4, (x29)         ;
_l9:    srliw x27, x7, 18                    ;
_l10:    sltiu x17, x22, -2047                    ;
_l11:    xor x1, x1, x1                    ;
      addi x6, zero, 1         ;
      slli x6, x6, 31         ;
      add x1, x1, x6         ;
      addi x7, zero, 1         ;
      slli x7, x7, 2         ;
      add x1, x1, x7         ;
      csrrs x20, satp, x1         ;
_l12:    addiw x28, x29, -493                    ;
_l13:    la x19, d_1_4                    ;
      lb x28, -31(x19)         ;
_l14:    srli x9, x5, 22                    ;
_l15:    la x20, d_0_19                    ;
      addi x20, x20, -0         ;
      amomin.d x7, x27, (x20)         ;
_l16:    la x7, d_2_25                    ;
      addi x7, x7, -8         ;
      amomaxu.d x2, x21, (x7)         ;
_l17:    la x2, _l70                    ;
      lbu x6, -15(x2)         ;
_l18:    fclass.s x11, f7                    ;
_l19:    la x25, d_4_1                    ;
      ld x20, -0(x25)         ;
_l20:    srli x12, x22, 12                    ;
_l21:    mret                    ;
_l22:    fclass.s x14, f30                    ;
_l23:    slli x4, x22, 4                    ;
_l24:    la x2, d_1_18                    ;
      lui x11, 0xffe00         ;
      xor x2, x2, x11         ;
      flw f23, -28(x2)         ;
_l25:    ori x10, x26, -1775                    ;
_l26:    srli x16, x19, 46                    ;
_l27:    sltiu x29, x13, -831                    ;
_l28:    la x21, d_3_13                    ;
      addi x21, x21, 20         ;
      amoswap.w x15, x6, (x21)         ;
_l29:    fmul.s f10, f15, f6, rne                    ;
_l30:    la x11, d_5_24                    ;
      addi x11, x11, 24         ;
      amomin.d x27, x22, (x11)         ;
_l31:    auipc x29, 55862                    ;
_l32:    addi x0, x1, 0                    ;
_l33:    fmax.s f9, f21, f8                    ;
_l34:    la x4, d_3_26                    ;
      addi x4, x4, 24         ;
      amomaxu.w x3, x18, (x4)         ;
_l35:    la x3, d_4_24                    ;
      addi x3, x3, 28         ;
      amomax.w x17, x23, (x3)         ;
_l36:    slli x5, x8, 0                    ;
_l37:    fsqrt.s f10, f12, rne                    ;
_l38:    lui x23, 896605                    ;
_l39:    lui x15, 357417                    ;
_l40:    la x3, d_3_13                    ;
      sw x5, 20(x3)         ;
_l41:    fmin.s f4, f31, f2                    ;
_l42:    csrrwi x16, pmpcfg0, 31                    ;
_l43:    la x18, d_0_2                    ;
      flw f27, 4(x18)         ;
_l44:    la x25, d_0_21                    ;
      sb x24, -1(x25)         ;
_l45:    fmv.w.x f7, x20                    ;
_l46:    fcvt.lu.s x27, f21, rne                    ;
_l47:    la x12, d_3_24                    ;
      addi x12, x12, 28         ;
      amoswap.w x16, x29, (x12)         ;
_l48:    sllw x14, x27, x16                    ;
_l49:    li x9, 1                    ;
      la x10, pt0         ;
      addi x10, x10, 0         ;
      sfence.vma x9, x10         ;
_l50:    csrrci x1, pmpaddr2, 7                    ;
_l51:    la x14, d_5_19                    ;
      addi x14, x14, -16         ;
      amoadd.d x13, x30, (x14)         ;
_l52:    la x23, d_3_3                    ;
      fsw f25, 8(x23)         ;
_l53:    sltiu x28, x25, -690                    ;
_l54:    srliw x3, x23, 31                    ;
_l55:    csrrwi x23, fflags, 9                    ;
_l56:    la x19, d_5_21                    ;
      lui x9, 0xffe00         ;
      xor x19, x19, x9         ;
      lb x3, 31(x19)         ;
_l57:    li x24, 1                    ;
      la x9, pt3         ;
      addi x9, x9, 56         ;
      sfence.vma x24, x9         ;
_l58:    la x14, d_4_15                    ;
      addi x14, x14, -8         ;
      amoadd.d x30, x2, (x14)         ;
_l59:    csrrwi x22, fflags, 19                    ;
_l60:    fcvt.w.s x20, f2, rne                    ;
_l61:    fclass.s x5, f0                    ;
_l62:    fsgnjx.s f26, f21, f5                    ;
_l63:    fcvt.s.l f9, x7, rne                    ;
_l64:    addi x0, x1, 0                    ;
_l65:    xor x24, x24, x24                    ;
      addi x27, zero, 3         ;
      slli x27, x27, 15         ;
      add x24, x24, x27         ;
      csrrs x6, scause, x24         ;
_l66:    fcvt.wu.s x28, f1, rne                    ;
_l67:    la x5, d_5_5                    ;
      addi x5, x5, 24         ;
      sc.d x4, x5, (x5)         ;
_l68:    la x28, d_1_27                    ;
      srai x28, x28, 1         ;
      csrrs x1, pmpaddr3, x28         ;
_l69:    uret                    ;
_l70:    la x19, d_0_14                    ;
      addi x19, x19, 8         ;
      amominu.d x17, x13, (x19)         ;
_l71:    la x1, d_5_0                    ;
      addi x1, x1, -8         ;
      amomax.w x22, x28, (x1)         ;
_l72:    fsgnjn.s f0, f23, f7                    ;
_l73:    la x5, d_5_15                    ;
      srai x5, x5, 1         ;
      csrrs x16, pmpaddr2, x5         ;
_l74:    la x20, d_1_26                    ;
      lhu x12, -10(x20)         ;
_l75:    la x30, d_5_8                    ;
      addi x30, x30, 20         ;
      sc.w x18, x19, (x30)         ;
_l76:    fmin.s f22, f22, f29                    ;
_l77:    li x27, 1                    ;
      la x5, pt0         ;
      addi x5, x5, 0         ;
      sfence.vma x27, x5         ;
_l78:    la x30, d_3_10                    ;
      addi x30, x30, 24         ;
      amoxor.w x25, x6, (x30)         ;
_l79:    la x17, d_5_22                    ;
      lb x9, -25(x17)         ;
_l80:    la x5, d_2_0                    ;
      addi x5, x5, 8         ;
      amoxor.d x18, x28, (x5)         ;
_l81:    fmadd.s f19, f3, f18, f1, rne                    ;
_l82:    csrrsi x15, pmpaddr6, 5                    ;
_l83:    la x15, d_2_21                    ;
      addi x15, x15, -28         ;
      amoadd.w x24, x29, (x15)         ;
_l84:    xor x6, x6, x6                    ;
      addi x10, zero, 3         ;
      slli x10, x10, 20         ;
      add x6, x6, x10         ;
      addi x5, zero, 1         ;
      slli x5, x5, 17         ;
      add x6, x6, x5         ;
      addi x11, zero, 1         ;
      slli x11, x11, 10         ;
      add x6, x6, x11         ;
      csrrs x27, sscratch, x6         ;
_l85:    fmax.s f15, f26, f27                    ;
_l86:    andi x4, x19, -2047                    ;
_l87:    la x6, d_2_17                    ;
      addi x6, x6, -28         ;
      amoand.w x10, x30, (x6)         ;
_l88:    fmsub.s f16, f25, f31, f19, rne                    ;
_l89:    la x28, d_1_8                    ;
      addi x28, x28, -0         ;
      amoor.d x24, x6, (x28)         ;
_l90:    la x30, d_5_8                    ;
      addi x30, x30, 20         ;
      sc.w x18, x19, (x30)         ;
_l91:    fle.s x26, f11, f8                    ;
_l92:    slli x27, x2, 0                    ;
_l93:    sltiu x12, x27, 2047                    ;
_l94:    fle.s x7, f31, f25                    ;
_l95:    uret                    ;
_l96:    addiw x21, x15, 742                    ;
_l97:    xor x15, x15, x15                    ;
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
_l98:    addw x13, x22, x2                    ;
_l99:    sltiu x12, x27, -1144                    ;
_l100:    slliw x1, x0, 25                    ;
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
                .dword 0x3c433112179b67be, 0x9523a51043f2b0ee
                .dword 0xc0bc46b335ae87b5, 0xd843ce0e2934b766
d_0_0:          .dword 0xd3883c779f9501c5, 0xd79b4c75215ee410
d_0_1:          .dword 0xcdc0835699709c1c, 0x6b33b09186124b26
d_0_2:          .dword 0x0666c9fccaa74db1, 0x78d9f3952f8c0378
d_0_3:          .dword 0x430d862cf939d978, 0xa9ad8fd43b4ab362
d_0_4:          .dword 0x6229b45e6e20906f, 0x2bae343d4ba7ff0b
d_0_5:          .dword 0x8fec6c37498c8573, 0x74774afe01ffde48
d_0_6:          .dword 0x84270410896009e6, 0xe2696a3a6a584be0
d_0_7:          .dword 0x3b6da46513306986, 0x9f3b004049cbb657
d_0_8:          .dword 0x3e742c8771cc6b4d, 0xd3f570ee02752a41
d_0_9:          .dword 0xf4f3fa7212df750e, 0x79a32b7af704798a
d_0_10:         .dword 0xd90837f74072fc74, 0x91e01a6e23f0915c
d_0_11:         .dword 0x50eb7288128900ec, 0xdfdb9099e6b91264
d_0_12:         .dword 0xb8b2767ea336a663, 0x316cf2ee49b95384
d_0_13:         .dword 0xc65ad5e29d924443, 0x40fc5f843b6acfcc
d_0_14:         .dword 0x150272d66dbcdc84, 0xf4166b477022d0f4
d_0_15:         .dword 0xbee4661f5960c364, 0xf545b83d2af9f95e
d_0_16:         .dword 0x1cf9ef0604c78451, 0x654483981bc03fee
d_0_17:         .dword 0x28d5f270a8be02da, 0x9de83bd5049314d5
d_0_18:         .dword 0xe056f740b05e5f0f, 0x5c9af78bc889f844
d_0_19:         .dword 0x966d6ff538320718, 0x36155aa1bce042be
d_0_20:         .dword 0xb6b6ba95596aeda7, 0xe0b2589aaaad5117
d_0_21:         .dword 0x6136c37656ca38bd, 0x51d549996785abd0
d_0_22:         .dword 0x29a246c3e7fa44cb, 0x019e6bb009450d5b
d_0_23:         .dword 0x7228f8151598745c, 0xe9a01a38c68f149c
d_0_24:         .dword 0x4f9aed172232303a, 0x7a8ff07e6c5d5a12
d_0_25:         .dword 0x00679a0622b64034, 0x763b6b737d429b15
d_0_26:         .dword 0xeffc20fab0ceab3b, 0x51b455016b64680c
d_0_27:         .dword 0xa381b9c92f36884a, 0xbad4909f5f41f384
                .dword 0xdb6dae6e3621bf7b, 0x376ea639aedceca1
                .dword 0x2140d8b23a83627c, 0x93d43ea49451c25a
        /* Random data */
_end_data0:
                 

    .section .data.random1;
    .align  8;

_random_data1:
                .dword 0x2b5eeb3514a583e9, 0xa968bbc1b626d17d
                .dword 0xeb055818c3a2c896, 0x8721b611edca2c5e
d_1_0:          .dword 0x37f9608a3007b7a0, 0x633783e91105b22d
d_1_1:          .dword 0xecd219b90b4be28a, 0x807e5f1da6150b4d
d_1_2:          .dword 0x064c67179be6ad21, 0x3c6c14752596beaa
d_1_3:          .dword 0x65454ed7488731d0, 0x642d651419418bf8
d_1_4:          .dword 0xb3555c12fec37074, 0xf079320e7f7da776
d_1_5:          .dword 0x1a81041d4d6b4666, 0x2331a7d3ce6e8ff5
d_1_6:          .dword 0xef67cafce8858ba1, 0x72d82b20ccbd54c1
d_1_7:          .dword 0x0931bf49eb35e10e, 0x8bbc366e4c3e9c2f
d_1_8:          .dword 0xad06b925fba9304a, 0x0a2b09dd5cc8b5bb
d_1_9:          .dword 0x2acfadad6a2c5535, 0x02a174687ff1e4f7
d_1_10:         .dword 0x813455f150e2da2c, 0x2cb1a1ece85f6a52
d_1_11:         .dword 0x11a897af07686715, 0x171f50144699fa4b
d_1_12:         .dword 0xe83ef5791fe680d8, 0xba01dd7c3d38916a
d_1_13:         .dword 0xafdcff14b3dff250, 0x19747d4eb7135210
d_1_14:         .dword 0x6e38b752891aabd5, 0xabcd3b01c9d3ac58
d_1_15:         .dword 0x655820dc30fa5fc0, 0xc1ba44fcbbe7cb3e
d_1_16:         .dword 0x4a574df396e0b47e, 0xadea7522b82c6f83
d_1_17:         .dword 0x32a5a40bf4a8cfd6, 0x51c63c23330d72ee
d_1_18:         .dword 0xb740824fbb690f38, 0xadcee56e7c8acfe0
d_1_19:         .dword 0x72134e5e3523ef3c, 0x20305afffbdf6ebf
d_1_20:         .dword 0x46283253fb0f3c2c, 0x3a38817acc04e803
d_1_21:         .dword 0xf66d5a88c43083cb, 0xc0333f6cc6c0079e
d_1_22:         .dword 0xcfb2f32c14ee4f8d, 0xd90ba6cc663b2865
d_1_23:         .dword 0x8260460a7a488602, 0xefd872f0c33a7cbb
d_1_24:         .dword 0xf03dfd03b8c5c71a, 0xd2d1364bac47f0df
d_1_25:         .dword 0xffa26c92c7c22329, 0x657423d439661668
d_1_26:         .dword 0x693cca70ae2517dc, 0xbdb5c1228bd20cea
d_1_27:         .dword 0x0278c05a11ca8f61, 0x99fc64e247a39157
                .dword 0xa56e1126a82338da, 0xf0b28f3ff610dade
                .dword 0xe05f4bb04d75d887, 0x695e5776bc53f2e9
        /* Random data */
_end_data1:


    .section .data.random2;
    .align  8;

_random_data2:
                .dword 0xd98ccef75ac0fde4, 0xacc6c95399ac417e
                .dword 0xd435533d85250cd9, 0xba182709e7f0d597
d_2_0:          .dword 0x1391b05f19d50f7c, 0x42624605551d4aea
d_2_1:          .dword 0xe4d5593730caa7b3, 0xfe81f9a4f04586bc
d_2_2:          .dword 0xa6b0fd09e2ae6312, 0x1ce5992f7633d6d9
d_2_3:          .dword 0xcc9ed948c6ce5640, 0x25775fa9b5f96b39
d_2_4:          .dword 0x5501e063b4e79a22, 0x95f939c97f905690
d_2_5:          .dword 0x6d75d2761aeb9307, 0xc3cc72e15d593893
d_2_6:          .dword 0x354faa1bc3b323da, 0xc1a732977bf7df32
d_2_7:          .dword 0x8ca79d8b7eed3cbf, 0xd1abe01bd3f5dfba
d_2_8:          .dword 0x766c2ef14f16ca26, 0x55019e6fac3bea45
d_2_9:          .dword 0x9b31bad127aa8033, 0x45558f2a6e55e23c
d_2_10:         .dword 0x853f3acb90e45280, 0x97ac11550d67ed99
d_2_11:         .dword 0x2d599bc087130fd1, 0x4c7cdaefa6efb5ef
d_2_12:         .dword 0x3f191aac6538fb5b, 0x4aa3d1f409806a4c
d_2_13:         .dword 0xaed87de1e73b3420, 0x3e197c9d750584d2
d_2_14:         .dword 0x0c6b705bad248a25, 0xa7796b524d48e273
d_2_15:         .dword 0xec9d2625871d69b6, 0xc8b0ec3207756085
d_2_16:         .dword 0xe938433ec1297617, 0x0f781720a0b0dca6
d_2_17:         .dword 0x79d207f9ab016720, 0xd1c10638b05cf791
d_2_18:         .dword 0xd673e10c52f3800e, 0xe321f5831c882d05
d_2_19:         .dword 0xdd1f8ad04a4cda64, 0x7f4e6a11e3308ee0
d_2_20:         .dword 0x4b4ba8da88d5b14d, 0xf4f1aa5a33f6b037
d_2_21:         .dword 0x262fb1f0cf0dbc1a, 0xac5bd512d42736c7
d_2_22:         .dword 0xa3e7a4f404dbd35d, 0xfd56e05b0ad0059b
d_2_23:         .dword 0x3a981db5f484bf84, 0x608b87c3cc0a74c9
d_2_24:         .dword 0xafa9c9e377588491, 0xe10ed06a9032f2f8
d_2_25:         .dword 0x2e72349a42186d88, 0xb3dcee4aaa95f378
d_2_26:         .dword 0x0fe38edd9020802c, 0xcfcc1a8d61b0a505
d_2_27:         .dword 0x3c92dba95598decb, 0x349983ced87d125f
                .dword 0x58e83076d1a14b89, 0xa0ba6f8a7c81eb73
                .dword 0x80d037440fb9464d, 0x07829cba0dec2953
         /* Random data */
_end_data2:
                

    .section .data.random3;
    .align  8;

_random_data3:
                .dword 0x9c4032309ea21e26, 0x95c922e4fc3a0b8a
                .dword 0xca9c08746a44a4f8, 0x34362e60888646ad
d_3_0:          .dword 0x23c2969276da4d8c, 0x06424080ced886bc
d_3_1:          .dword 0x40cdb58cbd4ccb10, 0x7692d0042fd8b43d
d_3_2:          .dword 0x6c59a195cfcc3e3b, 0xbf3a3336843fd146
d_3_3:          .dword 0x06f6e8f66e4a1c72, 0xe801ca80ff63e4af
d_3_4:          .dword 0x9d472282af72d425, 0x22e2c55036fe9cbd
d_3_5:          .dword 0x60c00da22fb3b69c, 0x57567582fb67a45b
d_3_6:          .dword 0x47ae1897cac36d0f, 0xddafb8499f33cd53
d_3_7:          .dword 0xed169cc30830e4b9, 0x79513cc22468dc1a
d_3_8:          .dword 0xa940d451dd768703, 0xb79be5beff734cdd
d_3_9:          .dword 0x862ba0d7f9e0d8c6, 0xa03a533f1dac7989
d_3_10:         .dword 0xc30b595f1f0f38e9, 0xfd2d83deae53c8f5
d_3_11:         .dword 0x103bc1cbe2ed427a, 0xba8884a50cdfb27d
d_3_12:         .dword 0xfb965eceecac6e52, 0xd83f8421d1a2c5f2
d_3_13:         .dword 0x3958fcfb23366614, 0x45777d45bfbc95c0
d_3_14:         .dword 0xc5bbde7fb21f85a6, 0xbe2190fe617d4dc7
d_3_15:         .dword 0xe9f51ec3bb59c6d5, 0x8de7da8b43b42168
d_3_16:         .dword 0x4f9255c15e424916, 0x1f36e42eb9f4a14f
d_3_17:         .dword 0xf879e9f8bdb28c0b, 0xc496c0cfda5f0c0d
d_3_18:         .dword 0x394d08bbbe4fa65d, 0xdac30c6973ecd58e
d_3_19:         .dword 0x320aecf6f83ca41a, 0x248d82f31ca8228a
d_3_20:         .dword 0xc4e9d1b78050d843, 0xeb169ccaaa888f5e
d_3_21:         .dword 0xe75a82ee1921f0c5, 0xf5a2db58b79a0525
d_3_22:         .dword 0xf3c537dcaadbc463, 0x17b9c303d2f33123
d_3_23:         .dword 0x1bc411e962a4a933, 0x5d80aa2c3588056e
d_3_24:         .dword 0xaee4e0c92046e80f, 0xb2ee6abafc94bcc6
d_3_25:         .dword 0x2224df94a5cc2d28, 0xd1d95177ae54edd0
d_3_26:         .dword 0x6465039cc797e1b6, 0xa45baa3f2da59014
d_3_27:         .dword 0xe09ec458b51d1a78, 0x1e6b476b7f9ccac4
                .dword 0x9c1b2fcc370fcd01, 0x3f08fb0d7bc94947
                .dword 0x10407fbd0a0dc955, 0x6ccecf86736dd0a7
        /* Random data */
_end_data3:


    .section .data.random4;
    .align  8;

_random_data4:
                .dword 0x1ee6952e15905c04, 0x4ca4c75c0714a212
                .dword 0x12493d3f1ff9c09f, 0x0c032a06d0ec9e7c
d_4_0:          .dword 0xaa9ba831e531432b, 0xa4ef295acd87f16b
d_4_1:          .dword 0xb552488929f474cf, 0xcd10ec1cc40b40ae
d_4_2:          .dword 0x34e9d39d59d4838d, 0x593effb269c5b724
d_4_3:          .dword 0x58fe0d75469b8298, 0xf6d14350716b84eb
d_4_4:          .dword 0x5163c5221bb46059, 0xa1e1de65b6f573e4
d_4_5:          .dword 0x01e628c5243de73d, 0xd105ed29f927a510
d_4_6:          .dword 0x9e080dd45d9b9cc4, 0x5b25d68442809fd7
d_4_7:          .dword 0xa3e3dc9017ebfc13, 0x1f50e6055033ed73
d_4_8:          .dword 0x61d7f959e567d0d8, 0x5cf46c6f84fd0dbb
d_4_9:          .dword 0xb70cf099d374a139, 0x577441eecd407581
d_4_10:         .dword 0x60124b21c8a9ef00, 0x8993f4dfad38f9b5
d_4_11:         .dword 0x5e418e271d075633, 0x1bd75ec6866f9d47
d_4_12:         .dword 0x04f83ac348702ae6, 0x5e48efaa9278b3cf
d_4_13:         .dword 0x9c4249407ff369c2, 0xcdca0aab066c9909
d_4_14:         .dword 0x69aa9fb71a5103da, 0xb96197df411b18d3
d_4_15:         .dword 0xe05b625191a8f440, 0x615f801b834ebe0d
d_4_16:         .dword 0x45278f097f014046, 0xfeacad82741d4329
d_4_17:         .dword 0xff0f18d3bcbf4c7f, 0x2e7defca325880d1
d_4_18:         .dword 0x1533a90d706a2ad4, 0x4602fa0dbfded602
d_4_19:         .dword 0x9370f0326d5cafa6, 0x636dd75939126d10
d_4_20:         .dword 0x6a0366af68ed5cb6, 0x93f0853d3bc48a9c
d_4_21:         .dword 0x6d39fa2a164805cc, 0x9c52165eb158c040
d_4_22:         .dword 0x622a358ee03130ed, 0x5b5e03a2d42c241c
d_4_23:         .dword 0xbe0c107bdb2c4992, 0xc9477490e49e9c59
d_4_24:         .dword 0xaf324182e1e87b8e, 0x6e1d71447ef0c7c8
d_4_25:         .dword 0x6364828bf20a2d75, 0xb8eb20946b72c84c
d_4_26:         .dword 0xf844fe103b58534c, 0xb95d2258155a6730
d_4_27:         .dword 0xae61478786cb15ac, 0xd3779305263cba14
                .dword 0xeab7486e62a1e376, 0xe3fc21a33cfdb0e5
                .dword 0x50f3f332628f878a, 0xb06fc24f7e02b445
        /* Random data */
_end_data4:


    .section .data.random5;
    .align  8;

_random_data5:
                .dword 0x272c9a8c7392d4ae, 0xfc513a77b076fc97
                .dword 0x2f3ce3e63406df52, 0xeb4c4c64748ca1c2
d_5_0:          .dword 0x9eaeb1928f7ba217, 0x0fe7940562ce3edb
d_5_1:          .dword 0x70587e8c57c01441, 0xeffad8ce330387e2
d_5_2:          .dword 0x6db463b7f6a67f71, 0xbdbcc49788c3499d
d_5_3:          .dword 0xa7fd27871ab31377, 0x481d4affa1cee848
d_5_4:          .dword 0x9fa67f8092c08a8c, 0x9b1a2677a4f1caf6
d_5_5:          .dword 0x77cfaba8cda293bf, 0x5eeeb1d63468b715
d_5_6:          .dword 0x55ca8b5d9c73e26e, 0x977c61f27c3ffa89
d_5_7:          .dword 0xf58e7af6086e0188, 0x2e7a772b5a9fdddb
d_5_8:          .dword 0xdc681a7a34267a81, 0x34867aaa9a04c040
d_5_9:          .dword 0xd8481b2d1195c1de, 0xbe9a45cb8db9af5b
d_5_10:         .dword 0x69d958db7e4deb46, 0x5b688fb07e48d9b4
d_5_11:         .dword 0xdcf02f2e7d216db3, 0xc7ab219ea0e0bba0
d_5_12:         .dword 0x64495a18804e5785, 0xbb8798a3ab3cce2f
d_5_13:         .dword 0x326d5b47a5dc546d, 0x79019cfb668f4e73
d_5_14:         .dword 0xe4f910091b8095e7, 0x2b8010456a39ac5b
d_5_15:         .dword 0x9674513eadad19fd, 0x6503d649df66f091
d_5_16:         .dword 0x20fe0bd26afcc4b8, 0x89f15a05ea156b9a
d_5_17:         .dword 0xb8840a88064cf22e, 0x1806c7f678840631
d_5_18:         .dword 0x0bac867cb95f6772, 0x6172cae907ac171a
d_5_19:         .dword 0xe79aeb9a9e3777f6, 0x998fd89d13e24e9f
d_5_20:         .dword 0x8a1d331fbea924e2, 0xe256a21c500f28bd
d_5_21:         .dword 0x899f21a32801bcdd, 0xfc55c655e00574ce
d_5_22:         .dword 0x82c62de72646dbba, 0x8c4719ddf8ad4e91
d_5_23:         .dword 0x91fe609e66205737, 0x4746a066def94cf8
d_5_24:         .dword 0xb7e962ae2b66eb77, 0x798c2aeb63fe9e51
d_5_25:         .dword 0x7f4f150f588ccbdb, 0xe25ae4e1ddc0d8ae
d_5_26:         .dword 0xe6ce6f1f40ac5be3, 0x984ea6501bf9daf2
d_5_27:         .dword 0xc07de7481e8fcbd6, 0xff3122780711aca0
                .dword 0xb37bd36ccb7fa216, 0xe8665098321f088e
                .dword 0xa871b972656f8884, 0x527027c955d66463
         /* Random data */
_end_data5:
              
                 
