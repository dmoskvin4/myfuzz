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
_s0:    la x15, d_2_10                            ;
        lui x30, 0xffe00                          ;
        xor x15, x15, x30                         ;
        sb x18, 0(x15)                            ;
_s1:    la x9, d_0_26                             ;
        lhu x15, 24(x9)                           ;
_s2:    srai x1, x21, 55                          ;
_s3:    sllw x5, x16, x8                          ;
_s4:    la x2, d_3_11                             ;
        ld x8, -24(x2)                            ;
_s5:;
        /* Fuzz suffix */
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
  1:    li a0, (MSTATUS_FS & (MSTATUS_FS >> 0));
        csrs mstatus, a0;
        init_mie;
        csrwi fcsr, 0;
        call init_freg
        csrw minstret,zero
        csrr a0, mhartid;
_fuzz_prefix:
_p0:    csrrwi x10, fcsr, 10                      ;
_p1:    la x14, d_0_21                            ;
        srai x14, x14, 1                          ;
        csrrs x13, pmpaddr3, x14                  ;
_p2:    la x13, _p1                               ;
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
_l0:    xor x14, x14, x14                         ;
        addi x23, zero, 3                         ;
        slli x23, x23, 6                          ;
        add x14, x14, x23                         ;
        addi x14, zero, 1                         ;
        slli x14, x14, 14                         ;
        add x14, x14, x14                         ;
        addi x27, zero, 3                         ;
        slli x27, x27, 10                         ;
        add x14, x14, x27                         ;
        csrrs x22, fflags, x14                    ;
_l1:    sllw x23, x28, x14                        ;
_l2:    fcvt.s.w f7, x26, rne                     ;
_l3:    la x6, d_1_7                              ;
        addi x6, x6, -16                          ;
        lui x28, 0xffe00                          ;
        xor x6, x6, x28                           ;
        amoor.d x6, x28, (x6)                     ;
_l4:    sret                                      ;
_l5:    slliw x10, x13, 1                         ;
_l6:    la x7, d_5_7                              ;
        addi x7, x7, -24                          ;
        sc.d x16, x7, (x7)                        ;
_l7:    la x27, d_4_20                            ;
        addi x27, x27, 0                          ;
        amoor.w x18, x18, (x27)                   ;
_l8:    fcvt.s.lu f11, x29, rne                   ;
_l9:    xor x9, x9, x9                            ;
        addi x2, zero, 3                          ;
        slli x2, x2, 4                            ;
        add x9, x9, x2                            ;
        csrrc x7, sepc, x9                        ;
_l10:   fcvt.s.lu f26, x15, rne                   ;
_l11:   srlw x28, x6, x5                          ;
_l12:   fmax.s f7, f19, f3                        ;
_l13:   fcvt.s.lu f8, x0, rne                     ;
_l14:   xor x30, x30, x30                         ;
        addi x27, zero, 3                         ;
        slli x27, x27, 25                         ;
        add x30, x30, x27                         ;
        addi x22, zero, 1                         ;
        slli x22, x22, 4                          ;
        add x30, x30, x22                         ;
        csrrs x30, satp, x30                      ;
_l15:   auipc x30, 778149                         ;
_l16:   auipc x26, 0                              ;
_l17:   la x14, d_5_0                             ;
        addi x14, x14, -0                         ;
        amoswap.d x30, x9, (x14)                  ;
_l18:   fsgnjn.s f10, f11, f15                    ;
_l19:   fcvt.s.lu f11, x0, rne                    ;
_l20:   la x5, d_4_0                              ;
        lui x19, 0xffe00                          ;
        xor x5, x5, x19                           ;
        sb x9, 23(x5)                             ;
_l21:   srli x19, x22, 0                          ;
_l22:   la x16, d_0_25                            ;
        addi x16, x16, 8                          ;
        amomax.d x11, x4, (x16)                   ;
_l23:   fmv.x.w x15, f17                          ;
_l24:   srlw x19, x7, x29                         ;
_l25:   la x12, d_2_8                             ;
        addi x12, x12, -16                        ;
        lr.d x26, (x12)                           ;
_l26:   la x10, d_5_3                             ;
        addi x10, x10, -16                        ;
        sc.d x2, x10, (x10)                       ;
_l27:   la x23, d_3_11                            ;
        addi x23, x23, 8                          ;
        amoswap.d x25, x11, (x23)                 ;
_l28:   fmin.s f14, f19, f30                      ;
_l29:   li x15, 1                                 ;
        la x17, pt1                               ;
        addi x17, x17, 32                         ;
        sfence.vma x15, x17                       ;
_l30:   addi x10, x0, -0                          ;
_l31:   fnmsub.s f6, f28, f6, f26, rne            ;
_l32:   sltiu x25, x29, 14                        ;
_l33:   la x12, d_4_2                             ;
        addi x12, x12, 16                         ;
        amominu.d x5, x30, (x12)                  ;
_l34:   la x14, d_5_0                             ;
        addi x14, x14, 8                          ;
        amoadd.d x22, x26, (x14)                  ;
_l35:   fnmadd.s f22, f13, f14, f23, rne          ;
_l36:   sraw x11, x14, x13                        ;
_l37:   la x30, d_0_26                            ;
        addi x30, x30, -8                         ;
        amoxor.d x18, x17, (x30)                  ;
_l38:   la x5, d_5_15                             ;
        addi x5, x5, 0                            ;
        lr.w x18, (x5)                            ;
_l39:   addw x13, x22, x2                         ;
_l40:   uret                                      ;
_l41:   la x20, d_1_14                            ;
        addi x20, x20, -8                         ;
        amoadd.d x11, x30, (x20)                  ;
_l42:   la x28, d_5_17                            ;
        lui x15, 0xffe00                          ;
        xor x28, x28, x15                         ;
        lw x12, -20(x28)                          ;
_l43:   slti x28, x4, -17                         ;
_l44:   fmax.s f15, f26, f27                      ;
_l45:   la x11, d_1_27                            ;
        addi x11, x11, -0                         ;
        amomaxu.d x11, x7, (x11)                  ;
_l46:   la x27, d_4_18                            ;
        lbu x12, 31(x27)                          ;
_l47:   la x13, d_2_10                            ;
        fsw f26, 20(x13)                          ;
_l48:   fmax.s f8, f14, f25                       ;
_l49:   li x6, 1                                  ;
        la x10, pt1                               ;
        addi x10, x10, 48                         ;
        sfence.vma x6, x10                        ;
_l50:   la x23, d_1_24                            ;
        addi x23, x23, 0                          ;
        amomin.d x21, x20, (x23)                  ;
_l51:   la x13, d_1_21                            ;
        addi x13, x13, 0                          ;
        amomax.w x12, x14, (x13)                  ;
_l52:   la x12, d_4_1                             ;
        addi x12, x12, -0                         ;
        lui x4, 0xffe00                           ;
        xor x12, x12, x4                          ;
        amoswap.w x11, x4, (x12)                  ;
_l53:   fcvt.lu.s x3, f22, rne                    ;
_l54:   sraiw x2, x9, 10                          ;
_l55:   ori x13, x24, 1913                        ;
_l56:   la x16, d_5_27                            ;
        lw x9, 28(x16)                            ;
_l57:   csrrwi x15, stval, 29                     ;
_l58:   la x18, d_1_23                            ;
        addi x18, x18, -8                         ;
        amoswap.d x19, x9, (x18)                  ;
_l59:   la x10, d_3_12                            ;
        addi x10, x10, -8                         ;
        amomaxu.w x29, x4, (x10)                  ;
_l60:   addw x15, x15, x16                        ;
_l61:   fcvt.w.s x7, f3, rne                      ;
_l62:   sllw x8, x17, x27                         ;
_l63:   la x19, d_4_0                             ;
        ld x27, -16(x19)                          ;
_l64:   la x24, d_0_25                            ;
        sw x29, 0(x24)                            ;
_l65:   la x27, d_1_2                             ;
        lui x2, 0xffe00                           ;
        xor x27, x27, x2                          ;
        sb x27, 24(x27)                           ;
_l66:   addi x17, x14, 730                        ;
_l67:   la x9, d_5_5                              ;
        addi x9, x9, 8                            ;
        amoand.d x6, x20, (x9)                    ;
_l68:   sltiu x23, x22, -1291                     ;
_l69:   lui x15, 548212                           ;
_l70:   la x2, d_5_7                              ;
        sw x24, 24(x2)                            ;
_l71:   la x24, d_2_24                            ;
        addi x24, x24, 0                          ;
        amominu.d x18, x16, (x24)                 ;
_l72:   xor x28, x28, x28                         ;
        addi x14, zero, 1                         ;
        slli x14, x14, 21                         ;
        add x28, x28, x14                         ;
        addi x28, zero, 1                         ;
        slli x28, x28, 16                         ;
        add x28, x28, x28                         ;
        addi x25, zero, 1                         ;
        slli x25, x25, 4                          ;
        add x28, x28, x25                         ;
        csrrs x16, sip, x28                       ;
_l73:   la x17, d_2_6                             ;
        addi x17, x17, 0                          ;
        amomax.w x11, x4, (x17)                   ;
_l74:   fadd.s f4, f22, f1, rne                   ;
_l75:   uret                                      ;
_l76:   uret                                      ;
_l77:   fcvt.s.l f31, x24, rne                    ;
_l78:   la x26, d_5_11                            ;
        addi x26, x26, -20                        ;
        lr.w x20, (x26)                           ;
_l79:   fmv.w.x f4, x17                           ;
_l80:   la x6, d_2_15                             ;
        addi x6, x6, 4                            ;
        lui x14, 0xffe00                          ;
        xor x6, x6, x14                           ;
        amoxor.w x28, x14, (x6)                   ;
_l81:   la x2, d_3_13                             ;
        addi x2, x2, 24                           ;
        amoand.d x29, x7, (x2)                    ;
_l82:   la x28, d_0_20                            ;
        addi x28, x28, 8                          ;
        amoswap.d x5, x15, (x28)                  ;
_l83:   la x6, d_4_15                             ;
        addi x6, x6, 16                           ;
        amomin.d x9, x25, (x6)                    ;
_l84:   la x26, d_3_26                            ;
        sw x26, 0(x26)                            ;
_l85:   flt.s x22, f18, f13                       ;
_l86:   fmv.w.x f12, x2                           ;
_l87:   la x10, d_3_24                            ;
        addi x10, x10, -24                        ;
        lr.w x28, (x10)                           ;
_l88:   fsqrt.s f18, f15, rne                     ;
_l89:   xor x12, x12, x12                         ;
        addi x24, zero, 1                         ;
        slli x24, x24, 31                         ;
        add x12, x12, x24                         ;
        addi x19, zero, 1                         ;
        slli x19, x19, 13                         ;
        add x12, x12, x19                         ;
        csrrc x20, sepc, x12                      ;
_l90:   la x23, d_3_12                            ;
        addi x23, x23, 16                         ;
        amomin.d x8, x12, (x23)                   ;
_l91:   fsgnjn.s f28, f30, f13                    ;
_l92:   andi x6, x9, 786                          ;
_l93:   la x19, d_3_22                            ;
        addi x19, x19, 8                          ;
        amomaxu.w x29, x8, (x19)                  ;
_l94:   slliw x0, x25, 20                         ;
_l95:   la x8, d_4_2                              ;
        addi x8, x8, -16                          ;
        lui x28, 0xffe00                          ;
        xor x8, x8, x28                           ;
        amomax.w x6, x28, (x8)                    ;
_l96:   slli x9, x19, 15                          ;
_l97:   la x7, d_1_1                              ;
        srai x7, x7, 1                            ;
        csrrs x27, pmpaddr5, x7                   ;
_l98:   slliw x1, x0, 25                          ;
_l99:   andi x4, x19, -2047                       ;
_l100:;
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
                .dword 0x4931c804c37cae79, 0x8a62407cd7aebae3
                .dword 0xe84680673a6ebcc1, 0x8d34687fac1ad7b7
d_0_0:          .dword 0xe4aa431f09dc7ff3, 0x6ab32a17082b7bba
d_0_1:          .dword 0xc4ba7f86866cd122, 0x80d4b324105c963d
d_0_2:          .dword 0x90b304110ebe2e43, 0x3033286389c15b78
d_0_3:          .dword 0x3dfb1bbd06c33696, 0xd3edaceb5988da58
d_0_4:          .dword 0x9cbdaaa286134e62, 0xa3456dc36581dd09
d_0_5:          .dword 0x10f42c56ff2b1f71, 0x6b615f0f29c069cb
d_0_6:          .dword 0x9760c35d69bd25da, 0x6d9fa5bb5dd1f839
d_0_7:          .dword 0x1511e82f55996972, 0x9e5d8497395b3a0b
d_0_8:          .dword 0x6d14e3423f54acb0, 0xac6a8d3072161aff
d_0_9:          .dword 0x7c1093fded84cc13, 0xc5b671203cf04f3d
d_0_10:         .dword 0xa4104f3cae936613, 0x710ba8a4a3ef0b8a
d_0_11:         .dword 0x768dbb8e09f58f0b, 0xb7bc2614bd45ec58
d_0_12:         .dword 0x351a13a6a1f59cad, 0x4b3fbd1d674877e9
d_0_13:         .dword 0x7ea09674282cfc35, 0xdcfce0331b6d348e
d_0_14:         .dword 0x5a99382b686aa7fa, 0xa3eb8ed5459a2337
d_0_15:         .dword 0x1d84c6738a0c03ba, 0x708f2868390caf72
d_0_16:         .dword 0x29021a28666b88b3, 0xed5fe0fdca035664
d_0_17:         .dword 0x1ce5ae81bd275418, 0xe04aca16f2e0bc10
d_0_18:         .dword 0x270e1d492119d018, 0x53342dae05f40457
d_0_19:         .dword 0x24b4c0ca840c0809, 0xbaa3684e0095c62e
d_0_20:         .dword 0x7c6ae6b2b12af0e1, 0xa56dac18cbae2cbe
d_0_21:         .dword 0xc1db0e20cbd39cd1, 0xa44b98291422401d
d_0_22:         .dword 0xb67040a9898daf02, 0xdc7d5a768a15538a
d_0_23:         .dword 0x7a4a8ea983dc921a, 0x42ccc570c53fa4f2
d_0_24:         .dword 0xf2330cd0c599ce51, 0x5f4ff7c9c5e8a2ca
d_0_25:         .dword 0x75466d88bc64aa1e, 0xb6d9820409a15183
d_0_26:         .dword 0x4bc643feb662db8f, 0x4c263b4af7e914ba
d_0_27:         .dword 0x6ea2c2eef4e23aa6, 0x93315bd24cfc543b
                .dword 0x1cdd344c85e1a5d4, 0x3de98ab84110a75c
                .dword 0xe2df8c9e2447622d, 0xbfbd293b4ff2a5e8
        /* Random data */
_end_data0:
                 

    .section .data.random1;
    .align  8;

_random_data1:
                .dword 0xc1eb2655641af176, 0x6308a453b22ed53b
                .dword 0xca19aef34dca997d, 0x7d66b701f6734508
d_1_0:          .dword 0xc227ab5e85eb8b6a, 0x026a76560142fa94
d_1_1:          .dword 0x37da25fadc785b0a, 0x485478fe1b6804e2
d_1_2:          .dword 0x6e8a53c6a3838fd2, 0xad8672479001585b
d_1_3:          .dword 0x30122fb662bd31ac, 0x944e89f11b96f592
d_1_4:          .dword 0x7a31238e4b36e266, 0x086645a152b49d63
d_1_5:          .dword 0x2758715a9a08be5c, 0x09771008528fdd8c
d_1_6:          .dword 0x020115251184799e, 0xfe85bb2814463ded
d_1_7:          .dword 0xa9d1ca00873adff6, 0x0424c9e1bf3b30f1
d_1_8:          .dword 0x536bf2cdea63bc14, 0x2ce65c6cb24981e0
d_1_9:          .dword 0xcc23986090e7f29f, 0x3256c149cbb79bc3
d_1_10:         .dword 0x542060d60c26a2fc, 0x277a19543f7f2b7c
d_1_11:         .dword 0xd4ac8a0f44564001, 0x6a614e7426a9f3d7
d_1_12:         .dword 0x276d2896a61100c9, 0x1a83ae340d57f603
d_1_13:         .dword 0xb56073f180525971, 0xe0bed3c9f0949263
d_1_14:         .dword 0xd538d39785d1338a, 0x1f62142e5170dbdf
d_1_15:         .dword 0x6dba4804e09b4523, 0x85dbd32203f4cd44
d_1_16:         .dword 0x219b83678c32561c, 0x8519dc151b8540f3
d_1_17:         .dword 0x38207d598aa7fcf2, 0x6027d10dde589600
d_1_18:         .dword 0xbf6a494cb81bc930, 0x4776b76ae8d95c75
d_1_19:         .dword 0x696a30aade7ccd22, 0x85f38d070a74251a
d_1_20:         .dword 0x9e7d27705d1d159f, 0x2dcf0e70d685f249
d_1_21:         .dword 0xdd445e70d5d91505, 0xbd29f421d905b51f
d_1_22:         .dword 0x5bdec3336935fa5d, 0x4c3e2ed6ae0a848f
d_1_23:         .dword 0x757c850b771febd1, 0x15eea9c32a140cdd
d_1_24:         .dword 0x3f5cf4d037ff743f, 0xe9168cb9e06a4866
d_1_25:         .dword 0xb93bf59c90c98bc1, 0x73b83d0424c584b7
d_1_26:         .dword 0x3097e4749c8be534, 0xd4b51cabd8626a35
d_1_27:         .dword 0xea2347e63e554ec9, 0x91d6825a2a7944e8
                .dword 0x51c5145ca5fe9d98, 0xbd78354d11b8f901
                .dword 0xff8b52825ab927b9, 0xb075083fcf937ead
        /* Random data */
_end_data1:


    .section .data.random2;
    .align  8;

_random_data2:
                .dword 0xf1defce472f0c725, 0xbc799d836ecb46e0
                .dword 0x3cb87b01e12a1d6c, 0x82ef2ffafc884e94
d_2_0:          .dword 0x621a7823c8792729, 0x4fe0a9da23255d91
d_2_1:          .dword 0x4ca2571f1656eebd, 0xa1e1d3cd0ca0e30e
d_2_2:          .dword 0xa70a2a6782b69749, 0xcf0eb19a9c81503d
d_2_3:          .dword 0xc5bcaaae0e492f13, 0xb681ecfc242f79d9
d_2_4:          .dword 0xed2d108dd54b419c, 0x45deda26fb4533b2
d_2_5:          .dword 0x7f5599f920f70f79, 0x2bafcb0c5b5d2b2f
d_2_6:          .dword 0x51b00265dbca185c, 0x8b71a71e6433901d
d_2_7:          .dword 0x845259bcab0a8ed9, 0xee69e87a0fcd4334
d_2_8:          .dword 0x17d6870e3c8c42e3, 0x8c7c3d1010840971
d_2_9:          .dword 0x0594da5f844c95f3, 0x3d0a00f2dcba1d1b
d_2_10:         .dword 0xaed97e5146bec67c, 0x72d46114b4fa5f25
d_2_11:         .dword 0x391c9fba792b17a3, 0xbeff50b9f8eca885
d_2_12:         .dword 0x0ecae03c4d937e55, 0x70f7c10002e8f2f1
d_2_13:         .dword 0x24dabf2f9002fc4c, 0x5d247f2a488a8024
d_2_14:         .dword 0xa5e03b3d449cffc4, 0x0a894e19bac18854
d_2_15:         .dword 0x5747e6810c0afffe, 0x6db703939a03ed80
d_2_16:         .dword 0xec78ccfe96a53bf5, 0xcf67ac208fd7db02
d_2_17:         .dword 0xddb09f040497d187, 0x4399c09015193da0
d_2_18:         .dword 0xc0ab601b56628eaf, 0xfb85a605d1c33ec2
d_2_19:         .dword 0x641a65767394c5e4, 0x2efc495739a275c5
d_2_20:         .dword 0xa4e8d1615970eb5c, 0x3c37f5fecdb6d6a2
d_2_21:         .dword 0xa291fec7ce18218d, 0x6224a569eb33fe63
d_2_22:         .dword 0xd6c818038c124b99, 0x8bb9c27accc5cddb
d_2_23:         .dword 0x583b17ba5e5f1e8c, 0x0aa1b34b1ba9d299
d_2_24:         .dword 0xc0ccdc93ac7a0e25, 0xb5eb2e2183f133b7
d_2_25:         .dword 0x151a43a23ac952f7, 0x65479143613f3673
d_2_26:         .dword 0xed6b9a79fd7d221e, 0xe9ca58eb272022dc
d_2_27:         .dword 0xa42fe2d16d3f4479, 0x09aa655351975ccb
                .dword 0x3605233a1e65f1ad, 0x4cdc8875c1e7eacb
                .dword 0x5d756326787b0382, 0x157b1f35a539e059
         /* Random data */
_end_data2:
                

    .section .data.random3;
    .align  8;

_random_data3:
                .dword 0x958284d37477b5e8, 0xd00e8489f89c4305
                .dword 0x6fcde4b6b4999981, 0xb0eabf1093a66b9e
d_3_0:          .dword 0x93e06b58e1e7da75, 0x824fbf71f1f464f4
d_3_1:          .dword 0x97176e4a9e09e4d1, 0xc3f3dcc21d10fffc
d_3_2:          .dword 0x9d8f345c35a8abf0, 0x5d63bc433bd2f51f
d_3_3:          .dword 0xe79b66b682af07b8, 0xe7653bf77149c60a
d_3_4:          .dword 0x4c4a38172d060b04, 0x2ae815d6221ad935
d_3_5:          .dword 0x1e93bf48ee0b78d7, 0x04032da9fa5413d8
d_3_6:          .dword 0xf762bdec30017f89, 0xeb6e0ad7693b8e39
d_3_7:          .dword 0x45c42426cab4b0f9, 0x2cae7eff2b006b8f
d_3_8:          .dword 0xf48140cbff56769a, 0x9c0ce7c540922a7d
d_3_9:          .dword 0x751275b4f5749eb5, 0x17044a4a5ac58a0f
d_3_10:         .dword 0x87b990bb3ba61c36, 0xe903d61a7bb5be23
d_3_11:         .dword 0xde3cd22aeedb734f, 0x60f01ea3e351373f
d_3_12:         .dword 0x8d8c21d4f54becfc, 0xd779e5c21069cd00
d_3_13:         .dword 0x9f7d9bf440dbe97b, 0x7c534f750c144efe
d_3_14:         .dword 0x14c3a353c2397c0f, 0x1ec488819b8bb498
d_3_15:         .dword 0x793f7807bbfd99bf, 0xe30147eaa14ab218
d_3_16:         .dword 0xc263fbef23ebcf06, 0x2bdae53953475d71
d_3_17:         .dword 0x1b2b78b42cc08b09, 0xba34bea503014d7d
d_3_18:         .dword 0x165a3647deda829a, 0x39c0a38e0b9996b9
d_3_19:         .dword 0xe8a8b21430c39b13, 0x93ec6e1ab800a20d
d_3_20:         .dword 0x77d986a400617a8e, 0x674f8a1bf27c6b96
d_3_21:         .dword 0xfcc436f9ef771da9, 0xfa1fada2bc1b9a47
d_3_22:         .dword 0x17536ab513853dff, 0xe94d8cafabd7dad9
d_3_23:         .dword 0xde78a20a00af486d, 0xe2abc2692931651a
d_3_24:         .dword 0x74f5dae95b0252be, 0xbb0132bbfa39f08f
d_3_25:         .dword 0xb81b7087cb125ad7, 0x0ad199508c154bed
d_3_26:         .dword 0xd5041cd9a59acd42, 0x312bc7b674efcdfc
d_3_27:         .dword 0x86ad407f2913f908, 0x63353b871a1be373
                .dword 0xd5887272133f8091, 0xc647b553fead5e58
                .dword 0x585d2f9ccdbef0b0, 0xd76b323f8473323d
        /* Random data */
_end_data3:


    .section .data.random4;
    .align  8;

_random_data4:
                .dword 0x4083690643513869, 0x83a165941d1801b0
                .dword 0x22fd81dd9509309f, 0xa660d1898a3a8ff4
d_4_0:          .dword 0x0eef7b314e006180, 0xb390be51ab4f505b
d_4_1:          .dword 0xcaa7e619931ec905, 0x18a35cda6c511241
d_4_2:          .dword 0xe5c962bf6c0d9a9d, 0xd3c30f332be3cc92
d_4_3:          .dword 0x786ec46c2d7afac5, 0x0d611875fff177e2
d_4_4:          .dword 0x1bd7b0c6cd714e10, 0x06e67220e2804730
d_4_5:          .dword 0xd0820a8a77dcee29, 0xefae7d8c73d83a26
d_4_6:          .dword 0xc65a4fef4c98fde8, 0x7692c90920e85763
d_4_7:          .dword 0x24ea30cfbc4e85c4, 0xee255d33fddb320f
d_4_8:          .dword 0x5f0b9b1d9a932cd4, 0xecc0c9a23eb67557
d_4_9:          .dword 0x36fb2baffd8134fa, 0x5a94b509412b1def
d_4_10:         .dword 0xb31f89420e644008, 0x5e61a5fc8b54898c
d_4_11:         .dword 0x041f64930897263e, 0x43f170dd3544a97b
d_4_12:         .dword 0xab2c33f2a38c41ec, 0x94f346e15501aa9f
d_4_13:         .dword 0x5222eee48678167e, 0xdcf061f5e216b21a
d_4_14:         .dword 0xa3ff31278ef2792d, 0x0c29eb84cf3fffa6
d_4_15:         .dword 0x161860b3d79bba06, 0x4ba659be7a5e3197
d_4_16:         .dword 0xba95632cf50d7000, 0x51b7cb283d393125
d_4_17:         .dword 0x1a2fe519e4d6e82d, 0xbc6ac6683ba918cc
d_4_18:         .dword 0x54989ab21ab512fa, 0x0173bae450dd86d0
d_4_19:         .dword 0x5e80cdbf6d5003a0, 0x08240b28deac18a3
d_4_20:         .dword 0x6695372928ae2fdb, 0x2572cc86d9088c24
d_4_21:         .dword 0x781a10a80ef2cc3f, 0xbb681637a14a811a
d_4_22:         .dword 0x3582b95c1a292dec, 0x03eb3f9c0ca9de07
d_4_23:         .dword 0x776dcf225e22f22e, 0xa857e2395b97f94f
d_4_24:         .dword 0xe85cabc6a2f343e0, 0x6911ec98d6057372
d_4_25:         .dword 0x1a5572b0b8fe3987, 0xd9c5ee477e01f2f5
d_4_26:         .dword 0x95b3f8574b50c908, 0xba02b1e1013661af
d_4_27:         .dword 0x95f3d0e9be2df1bf, 0x20416cacfe241350
                .dword 0xbb205c1fbc7c8b2d, 0x7d6c173d9a3e375d
                .dword 0xbdadf7692b6192b4, 0x64ae9427563ff25e
        /* Random data */
_end_data4:


    .section .data.random5;
    .align  8;

_random_data5:
                .dword 0x87e1c96da424adae, 0xfaf3e8c7f1af7ad9
                .dword 0xbe6a201cbe06f0a5, 0x9a0d7028ba9cf709
d_5_0:          .dword 0x19fc4a0cc117fa82, 0x643f34cf9a8bfbaf
d_5_1:          .dword 0xe838a7096b3f1e87, 0x044f5fddc2106e82
d_5_2:          .dword 0x9b66f218c750f2a6, 0xe2f040e6ee5abcf2
d_5_3:          .dword 0xecf5c86ef367f4ad, 0x1d1ddae646e54a23
d_5_4:          .dword 0x252d84f3bc71f6ec, 0x8c60d457776dfecd
d_5_5:          .dword 0xfd3edfcf0ed8929e, 0xe23bf78257270a8f
d_5_6:          .dword 0x84834f1374285dbc, 0x54ac8886afbc9803
d_5_7:          .dword 0xd89627886f47f7d1, 0xf6c2b582df54f880
d_5_8:          .dword 0xc6b8dca86b36646a, 0x5c79091af74dc5b1
d_5_9:          .dword 0x0f5bf04fd849ccbe, 0x40bd4cdab5f64a31
d_5_10:         .dword 0x03c6d662512d2e82, 0xb1795abff09e502f
d_5_11:         .dword 0x7dec203bf28b38d5, 0x42b641f906cb96e3
d_5_12:         .dword 0x577eeef3a6d1efd4, 0xee8525f8d16a2958
d_5_13:         .dword 0x9aa9834ae61f8e22, 0x69db96f92239cc6d
d_5_14:         .dword 0xd7f96abea6225692, 0x926c4104232dbf81
d_5_15:         .dword 0x384ad4ae29367a4f, 0xe8e00bb05f647d5b
d_5_16:         .dword 0x62ce40d863f5d6f4, 0xf2f6ed3c79f38bd3
d_5_17:         .dword 0xe29b5501cc7e8ea8, 0xf608e1011d8c26f6
d_5_18:         .dword 0x4d018c6de58c97e3, 0xb0e9067810e4f3c5
d_5_19:         .dword 0xf3ad8f0744ee2260, 0xdc2163b4dedd76a2
d_5_20:         .dword 0x92b18e1cbe47080b, 0x1ec519b8f07e5c93
d_5_21:         .dword 0xc0c804311fb87105, 0xf9f1b01b261fcf5f
d_5_22:         .dword 0xc07e346452ba1d7b, 0x2d36b708ac8bb8f3
d_5_23:         .dword 0x7a5f98f6d4201111, 0x71d35642010b8289
d_5_24:         .dword 0x88a40af4bab1a96f, 0xb497c01e2c6a1e4f
d_5_25:         .dword 0xe2fbe5b00e86a54f, 0x9fc8d7b9eb63810b
d_5_26:         .dword 0x45d56a2086191a9f, 0x847909fb3e4b0afe
d_5_27:         .dword 0xfb2a5f44b06b8050, 0x1a0536e500f59cd5
                .dword 0xf4822893e1cf810b, 0x56d2c8fcd6562305
                .dword 0x8edac7523039e5b9, 0x349c903bc736e988
         /* Random data */
_end_data5:
              
