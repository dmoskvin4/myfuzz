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
_s0:    fmv.w.x f12, x6                           ;
_s1:    la x5, d_3_13                             ;
        lhu x30, 6(x5)                            ;
_s2:    la x20, d_1_12                            ;
        lh x21, -0(x20)                           ;
_s3:    la x24, d_0_21                            ;
        addi x24, x24, 24                         ;
        lui x15, 0xffe00                          ;
        xor x24, x24, x15                         ;
        sc.w x18, x15, (x24)                      ;
_s4:    srlw x3, x27, x18                         ;
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
_p0:    csrrsi x12, scause, 5                     ;
_p1:    csrrwi x14, pmpcfg0, 31                   ;
_p2:    la x12, _p1                               ;
        srai x12, x12, 1                          ;
        csrrc x14, pmpaddr7, x12                  ;
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
_l2:    fsgnjx.s f22, f31, f23                    ;
_l3:    addi x0, x1, 0                    ;
_l4:    addi x21, x12, 8                    ;
_l5:    fadd.s f7, f30, f2, rne                    ;
_l6:    fsgnjn.s f11, f10, f17                    ;
_l7:    auipc x2, 919504                    ;
_l8:    la x17, d_5_6                    ;
      addi x17, x17, -20         ;
      amomax.w x19, x14, (x17)         ;
_l9:    ori x19, x30, 418                    ;
_l10:    csrrci x8, sstatus, 5                    ;
_l11:    flt.s x3, f2, f31                    ;
_l12:    csrrwi x1, pmpaddr1, 0                    ;
_l13:    mret                    ;
_l14:    la x26, d_5_14                    ;
      addi x26, x26, 12         ;
      amomax.w x30, x8, (x26)         ;
_l15:    fcvt.lu.s x15, f1, rne                    ;
_l16:    fcvt.lu.s x3, f30, rne                    ;
_l17:    xor x18, x18, x18                    ;
      addi x22, zero, 1         ;
      slli x22, x22, 1         ;
      add x18, x18, x22         ;
      csrrw x29, scause, x18         ;
_l18:    la x19, d_3_18                    ;
      addi x19, x19, -16         ;
      amoswap.d x21, x13, (x19)         ;
_l19:    la x25, d_1_1                    ;
      addi x25, x25, 0         ;
      amomax.d x11, x12, (x25)         ;
_l20:    slliw x21, x30, 6                    ;
_l21:    la x19, d_5_5                    ;
      lui x14, 0xffe00         ;
      xor x19, x19, x14         ;
      fsw f22, -12(x19)         ;
_l22:    la x21, d_5_25                    ;
      addi x21, x21, -16         ;
      lui x22, 0xffe00         ;
      xor x21, x21, x22         ;
      amomin.d x18, x22, (x21)         ;
_l23:    ori x0, x6, 594                    ;
_l24:    sret                    ;
_l25:    srli x28, x2, 52                    ;
_l26:    andi x14, x25, 0                    ;
_l27:    fmul.s f5, f31, f23, rne                    ;
_l28:    fnmadd.s f17, f16, f7, f23, rne                    ;
_l29:    xor x4, x4, x4                    ;
      addi x29, zero, 3         ;
      slli x29, x29, 23         ;
      add x4, x4, x29         ;
      csrrc x14, fcsr, x4         ;
_l30:    fcvt.l.s x23, f8, rne                    ;
_l31:    fcvt.s.l f7, x17, rne                    ;
_l32:    andi x25, x1, -299                    ;
_l33:    fmul.s f24, f24, f23, rne                    ;
_l34:    la x22, d_5_7                    ;
      addi x22, x22, 24         ;
      amoadd.d x13, x2, (x22)         ;
_l35:    xor x16, x16, x16                    ;
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
_l36:    sret                    ;
_l37:    xor x16, x16, x16                    ;
      addi x29, zero, 3         ;
      slli x29, x29, 8         ;
      add x16, x16, x29         ;
      addi x4, zero, 3         ;
      slli x4, x4, 18         ;
      add x16, x16, x4         ;
      csrrs x4, fcsr, x16         ;
_l38:    la x27, d_5_18                    ;
      flw f31, 24(x27)         ;
_l39:    la x20, d_1_7                    ;
      lui x8, 0xffe00         ;
      xor x20, x20, x8         ;
      sb x17, 14(x20)         ;
_l40:    fmsub.s f17, f2, f14, f21, rne                    ;
_l41:    la x26, d_5_4                    ;
      addi x26, x26, 0         ;
      amoor.d x28, x17, (x26)         ;
_l42:    sret                    ;
_l43:    la x3, d_5_14                    ;
      sb x7, 15(x3)         ;
_l44:    xor x2, x2, x2                    ;
      csrrc x12, stval, x2         ;
_l45:    slti x23, x3, 0                    ;
_l46:    la x18, d_5_11                    ;
      fsw f12, 28(x18)         ;
_l47:    fmax.s f3, f26, f11                    ;
_l48:    la x10, d_5_12                    ;
      addi x10, x10, -24         ;
      amomin.d x11, x11, (x10)         ;
_l49:    la x9, d_2_12                    ;
      sb x8, -0(x9)         ;
_l50:    auipc x10, 1048575                    ;
_l51:    la x4, d_1_3                    ;
      addi x4, x4, -0         ;
      amominu.w x23, x24, (x4)         ;
_l52:    la x10, d_1_2                    ;
      lbu x1, 4(x10)         ;
_l53:    fmadd.s f4, f30, f18, f25, rne                    ;
_l54:    la x8, d_4_12                    ;
      addi x8, x8, 16         ;
      lui x30, 0xffe00         ;
      xor x8, x8, x30         ;
      lr.d x4, (x8)         ;
_l55:    la x7, d_1_8                    ;
      addi x7, x7, 24         ;
      amoand.d x24, x14, (x7)         ;
_l56:    srli x3, x17, 35                    ;
_l57:    la x26, d_1_9                    ;
      addi x26, x26, -16         ;
      amoadd.w x18, x18, (x26)         ;
_l58:    la x24, d_4_21                    ;
      addi x24, x24, 8         ;
      amoand.d x10, x19, (x24)         ;
_l59:    la x24, d_0_16                    ;
      ld x10, -0(x24)         ;
_l60:    sraw x11, x0, x20                    ;
_l61:    csrrci x30, pmpaddr3, 28                    ;
_l62:    sraiw x14, x13, 31                    ;
_l63:    la x30, d_3_7                    ;
      addi x30, x30, 24         ;
      amoor.d x5, x29, (x30)         ;
_l64:    xor x12, x12, x12                    ;
      csrrc x28, frm, x12         ;
_l65:    la x1, d_0_26                    ;
      addi x1, x1, 0         ;
      lui x14, 0xffe00         ;
      xor x1, x1, x14         ;
      amomin.d x21, x14, (x1)         ;
_l66:    fmax.s f23, f16, f31                    ;
_l67:    la x14, d_1_17                    ;
      lh x15, 0(x14)         ;
_l68:    la x16, d_3_11                    ;
      addi x16, x16, -24         ;
      lui x11, 0xffe00         ;
      xor x16, x16, x11         ;
      amoor.d x19, x11, (x16)         ;
_l69:    la x21, d_1_17                    ;
      addi x21, x21, 12         ;
      amominu.w x14, x3, (x21)         ;
_l70:    slli x12, x17, 48                    ;
_l71:    ori x3, x21, -2047                    ;
_l72:    fmax.s f7, f26, f12                    ;
_l73:    subw x24, x27, x28                    ;
_l74:    uret                    ;
_l75:    ori x17, x7, 0                    ;
_l76:    fcvt.s.l f14, x30, rne                    ;
_l77:    slti x15, x17, 388                    ;
_l78:    fsqrt.s f24, f13, rne                    ;
_l79:    sraiw x3, x16, 31                    ;
_l80:    csrrwi x11, sscratch, 7                    ;
_l81:    ori x19, x30, 418                    ;
_l82:    la x18, d_2_17                    ;
      addi x18, x18, -0         ;
      amoxor.w x5, x16, (x18)         ;
_l83:    fcvt.w.s x17, f8, rne                    ;
_l84:    srliw x19, x6, 24                    ;
_l85:    la x24, d_1_8                    ;
      srai x24, x24, 1         ;
      csrrw x28, pmpaddr3, x24         ;
_l86:    fcvt.s.w f13, x7, rne                    ;
_l87:    subw x28, x17, x27                    ;
_l88:    xor x13, x13, x13                    ;
      csrrs x9, frm, x13         ;
_l89:    la x8, _l35                    ;
      lhu x11, 14(x8)         ;
_l90:    la x26, d_5_14                    ;
      addi x26, x26, 12         ;
      amomax.w x30, x8, (x26)         ;
_l91:    csrrsi x1, frm, 12                    ;
_l92:    slli x26, x10, 44                    ;
_l93:    fle.s x3, f17, f26                    ;
_l94:    fcvt.s.lu f19, x26, rne                    ;
_l95:    la x16, d_1_8                    ;
      sb x26, -31(x16)         ;
_l96:    la x19, d_0_8                    ;
      addi x19, x19, 4         ;
      amoor.w x15, x25, (x19)         ;
_l97:    ori x9, x8, -0                    ;
_l98:    fnmadd.s f19, f4, f13, f4, rne                    ;
_l99:    fdiv.s f17, f0, f20, rne                    ;
_l100:    la x10, d_2_19                    ;
      flw f9, 0(x10)         ;
      addi x26, x26, 0         ;
      amomin.d x2, x19, (x26)         ;
      addi x19, x19, -0         ;
      amomin.d x12, x12, (x19)         ;
      addi x5, x5, 4         ;
      amoor.w x23, x8, (x5)         ;
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
                .dword 0x1e8d5e95e633a2cc, 0x0fd733aa18357b39
                .dword 0x45d106a403a8613a, 0x9d8aacdcdaf9ee1a
d_0_0:          .dword 0x6a4b5c291d443690, 0xf136fa086f1d565a
d_0_1:          .dword 0xd587917dfd28a5ae, 0x148de0a55629e990
d_0_2:          .dword 0xadd697866f9ed9ab, 0x459da6c79259f1a9
d_0_3:          .dword 0x0c2659f52ce9bfd7, 0xc35e676b50750e12
d_0_4:          .dword 0x8fb15fe7f4e6f757, 0x6a731277c118f217
d_0_5:          .dword 0x5e42e385b187fd47, 0x581a62dd2c833c9e
d_0_6:          .dword 0x432da79314642d46, 0x56534873c1dd2910
d_0_7:          .dword 0x37cfe873ca99afea, 0x8fcc5492da396c81
d_0_8:          .dword 0x36914cba6ef0c924, 0x6d62d3def9e67c06
d_0_9:          .dword 0xbf62bc16339e03cd, 0x15db0cdeb80ae7fd
d_0_10:         .dword 0xa7a9ec0271e13fe6, 0x5b6e872a89bf2c5a
d_0_11:         .dword 0x7db10dfbeb9e4862, 0x977039cf9fd2343a
d_0_12:         .dword 0xdd8f0d34442ba6c0, 0x03f2cd21194d0d0d
d_0_13:         .dword 0x676ca7063f97fc22, 0x702684de1372c91d
d_0_14:         .dword 0x36aa7045db215a49, 0xe3365a6f25db88ca
d_0_15:         .dword 0x4ef33890bdbb988f, 0xaf2a96800dc739e8
d_0_16:         .dword 0xb80ab7bbfab00262, 0xa254f618cedc6d70
d_0_17:         .dword 0xcfb20b0e041ee16a, 0xb2b918d487016f39
d_0_18:         .dword 0xad2309ab4d4fc135, 0x3b9cc911a1d5fd72
d_0_19:         .dword 0x6fcfd70ce89d3cd3, 0x383a4c18ca027d0e
d_0_20:         .dword 0x274f1ee667ebafed, 0xa975c1065fc094a9
d_0_21:         .dword 0xb227039dcb6a854a, 0xd618d1ce28172f54
d_0_22:         .dword 0x26fddc1b5eb0a71d, 0x43270a479d42865f
d_0_23:         .dword 0x4f8720cbc21dcd12, 0xebf8748f377117e9
d_0_24:         .dword 0x608cad5a5585ef91, 0xfce804d8e88fd1ee
d_0_25:         .dword 0xe5e6ef128401817b, 0x547f451617c30b53
d_0_26:         .dword 0x1781f96c9a9304d9, 0x361f0b0f2cd0c2aa
d_0_27:         .dword 0x0be3fff8dbd980a0, 0xc059f6f6b7272b64
                .dword 0x6f09c665e77a047b, 0x3acb9b993a7037ac
                .dword 0x6af0fe9055f4bd87, 0xc12a3fbccc871644
        /* Random data */
_end_data0:
                 

    .section .data.random1;
    .align  8;

_random_data1:
                .dword 0x0ee5b2ceec0447ed, 0x4d3c306a96778010
                .dword 0xc5e4e26e37a653c8, 0x70c70a5d8f0093a1
d_1_0:          .dword 0x738e5a8c01916be1, 0x4be97d56135f129d
d_1_1:          .dword 0x8cc085665b1588dc, 0x55cce0895eb4d45c
d_1_2:          .dword 0x1ee25d9285a45086, 0x1fa95802ed998dd1
d_1_3:          .dword 0x977dd16020d7cbaf, 0x93728e141610f2c2
d_1_4:          .dword 0x8e0e137be8c8d10d, 0xa040194819591502
d_1_5:          .dword 0x287db3a1ed9ccc60, 0x4a1fb06f3d8e229d
d_1_6:          .dword 0x8451ea83ac48f384, 0x1d3975bac23513bd
d_1_7:          .dword 0x127dd8918b597e10, 0x06ca97fc7c61ff59
d_1_8:          .dword 0xe3d7c4dc1801b95f, 0xea6ba6252a31d9f1
d_1_9:          .dword 0xd406aef78cceb9e0, 0x8631f9ef24e03709
d_1_10:         .dword 0xd45bd4e35bf04784, 0xa51f43a3b9c760d2
d_1_11:         .dword 0x59e9ca4cc802a66e, 0xfbfb08cfa0003aca
d_1_12:         .dword 0x4edfbf9d8d501298, 0x3f83181908ab2936
d_1_13:         .dword 0xa32f42d666f6394c, 0xa5dd5126b7169a02
d_1_14:         .dword 0xf7475992059b32df, 0x61dbea0f8e4be81b
d_1_15:         .dword 0x7d016089eb1393c5, 0xa920cbd9d478ccdf
d_1_16:         .dword 0x40500a7dc66e9e80, 0x592e73aa182c9f38
d_1_17:         .dword 0x31a7546fec935f95, 0xfe26246cf7e1abff
d_1_18:         .dword 0xa3c1bd8b2aaf0380, 0x78420426643a4581
d_1_19:         .dword 0xac5b2881108efdaa, 0xd820b2de1bd7c4db
d_1_20:         .dword 0x60f9eccc91a3510a, 0x10c74cdea7f1927f
d_1_21:         .dword 0x5ba46c17cc18002f, 0xfc8a078de63e4df1
d_1_22:         .dword 0x6297812a6eb23f7d, 0x4b3d253abf2604fd
d_1_23:         .dword 0xf8f33d82e1830ddf, 0x632ba949f4c8cce9
d_1_24:         .dword 0x908f3baa110e177a, 0x1a3e6e43ac7c9592
d_1_25:         .dword 0x5df054015672c187, 0xa983e8a03c50f413
d_1_26:         .dword 0xbdf0dbb846ebd4e9, 0x88f365160bced708
d_1_27:         .dword 0x2519137412b257cc, 0x1547cc128b61a65b
                .dword 0xae055dc244a3fd19, 0xa9fbd2ca05670488
                .dword 0x30fbfa38b105275b, 0xec761d69b84dbdb3
        /* Random data */
_end_data1:


    .section .data.random2;
    .align  8;

_random_data2:
                .dword 0x12683e25a02c687f, 0xd927b023287a6992
                .dword 0x8bc4199c5185ea1e, 0x1028f9d8b5f9779d
d_2_0:          .dword 0xebacf4b3ad659597, 0xc3157b60fd0b0512
d_2_1:          .dword 0x79f77e8f8ea33293, 0x7308aff66c5b4d2d
d_2_2:          .dword 0xde01ab95ecbca093, 0xfd68929332f8ea20
d_2_3:          .dword 0x2f5ae1715df2ffb4, 0xdf80b156d2f68117
d_2_4:          .dword 0x0ae899631fc48ee4, 0x128188b72e720d3a
d_2_5:          .dword 0x075ebd7f7e278b4a, 0xac1fc95223f07968
d_2_6:          .dword 0x0d2705b19dce4046, 0x53569f47e26a9606
d_2_7:          .dword 0x8abcff7800366a08, 0x8ffced7b6cbfd420
d_2_8:          .dword 0x1b51790f7942ad8c, 0xa3f89ff90538f40b
d_2_9:          .dword 0x85e6f02e36ed2c9c, 0xe54496a9b906e543
d_2_10:         .dword 0x893eeb9081141184, 0xe61e713e4b4cc2cd
d_2_11:         .dword 0x52f32fa1308cce71, 0x9db6f632431a73c3
d_2_12:         .dword 0x5aa1083fe2ee2885, 0xd69a62085ca1a53d
d_2_13:         .dword 0xca9a46322b3f707e, 0x7b715defc18a9fe5
d_2_14:         .dword 0x5e5aca728c57ae61, 0x42fb84412dc1c895
d_2_15:         .dword 0xf9f4ee2b704dd362, 0xba501ccfb6bdd4fc
d_2_16:         .dword 0x58779d419d521c47, 0x0d19a205ae59ea43
d_2_17:         .dword 0x7ffe3a5a297ba139, 0x2364526b9516a583
d_2_18:         .dword 0x76e34295748e8397, 0x691836d4586dcc9f
d_2_19:         .dword 0x0e168c7ce2cb056a, 0xd494ec59b7d06986
d_2_20:         .dword 0xbbab85f8701377d1, 0x5d0503de85cd83e7
d_2_21:         .dword 0x491b46967c690663, 0xd235a4e0cc711e49
d_2_22:         .dword 0x00ce18e3e95d03a8, 0xe15efba08965065e
d_2_23:         .dword 0xfa07958dd113bcb8, 0x10bac841245e2fc9
d_2_24:         .dword 0x11b490361a70d374, 0xd343cff432f1a5f5
d_2_25:         .dword 0x28c5a137d07cf61e, 0x62665d9af8c8b31b
d_2_26:         .dword 0x40c1458ed544b643, 0x35188ec76fabdaa4
d_2_27:         .dword 0xd06973665019971a, 0x7e935ecc2cd1da38
                .dword 0xbaf51ce17d0872b8, 0x53e623143145e09a
                .dword 0x41512d51821095c5, 0x20120494bed67461
         /* Random data */
_end_data2:
                

    .section .data.random3;
    .align  8;

_random_data3:
                .dword 0x5cfdc7137347d14a, 0x534ddb02dba15ee3
                .dword 0x04c251be6cc96a66, 0x91fb209b27c366b9
d_3_0:          .dword 0x1f73e96b0f0875aa, 0xca8e9ef20e3c8343
d_3_1:          .dword 0x151fb2571884d8d8, 0x7114529dd3c56cb9
d_3_2:          .dword 0x0aadce6a08abb90d, 0x49932c7efbb21ef1
d_3_3:          .dword 0xd1f58aeecaff6736, 0x6b8809f855b19928
d_3_4:          .dword 0xa366ecaa3fb5e8eb, 0x50f240409eaec84d
d_3_5:          .dword 0xaac0cc490ae7bb90, 0x64c2720aa296a626
d_3_6:          .dword 0x2909ebf8838698f5, 0xd07430f0d28158c6
d_3_7:          .dword 0x2880bdf7a844fbf2, 0xc04b19252849ba0c
d_3_8:          .dword 0x489aa7ae145f9b28, 0x683e49329a9efe86
d_3_9:          .dword 0x995d15d53258b6d8, 0x6bb60c38e6ba1799
d_3_10:         .dword 0xe2854f67535d6a91, 0x4f81e146337b3103
d_3_11:         .dword 0xa643f3567b5d0866, 0x910ef981def8a2de
d_3_12:         .dword 0xc235e6f254587e00, 0xedf972e3d934e930
d_3_13:         .dword 0xc179387b5cb9552d, 0x54645e9a2bbbbc5d
d_3_14:         .dword 0x221488f2f0d25826, 0x8c15eaa3909c0907
d_3_15:         .dword 0x1cf5353285d10eeb, 0xb25b51fb678f20cf
d_3_16:         .dword 0x387c538c28eb4dc8, 0x2168eebbfee2351e
d_3_17:         .dword 0x09e68f5aae0e1fb9, 0x7eda32912f2e5186
d_3_18:         .dword 0x5a5b45832e623e29, 0xeea9027e3215e804
d_3_19:         .dword 0xc8b6ce7924b3e7a6, 0xb18408ffdfd2c0e5
d_3_20:         .dword 0x2ab9195549903c5c, 0x2a74649d618197e1
d_3_21:         .dword 0xcbf20e6968238145, 0xc4c46f6996e7bee1
d_3_22:         .dword 0x151d74d56d086e8e, 0x33b4a45ab0ed1d03
d_3_23:         .dword 0xad65543f019aecf6, 0x00a9dc225cff7c2f
d_3_24:         .dword 0x5726d7e24cca117b, 0x30e1dc1738a1f700
d_3_25:         .dword 0xd23de6b26b312a57, 0x4699afd01c5a5b72
d_3_26:         .dword 0xa30deb0b4c4e7f0d, 0x09e97895705f27f4
d_3_27:         .dword 0x90a07a451268f962, 0x8c1891354b005f45
                .dword 0xa4da93096497f6e8, 0x65d0ccf37c45e597
                .dword 0x87fa7080afb67592, 0x3ed35f2c8095a998
        /* Random data */
_end_data3:


    .section .data.random4;
    .align  8;

_random_data4:
                .dword 0xda56ad5d77f0116b, 0x022e36f69f12914b
                .dword 0xc283f9ac2f40c14e, 0x1f0451e66d0433d4
d_4_0:          .dword 0x2bf7f1fb4b69b07b, 0x90851c035475224d
d_4_1:          .dword 0x04e9234558ffc637, 0x52f0d96abe0cb047
d_4_2:          .dword 0x90d63c3edbd2096f, 0x483e1425ec8ba59e
d_4_3:          .dword 0xe7d6488793283b24, 0x9db4b8955a498b72
d_4_4:          .dword 0x5c414be2a4d00374, 0x84b9f8d56cc5e121
d_4_5:          .dword 0x3d96f33f1b4c7167, 0x1b3646335f11058d
d_4_6:          .dword 0x55ccf6671f787db9, 0x63879c8491b66a7e
d_4_7:          .dword 0x53ea0079c9495d75, 0xc675a9ca1ae6b68f
d_4_8:          .dword 0x508c1fedd5826ba7, 0xd9150d3173194614
d_4_9:          .dword 0xf2039840e47cd2ca, 0x086c05522a205270
d_4_10:         .dword 0xd6973d557a98690a, 0xb960bbfed7344374
d_4_11:         .dword 0xb41e7f4f62fbe22d, 0xe48270e793397724
d_4_12:         .dword 0x5a76b39f455c97dc, 0x7b94dce0c0c24e20
d_4_13:         .dword 0x0983c4c26053b5ca, 0x997a0fb9358eb7c9
d_4_14:         .dword 0xcebb926fa8a2798f, 0xad195740cc69e248
d_4_15:         .dword 0x49d4522a3700ec18, 0x2556e27b310000fd
d_4_16:         .dword 0x6a9c361811ec74a5, 0x3749ba908c38425d
d_4_17:         .dword 0x1e00a0cde3df6ce2, 0xa5e252c50bf206bd
d_4_18:         .dword 0xc4226fdce7784e4e, 0x1920180abe62a719
d_4_19:         .dword 0xe5a058b702a6ea92, 0x4a8598a0990d3110
d_4_20:         .dword 0x028ffdcd13194161, 0x1979691ee4f34805
d_4_21:         .dword 0x5baba7fdcdff8b3b, 0xb4f1ad92389e75df
d_4_22:         .dword 0x47d88f46f94038d6, 0x3ce57820809c9283
d_4_23:         .dword 0x03074c82869bf9a0, 0x9667cc618389a24d
d_4_24:         .dword 0xca3196e801ea0d19, 0xc3ae6e7750479e6f
d_4_25:         .dword 0x21c23fecc8d736e0, 0xd785a46a69dcf779
d_4_26:         .dword 0xbb5b98b8382d0352, 0xb5a99ae5180e1ae5
d_4_27:         .dword 0xb8f806af2410e45c, 0x3b2840322f6e24a4
                .dword 0x92f29194de7d8d75, 0x5ce5391fc26b6b78
                .dword 0x5c8fea7b09f94746, 0xcf7d1f21041a221e
        /* Random data */
_end_data4:


    .section .data.random5;
    .align  8;

_random_data5:
                .dword 0xa905b6dd086bc70e, 0x78e559093eda57e9
                .dword 0xd3aa969cfc1aad40, 0x13cdb5dc9242756c
d_5_0:          .dword 0x6223b87ac6a5c12f, 0xe407f2c96399e8c9
d_5_1:          .dword 0x1907040f3a5410bb, 0x0aaed4976fb0d113
d_5_2:          .dword 0x3a2251ec49a3c995, 0x4ca34989c04f6644
d_5_3:          .dword 0x97a3d390a720d968, 0xbff388af51ef70cf
d_5_4:          .dword 0xca0e8f3c00e1760e, 0x0df78788c7ab5ae3
d_5_5:          .dword 0xaf687c989ec16568, 0xe42a7ed16456f29a
d_5_6:          .dword 0x6fbfae81c2383a31, 0x510b68349dfad310
d_5_7:          .dword 0xc4991825e27bdb0c, 0x8c501cb6e7aa8197
d_5_8:          .dword 0x9dcde719e857b4a4, 0x89ecc331d6897220
d_5_9:          .dword 0x2cf3b4886adcecc9, 0xf3f084d21aad6412
d_5_10:         .dword 0xc839b80ff6f8ed7a, 0xe3117403fb09d547
d_5_11:         .dword 0xfc8ee4e5654b9310, 0x7411f5240f7e2bf0
d_5_12:         .dword 0x7e9aca098ac88215, 0x7bbc3c5ce9a1f9f8
d_5_13:         .dword 0x6a209067e10fb982, 0xe28609096673e0a4
d_5_14:         .dword 0xd597e4b7be4add51, 0x9b95e2c72747d884
d_5_15:         .dword 0xabcacec282a983f4, 0xd2c5ca612692a36c
d_5_16:         .dword 0xad4e74e92196fa68, 0x9238b529cb800229
d_5_17:         .dword 0x97381418a86ca53f, 0xfe1f9afb77a69813
d_5_18:         .dword 0xa5e36fd8b0b4f385, 0xd992ad939e289365
d_5_19:         .dword 0x8229b2549dbb0aeb, 0x31b38b3e8e953bad
d_5_20:         .dword 0x111e4d5f3a594936, 0x1898bc2f38d18a43
d_5_21:         .dword 0x5d07e258a3986b70, 0x80887678640ef75c
d_5_22:         .dword 0x0d69251624a605e6, 0xa1dd725d4d03f5ef
d_5_23:         .dword 0xa69fad7febb9fa05, 0x8f832a20c6b22e18
d_5_24:         .dword 0x306bf272fc9fb028, 0x370be37fd197b195
d_5_25:         .dword 0x7c8d3d162b3a4647, 0x5c925d94a8a020b7
d_5_26:         .dword 0xc427ed26d25e0898, 0x174a39e31f57b656
d_5_27:         .dword 0xf80f935c0f6da09d, 0xd0b930ec7c0ce8ba
                .dword 0xdb83a23cd1ee6636, 0xa79756e299f5a81b
                .dword 0x2cce35572bec8ff6, 0x88808a869bf04968
         /* Random data */
_end_data5:
              
                 
