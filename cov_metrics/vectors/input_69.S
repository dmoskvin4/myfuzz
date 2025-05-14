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
_s0:    sraw x28, x16, x14                        ;
_s1:    srli x21, x15, 7                          ;
_s2:    fcvt.lu.s x10, f22, rne                   ;
_s3:    la x10, d_5_17                            ;
        ld x22, -16(x10)                          ;
_s4:    uret                                      ;
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
_p0:    csrrwi x13, sepc, 25                      ;
_p1:    xor x14, x14, x14                         ;
        addi x12, zero, 3                         ;
        slli x12, x12, 2                          ;
        add x14, x14, x12                         ;
        csrrw x12, pmpcfg0, x14                   ;
_p2:    xor x13, x13, x13                         ;
        csrrc x12, frm, x13                       ;
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
_l0:    la x16, d_3_17                            ;
        addi x16, x16, -0                         ;
        amoswap.w x9, x11, (x16)                  ;
_l1:    la x14, d_4_26                            ;
        sh x10, -30(x14)                          ;
_l2:    fadd.s f17, f21, f18, rne                 ;
_l3:    fmax.s f21, f20, f5                       ;
_l4:    la x5, d_2_3                              ;
        addi x5, x5, -24                          ;
        lr.w x29, (x5)                            ;
_l5:    csrrci x2, pmpaddr6, 27                   ;
_l6:    la x11, d_1_14                            ;
        lb x25, -7(x11)                           ;
_l7:    uret                                      ;
_l8:    fmsub.s f26, f11, f9, f20, rne            ;
_l9:    slti x29, x25, 0                          ;
_l10:   la x12, d_4_17                            ;
        addi x12, x12, 24                         ;
        amoxor.w x13, x17, (x12)                  ;
_l11:   la x23, d_4_24                            ;
        lb x10, -9(x23)                           ;
_l12:   fcvt.s.l f23, x24, rne                    ;
_l13:   fcvt.s.l f15, x3, rne                     ;
_l14:   fnmadd.s f13, f22, f17, f21, rne          ;
_l15:   la x20, d_2_7                             ;
        lh x5, 14(x20)                            ;
_l16:   xori x23, x26, 0                          ;
_l17:   sret                                      ;
_l18:   fcvt.s.lu f11, x24, rne                   ;
_l19:   csrrwi x14, sscratch, 24                  ;
_l20:   la x27, d_2_1                             ;
        addi x27, x27, -28                        ;
        amoswap.w x12, x26, (x27)                 ;
_l21:   la x29, d_4_16                            ;
        ld x16, -0(x29)                           ;
_l22:   la x14, d_5_23                            ;
        addi x14, x14, -0                         ;
        amoxor.d x29, x14, (x14)                  ;
_l23:   la x23, d_3_19                            ;
        srai x23, x23, 1                          ;
        csrrs x4, pmpaddr3, x23                   ;
_l24:   subw x10, x28, x27                        ;
_l25:   la x30, d_1_23                            ;
        addi x30, x30, 24                         ;
        lui x8, 0xffe00                           ;
        xor x30, x30, x8                          ;
        amomax.d x28, x8, (x30)                   ;
_l26:   xor x5, x5, x5                            ;
        csrrs x20, sstatus, x5                    ;
_l27:   fcvt.s.w f5, x21, rne                     ;
_l28:   xor x19, x19, x19                         ;
        addi x11, zero, 1                         ;
        slli x11, x11, 2                          ;
        add x19, x19, x11                         ;
        addi x1, zero, 1                          ;
        slli x1, x1, 25                           ;
        add x19, x19, x1                          ;
        csrrc x13, fcsr, x19                      ;
_l29:   fmadd.s f4, f5, f19, f22, rne             ;
_l30:   la x23, d_3_4                             ;
        addi x23, x23, -8                         ;
        amoadd.d x10, x16, (x23)                  ;
_l31:   la x25, d_4_1                             ;
        addi x25, x25, 0                          ;
        amoor.d x22, x4, (x25)                    ;
_l32:   la x19, d_1_19                            ;
        addi x19, x19, -0                         ;
        amomin.d x12, x12, (x19)                  ;
_l33:   la x2, d_3_21                             ;
        addi x2, x2, -24                          ;
        amomaxu.w x8, x30, (x2)                   ;
_l34:   sraw x20, x0, x2                          ;
_l35:   fcvt.w.s x29, f23, rne                    ;
_l36:   li x11, 0                                 ;
        la x13, pt1                               ;
        addi x13, x13, 48                         ;
        sfence.vma x11, x13                       ;
_l37:   addiw x2, x15, 785                        ;
_l38:   csrrwi x8, sip, 11                        ;
_l39:   csrrci x11, fcsr, 22                      ;
_l40:   la x28, _l98                              ;
        lh x22, 22(x28)                           ;
_l41:   fmax.s f21, f22, f18                      ;
_l42:   andi x7, x5, 0                            ;
_l43:   addi x17, x9, 500                         ;
_l44:   andi x19, x23, 0                          ;
_l45:   fcvt.l.s x9, f5, rne                      ;
_l46:   fcvt.s.wu f13, x1, rne                    ;
_l47:   la x8, d_5_6                              ;
        addi x8, x8, -0                           ;
        amoswap.w x29, x12, (x8)                  ;
_l48:   la x6, d_4_8                              ;
        addi x6, x6, 24                           ;
        amomin.d x2, x5, (x6)                     ;
_l49:   csrrsi x7, sstatus, 29                    ;
_l50:   xori x20, x10, 285                        ;
_l51:   addiw x1, x12, -2047                      ;
_l52:   fmax.s f17, f20, f6                       ;
_l53:   mret                                      ;
_l54:   la x12, d_3_9                             ;
        addi x12, x12, -8                         ;
        amoor.w x2, x5, (x12)                     ;
_l55:   sltiu x0, x30, -285                       ;
_l56:   fmadd.s f28, f21, f11, f19, rne           ;
_l57:   la x21, _l1                               ;
        srai x21, x21, 1                          ;
        csrrc x23, pmpaddr5, x21                  ;
_l58:   la x3, d_3_9                              ;
        lw x28, 24(x3)                            ;
_l59:   fsub.s f22, f18, f30, rne                 ;
_l60:   xor x25, x25, x25                         ;
        addi x20, zero, 3                         ;
        slli x20, x20, 27                         ;
        add x25, x25, x20                         ;
        csrrc x7, satp, x25                       ;
_l61:   la x10, d_3_14                            ;
        addi x10, x10, 16                         ;
        amoswap.d x7, x12, (x10)                  ;
_l62:   la x3, d_4_6                              ;
        lw x23, 16(x3)                            ;
_l63:   addi x11, x26, 1522                       ;
_l64:   srlw x11, x26, x3                         ;
_l65:   fmv.x.w x15, f9                           ;
_l66:   la x10, d_3_22                            ;
        addi x10, x10, -28                        ;
        amoxor.w x29, x1, (x10)                   ;
_l67:   fcvt.wu.s x11, f12, rne                   ;
_l68:   la x11, d_0_6                             ;
        lui x19, 0xffe00                          ;
        xor x11, x11, x19                         ;
        sw x26, -28(x11)                          ;
_l69:   ori x17, x1, 1304                         ;
_l70:   la x18, d_5_7                             ;
        addi x18, x18, -16                        ;
        lui x25, 0xffe00                          ;
        xor x18, x18, x25                         ;
        amomaxu.d x25, x25, (x18)                 ;
_l71:   fclass.s x25, f26                         ;
_l72:   fcvt.s.lu f30, x17, rne                   ;
_l73:   fmsub.s f31, f1, f21, f19, rne            ;
_l74:   la x21, d_1_25                            ;
        sb x2, -14(x21)                           ;
_l75:   la x23, d_0_22                            ;
        addi x23, x23, -16                        ;
        amoor.d x27, x5, (x23)                    ;
_l76:   sllw x4, x18, x2                          ;
_l77:   la x28, d_0_23                            ;
        addi x28, x28, 20                         ;
        amoor.w x24, x28, (x28)                   ;
_l78:   fadd.s f11, f29, f27, rne                 ;
_l79:   sllw x19, x21, x12                        ;
_l80:   la x8, d_2_20                             ;
        addi x8, x8, -16                          ;
        lr.d x2, (x8)                             ;
_l81:   fmadd.s f28, f24, f5, f14, rne            ;
_l82:   ori x3, x6, -8                            ;
_l83:   fnmsub.s f23, f10, f1, f5, rne            ;
_l84:   fcvt.s.w f22, x27, rne                    ;
_l85:   la x14, d_5_8                             ;
        addi x14, x14, -0                         ;
        amoand.d x2, x30, (x14)                   ;
_l86:   fmax.s f28, f18, f18                      ;
_l87:   xori x2, x5, -17                          ;
_l88:   addw x20, x6, x22                         ;
_l89:   fcvt.wu.s x21, f20, rne                   ;
_l90:   la x11, d_4_2                             ;
        addi x11, x11, -28                        ;
        amoor.w x24, x26, (x11)                   ;
_l91:   la x6, d_0_1                              ;
        lb x5, -14(x6)                            ;
_l92:   la x9, d_2_25                             ;
        addi x9, x9, 28                           ;
        amomin.w x25, x29, (x9)                   ;
_l93:   la x23, d_0_4                             ;
        addi x23, x23, 0                          ;
        amoswap.d x14, x29, (x23)                 ;
_l94:   fnmadd.s f9, f30, f6, f6, rne             ;
_l95:   la x5, d_0_18                             ;
        addi x5, x5, 8                            ;
        lr.w x15, (x5)                            ;
_l96:   slliw x3, x9, 12                          ;
_l97:   la x25, d_3_22                            ;
        addi x25, x25, -28                        ;
        lr.w x25, (x25)                           ;
_l98:   la x26, _l98                              ;
        lhu x8, 10(x26)                           ;
_l99:   li x26, 1                                 ;
        la x9, pt1                                ;
        addi x9, x9, 8                            ;
        sfence.vma x26, x9                        ;
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
                .dword 0xcd9d84f2920ce566, 0x97d2086b510ef241
                .dword 0x8a301b937ee8d77b, 0x7c5ec656c13bb360
d_0_0:          .dword 0x0d4eaa9c1ac30802, 0xb0d8510a607aceaa
d_0_1:          .dword 0x5bb3c47d6356f021, 0x181da68c51cafc9e
d_0_2:          .dword 0x4de7e7f5a2e298cf, 0xcc4e96b97ebd1819
d_0_3:          .dword 0x6dad13b13e7c6ab8, 0x46995f87d2117823
d_0_4:          .dword 0x977f6e6c405b9690, 0xc528da4a8c2ea538
d_0_5:          .dword 0x447d916042f1c5ed, 0xdadbd6b855f9298f
d_0_6:          .dword 0x9d9bb09277000e4a, 0xee1a29a7b7db0edc
d_0_7:          .dword 0x40676d3ac0f68274, 0x95bd60bcb36770c2
d_0_8:          .dword 0x252bc1a30bfd6c66, 0x34852de8bbf33d3b
d_0_9:          .dword 0x21534f8401fcc435, 0xbf8285df923a1744
d_0_10:         .dword 0xf566b64c8cff1f23, 0x378057b58acb02d3
d_0_11:         .dword 0xfbba6a88fda56581, 0x3646b7b4b2041a34
d_0_12:         .dword 0x4eacd7fedaf60840, 0x3f888219705e3fba
d_0_13:         .dword 0xa53aa31c6b6645d8, 0x8929eb9727397201
d_0_14:         .dword 0x3cbaf89fe20e1fd1, 0x0d15a38a2094036a
d_0_15:         .dword 0x42f57ba9f0a08a31, 0xdd9bb7bde4dbc6b5
d_0_16:         .dword 0xe5e74901fc24c17d, 0x8d1c10e0254f859e
d_0_17:         .dword 0x6715e2bf4f58784d, 0x442364ee9b2c3a75
d_0_18:         .dword 0x460ff819737b899e, 0xe27f8915dea8ea25
d_0_19:         .dword 0x55f5914169adbfe0, 0xa8d60859c7481cea
d_0_20:         .dword 0xa2b96d204af80492, 0xf07a041c00c10bb1
d_0_21:         .dword 0x42fe8b43d2b9fc9b, 0xf583ed994bf6497a
d_0_22:         .dword 0x6302aa792206f4c9, 0x1396b14e1e60df7e
d_0_23:         .dword 0x16514dffcbf5c37c, 0x9d7989cb06ccd40b
d_0_24:         .dword 0x14592e728294bbef, 0x4011027b43670b22
d_0_25:         .dword 0x9144fff54070d24d, 0x9f9c41c16d09abde
d_0_26:         .dword 0x145b95d524de1ed3, 0xb432e6e8f83a15ba
d_0_27:         .dword 0x8af51cdc59402c50, 0xc34c6f600c7a5748
                .dword 0xe5a856263c1fff3d, 0xbbdc8a400ad888c8
                .dword 0xf5856230c7bd7457, 0xcfc0e5eba4b3288b
        /* Random data */
_end_data0:
                 

    .section .data.random1;
    .align  8;

_random_data1:
                .dword 0xbef20aac2f85ef19, 0x13e110b2848093b4
                .dword 0x400091757ed897e4, 0xad6c15e1e897f2e7
d_1_0:          .dword 0xe4434da0ad146f55, 0x829b31274f8036bf
d_1_1:          .dword 0xe0860f92b6922ad0, 0x223e656fe04c3722
d_1_2:          .dword 0x4bdcb26d364e7820, 0xecffe69d275e7fa4
d_1_3:          .dword 0xfb02f41d4d216f57, 0x70979b42cfeb249a
d_1_4:          .dword 0xe9346a644d4487c7, 0x88233bedcd1d4a62
d_1_5:          .dword 0x82ed5de025970f2d, 0x0d47f6b6c84fad20
d_1_6:          .dword 0xb37fb9a2e24db46e, 0x0aee0d8c17fe6370
d_1_7:          .dword 0xd66dacef8e07e742, 0xf35b4a430e7982c5
d_1_8:          .dword 0xf1bcd5bce5e68142, 0xcf755d432dc314d2
d_1_9:          .dword 0x28d6a2ce1aae01b7, 0x81666c711b4a4bad
d_1_10:         .dword 0x4c6456409d2b9258, 0xf32fe6ae612e9ebf
d_1_11:         .dword 0x7b2b918858f9d995, 0x74fc2b11fa8e735c
d_1_12:         .dword 0xeeebbe30f3ee8332, 0x8c25e0c73d227036
d_1_13:         .dword 0xf52de782bb724bd8, 0x9bcda08ce4685fec
d_1_14:         .dword 0x3b6fe5cf25c463b6, 0xf63653ccc4554930
d_1_15:         .dword 0xdcc0dff32b84c743, 0xe8c6f1622fe1673c
d_1_16:         .dword 0xefb630e2f843429a, 0x445b3aca378968fc
d_1_17:         .dword 0x4628f9298fbb97dc, 0xdd6e87f6e987c233
d_1_18:         .dword 0xa74441117fdd03bc, 0x875c5cb80d64ca9c
d_1_19:         .dword 0xc8b0d23c56ac48e9, 0xd70d6eb6183b3787
d_1_20:         .dword 0x9747cb1dc836331d, 0x902b13e85a5be017
d_1_21:         .dword 0xc324918310018e51, 0xca983bd56f7c2bbd
d_1_22:         .dword 0x06920dce4ce20ff3, 0x52824e5a0553e0ff
d_1_23:         .dword 0xd338a5ba25725901, 0x44962fa141df92c3
d_1_24:         .dword 0x1c4ae6df2f0bf3f7, 0xf66281acb55046a4
d_1_25:         .dword 0x29babebbee608fcf, 0x9d68393545daa179
d_1_26:         .dword 0x6cb0a281b342fbdd, 0x832113c7f4f9a9d6
d_1_27:         .dword 0x9668b14d5c23b850, 0xd24ae5f7f7af465b
                .dword 0xc18a38fc9eafa355, 0xf3311369bc4205ff
                .dword 0xac27a265ac9ba64c, 0x3c8dca4dc8790c63
        /* Random data */
_end_data1:


    .section .data.random2;
    .align  8;

_random_data2:
                .dword 0xfee4dd81373673fd, 0x840cc85e4ae1b71d
                .dword 0x177b20d0e97d3e58, 0x166fbbd8662aac74
d_2_0:          .dword 0x84effd5423215ce4, 0x73a290a84cca99e8
d_2_1:          .dword 0x624648398d0186ac, 0x759bc405f8c1174a
d_2_2:          .dword 0x9a35bbeb8e595bed, 0xda99e71cc8d22c20
d_2_3:          .dword 0xa380eff458410e30, 0x5a24ea6d2ddcc866
d_2_4:          .dword 0xefc652f0ca3580ab, 0xc7b188f07a440190
d_2_5:          .dword 0x890b5b6cb3d0fa5f, 0x7f8e938962120274
d_2_6:          .dword 0x2047c1473f4565b2, 0xa1ad5dfb1f09cb61
d_2_7:          .dword 0xd7df5b32ac53e564, 0xbaaef705e9781e74
d_2_8:          .dword 0x86d3aec7deae3792, 0x7549cd8ae0c26c79
d_2_9:          .dword 0xcefbf73d51888467, 0x988b3ff58487756a
d_2_10:         .dword 0x4b09468a8850c08a, 0x44dfe66790539360
d_2_11:         .dword 0xcdbf59ded5524569, 0x9b1f3b6b4baf360d
d_2_12:         .dword 0x1a5ef0424fba29a5, 0x9314ca0da4d35475
d_2_13:         .dword 0xd8db1fefd7c622da, 0xe76d59a69b0fd3f8
d_2_14:         .dword 0x5887c603cd0a2454, 0xa045789d15f8149d
d_2_15:         .dword 0xe200ae4629a54d1b, 0x097422df1bf99b54
d_2_16:         .dword 0xc56acf00b82f3f2d, 0x9bc9323189784da6
d_2_17:         .dword 0xc611514c54084634, 0x75f3d0b28b010878
d_2_18:         .dword 0x1a40b0ed7535202a, 0xa04dd8d8e845d74a
d_2_19:         .dword 0x365a1dff148fbe16, 0x89d3649d8d6e5a53
d_2_20:         .dword 0xd1ef64e2953eb49c, 0xf5a90125bc4baaa7
d_2_21:         .dword 0xd6cc8ef86812504b, 0x2aeaf386b5cb82fd
d_2_22:         .dword 0x32ee1b0a3ee0f571, 0x092705df6013fb1e
d_2_23:         .dword 0x97b06dfc6c5e1f91, 0x2163ea0bca90d6ec
d_2_24:         .dword 0xdd98dbe0c9cf3817, 0x4efb46d24c9f06bf
d_2_25:         .dword 0xe51e9e268f96c68c, 0xa280cd04b5fd1295
d_2_26:         .dword 0x0f9510bd7de58d80, 0x829d422bc4a08f55
d_2_27:         .dword 0xc725084273038b9e, 0x33d0c4d9fac17f9c
                .dword 0xf5bf2ef39aac3a5e, 0xb9d4b67d03fed9bb
                .dword 0x32c008e1c2b9ec18, 0x6fcc5cca7de31537
         /* Random data */
_end_data2:
                

    .section .data.random3;
    .align  8;

_random_data3:
                .dword 0x4d31040e8b1f1864, 0xc4cafcf43c89c44e
                .dword 0x316c53fe74fe83bd, 0x45dcaeb774b5732a
d_3_0:          .dword 0xfa5358d7f5965709, 0x5224b39d4bd44519
d_3_1:          .dword 0xa6121992880b289e, 0xb575abb38963245c
d_3_2:          .dword 0xbd01d6922966eefb, 0xc4d4e06b3d782131
d_3_3:          .dword 0xb53cef2f4d94acd2, 0x1ccbc779a5dbaf5d
d_3_4:          .dword 0xb9d397ea6ff76183, 0xba1818ced7a9e13d
d_3_5:          .dword 0x092f63b7eb831e71, 0x13443ab64f18d485
d_3_6:          .dword 0x63e3710d515d6963, 0xeb5a563f97c0d204
d_3_7:          .dword 0x82d333b264a58584, 0x94a3b63b63285280
d_3_8:          .dword 0xca9a26fe730eb743, 0x155c8277172b58bc
d_3_9:          .dword 0x9a9ec34943e72abb, 0x23c698642a650cef
d_3_10:         .dword 0xd103048b4f665706, 0xb0145830500efff1
d_3_11:         .dword 0xa077708831559e1e, 0xadb4605ba77c4632
d_3_12:         .dword 0x9b9e23bb78ce36e5, 0x8fea2cead07bdf99
d_3_13:         .dword 0x99be5acf99d38114, 0x8c38555d7e50966e
d_3_14:         .dword 0x5e3bd8730eec0c31, 0xa27b5d140dfbff70
d_3_15:         .dword 0x60c059622689f2f9, 0x0a0f959ae68ceab3
d_3_16:         .dword 0x247209993b74fcef, 0xfbdc98f549c2f71e
d_3_17:         .dword 0xd954e043b3d809d1, 0x48bc4cdf336123f5
d_3_18:         .dword 0xdb7fbe25bc85f0e6, 0xea48ef8ed25887e7
d_3_19:         .dword 0x5b9eee37980f3b9e, 0xa03fcd1af93d7f8d
d_3_20:         .dword 0xc23cebf69a29a640, 0x17dd5f77b6ce8626
d_3_21:         .dword 0x1ca688954b706853, 0x72a0254477d51070
d_3_22:         .dword 0x5a1ac35e7ab3c6a5, 0x1b5a74185a35cadf
d_3_23:         .dword 0x052fc6c07d01f6f7, 0xb6da149dd3d91446
d_3_24:         .dword 0x94cf07ab205acba1, 0x4e9f2c008affa401
d_3_25:         .dword 0xf200166f0667a0a3, 0x19f9d1638e7d3111
d_3_26:         .dword 0xd2e9238683e30b0e, 0x70c3d7cd8dd9fcb0
d_3_27:         .dword 0xca8bb8e38cb57a51, 0x42d3848e6d217511
                .dword 0xc5128d8efaaa971e, 0xd9ff771a9cf80f13
                .dword 0x06141975ee25b3ab, 0xa3d106cb14b83171
        /* Random data */
_end_data3:


    .section .data.random4;
    .align  8;

_random_data4:
                .dword 0xc82bc5dfc74a668b, 0xb5e225b557f1eac0
                .dword 0x8c1561ef5c6d1467, 0xbf14344828459713
d_4_0:          .dword 0x45096d1b3351b94b, 0x9cacd94c02b02a0d
d_4_1:          .dword 0x743c49f82aa30099, 0xd2bcbd8dbe36c0c6
d_4_2:          .dword 0x30f47adf77e9fccd, 0x772bfdf842168719
d_4_3:          .dword 0xd6fe789b09706a47, 0x7459f1dbce2f2084
d_4_4:          .dword 0x7279d358b8fdb614, 0x60c31b81bf0d0c94
d_4_5:          .dword 0xf439438717463118, 0x57804668320dfedc
d_4_6:          .dword 0x30fe11661cfc0411, 0x64b1bb5e09e7816d
d_4_7:          .dword 0x83e639f1d47a2072, 0x440074b025a44ae1
d_4_8:          .dword 0xa3fb44b187bda473, 0x33639e5d79a9261b
d_4_9:          .dword 0x7edc0f64cfb26b6e, 0x236bf7f750f007dd
d_4_10:         .dword 0x6100dd9fa9297e7b, 0x44a81d71871610fa
d_4_11:         .dword 0x6ac78e8c488195f9, 0xbaa3ec3a17a8a98c
d_4_12:         .dword 0x791b7fd247226dec, 0xdcef7c6b4580d41b
d_4_13:         .dword 0xc7d9a736d0ebe281, 0xdfefcbf18036780a
d_4_14:         .dword 0xd4f27724897f7c55, 0x61ffeff14c138bc5
d_4_15:         .dword 0x0246494f5a83bcd2, 0xa6ff00ffa00a4da9
d_4_16:         .dword 0xdc15628b65e24f68, 0x70c7dd082a430468
d_4_17:         .dword 0xe0888b495ce3e51c, 0x8d5b52402c997544
d_4_18:         .dword 0x1975c9999bbaf278, 0x4c86a9b355d7f130
d_4_19:         .dword 0x748a137d41cf8942, 0x5c38a225ce24b32d
d_4_20:         .dword 0x6e223a178ca13ff8, 0x4968dc1bbc9585a9
d_4_21:         .dword 0xe356c6d5a9b109f1, 0x6e9f55cccea7f3da
d_4_22:         .dword 0x5b37e2c5560d87e2, 0xe21f0a98e8917664
d_4_23:         .dword 0x53c67a6326e68041, 0x1e117466f6fb4dc5
d_4_24:         .dword 0xf02b1cf810c39085, 0x33196dee494134f4
d_4_25:         .dword 0xb5e7d6ee0c606925, 0xdf5d15bb46d40d5f
d_4_26:         .dword 0x0578d788ca316329, 0x5778ceeef258368f
d_4_27:         .dword 0x61e52c54707d3777, 0xa74b0cf63fc5c1fb
                .dword 0xe6ac16cbf0721d0f, 0xafa554341d72698b
                .dword 0xf723e9674333104d, 0xdb60aa3cffa05a46
        /* Random data */
_end_data4:


    .section .data.random5;
    .align  8;

_random_data5:
                .dword 0x129a56704a1439e7, 0xe6e71f83de48d4fb
                .dword 0x810a1e27b1141ce9, 0xade181d9aa26c3d3
d_5_0:          .dword 0x236abbdd68961a6e, 0xc584cd8809ddb1eb
d_5_1:          .dword 0x3efad202e3b2012a, 0x1564836faa5fa0c9
d_5_2:          .dword 0x90f63a3affff361a, 0x566e27a735dcafd8
d_5_3:          .dword 0x88d5e2f4a9f41564, 0x9ba70b71911d1841
d_5_4:          .dword 0x9da6daa3204b5236, 0xfda737afa1b7cb32
d_5_5:          .dword 0x8efdf0f12b3f6a92, 0xae423040c0515d9b
d_5_6:          .dword 0xd607c4a87a64b298, 0x492e26fdeba20fb2
d_5_7:          .dword 0x48f132a56e0af0e8, 0x39b2ca39ddb32930
d_5_8:          .dword 0xb70b81796e6f0f28, 0x3a8184942867220c
d_5_9:          .dword 0xdc893befcef5f4fe, 0x0715d609511ba724
d_5_10:         .dword 0xaf1b151a8e8e4d6a, 0xb8d444f3a918a7fc
d_5_11:         .dword 0xae5f39256d60a068, 0x16f153235fd8a611
d_5_12:         .dword 0xfb5fce51c8c52343, 0xf5653af4b411c0d7
d_5_13:         .dword 0x5bc296cc6eeb3420, 0x769a536c10fd41f2
d_5_14:         .dword 0x21827ccb69fc67e6, 0xb7380cad36125392
d_5_15:         .dword 0xfcc50ab3dddc16b8, 0x1c034e179772aaec
d_5_16:         .dword 0xfebabf81cc697008, 0xfcf3a8ab791e43e5
d_5_17:         .dword 0x9713e64421dec8e4, 0x67ed50a2548686e9
d_5_18:         .dword 0x4c7f1d13ac73c6e5, 0xd14255ab5adf4630
d_5_19:         .dword 0xf4f2bc7cc948c650, 0x22a0318b7865c36c
d_5_20:         .dword 0xe5597b6613d43d84, 0x37d1bf3a5de40a8f
d_5_21:         .dword 0x32a2576721dc48a5, 0x0a4c6c56a4ea0edd
d_5_22:         .dword 0xaf3da377a3474663, 0x80b768578410daae
d_5_23:         .dword 0x83a910c3ca753a58, 0xe0197e8d1d0a32e5
d_5_24:         .dword 0x9ece8d673fec406f, 0xf803b4bfe0875e39
d_5_25:         .dword 0x7cab2dc8445e8aa2, 0xcd3fd297f72c384e
d_5_26:         .dword 0x09d2ca43dce87468, 0x3745da963051f3c7
d_5_27:         .dword 0x1c82a1b63a3d95e1, 0x535020fedf789840
                .dword 0x1b04619f727d59d7, 0x112ddda85c642733
                .dword 0xd7141a34b78d31ec, 0x808a7a2402605ae3
         /* Random data */
_end_data5:
              
                 
