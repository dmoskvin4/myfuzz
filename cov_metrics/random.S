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
_p0:    csrrwi x14, pmpaddr2, 0                   ;
_p1:    xor x10, x10, x10                         ;
        addi x14, zero, 1                         ;
        slli x14, x14, 28                         ;
        add x10, x10, x14                         ;
        csrrw x14, stval, x10                     ;
_p2:    la x10, d_1_9                             ;
        srai x10, x10, 1                          ;
        csrrs x14, pmpaddr7, x10                  ;
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
_l0:    la x12, d_0_17                            ;
        addi x12, x12, -28                        ;
        amoand.w x1, x9, (x12)                    ;
_l1:    slli x27, x27, 13                         ;
_l2:    slti x16, x27, 13                         ;
_l3:    la x10, d_5_20                            ;
        sh x14, -6(x10)                           ;
_l4:    la x14, d_3_7                             ;
        addi x14, x14, 24                         ;
        lui x1, 0xffe00                           ;
        xor x14, x14, x1                          ;
        sc.d x15, x14, (x14)                      ;
_l5:    fclass.s x6, f6                           ;
_l6:    subw x13, x3, x9                          ;
_l7:    la x17, d_2_27                            ;
        sb x13, -0(x17)                           ;
_l8:    slti x3, x13, 912                         ;
_l9:    addw x16, x24, x13                        ;
_l10:   subw x23, x21, x26                        ;
_l11:   fmsub.s f17, f24, f17, f17, rne           ;
_l12:   uret                                      ;
_l13:   la x20, d_3_2                             ;
        sd x29, 0(x20)                            ;
_l14:   la x7, d_1_20                             ;
        addi x7, x7, 0                            ;
        lr.d x7, (x7)                             ;
_l15:   la x26, _l86                              ;
        lb x11, 31(x26)                           ;
_l16:   fclass.s x3, f15                          ;
_l17:   la x15, d_1_12                            ;
        addi x15, x15, 16                         ;
        amomaxu.w x8, x18, (x15)                  ;
_l18:   fcvt.l.s x6, f27, rne                     ;
_l19:   la x15, d_1_26                            ;
        addi x15, x15, -0                         ;
        amominu.w x10, x20, (x15)                 ;
_l20:   fsub.s f4, f4, f6, rne                    ;
_l21:   fcvt.s.lu f3, x15, rne                    ;
_l22:   la x7, d_2_23                             ;
        srai x7, x7, 1                            ;
        csrrc x15, pmpaddr3, x7                   ;
_l23:   sraiw x22, x24, 19                        ;
_l24:   sraiw x10, x24, 0                         ;
_l25:   slliw x21, x30, 6                         ;
_l26:   fle.s x17, f1, f2                         ;
_l27:   la x30, d_2_14                            ;
        sd x17, -8(x30)                           ;
_l28:   fsqrt.s f25, f25, rne                     ;
_l29:   la x9, d_4_19                             ;
        lb x5, 17(x9)                             ;
_l30:   la x30, d_0_13                            ;
        addi x30, x30, 4                          ;
        amomax.w x26, x20, (x30)                  ;
_l31:   la x26, d_3_10                            ;
        lui x30, 0xffe00                          ;
        xor x26, x26, x30                         ;
        lb x13, 7(x26)                            ;
_l32:   la x13, d_3_14                            ;
        addi x13, x13, -0                         ;
        amomax.w x12, x28, (x13)                  ;
_l33:   la x11, d_1_6                             ;
        sh x30, 12(x11)                           ;
_l34:   sraw x25, x8, x24                         ;
_l35:   la x3, d_4_8                              ;
        addi x3, x3, -8                           ;
        lui x10, 0xffe00                          ;
        xor x3, x3, x10                           ;
        amomax.d x24, x10, (x3)                   ;
_l36:   xori x3, x0, 0                            ;
_l37:   la x24, _l51                              ;
        lbu x4, 28(x24)                           ;
_l38:   fcvt.s.l f26, x3, rne                     ;
_l39:   la x23, d_3_0                             ;
        sh x18, 0(x23)                            ;
_l40:   la x16, d_3_8                             ;
        addi x16, x16, -8                         ;
        amoor.d x7, x6, (x16)                     ;
_l41:   la x14, d_3_1                             ;
        addi x14, x14, -8                         ;
        amoadd.d x11, x1, (x14)                   ;
_l42:   flt.s x0, f27, f15                        ;
_l43:   la x17, d_1_4                             ;
        sb x1, -31(x17)                           ;
_l44:   la x21, d_4_7                             ;
        addi x21, x21, -8                         ;
        amoswap.d x22, x17, (x21)                 ;
_l45:   fmsub.s f27, f15, f18, f24, rne           ;
_l46:   fdiv.s f1, f22, f14, rne                  ;
_l47:   fdiv.s f2, f22, f6, rne                   ;
_l48:   fmsub.s f22, f25, f5, f14, rne            ;
_l49:   fmsub.s f7, f2, f25, f14, rne             ;
_l50:   addiw x5, x8, -2034                       ;
_l51:   fdiv.s f6, f7, f15, rne                   ;
_l52:   fcvt.lu.s x6, f21, rne                    ;
_l53:   la x17, _l4                               ;
        ld x25, -24(x17)                          ;
_l54:   la x10, d_5_3                             ;
        lb x8, -31(x10)                           ;
_l55:   la x11, d_0_3                             ;
        addi x11, x11, -0                         ;
        amomaxu.w x20, x10, (x11)                 ;
_l56:   fmadd.s f17, f12, f31, f27, rne           ;
_l57:   fadd.s f30, f18, f26, rne                 ;
_l58:   la x23, d_1_0                             ;
        addi x23, x23, 24                         ;
        amoswap.d x22, x19, (x23)                 ;
_l59:   fcvt.s.l f8, x23, rne                     ;
_l60:   fmadd.s f19, f3, f18, f1, rne             ;
_l61:   la x12, d_0_10                            ;
        addi x12, x12, 24                         ;
        sc.d x1, x12, (x12)                       ;
_l62:   fcvt.wu.s x23, f4, rne                    ;
_l63:   feq.s x7, f19, f25                        ;
_l64:   fsgnjx.s f8, f27, f20                     ;
_l65:   xor x28, x28, x28                         ;
        addi x15, zero, 3                         ;
        slli x15, x15, 19                         ;
        add x28, x28, x15                         ;
        addi x18, zero, 1                         ;
        slli x18, x18, 29                         ;
        add x28, x28, x18                         ;
        csrrs x13, satp, x28                      ;
_l66:   xor x24, x24, x24                         ;
        csrrw x7, sstatus, x24                    ;
_l67:   fsgnj.s f31, f20, f18                     ;
_l68:   sraiw x24, x26, 14                        ;
_l69:   fdiv.s f5, f28, f18, rne                  ;
_l70:   fnmsub.s f21, f26, f23, f15, rne          ;
_l71:   fmv.x.w x16, f29                          ;
_l72:   la x3, d_2_16                             ;
        addi x3, x3, 28                           ;
        sc.w x14, x13, (x3)                       ;
_l73:   fsgnj.s f4, f18, f5                       ;
_l74:   xor x18, x18, x18                         ;
        csrrw x17, sscratch, x18                  ;
_l75:   la x14, d_0_3                             ;
        addi x14, x14, -28                        ;
        amoor.w x13, x30, (x14)                   ;
_l76:   la x28, d_1_27                            ;
        addi x28, x28, -28                        ;
        amominu.w x17, x28, (x28)                 ;
_l77:   fcvt.lu.s x25, f18, rne                   ;
_l78:   la x13, d_1_9                             ;
        addi x13, x13, -16                        ;
        amoxor.w x18, x10, (x13)                  ;
_l79:   fsqrt.s f24, f9, rne                      ;
_l80:   flt.s x21, f29, f28                       ;
_l81:   sltiu x28, x23, -2047                     ;
_l82:   la x29, d_0_20                            ;
        lb x27, 22(x29)                           ;
_l83:   fmin.s f20, f30, f6                       ;
_l84:   mret                                      ;
_l85:   fsgnj.s f0, f4, f10                       ;
_l86:   la x11, d_4_13                            ;
        lhu x28, 26(x11)                          ;
_l87:   la x26, d_5_14                            ;
        addi x26, x26, -24                        ;
        lr.w x29, (x26)                           ;
_l88:   fmul.s f0, f15, f12, rne                  ;
_l89:   xor x5, x5, x5                            ;
        addi x26, zero, 1                         ;
        slli x26, x26, 15                         ;
        add x5, x5, x26                           ;
        addi x25, zero, 3                         ;
        slli x25, x25, 30                         ;
        add x5, x5, x25                           ;
        addi x3, zero, 1                          ;
        slli x3, x3, 29                           ;
        add x5, x5, x3                            ;
        csrrw x21, sscratch, x5                   ;
_l90:   la x15, d_1_0                             ;
        addi x15, x15, 8                          ;
        amoor.d x14, x14, (x15)                   ;
_l91:   la x11, d_5_12                            ;
        addi x11, x11, 0                          ;
        amoswap.d x21, x13, (x11)                 ;
_l92:   xor x2, x2, x2                            ;
        addi x1, zero, 3                          ;
        slli x1, x1, 31                           ;
        add x2, x2, x1                            ;
        csrrc x6, fflags, x2                      ;
_l93:   la x26, d_4_15                            ;
        sh x22, -20(x26)                          ;
_l94:   la x9, d_4_4                              ;
        sw x13, -12(x9)                           ;
_l95:   la x1, d_2_14                             ;
        addi x1, x1, -0                           ;
        amoor.w x23, x6, (x1)                     ;
_l96:   ori x17, x8, 11                           ;
_l97:   la x4, d_2_5                              ;
        fsw f14, 12(x4)                           ;
_l98:   fadd.s f17, f9, f25, rne                  ;
_l99:   fnmsub.s f8, f11, f12, f19, rne           ;
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
                .dword 0x6271fbebff646396, 0x59a9dfd24d38c7b1
                .dword 0x5541e595de97ced0, 0x53d5ffea55975ea7
d_0_0:          .dword 0x48ecbcdf60e1df54, 0xf1e187341f849d43
d_0_1:          .dword 0x9d9f93035da67e3b, 0x982370fa158a8ec8
d_0_2:          .dword 0x646049a9a79a3447, 0xa7511e0eae0ff07d
d_0_3:          .dword 0xe56cca52df540025, 0x5798870f7973e1b6
d_0_4:          .dword 0x9e904507d422a32b, 0x4713bbc0769dc564
d_0_5:          .dword 0x39c665c90dc5844e, 0x871bf748580c3a3b
d_0_6:          .dword 0x14ea1942f0c611bc, 0xe2f7d3b945078988
d_0_7:          .dword 0x9fac3a3dd3edfb8c, 0xe3c43f5beb4defb0
d_0_8:          .dword 0xf50e732dcc6f020a, 0x2552c82062fc54df
d_0_9:          .dword 0xea9d424a23e2005f, 0xc26565a91e1e6308
d_0_10:         .dword 0x1c327fbef54deb1c, 0x868ec94e2dd89093
d_0_11:         .dword 0x94efeb9036a13dde, 0xbc80d68b0a855691
d_0_12:         .dword 0x599791f6564682dd, 0x13bb6fe716dbc984
d_0_13:         .dword 0xcba3e0ca7331d692, 0xace8628728cb8338
d_0_14:         .dword 0xc6f73adb644fbfa0, 0x0237e419e8d6904e
d_0_15:         .dword 0x6ab748b335c1f367, 0x4061c2267fba797a
d_0_16:         .dword 0x645340d180bb6cb8, 0x1eea0e3bb43c13fa
d_0_17:         .dword 0x28f14a6c54fb2a9d, 0xd99322f7b9acc178
d_0_18:         .dword 0x20c96714e9cb15f8, 0x8ff25274a9675dab
d_0_19:         .dword 0x0006ac3747ef62c9, 0xefe6fa0c42bbc9fd
d_0_20:         .dword 0x284483a73d31a396, 0x8d9de8f6c413a1d4
d_0_21:         .dword 0x220f51b8ac39e326, 0x6e3704cdf497f99b
d_0_22:         .dword 0xffb8d7a06ec04865, 0xf8cbedb5fa91c2ba
d_0_23:         .dword 0x1ade43052fbcdbe5, 0x68818de6f6699c55
d_0_24:         .dword 0x3746b219ea8fd49d, 0xde78c427054abab3
d_0_25:         .dword 0x123b12997dd8692b, 0x012e3be55eda1755
d_0_26:         .dword 0x9a140fe53250e45a, 0x2449f92bf07b6dea
d_0_27:         .dword 0xd4269de6fe429c38, 0xd9f99b0794a6fe2b
                .dword 0xa72d1114b8e5ba06, 0x5302f140f7d0a1cf
                .dword 0x740512c142ba0e30, 0xbc4a33974a3700a5
        /* Random data */
_end_data0:
                 

    .section .data.random1;
    .align  8;

_random_data1:
                .dword 0x3535a272da84f354, 0x8e42345577d01c0f
                .dword 0x0cdeeb4c7795a981, 0x8e94cdf78d2cedea
d_1_0:          .dword 0x42ccfd19a45c1847, 0xcc9e141061c01d95
d_1_1:          .dword 0x64f7122286ecd710, 0xa582e0d67068160f
d_1_2:          .dword 0xd533742cbc14232c, 0xcf31a4f66f2add93
d_1_3:          .dword 0xd6c9b8798462d6ce, 0xa40cf5b52a3a6b37
d_1_4:          .dword 0x738c9d0271900237, 0x51fd52c7110751c4
d_1_5:          .dword 0x294effa5937e86c6, 0x0f51d17b86500761
d_1_6:          .dword 0xfd33dd1fc9f03c42, 0xdc47f7a5503cab8e
d_1_7:          .dword 0x56a92d4d3a3bd5c8, 0x46a52fd9d198f07c
d_1_8:          .dword 0x088e9a9c20757b9d, 0x1b75a94d63f9edb5
d_1_9:          .dword 0xaf2d02f46b349ea0, 0xd45fd64a07546657
d_1_10:         .dword 0xe77cc7cd832029fb, 0x708b52dc628be357
d_1_11:         .dword 0xa87646f7649e4097, 0x79de8ca32dd42b86
d_1_12:         .dword 0xdafa74f8f98b370f, 0x9432106adc7b5429
d_1_13:         .dword 0xbdcbcdd616690d78, 0xd5320b01c7e66bf5
d_1_14:         .dword 0xb03aac7b994c797d, 0x4a4cf88d173c4289
d_1_15:         .dword 0x18495c9a6c97653a, 0x7787a80fd26f3135
d_1_16:         .dword 0x80fd12bc48ffb4b8, 0xfed5f4ed9bc144d9
d_1_17:         .dword 0x33a5384af3135c08, 0x0d44f21d81c9a3c8
d_1_18:         .dword 0x899963b610ae1151, 0xd1a75ac1298b703d
d_1_19:         .dword 0x689f8e50385814b4, 0xfa0702db5c66891f
d_1_20:         .dword 0xbaf322f084a800dd, 0x2ad729e0a3b82caf
d_1_21:         .dword 0x2e2be0c587956dc4, 0xf7b8d56002a5ed7d
d_1_22:         .dword 0x54e8e57a914e086e, 0x47afcb38c781a118
d_1_23:         .dword 0xdc8505ae07acc154, 0xead0a859b6eeef7a
d_1_24:         .dword 0xd569f16d10dc0f99, 0x30a843585fcdda30
d_1_25:         .dword 0xd605bde0e0892f74, 0x484198aeb7a0f87d
d_1_26:         .dword 0x8b3b117f48c0e4b1, 0x931771e577ce1b1d
d_1_27:         .dword 0x3c0f36afcbf86494, 0xc3f10ec0a9facfb8
                .dword 0x2013d020a4b1ab74, 0xa76f5cda48d2ed8d
                .dword 0xd7a4d6e37c34e5ac, 0x3f3ae3ffc8e2310d
        /* Random data */
_end_data1:


    .section .data.random2;
    .align  8;

_random_data2:
                .dword 0xd1dc287a55fa7ea1, 0x0b1096e9e7f27d15
                .dword 0x8523f651cd0f1400, 0x59847bef5796ce2d
d_2_0:          .dword 0xf5ad2873cf5d38df, 0x180dfe7a07cb5030
d_2_1:          .dword 0xab6cc239a5008a10, 0xd29b755b1e2eadb2
d_2_2:          .dword 0xd7f352310b80b8ca, 0xe716d9624fd827de
d_2_3:          .dword 0x4ee8defd602eb1ee, 0xdf8705b177aa265d
d_2_4:          .dword 0x1863520c215bf6ce, 0x7d4800db0a173974
d_2_5:          .dword 0x7a3999ba9b8c8a28, 0x24387c09227560f8
d_2_6:          .dword 0x901ea2368fc93a86, 0x63ae5be712a27888
d_2_7:          .dword 0x5b319f2dd486d33a, 0xf87afbcc26a27bc4
d_2_8:          .dword 0x2b678d520cab69cb, 0x2e780a55d8f46822
d_2_9:          .dword 0xc991647dd3a923d7, 0xad0f074a90c47fb1
d_2_10:         .dword 0x6ff7525ec57b9a52, 0xe45d51abd8efd923
d_2_11:         .dword 0x0dd0cf148e6933f1, 0xe1984d6857d8450e
d_2_12:         .dword 0x47991af82c63df9f, 0x1c4991fb69ee94ff
d_2_13:         .dword 0x9c7e75b6c3fa48b9, 0x5a9e8ae62b5fdc85
d_2_14:         .dword 0xcbb7f58fc98495fb, 0x2e88f525e8b24492
d_2_15:         .dword 0x0a12fc818efc59c1, 0x02d2cbdd611b4b2f
d_2_16:         .dword 0xd87f5a8b9047e0fb, 0xb656166d6ee732b2
d_2_17:         .dword 0xd21157221ac42024, 0x52d27bf73362c328
d_2_18:         .dword 0x1318e7b698c3c6f9, 0x4c1eb4fe2c05101d
d_2_19:         .dword 0x9954f3bfb4a36650, 0xab88f4fac0e7970e
d_2_20:         .dword 0xee655c9213260b8b, 0x16642b865b5d13e0
d_2_21:         .dword 0xab31b8936f5e506d, 0x5d4d8157c7814d5e
d_2_22:         .dword 0xe07f3114e1f2e939, 0x384b83347b3e426f
d_2_23:         .dword 0x4384b5e6b9033dc6, 0xeef9194f7fd55f84
d_2_24:         .dword 0xff80e49c23f87840, 0x0c84de4cb6f06c80
d_2_25:         .dword 0x551f7d6516aff9a9, 0x101f6312e2b0249c
d_2_26:         .dword 0xc745eee3d8daad02, 0x7c9a204f70df9192
d_2_27:         .dword 0xeeb683f4a143596d, 0x2f8de8c8815ea3d8
                .dword 0x08e273822d97c76b, 0x84e67b7b968702c1
                .dword 0x92c4ac917500eed7, 0x13b64ad60bb416df
         /* Random data */
_end_data2:
                

    .section .data.random3;
    .align  8;

_random_data3:
                .dword 0xc23f1f97b3afa598, 0x974b87b482f70904
                .dword 0x81abb2b52442b209, 0x611ad6c0f8342b89
d_3_0:          .dword 0x9578dc97da467938, 0xc1cac9645e75679d
d_3_1:          .dword 0x96c4211fe1bf946d, 0x75584af4f822e3b2
d_3_2:          .dword 0xb821eac395947877, 0xe47fe067f5d94c96
d_3_3:          .dword 0x92c9cc5018a14e9e, 0x52dc592785b1bf84
d_3_4:          .dword 0xdd4bcccbe9a4dd3b, 0x7df36f91f46bc11b
d_3_5:          .dword 0x6b23dfae5c335c25, 0x956c2384ee7272a2
d_3_6:          .dword 0x021d3045089381c5, 0x569a6414c57d06c5
d_3_7:          .dword 0xf28807c655ffcbc1, 0xe6bebd68d5e069b4
d_3_8:          .dword 0x03a647025e709745, 0xe068fa6a14128f53
d_3_9:          .dword 0x20c8750b3b84803f, 0xa5561059101c9d05
d_3_10:         .dword 0x61ea8a3d1ad2bcc2, 0x392cba1f60550aa3
d_3_11:         .dword 0xdb2ed160e3978b4c, 0x830be84512ad5e62
d_3_12:         .dword 0xe2b4bdb96c1679cf, 0x087697da24771d68
d_3_13:         .dword 0x80a05b301e40b63b, 0x3cd644c893853082
d_3_14:         .dword 0xdcae69eb69574d4f, 0x5c0a9e71429ab3d0
d_3_15:         .dword 0xedd3616fc4537b97, 0x3b2c87075ae7705a
d_3_16:         .dword 0xea446d82e44620bc, 0x54580eadc53185a0
d_3_17:         .dword 0x6f711f904b917e0e, 0x512f623b75f0860a
d_3_18:         .dword 0xdeb49d8d46cc84de, 0x9538b0848022c473
d_3_19:         .dword 0x84c0def453801097, 0x5aee70fb39908ee1
d_3_20:         .dword 0xd3f8992cb7157258, 0x2e38c05614dd51a2
d_3_21:         .dword 0x2ab7858e62af93e4, 0x9335a3b6115b673f
d_3_22:         .dword 0x438a4558b12e7784, 0xedfdb52ff658bd8a
d_3_23:         .dword 0x6ea634856164ed08, 0x7f9e6682b54e9f33
d_3_24:         .dword 0x024a7d66cfceab04, 0x498c38b7cdebb44e
d_3_25:         .dword 0xf120faa4566bab24, 0xc11410d9b47b7d56
d_3_26:         .dword 0x46bf39b8803b20e3, 0x3ed7122d226994ad
d_3_27:         .dword 0xa8fb651465c9885a, 0xc30c3976201beb13
                .dword 0xae9f9fbdc4196bf3, 0x0545c7a1b4fee75b
                .dword 0x989d634892bbb802, 0x39e7b457be2b9c65
        /* Random data */
_end_data3:


    .section .data.random4;
    .align  8;

_random_data4:
                .dword 0xad776187da4cc828, 0x44bf1900e90ab8a7
                .dword 0x15bbe13505ecbebe, 0xfbe2bfcba90b67e2
d_4_0:          .dword 0x9af33e76271c421e, 0x2738c13e92967862
d_4_1:          .dword 0x177bc92ded8ab822, 0x6616482d92a13c6b
d_4_2:          .dword 0x397212c8b4d5bbc2, 0xe16d306edfefffc8
d_4_3:          .dword 0xc7511c2dd4f8c1cb, 0x15cac4015e01cb8a
d_4_4:          .dword 0x5418b42382d84ff8, 0x5f6465e228df812f
d_4_5:          .dword 0x81af9488b3ee1e71, 0x99a17dbaa5f177bf
d_4_6:          .dword 0x7d6ae28d48593004, 0x0d2696678cb43817
d_4_7:          .dword 0x8519835933ba4047, 0x81c8ee96f6a67324
d_4_8:          .dword 0x0493df612fbed20f, 0x24eb01500d4be2fb
d_4_9:          .dword 0x935b562de632efad, 0x39c6bbd4d07cbc2b
d_4_10:         .dword 0xd261205b029129f3, 0xb2529c05fcc31b9e
d_4_11:         .dword 0x45c22f64c174a10a, 0x22735c8d3207e994
d_4_12:         .dword 0x832c70a8308fda7f, 0x61a935f888bc811d
d_4_13:         .dword 0x506f5b2bbf0408c1, 0x28bcbc511c4c42b6
d_4_14:         .dword 0xb4e73e76f3097162, 0x9b496341e34cd55f
d_4_15:         .dword 0x7873357e241bb73b, 0x2c4ef6dcb89b1c3f
d_4_16:         .dword 0x46fff9b2a26541f2, 0xa829fcc10be8bd3c
d_4_17:         .dword 0x54146161971d5c4e, 0x1d3691e572616af1
d_4_18:         .dword 0x5562a89637c3bb24, 0x26c5750e93a18501
d_4_19:         .dword 0xb73077d4eb5a45ac, 0x6b002899ed9734df
d_4_20:         .dword 0xd87a15b630c9cdaf, 0x0413a9059476ab2e
d_4_21:         .dword 0xff12dc4a20fd2c00, 0x7baff074a3f86d91
d_4_22:         .dword 0x9b03b4bb464db6e6, 0xa424fd750039da94
d_4_23:         .dword 0x461a540896c9c553, 0x818014aa7112fa64
d_4_24:         .dword 0x60df1482138b849d, 0x14b46531e770e51a
d_4_25:         .dword 0x5da36e0514d31383, 0x0d3d4fe965b8dfe3
d_4_26:         .dword 0xace3b58b2ae3bf69, 0x7bac74c1800c5637
d_4_27:         .dword 0xe0f19e660dcb569e, 0x5a8bf7acff5735cd
                .dword 0xdd4aef4641e5f142, 0x44b7bbef871ee99c
                .dword 0xe526dc7d7b5cfe7d, 0xb4896dc3fed76147
        /* Random data */
_end_data4:


    .section .data.random5;
    .align  8;

_random_data5:
                .dword 0xed58ea9cf4ff060d, 0xd88b2989e43eaea7
                .dword 0xf6420b0f01cf7829, 0xa6ea856fea6e8b05
d_5_0:          .dword 0xd41d7087f3d616ed, 0xef156ef367d0d313
d_5_1:          .dword 0x402264004bd6ce35, 0x957d389f7859adf0
d_5_2:          .dword 0x67fe386df61cdeeb, 0x222281e9b9b4749e
d_5_3:          .dword 0xb67852efb9803d7b, 0xfddda66f69f975a8
d_5_4:          .dword 0x2d60f4e1f847a793, 0xce73a0955e5622ec
d_5_5:          .dword 0x11e5f03d6c6101ee, 0x4e16eb75e25ccde1
d_5_6:          .dword 0x3d7a0f47acdff976, 0x3f34b9a89521e9cc
d_5_7:          .dword 0x549ab641b178b508, 0xab2001a8e16dd0b4
d_5_8:          .dword 0x793cb7facc177249, 0xa5512e6015d8dc45
d_5_9:          .dword 0xf918e2912064e6ca, 0x4c3dd9f0640180e3
d_5_10:         .dword 0x9472f63b56998111, 0x4d868858ecc76005
d_5_11:         .dword 0x935261a2bae907c0, 0x16ca781c091daee6
d_5_12:         .dword 0x21abced413b5d6fe, 0xf5733db57be64b56
d_5_13:         .dword 0x92b440b5cc35ec04, 0x5c3675f1b7b55030
d_5_14:         .dword 0xe6c6e72bfe398101, 0x36da937711d5dfec
d_5_15:         .dword 0xa9bfc8b39d7a8049, 0x274a9439d8230217
d_5_16:         .dword 0xb3b9344ccad44ea8, 0xdc79fd1c5491f60d
d_5_17:         .dword 0x2c64a676fb4f2415, 0xc2b4e746655ae584
d_5_18:         .dword 0x338fc174fef1c394, 0x44731fac2cc1056b
d_5_19:         .dword 0xf94fdea9292a8e9f, 0x723cdebcd0d1dce4
d_5_20:         .dword 0xf68600b943242ada, 0xb360084cd1e9b508
d_5_21:         .dword 0xaacc92ca4abd5af7, 0xc83ecd09637738d3
d_5_22:         .dword 0x56b873ec1dd48214, 0xc82a2ead1f8732a8
d_5_23:         .dword 0x70edc91959df7935, 0x63379f596ed51393
d_5_24:         .dword 0x50622bf00b8a393f, 0xdd71b255dac29508
d_5_25:         .dword 0x7e2f5d67c1c9eb7e, 0x05aa40a17963f316
d_5_26:         .dword 0x86be284e6e92c937, 0xbc61a8755fc2d425
d_5_27:         .dword 0x106bb70d032b04e9, 0x9041bf7ac876cf4c
                .dword 0x59f0a5ce12090f74, 0x17b656eeb9c21c95
                .dword 0x4efbe1f6c68267ea, 0x6950d216d2eb8f57
         /* Random data */
_end_data5:
              
                 
