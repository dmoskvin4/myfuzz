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
_p0:    la x13, _p3                               ;
        srai x13, x13, 1                          ;
        csrrc x10, pmpaddr3, x13                  ;
_p1:    csrrci x14, sie, 7                        ;
_p2:    csrrsi x10, satp, 24                      ;
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
_l0:    fcvt.s.w f4, x10, rne                    ;
_l1:    fmadd.s f4, f10, f21, f30, rne                    ;
_l2:    addi x0, x1, 0                    ;
_l3:    fadd.s f13, f19, f13, rne                    ;
_l4:    la x15, d_1_11                    ;
      fsw f1, -12(x15)         ;
_l5:    fcvt.w.s x11, f31, rne                    ;
_l6:    fadd.s f14, f29, f20, rne                    ;
_l7:    la x15, d_1_24                    ;
      addi x15, x15, 16         ;
      amominu.w x11, x25, (x15)         ;
_l8:    srli x27, x19, 7                    ;
_l9:    xor x24, x24, x24                    ;
      addi x14, zero, 3         ;
      slli x14, x14, 20         ;
      add x24, x24, x14         ;
      addi x12, zero, 1         ;
      slli x12, x12, 3         ;
      add x24, x24, x12         ;
      addi x22, zero, 1         ;
      slli x22, x22, 0         ;
      add x24, x24, x22         ;
      csrrw x25, sie, x24         ;
_l10:    xori x17, x27, 156                    ;
_l11:    srli x17, x28, 63                    ;
_l12:    csrrsi x21, pmpaddr5, 4                    ;
_l13:    ori x6, x30, -4                    ;
_l14:    fclass.s x17, f9                    ;
_l15:    la x22, d_0_7                    ;
      lh x11, 22(x22)         ;
_l16:    la x20, d_0_4                    ;
      sb x15, 15(x20)         ;
_l17:    fmv.w.x f26, x21                    ;
_l18:    fcvt.s.wu f0, x21, rne                    ;
_l19:    uret                    ;
_l20:    la x12, d_0_23                    ;
      lw x28, 28(x12)         ;
_l21:    mret                    ;
_l22:    la x10, d_0_23                    ;
      addi x10, x10, -20         ;
      amomin.w x17, x22, (x10)         ;
_l23:    fsgnj.s f25, f16, f28                    ;
_l24:    slliw x29, x3, 0                    ;
_l25:    fsgnjn.s f26, f27, f1                    ;
_l26:    subw x29, x15, x12                    ;
_l27:    fsqrt.s f1, f20, rne                    ;
_l28:    la x27, d_3_11                    ;
      srai x27, x27, 1         ;
      csrrc x9, pmpaddr2, x27         ;
_l29:    la x4, d_2_21                    ;
      addi x4, x4, -28         ;
      amoor.w x24, x25, (x4)         ;
_l30:    sltiu x22, x22, -2047                    ;
_l31:    sllw x2, x24, x7                    ;
_l32:    la x25, d_0_19                    ;
      addi x25, x25, -16         ;
      sc.w x6, x20, (x25)         ;
_l33:    la x9, d_4_13                    ;
      addi x9, x9, 24         ;
      sc.w x14, x18, (x9)         ;
_l34:    addiw x25, x11, 436                    ;
_l35:    fmadd.s f25, f8, f18, f21, rne                    ;
_l36:    fcvt.s.w f4, x10, rne                    ;
_l37:    fmv.x.w x5, f26                    ;
_l38:    feq.s x3, f9, f0                    ;
_l39:    la x1, d_4_22                    ;
      addi x1, x1, 20         ;
      amomin.w x21, x1, (x1)         ;
_l40:    la x4, d_1_7                    ;
      addi x4, x4, -8         ;
      sc.d x17, x4, (x4)         ;
_l41:    fsub.s f1, f26, f5, rne                    ;
_l42:    fnmadd.s f26, f16, f21, f23, rne                    ;
_l43:    fadd.s f11, f2, f16, rne                    ;
_l44:    la x16, d_3_25                    ;
      addi x16, x16, 0         ;
      amoxor.d x23, x15, (x16)         ;
_l45:    la x19, d_5_27                    ;
      addi x19, x19, 8         ;
      amominu.w x19, x27, (x19)         ;
_l46:    la x27, d_2_15                    ;
      addi x27, x27, 16         ;
      lr.d x1, (x27)         ;
_l47:    la x20, d_4_3                    ;
      addi x20, x20, -4         ;
      amomax.w x9, x8, (x20)         ;
_l48:    csrrci x5, fcsr, 16                    ;
_l49:    ori x18, x5, -12                    ;
_l50:    andi x20, x20, 2047                    ;
_l51:    srlw x18, x30, x25                    ;
_l52:    sltiu x5, x5, 0                    ;
_l53:    srliw x22, x4, 31                    ;
_l54:    la x5, d_0_18                    ;
      addi x5, x5, 16         ;
      amoor.d x12, x9, (x5)         ;
_l55:    la x11, d_4_7                    ;
      addi x11, x11, 24         ;
      amoadd.d x8, x24, (x11)         ;
_l56:    fcvt.s.wu f16, x27, rne                    ;
_l57:    fcvt.s.w f11, x9, rne                    ;
_l58:    la x3, d_0_23                    ;
      addi x3, x3, 24         ;
      sc.w x29, x23, (x3)         ;
_l59:    fnmadd.s f6, f1, f12, f8, rne                    ;
_l60:    fcvt.l.s x15, f11, rne                    ;
_l61:    la x6, d_0_0                    ;
      addi x6, x6, 16         ;
      amomin.d x12, x21, (x6)         ;
_l62:    fcvt.s.w f7, x13, rne                    ;
_l63:    fmax.s f23, f21, f16                    ;
_l64:    csrrci x12, frm, 31                    ;
_l65:    la x21, d_0_5                    ;
      sh x29, 12(x21)         ;
_l66:    fcvt.s.wu f31, x6, rne                    ;
_l67:    addiw x17, x11, 1838                    ;
_l68:    la x30, d_1_0                    ;
      fsw f18, -24(x30)         ;
_l69:    fmv.w.x f27, x19                    ;
_l70:    fmin.s f31, f26, f7                    ;
_l71:    lui x12, 13                    ;
_l72:    fcvt.l.s x27, f29, rne                    ;
_l73:    fcvt.w.s x23, f30, rne                    ;
_l74:    csrrwi x4, frm, 3                    ;
_l75:    fcvt.s.l f18, x11, rne                    ;
_l76:    auipc x11, 0                    ;
_l77:    fsgnjn.s f21, f18, f17                    ;
_l78:    la x29, d_5_5                    ;
      addi x29, x29, 24         ;
      amomax.d x29, x4, (x29)         ;
_l79:    addi x26, x27, -25                    ;
_l80:    la x4, d_4_21                    ;
      sw x13, 28(x4)         ;
_l81:    la x30, d_0_24                    ;
      addi x30, x30, 4         ;
      sc.w x5, x15, (x30)         ;
_l82:    fnmadd.s f1, f25, f17, f3, rne                    ;
_l83:    la x6, d_0_14                    ;
      lbu x23, -11(x6)         ;
_l84:    la x10, d_5_22                    ;
      addi x10, x10, -8         ;
      amomaxu.d x9, x14, (x10)         ;
_l85:    la x28, d_5_14                    ;
      lui x14, 0xffe00         ;
      xor x28, x28, x14         ;
      lb x26, -4(x28)         ;
_l86:    fnmsub.s f2, f8, f6, f5, rne                    ;
_l87:    fcvt.l.s x8, f29, rne                    ;
_l88:    fcvt.lu.s x29, f1, rne                    ;
_l89:    la x4, d_2_10                    ;
      sd x18, -8(x4)         ;
_l90:    flt.s x9, f26, f24                    ;
_l91:    slliw x21, x10, 31                    ;
_l92:    la x26, d_3_22                    ;
      addi x26, x26, -0         ;
      amoxor.d x7, x2, (x26)         ;
_l93:    sret                    ;
_l94:    la x7, d_3_12                    ;
      addi x7, x7, 16         ;
      lui x3, 0xffe00         ;
      xor x7, x7, x3         ;
      amomax.d x13, x3, (x7)         ;
_l95:    addw x20, x18, x13                    ;
_l96:    fmv.w.x f0, x20                    ;
_l97:    fcvt.wu.s x0, f23, rne                    ;
_l98:    mret                    ;
_l99:    la x8, d_0_1                    ;
      addi x8, x8, -0         ;
      lr.w x28, (x8)         ;
_l100:    sltiu x25, x2, -640                    ;
      addi x5, x5, -4         ;
      amoadd.w x15, x24, (x5)         ;
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
                .dword 0xb1cffa76bb379964, 0xd549f7ad657b01e3
                .dword 0xa29798ef518fcc48, 0x114f77ad57c2a60c
d_0_0:          .dword 0xf80e4f9348bbabd7, 0xa5fd9b28f095e532
d_0_1:          .dword 0x06ff3ebd587aed10, 0x770f1f28ab34231d
d_0_2:          .dword 0x41971c6140b142c0, 0xb0b4d171e9d55442
d_0_3:          .dword 0x2251f4fd386ab350, 0x4447b39b6e02b0d7
d_0_4:          .dword 0x0f7e7bbff6594ae8, 0x7cf4ac87c7debf38
d_0_5:          .dword 0xafb36b97e6e125c6, 0x9d1d1dd62f565892
d_0_6:          .dword 0x67f063fe16fca802, 0x5d499805775c8519
d_0_7:          .dword 0x85f63ced63801ece, 0x4cc770a2626b8ae5
d_0_8:          .dword 0x42a983768f257673, 0x22dbada6fd75d96e
d_0_9:          .dword 0x03bd48e577dee5db, 0x98f2701bbd5b9d0a
d_0_10:         .dword 0xe03d16f1cde63c96, 0x3c583d11f27e8fe4
d_0_11:         .dword 0xbb4098625e10ffa6, 0x5bf7426c798eb2b5
d_0_12:         .dword 0xa293b8b4041ddff6, 0x12a6879380e68598
d_0_13:         .dword 0xe279ead74bd8c9d6, 0x45103c1187807b85
d_0_14:         .dword 0xb05abe798e9ce030, 0xe870d9f4507dbc65
d_0_15:         .dword 0x403b54633d2b3be6, 0x0a836677d5b290d7
d_0_16:         .dword 0xd31c2d9ff5a8f212, 0x2d07e993df0b7cbd
d_0_17:         .dword 0x54836427467c7f25, 0xc1fcc198eae28edb
d_0_18:         .dword 0xcb43ad30854dfcf5, 0x514c428f8f30bd7f
d_0_19:         .dword 0x808e62b56d6112d4, 0x3076c6e6eef78086
d_0_20:         .dword 0x3a35f4fe15c7d05d, 0xbb967fdb51b0f7a0
d_0_21:         .dword 0xd68f1df85e686e6b, 0xfaf85b9283c8c5cd
d_0_22:         .dword 0xa3200613e64eaa03, 0x68db17cafa587878
d_0_23:         .dword 0xe3969827ed99df03, 0x7b460bc28c07349a
d_0_24:         .dword 0x1faebfe05c7df542, 0xef2e8cf5c065852d
d_0_25:         .dword 0xabca200832a32756, 0x4c07639bf0e36a5a
d_0_26:         .dword 0xefb02715f9775900, 0x97c7613cf1b0fb6f
d_0_27:         .dword 0xcfe71b0371e0d2ed, 0x14eac9473965a38e
                .dword 0xa5cb9499a066e52b, 0x819c119ff04cf815
                .dword 0x7b6efeac0a16b6b1, 0xaf685b0d61ce5217
        /* Random data */
_end_data0:
                 

    .section .data.random1;
    .align  8;

_random_data1:
                .dword 0x4e925aad0b322473, 0x7bb7d89706fdc49f
                .dword 0x8116810a71b97a66, 0xe9566cfe4c92de57
d_1_0:          .dword 0x8ba2ab292398b5fa, 0x82492b5798a9b81d
d_1_1:          .dword 0xf4b018a600ef5e4b, 0x2aebf2cd5da40809
d_1_2:          .dword 0x729a85d6886f838c, 0x7931e31929fed605
d_1_3:          .dword 0xe2af52b46929d242, 0x255f6f8d5942c021
d_1_4:          .dword 0x3a6d44ffcabe02a4, 0x0fdd077a5b957b27
d_1_5:          .dword 0xfa591a6a1e7c4531, 0xb313d870c687e82e
d_1_6:          .dword 0x35aea8ca6e04c4bd, 0xa37f63db9ddacd1b
d_1_7:          .dword 0x195c9a05115c0cfb, 0xfb76eb0787e3c0e3
d_1_8:          .dword 0xb3744c4ea5b64462, 0xd7b64b9bb8978f83
d_1_9:          .dword 0x324a375a3b18f6cf, 0x6c06d6210b89c0d5
d_1_10:         .dword 0x728c98adf9c8bc75, 0x17b4a350548b48a9
d_1_11:         .dword 0x93625d314d9cee08, 0xd1194c33105f7f54
d_1_12:         .dword 0xc28ff1d30488a103, 0x03436c14343ab252
d_1_13:         .dword 0x91ae08cadc508f1c, 0x3621e3f3f7397eff
d_1_14:         .dword 0x83ad6cb299179a13, 0x020223b561b6d6f0
d_1_15:         .dword 0x371792322a4bf88d, 0xffe2496ccdce1a57
d_1_16:         .dword 0x9c7d4ec8e254fca7, 0x2f3f243fa83cce4c
d_1_17:         .dword 0x43884dffe5bdbd5f, 0x935998cbd27e0d75
d_1_18:         .dword 0xdf258f5baf30af66, 0x702b1b7b7dd07844
d_1_19:         .dword 0xf00ba4d73a2e3c88, 0x332673faf2afdbeb
d_1_20:         .dword 0x1c29f7c59c3be48e, 0xd6a2ec10d175411a
d_1_21:         .dword 0xa5d2691de13a1f1d, 0xb35b53b668fdfb7f
d_1_22:         .dword 0xa372f0772c5e2e66, 0x1b2720808c4406d2
d_1_23:         .dword 0x739de257648b1bf3, 0x365c342e755bc523
d_1_24:         .dword 0xa388f0b74d2ed0d9, 0xa50e502590848ceb
d_1_25:         .dword 0x2f45b57c85c10400, 0xb8c1dea941eceb86
d_1_26:         .dword 0x73e39778daf29460, 0x7762e9648f76f902
d_1_27:         .dword 0xb35d429146524f0a, 0x0e69ceeb07093a2a
                .dword 0xd0c57cad402b86c7, 0x35ad2024c6ad9968
                .dword 0x22b7e264f551b520, 0xdcd747f97d812d57
        /* Random data */
_end_data1:


    .section .data.random2;
    .align  8;

_random_data2:
                .dword 0x1af3af4bfd7bb0d6, 0xc950d4654b06ffa1
                .dword 0x5f323353965ac83f, 0xb04b5c1f277dd849
d_2_0:          .dword 0xfa0760e40209b75a, 0x3c18a0c1af2ea424
d_2_1:          .dword 0x0698e5ae19162837, 0x919c108cb0a01695
d_2_2:          .dword 0x6702ea8b34115f83, 0x22fa16ed530ae3ae
d_2_3:          .dword 0xc83797dcdea5253f, 0x58fc17c88623d45b
d_2_4:          .dword 0xf20411b418367e71, 0x7208bd34fc63788c
d_2_5:          .dword 0x2e737b78c231c20c, 0xded10f7437130341
d_2_6:          .dword 0xba46ca01f708eb28, 0xb3e7cd051b955181
d_2_7:          .dword 0x12ea695d79c87d94, 0x2e6a14c5a310e3a5
d_2_8:          .dword 0xf830814049c3ab0d, 0xb6244fa717c97511
d_2_9:          .dword 0xf07620d555fe04e0, 0x4ae9dba7035f9ce3
d_2_10:         .dword 0x480ddf537b971623, 0x20a5b3144b0882d8
d_2_11:         .dword 0x0a74fa634c5fcf03, 0x02c46039fb15a430
d_2_12:         .dword 0x2f20103877d52390, 0xd6f397858bbf7c6c
d_2_13:         .dword 0x12cca32469d08d93, 0xd32872651867bed7
d_2_14:         .dword 0xaf7f0d235213d043, 0x54834295e2132a64
d_2_15:         .dword 0x938e810c4f46b77d, 0xf3ddc563d627e631
d_2_16:         .dword 0xee7f6f0ac34e67f6, 0x382e3194155ba59a
d_2_17:         .dword 0x02eef202011aeda9, 0xa710131755c0c10b
d_2_18:         .dword 0x1bf70703d417ab0a, 0xd59e962114452552
d_2_19:         .dword 0xb5155ffc60e4630e, 0x5f294959c3f270e8
d_2_20:         .dword 0x98e276249c7c4358, 0x79265160d7075b36
d_2_21:         .dword 0xa50c3dbd23d26713, 0x31d7c02e8cb7949e
d_2_22:         .dword 0x4095145fd601f965, 0xa7140f0c09350782
d_2_23:         .dword 0x6302fd85b7919656, 0x787533837431f0d2
d_2_24:         .dword 0x1aa4787962b65ecc, 0xf4178c56cb9ee597
d_2_25:         .dword 0xd7cfb0deef938204, 0xbb7a728d90f0b779
d_2_26:         .dword 0xeadfe1b9ad64289f, 0x72aa1f11f05a3f31
d_2_27:         .dword 0xd1436b3f794adc91, 0x15e5011a911b1ad0
                .dword 0x65a6e63516237acc, 0x0b4a2903c1ed3ffa
                .dword 0xc325f31e21c6e192, 0x0aea2bc93c66ff0b
         /* Random data */
_end_data2:
                

    .section .data.random3;
    .align  8;

_random_data3:
                .dword 0x35e76f6f55827709, 0x3c7d4d66ef220570
                .dword 0xce8750f07f4a5dcd, 0x9c90f7653b329d92
d_3_0:          .dword 0x12c8b41d94a53da6, 0x93a785a944613f29
d_3_1:          .dword 0x0ec6653c7be8edcd, 0xb4b54850c106d133
d_3_2:          .dword 0x84a4536bded9e025, 0x001bb7fbfd41452d
d_3_3:          .dword 0x9efe32a81dbbab32, 0x274872f49104eb45
d_3_4:          .dword 0xc7868759a1bb898e, 0x6b0aca6f685dc963
d_3_5:          .dword 0x35f7b1549259f4ac, 0x9740e4fa71e669fc
d_3_6:          .dword 0xad63f334427df8eb, 0x5e8eb1ada43eb8ef
d_3_7:          .dword 0x030e84039cdcff3c, 0xb891f04b3da494c1
d_3_8:          .dword 0x03581327b27b9438, 0x2b1d810da58e6150
d_3_9:          .dword 0xa1ab4035bb874ef3, 0x72ba19040f1f6601
d_3_10:         .dword 0xf74bc4c7050697e5, 0xd59f1a9406e2b289
d_3_11:         .dword 0xfea8bae068e4b45e, 0x4e2cbc0a253cf23c
d_3_12:         .dword 0x0b1869b5cfc1b4fa, 0xaee4ca285f853af0
d_3_13:         .dword 0x8e2a2d11fd1a1667, 0xebe4e4e2e67aec27
d_3_14:         .dword 0x03af68d85716a9ab, 0x107aae7ec7b8e4db
d_3_15:         .dword 0xc4a17e696c217940, 0x8ed7d9f5fe40c4e1
d_3_16:         .dword 0x05aed8d03a828026, 0x9f7046661eeeb52c
d_3_17:         .dword 0x5df65058e5680667, 0xd82026b9f93ad5d1
d_3_18:         .dword 0x7a1b8bbadbddffe7, 0xa03e87b9a5ba72ce
d_3_19:         .dword 0x3a04316062aa8d16, 0xf6f3b619e6d37978
d_3_20:         .dword 0xb7ab0fe73d31cdf9, 0xacce5effac0f5beb
d_3_21:         .dword 0x4ce4a25bac36478e, 0x47adff7827b019e3
d_3_22:         .dword 0x477d1a619ebc130a, 0xdaeea1bb3213eecb
d_3_23:         .dword 0x588a44ce08f52a73, 0x5819f7266e6c3588
d_3_24:         .dword 0x0f6b53b411b90df6, 0xe6608098b9d5719a
d_3_25:         .dword 0xcd2004b09b0ab69e, 0x5773cfe971851e6e
d_3_26:         .dword 0x49ce5561f5f37aaa, 0xc65c1b68827c7dcc
d_3_27:         .dword 0x8dc3d6454d71c046, 0x06b58cd692813335
                .dword 0x4bc738cc9795f31c, 0x37cb0e6d0130f176
                .dword 0x457c5d62a673a2e0, 0x318f1972cc2b7f5f
        /* Random data */
_end_data3:


    .section .data.random4;
    .align  8;

_random_data4:
                .dword 0x20787387c97e6372, 0x8b1e1ce81f70f284
                .dword 0x933a8ce441c525e5, 0x8d76751d46076c2d
d_4_0:          .dword 0xc4a50e92dfa8b663, 0x455b0ddde68ae7db
d_4_1:          .dword 0x787bc710ca475dd3, 0x96a9d7e739d5985a
d_4_2:          .dword 0xa5df77e184ad093f, 0x199e9a3346b913db
d_4_3:          .dword 0x14d35dfa949ee8fe, 0x9b53fda6eb427874
d_4_4:          .dword 0x65dd2d31b7b8a931, 0x4db9af2e36e7bb86
d_4_5:          .dword 0x7842798510a473ec, 0xd7c80b568e5f88ab
d_4_6:          .dword 0x2d03fdcadc985080, 0xcc30cb3beaa23456
d_4_7:          .dword 0xa246f1d4659e55ca, 0x0b5fe8e6e0803386
d_4_8:          .dword 0x99362ec38a0b8824, 0xefe4f594abd6deca
d_4_9:          .dword 0x5c70f9359d70b8e8, 0x1b7af5adc1020ee0
d_4_10:         .dword 0x3f7f2dfde1819fa9, 0xee4c55bf09c88ac1
d_4_11:         .dword 0xe25d6c5d1b633040, 0x36e35458cf88a6f5
d_4_12:         .dword 0x16c79f25fb0c5898, 0xc8082398e14fc673
d_4_13:         .dword 0xb24829321f81f4de, 0x155b84260caf5717
d_4_14:         .dword 0xb80e3641111b4501, 0x77f60dae3c048795
d_4_15:         .dword 0x4818010749df9d4c, 0xd1211d9a216ca171
d_4_16:         .dword 0xf675d493c0b78b31, 0x393666f9e4dab557
d_4_17:         .dword 0x70556b31dcf04113, 0x6e05d66c14f7ebc6
d_4_18:         .dword 0x16cab365ed758185, 0xd1acc2452d471ae3
d_4_19:         .dword 0xe9bb718738fb1047, 0xc1893d93011002fd
d_4_20:         .dword 0x6be53c66d62d6fa3, 0xdc8e78951822c4cb
d_4_21:         .dword 0x94a86c284d7cfa83, 0x6a3b5e82443d1696
d_4_22:         .dword 0x791f5b317ca8068b, 0x7cbb473ded0c997d
d_4_23:         .dword 0xc5a4d911f38b699c, 0xbe2cffca1107810b
d_4_24:         .dword 0x068959511576d03d, 0x8640942e36b46088
d_4_25:         .dword 0xda1fd2f759beb36e, 0x2884dd7b1a9549d8
d_4_26:         .dword 0x0f41a70687e3acb6, 0x5c1966b194051afb
d_4_27:         .dword 0x1483afb27ed70e54, 0x9b885b93de9d5a73
                .dword 0x59b24354a89d0d9d, 0x62cf51e1f50305de
                .dword 0x5785f3846048dc59, 0x67c6e6c6447702b6
        /* Random data */
_end_data4:


    .section .data.random5;
    .align  8;

_random_data5:
                .dword 0x236d5f8c6d7d0427, 0x1873f9f67286df53
                .dword 0x7a35b1b65e5dd407, 0x7715885b69967e50
d_5_0:          .dword 0xa899432a4c022f16, 0x6e6213a04208eab7
d_5_1:          .dword 0x140fddaea1c154ed, 0xbc4dc8ec1125d300
d_5_2:          .dword 0xb6e95fe2aa09e217, 0xd6b8f0741c94b7e0
d_5_3:          .dword 0x35019c2f01c4af3e, 0xae6b3b53ae57eb84
d_5_4:          .dword 0xc0fe94f461372221, 0x65c4e1590d217a5c
d_5_5:          .dword 0x01d888bf96b1c412, 0x199e5d7f34bc68ef
d_5_6:          .dword 0xdd39de2594c4796d, 0x4ad378e1e2a34a3f
d_5_7:          .dword 0xff0b555d636ea78c, 0xf4cab1e1c0dfad1a
d_5_8:          .dword 0x0920ae03b27a4731, 0x4711dc9ace4da28a
d_5_9:          .dword 0x3ffc9bea995f84c1, 0x2bc403e19c7ad348
d_5_10:         .dword 0x616fdfbd62665ef6, 0x56cf135b92e8189f
d_5_11:         .dword 0x7e73c1c2cbd6b010, 0xb9ca74ee3f2db5f8
d_5_12:         .dword 0x6e5e92e1ee7ea83f, 0x946eef0602a68df3
d_5_13:         .dword 0xbabd5c37cc71151c, 0xdc9a67e6a339b089
d_5_14:         .dword 0x71917edabf7c3101, 0x3aa2b648e88c6a30
d_5_15:         .dword 0xde7f2e8b0847456b, 0x1b811df24cc6d8f4
d_5_16:         .dword 0xef6221b9028ecd1d, 0x61abf3133bca2bed
d_5_17:         .dword 0x6bbd3ae165f90429, 0xdec38cbecf1d4e53
d_5_18:         .dword 0xc3703ce1363930e1, 0x8468bd524c2aecf0
d_5_19:         .dword 0x63fcb56678f15796, 0x8de45b9de7bf324e
d_5_20:         .dword 0x82ab4cb99c8e292c, 0x94e74e4f2f90c51b
d_5_21:         .dword 0xe1b0937748cf399e, 0xe836528302276718
d_5_22:         .dword 0x16165ed5a27efa5b, 0x7adf20d2908d5219
d_5_23:         .dword 0x3a8f2dd11afe4331, 0xf5915968bb383de8
d_5_24:         .dword 0xd025d099d657e478, 0x143819d8ec3f6a13
d_5_25:         .dword 0x324903ca3c9925d1, 0xb11c0d03b356ca2d
d_5_26:         .dword 0xe0d443845edfd3ca, 0x149c9dfb663200d7
d_5_27:         .dword 0xc90e858589612073, 0xd016d7c432a51ed0
                .dword 0xaacad2faef04f79c, 0xeb9a14c328a217bf
                .dword 0xe55d46ffa71b0e44, 0x24f3cdd2fe5947c2
         /* Random data */
_end_data5:
              
                 
