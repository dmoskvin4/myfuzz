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
_p0:    csrrwi x14, pmpaddr6, 31                  ;
_p1:    csrrwi x14, pmpaddr4, 5                   ;
_p2:    xor x10, x10, x10                         ;
        addi x12, zero, 1                         ;
        slli x12, x12, 11                         ;
        add x10, x10, x12                         ;
        csrrc x12, scause, x10                    ;
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
_l0:    lui x28, 798372                           ;
_l1:    sret                                      ;
_l2:    la x28, d_3_20                            ;
        addi x28, x28, 0                          ;
        sc.w x21, x5, (x28)                       ;
_l3:    la x10, d_3_4                             ;
        addi x10, x10, 4                          ;
        lr.w x13, (x10)                           ;
_l4:    slli x21, x6, 9                           ;
_l5:    la x20, _l17                              ;
        lb x3, 9(x20)                             ;
_l6:    la x20, d_3_21                            ;
        addi x20, x20, -8                         ;
        amoxor.w x26, x14, (x20)                  ;
_l7:    la x26, d_3_24                            ;
        lb x6, -31(x26)                           ;
_l8:    la x12, d_1_5                             ;
        addi x12, x12, -16                        ;
        amomin.d x6, x8, (x12)                    ;
_l9:    fcvt.l.s x30, f19, rne                    ;
_l10:   fclass.s x25, f15                         ;
_l11:   fcvt.s.w f4, x30, rne                     ;
_l12:   fcvt.s.l f15, x14, rne                    ;
_l13:   sllw x17, x23, x18                        ;
_l14:   la x10, d_4_19                            ;
        sh x1, 6(x10)                             ;
_l15:   la x10, d_3_26                            ;
        addi x10, x10, 20                         ;
        amoor.w x13, x1, (x10)                    ;
_l16:   csrrsi x17, pmpaddr0, 19                  ;
_l17:   la x29, d_1_25                            ;
        addi x29, x29, 20                         ;
        sc.w x10, x30, (x29)                      ;
_l18:   srliw x3, x7, 16                          ;
_l19:   fle.s x16, f13, f29                       ;
_l20:   fnmsub.s f28, f9, f19, f17, rne           ;
_l21:   la x12, _l0                               ;
        lw x29, -20(x12)                          ;
_l22:   fnmsub.s f4, f7, f0, f4, rne              ;
_l23:   la x7, d_4_22                             ;
        addi x7, x7, 0                            ;
        lui x7, 0xffe00                           ;
        xor x7, x7, x7                            ;
        amoor.d x9, x7, (x7)                      ;
_l24:   fmsub.s f17, f0, f9, f13, rne             ;
_l25:   flt.s x22, f25, f1                        ;
_l26:   fsgnjn.s f28, f1, f5                      ;
_l27:   fnmsub.s f13, f29, f9, f28, rne           ;
_l28:   fcvt.w.s x18, f4, rne                     ;
_l29:   la x21, d_1_9                             ;
        addi x21, x21, -0                         ;
        amoadd.d x22, x10, (x21)                  ;
_l30:   fcvt.s.l f29, x4, rne                     ;
_l31:   la x22, d_1_25                            ;
        addi x22, x22, 16                         ;
        amominu.w x30, x28, (x22)                 ;
_l32:   xori x30, x28, -0                         ;
_l33:   la x29, d_2_21                            ;
        addi x29, x29, 0                          ;
        amoor.d x26, x15, (x29)                   ;
_l34:   la x19, d_1_12                            ;
        addi x19, x19, -16                        ;
        lr.d x9, (x19)                            ;
_l35:   fcvt.wu.s x2, f27, rne                    ;
_l36:   la x11, d_2_26                            ;
        lh x17, 26(x11)                           ;
_l37:   flt.s x10, f8, f9                         ;
_l38:   fmin.s f4, f13, f17                       ;
_l39:   la x19, d_0_26                            ;
        addi x19, x19, 4                          ;
        lui x13, 0xffe00                          ;
        xor x19, x19, x13                         ;
        amoswap.w x26, x13, (x19)                 ;
_l40:   fmax.s f3, f9, f24                        ;
_l41:   fsgnj.s f15, f2, f2                       ;
_l42:   fadd.s f13, f18, f9, rne                  ;
_l43:   la x8, d_0_27                             ;
        flw f27, -0(x8)                           ;
_l44:   uret                                      ;
_l45:   fdiv.s f26, f7, f24, rne                  ;
_l46:   fmax.s f18, f12, f14                      ;
_l47:   addi x9, x20, -0                          ;
_l48:   la x1, d_0_25                             ;
        sh x17, -10(x1)                           ;
_l49:   srlw x13, x25, x22                        ;
_l50:   slliw x20, x13, 7                         ;
_l51:   slliw x9, x11, 5                          ;
_l52:   slli x23, x9, 23                          ;
_l53:   fsgnjx.s f15, f25, f30                    ;
_l54:   la x10, _l39                              ;
        ld x23, 0(x10)                            ;
_l55:   la x26, d_2_8                             ;
        addi x26, x26, -8                         ;
        amomin.d x15, x17, (x26)                  ;
_l56:   fclass.s x11, f25                         ;
_l57:   ori x11, x16, 1494                        ;
_l58:   flt.s x20, f5, f27                        ;
_l59:   sraw x10, x16, x4                         ;
_l60:   la x12, d_5_0                             ;
        sh x14, -0(x12)                           ;
_l61:   addiw x22, x28, -1408                     ;
_l62:   la x28, d_3_25                            ;
        addi x28, x28, -16                        ;
        lr.d x15, (x28)                           ;
_l63:   csrrwi x30, sepc, 18                      ;
_l64:   la x30, d_0_25                            ;
        sh x22, 12(x30)                           ;
_l65:   fmv.x.w x8, f4                            ;
_l66:   lui x15, 169161                           ;
_l67:   la x7, d_3_1                              ;
        ld x26, -0(x7)                            ;
_l68:   fmul.s f13, f5, f1, rne                   ;
_l69:   addw x5, x3, x9                           ;
_l70:   feq.s x20, f5, f27                        ;
_l71:   fcvt.l.s x0, f6, rne                      ;
_l72:   fcvt.s.l f27, x12, rne                    ;
_l73:   flt.s x28, f28, f30                       ;
_l74:   la x27, d_0_20                            ;
        lw x23, 24(x27)                           ;
_l75:   sret                                      ;
_l76:   ori x12, x29, 1535                        ;
_l77:   fnmsub.s f31, f25, f25, f1, rne           ;
_l78:   la x13, d_1_20                            ;
        addi x13, x13, -20                        ;
        amoswap.w x28, x23, (x13)                 ;
_l79:   slliw x19, x12, 9                         ;
_l80:   fmv.x.w x22, f16                          ;
_l81:   sraw x10, x26, x18                        ;
_l82:   li x30, 0                                 ;
        la x29, pt2                               ;
        addi x29, x29, 40                         ;
        sfence.vma x30, x29                       ;
_l83:   la x2, d_2_25                             ;
        addi x2, x2, 28                           ;
        amomaxu.w x8, x20, (x2)                   ;
_l84:   sret                                      ;
_l85:   la x13, d_1_22                            ;
        addi x13, x13, 0                          ;
        lr.d x6, (x13)                            ;
_l86:   fcvt.w.s x1, f11, rne                     ;
_l87:   la x4, d_4_22                             ;
        lh x8, 26(x4)                             ;
_l88:   la x11, d_5_24                            ;
        addi x11, x11, 24                         ;
        amomin.d x27, x22, (x11)                  ;
_l89:   slliw x7, x25, 10                         ;
_l90:   la x30, d_1_17                            ;
        addi x30, x30, -24                        ;
        sc.d x7, x30, (x30)                       ;
_l91:   fclass.s x18, f24                         ;
_l92:   feq.s x0, f16, f16                        ;
_l93:   fsub.s f12, f25, f7, rne                  ;
_l94:   la x17, d_3_12                            ;
        addi x17, x17, -28                        ;
        amomaxu.w x15, x9, (x17)                  ;
_l95:   la x30, d_1_12                            ;
        addi x30, x30, 16                         ;
        amoand.w x18, x6, (x30)                   ;
_l96:   la x27, d_4_27                            ;
        lhu x26, -30(x27)                         ;
_l97:   la x12, d_5_2                             ;
        addi x12, x12, -0                         ;
        amoand.d x9, x13, (x12)                   ;
_l98:   fsqrt.s f11, f12, rne                     ;
_l99:   la x8, d_2_26                             ;
        addi x8, x8, -16                          ;
        lr.d x9, (x8)                             ;
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
                .dword 0xfd2bb95d8f89a14e, 0x55563df398517fc1
                .dword 0x8158859f22570766, 0xe160ba53626b24cd
d_0_0:          .dword 0x6d0796608c53e40b, 0x09ea0e956cb38999
d_0_1:          .dword 0xa4500d3d30874121, 0xa96be052d0b17a79
d_0_2:          .dword 0xcbd0ab040046572b, 0xae7984a92ea0b61c
d_0_3:          .dword 0xd66742af0a32f282, 0x0e9fb75a1955cd99
d_0_4:          .dword 0x08192c77ded803a8, 0x5a3ce82619474ce8
d_0_5:          .dword 0xb34c9c272b3745d4, 0x652a2e2c6c6bce7f
d_0_6:          .dword 0x0d441c51405fea81, 0x242f3418ca68714d
d_0_7:          .dword 0x5e31818ac7d64610, 0x2d5c025a7a6ddc72
d_0_8:          .dword 0x113ba85a4c533d0e, 0x426ea44ad77937d8
d_0_9:          .dword 0x3f22e8847246ce22, 0xc48916586e240c30
d_0_10:         .dword 0xd54136db63e3e800, 0x1fde2f9cee5d8b76
d_0_11:         .dword 0x3770c7b06e76e917, 0xb59c1f8d8076f820
d_0_12:         .dword 0x21141d32be4fa564, 0x1dbdae4b10672ea6
d_0_13:         .dword 0x464fe4c3b7203a06, 0x248123600d18973c
d_0_14:         .dword 0xab7a2fb7d0c7272d, 0x090ac69ce307169b
d_0_15:         .dword 0xac8c07c9a662e6d9, 0xfd20cf6574b9ab7a
d_0_16:         .dword 0x7d13c6f192aa2bfd, 0x8f6ddf600a02ed20
d_0_17:         .dword 0x1b87abb162a49705, 0x1d6340f40300a297
d_0_18:         .dword 0x0877f2fc7c635161, 0xd44ca643f63305d1
d_0_19:         .dword 0xe385188638529f5a, 0x3b07482a4190059a
d_0_20:         .dword 0xf1b183daca4f188e, 0xa96284eabbe96efe
d_0_21:         .dword 0xf8a86834c6d35e3b, 0x3688751b2a05cb62
d_0_22:         .dword 0x8e299414fccdc26a, 0xf0d919736de993a2
d_0_23:         .dword 0xe93215b39fc5405c, 0xde85fc1cb736bbda
d_0_24:         .dword 0xc0e25ecb9a288559, 0xe5d75d4a43b23356
d_0_25:         .dword 0x772abc5a23047f9d, 0x1fc0be1ed83dd872
d_0_26:         .dword 0xc098ea22429a3783, 0xd6e9da519d7ef66c
d_0_27:         .dword 0xb25c33e5e3cb8858, 0x70263e7f4d343965
                .dword 0xd87d77efbd975f19, 0xd8b390d28e3572f4
                .dword 0x16f5ac9a8ec57e7a, 0x90b88e9f94b2eda7
        /* Random data */
_end_data0:
                 

    .section .data.random1;
    .align  8;

_random_data1:
                .dword 0xed31545052a6a030, 0x11fd3e0af35d7638
                .dword 0x7880052a217af366, 0x558e2250538e8906
d_1_0:          .dword 0x924d2f6ab49f4b76, 0xe2467b2ca3fe19a1
d_1_1:          .dword 0x70f5e4f4bd617444, 0x56bff644169af6c3
d_1_2:          .dword 0x9f19139ca15fc0bc, 0x6450c8c32d7cb816
d_1_3:          .dword 0x0a5827d192fdaad1, 0xa094b4a62a1ec5ab
d_1_4:          .dword 0x6a2319dcb638268c, 0x8128e87846461de0
d_1_5:          .dword 0x4a6d1c5fa69b6824, 0x4e88e1ada85b746c
d_1_6:          .dword 0x879358860fcad7ef, 0x763e1b6c8b8a1de5
d_1_7:          .dword 0xacc3034fa609b3ac, 0xa73477c29140cf5a
d_1_8:          .dword 0x0d3d7b6702c590c5, 0x9db9f8683144b75e
d_1_9:          .dword 0xe4ac95d22ab3bc6b, 0xf955148a0a74b636
d_1_10:         .dword 0x6b8a7c62c7a4f618, 0x84840b566eba4b7a
d_1_11:         .dword 0x689360b1893af407, 0x73035f04bff830e1
d_1_12:         .dword 0x69cfeb9fc5b364c2, 0x9af34e9851622e4f
d_1_13:         .dword 0xcf3008add7bf958a, 0x893d9ee4c811b5fe
d_1_14:         .dword 0x16fd5cdbfde5b7ea, 0xbaad459efd8bce4a
d_1_15:         .dword 0xffb6f94642f77b3d, 0xc3b8c277681a5d3a
d_1_16:         .dword 0xce2eed1e0bf5d934, 0xd8aa946955e7b244
d_1_17:         .dword 0xff4eabaf19787f4c, 0xb362e5e388350b8f
d_1_18:         .dword 0x363b30142002eef4, 0xaa3c94334e5bd44f
d_1_19:         .dword 0xcc363c9327743090, 0xdf8f22fd46634f2e
d_1_20:         .dword 0x5e83db9faa9a09bf, 0x3f12419dba426f1b
d_1_21:         .dword 0x48f1cdb4e11b7d54, 0x2b2c624e1201d3ac
d_1_22:         .dword 0x55709372636804ed, 0x4686a3fe534b0450
d_1_23:         .dword 0x4743907e0cd6ec35, 0x0dd23316b3dfa174
d_1_24:         .dword 0xe29b8fcbf54110d3, 0x2ebfcca898286bde
d_1_25:         .dword 0xa52b623ece0b2560, 0x8b135d07d1a4fc50
d_1_26:         .dword 0x59d82e6e5e5fc583, 0xb15eaa0bb52c80d0
d_1_27:         .dword 0x8e3739728c3b8771, 0x8076cc1b596da209
                .dword 0xe08fc5eca4ae7e1a, 0x0cc8c99516f66c4b
                .dword 0x7ac1bf9c494d3d74, 0x2b3f0524102764ca
        /* Random data */
_end_data1:


    .section .data.random2;
    .align  8;

_random_data2:
                .dword 0xc2b2eaee2c8afaf7, 0x5d545112f671e18c
                .dword 0x58363b9754c03b0d, 0xefd7606be5dd268a
d_2_0:          .dword 0x878e4321f4401380, 0x8f35cdb218c41f6d
d_2_1:          .dword 0xb15c7477bf699f14, 0x0f3056f70d0800dc
d_2_2:          .dword 0xcf4a2cd2e354fa92, 0x395d25b75f5e2390
d_2_3:          .dword 0x131a2b22a2c70b5f, 0xd130679423acb62e
d_2_4:          .dword 0x8031df2bd3741c6d, 0x0ea4331bbe5ab748
d_2_5:          .dword 0x1d44eee842c034db, 0xa64fd596fe93a473
d_2_6:          .dword 0x23e04203ff5c0056, 0x8014f5976bf1b0c7
d_2_7:          .dword 0xfabf6e2f3d7a6b9b, 0x3ab219a098f7811b
d_2_8:          .dword 0x5a34725833238169, 0x0342fa2a4809fb9e
d_2_9:          .dword 0xbd51a823c718ad1f, 0x5420e179217a1b6c
d_2_10:         .dword 0x13fb254d56ee5125, 0xe3147939e32b4c19
d_2_11:         .dword 0x0c32c4c5f6491db1, 0xe8fe3e9839e003ff
d_2_12:         .dword 0x032af07f3ba83d9a, 0x8aa7447413e6616b
d_2_13:         .dword 0x65533f9d30f15945, 0xe2b8255f6dd366a0
d_2_14:         .dword 0xa90d2322f13c43af, 0x7d2aa45728243e54
d_2_15:         .dword 0x21bde858b491e732, 0x1fee6df43059a386
d_2_16:         .dword 0x42302186b9eb8779, 0xc62b98c73e48573b
d_2_17:         .dword 0xfe782a034f42d002, 0x591cff87e2fa730c
d_2_18:         .dword 0xd37a80f7055ce0ae, 0xb4705e9b6402379f
d_2_19:         .dword 0x2e4e97685b91ba5b, 0x22adf51c28e0badb
d_2_20:         .dword 0xc8cceddb36da8f63, 0xe0d9dfa2624d2828
d_2_21:         .dword 0xd929fb68c6b1ab79, 0x4fe0bd768c19226e
d_2_22:         .dword 0x3cd727dafc74a14c, 0x9e55b15a3dfef194
d_2_23:         .dword 0x325fabb8adb20ee6, 0x1bd08d0e8ed90cb0
d_2_24:         .dword 0x81327fcc5424c973, 0xd0c00839e7abd9e8
d_2_25:         .dword 0x05977a4c33de3a9e, 0xab4946de2cbfad9b
d_2_26:         .dword 0x91f1c54eb5a098ca, 0x866d93599a8ecff8
d_2_27:         .dword 0x7b5f532b7cfcf68b, 0xc1587daaa342ca44
                .dword 0x7aeaadbcffe77010, 0x1e48b40802be2bf6
                .dword 0xd93ece055e46e0cb, 0x333c113db39d4380
         /* Random data */
_end_data2:
                

    .section .data.random3;
    .align  8;

_random_data3:
                .dword 0xda78e315a3927e35, 0x2c86f4f9b7adb7db
                .dword 0x9764ad35e8369b11, 0x51e2da6e8fd5212b
d_3_0:          .dword 0xd4450070eda67a01, 0xf61d6c5844003b65
d_3_1:          .dword 0xc0e1a310f7d080ac, 0xf028568874404055
d_3_2:          .dword 0x3aba074222d6dbd8, 0x4ba1b388801063ef
d_3_3:          .dword 0x8fb4eceef3e9c7bd, 0x28e8723fd6552426
d_3_4:          .dword 0x7953affe25afa950, 0x6e2aaa43fdc3c18a
d_3_5:          .dword 0x0d35bd15c3ddd8b4, 0xc9c6971e6a7d894f
d_3_6:          .dword 0xa3c0b9d0cb7dafe4, 0xadadcb0bf3fab754
d_3_7:          .dword 0x4a7794eb0198fcce, 0xdaf470df06da043c
d_3_8:          .dword 0xcc576a42fce25780, 0x356d966414b26c11
d_3_9:          .dword 0x465869b92167c474, 0xb731418d67444a25
d_3_10:         .dword 0x08584af21e90ebf1, 0xe8cc8dfc5f393d5d
d_3_11:         .dword 0xc1519036d7eef865, 0x7a5986a8c4388075
d_3_12:         .dword 0xc2f7daedcaf50cbc, 0x2c499cbd3ee428cb
d_3_13:         .dword 0x6840b97cf665d58f, 0x88745a8eaa2ea7e8
d_3_14:         .dword 0x81320de458a98a82, 0x59da35d22cdeda09
d_3_15:         .dword 0x8a709c2b37cea524, 0xb37768dfb48787ef
d_3_16:         .dword 0xf834d04ddf50c76c, 0xbf6048f1255aa45f
d_3_17:         .dword 0xc2ea39d5a6a31811, 0x5f4eb802d205fcec
d_3_18:         .dword 0x076d61d2949e21a4, 0xd3263f9c583f7193
d_3_19:         .dword 0xa3fc583fa0be0492, 0xc7cf31bf833daff0
d_3_20:         .dword 0xe3db097244e10213, 0xde74c4ff14719895
d_3_21:         .dword 0x85f11bc5d5fe7643, 0x95747ae676c1bbab
d_3_22:         .dword 0xb39071caef7f08f1, 0x324ba1ddd72eacec
d_3_23:         .dword 0x0c90ece47f09c32d, 0x0cb444c4ff72d55a
d_3_24:         .dword 0x029840849108cf51, 0xcaa920b9e012f8d5
d_3_25:         .dword 0x84136d7274ad33ef, 0x7e0f4344293a7d8f
d_3_26:         .dword 0x17344c2fcbd58164, 0x26138c0e5ca64955
d_3_27:         .dword 0xd522d21226b5a827, 0x5d57cc879a19fe7a
                .dword 0xee716581ab64a6a4, 0x12e89f87137a7b01
                .dword 0x3479e327818a2abb, 0x62a44d5c8a61d47d
        /* Random data */
_end_data3:


    .section .data.random4;
    .align  8;

_random_data4:
                .dword 0xe9fe26f2f565c2db, 0xb6e39d751dac69b4
                .dword 0x5762579ab3823c3c, 0xe4087c1bede31f42
d_4_0:          .dword 0x7cea0c007dbba1e1, 0xa011cd7b06eb915f
d_4_1:          .dword 0x55522fb51f85c3e2, 0x42c78f8b3ae957bb
d_4_2:          .dword 0x1cef2f9cc070adb7, 0x9dbfdf8e314bb3db
d_4_3:          .dword 0xdf6f33f182a1d3fb, 0xddb6bd0d9506ceb4
d_4_4:          .dword 0x71b69cf687919f7d, 0x6b073d695d3a88b0
d_4_5:          .dword 0x656abb77c4541be1, 0x8d02edfcd5407c15
d_4_6:          .dword 0x74960cabc89f33c0, 0x7decbb97c804c1e1
d_4_7:          .dword 0x95c6c24161920d53, 0xa532f3e0e7b3fd02
d_4_8:          .dword 0xcd21466fd64eef58, 0x4136dfa2ed117dae
d_4_9:          .dword 0xdb445eab81153aeb, 0x638553bfbc67f22f
d_4_10:         .dword 0xce85249be307b350, 0xb8e51f7d9516e2ac
d_4_11:         .dword 0x4a3c0c057ccfb69c, 0x5d78c5636759a643
d_4_12:         .dword 0x0a16dcf662e65699, 0x6683808db0be4b76
d_4_13:         .dword 0x722b50d83ac6b2e2, 0xdf8739d47de0f176
d_4_14:         .dword 0x99317132e03ff638, 0x49819c1bbe1617da
d_4_15:         .dword 0x992403f42628c547, 0x9b32ac472a7a19de
d_4_16:         .dword 0x621f16a94e6e6e78, 0x26050166b0ec778f
d_4_17:         .dword 0xdb18a4b849133dfb, 0xb93de016f3269ef9
d_4_18:         .dword 0x0e347e19437aff7c, 0x738459e5b6d7dd0c
d_4_19:         .dword 0x48669fd11f87aeae, 0x4b3707162d1a9f03
d_4_20:         .dword 0x84524a50e2f142d6, 0x86f19f2607f210ab
d_4_21:         .dword 0x9a5df2785b15878e, 0xf3b34adcf857b48d
d_4_22:         .dword 0x83a74ecf97f28841, 0x22a02cd83b457bfd
d_4_23:         .dword 0xf189a2cd6ec3009c, 0x065648b78d15c49c
d_4_24:         .dword 0x4bfe096f163029c0, 0x12d7c67721e5e4d8
d_4_25:         .dword 0xdf7a22db7255dc23, 0xfd3164adf2444fb3
d_4_26:         .dword 0x84af24faf82da690, 0x41466e667a7398cd
d_4_27:         .dword 0xa377c6dc4ecbd665, 0x4d1a2765ece09b77
                .dword 0x6af00dee0ed9fe21, 0xd9e367948ab50ff7
                .dword 0xdff0ab18460a19b2, 0x99e56ebd57d67605
        /* Random data */
_end_data4:


    .section .data.random5;
    .align  8;

_random_data5:
                .dword 0x38555fe6a692d419, 0x54f1af28361bd200
                .dword 0x6bd4a43e5f521bc1, 0x8183f1d5c972425c
d_5_0:          .dword 0x47e40b140ddaf5cc, 0xdce922d8c5cd0db6
d_5_1:          .dword 0xa7274be203c7bf61, 0xbe804ef5e8d4e54e
d_5_2:          .dword 0xa85d6a188dbe7b83, 0xb9032cea881d234e
d_5_3:          .dword 0xbfadd26b338984f2, 0x13e852b95834797d
d_5_4:          .dword 0x361d682d81eac2ac, 0x527b5ad96ccc1908
d_5_5:          .dword 0xa33c95b5c3549a22, 0x2320b56dc71e814a
d_5_6:          .dword 0x3bdddfac13de69d9, 0x77f6269b8211ffd7
d_5_7:          .dword 0xc3ad9bf2c64b62f8, 0x8c5aacb780b695e3
d_5_8:          .dword 0xcbbb4e6adeebb8a5, 0xa8983bb5fb61f2a9
d_5_9:          .dword 0xd9215c4f02a3ca31, 0x145aa487043ea324
d_5_10:         .dword 0xe58c079202521cd4, 0x296d2646d438aa2b
d_5_11:         .dword 0x992fb298e2470022, 0x91137a145574c21a
d_5_12:         .dword 0x1f274963b678f75e, 0x237f4e501a09555c
d_5_13:         .dword 0x7de4f629c45202d5, 0x93eab3183d6b6996
d_5_14:         .dword 0x7d50ec9a323690a2, 0xc263a4ad7212475f
d_5_15:         .dword 0x39d1bbb36a1541c4, 0xaeb062e2590b574d
d_5_16:         .dword 0x9b335d1169611d30, 0x59a6071546d45e10
d_5_17:         .dword 0x561130a4b9c5f6ce, 0x0a7f657d5d142844
d_5_18:         .dword 0x98681a579d92f79a, 0x79733d27e6ca09fd
d_5_19:         .dword 0x8e6b57461f9ce97d, 0x004f8eec1f3de7ba
d_5_20:         .dword 0xd84440c2ae0f149e, 0x25705ba14c97e441
d_5_21:         .dword 0xe24191751d014849, 0x816e6c7fe433c894
d_5_22:         .dword 0xc29e40b56a1a56bf, 0x7fd87d243520facc
d_5_23:         .dword 0xc9a55833645fbea1, 0x194f404402cdcb9e
d_5_24:         .dword 0xcf292207a098ce91, 0x299a3527265c7309
d_5_25:         .dword 0x79196fa25db0f4ff, 0x169e26afe04bab9c
d_5_26:         .dword 0x1f6a2c8bb9da1b75, 0xa4221a757ca4d9f8
d_5_27:         .dword 0xa16ab2c87a772d32, 0x57c1c67af1542ba7
                .dword 0xb68ef1a61f00aa3a, 0xc12f2aac44e191ee
                .dword 0xe5a444feefa6279a, 0x40af5cc1f76e0b2f
         /* Random data */
_end_data5:
              
                 
