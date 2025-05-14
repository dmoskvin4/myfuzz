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
_p0:    csrrsi x12, pmpaddr3, 5                   ;
_p1:    xor x10, x10, x10                         ;
        addi x11, zero, 1                         ;
        slli x11, x11, 9                          ;
        add x10, x10, x11                         ;
        addi x12, zero, 1                         ;
        slli x12, x12, 13                         ;
        add x10, x10, x12                         ;
        csrrw x14, stval, x10                     ;
_p2:    csrrsi x12, scause, 5                     ;
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
_l1:    xori x24, x19, -344                    ;
_l2:    xor x18, x18, x18                    ;
      addi x22, zero, 1         ;
      slli x22, x22, 1         ;
      add x18, x18, x22         ;
      csrrw x29, scause, x18         ;
_l3:    addi x0, x1, 0                    ;
_l4:    addi x0, x1, 0                    ;
_l5:    slli x14, x12, 63                    ;
_l6:    la x26, d_0_21                    ;
      flw f20, 24(x26)         ;
_l7:    fcvt.s.lu f14, x17, rne                    ;
_l8:    la x11, d_4_19                    ;
      ld x22, 8(x11)         ;
_l9:    la x18, d_5_11                    ;
      fsw f12, 28(x18)         ;
_l10:    andi x28, x3, -1854                    ;
_l11:    srliw x5, x30, 0                    ;
_l12:    la x13, d_2_10                    ;
      fsw f26, 20(x13)         ;
_l13:    la x21, d_3_13                    ;
      addi x21, x21, 20         ;
      amoswap.w x15, x6, (x21)         ;
_l14:    la x27, d_4_18                    ;
      lbu x12, 31(x27)         ;
_l15:    la x18, d_0_4                    ;
      addi x18, x18, -24         ;
      amoor.d x18, x7, (x18)         ;
_l16:    la x19, d_0_8                    ;
      addi x19, x19, 4         ;
      amoor.w x15, x25, (x19)         ;
_l17:    la x19, d_1_1                    ;
      sd x19, -8(x19)         ;
_l18:    la x26, d_3_10                    ;
      addi x26, x26, 12         ;
      amomin.w x19, x26, (x26)         ;
_l19:    addi x0, x1, 0                    ;
_l20:    srai x15, x30, 17                    ;
_l21:    la x23, d_2_23                    ;
      addi x23, x23, 20         ;
      amoxor.w x7, x18, (x23)         ;
_l22:    la x7, d_4_3                    ;
      addi x7, x7, -0         ;
      amoswap.d x7, x12, (x7)         ;
_l23:    addi x0, x1, 0                    ;
_l24:    sllw x26, x29, x26                    ;
_l25:    li x29, 0                    ;
      la x4, pt0         ;
      addi x4, x4, 0         ;
      sfence.vma x29, x4         ;
_l26:    la x19, d_1_10                    ;
      addi x19, x19, -0         ;
      amoand.d x2, x1, (x19)         ;
_l27:    la x11, d_1_24                    ;
      lw x5, -4(x11)         ;
_l28:    srlw x4, x29, x14                    ;
_l29:    srli x16, x5, 43                    ;
_l30:    fsub.s f31, f2, f10, rne                    ;
_l31:    auipc x11, 753113                    ;
_l32:    fcvt.lu.s x18, f15, rne                    ;
_l33:    la x6, d_2_10                    ;
      lbu x29, 0(x6)         ;
_l34:    sraw x10, x25, x12                    ;
_l35:    fmul.s f4, f20, f8, rne                    ;
_l36:    fadd.s f10, f20, f8, rne                    ;
_l37:    fcvt.l.s x25, f14, rne                    ;
_l38:    la x23, d_1_10                    ;
      addi x23, x23, -0         ;
      lr.d x11, (x23)         ;
_l39:    la x12, d_3_20                    ;
      addi x12, x12, -16         ;
      amoxor.d x26, x10, (x12)         ;
_l40:    la x5, d_3_16                    ;
      sw x13, 20(x5)         ;
_l41:    la x9, d_3_7                    ;
      fsw f24, 4(x9)         ;
_l42:    la x21, d_5_25                    ;
      addi x21, x21, -16         ;
      lui x22, 0xffe00         ;
      xor x21, x21, x22         ;
      amomin.d x18, x22, (x21)         ;
_l43:    la x27, d_5_18                    ;
      flw f31, 24(x27)         ;
_l44:    slliw x23, x30, 20                    ;
_l45:    fmv.x.w x22, f16                    ;
_l46:    la x26, d_3_17                    ;
      addi x26, x26, -0         ;
      lr.d x29, (x26)         ;
_l47:    la x27, d_0_7                    ;
      addi x27, x27, -20         ;
      amoor.w x17, x30, (x27)         ;
_l48:    fnmsub.s f22, f24, f5, f13, rne                    ;
_l49:    la x19, d_1_1                    ;
      sd x19, -8(x19)         ;
_l50:    la x10, d_1_2                    ;
      addi x10, x10, -8         ;
      sc.d x20, x10, (x10)         ;
_l51:    la x11, d_4_1                    ;
      addi x11, x11, -8         ;
      amoand.w x5, x9, (x11)         ;
_l52:    xori x18, x6, -1921                    ;
_l53:    mret                    ;
_l54:    la x16, d_2_10                    ;
      addi x16, x16, -0         ;
      sc.w x27, x16, (x16)         ;
_l55:    sltiu x4, x13, 1903                    ;
_l56:    feq.s x30, f17, f17                    ;
_l57:    la x12, d_4_1                    ;
      addi x12, x12, -0         ;
      lui x4, 0xffe00         ;
      xor x12, x12, x4         ;
      amoswap.w x11, x4, (x12)         ;
_l58:    la x4, d_1_24                    ;
      sb x2, -15(x4)         ;
_l59:    la x18, d_5_11                    ;
      fsw f12, 28(x18)         ;
_l60:    la x14, d_0_14                    ;
      addi x14, x14, 16         ;
      lr.d x4, (x14)         ;
_l61:    subw x16, x18, x0                    ;
_l62:    la x8, d_4_13                    ;
      addi x8, x8, 8         ;
      lui x17, 0xffe00         ;
      xor x8, x8, x17         ;
      amoand.w x25, x17, (x8)         ;
_l63:    la x28, d_2_18                    ;
      sw x25, -4(x28)         ;
_l64:    la x3, d_3_13                    ;
      sw x5, 20(x3)         ;
_l65:    la x18, d_0_2                    ;
      flw f27, 4(x18)         ;
_l66:    flt.s x3, f2, f31                    ;
_l67:    fnmsub.s f11, f19, f11, f22, rne                    ;
_l68:    fsgnj.s f28, f0, f18                    ;
_l69:    li x24, 1                    ;
      la x9, pt3         ;
      addi x9, x9, 56         ;
      sfence.vma x24, x9         ;
_l70:    addiw x30, x12, -52                    ;
_l71:    fmv.x.w x24, f13                    ;
_l72:    fcvt.lu.s x15, f1, rne                    ;
_l73:    sret                    ;
_l74:    slli x9, x27, 61                    ;
_l75:    la x23, d_1_11                    ;
      addi x23, x23, 24         ;
      amoxor.d x6, x10, (x23)         ;
_l76:    la x14, d_5_0                    ;
      addi x14, x14, 8         ;
      amoadd.d x22, x26, (x14)         ;
_l77:    fcvt.s.l f14, x30, rne                    ;
_l78:    fcvt.s.wu f27, x12, rne                    ;
_l79:    la x21, d_2_10                    ;
      lbu x10, 29(x21)         ;
_l80:    addw x20, x18, x13                    ;
_l81:    srai x11, x9, 63                    ;
_l82:    la x11, d_1_27                    ;
      addi x11, x11, -0         ;
      amomaxu.d x11, x7, (x11)         ;
_l83:    fmul.s f24, f24, f23, rne                    ;
_l84:    la x2, d_0_13                    ;
      addi x2, x2, -0         ;
      amoxor.w x14, x11, (x2)         ;
_l85:    slliw x23, x25, 15                    ;
_l86:    fsub.s f14, f8, f19, rne                    ;
_l87:    la x10, d_2_19                    ;
      flw f9, 0(x10)         ;
_l88:    sraw x28, x22, x17                    ;
_l89:    fcvt.lu.s x27, f21, rne                    ;
_l90:    auipc x2, 865825                    ;
_l91:    andi x3, x15, -1501                    ;
_l92:    la x17, d_4_9                    ;
      addi x17, x17, -0         ;
      lr.d x24, (x17)         ;
_l93:    fnmadd.s f22, f12, f7, f11, rne                    ;
_l94:    fnmsub.s f25, f12, f22, f1, rne                    ;
_l95:    fcvt.lu.s x3, f22, rne                    ;
_l96:    la x5, d_3_10                    ;
      addi x5, x5, 0         ;
      lr.d x24, (x5)         ;
_l97:    ori x19, x30, 418                    ;
_l98:    auipc x6, 1048575                    ;
_l99:    flt.s x16, f23, f2                    ;
_l100:    addi x0, x1, 0                    ;
      addi x10, x10, 16         ;
      lr.d x7, (x10)         ;
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
                .dword 0x067bcad97f172d3d, 0x5feda7d46121862e
                .dword 0x877768902e3ac246, 0x0ab1ee46c10c881b
d_0_0:          .dword 0x3f3fe5260261f4ac, 0x2bd38e1a3a73b438
d_0_1:          .dword 0x3c4764a1c3d3fbbe, 0xf0368af16166b87e
d_0_2:          .dword 0x0e798aa2aaa1dfed, 0x6a64433f428cf6c3
d_0_3:          .dword 0x6276e8671d5e7228, 0x2aba2e3e0b50cce5
d_0_4:          .dword 0xc03986c6de4381aa, 0x56740149c9933b1f
d_0_5:          .dword 0xb689ee7e35610b28, 0x4cd5ff0c48c93286
d_0_6:          .dword 0x001f0d795a6396a5, 0x8c3d389e1c1ce87b
d_0_7:          .dword 0x643fa9bc13c8c625, 0xec69ee93b28a7cd4
d_0_8:          .dword 0x6adf60e7683f8382, 0x6ba4e0a9d3ac4643
d_0_9:          .dword 0xffe5739f70859d23, 0xbdfc324214befb3e
d_0_10:         .dword 0xdf9412c62b053dde, 0xea7d78b4fea6d565
d_0_11:         .dword 0x610100836daee29d, 0x03723c1274f772cf
d_0_12:         .dword 0x7889df1a9b11d2e6, 0x47f031a53451793a
d_0_13:         .dword 0x42250a191542e258, 0x4a939445c22f1933
d_0_14:         .dword 0x4088ae51e60e1ffe, 0xe31080c20294ab48
d_0_15:         .dword 0x344b3612367324be, 0x53676f6b1230a33b
d_0_16:         .dword 0x16848fc23271bf42, 0x94ee005aa5a0c4ab
d_0_17:         .dword 0x7baf4c85bcef833f, 0x13a67b57b516f48e
d_0_18:         .dword 0x6fb0aff8495fb559, 0xc6b937be916a4e8f
d_0_19:         .dword 0x48c0ad8c2a44644d, 0xeef7042268792e7d
d_0_20:         .dword 0x0254717542bd5df5, 0x1fd9b99969765f50
d_0_21:         .dword 0x3e030706f2d61605, 0x3cdf33e71d871a3b
d_0_22:         .dword 0x09b0437501fc741c, 0xa3dd8bf037836155
d_0_23:         .dword 0x8e3282a0ef1b7de7, 0x0fc0f38e4f29b8ad
d_0_24:         .dword 0x84933382c8ae171d, 0x85c1354ddbfb9527
d_0_25:         .dword 0xbbca42640f7b570f, 0x3da499cbee6dab65
d_0_26:         .dword 0xb16ae11714171b87, 0x20ccb0d52af71608
d_0_27:         .dword 0xfc91148b70d37801, 0x3e09d543f0de2fe5
                .dword 0x16b78b1c39dd27c3, 0xd3fd4b8794a345fb
                .dword 0xf932e89eedf38227, 0xe9168dc62a7eae0c
        /* Random data */
_end_data0:
                 

    .section .data.random1;
    .align  8;

_random_data1:
                .dword 0xbc85b02e271ac2dc, 0x527f41bf4200d9ed
                .dword 0xfea1140b842770d4, 0xc690686478699481
d_1_0:          .dword 0x7be304e10018d126, 0x962e77d80afe5241
d_1_1:          .dword 0x8536407a6307eb0d, 0xbe76e13a61f65954
d_1_2:          .dword 0xf1eb7d9ceea622f7, 0xc888245b3880cb63
d_1_3:          .dword 0x4e861315e0ce5e4f, 0xe5cbc8d0e38e36e2
d_1_4:          .dword 0xeb062be875c9861a, 0x04fe4ec3e37e0e62
d_1_5:          .dword 0x6ffd235a05226dbd, 0x67102bdd6cfc4e79
d_1_6:          .dword 0x1e40f504f5a72117, 0xb08cdce6fdd7baf1
d_1_7:          .dword 0xbeb719bfef4ca113, 0x8a2ff728ac2461cc
d_1_8:          .dword 0x31b281b3933deb9e, 0x0880aa9c6c7b14ea
d_1_9:          .dword 0xb18ee060bd6d2651, 0xd247b83174315bc1
d_1_10:         .dword 0xb5f6ec16b02af4d1, 0x5b3b2c7f6cd8a404
d_1_11:         .dword 0xa1f1c811a4e73c5b, 0x30c41e972c8f6210
d_1_12:         .dword 0xe98ba0fcf3f7a986, 0x3711b82fd0c4e0f0
d_1_13:         .dword 0x91f655010728b75b, 0x662b521db49fd504
d_1_14:         .dword 0x5d3ddee204f3606f, 0x44c59a43284bd82d
d_1_15:         .dword 0x7ebb1ca943e57629, 0x657f70fbc5afc610
d_1_16:         .dword 0x1e95d273d4a3eed1, 0x8e2fb21f44791db4
d_1_17:         .dword 0x33c917d2202a33a3, 0x592ef3081ae4f063
d_1_18:         .dword 0x50016c5351e34235, 0xb04c958d476656ec
d_1_19:         .dword 0xfd3567b98296a94a, 0x0f2499e92344f8d6
d_1_20:         .dword 0xf55e9622951ff209, 0x62830c868efa374f
d_1_21:         .dword 0x2590c8a091bc8e6b, 0x3aed524b63aa1321
d_1_22:         .dword 0x5e7236a00393f3e8, 0x3f5f4e86d9171010
d_1_23:         .dword 0xfe44d3590f9bfe67, 0x5a8cc0f0e1d3c6c7
d_1_24:         .dword 0x54f354b58b3bdc49, 0x76bd4587e44e18a3
d_1_25:         .dword 0x40dbd3d89758481c, 0x25be1e66ac4e9a27
d_1_26:         .dword 0x7dc869c2da315872, 0xb9ea8b083d55a8ec
d_1_27:         .dword 0x22888c478270b36a, 0xf746d60b34eae1ba
                .dword 0x5504f340357d4340, 0xa1d587589dbf97b2
                .dword 0xaf98f847d135902b, 0xf251d888d6b79345
        /* Random data */
_end_data1:


    .section .data.random2;
    .align  8;

_random_data2:
                .dword 0x8703e5beb579ca73, 0x8284b784278bf362
                .dword 0x4e42ed99f0299314, 0xe2c6f5878d4befa0
d_2_0:          .dword 0x3215c67447ad3cf1, 0xeaeeb0e98fc607bd
d_2_1:          .dword 0x7549d2a4a9177444, 0x8e620c0c91129c27
d_2_2:          .dword 0xbf2d3c7c2dd3d5d6, 0x8cb734a528c20d10
d_2_3:          .dword 0x47d86247918646f8, 0xf2f5cb3bfcce0b83
d_2_4:          .dword 0x4ec460a71b81e47b, 0x106e8dee45991211
d_2_5:          .dword 0x3477c224508d0a22, 0xcfbc9cb051fd5d00
d_2_6:          .dword 0x0a73d6f3c74891a8, 0xd5743a7ba4e9b6fe
d_2_7:          .dword 0x3ef6928caed84827, 0xb6c7a78d0d3f1b4b
d_2_8:          .dword 0xcac9a80f2d3c197b, 0xe9d016b5e96adf5b
d_2_9:          .dword 0x8ffbd83ebe8b4d93, 0xd291711c734b9e35
d_2_10:         .dword 0xc095d456c08dbf0e, 0x3a96ffd6544b795a
d_2_11:         .dword 0x26b1330cf9dcc839, 0xa47d814f72fc53fd
d_2_12:         .dword 0xeb236860cae32f41, 0xf28f5e43dcf1749a
d_2_13:         .dword 0x94c5e79b902ac97b, 0x7626a84d132bcfd7
d_2_14:         .dword 0xbc6e7e18f627ea80, 0x4d42c89b58aee543
d_2_15:         .dword 0xcc490158e55f68e3, 0xe55cbe754b14e6b8
d_2_16:         .dword 0x4eae3edb56b8a692, 0x248e91e09be14eff
d_2_17:         .dword 0x0bba99ddf9b707b5, 0x28d1f7ad9eccc394
d_2_18:         .dword 0xca0b143d4b99756b, 0x0d7f071d8b6cdb6d
d_2_19:         .dword 0xabf41b50fe38652e, 0x92f5064588473554
d_2_20:         .dword 0x249b333510a9a200, 0x383b8e4c2bf4b9b1
d_2_21:         .dword 0xba0ba0b9bfd56dc4, 0x835f61b7687855d0
d_2_22:         .dword 0xea182c5aab025719, 0x613d7db3fa1730e9
d_2_23:         .dword 0x09755ac0decba12e, 0x4ecfb542732f17f5
d_2_24:         .dword 0x5798d7f0a5cdf42a, 0x363f274c0e9d9277
d_2_25:         .dword 0xdbbde162385ae7e5, 0x6a4ab6e395ba6e1c
d_2_26:         .dword 0x63cc6331059930f4, 0xfb56f274bfc0e351
d_2_27:         .dword 0x71c68b33218f1e9a, 0xb15f605d0e9727b2
                .dword 0x92068b8b46a78d40, 0x3ae36773ec3ad087
                .dword 0x3e44bf745cee20ca, 0x59750cae882bb6ae
         /* Random data */
_end_data2:
                

    .section .data.random3;
    .align  8;

_random_data3:
                .dword 0x3251a0623d394e61, 0x30159ca70882d3b9
                .dword 0x1f5c2aa57b37c942, 0x92838365a9810b9e
d_3_0:          .dword 0x65134575526aed8f, 0x293e265129088da5
d_3_1:          .dword 0x707ac3ca078042ce, 0xa20c21abd3954904
d_3_2:          .dword 0x8ba48ae7ad9a27a1, 0x569b04bcc1416d06
d_3_3:          .dword 0xff987cd7b796100e, 0xb9ec8412266e9392
d_3_4:          .dword 0x311ccc13dc5ea0ce, 0xf86b40a241763e94
d_3_5:          .dword 0xac4ce8c55dca25b5, 0xeacae8997c655bf0
d_3_6:          .dword 0x6a21396d09b254fe, 0x1bb74036cb4310a9
d_3_7:          .dword 0x02d17a6ea7f1329c, 0x1b37663ee6b39b6b
d_3_8:          .dword 0xb654f1ed09edc7e3, 0x8e9e9273d378d4b1
d_3_9:          .dword 0xf4c466448a2e96dc, 0x02a5394e5a05a3cd
d_3_10:         .dword 0x5b86c45aa1a62dff, 0xe2e839ec92e7a048
d_3_11:         .dword 0x19cb72de8b19a5b4, 0x7dd0d7ea516aa5be
d_3_12:         .dword 0x0f814d61fc62f51b, 0x90b55f82d0e8e3c1
d_3_13:         .dword 0xa949b9d5d850189d, 0xa9456fb88b90b391
d_3_14:         .dword 0xd73e0d74be34c6b0, 0xd0b7b22d55096ecc
d_3_15:         .dword 0xf51390e393cee520, 0xd09d478f57c4b65f
d_3_16:         .dword 0x624325836183b76e, 0xfb0ee7f0b908a5f6
d_3_17:         .dword 0x10da9350e0f80129, 0xe80bb532fa06dfd8
d_3_18:         .dword 0x1afe1fb62dc3360b, 0x17350fdc2fab99b2
d_3_19:         .dword 0xbf247dbae7d79b94, 0x4067ca5b81333863
d_3_20:         .dword 0x849a40fc7a9a0302, 0x6cc2c5e8a7a801a5
d_3_21:         .dword 0x507920b53062bc5e, 0xc756ea2da515cd3f
d_3_22:         .dword 0xc0f852f574833b31, 0xf66a440779a01552
d_3_23:         .dword 0x1f2e60f4f051abfb, 0x3031466d04533740
d_3_24:         .dword 0x30c8328c1c577acb, 0x5229bf3f92f19668
d_3_25:         .dword 0x3fd0a623423c95d9, 0xcefa3914e91a6404
d_3_26:         .dword 0xe8e4b254daed5446, 0xe4ee452904c9bbc0
d_3_27:         .dword 0xc4dd5b7d2174e671, 0x2d9263c49b33f10a
                .dword 0xc7f8b7e4b9b37672, 0x95d27250e1cbd985
                .dword 0xbf204d9d6bf5b25f, 0x840812e514d06c2c
        /* Random data */
_end_data3:


    .section .data.random4;
    .align  8;

_random_data4:
                .dword 0x00a0ef129ade2275, 0xd5f211e01b10f1a0
                .dword 0xb271d239d39542d9, 0xc429a18b8b4488ce
d_4_0:          .dword 0x7854ee76c24f7064, 0xbc03b43b7f631325
d_4_1:          .dword 0x6f3e5f48bd1386bc, 0xf865854d8056a66b
d_4_2:          .dword 0x1d058e789c0fe6be, 0x1b3d50d0a4a9c7c5
d_4_3:          .dword 0x1a6f42ecf63e4e29, 0xcb17fb96e6030fb9
d_4_4:          .dword 0x57f6708abdaab8fb, 0xd5946717367a2517
d_4_5:          .dword 0x7bbc29f84c50d9d3, 0x33ccceba384253fc
d_4_6:          .dword 0xcb081c9e6f9dec12, 0x427959e5f2532f78
d_4_7:          .dword 0x89e1e2450f4e56f3, 0x18a536cc6d731c02
d_4_8:          .dword 0x60ad36f5c10dc297, 0x257515292c05186b
d_4_9:          .dword 0x7e088285376eefa7, 0x7f2c8713e5ac55b4
d_4_10:         .dword 0x95660da3dd827aef, 0xccdddb9d3a0194e8
d_4_11:         .dword 0xf007c809e84c0dc4, 0xb17b49fbbdfecf98
d_4_12:         .dword 0x7d59d0390a2d160f, 0x718f52b08ff37146
d_4_13:         .dword 0x1f47bfe037227c51, 0xb00d5349006138f4
d_4_14:         .dword 0x35bf3ce1bc2db8be, 0x096736a2b9219e6f
d_4_15:         .dword 0x26942ed965130d6e, 0x2d708ac4dba8fa25
d_4_16:         .dword 0xbf753d43ad6831c3, 0xfd32d5e15f94e1cb
d_4_17:         .dword 0x8e93c771e2dc9ae9, 0x0e92feb75b1a820c
d_4_18:         .dword 0x6a325e767f59a71b, 0xedc441fc99974074
d_4_19:         .dword 0xeaed8a801953746f, 0xe94ac98951ae0c17
d_4_20:         .dword 0x948b21e71a167e9c, 0x089ba7f29c61c148
d_4_21:         .dword 0x841c0fa72c62c596, 0x574ad9148b96ef06
d_4_22:         .dword 0x529304700d7b1187, 0x3f13f8d9630190fd
d_4_23:         .dword 0xca8d9ac3d88295eb, 0xe1edcebf360438fe
d_4_24:         .dword 0x20929f6b537cd14b, 0x70d203c30fd27d0b
d_4_25:         .dword 0xd66680b76c813a93, 0x09bb2e39484519c4
d_4_26:         .dword 0x285aefa2d48a6e12, 0xedb19a57cca9d742
d_4_27:         .dword 0x085fb2f16c2913a8, 0xb80f675fcfdaa011
                .dword 0xd5ed16395f799f27, 0x91be7a8a1dab4c16
                .dword 0x906a867d5817df1a, 0x035158521ff7f8b1
        /* Random data */
_end_data4:


    .section .data.random5;
    .align  8;

_random_data5:
                .dword 0x5048a8e6616318b7, 0x32f62c3d9b89c6f4
                .dword 0xd6fe15fcf6f7e2a8, 0xe7e9ddcefde20ed4
d_5_0:          .dword 0xf4c1ae8c9f123d13, 0xa39192a6c3c73840
d_5_1:          .dword 0x91da1ea14c266ac0, 0xdc3fc5877948a415
d_5_2:          .dword 0x3d1352f0689b4a53, 0xa52d848830a4bfd3
d_5_3:          .dword 0x1e77e682aa5097c5, 0x01236efa427d319e
d_5_4:          .dword 0x261bad18344a5314, 0x30f20e22b480975b
d_5_5:          .dword 0xed1acfbe679c7d68, 0xcdedc0e60f363688
d_5_6:          .dword 0xb395f4e3f93b534e, 0x2b01b738590fb3ce
d_5_7:          .dword 0x808758f53e1bfb5a, 0x44a5f8669cc259a7
d_5_8:          .dword 0xc128dace2c80c944, 0xbf3051e7962f29d3
d_5_9:          .dword 0x1bacd9454f8d2006, 0xbcc5ee38216f36d9
d_5_10:         .dword 0xa790589ca5a43f8e, 0xea3278639188bc8b
d_5_11:         .dword 0x43ef29f245a2050b, 0x0225ee2ad7c2f87f
d_5_12:         .dword 0xbc4c7f2d26ba02cf, 0x5b74a8cc05402226
d_5_13:         .dword 0xf35004c7c1a5a5d8, 0xd3509472a6f74209
d_5_14:         .dword 0x3032a2428e16535c, 0xa4e4f88157fcc720
d_5_15:         .dword 0x1ddf13ea74c8a692, 0x05529a2fb867271d
d_5_16:         .dword 0x20050771da2813ba, 0x33979f9c94fe4fdf
d_5_17:         .dword 0x4b9fad63f05bb5b3, 0xe5b95901466950b1
d_5_18:         .dword 0x8cebca64bb4056c5, 0xc45502f0904fea04
d_5_19:         .dword 0x6bcb277ded309731, 0xe8fb6eaf118da091
d_5_20:         .dword 0x1abdf172ae2b1102, 0x401d66d59b40d33d
d_5_21:         .dword 0x0edf6c6281cba963, 0x29401569ce46d8eb
d_5_22:         .dword 0xc4887c936a97dccb, 0xa726ef187d72a0e3
d_5_23:         .dword 0xbba41186ad4204cd, 0x9504136ad0b1b607
d_5_24:         .dword 0xfa2a14254a071d1d, 0x8a74ac8a66153009
d_5_25:         .dword 0x4d10b0db6beecf82, 0xbe887763fbe91fd0
d_5_26:         .dword 0x7116db46ffe260d8, 0x5d89702216707842
d_5_27:         .dword 0xc8edc1459a7bdedd, 0x6f7a22daaa1bed91
                .dword 0x3d30d0fe1178cd6b, 0xa52ba3360e8eadc7
                .dword 0x453bd06c2f90e031, 0x562273c61321bbb9
         /* Random data */
_end_data5:
              
                 
