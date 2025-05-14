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
_s0:    andi x23, x20, 1155                       ;
_s1:    uret                                      ;
_s2:    slti x14, x14, -689                       ;
_s3:    fclass.s x5, f15                          ;
_s4:    fsgnjn.s f10, f13, f27                    ;
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
        addi x12, zero, 1                         ;
        slli x12, x12, 29                         ;
        add x11, x11, x12                         ;
        csrrs x11, scause, x11                    ;
_p1:    csrrsi x11, pmpaddr3, 0                   ;
_p2:    xor x10, x10, x10                         ;
        addi x11, zero, 3                         ;
        slli x11, x11, 20                         ;
        add x10, x10, x11                         ;
        csrrc x14, sscratch, x10                  ;
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
_l1:    la x21, d_5_25                    ;
      addi x21, x21, -16         ;
      lui x22, 0xffe00         ;
      xor x21, x21, x22         ;
      amomin.d x18, x22, (x21)         ;
_l2:    fmul.s f24, f24, f23, rne                    ;
_l3:    sret                    ;
_l4:    la x18, d_5_11                    ;
      fsw f12, 28(x18)         ;
_l5:    addi x0, x1, 0                    ;
_l6:    la x8, d_4_12                    ;
      addi x8, x8, 16         ;
      lui x30, 0xffe00         ;
      xor x8, x8, x30         ;
      lr.d x4, (x8)         ;
_l7:    la x30, d_1_17                    ;
      addi x30, x30, -24         ;
      sc.d x7, x30, (x30)         ;
_l8:    fadd.s f10, f20, f8, rne                    ;
_l9:    la x7, d_1_8                    ;
      addi x7, x7, 24         ;
      amoand.d x24, x14, (x7)         ;
_l10:    la x24, d_0_16                    ;
      ld x10, -0(x24)         ;
_l11:    la x30, d_5_24                    ;
      lh x26, -8(x30)         ;
_l12:    fnmadd.s f3, f28, f5, f24, rne                    ;
_l13:    subw x24, x27, x28                    ;
_l14:    sraiw x3, x16, 31                    ;
_l15:    fle.s x3, f17, f26                    ;
_l16:    la x1, d_5_0                    ;
      addi x1, x1, -8         ;
      amomax.w x22, x28, (x1)         ;
_l17:    la x19, d_0_8                    ;
      addi x19, x19, 4         ;
      amoor.w x15, x25, (x19)         ;
_l18:    la x10, d_2_19                    ;
      flw f9, 0(x10)         ;
_l19:    fsgnjx.s f9, f0, f3                    ;
_l20:    la x8, d_3_26                    ;
      lh x13, -14(x8)         ;
_l21:    slliw x7, x25, 10                    ;
_l22:    srlw x25, x12, x6                    ;
_l23:    fcvt.lu.s x22, f5, rne                    ;
_l24:    slliw x1, x0, 25                    ;
_l25:    srai x18, x0, 18                    ;
_l26:    la x15, d_3_10                    ;
      lhu x18, 0(x15)         ;
_l27:    srai x15, x10, 6                    ;
_l28:    feq.s x28, f26, f5                    ;
_l29:    sltiu x0, x14, -117                    ;
_l30:    la x9, _l91                    ;
      lbu x19, 8(x9)         ;
_l31:    addw x13, x22, x2                    ;
_l32:    la x12, d_3_4                    ;
      addi x12, x12, 0         ;
      lui x2, 0xffe00         ;
      xor x12, x12, x2         ;
      amomaxu.d x19, x2, (x12)         ;
_l33:    la x26, d_5_24                    ;
      sh x19, 4(x26)         ;
_l34:    xor x11, x11, x11                    ;
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
_l35:    fmv.w.x f20, x25                    ;
_l36:    la x25, d_4_4                    ;
      addi x25, x25, -8         ;
      amoand.d x2, x28, (x25)         ;
_l37:    sraw x0, x2, x21                    ;
_l38:    xor x15, x15, x15                    ;
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
_l39:    fnmadd.s f16, f6, f12, f26, rne                    ;
_l40:    fcvt.l.s x25, f14, rne                    ;
_l41:    fmadd.s f8, f5, f14, f31, rne                    ;
_l42:    sltiu x29, x30, 2047                    ;
_l43:    la x19, d_1_9                    ;
      lhu x6, 30(x19)         ;
_l44:    fle.s x7, f31, f25                    ;
_l45:    fcvt.wu.s x14, f17, rne                    ;
_l46:    sltiu x12, x27, -1144                    ;
_l47:    addiw x21, x15, 742                    ;
_l48:    fcvt.s.lu f3, x15, rne                    ;
_l49:    la x15, d_2_21                    ;
      addi x15, x15, -28         ;
      amoadd.w x24, x29, (x15)         ;
_l50:    la x22, d_5_11                    ;
      lui x24, 0xffe00         ;
      xor x22, x22, x24         ;
      sb x6, 31(x22)         ;
_l51:    la x8, d_3_26                    ;
      lh x13, -14(x8)         ;
_l52:    la x5, d_2_0                    ;
      addi x5, x5, 8         ;
      amoxor.d x18, x28, (x5)         ;
_l53:    fle.s x26, f11, f8                    ;
_l54:    la x5, d_5_15                    ;
      srai x5, x5, 1         ;
      csrrs x16, pmpaddr2, x5         ;
_l55:    la x30, d_5_8                    ;
      addi x30, x30, 20         ;
      sc.w x18, x19, (x30)         ;
_l56:    fsgnjn.s f0, f23, f7                    ;
_l57:    fmsub.s f16, f25, f31, f19, rne                    ;
_l58:    fcvt.s.l f9, x7, rne                    ;
_l59:    fsgnjx.s f26, f21, f5                    ;
_l60:    li x24, 1                    ;
      la x9, pt3         ;
      addi x9, x9, 56         ;
      sfence.vma x24, x9         ;
_l61:    la x23, d_3_3                    ;
      fsw f25, 8(x23)         ;
_l62:    la x14, d_5_19                    ;
      addi x14, x14, -16         ;
      amoadd.d x13, x30, (x14)         ;
_l63:    fcvt.lu.s x27, f21, rne                    ;
_l64:    la x6, d_2_17                    ;
      addi x6, x6, -28         ;
      amoand.w x10, x30, (x6)         ;
_l65:    andi x4, x19, -2047                    ;
_l66:    fnmadd.s f10, f10, f19, f30, rne                    ;
_l67:    fmax.s f15, f26, f27                    ;
_l68:    la x18, d_0_2                    ;
      flw f27, 4(x18)         ;
_l69:    la x3, d_3_13                    ;
      sw x5, 20(x3)         ;
_l70:    la x4, d_1_2                    ;
      addi x4, x4, 0         ;
      amoand.d x22, x20, (x4)         ;
_l71:    slliw x23, x30, 20                    ;
_l72:    la x17, d_5_22                    ;
      lb x9, -25(x17)         ;
_l73:    la x21, d_3_13                    ;
      addi x21, x21, 20         ;
      amoswap.w x15, x6, (x21)         ;
_l74:    la x30, d_3_10                    ;
      addi x30, x30, 24         ;
      amoxor.w x25, x6, (x30)         ;
_l75:    mret                    ;
_l76:    li x27, 1                    ;
      la x5, pt0         ;
      addi x5, x5, 0         ;
      sfence.vma x27, x5         ;
_l77:    la x25, d_4_1                    ;
      ld x20, -0(x25)         ;
_l78:    la x9, d_3_7                    ;
      fsw f24, 4(x9)         ;
_l79:    la x23, d_3_20                    ;
      ld x19, 0(x23)         ;
_l80:    sraiw x20, x29, 31                    ;
_l81:    la x24, d_3_18                    ;
      addi x24, x24, 24         ;
      amoand.w x20, x1, (x24)         ;
_l82:    xor x11, x11, x11                    ;
      addi x16, zero, 1         ;
      slli x16, x16, 11         ;
      add x11, x11, x16         ;
      csrrs x9, sip, x11         ;
_l83:    la x6, d_5_8                    ;
      lh x9, -12(x6)         ;
_l84:    xor x28, x28, x28                    ;
      addi x12, zero, 1         ;
      slli x12, x12, 3         ;
      add x28, x28, x12         ;
      addi x21, zero, 1         ;
      slli x21, x21, 16         ;
      add x28, x28, x21         ;
      csrrc x5, sip, x28         ;
_l85:    la x16, d_3_20                    ;
      addi x16, x16, -28         ;
      amomin.w x4, x6, (x16)         ;
_l86:    fcvt.s.w f21, x4, rne                    ;
_l87:    xor x20, x20, x20                    ;
      addi x20, zero, 1         ;
      slli x20, x20, 12         ;
      add x20, x20, x20         ;
      csrrc x22, sscratch, x20         ;
_l88:    fle.s x12, f1, f25                    ;
_l89:    fmin.s f22, f22, f29                    ;
_l90:    la x26, d_5_11                    ;
      addi x26, x26, -20         ;
      lr.w x20, (x26)         ;
_l91:    la x30, d_5_8                    ;
      addi x30, x30, 20         ;
      sc.w x18, x19, (x30)         ;
_l92:    la x20, d_1_26                    ;
      lhu x12, -10(x20)         ;
_l93:    la x1, d_5_0                    ;
      addi x1, x1, -8         ;
      amomax.w x22, x28, (x1)         ;
_l94:    fdiv.s f29, f25, f11, rne                    ;
_l95:    la x13, d_2_14                    ;
      addi x13, x13, 24         ;
      amomaxu.w x5, x14, (x13)         ;
_l96:    addiw x4, x3, -1291                    ;
_l97:    la x19, d_0_14                    ;
      addi x19, x19, 8         ;
      amominu.d x17, x13, (x19)         ;
_l98:    la x5, d_5_5                    ;
      addi x5, x5, 24         ;
      sc.d x4, x5, (x5)         ;
_l99:    addw x9, x30, x20                    ;
_l100:    subw x7, x23, x17                    ;
      srai x5, x5, 1         ;
      csrrs x16, pmpaddr2, x5         ;
      ld x24, 0(x9)         ;
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
                .dword 0xf78f9a18d3bdcf5f, 0xe8d540e285940ac1
                .dword 0x5ab18ea694ace3de, 0x901939b275cc83aa
d_0_0:          .dword 0x71c08b9776a2e43b, 0x7a187f6e431260d9
d_0_1:          .dword 0xb566eaf558d58ab3, 0x568de39cbf938b42
d_0_2:          .dword 0xed5593e9b45aeaad, 0xc4d9e3364b899129
d_0_3:          .dword 0x500a2d2aa4e32f03, 0x5233307bb8a30c53
d_0_4:          .dword 0x43d340d9a6e13221, 0x12fea3c90b77f501
d_0_5:          .dword 0x42e413e2278f7e67, 0xeecc5874548354d2
d_0_6:          .dword 0x6f419376339a9947, 0x96d34a9b6f45923a
d_0_7:          .dword 0x4015dd31b17aa46a, 0x06bade7b9f39b229
d_0_8:          .dword 0x6bd5672ffc222fd6, 0x1022301dc6d61ab7
d_0_9:          .dword 0xccf62ce9fcd67feb, 0x18f7871b0bba9c7a
d_0_10:         .dword 0x0979b578bfdadf3a, 0x5918ea6cd8396c8c
d_0_11:         .dword 0x4a309b99350d0fb0, 0x6ae3d51dcbe33b54
d_0_12:         .dword 0x7c925cc1e3a92c1a, 0xa4c33c9bdeeaa50a
d_0_13:         .dword 0x03680bc75855fce1, 0xa40f416130843335
d_0_14:         .dword 0xa1b19760d906e38c, 0xb21300993f3445c4
d_0_15:         .dword 0xe15622573d8eea25, 0xbb4c8215f97370d8
d_0_16:         .dword 0x361b5bdd1021477b, 0x0a882c0f392ec163
d_0_17:         .dword 0x10fc2e8801827982, 0x6d7ff84c4cfaa53c
d_0_18:         .dword 0xc100709a5aed0649, 0x1143773edc5dd719
d_0_19:         .dword 0x1f5f6f82e1868409, 0x030339050b02bbab
d_0_20:         .dword 0x010522fc5e8807bb, 0x7caba4dd387ee2e8
d_0_21:         .dword 0xefe97c4eb59a184d, 0x0893fdf6d9fddc42
d_0_22:         .dword 0x29a334c6904f4546, 0x59ba3b6adf834c28
d_0_23:         .dword 0x937d75a17357ac20, 0x1a9ec48439352a7a
d_0_24:         .dword 0x4aff47e5306d5a7c, 0x01c1e3c887234df0
d_0_25:         .dword 0x68c1917d4c72cfc0, 0x65ba83f0dc075e56
d_0_26:         .dword 0x692955234136252b, 0xc988e81ae8415188
d_0_27:         .dword 0xc2e916f7f253a811, 0x1b5d00702d43e24b
                .dword 0x6894787ab9266fa0, 0xdaf1f947dfbcc44e
                .dword 0x527a4be3c06957a4, 0x66140a76cc5e4572
        /* Random data */
_end_data0:
                 

    .section .data.random1;
    .align  8;

_random_data1:
                .dword 0xc0fef2b6ec6a6e4f, 0x2137b030dd72f39b
                .dword 0x73fddd78a6ed44bd, 0x342538c0f34d8318
d_1_0:          .dword 0x4eb69f9f47594c42, 0x3a403cfeb0b3da0f
d_1_1:          .dword 0x2c219e2f41b0e022, 0x4b1a7e757f90a981
d_1_2:          .dword 0x5f858c77f46537e8, 0xf0936d293406f339
d_1_3:          .dword 0x993fed74fcbf3841, 0x063d05c6ed9f41dd
d_1_4:          .dword 0x5e19b7b22c1688ca, 0x69dd9b11cb4d67d9
d_1_5:          .dword 0x8f474ebe8c67af3e, 0xc718e2b652214887
d_1_6:          .dword 0x75a61d8bffdbe5e8, 0x1ff1ec61b4615eb7
d_1_7:          .dword 0x7c98ce116ab7babc, 0xa4eb381634988c0a
d_1_8:          .dword 0x3b97f2078482fd69, 0x1785b32bbea31374
d_1_9:          .dword 0xdf47210a9eed7fcd, 0x0bc3257e507eeeab
d_1_10:         .dword 0x917debcce839fc40, 0xd6b1bc920827747b
d_1_11:         .dword 0x95791dcbe39b8ef7, 0x981c875a1f8d8466
d_1_12:         .dword 0xe0b5c6a64375715c, 0xa86db1e6dd3cf96f
d_1_13:         .dword 0x3e32a40fdc9bc706, 0x4a92ff5ea7dbb8eb
d_1_14:         .dword 0x6659ad5d484eea98, 0x436f618fedb2169f
d_1_15:         .dword 0x217ba7d542206ccc, 0xbb645a18ebcf28f2
d_1_16:         .dword 0x1980c32ebafe6005, 0x62bfdf2cd030a96e
d_1_17:         .dword 0x3fc5ca2e37856209, 0x388f67e7ca26ade0
d_1_18:         .dword 0x5c8e0c09f17a3ee1, 0x7dbd9f57239512ae
d_1_19:         .dword 0x9923a5fc30f41a1e, 0x915a2fd1896ffced
d_1_20:         .dword 0xb04e5f868a49a5a7, 0xaf98c02a395f443a
d_1_21:         .dword 0x5318669fed8a5d8d, 0xb845eb0171212d85
d_1_22:         .dword 0x5e9c413821684134, 0x0706619df1f4ccb2
d_1_23:         .dword 0x5538e0f5545af681, 0xaf62da80f012faf6
d_1_24:         .dword 0x443fb73736c54cfd, 0x0574ccb456391eeb
d_1_25:         .dword 0x7e44b91cbdc5a1c1, 0x2b155c9892375fbf
d_1_26:         .dword 0x9ee5a21ca7a0158f, 0x44369d146578ac8e
d_1_27:         .dword 0x189da37ee56ea07b, 0x648720aeba928e1c
                .dword 0x24b830709968114b, 0x77ca6ffef0f55e5c
                .dword 0xcf6f3e7367300a76, 0xed527fdd562a65a4
        /* Random data */
_end_data1:


    .section .data.random2;
    .align  8;

_random_data2:
                .dword 0x326bb778bb3a8cae, 0x9c89c0dac8e4ebd6
                .dword 0x21ea5532f966d644, 0xbd86e6cfbabfd25e
d_2_0:          .dword 0xc7bdb116cc37d908, 0x3ec30601ef37a1f3
d_2_1:          .dword 0x5e477d54588bf233, 0x668018b137c48ab2
d_2_2:          .dword 0x0c8d804035cf0af6, 0x1b1eed0c9125dbd0
d_2_3:          .dword 0x09af67c3f2ee8115, 0x3f099eaeb20c0ad9
d_2_4:          .dword 0xdb5b7d95d28eb78f, 0x07f7bd80c908bdd6
d_2_5:          .dword 0x40b274b3010a83ef, 0x07b9b85ed6f47145
d_2_6:          .dword 0x75206c465dd57512, 0x9707090354d4c323
d_2_7:          .dword 0x434dfbf5b1a4b5bf, 0x9975f1ac4df584e4
d_2_8:          .dword 0x52312e281a95b81b, 0x4355ae2c0dab4fa1
d_2_9:          .dword 0x70dba1db9ccfa18b, 0xe232766b55ad0978
d_2_10:         .dword 0xdc1e58c5cb24e442, 0x4fbfbe9b56bf119c
d_2_11:         .dword 0x8e794f3f0d526e94, 0x498ff61bd7677b8f
d_2_12:         .dword 0xedbab53c07a03ab9, 0xe1b72f19e6c8f598
d_2_13:         .dword 0x6d30623d0b1f3c55, 0x0ad16dfcdcad70c2
d_2_14:         .dword 0x8e75b3d872f9e040, 0xe13ff537c0c3819c
d_2_15:         .dword 0x5dc76491040575fe, 0xb81ec3896634962c
d_2_16:         .dword 0xaea4f46549eff2db, 0x5e415e732bd075b4
d_2_17:         .dword 0x9b0c3773653408fd, 0xed516cb93e13002b
d_2_18:         .dword 0x094643c2e4c44bc1, 0x3fc5fa8391d030c8
d_2_19:         .dword 0x0ec852d6c038c05f, 0xf266a8fce2dfe18a
d_2_20:         .dword 0xff020d0512138b61, 0x319896eb9ebcc827
d_2_21:         .dword 0xea90f39b50271bdb, 0x4a625cbaa5010121
d_2_22:         .dword 0xbf6dd23be4c36e0f, 0x7795e92f47b602d7
d_2_23:         .dword 0xb522cff33927851b, 0x96a8266ae7c6c92b
d_2_24:         .dword 0x5964f4b2fe72a9c5, 0x6e1327089c385422
d_2_25:         .dword 0x9bdd8200dc0a5f5b, 0x79df586a5faa6a88
d_2_26:         .dword 0xb2b97c8bcb418667, 0xcc777c3ad8fde8a1
d_2_27:         .dword 0xcd8fc7626afd0673, 0x56ff0333ec925c5b
                .dword 0xc04121ca96854eb4, 0x97ba5bc5f3326eb3
                .dword 0x7587aa535e50c002, 0x370d91e7b8279627
         /* Random data */
_end_data2:
                

    .section .data.random3;
    .align  8;

_random_data3:
                .dword 0xc9f92dc3cf96d86d, 0x1b80d5a8642c9775
                .dword 0xde15b8202cbda8f7, 0x5c55ad067d69fbb5
d_3_0:          .dword 0xfbfa2685db884a48, 0x63fe29b40cc88543
d_3_1:          .dword 0x8e60af327d73126c, 0x840fca862cd7eb12
d_3_2:          .dword 0x980fdf167999f995, 0x37ce57d6e3b911bd
d_3_3:          .dword 0x72afd5e5d32ef423, 0xb2cc63dfad4a7d21
d_3_4:          .dword 0xa0f7b7b2fc53d246, 0x5e2facae77048205
d_3_5:          .dword 0x1675701cd063c0ba, 0xff698b2702820a71
d_3_6:          .dword 0xd7f101727c88d080, 0xafad4d910464d5be
d_3_7:          .dword 0x3250e752270798a5, 0xfaf34adf0768ce04
d_3_8:          .dword 0xb81c710758d3a6fd, 0x39bd287374cf39b8
d_3_9:          .dword 0x2cc2fedba2892334, 0x318e409bf45ff173
d_3_10:         .dword 0xaa0c38c608741f87, 0x93900201e69f265a
d_3_11:         .dword 0xf8fd40a027b9699b, 0x3f3cfe734acf70a8
d_3_12:         .dword 0x5447d22fae311b93, 0x2f2baa5cd84fbe1c
d_3_13:         .dword 0x40116e23c07eb271, 0xa010b707fe978083
d_3_14:         .dword 0x07e911d1ff78a606, 0xbad8a4025298d393
d_3_15:         .dword 0x59848f50eb71a7e7, 0xa6eeebc421cbd7d6
d_3_16:         .dword 0xc667aceb048cf6af, 0x86498a2acfdfd2f5
d_3_17:         .dword 0x14cc64e3c7f1b718, 0x2679237808281a3e
d_3_18:         .dword 0xeb10abad4d897ce7, 0x03eba894d32b1a23
d_3_19:         .dword 0x457f56c6e672c89d, 0x3c56e98dc1b5431a
d_3_20:         .dword 0x842b3972fcd39f73, 0xea086af0df259fae
d_3_21:         .dword 0xcbd9dbd6761ddd9c, 0xb315b836a0360f83
d_3_22:         .dword 0x0d34547d4c8eadad, 0xbd03f6fd2e5fe358
d_3_23:         .dword 0x475a4e5bf19cb60f, 0x18018aeb882cacb0
d_3_24:         .dword 0xb98550a48af43875, 0x5d6e37d17e414070
d_3_25:         .dword 0xa5ba466e36271dbb, 0xb5606fcd2e6414e4
d_3_26:         .dword 0x0887a0543b855934, 0x5ee54c08b8fd2aaf
d_3_27:         .dword 0x12c34eb8f12d01ba, 0xa02dda44592fb88b
                .dword 0xcc315efc2361d719, 0xcfe9569f1f19e2e6
                .dword 0xa72a25d9da52a93f, 0x9da3058adf755659
        /* Random data */
_end_data3:


    .section .data.random4;
    .align  8;

_random_data4:
                .dword 0x3ed90e8aa2fbe831, 0x92bf06922234218f
                .dword 0xc5d413276d97d6a3, 0x99961628db479e4c
d_4_0:          .dword 0x2cf30f857fc5a6b0, 0xa48e9240dc9298b1
d_4_1:          .dword 0xda5168b19a07fcd2, 0x2d0bf998ff76196f
d_4_2:          .dword 0xcae5ffbc718da09c, 0x3bf917141d15ee14
d_4_3:          .dword 0x32f28c0a4a6cf911, 0x6138bdd9c7bb08f3
d_4_4:          .dword 0xd75f80484a2b0ba4, 0x7bbaa86efe57aa7d
d_4_5:          .dword 0x953379f5f9d250e4, 0xc7e3ceb75840e7d6
d_4_6:          .dword 0x7a322bc6c58053fb, 0xabbc6cc114644513
d_4_7:          .dword 0xa70b7f3d58503be0, 0x6c187382f632a020
d_4_8:          .dword 0x2cba7fe86a28908e, 0xf0e08c405036667e
d_4_9:          .dword 0x9fe04ba0ec5097ef, 0x11a06610f326a6b1
d_4_10:         .dword 0x58d89676d9436bfe, 0xf036c9ee84b91d53
d_4_11:         .dword 0xe82561e79874160a, 0xa81118ef9437e48e
d_4_12:         .dword 0xa912a6bf2957763f, 0x85eedbcdb06ca911
d_4_13:         .dword 0x0b21b981c7e7b6c0, 0xbc0ad23ad450baf9
d_4_14:         .dword 0xaa6403c6790dfe0d, 0xc297f81defff7ade
d_4_15:         .dword 0xf28b731323e531fb, 0x170b8a3886bdb8a7
d_4_16:         .dword 0xe99291cc299cb8be, 0xdcb770ec52d0e5c4
d_4_17:         .dword 0x9a9c8cdab5851d07, 0xe4845b46fd00d9cd
d_4_18:         .dword 0x73cbaae786b0d2dd, 0xfc5e646b4d6162a5
d_4_19:         .dword 0xd01626f8ca848da6, 0x3fc1bdd565a4fcd0
d_4_20:         .dword 0x1a99870c996338c0, 0x5363e9720bf31fb1
d_4_21:         .dword 0x44e88a476a98a91e, 0x2ae5ad8f30b152f4
d_4_22:         .dword 0xc5ee9ce383257f89, 0xba00b5791cafb7b8
d_4_23:         .dword 0xb4da360a8e7b9894, 0x45c833b60b131df4
d_4_24:         .dword 0x5856cf199494c9fa, 0xb2aaa093699e6351
d_4_25:         .dword 0x6d3cbd0c89def788, 0x8e2998f4c891e167
d_4_26:         .dword 0xb133b16512dccc7e, 0x1058789ca22167f2
d_4_27:         .dword 0x703f0bb1cd6be5cb, 0x06394b343952349f
                .dword 0x6cf25c862517e2ba, 0xc20fb82a291008db
                .dword 0xd8dbcff472fb9a77, 0x3fecf16865de9dee
        /* Random data */
_end_data4:


    .section .data.random5;
    .align  8;

_random_data5:
                .dword 0x4379d0580ce23919, 0x8b621926ae6fc5bf
                .dword 0x2e255d832a229b1c, 0x7443cae1b9074d5b
d_5_0:          .dword 0x4d670a428d102eaa, 0x5250f74abeb6d6a7
d_5_1:          .dword 0x6438a9d15dffb85d, 0xc3125dd43c1591f4
d_5_2:          .dword 0x6b153443d54fef66, 0x688fc1f4062827cf
d_5_3:          .dword 0x80e4f80eb6e29d7b, 0x8f80d3f7e2226df4
d_5_4:          .dword 0xfd2dd63a40bd0808, 0x78d649d450c27d89
d_5_5:          .dword 0x7eddfe6465b81e8a, 0x7d8cd7399abd718c
d_5_6:          .dword 0x05f0cc3fdec6d823, 0xa3cab66604bb1f47
d_5_7:          .dword 0x5c026fd3dbb577d7, 0x75ac2a1aec64e8f8
d_5_8:          .dword 0x120d928a449b36dc, 0x3b3377c411868321
d_5_9:          .dword 0x11743cf86a57abca, 0x674d83c1da272b11
d_5_10:         .dword 0x95a983c16d15327d, 0xa42e3f3c8787cbb2
d_5_11:         .dword 0x9c9146e5df105232, 0x95eadc3577cc975c
d_5_12:         .dword 0xb416a297baec2a31, 0x0aac0058df2d3784
d_5_13:         .dword 0x5fea71698c208294, 0xd90da6202e721fd2
d_5_14:         .dword 0xb94a9f6a8107a003, 0x8465c205fa52919c
d_5_15:         .dword 0x1f85f8e1af0fa78b, 0x3a68a28a7092d1ca
d_5_16:         .dword 0xf83a64e6ef39d584, 0x2162bf2a5822f520
d_5_17:         .dword 0xa30d202b89e34d6b, 0x9e22f20afa6dbbe1
d_5_18:         .dword 0xffc8e9e3f8289823, 0xd8ad0f865addc0ac
d_5_19:         .dword 0x545a6501f4f489ae, 0x56a7ccb5d909bae6
d_5_20:         .dword 0xaed4af07344e9bd2, 0x524605c60633711e
d_5_21:         .dword 0x8997995d851fefd5, 0x7661eddad5ae0b60
d_5_22:         .dword 0x350ea6dfcdc12b54, 0x289071cd5940a3bc
d_5_23:         .dword 0x7619b1686579af15, 0xf5f6059e26c26fd0
d_5_24:         .dword 0x4bb87f963ba49fee, 0x99dd3a87ababcecd
d_5_25:         .dword 0xd6ce501983d8868b, 0xe6b0e238cc65a59f
d_5_26:         .dword 0x3b82b4a88ef4957c, 0xba9df3d911050e1b
d_5_27:         .dword 0x16c62e26ee1d6d26, 0x71117bfd4afb0c6b
                .dword 0x939e984d22c55cf0, 0x3f2b36004cd861ea
                .dword 0xa01f51c4d983cc9f, 0xed099c5aa2955078
         /* Random data */
_end_data5:
              
                 
