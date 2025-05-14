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
_s0:    fclass.s x15, f23                         ;
_s1:    la x18, d_5_18                            ;
        lui x7, 0xffe00                           ;
        xor x18, x18, x7                          ;
        sd x19, -0(x18)                           ;
_s2:    ori x25, x5, 10                           ;
_s3:    fmv.x.w x30, f29                          ;
_s4:    csrrci x5, pmpcfg0, 2                     ;
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
_p0:    csrrwi x14, sip, 31                       ;
_p1:    csrrsi x10, pmpaddr0, 0                   ;
_p2:    csrrwi x13, stval, 2                      ;
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
_l0:    la x27, d_1_1                             ;
        addi x27, x27, 0                          ;
        amomax.d x14, x27, (x27)                  ;
_l1:    fsgnjx.s f2, f29, f2                      ;
_l2:    fcvt.wu.s x28, f26, rne                   ;
_l3:    fmadd.s f2, f0, f14, f26, rne             ;
_l4:    la x26, d_0_12                            ;
        sh x25, -2(x26)                           ;
_l5:    xor x6, x6, x6                            ;
        addi x13, zero, 3                         ;
        slli x13, x13, 17                         ;
        add x6, x6, x13                           ;
        addi x11, zero, 1                         ;
        slli x11, x11, 5                          ;
        add x6, x6, x11                           ;
        csrrs x2, satp, x6                        ;
_l6:    la x4, d_0_11                             ;
        lw x10, -8(x4)                            ;
_l7:    sret                                      ;
_l8:    fmul.s f26, f29, f1, rne                  ;
_l9:    fmsub.s f24, f6, f24, f12, rne            ;
_l10:   csrrci x11, pmpaddr7, 0                   ;
_l11:   la x27, d_2_18                            ;
        lw x13, 20(x27)                           ;
_l12:   la x11, d_0_6                             ;
        addi x11, x11, -16                        ;
        amomin.w x6, x25, (x11)                   ;
_l13:   la x30, d_2_26                            ;
        addi x30, x30, -8                         ;
        amoadd.d x5, x7, (x30)                    ;
_l14:   slli x27, x5, 27                          ;
_l15:   la x26, d_2_2                             ;
        addi x26, x26, 0                          ;
        sc.d x2, x26, (x26)                       ;
_l16:   flt.s x18, f14, f26                       ;
_l17:   fmul.s f12, f19, f1, rne                  ;
_l18:   fnmadd.s f19, f4, f13, f4, rne            ;
_l19:   la x24, d_1_8                             ;
        srai x24, x24, 1                          ;
        csrrw x28, pmpaddr3, x24                  ;
_l20:   la x24, d_4_21                            ;
        addi x24, x24, 8                          ;
        amoand.d x10, x19, (x24)                  ;
_l21:   fmax.s f3, f26, f11                       ;
_l22:   xor x16, x16, x16                         ;
        addi x8, zero, 1                          ;
        slli x8, x8, 3                            ;
        add x16, x16, x8                          ;
        addi x18, zero, 1                         ;
        slli x18, x18, 28                         ;
        add x16, x16, x18                         ;
        addi x30, zero, 3                         ;
        slli x30, x30, 8                          ;
        add x16, x16, x30                         ;
        csrrs x28, sscratch, x16                  ;
_l23:   srli x28, x2, 52                          ;
_l24:   ori x0, x6, 594                           ;
_l25:   la x26, d_5_14                            ;
        addi x26, x26, 12                         ;
        amomax.w x30, x8, (x26)                   ;
_l26:   ori x19, x30, 418                         ;
_l27:   fcvt.s.l f14, x30, rne                    ;
_l28:   addi x21, x12, 8                          ;
_l29:   fnmsub.s f22, f24, f5, f13, rne           ;
_l30:   srai x15, x30, 17                         ;
_l31:   la x27, d_2_19                            ;
        lhu x13, -2(x27)                          ;
_l32:   fsqrt.s f13, f23, rne                     ;
_l33:   fsgnjx.s f22, f14, f22                    ;
_l34:   la x11, d_1_24                            ;
        lw x5, -4(x11)                            ;
_l35:   fadd.s f10, f20, f8, rne                  ;
_l36:   fcvt.l.s x25, f14, rne                    ;
_l37:   addiw x30, x12, -52                       ;
_l38:   slliw x23, x25, 15                        ;
_l39:   fsqrt.s f3, f15, rne                      ;
_l40:   la x25, d_0_18                            ;
        addi x25, x25, 8                          ;
        amominu.d x20, x10, (x25)                 ;
_l41:   sraw x30, x6, x8                          ;
_l42:   fmv.w.x f13, x2                           ;
_l43:   sraiw x28, x15, 31                        ;
_l44:   la x2, d_3_25                             ;
        addi x2, x2, -0                           ;
        lr.d x12, (x2)                            ;
_l45:   la x15, d_1_0                             ;
        addi x15, x15, -24                        ;
        lui x17, 0xffe00                          ;
        xor x15, x15, x17                         ;
        amomin.d x27, x17, (x15)                  ;
_l46:   la x24, d_4_4                             ;
        addi x24, x24, 12                         ;
        amomin.w x15, x14, (x24)                  ;
_l47:   xor x17, x17, x17                         ;
        addi x19, zero, 3                         ;
        slli x19, x19, 31                         ;
        add x17, x17, x19                         ;
        csrrc x8, sstatus, x17                    ;
_l48:   slti x20, x2, 17                          ;
_l49:   srlw x3, x7, x3                           ;
_l50:   la x22, d_0_12                            ;
        addi x22, x22, -8                         ;
        amomin.w x15, x3, (x22)                   ;
_l51:   la x25, d_5_25                            ;
        flw f6, -28(x25)                          ;
_l52:   csrrci x23, sstatus, 13                   ;
_l53:   fcvt.lu.s x21, f12, rne                   ;
_l54:   slliw x24, x16, 2                         ;
_l55:   sltiu x22, x20, -0                        ;
_l56:   fcvt.s.w f22, x12, rne                    ;
_l57:   fcvt.s.lu f31, x17, rne                   ;
_l58:   xor x1, x1, x1                            ;
        addi x25, zero, 3                         ;
        slli x25, x25, 10                         ;
        add x1, x1, x25                           ;
        addi x6, zero, 3                          ;
        slli x6, x6, 23                           ;
        add x1, x1, x6                            ;
        csrrc x13, stval, x1                      ;
_l59:   la x14, d_5_7                             ;
        lw x29, 20(x14)                           ;
_l60:   fnmadd.s f30, f15, f22, f22, rne          ;
_l61:   fle.s x27, f8, f31                        ;
_l62:   fnmadd.s f3, f4, f23, f26, rne            ;
_l63:   fcvt.wu.s x19, f14, rne                   ;
_l64:   la x12, d_3_5                             ;
        lhu x11, -26(x12)                         ;
_l65:   la x24, d_0_20                            ;
        addi x24, x24, 8                          ;
        amominu.d x2, x29, (x24)                  ;
_l66:   srli x4, x10, 62                          ;
_l67:   fcvt.l.s x16, f2, rne                     ;
_l68:   fsqrt.s f23, f2, rne                      ;
_l69:   srliw x20, x22, 4                         ;
_l70:   fcvt.s.w f28, x29, rne                    ;
_l71:   fcvt.s.w f22, x30, rne                    ;
_l72:   li x20, 0                                 ;
        la x12, pt2                               ;
        addi x12, x12, 32                         ;
        sfence.vma x20, x12                       ;
_l73:   sraiw x13, x12, 1                         ;
_l74:   la x29, d_3_10                            ;
        addi x29, x29, -16                        ;
        amoor.d x23, x30, (x29)                   ;
_l75:   la x19, d_0_12                            ;
        sb x9, 22(x19)                            ;
_l76:   srai x0, x26, 1                           ;
_l77:   fcvt.lu.s x11, f24, rne                   ;
_l78:   subw x16, x19, x20                        ;
_l79:   srli x8, x29, 3                           ;
_l80:   srlw x16, x26, x5                         ;
_l81:   la x15, d_3_13                            ;
        lb x27, -18(x15)                          ;
_l82:   la x23, d_4_10                            ;
        addi x23, x23, 8                          ;
        amoand.w x13, x18, (x23)                  ;
_l83:   fsub.s f4, f5, f23, rne                   ;
_l84:   sltiu x15, x12, 1115                      ;
_l85:   feq.s x14, f15, f25                       ;
_l86:   csrrci x26, sepc, 10                      ;
_l87:   la x28, d_1_15                            ;
        addi x28, x28, 28                         ;
        amoadd.w x13, x28, (x28)                  ;
_l88:   xor x1, x1, x1                            ;
        addi x11, zero, 1                         ;
        slli x11, x11, 28                         ;
        add x1, x1, x11                           ;
        addi x14, zero, 3                         ;
        slli x14, x14, 13                         ;
        add x1, x1, x14                           ;
        csrrs x20, satp, x1                       ;
_l89:   sltiu x29, x2, 2047                       ;
_l90:   la x29, d_0_25                            ;
        addi x29, x29, 0                          ;
        amomin.w x29, x28, (x29)                  ;
_l91:   auipc x18, 47874                          ;
_l92:   la x19, d_0_4                             ;
        addi x19, x19, -12                        ;
        amoor.w x30, x18, (x19)                   ;
_l93:   sltiu x29, x6, -158                       ;
_l94:   srlw x7, x6, x10                          ;
_l95:   la x16, d_2_17                            ;
        addi x16, x16, -24                        ;
        lui x5, 0xffe00                           ;
        xor x16, x16, x5                          ;
        amomaxu.d x9, x5, (x16)                   ;
_l96:   la x22, d_3_14                            ;
        addi x22, x22, 8                          ;
        amoswap.d x2, x6, (x22)                   ;
_l97:   la x16, d_4_25                            ;
        addi x16, x16, -20                        ;
        amoor.w x14, x2, (x16)                    ;
_l98:   csrrsi x5, stval, 9                       ;
_l99:   sret                                      ;
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
                .dword 0x514ecb6ca8dc2ab3, 0x7f23e8787f1b5a71
                .dword 0x9f0edde3e5e6815c, 0x0b6adf2ab1c12e33
d_0_0:          .dword 0x1c37731e46ee5f63, 0x7e62575d968c413a
d_0_1:          .dword 0xda4be3f1106b3c09, 0x46e7aa596bbf9d94
d_0_2:          .dword 0x846a8cdea7de2e2e, 0x29989b8dfc3afc04
d_0_3:          .dword 0x826043d03b0fd699, 0x4ebee65b7e490de4
d_0_4:          .dword 0x3a63570bedbc0476, 0xc04c04a73de53128
d_0_5:          .dword 0xc04df71f7acdf97d, 0x2c0dcc68eb6c3d58
d_0_6:          .dword 0xb87966e7e3785b38, 0x0e8798eea4fbc45e
d_0_7:          .dword 0x7bfd7efaecd66889, 0x01e595aa49d6f704
d_0_8:          .dword 0x86071f40664ca772, 0xfb31ad24ad8dca80
d_0_9:          .dword 0x4b36e298774ea5ae, 0x107fb2136c983999
d_0_10:         .dword 0x3c81214c4d35869c, 0x2d1e0e72d516a8e0
d_0_11:         .dword 0xba462ee6dcd4242e, 0x7ca1feb16448b01e
d_0_12:         .dword 0x8a9aa092f1bac04d, 0xebfccbf23eebdf5b
d_0_13:         .dword 0x5b373651c5ecc888, 0x1383b834dc1d1762
d_0_14:         .dword 0x877a8e137ed32bb6, 0xd493ff9479c73159
d_0_15:         .dword 0xdc4546de6b993359, 0x54e1004f799e00b6
d_0_16:         .dword 0x8a01533bae87c6d2, 0x14fa1d736e4ba2db
d_0_17:         .dword 0x5215f39667f219bb, 0x2ca4636ef6f73849
d_0_18:         .dword 0x84be7d970baf759b, 0x0b17490fdbeb9967
d_0_19:         .dword 0xb175a80d19595b0c, 0x49b17cd9153df65b
d_0_20:         .dword 0x14d208f1bce7c27a, 0xac245cd0438d5156
d_0_21:         .dword 0x2e06e73389c14ad6, 0x72acbefca4db295c
d_0_22:         .dword 0x7c7d54aff5bf94a2, 0x6e72c08b980e8b3d
d_0_23:         .dword 0xa74d61473d0d4945, 0xc1130219c4262246
d_0_24:         .dword 0x06c1ac90bd9720ab, 0xd60b156206713913
d_0_25:         .dword 0xb5dc22347fb1258e, 0x2e90b980a9294c58
d_0_26:         .dword 0x0b2a84a2348f21eb, 0x1e4a6a97f661e8d7
d_0_27:         .dword 0x9dbf2fa0767dd328, 0x681313da3e07da34
                .dword 0x6db4526200c3e295, 0x64309bbd91244206
                .dword 0x455eda21a434ad3e, 0x5805e700751217f8
        /* Random data */
_end_data0:
                 

    .section .data.random1;
    .align  8;

_random_data1:
                .dword 0x20ad1366f67aafe9, 0xea92515e20084d79
                .dword 0xaa498c2071868972, 0x133aa3ff92c40d29
d_1_0:          .dword 0x5c161c5c4ffadf03, 0xfe04eb4d520066f5
d_1_1:          .dword 0x3820fe70bebe66b5, 0x94d1cb74b5bcd405
d_1_2:          .dword 0xed2e6268f16b5245, 0x512763c7f1cd4947
d_1_3:          .dword 0xe5c78c22825048bd, 0xccad994816c67083
d_1_4:          .dword 0xb00149196194466f, 0xc537e3363e89cc68
d_1_5:          .dword 0xa6fe82c11a17c912, 0xf9b973b75ecba7a3
d_1_6:          .dword 0xb8d598eca2d3a535, 0x285b6fd3b581801b
d_1_7:          .dword 0x5c13167bcc6abdae, 0x1b7478353d30e505
d_1_8:          .dword 0xf565a358a0768592, 0xfde3fc33a94cd4e6
d_1_9:          .dword 0x39d3cd165a794c9b, 0xf9af707580e91aae
d_1_10:         .dword 0x67557d538e4f93fc, 0x8f8b0d8ea06048eb
d_1_11:         .dword 0x11d4849efac7b109, 0xfae1e1ed54cf5c73
d_1_12:         .dword 0x1f2f960008a6c856, 0x17b539c8c9d6f738
d_1_13:         .dword 0x7d4225baf5d420be, 0x041859fa662ddd1c
d_1_14:         .dword 0x7d9d3e5be6e4d61c, 0x804e5770845e2413
d_1_15:         .dword 0xd4eb3e29ad82855e, 0x331bf0e1db28b24f
d_1_16:         .dword 0xc742f1fbf5e64de7, 0x8435323f29bb0d32
d_1_17:         .dword 0x330fda624d634313, 0xaa8fccc243765e77
d_1_18:         .dword 0xe106318d4b9fcb5d, 0x84ec14edaadf8533
d_1_19:         .dword 0x5ce6049f7d135de9, 0x990cc5deaee7083c
d_1_20:         .dword 0x38f0f7efff00a949, 0x89b9e18822021480
d_1_21:         .dword 0xa6710e45bfa6b65c, 0xbdc6413158e89dba
d_1_22:         .dword 0x095094e3a39c9e19, 0x1b109c7bb4fdac52
d_1_23:         .dword 0xdc8c161572284821, 0x2f521c6f736a8bb4
d_1_24:         .dword 0x5ec3767b6c5d3124, 0xd50890ee17b3c4ac
d_1_25:         .dword 0x40b10c4794aedeb2, 0xac5567b4e3fc31d8
d_1_26:         .dword 0x94d930fea59cf95a, 0xead94a3bb9d60468
d_1_27:         .dword 0x1d726968460c5db8, 0xd24fc2e0eac2b29b
                .dword 0x8cb54420929930d1, 0x77e3385434012aa0
                .dword 0x33e4028c307a7af3, 0xb1d20736a18a0941
        /* Random data */
_end_data1:


    .section .data.random2;
    .align  8;

_random_data2:
                .dword 0x9a40678ccdbb7c78, 0x3b9b0b4558359227
                .dword 0x9374ce4c7b5e615a, 0x56b68b639bd18ac4
d_2_0:          .dword 0xd17de6dc5d23aef7, 0xefaa865348e252b2
d_2_1:          .dword 0xc35bf53483278ed7, 0xfac0b007644221ea
d_2_2:          .dword 0x2e7d9a0a699da770, 0xa4585d1ea98d9e3b
d_2_3:          .dword 0x7568c2824b547b0f, 0xa5d1ed89825f723f
d_2_4:          .dword 0x9e6047145e679932, 0x9a4e49de4276b4fc
d_2_5:          .dword 0x0938a4d7631714ea, 0x82e71e1146a4e8ce
d_2_6:          .dword 0x69e12f3b430407e1, 0x8f8080857791bf81
d_2_7:          .dword 0x66b446af90cb2069, 0x421ce6f8a5383f39
d_2_8:          .dword 0xd81228591afbdf45, 0xe7fcde92f1b81cf1
d_2_9:          .dword 0xd6bd42ba8343cc6f, 0xda6aee1adcb13030
d_2_10:         .dword 0x72c1f452dccbcce5, 0xb38b63c485e2258b
d_2_11:         .dword 0xd3d77d270a2a86d7, 0xa97a24f09e516468
d_2_12:         .dword 0xdded3d315872982e, 0x58fb65970133e71a
d_2_13:         .dword 0x5d8f5f66db2666ab, 0x1f3e567dbf97acdb
d_2_14:         .dword 0x6816552ae486e0a4, 0xcb3959f449b557fe
d_2_15:         .dword 0x0475afab01eca862, 0x218e1ca798bf8826
d_2_16:         .dword 0x77a8c1f332c5eea7, 0xc94e7bb472b5942c
d_2_17:         .dword 0x6e109678a7a2a283, 0xe782337775653018
d_2_18:         .dword 0x6676fe5b9aba8a23, 0xa5cb747c875d2492
d_2_19:         .dword 0xc516110a71fc1f09, 0xc27d176598e2ae15
d_2_20:         .dword 0x995d5b35fe454ce7, 0x1dd067836a5cf82a
d_2_21:         .dword 0xf6c7b41ddb18b3e7, 0x9ecbef8be907600c
d_2_22:         .dword 0x6e1279cece0e86c0, 0x873a96a247a3f754
d_2_23:         .dword 0x66a65f72bba6f234, 0x7cb6da80b93f9a97
d_2_24:         .dword 0xce4b4558d1cc1321, 0x2fd4354c659a195b
d_2_25:         .dword 0x23f7fd32fe895509, 0x78fc2208970bde9f
d_2_26:         .dword 0xb580a28d5758e233, 0xa4a8830e40a42a8e
d_2_27:         .dword 0x8cdc1cee5217b6a8, 0x21c1f97b66761adb
                .dword 0x5c436c366ce3a7a1, 0xcf0988c14a55e85d
                .dword 0xe196a4d0fa455e84, 0x8da3d18d2504a2c0
         /* Random data */
_end_data2:
                

    .section .data.random3;
    .align  8;

_random_data3:
                .dword 0x38bc9ae913d48d7a, 0x7e8a76be7a64307a
                .dword 0xfb534f36307a7058, 0x76ff8fad4ec68be6
d_3_0:          .dword 0xfee855f338db3bda, 0x56b161ed44a46c5b
d_3_1:          .dword 0xa0c1204c6b43dcc3, 0x333ae4d8f7d97c13
d_3_2:          .dword 0x5891c7eb1266558f, 0x1dc78958689a1ae4
d_3_3:          .dword 0x36587db2a0e6ac12, 0x33dc77e4c6cfc59b
d_3_4:          .dword 0x6b02ed98d4d19710, 0xa26c54626daf04d8
d_3_5:          .dword 0xa0d0f6d6e94bede2, 0xfcc87ed65e9d76ea
d_3_6:          .dword 0x926d9e6a10d15f25, 0xf03ce93d65180c65
d_3_7:          .dword 0xb5bf88714a7f881d, 0x215886d9b1dafa74
d_3_8:          .dword 0x9fa436c4b69ccd3b, 0xdc3fb98c3b8514b9
d_3_9:          .dword 0x43ccbc72700b57dc, 0x2e9206690a8773e4
d_3_10:         .dword 0xab86f38447fcb0f4, 0x942b52a433886874
d_3_11:         .dword 0x30ae5435c28e8eaa, 0x3b25a6a3bbd272c6
d_3_12:         .dword 0x383cd1c6a85ea6e7, 0xb5b35f39786c5bbf
d_3_13:         .dword 0x35cabce11b70480d, 0x7b736293fac54267
d_3_14:         .dword 0x8a2f9db319b1d042, 0x0db4b3a3c52fb3cf
d_3_15:         .dword 0xe09fc2f8b7e94324, 0x0ed35295d58f75c2
d_3_16:         .dword 0xb7e7360e60b89cdf, 0xf783c621e1bbac05
d_3_17:         .dword 0x5e7647f521ce4732, 0x8825a1107ea10135
d_3_18:         .dword 0x8cde52de8193abcf, 0xb6c5d1c23ff9696c
d_3_19:         .dword 0x2bb5ca5811eef7c8, 0x65559119a95f97da
d_3_20:         .dword 0x575274a8e520cfcc, 0x7bfe77d63e2fe553
d_3_21:         .dword 0x3b2b1502fbaa345d, 0x9a10c154eaa7f26f
d_3_22:         .dword 0xf1248e1f9ef0099f, 0x48f8b83fd44a218b
d_3_23:         .dword 0x100600b112f9328b, 0x693a1444e5ae125e
d_3_24:         .dword 0x6e968f6963bffb83, 0xc3c65ca80ce42fc4
d_3_25:         .dword 0xf202e9d49ec71376, 0x530d3e02d450b78f
d_3_26:         .dword 0x50ead79ca10fd3d3, 0x6df58651c9db243f
d_3_27:         .dword 0x8a85840e011c68ee, 0x5d64ef3ae6275acd
                .dword 0x5a17af1196bf88e5, 0xe40e070e4d88590e
                .dword 0x0853bd583acd592a, 0x79818b1aed1d9153
        /* Random data */
_end_data3:


    .section .data.random4;
    .align  8;

_random_data4:
                .dword 0x83f3d196f5aeedfb, 0xccec36c88941eaad
                .dword 0x91134d869a46b374, 0xb2f0d7f14bc7d085
d_4_0:          .dword 0x95e33c667d3aa044, 0xdca94cf1dd1c8b87
d_4_1:          .dword 0xb1ef1c3f3da09495, 0x4baca3ffebbb5c2a
d_4_2:          .dword 0x684a7ed952bb5781, 0xbe2744eb03c94ae5
d_4_3:          .dword 0x294c77a6da9fa0ae, 0xd07e5ca3b801848e
d_4_4:          .dword 0x190f15061ad14dc8, 0x85236e2980d00998
d_4_5:          .dword 0x2c97c3a3010d0e33, 0x0701391e4732e11f
d_4_6:          .dword 0x6a436eed71835cb9, 0x43dd4d0cc2596e12
d_4_7:          .dword 0x6591c5a4b1706526, 0x93b199b866caa100
d_4_8:          .dword 0x8516046517ffab21, 0x38c3d4aa0a3582f7
d_4_9:          .dword 0x1a0cc140325a8b46, 0xf5a3a99cb018a763
d_4_10:         .dword 0xbe7eaacac33bcfac, 0x88887fbf05ee0b2a
d_4_11:         .dword 0x6d6256b47e528db7, 0xdd66c2e972c61925
d_4_12:         .dword 0xb600fc04f5aab560, 0xf4b5cf84f545aae6
d_4_13:         .dword 0x5dd208b1fdf90de7, 0x3887d8dcc52dedc0
d_4_14:         .dword 0xe01cec05602144ac, 0xe3d6d469e3efd6db
d_4_15:         .dword 0x070379f219d754d9, 0x5b96bfe16ac72b96
d_4_16:         .dword 0x20859afd3ca0c663, 0x48eb863381dbc573
d_4_17:         .dword 0xdb02890c3537fcc2, 0xfc89d53e5d5a0840
d_4_18:         .dword 0x9917fc006587dfc3, 0x928116545c9c4350
d_4_19:         .dword 0x2ab7a6eebab5cc1f, 0xf0f02388c591ce9d
d_4_20:         .dword 0x8e20aaaf4a07ec5a, 0xa3d21b24560adaf3
d_4_21:         .dword 0x262a8aa9da9df602, 0x9da18bfabd3888f6
d_4_22:         .dword 0xdc5298fa194eafd7, 0xdf19ed66f75a37ce
d_4_23:         .dword 0xcc6651cfbfc7684e, 0x22eb2f0e4a75985d
d_4_24:         .dword 0x12a9f7e9e09e035a, 0x9245dc4c13d80bf6
d_4_25:         .dword 0x58936654d5abfa02, 0x04cef3e952c65b19
d_4_26:         .dword 0xc822d6285a9f7f0d, 0x582d56490342507d
d_4_27:         .dword 0x8b7f372ef8be26eb, 0x2fdf7eb4e631af3f
                .dword 0x2433cd03d2fa5307, 0xab69487e0b063eba
                .dword 0x64869902605b0cd2, 0x64f34af590566b42
        /* Random data */
_end_data4:


    .section .data.random5;
    .align  8;

_random_data5:
                .dword 0xe43854c008a02b8c, 0xe1d9f51f289261a4
                .dword 0xde30958916c23917, 0x35e4b7d1b1b82dee
d_5_0:          .dword 0xb302d00fbac8607a, 0x6ecaa1e051615cf9
d_5_1:          .dword 0x7fadfec4806cf588, 0x0b0e9c2851de088e
d_5_2:          .dword 0x9f9db679c716b4a9, 0x6cfb55576a0d0fc1
d_5_3:          .dword 0xa1fb2b9dffc82f14, 0x5888de442a80b526
d_5_4:          .dword 0x1d81ea03ec463c17, 0x224b9f62e6a50d67
d_5_5:          .dword 0x63d21388175939aa, 0x7375ecd4813e592a
d_5_6:          .dword 0x3d5e70b538f167ed, 0x35d97c62a28ac59e
d_5_7:          .dword 0x760a0731ddf2e814, 0x8e60cbac955699a6
d_5_8:          .dword 0xa1163bed02b7e7b3, 0xef52f6dfe3f31bd6
d_5_9:          .dword 0xfdf216f43e815823, 0xaa3f0b5e1f1a10e0
d_5_10:         .dword 0xc422bfb072fbc798, 0x0b96b205d84c98e4
d_5_11:         .dword 0xecddd6bdba54d88c, 0x7533affa0cb954d8
d_5_12:         .dword 0xa533ced68275d824, 0x33c70ad47cc61557
d_5_13:         .dword 0xaa024bb990d24eb1, 0xece321d69c2e13a2
d_5_14:         .dword 0xcd408f30a36d1a7b, 0x4f2621cc1bd9eb90
d_5_15:         .dword 0x7ef4fbe2b6d4c076, 0x85f86dee540ff76f
d_5_16:         .dword 0x7a2fb4c18deefd58, 0x645d418dc883f421
d_5_17:         .dword 0x152b29ecdb30c42f, 0x3d10e6b29f92b070
d_5_18:         .dword 0x1d61ec9b0da49657, 0xef2324bdb6203ee2
d_5_19:         .dword 0x0ab59043c9179ce5, 0xc925c631e2e5ad1c
d_5_20:         .dword 0x82c57a370602a745, 0x190bbd85806b276b
d_5_21:         .dword 0xe4ee32e7e14261dc, 0x4906144fbc0f0afe
d_5_22:         .dword 0x977052d4528d4509, 0xb1601139d0cb8bbd
d_5_23:         .dword 0xed24100aacbb9df2, 0x8a6fbaa6af06af77
d_5_24:         .dword 0x1bf3cc948f0748c9, 0x5dfbb8b9b388615c
d_5_25:         .dword 0x2e9d22cd4963f959, 0x2938ac521bc13eab
d_5_26:         .dword 0x68060fe34c623ecb, 0xb7dbda93328be3f0
d_5_27:         .dword 0x289839b62099e31b, 0x194ffb9c479fb8ca
                .dword 0x943150105ff5e5e7, 0x552ad258a329cb5f
                .dword 0x379bc58bb35cec93, 0x7bfacb3d69419979
         /* Random data */
_end_data5:
              
