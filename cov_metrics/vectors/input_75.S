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
_s0:    fcvt.s.lu f14, x18, rne                   ;
_s1:    fmadd.s f2, f16, f3, f14, rne             ;
_s2:    lui x4, 1991                              ;
_s3:    csrrsi x16, fflags, 12                    ;
_s4:    andi x22, x27, -2047                      ;
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
_p0:    csrrci x13, pmpaddr1, 4                   ;
_p1:    csrrwi x10, sscratch, 0                   ;
_p2:    csrrwi x14, sip, 18                       ;
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
_l0:    xor x18, x18, x18                         ;
        addi x22, zero, 1                         ;
        slli x22, x22, 1                          ;
        add x18, x18, x22                         ;
        csrrw x29, scause, x18                    ;
_l1:    la x21, d_5_25                            ;
        addi x21, x21, -16                        ;
        lui x22, 0xffe00                          ;
        xor x21, x21, x22                         ;
        amomin.d x18, x22, (x21)                  ;
_l2:    fmul.s f24, f24, f23, rne                 ;
_l3:    sret                                      ;
_l4:    la x18, d_5_11                            ;
        fsw f12, 28(x18)                          ;
_l5:    la x8, d_4_12                             ;
        addi x8, x8, 16                           ;
        lui x30, 0xffe00                          ;
        xor x8, x8, x30                           ;
        lr.d x4, (x8)                             ;
_l6:    la x7, d_1_8                              ;
        addi x7, x7, 24                           ;
        amoand.d x24, x14, (x7)                   ;
_l7:    la x24, d_0_16                            ;
        ld x10, -0(x24)                           ;
_l8:    subw x24, x27, x28                        ;
_l9:    sraiw x3, x16, 31                         ;
_l10:   fle.s x3, f17, f26                        ;
_l11:   la x19, d_0_8                             ;
        addi x19, x19, 4                          ;
        amoor.w x15, x25, (x19)                   ;
_l12:   la x10, d_2_19                            ;
        flw f9, 0(x10)                            ;
_l13:   srai x18, x0, 18                          ;
_l14:   la x15, d_3_10                            ;
        lhu x18, 0(x15)                           ;
_l15:   srai x15, x10, 6                          ;
_l16:   feq.s x28, f26, f5                        ;
_l17:   sltiu x0, x14, -117                       ;
_l18:   la x12, d_3_4                             ;
        addi x12, x12, 0                          ;
        lui x2, 0xffe00                           ;
        xor x12, x12, x2                          ;
        amomaxu.d x19, x2, (x12)                  ;
_l19:   la x26, d_5_24                            ;
        sh x19, 4(x26)                            ;
_l20:   sraw x0, x2, x21                          ;
_l21:   fnmadd.s f16, f6, f12, f26, rne           ;
_l22:   fmadd.s f8, f5, f14, f31, rne             ;
_l23:   sltiu x29, x30, 2047                      ;
_l24:   sltiu x12, x27, -1144                     ;
_l25:   addiw x21, x15, 742                       ;
_l26:   sltiu x12, x27, 2047                      ;
_l27:   la x15, d_2_21                            ;
        addi x15, x15, -28                        ;
        amoadd.w x24, x29, (x15)                  ;
_l28:   la x8, d_3_26                             ;
        lh x13, -14(x8)                           ;
_l29:   la x5, d_2_0                              ;
        addi x5, x5, 8                            ;
        amoxor.d x18, x28, (x5)                   ;
_l30:   la x5, d_5_15                             ;
        srai x5, x5, 1                            ;
        csrrs x16, pmpaddr2, x5                   ;
_l31:   fsgnjn.s f0, f23, f7                      ;
_l32:   fcvt.s.l f9, x7, rne                      ;
_l33:   fsgnjx.s f26, f21, f5                     ;
_l34:   li x24, 1                                 ;
        la x9, pt3                                ;
        addi x9, x9, 56                           ;
        sfence.vma x24, x9                        ;
_l35:   la x23, d_3_3                             ;
        fsw f25, 8(x23)                           ;
_l36:   la x14, d_5_19                            ;
        addi x14, x14, -16                        ;
        amoadd.d x13, x30, (x14)                  ;
_l37:   fcvt.lu.s x27, f21, rne                   ;
_l38:   la x18, d_0_2                             ;
        flw f27, 4(x18)                           ;
_l39:   la x3, d_3_13                             ;
        sw x5, 20(x3)                             ;
_l40:   slliw x23, x30, 20                        ;
_l41:   la x21, d_3_13                            ;
        addi x21, x21, 20                         ;
        amoswap.w x15, x6, (x21)                  ;
_l42:   mret                                      ;
_l43:   la x25, d_4_1                             ;
        ld x20, -0(x25)                           ;
_l44:   la x23, d_3_20                            ;
        ld x19, 0(x23)                            ;
_l45:   sraiw x20, x29, 31                        ;
_l46:   la x24, d_3_18                            ;
        addi x24, x24, 24                         ;
        amoand.w x20, x1, (x24)                   ;
_l47:   xor x11, x11, x11                         ;
        addi x16, zero, 1                         ;
        slli x16, x16, 11                         ;
        add x11, x11, x16                         ;
        csrrs x9, sip, x11                        ;
_l48:   xor x28, x28, x28                         ;
        addi x12, zero, 1                         ;
        slli x12, x12, 3                          ;
        add x28, x28, x12                         ;
        addi x21, zero, 1                         ;
        slli x21, x21, 16                         ;
        add x28, x28, x21                         ;
        csrrc x5, sip, x28                        ;
_l49:   la x16, d_3_20                            ;
        addi x16, x16, -28                        ;
        amomin.w x4, x6, (x16)                    ;
_l50:   fcvt.s.w f21, x4, rne                     ;
_l51:   xor x20, x20, x20                         ;
        addi x20, zero, 1                         ;
        slli x20, x20, 12                         ;
        add x20, x20, x20                         ;
        csrrc x22, sscratch, x20                  ;
_l52:   fle.s x12, f1, f25                        ;
_l53:   fdiv.s f29, f25, f11, rne                 ;
_l54:   la x13, d_2_14                            ;
        addi x13, x13, 24                         ;
        amomaxu.w x5, x14, (x13)                  ;
_l55:   subw x7, x23, x17                         ;
_l56:   andi x4, x24, 2003                        ;
_l57:   fcvt.s.w f22, x17, rne                    ;
_l58:   sret                                      ;
_l59:   fmax.s f29, f4, f23                       ;
_l60:   la x30, d_0_3                             ;
        lbu x11, -14(x30)                         ;
_l61:   fmax.s f25, f11, f31                      ;
_l62:   slti x15, x15, 1991                       ;
_l63:   fle.s x5, f21, f16                        ;
_l64:   fmv.x.w x9, f8                            ;
_l65:   ori x9, x29, 18                           ;
_l66:   la x19, d_1_20                            ;
        addi x19, x19, -16                        ;
        amomax.d x20, x24, (x19)                  ;
_l67:   srlw x26, x25, x14                        ;
_l68:   slliw x20, x11, 8                         ;
_l69:   fadd.s f27, f27, f27, rne                 ;
_l70:   la x3, d_3_9                              ;
        lhu x19, 10(x3)                           ;
_l71:   fcvt.s.w f5, x3, rne                      ;
_l72:   la x17, d_5_5                             ;
        addi x17, x17, -8                         ;
        lui x9, 0xffe00                           ;
        xor x17, x17, x9                          ;
        amoxor.d x20, x9, (x17)                   ;
_l73:   fsqrt.s f8, f4, rne                       ;
_l74:   la x20, d_3_19                            ;
        sw x18, -16(x20)                          ;
_l75:   fmul.s f5, f13, f20, rne                  ;
_l76:   fmsub.s f28, f27, f24, f26, rne           ;
_l77:   andi x26, x23, 0                          ;
_l78:   la x8, d_3_19                             ;
        addi x8, x8, 0                            ;
        amomin.w x4, x28, (x8)                    ;
_l79:   feq.s x10, f2, f6                         ;
_l80:   la x30, d_3_8                             ;
        lw x24, -8(x30)                           ;
_l81:   la x22, _l57                              ;
        flw f7, -16(x22)                          ;
_l82:   srai x26, x26, 50                         ;
_l83:   la x27, d_2_19                            ;
        sh x27, 8(x27)                            ;
_l84:   csrrwi x22, satp, 31                      ;
_l85:   la x24, d_3_7                             ;
        addi x24, x24, -8                         ;
        amominu.d x24, x15, (x24)                 ;
_l86:   csrrwi x13, pmpaddr4, 3                   ;
_l87:   la x15, d_2_5                             ;
        lh x23, 0(x15)                            ;
_l88:   sllw x5, x0, x17                          ;
_l89:   la x9, d_2_7                              ;
        addi x9, x9, -16                          ;
        sc.w x28, x26, (x9)                       ;
_l90:   la x21, d_3_0                             ;
        addi x21, x21, -12                        ;
        amoswap.w x14, x24, (x21)                 ;
_l91:   fcvt.s.wu f29, x14, rne                   ;
_l92:   la x19, d_2_13                            ;
        fsw f30, 12(x19)                          ;
_l93:   la x4, d_5_19                             ;
        addi x4, x4, -8                           ;
        amoand.d x30, x1, (x4)                    ;
_l94:   fdiv.s f25, f0, f20, rne                  ;
_l95:   la x4, d_1_21                             ;
        addi x4, x4, -24                          ;
        amomin.d x17, x14, (x4)                   ;
_l96:   la x30, d_1_17                            ;
        addi x30, x30, 8                          ;
        lui x26, 0xffe00                          ;
        xor x30, x30, x26                         ;
        amomaxu.d x5, x26, (x30)                  ;
_l97:   la x10, d_3_17                            ;
        addi x10, x10, 16                         ;
        amomax.d x26, x12, (x10)                  ;
_l98:   fsgnj.s f13, f15, f10                     ;
_l99:   la x5, d_5_18                             ;
        addi x5, x5, 24                           ;
        amoand.w x14, x1, (x5)                    ;
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
                .dword 0x868e8b9e2d7c6cc2, 0x83752463a3b66f8f
                .dword 0x16de8fa73a77044e, 0xf41dfaaa6748cc48
d_0_0:          .dword 0xa5af3cb1feee0f2d, 0xf6594325cf9620e4
d_0_1:          .dword 0x8892c76c1bde6d21, 0x1cb6f57713c79d3d
d_0_2:          .dword 0x62ce963d2a07f086, 0x9057ccf2115180ee
d_0_3:          .dword 0x6cdb4ea227b3f337, 0xe42d58c863623ff5
d_0_4:          .dword 0xc94b743114a344bd, 0x1ea90a22bd62b85f
d_0_5:          .dword 0xf4d0e172262f9e9a, 0x2d129632cb1d410b
d_0_6:          .dword 0x9299e8d57f959ccc, 0x027a6e61c3e1b844
d_0_7:          .dword 0x665971b99a84bc2f, 0x95c1691235f06a7e
d_0_8:          .dword 0x6472b447a7196388, 0x3eb32e5fa0ce758d
d_0_9:          .dword 0x0454a9f82fa253b7, 0xefbad7bad7d49a13
d_0_10:         .dword 0xb8086fba41c34d9f, 0xe53a86f711c20c5f
d_0_11:         .dword 0x1b9f9577b01d6c71, 0xd5d80a76d7619ce0
d_0_12:         .dword 0x3ca4683fb00ebd28, 0x68ecf3e650e5a83d
d_0_13:         .dword 0x190564574ab001b8, 0x08ff6c97bf265f5e
d_0_14:         .dword 0xf0f29688164344a3, 0x176294fd5c0396cf
d_0_15:         .dword 0xa51e25e9193f3edc, 0xce8beb93e1a7b62c
d_0_16:         .dword 0xb201022308d29623, 0x868fa4b01a629da6
d_0_17:         .dword 0x234513d88d085344, 0x42f4c8ba696c2443
d_0_18:         .dword 0x1550f50ad47c76e0, 0xccf05fa8c91e015b
d_0_19:         .dword 0x3c6c125adce7a533, 0x6704bfa6f8387dab
d_0_20:         .dword 0x5628213cd4ed8716, 0xb2d9906362d82b3a
d_0_21:         .dword 0x4d969ed4002b5bd2, 0x78a43dde87f38228
d_0_22:         .dword 0xae4b55cbfb5697e0, 0x82dba7f4571b63f8
d_0_23:         .dword 0x5b876096fefc4a3a, 0x26e341be144a63db
d_0_24:         .dword 0x91a944543230c85f, 0x88044ac71ce20bfb
d_0_25:         .dword 0x8c8f174a78ee62ec, 0x28fba294f2f76a6b
d_0_26:         .dword 0x44b06a67cd31a6f1, 0x1c8a8124198f2d8c
d_0_27:         .dword 0xeaccdd38b324e852, 0x6c6608021c5adc48
                .dword 0x713fc9226d3a149f, 0xdcbe316643b68b42
                .dword 0x9711f15aa61dce68, 0x9c4e58e184f4e5e4
        /* Random data */
_end_data0:
                 

    .section .data.random1;
    .align  8;

_random_data1:
                .dword 0x98d4c6be2d5eb137, 0xba44c7cb63ed4351
                .dword 0x19eff52ec815f59e, 0xad63fda3f309837e
d_1_0:          .dword 0xf0011cbe5fd00428, 0x3906c5e97d59faa5
d_1_1:          .dword 0xed287458498e82dd, 0x0f1d95c31c0d1452
d_1_2:          .dword 0x8dc214c640713be2, 0xbaa5aaf8798ed65d
d_1_3:          .dword 0x4315b50fcc713db2, 0x05ac5a1d2010f185
d_1_4:          .dword 0xd0d1b633d593782a, 0x8d3a18ac50ec5987
d_1_5:          .dword 0xf7c3a21daec5a2c0, 0x3c0802696f70e21a
d_1_6:          .dword 0xccd9917274c4c9c1, 0x5c2976ad797d6ebb
d_1_7:          .dword 0x2e412a320e9eb2e4, 0x304960d5945cf9b6
d_1_8:          .dword 0xdeade416dae48261, 0x745fe7430f7fda18
d_1_9:          .dword 0xe08b8a5450e1fab4, 0xc532c436433dfc2d
d_1_10:         .dword 0x89dbd5628648b28f, 0xea330bc5c445a446
d_1_11:         .dword 0xa72d0e349943dd23, 0xed75ea6bc2c2d0ed
d_1_12:         .dword 0x7096da067fa6efe9, 0xf56d0eb860f97a11
d_1_13:         .dword 0x87182bf9891451cf, 0xe133efbcd82aac02
d_1_14:         .dword 0x808f99b0c9b08faa, 0xc513a4375d76e4d2
d_1_15:         .dword 0x3511988ad7b5d2e1, 0xe3ceeec1a9a996ae
d_1_16:         .dword 0xa1fc8c2a2efe9fda, 0x411e8eb6dc7d3eb0
d_1_17:         .dword 0xa6fb46073e330be3, 0xce5ae9637bb55e21
d_1_18:         .dword 0x1d2a70f82103f086, 0xc52dcaed775d611c
d_1_19:         .dword 0xc7a732d68cd9ad2f, 0xcc5b89b20be29fcc
d_1_20:         .dword 0x306d4aaacfdd6a39, 0x1a1ad932029e7adf
d_1_21:         .dword 0x8f74c2c9b0a4fd5b, 0x2fc255b2b45907b4
d_1_22:         .dword 0xc15ed0b940c0623f, 0xa3440f0008635d23
d_1_23:         .dword 0xafbb6e9a2eb0d346, 0x3eac00f6728949c2
d_1_24:         .dword 0x2b187ad8c9a663c6, 0xaf77c8cda760c97b
d_1_25:         .dword 0x995903e7ae2e9584, 0x8024cc221af2cfd7
d_1_26:         .dword 0x387c335b3359ed0b, 0x308080ed213423ae
d_1_27:         .dword 0xee570de22fd02065, 0x7cbe0689582c8e68
                .dword 0x4141cadc15ee4758, 0xb1d27697b014ddf2
                .dword 0x0bf3e51a5a3dbe1b, 0x72341e4e508552ea
        /* Random data */
_end_data1:


    .section .data.random2;
    .align  8;

_random_data2:
                .dword 0xfba53b61c7a3e45b, 0x2c3ecd5cd3dcb8c9
                .dword 0x904a4b7081c31f64, 0xdeb3edc4781835eb
d_2_0:          .dword 0x11a58142ac8eec77, 0x7e6a9c0b6e0119b5
d_2_1:          .dword 0x805ebdab1f2cf4f3, 0x7c2b97eade2c82dc
d_2_2:          .dword 0x7b4486dd6ffc069e, 0x1a1c939affc7f738
d_2_3:          .dword 0x9eeff7473a48402a, 0x1d235ac090b6389e
d_2_4:          .dword 0xc427a84e0ab92d24, 0x57984c07e9e79b27
d_2_5:          .dword 0x5f2af68968220146, 0xeec9c6115e73bb7c
d_2_6:          .dword 0x89333e32cb95ae3a, 0x939c28158faa44a4
d_2_7:          .dword 0x6e8b371250dc8117, 0x46eafcec92051c98
d_2_8:          .dword 0x6367526382718c13, 0xea84c5648c4f772a
d_2_9:          .dword 0xe746e20125146c9e, 0x79b22a5ac837c68d
d_2_10:         .dword 0x068419ea4437c963, 0xb1124afe02fdbc7c
d_2_11:         .dword 0xeaca9fb8e256592c, 0x11a39fc5d91d22e2
d_2_12:         .dword 0x6c098c10b2c803ad, 0xfe5a2d90ce9dfa74
d_2_13:         .dword 0x7ede9b393fd3e4e0, 0x3d86893d1f8da0a7
d_2_14:         .dword 0xc0927bfd55c0fa3d, 0x51588d50e2db4e16
d_2_15:         .dword 0x22f6f01d3a64958f, 0xadf6a771d01ad82d
d_2_16:         .dword 0x5d744a5bd025d6fc, 0x344e1fe2cc197725
d_2_17:         .dword 0x09a42caa25f5ead8, 0x7f8be698206f44fe
d_2_18:         .dword 0xb491542b3e56e069, 0xc50d664520eff27e
d_2_19:         .dword 0x159a6fd9cbf9f7e4, 0x5dc747e8cc0db150
d_2_20:         .dword 0x24eafbade6579e4a, 0xa47a8956b35f487a
d_2_21:         .dword 0x93ca943fda2f3d58, 0xbf87af6517f4fbcb
d_2_22:         .dword 0x105073b758400cee, 0xf1a172784aca7dcb
d_2_23:         .dword 0xc10d494f28deb051, 0xc060a9e71b3442fc
d_2_24:         .dword 0x3a600c3d96647386, 0xa84bd8daf2e4822a
d_2_25:         .dword 0x8062ca2ed9e43cd3, 0x3fe181bbf45ef524
d_2_26:         .dword 0x35610cad454399c8, 0x033f166a4d3716fb
d_2_27:         .dword 0x0eef4d46cb513cf7, 0x7a8ccac9835d7361
                .dword 0xe7cce225a03db95d, 0x42f6396224707cdc
                .dword 0x662ee68406c47b32, 0xc178a4ff322cd07b
         /* Random data */
_end_data2:
                

    .section .data.random3;
    .align  8;

_random_data3:
                .dword 0x6e6f46b0505350da, 0xc292e09e8dc7c727
                .dword 0x30bf83d2aa955360, 0xfc95dee2895a29ce
d_3_0:          .dword 0x2c185677f9c4fcfb, 0xbb974a036325c8b6
d_3_1:          .dword 0x02ef71b5e9e8fb36, 0x5ca457a0e58b01a9
d_3_2:          .dword 0x32147f8a3e1f0ef3, 0x7a5cdb82e9b68cd4
d_3_3:          .dword 0x713d4fc3f594882c, 0x707f49774257037b
d_3_4:          .dword 0xa03d6a8b4b509067, 0x233bd4f57cd46ce5
d_3_5:          .dword 0xae282e16c48a3581, 0xf4b0798f6cc6b7ab
d_3_6:          .dword 0x6b11bf7e5d653569, 0x74bc62224eac5b5c
d_3_7:          .dword 0x649524c9d7d27704, 0x41ec17673844a54b
d_3_8:          .dword 0xf7aa6eca0069c787, 0x5d06d0826c8fcd2e
d_3_9:          .dword 0x6bc2d46687adb3b7, 0x2d1735fbf406ed09
d_3_10:         .dword 0xc7350c178eaf4382, 0x2723d5885643a38c
d_3_11:         .dword 0x9f1a72412452693d, 0xcd4661f2db136994
d_3_12:         .dword 0xb976f08d52a16551, 0x82694faf850a17c8
d_3_13:         .dword 0x014a2eaa18284472, 0x3a1541c76ace9367
d_3_14:         .dword 0x68e7b1c7c72842d1, 0xea5b29916154a342
d_3_15:         .dword 0xd04b1655dcea50cc, 0xe2ed59123ba41827
d_3_16:         .dword 0xfc9e8c31b1f821bd, 0x240cc4691d73b444
d_3_17:         .dword 0x39a7b36b8aaeeb9e, 0xef9f3beda9511c56
d_3_18:         .dword 0x8f830eac4787146f, 0x6a526d83ee6f0144
d_3_19:         .dword 0x1b7ff3438ac4e8b6, 0xe197128805d51abc
d_3_20:         .dword 0x400638a4883ea5e2, 0x460c5a70d978cc04
d_3_21:         .dword 0x41fdaa3a2c4e5b5f, 0xa24d6e9e36eb4921
d_3_22:         .dword 0x265466177cc5b0fe, 0xf833ed104a3e73f1
d_3_23:         .dword 0x22b1a52914cdf8be, 0xf447c14b36b2a725
d_3_24:         .dword 0x09f9fa3d3252e1c4, 0x7aa98dd9a743223e
d_3_25:         .dword 0x753b5ce2c2769e54, 0x0017ec67d2b8e4d5
d_3_26:         .dword 0x73bb9c37d119c477, 0x0138177d94e103d3
d_3_27:         .dword 0x230de4e119527b96, 0xae7c062709cad2c6
                .dword 0x4a3985f83f6351e5, 0x11c8fe0ec4713349
                .dword 0x3412514b0fafc035, 0xffc3844ac28c4a3f
        /* Random data */
_end_data3:


    .section .data.random4;
    .align  8;

_random_data4:
                .dword 0x2d55259021765a35, 0x187d35e687751483
                .dword 0xa098b37ef1c5a172, 0x0515d9109f8b21f6
d_4_0:          .dword 0x1ab1cfc8de649f52, 0xd0822c41b36e5637
d_4_1:          .dword 0x15b4669ce9d94d7d, 0x1e909cfd1088b7b9
d_4_2:          .dword 0xf25511474b8b119e, 0xeeed669a291e5b9e
d_4_3:          .dword 0x38122d3b5d27bce7, 0x2e5cbe7c1336fb27
d_4_4:          .dword 0x83a714a7739402e1, 0x9711d3145bf0951b
d_4_5:          .dword 0xf7dec5881faef20c, 0xe8634b6ff3347a3d
d_4_6:          .dword 0x01da40ce71ea7e18, 0x46786925afa6402c
d_4_7:          .dword 0x971ce158e1c9900c, 0xabf126a3aae25392
d_4_8:          .dword 0x996ab94d19bb3e86, 0x2505e92488a20fbc
d_4_9:          .dword 0x42bdb104793cd207, 0xb24ad2443478ad59
d_4_10:         .dword 0xdbd8783864032587, 0x89df60ad993c962e
d_4_11:         .dword 0x6a3ac22691584d3d, 0xbc31a4dab7c19eb9
d_4_12:         .dword 0xc47b06fa7f63b30f, 0xffa7c7d2651bab06
d_4_13:         .dword 0xb76a70057c1d9827, 0x110f5f4e74fa957b
d_4_14:         .dword 0xf4967d1cc7a8c86a, 0xf51ea682c31b5be3
d_4_15:         .dword 0x7a69312b89dc96c3, 0xb34bac98e502ae94
d_4_16:         .dword 0xb06577dbba95cb20, 0xae33b18de3743f84
d_4_17:         .dword 0x6dc7be9ac15ed744, 0x9aff21a82ee1711c
d_4_18:         .dword 0x62a3364431824070, 0x3573b4a3e8ae1db6
d_4_19:         .dword 0xca9abf742fb86b52, 0x4facdb2fd97a3023
d_4_20:         .dword 0x1d54967033f20769, 0x8192053aa4494f3e
d_4_21:         .dword 0xe33d2ffd30badf5e, 0x4a03fa792c33c3e9
d_4_22:         .dword 0xd768e435d3f620f9, 0xa36f3ab463f1a877
d_4_23:         .dword 0xa4b422204830b26b, 0xf93e9a571f51edff
d_4_24:         .dword 0xe4b6fa916dd42dfb, 0xc9dbc6edbbcc721d
d_4_25:         .dword 0xe608b9ea2b85f2ff, 0xef19af2f2012f92b
d_4_26:         .dword 0x0bd9b3163d67a3fe, 0x88360b4bc2ffb03c
d_4_27:         .dword 0xbc9c4184fe46dd09, 0x6c9a450a17de3d82
                .dword 0xe43eae0efc60d58b, 0x7ad4c8e7960f7ffa
                .dword 0x0a0a156616a4f9b8, 0xfbb479492881b2b8
        /* Random data */
_end_data4:


    .section .data.random5;
    .align  8;

_random_data5:
                .dword 0xe11f0508d3928a1d, 0x856bbaa2377d6139
                .dword 0x23afac346dca2217, 0x001526e1cd264fb0
d_5_0:          .dword 0x35f7d8c14ee6d2a8, 0xec4a4670f6ddfc90
d_5_1:          .dword 0xc9a59c178bfbec28, 0xf2ee4fa75b606c1f
d_5_2:          .dword 0x241a5716fe8fe0d0, 0xac292d97a4fd5986
d_5_3:          .dword 0xbe507a673af5c38a, 0x39cd55648bafc733
d_5_4:          .dword 0xb8828a7cfecb2461, 0x9877654440bd1012
d_5_5:          .dword 0xecd2213eed813ee9, 0x6c1e006cf1ef8c7d
d_5_6:          .dword 0xd869d12339c3cee7, 0x84221099cf98fb78
d_5_7:          .dword 0xe55af92fde177808, 0xa8b05c6a3cfad262
d_5_8:          .dword 0x535dd595a30b8faf, 0xcb2442f2d3b9f5f3
d_5_9:          .dword 0xef3f8f372adc9ae3, 0x2310a353cc8a4420
d_5_10:         .dword 0xd6007feb10043db6, 0x556992bd71edd85d
d_5_11:         .dword 0x8527468a41dc722d, 0xfa7222f4c20535cc
d_5_12:         .dword 0x6cd449382074d446, 0xbde63007e3742f43
d_5_13:         .dword 0x364bb3209af7b1cb, 0xc46f336f53341e7a
d_5_14:         .dword 0x3b1035ea7f20c3cf, 0x0ef03edd64cb42d6
d_5_15:         .dword 0x0c1a23b0a63fcaad, 0xe68683b09b0fc4e1
d_5_16:         .dword 0x77c12d56460f2229, 0x9cf93ee58c4c9455
d_5_17:         .dword 0xc98eb1874cd8aa2d, 0xa0fb771301c09124
d_5_18:         .dword 0x6d8b42ebee8c3753, 0x9d9dec912badd6d9
d_5_19:         .dword 0xe276650bdc0a96c4, 0x82a06f8271931c6b
d_5_20:         .dword 0x16dbab7f47a4d3e7, 0x7e86efaddf515cd1
d_5_21:         .dword 0xbc6c64b2b13deb54, 0x38799ef921af772b
d_5_22:         .dword 0x9a894e1eccd76212, 0x1c8e3910fed17d03
d_5_23:         .dword 0x1d95fc6d500788ca, 0xfdbc5a1b35a5b35b
d_5_24:         .dword 0xf3e91db9555ecb59, 0xf74c5c041b39b2dd
d_5_25:         .dword 0xea1062e29f2227cd, 0x913e3e8807aa0d4e
d_5_26:         .dword 0x8b6cbd1688922d9f, 0x6cdcf1cf01531a40
d_5_27:         .dword 0x8244db02075827cc, 0xeef3e01d5a0ef281
                .dword 0x1a08a5201f083189, 0xf9aa6824196d6994
                .dword 0x8a01b6b0d40c9040, 0x55d89e120a9576b5
         /* Random data */
_end_data5:
              
