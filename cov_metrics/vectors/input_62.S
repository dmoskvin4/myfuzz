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
_s0:    la x14, d_0_23                            ;
        addi x14, x14, 8                          ;
        amoswap.d x21, x16, (x14)                 ;
_s1:    srai x3, x15, 25                          ;
_s2:    fmadd.s f7, f11, f8, f27, rne             ;
_s3:    la x23, d_1_18                            ;
        addi x23, x23, -16                        ;
        sc.d x8, x23, (x23)                       ;
_s4:    fmv.w.x f17, x20                          ;
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
_p0:    csrrwi x14, sip, 17                       ;
_p1:    csrrwi x11, sstatus, 0                    ;
_p2:    csrrci x10, satp, 31                      ;
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
_l0:    la x10, d_1_1                             ;
        addi x10, x10, -16                        ;
        amoswap.d x22, x2, (x10)                  ;
_l1:    csrrci x11, sie, 17                       ;
_l2:    srlw x24, x27, x15                        ;
_l3:    xor x22, x22, x22                         ;
        addi x4, zero, 1                          ;
        slli x4, x4, 24                           ;
        add x22, x22, x4                          ;
        csrrs x12, sscratch, x22                  ;
_l4:    csrrci x2, sie, 17                        ;
_l5:    la x15, d_2_16                            ;
        addi x15, x15, 24                         ;
        lui x10, 0xffe00                          ;
        xor x15, x15, x10                         ;
        amominu.w x3, x10, (x15)                  ;
_l6:    la x23, d_1_2                             ;
        addi x23, x23, 8                          ;
        amoand.d x20, x8, (x23)                   ;
_l7:    fmadd.s f8, f8, f14, f8, rne              ;
_l8:    la x26, d_2_23                            ;
        addi x26, x26, 8                          ;
        amomax.d x4, x6, (x26)                    ;
_l9:    la x10, d_3_9                             ;
        lhu x28, -16(x10)                         ;
_l10:   fmadd.s f14, f8, f17, f20, rne            ;
_l11:   la x13, d_2_11                            ;
        srai x13, x13, 1                          ;
        csrrc x12, pmpaddr6, x13                  ;
_l12:   fcvt.wu.s x12, f8, rne                    ;
_l13:   la x9, d_5_9                              ;
        addi x9, x9, -8                           ;
        lr.d x21, (x9)                            ;
_l14:   subw x19, x2, x19                         ;
_l15:   fcvt.lu.s x14, f25, rne                   ;
_l16:   fadd.s f5, f7, f27, rne                   ;
_l17:   fle.s x13, f5, f11                        ;
_l18:   fnmsub.s f9, f8, f27, f8, rne             ;
_l19:   fmsub.s f25, f24, f21, f31, rne           ;
_l20:   la x3, d_1_22                             ;
        ld x28, 8(x3)                             ;
_l21:   auipc x0, 608170                          ;
_l22:   fnmadd.s f0, f16, f24, f11, rne           ;
_l23:   fmadd.s f11, f26, f13, f2, rne            ;
_l24:   fcvt.l.s x4, f13, rne                     ;
_l25:   fsqrt.s f0, f5, rne                       ;
_l26:   csrrsi x27, pmpaddr3, 17                  ;
_l27:   la x28, d_3_22                            ;
        sh x25, -30(x28)                          ;
_l28:   srlw x18, x18, x12                        ;
_l29:   fmsub.s f28, f19, f8, f16, rne            ;
_l30:   csrrci x13, frm, 26                       ;
_l31:   la x16, d_3_19                            ;
        addi x16, x16, 8                          ;
        lui x5, 0xffe00                           ;
        xor x16, x16, x5                          ;
        amominu.d x6, x5, (x16)                   ;
_l32:   fmadd.s f25, f14, f11, f28, rne           ;
_l33:   la x12, d_0_27                            ;
        addi x12, x12, -8                         ;
        amoor.w x28, x18, (x12)                   ;
_l34:   la x6, d_1_15                             ;
        addi x6, x6, 0                            ;
        amoswap.w x7, x24, (x6)                   ;
_l35:   srai x5, x17, 63                          ;
_l36:   addiw x12, x15, -2047                     ;
_l37:   fle.s x22, f17, f7                        ;
_l38:   la x24, d_1_3                             ;
        addi x24, x24, 16                         ;
        amomaxu.d x6, x18, (x24)                  ;
_l39:   fmv.w.x f5, x5                            ;
_l40:   fcvt.s.l f14, x15, rne                    ;
_l41:   csrrci x2, pmpaddr1, 10                   ;
_l42:   fcvt.s.l f26, x24, rne                    ;
_l43:   la x18, d_2_4                             ;
        sh x7, 18(x18)                            ;
_l44:   fsub.s f18, f21, f11, rne                 ;
_l45:   sret                                      ;
_l46:   la x8, d_5_18                             ;
        addi x8, x8, 0                            ;
        amominu.d x4, x2, (x8)                    ;
_l47:   la x20, d_4_4                             ;
        addi x20, x20, -24                        ;
        amomaxu.d x14, x21, (x20)                 ;
_l48:   addi x12, x27, 3                          ;
_l49:   la x7, d_5_21                             ;
        addi x7, x7, -0                           ;
        amoadd.d x29, x30, (x7)                   ;
_l50:   fsgnjx.s f27, f7, f24                     ;
_l51:   la x17, d_1_6                             ;
        addi x17, x17, 16                         ;
        amoand.d x8, x9, (x17)                    ;
_l52:   csrrwi x2, fcsr, 20                       ;
_l53:   la x7, d_1_24                             ;
        lui x30, 0xffe00                          ;
        xor x7, x7, x30                           ;
        fsw f22, 0(x7)                            ;
_l54:   feq.s x14, f9, f16                        ;
_l55:   la x10, _l65                              ;
        lbu x25, -15(x10)                         ;
_l56:   la x29, d_4_20                            ;
        addi x29, x29, 28                         ;
        amoadd.w x19, x16, (x29)                  ;
_l57:   la x2, d_0_11                             ;
        fsw f10, 4(x2)                            ;
_l58:   sllw x21, x28, x23                        ;
_l59:   la x16, d_3_12                            ;
        ld x1, 8(x16)                             ;
_l60:   fclass.s x17, f3                          ;
_l61:   la x5, d_1_25                             ;
        addi x5, x5, 24                           ;
        lr.w x25, (x5)                            ;
_l62:   la x6, d_2_15                             ;
        sd x14, 8(x6)                             ;
_l63:   fmv.x.w x12, f30                          ;
_l64:   fadd.s f30, f20, f13, rne                 ;
_l65:   la x20, d_3_15                            ;
        addi x20, x20, 8                          ;
        lui x4, 0xffe00                           ;
        xor x20, x20, x4                          ;
        amomax.d x19, x4, (x20)                   ;
_l66:   fclass.s x30, f2                          ;
_l67:   la x24, d_5_5                             ;
        addi x24, x24, -0                         ;
        amomaxu.w x3, x6, (x24)                   ;
_l68:   la x19, d_5_1                             ;
        fsw f23, -24(x19)                         ;
_l69:   fmul.s f27, f16, f12, rne                 ;
_l70:   srlw x16, x19, x6                         ;
_l71:   la x2, d_4_4                              ;
        addi x2, x2, -0                           ;
        amoor.d x13, x22, (x2)                    ;
_l72:   la x6, d_3_18                             ;
        lbu x20, -0(x6)                           ;
_l73:   fcvt.s.w f1, x4, rne                      ;
_l74:   la x6, d_1_16                             ;
        addi x6, x6, -0                           ;
        lr.d x20, (x6)                            ;
_l75:   fadd.s f21, f8, f31, rne                  ;
_l76:   la x3, d_4_19                             ;
        addi x3, x3, 24                           ;
        amoadd.d x4, x23, (x3)                    ;
_l77:   la x23, d_0_21                            ;
        addi x23, x23, -8                         ;
        amoxor.d x22, x27, (x23)                  ;
_l78:   fnmsub.s f3, f8, f26, f29, rne            ;
_l79:   xor x30, x30, x30                         ;
        addi x6, zero, 3                          ;
        slli x6, x6, 16                           ;
        add x30, x30, x6                          ;
        addi x14, zero, 1                         ;
        slli x14, x14, 5                          ;
        add x30, x30, x14                         ;
        csrrs x1, sip, x30                        ;
_l80:   fcvt.s.lu f17, x5, rne                    ;
_l81:   fmv.x.w x1, f30                           ;
_l82:   la x17, d_1_27                            ;
        addi x17, x17, 24                         ;
        lr.d x8, (x17)                            ;
_l83:   csrrsi x13, frm, 0                        ;
_l84:   la x15, d_3_27                            ;
        addi x15, x15, -28                        ;
        amoand.w x1, x21, (x15)                   ;
_l85:   la x3, d_5_23                             ;
        addi x3, x3, -28                          ;
        amoxor.w x18, x22, (x3)                   ;
_l86:   la x11, d_5_23                            ;
        addi x11, x11, -8                         ;
        amomax.d x2, x12, (x11)                   ;
_l87:   csrrwi x3, scause, 12                     ;
_l88:   la x25, d_2_6                             ;
        addi x25, x25, 4                          ;
        amoor.w x20, x24, (x25)                   ;
_l89:   subw x18, x21, x1                         ;
_l90:   sltiu x15, x7, -1103                      ;
_l91:   sltiu x8, x1, 1563                        ;
_l92:   la x14, d_3_9                             ;
        sw x9, 0(x14)                             ;
_l93:   la x14, d_0_8                             ;
        srai x14, x14, 1                          ;
        csrrc x12, pmpaddr2, x14                  ;
_l94:   sllw x14, x27, x9                         ;
_l95:   fmv.w.x f20, x0                           ;
_l96:   fdiv.s f5, f7, f25, rne                   ;
_l97:   sllw x0, x28, x2                          ;
_l98:   sllw x30, x24, x1                         ;
_l99:   la x20, d_1_6                             ;
        fsw f15, 24(x20)                          ;
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
                .dword 0x8ae33db21490fb9b, 0x604eff3fa64ba7cb
                .dword 0x2e3c8c45189e28ca, 0x2e26ff6b825f6b56
d_0_0:          .dword 0x917dc2bce9054996, 0x99ba8fa5ddb139ed
d_0_1:          .dword 0x2a5b449680d71062, 0x79cec218bdab9e1e
d_0_2:          .dword 0x7de8bce93b917ea3, 0x5f28f1a808cfce1b
d_0_3:          .dword 0x839b721d26579e6a, 0x1907f8fb0184191d
d_0_4:          .dword 0x126771887d4ac8f7, 0xbf71ba674b5e42c7
d_0_5:          .dword 0xa1c1fe48b0b8f94a, 0x6ff1e39d32299e91
d_0_6:          .dword 0x2898d253c94e0b48, 0xe18ee2c09eda81cb
d_0_7:          .dword 0x147bd0c8f8d68602, 0x653165518073d0df
d_0_8:          .dword 0x9095e239f6d445fc, 0xc90e59102c5082e5
d_0_9:          .dword 0x7b3c7967a4c92c13, 0x54274746c17d90d8
d_0_10:         .dword 0x1c2fefb1204f81ee, 0x02a3e778189b445c
d_0_11:         .dword 0x6421f3bda54ed2c3, 0xebaed97097058f72
d_0_12:         .dword 0xfa6206a7db807b53, 0x4c5604ac4e655031
d_0_13:         .dword 0xca119522ccc7a441, 0xe02510a220ed7f7a
d_0_14:         .dword 0xcf4267d2202a4ec9, 0xc8c36483ce3b3653
d_0_15:         .dword 0x6f66e7579b311d26, 0xaf6cde21ab29c0d3
d_0_16:         .dword 0x8dd4d4dfcb3e8dcd, 0x6ce739affbc78da7
d_0_17:         .dword 0x4660b27634139c25, 0x680cddf7ca8e2481
d_0_18:         .dword 0xd925d6461e2f059f, 0x85f8c596557fb9bb
d_0_19:         .dword 0x43c5584617bfff75, 0x9a6b4c97c844d101
d_0_20:         .dword 0x4aa40bded3740f54, 0x3ddbf0b694a54d67
d_0_21:         .dword 0xa07eaffd4294edab, 0x2f2a4999f8fd1a6f
d_0_22:         .dword 0x10b254bed670db97, 0x94af4f7486259f98
d_0_23:         .dword 0x453f4ac15624075b, 0xf9105e9eea329662
d_0_24:         .dword 0xdce819e797834c16, 0x174b95f1b2f2fbf0
d_0_25:         .dword 0xe7d9f9fabbbe225a, 0x8869d14fbe44a9cb
d_0_26:         .dword 0x79c3e5bcc1976f2c, 0x7947c9370a3c6559
d_0_27:         .dword 0x17c747fdec8a2980, 0x63f71a2e7c705845
                .dword 0xf98af862faaafd56, 0x1ec0393bb4073e87
                .dword 0x2f0af479be71fa8a, 0x7bfe936f8bf34ee9
        /* Random data */
_end_data0:
                 

    .section .data.random1;
    .align  8;

_random_data1:
                .dword 0x62e0138dac43899c, 0xdb346c48d6007373
                .dword 0xee445834b5ceed0f, 0x843de50af6dc0d0e
d_1_0:          .dword 0x922dba2049829ad9, 0xc287d24113ab0a1f
d_1_1:          .dword 0x6b84c0cbc78b006b, 0xa1873e011c4b403c
d_1_2:          .dword 0x78a83888ce926ecf, 0x1bf56a2d9f18083c
d_1_3:          .dword 0xa2df2e51b9366128, 0x1ff131ff17360aac
d_1_4:          .dword 0xc7f74d1c40625b89, 0x32f285fa293529b5
d_1_5:          .dword 0x542e30fae2291c77, 0x04aa16f29bc2be9e
d_1_6:          .dword 0xb277f2a55222ea8b, 0xf50f2cfcb7f6772c
d_1_7:          .dword 0x7913027b7b7f57b3, 0x230338bb1c2722b3
d_1_8:          .dword 0xb5acadf5327d4499, 0x0675429547fa4fa5
d_1_9:          .dword 0xe39bf5662b2582cf, 0xa724970cbd898041
d_1_10:         .dword 0x6a4129961bb9ddaf, 0x6e4bcd3a78bd7b0d
d_1_11:         .dword 0xcf76efdd4d06d18b, 0x7543264e2a02e0fe
d_1_12:         .dword 0x9f9e15c436eaf737, 0x9fb0c837bfa1af7e
d_1_13:         .dword 0xd75370fd16c37909, 0x01b49ed8ab19993c
d_1_14:         .dword 0x57845edfe1a7b0c1, 0xf8779ca9ac0bc55e
d_1_15:         .dword 0xc550d87ad22f4d38, 0x35a65851fd386056
d_1_16:         .dword 0xd8805a707bb54a2c, 0x5faa985f57a67ef0
d_1_17:         .dword 0x1a937a83aad47c62, 0xfa555034998eb40b
d_1_18:         .dword 0x0218c5de7cdc86a6, 0x47b6f6b23bce2410
d_1_19:         .dword 0x5c32afcef114920a, 0xac59f79b4e1607b5
d_1_20:         .dword 0xac59014cb70513cc, 0x93626f1cc65b6370
d_1_21:         .dword 0x60313aa4b52735db, 0xe1b18ffd5d5e8b19
d_1_22:         .dword 0x7279eb5e58e2bf75, 0xac9dea4b57c0964e
d_1_23:         .dword 0xf4fa8814bd605de2, 0xd9e256fdb491d61d
d_1_24:         .dword 0x8f87ba1b36c01f41, 0xec9657fcf8b44608
d_1_25:         .dword 0x92549d05476c6dda, 0x5c4b479edbafdc14
d_1_26:         .dword 0x55dcfa52bd8d8e04, 0x412c600710da0d6c
d_1_27:         .dword 0xa40a9fe2be589016, 0xcf762d2d3d74d928
                .dword 0x82b929cd5d8a25eb, 0xb6ecd726df3735ea
                .dword 0x1ef89d0fa9d1d408, 0x1e56102fee18a103
        /* Random data */
_end_data1:


    .section .data.random2;
    .align  8;

_random_data2:
                .dword 0x4e93226d7340ff75, 0x0dbc78492c32d484
                .dword 0x5a73726fbfc20ed5, 0xac530a0ab17a95cf
d_2_0:          .dword 0xea529535ffac338b, 0x65a98306724238b4
d_2_1:          .dword 0xf9d83c396998f10e, 0x08245471dfaffefd
d_2_2:          .dword 0x66e60611e0381462, 0xe68b9cda1add1930
d_2_3:          .dword 0x6df2a28aa0f49b9a, 0xe17ad851eaed6e09
d_2_4:          .dword 0xca9bc29c426a1403, 0xb3edc697afe3e5d2
d_2_5:          .dword 0x40a1ec358c62e32b, 0x900af832c967059e
d_2_6:          .dword 0x769dcc0f2e43a5dc, 0x825d47d8cfcf8cdd
d_2_7:          .dword 0xbfcca745565ea9db, 0x0d32f5a85accb1e3
d_2_8:          .dword 0xba5f33e29d14c4cb, 0x9badf5b0019ae05f
d_2_9:          .dword 0x10dcfc931dde1eae, 0xe14dc728f3c58d09
d_2_10:         .dword 0x0a5dd8cd1e1b0d2c, 0xa32cd88380eeed28
d_2_11:         .dword 0x265b500fbf4117f8, 0xc9abfb1188540138
d_2_12:         .dword 0xabe4fb0541e11bcb, 0xc50102dcf4f1f5cf
d_2_13:         .dword 0xc61c87114cf93308, 0x3e9df35f28102eac
d_2_14:         .dword 0xd3410baca5219fc2, 0xed826a5924e941ac
d_2_15:         .dword 0x566235e90ff65ded, 0x9ff4913c496af776
d_2_16:         .dword 0x1c1d61ae0bd93d39, 0x5f4a170d4468465c
d_2_17:         .dword 0x468646dcb24993d0, 0xdb720e03079b3dca
d_2_18:         .dword 0x18c06f8dfeb84981, 0xc3b3aa2533f03e75
d_2_19:         .dword 0xd021b4fa32d61daa, 0xea5bf293a7ff9b6c
d_2_20:         .dword 0x0fcb7fb172e7d152, 0x01ac3942bfc019b8
d_2_21:         .dword 0xf8131a9fbf5e1211, 0xeca864c47cc841fb
d_2_22:         .dword 0x1f007955ff4d964f, 0xab107f11eab86977
d_2_23:         .dword 0x134d47875052d96c, 0x28b7cc665b32afe1
d_2_24:         .dword 0x74a399f8b0f100bf, 0x0a1b92d6a555098d
d_2_25:         .dword 0xa643342eafbd6b3b, 0x7419f9c59cb883a8
d_2_26:         .dword 0xb0eaacca7d29a89a, 0xb6a948f7344877ea
d_2_27:         .dword 0x7d4520cb24335677, 0x77bf64e8ce51282c
                .dword 0x2e815ffbc8a17172, 0x8bc57a9e4fc4c9bb
                .dword 0x5bd4bc8bc9c38864, 0xd0c113160802bdb8
         /* Random data */
_end_data2:
                

    .section .data.random3;
    .align  8;

_random_data3:
                .dword 0x71c2ea3a0fee8207, 0xa59280f73b6864cf
                .dword 0x2febae0a230c77d0, 0x4d6cf375b4508e53
d_3_0:          .dword 0xd044977ab3c4c0ed, 0x99501084f251d9a5
d_3_1:          .dword 0xcc3f56fc7637b23b, 0x2a22847c8a324efb
d_3_2:          .dword 0x86d2e85c15e678e0, 0x045aafea0988ee0d
d_3_3:          .dword 0x88841f3c45f9a032, 0x062a6fc6fa3055e7
d_3_4:          .dword 0xf51ed660d981b675, 0xce6ca9281a8bf11c
d_3_5:          .dword 0xd4bcd7225d4105a6, 0x440ac59f3a66575d
d_3_6:          .dword 0xfd8f92277fd8c95b, 0x63cccff574fd9e41
d_3_7:          .dword 0x71b5fa407b884d36, 0x54a733248d00282c
d_3_8:          .dword 0xfadcf4d76cf073c7, 0x134b55e3e094ebd7
d_3_9:          .dword 0xf5e3d52f2b75e671, 0xb40e1c1101696468
d_3_10:         .dword 0x7782f302b780db12, 0x92a1c2f22d96666a
d_3_11:         .dword 0xb13819921949dcb0, 0xa44d216eee8c5aa9
d_3_12:         .dword 0x7467fb2289c1ed88, 0xf78233bb89a7d7da
d_3_13:         .dword 0xd7018cd7ac9b0d0f, 0x9ca9baa62ec39aaf
d_3_14:         .dword 0x790762c6625008ef, 0xe0e294318da91114
d_3_15:         .dword 0x11eb048e534e81e9, 0xf2129f7cd548d094
d_3_16:         .dword 0x88b15865cb5177d3, 0x6e76487e111a9476
d_3_17:         .dword 0x113b5e87215d19fa, 0x977ad409815b3b46
d_3_18:         .dword 0xdc11e19566e495a3, 0x3b3a1976c8fe383e
d_3_19:         .dword 0xbb57e08d49155e35, 0x257dbb14f538f63a
d_3_20:         .dword 0x54c218c8637db713, 0xe2b14effa4fbbdd3
d_3_21:         .dword 0xa02ede0e1eab1dbf, 0x22ea025f69a783dc
d_3_22:         .dword 0x8114575e84526648, 0x98e2c1536dd0770b
d_3_23:         .dword 0x5d4b90c7ba3ac8ad, 0xefde6ede2bc4ccfb
d_3_24:         .dword 0x751c8a1a75b3703d, 0x86c7596d6daf14d3
d_3_25:         .dword 0x89615ecee6cdff4a, 0xcf6aebef9ab498ce
d_3_26:         .dword 0x5b392c783d859570, 0x523ebea980f6603b
d_3_27:         .dword 0x26ea05923097e934, 0x2e8292a2a9cae655
                .dword 0x2d4905404781c5f6, 0xb5c11c61c98ac971
                .dword 0x49e471de566db315, 0xe0a0456aaf1cbd6d
        /* Random data */
_end_data3:


    .section .data.random4;
    .align  8;

_random_data4:
                .dword 0x36ffcc02a38eb67e, 0x7e413228018faff3
                .dword 0xc1f54952aecd48ad, 0xf9c5cce8099c06ef
d_4_0:          .dword 0xd86acf2b3d368745, 0x0f89ae452be0f306
d_4_1:          .dword 0x60223d4e8bc7c190, 0x0494269ea0e026b8
d_4_2:          .dword 0xffa55d655d2a5d88, 0xab437337c3ea335f
d_4_3:          .dword 0xd18878f7a88507e5, 0x3cdfbd2ded77490f
d_4_4:          .dword 0x536258682bceb96b, 0x48546475317064c2
d_4_5:          .dword 0xed95e657e910903f, 0x2c9b9ba1809f72d2
d_4_6:          .dword 0xaf70a7782f7df2a5, 0x98f5a763339025ff
d_4_7:          .dword 0x79e0344eecf514c9, 0x263dd9660b5c0832
d_4_8:          .dword 0x25d3454278dcaba9, 0x29f4cb06605861dc
d_4_9:          .dword 0x9a340d9ca86c6a83, 0x68b7bc55f387090d
d_4_10:         .dword 0x7a0b5f91e195b7b6, 0x9ce73a9cf2648e55
d_4_11:         .dword 0x27f958d1527ed2e7, 0xd7f916222e6c00e5
d_4_12:         .dword 0x2b35788563e1d1a4, 0xafffc9d937baa950
d_4_13:         .dword 0xcb1b94e3d92ea6e9, 0xc39e5f85d96da574
d_4_14:         .dword 0xfd69f60c0ffd50dc, 0xc2cdf4c45bf1cde7
d_4_15:         .dword 0x05e607a2e17fb382, 0x71041dd6233415f3
d_4_16:         .dword 0x7eaa094cb330c878, 0xd19384b27c2d2ee0
d_4_17:         .dword 0x41c33eb0b2f515b2, 0xa9e13b4529ca6f9d
d_4_18:         .dword 0x99c1569688c18d68, 0x220db8d191ac2457
d_4_19:         .dword 0x832f7c21643ca66b, 0x52ace84c3b60a36e
d_4_20:         .dword 0x16270e9f99fb107d, 0x9c7b1feebaffda5c
d_4_21:         .dword 0xd8ff4cc4777c176d, 0x72874e14e3f14fa9
d_4_22:         .dword 0x093f194ff65ca9f5, 0xb0e9966ce7d2700e
d_4_23:         .dword 0x05c9d59331cfc7ad, 0x3166f7bddcd6d7a6
d_4_24:         .dword 0x6cfeaa1696254070, 0x8987ac77fe1baa31
d_4_25:         .dword 0xd8d99dddaefc2012, 0x78793b9c802c0b81
d_4_26:         .dword 0x163fc997972ac6ce, 0x4de87315af193c9f
d_4_27:         .dword 0x1bd8cab5c6b6bc31, 0xfcab3344c5aeb0cb
                .dword 0xab50908825225b0c, 0x823711f656f01c02
                .dword 0x41106267d91876cb, 0x4907f8693b7eceff
        /* Random data */
_end_data4:


    .section .data.random5;
    .align  8;

_random_data5:
                .dword 0x593a63b7b69fe08f, 0x72916d78af191010
                .dword 0x483428c8bf852104, 0x41a5ea37b92e2944
d_5_0:          .dword 0xfe57e562ac517369, 0x2ff05a9783743ca5
d_5_1:          .dword 0x48ef07a10619ff3f, 0xe008077eb9bcb8d8
d_5_2:          .dword 0x94f2ecd06814be76, 0xc14804600386431b
d_5_3:          .dword 0x726182a56900f653, 0xb5977c28691cd23b
d_5_4:          .dword 0x7985e329d6a8cfe9, 0x3d2e344dc74b7289
d_5_5:          .dword 0xcb0dde94c176e6b3, 0x966c9d6448cab4b5
d_5_6:          .dword 0x885f836d221ba7a2, 0x3a4dd5193257dfc2
d_5_7:          .dword 0x809c5079df5aed92, 0xf21ffb7caa480cce
d_5_8:          .dword 0xf5af0e107e430175, 0x113930ca029dc8bb
d_5_9:          .dword 0x9c60036b93bc23a4, 0x63f37646a2331680
d_5_10:         .dword 0xef5563438edd9ea9, 0xa93296fa1b824ef1
d_5_11:         .dword 0xa2f12144779d2514, 0x1367565960d7c28f
d_5_12:         .dword 0xf30eb08d5b26b336, 0x674515a3d8032350
d_5_13:         .dword 0xcad32871448ee97c, 0x74fafc1be07f85cf
d_5_14:         .dword 0x1b962cbe7d2c2fc0, 0x4499a5479002269a
d_5_15:         .dword 0xa523a561e7fcf294, 0x0686ce351a7a9461
d_5_16:         .dword 0x61b9596e8c4e89c7, 0xb9a9f25897b891d8
d_5_17:         .dword 0xad65f96043e0cc89, 0x33724b4d52167480
d_5_18:         .dword 0xfdeb32c744e60712, 0x1a36d148155593f5
d_5_19:         .dword 0x5601b2cf013fefdc, 0xda6372741bc5ab8f
d_5_20:         .dword 0xc424b2c83d42301e, 0x779297d975861437
d_5_21:         .dword 0x83c7229954af6fdf, 0x9d8d8e9a0eddda2f
d_5_22:         .dword 0xdc0eb42e709e5de4, 0x78c80e5774e95c16
d_5_23:         .dword 0x5eee8e71e19633ff, 0x1d3a710b51dc512f
d_5_24:         .dword 0x88fd70503c585bc7, 0x074b0a39aea518aa
d_5_25:         .dword 0x2db29520ce669621, 0x621ab5baeb505f47
d_5_26:         .dword 0xd01b0c1d595a5d08, 0x9c15450568a1d967
d_5_27:         .dword 0xcac1837a820fbf9c, 0x13bc3256a0f61033
                .dword 0x6cf11f8d35ee02f0, 0xd6b345f15c776a6d
                .dword 0x2eefab32ad211f84, 0x6f42802f6bb820f4
         /* Random data */
_end_data5:
              
                 
