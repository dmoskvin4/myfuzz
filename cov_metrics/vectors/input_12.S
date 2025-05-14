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
_s0:    la x11, d_5_11                            ;
        lhu x22, 0(x11)                           ;
_s1:    srai x27, x28, 8                          ;
_s2:    la x14, d_0_1                             ;
        addi x14, x14, 12                         ;
        amoand.w x16, x5, (x14)                   ;
_s3:    srli x15, x16, 0                          ;
_s4:    sltiu x18, x11, -1745                     ;
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
_p0:    csrrsi x11, pmpaddr2, 4                   ;
_p1:    la x10, d_0_14                            ;
        srai x10, x10, 1                          ;
        csrrw x12, pmpaddr7, x10                  ;
_p2:    la x11, d_4_3                             ;
        srai x11, x11, 1                          ;
        csrrs x13, pmpaddr0, x11                  ;
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
_l0:    fcvt.s.w f4, x10, rne                     ;
_l1:    fmadd.s f4, f10, f21, f30, rne            ;
_l2:    la x15, d_1_24                            ;
        addi x15, x15, 16                         ;
        amominu.w x11, x25, (x15)                 ;
_l3:    xor x24, x24, x24                         ;
        addi x14, zero, 3                         ;
        slli x14, x14, 20                         ;
        add x24, x24, x14                         ;
        addi x12, zero, 1                         ;
        slli x12, x12, 3                          ;
        add x24, x24, x12                         ;
        addi x22, zero, 1                         ;
        slli x22, x22, 0                          ;
        add x24, x24, x22                         ;
        csrrw x25, sie, x24                       ;
_l4:    srli x17, x28, 63                         ;
_l5:    csrrsi x21, pmpaddr5, 4                   ;
_l6:    ori x6, x30, -4                           ;
_l7:    fclass.s x17, f9                          ;
_l8:    la x22, d_0_7                             ;
        lh x11, 22(x22)                           ;
_l9:    la x20, d_0_4                             ;
        sb x15, 15(x20)                           ;
_l10:   fcvt.s.wu f0, x21, rne                    ;
_l11:   uret                                      ;
_l12:   la x12, d_0_23                            ;
        lw x28, 28(x12)                           ;
_l13:   mret                                      ;
_l14:   la x10, d_0_23                            ;
        addi x10, x10, -20                        ;
        amomin.w x17, x22, (x10)                  ;
_l15:   slliw x29, x3, 0                          ;
_l16:   subw x29, x15, x12                        ;
_l17:   fsqrt.s f1, f20, rne                      ;
_l18:   la x27, d_3_11                            ;
        srai x27, x27, 1                          ;
        csrrc x9, pmpaddr2, x27                   ;
_l19:   sltiu x22, x22, -2047                     ;
_l20:   la x25, d_0_19                            ;
        addi x25, x25, -16                        ;
        sc.w x6, x20, (x25)                       ;
_l21:   la x9, d_4_13                             ;
        addi x9, x9, 24                           ;
        sc.w x14, x18, (x9)                       ;
_l22:   fmadd.s f25, f8, f18, f21, rne            ;
_l23:   fmv.x.w x5, f26                           ;
_l24:   feq.s x3, f9, f0                          ;
_l25:   la x1, d_4_22                             ;
        addi x1, x1, 20                           ;
        amomin.w x21, x1, (x1)                    ;
_l26:   fnmadd.s f26, f16, f21, f23, rne          ;
_l27:   fadd.s f11, f2, f16, rne                  ;
_l28:   la x19, d_5_27                            ;
        addi x19, x19, 8                          ;
        amominu.w x19, x27, (x19)                 ;
_l29:   la x27, d_2_15                            ;
        addi x27, x27, 16                         ;
        lr.d x1, (x27)                            ;
_l30:   andi x20, x20, 2047                       ;
_l31:   srlw x18, x30, x25                        ;
_l32:   sltiu x5, x5, 0                           ;
_l33:   srliw x22, x4, 31                         ;
_l34:   la x11, d_4_7                             ;
        addi x11, x11, 24                         ;
        amoadd.d x8, x24, (x11)                   ;
_l35:   fcvt.s.w f11, x9, rne                     ;
_l36:   fcvt.l.s x15, f11, rne                    ;
_l37:   la x6, d_0_0                              ;
        addi x6, x6, 16                           ;
        amomin.d x12, x21, (x6)                   ;
_l38:   fmax.s f23, f21, f16                      ;
_l39:   la x21, d_0_5                             ;
        sh x29, 12(x21)                           ;
_l40:   addiw x17, x11, 1838                      ;
_l41:   la x30, d_1_0                             ;
        fsw f18, -24(x30)                         ;
_l42:   fmv.w.x f27, x19                          ;
_l43:   lui x12, 13                               ;
_l44:   fcvt.l.s x27, f29, rne                    ;
_l45:   csrrwi x4, frm, 3                         ;
_l46:   fcvt.s.l f18, x11, rne                    ;
_l47:   la x29, d_5_5                             ;
        addi x29, x29, 24                         ;
        amomax.d x29, x4, (x29)                   ;
_l48:   la x4, d_4_21                             ;
        sw x13, 28(x4)                            ;
_l49:   la x6, d_0_14                             ;
        lbu x23, -11(x6)                          ;
_l50:   la x10, d_5_22                            ;
        addi x10, x10, -8                         ;
        amomaxu.d x9, x14, (x10)                  ;
_l51:   la x28, d_5_14                            ;
        lui x14, 0xffe00                          ;
        xor x28, x28, x14                         ;
        lb x26, -4(x28)                           ;
_l52:   fnmsub.s f2, f8, f6, f5, rne              ;
_l53:   fcvt.l.s x8, f29, rne                     ;
_l54:   flt.s x9, f26, f24                        ;
_l55:   la x26, d_3_22                            ;
        addi x26, x26, -0                         ;
        amoxor.d x7, x2, (x26)                    ;
_l56:   la x7, d_3_12                             ;
        addi x7, x7, 16                           ;
        lui x3, 0xffe00                           ;
        xor x7, x7, x3                            ;
        amomax.d x13, x3, (x7)                    ;
_l57:   addw x20, x18, x13                        ;
_l58:   mret                                      ;
_l59:   la x21, d_4_7                             ;
        addi x21, x21, 20                         ;
        lui x26, 0xffe00                          ;
        xor x21, x21, x26                         ;
        amomax.w x14, x26, (x21)                  ;
_l60:   ori x10, x19, 19                          ;
_l61:   la x17, d_5_0                             ;
        addi x17, x17, 24                         ;
        amoor.d x4, x9, (x17)                     ;
_l62:   la x19, d_1_20                            ;
        addi x19, x19, -0                         ;
        amominu.d x21, x12, (x19)                 ;
_l63:   la x27, d_1_26                            ;
        addi x27, x27, 0                          ;
        amoand.d x1, x22, (x27)                   ;
_l64:   fle.s x6, f18, f25                        ;
_l65:   fcvt.s.l f29, x19, rne                    ;
_l66:   la x11, d_5_6                             ;
        addi x11, x11, 16                         ;
        sc.w x5, x30, (x11)                       ;
_l67:   fmul.s f18, f9, f20, rne                  ;
_l68:   fcvt.wu.s x13, f1, rne                    ;
_l69:   la x16, d_2_6                             ;
        addi x16, x16, 0                          ;
        amomaxu.d x5, x5, (x16)                   ;
_l70:   fsub.s f26, f29, f14, rne                 ;
_l71:   la x14, d_4_13                            ;
        addi x14, x14, 24                         ;
        amomax.w x23, x18, (x14)                  ;
_l72:   la x23, d_1_1                             ;
        addi x23, x23, 8                          ;
        lui x26, 0xffe00                          ;
        xor x23, x23, x26                         ;
        amoadd.d x26, x26, (x23)                  ;
_l73:   fcvt.s.lu f5, x18, rne                    ;
_l74:   fdiv.s f25, f25, f23, rne                 ;
_l75:   fadd.s f29, f12, f31, rne                 ;
_l76:   la x22, d_5_16                            ;
        addi x22, x22, 0                          ;
        amoand.w x19, x12, (x22)                  ;
_l77:   fnmadd.s f20, f2, f2, f16, rne            ;
_l78:   la x28, _l54                              ;
        srai x28, x28, 1                          ;
        csrrs x28, pmpaddr6, x28                  ;
_l79:   fmv.x.w x9, f28                           ;
_l80:   fdiv.s f30, f22, f26, rne                 ;
_l81:   la x7, d_2_0                              ;
        addi x7, x7, 28                           ;
        amoadd.w x12, x13, (x7)                   ;
_l82:   la x18, d_4_4                             ;
        addi x18, x18, 8                          ;
        amoor.d x11, x8, (x18)                    ;
_l83:   ori x26, x17, 1201                        ;
_l84:   fmadd.s f22, f3, f2, f10, rne             ;
_l85:   la x23, d_3_13                            ;
        addi x23, x23, -24                        ;
        amoxor.d x7, x18, (x23)                   ;
_l86:   la x19, d_0_21                            ;
        addi x19, x19, -0                         ;
        amominu.d x18, x27, (x19)                 ;
_l87:   slli x29, x14, 0                          ;
_l88:   addw x9, x30, x20                         ;
_l89:   la x6, d_5_8                              ;
        lh x9, -12(x6)                            ;
_l90:   la x22, d_5_11                            ;
        lui x24, 0xffe00                          ;
        xor x22, x22, x24                         ;
        sb x6, 31(x22)                            ;
_l91:   fmv.w.x f20, x25                          ;
_l92:   fsgnjx.s f9, f0, f3                       ;
_l93:   la x14, _l48                              ;
        lui x3, 0xffe00                           ;
        xor x14, x14, x3                          ;
        flw f21, -0(x14)                          ;
_l94:   la x21, d_0_7                             ;
        addi x21, x21, -0                         ;
        amominu.d x28, x7, (x21)                  ;
_l95:   andi x18, x16, 1946                       ;
_l96:   la x9, d_1_4                              ;
        addi x9, x9, 4                            ;
        amominu.w x26, x17, (x9)                  ;
_l97:   xori x30, x29, -2010                      ;
_l98:   li x3, 1                                  ;
        la x12, pt3                               ;
        addi x12, x12, 24                         ;
        sfence.vma x3, x12                        ;
_l99:   fcvt.s.w f10, x4, rne                     ;
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
                .dword 0xfa40b930a1cfd49b, 0x8a8486360b88e391
                .dword 0x2766d76e70d0d0a4, 0xe2f236e7ea70eedb
d_0_0:          .dword 0x42e2e2193edce275, 0xf06b081f391fd787
d_0_1:          .dword 0x957ce81ddc1d2cfe, 0x98598a664ea531df
d_0_2:          .dword 0x2a2d7306f467f3ac, 0xf6410fc5b0ab49b5
d_0_3:          .dword 0xc81fcd59977461ed, 0x2db51cd34b2ec19a
d_0_4:          .dword 0x6c03b5f5a4f27584, 0xad41d76419335190
d_0_5:          .dword 0x2b412d37ac212bf6, 0xfea630faf0979e33
d_0_6:          .dword 0xf0a90a60c4778cde, 0xf7dc685e06fb4523
d_0_7:          .dword 0xe15bfeb5ba4d3b34, 0xf19a44dfa1e885df
d_0_8:          .dword 0x089be0fe09d70ea0, 0x32f3b3cf18c2c235
d_0_9:          .dword 0x7265425938acf0d7, 0xf0dfd3497f2b27fb
d_0_10:         .dword 0x32253160b1f83a82, 0x80c8f52475543b63
d_0_11:         .dword 0x03027194708ecb98, 0x702de88487f4f1a0
d_0_12:         .dword 0x9367898b86646fa7, 0x7c4c154a4f1662d8
d_0_13:         .dword 0xcfb89f0898ce45c3, 0xb2eccfcd812823ee
d_0_14:         .dword 0xe8bb17f7bbbaab84, 0x2b31697e31a831da
d_0_15:         .dword 0x00c5753c8bc20f1d, 0x9ea7a0674ccdabf0
d_0_16:         .dword 0x68cc6dad2cbfd33c, 0xa2ad221cc1112cbb
d_0_17:         .dword 0x8bca9d9373c267c6, 0xa371f1c3685be302
d_0_18:         .dword 0x3c87a4f59e555623, 0x360ec899024dbe70
d_0_19:         .dword 0x5b1dffcceaefe933, 0xf9ba93ab4b35f47d
d_0_20:         .dword 0xee855cd942a45962, 0xab6c6e4fffc02a6d
d_0_21:         .dword 0x9cc91624b3fa07b6, 0xcc53fe32064be5e2
d_0_22:         .dword 0x816f0fe091c1458d, 0xdb199b9fecd84db6
d_0_23:         .dword 0x53c1e1c3b716c706, 0xd848370283b610c3
d_0_24:         .dword 0xf1c01e0dd38398f4, 0xbc78ff112037ad4c
d_0_25:         .dword 0x7bda2c06c70199e3, 0xe12751729850eccb
d_0_26:         .dword 0x67869f02b239c091, 0xbb6c63eb5dd8abd9
d_0_27:         .dword 0xc9475732aafeaa19, 0x5bff2755e8a14bb3
                .dword 0x53092a8f83d45b96, 0x9afd7ea0139fb5ee
                .dword 0xad1b13f864f70fc6, 0xc2d89fc97342e202
        /* Random data */
_end_data0:
                 

    .section .data.random1;
    .align  8;

_random_data1:
                .dword 0x9442b960b54a9ebb, 0xbba5e44d4b19bb1b
                .dword 0xdda65e1b7fcca2c6, 0x5fed152f6807cecf
d_1_0:          .dword 0x8c8cf663d90d390c, 0x101fbe7f4004e85a
d_1_1:          .dword 0xdc2eda30a05d8575, 0x9a043d55844f5dce
d_1_2:          .dword 0x6a7c96a6d522a1ca, 0x3c72a74e32a25d3b
d_1_3:          .dword 0xf50fdd0c243b8fb8, 0x2bb01390535b70e4
d_1_4:          .dword 0x202717168c5efbb4, 0x4795a4f19100b5fd
d_1_5:          .dword 0xa44b4d661657a7b3, 0x1d5e1a690bc3480d
d_1_6:          .dword 0xbae89c9ea5ccad25, 0x091a359a93467710
d_1_7:          .dword 0x28fe753287ef8e24, 0x20daca59b25d3f5c
d_1_8:          .dword 0x720750879c7c6486, 0x7667b412a4eb95c2
d_1_9:          .dword 0x4fef8815fd7d3ea1, 0x7e449de982821f82
d_1_10:         .dword 0x748bfa4f5fca9f2c, 0x66889152ac18737b
d_1_11:         .dword 0x2d7c0c93fefe656f, 0xf1530abeeabff6b1
d_1_12:         .dword 0x6405bc97db6c180b, 0xa04d0b216d80079b
d_1_13:         .dword 0x82c83ca0c2e767c8, 0xc56f8165566d494d
d_1_14:         .dword 0xe2c041ba6e65877e, 0x81689fe852a658b5
d_1_15:         .dword 0xf7fedf4f5f61eb5d, 0x8a02a73870db0efa
d_1_16:         .dword 0x95806a77c61ae7cf, 0xf66a622ebf16f404
d_1_17:         .dword 0xaac63d472b19b88e, 0x517206938ed18936
d_1_18:         .dword 0x5d9d372e415ff1b9, 0xf32b44df086e0bea
d_1_19:         .dword 0x5de662c3c99bddb4, 0x410be17e42599df1
d_1_20:         .dword 0x6349c8755a02508e, 0x4445a3e656bec5a4
d_1_21:         .dword 0x1b81f83e3c2b473e, 0xddc40704dc9f7392
d_1_22:         .dword 0x85514da515bb4707, 0x95b9f2b8bae662c6
d_1_23:         .dword 0x565a98131a8cfaeb, 0xe45f19efeba8b134
d_1_24:         .dword 0xa05d8a481f84d5ab, 0x4ff8653909a68354
d_1_25:         .dword 0x3989562f31d8828a, 0xff6caf2f588252e0
d_1_26:         .dword 0x64f145a39178f5e7, 0x176c80a6e4a066d3
d_1_27:         .dword 0x3be90349eee96873, 0x955e87007ba87e83
                .dword 0x6503506156216a66, 0x52f3e983c1113015
                .dword 0x38541d005927f02c, 0x456bafdcd2e697de
        /* Random data */
_end_data1:


    .section .data.random2;
    .align  8;

_random_data2:
                .dword 0xf61b1fbbbc0cc8aa, 0xf5a9a238f64fcd9f
                .dword 0x68ec74e8e9e8c4c4, 0x0ad33aa379f0c782
d_2_0:          .dword 0x029ec753ca26ca7d, 0x4be047cfec57f316
d_2_1:          .dword 0x9b327c076f8cf897, 0x289f0ac447b8841c
d_2_2:          .dword 0x99832dffc6f7962f, 0x93a0b1e50c7ad40e
d_2_3:          .dword 0x1163069f5b663201, 0x69b04c6993c4a696
d_2_4:          .dword 0x7d42c59e67491c52, 0x67f29f82b51b467e
d_2_5:          .dword 0xf1987a67d4da66df, 0xfab787128d264a47
d_2_6:          .dword 0x3f36593a1624f8fa, 0x5f9201ad990e0140
d_2_7:          .dword 0xa9fb7b4cfb6863f6, 0x6bf36b4c6ea8ac41
d_2_8:          .dword 0xeb2c1c94411a0f92, 0x0bf8cff2604d4610
d_2_9:          .dword 0xcdad7e4c0b2715a3, 0x2ad742ac70ef4f24
d_2_10:         .dword 0xad00521a83a62012, 0x26e2036f48a17687
d_2_11:         .dword 0x64bb3a74ef73b373, 0x39770626d03e3cb6
d_2_12:         .dword 0xbd29716cddb3d32d, 0xbe1351f780ac8ac8
d_2_13:         .dword 0x88e05815cdaef8a5, 0xa8787758d1d9753a
d_2_14:         .dword 0x8a15454c100f4b0f, 0xd5daa1ee4d0cccd7
d_2_15:         .dword 0x6f38badb954e23f5, 0xdae7435dbf6ef397
d_2_16:         .dword 0xfac7eb7b64c8748d, 0x27ff2ec235a0dee9
d_2_17:         .dword 0x458c36ce85491b00, 0x70451e0fa29dc540
d_2_18:         .dword 0x5abce63dc4eac579, 0xd8334c612de0d788
d_2_19:         .dword 0xf2e7114bfb417c7b, 0xe428f2c2da11c07e
d_2_20:         .dword 0xd53af11f3c52544b, 0xa1356158144f42ab
d_2_21:         .dword 0x680e5fe5be2bb874, 0x5cd79adc7b707a31
d_2_22:         .dword 0x8a26b424833aa4ab, 0xa65a08541e9f5925
d_2_23:         .dword 0xa816aecdb6f3e032, 0xd59d279a0b666ea1
d_2_24:         .dword 0xa9fe8e3b8228bb96, 0x4847378edc4c03fb
d_2_25:         .dword 0x88667a31ddb6fd90, 0xcc5f2177b6a05300
d_2_26:         .dword 0x45b1d5fad38d1429, 0x27fa5851079608e2
d_2_27:         .dword 0xdab040e60dc98171, 0x11b36c88b091dd0b
                .dword 0x1e4cb1eccc7db725, 0x61a6df636ee82cf0
                .dword 0x3a671c18c85a338f, 0x19a68187a27cbcaa
         /* Random data */
_end_data2:
                

    .section .data.random3;
    .align  8;

_random_data3:
                .dword 0xf369571b61013d44, 0xefe596b3012acdbe
                .dword 0x59db875794db6523, 0xbbf1c327591d643a
d_3_0:          .dword 0xb3b239d223c75f86, 0x0863d1b1152aee65
d_3_1:          .dword 0xa56ce2f2d43a3725, 0x605994e41d1a32a8
d_3_2:          .dword 0xe39ca5ce63909a35, 0x581c07de2e2a1f0b
d_3_3:          .dword 0xc3baf34607756832, 0xfe2b3a9405ff48e0
d_3_4:          .dword 0xa5dba867735d3c0f, 0x6a108402aa38b20c
d_3_5:          .dword 0xcebad3374ee9918b, 0x0e07ba2f69fdc6d7
d_3_6:          .dword 0x888bf031233bb918, 0xbd1e1fa71aeb4467
d_3_7:          .dword 0x7456b9f8b7f3433e, 0xe5f292090edb77d3
d_3_8:          .dword 0xc692f547b9105012, 0x77e5cd93fab74876
d_3_9:          .dword 0xa0927f56db51f7d4, 0x4706b26dd5507252
d_3_10:         .dword 0xd8ce67121bad0253, 0xea50db4f7b883012
d_3_11:         .dword 0xbe402d630b935b3b, 0x65df1a0b85170391
d_3_12:         .dword 0x2f1b76c98a9a3854, 0x6ac3d13878fdea6b
d_3_13:         .dword 0x48f19fd10c0cf58c, 0xd520c6262e41dfa8
d_3_14:         .dword 0x5df4acdb76a640fa, 0x1ae094973712bc28
d_3_15:         .dword 0xb93b153ff15ecedd, 0x546c21f6f6974fa5
d_3_16:         .dword 0xd2c2e9aaa2194bd9, 0xd59c4f008fde4f20
d_3_17:         .dword 0x1942b65fc9f51c85, 0xcbffa28b1c8040ac
d_3_18:         .dword 0x4e112c0d7057f095, 0x8f263bba3c74f47d
d_3_19:         .dword 0x04caa4c61a3b7e16, 0x0829493bd83ed799
d_3_20:         .dword 0xfb7757d178b3213a, 0x0a0d8bbf93b12b82
d_3_21:         .dword 0x5bbc95db0e7d7fe1, 0xde44474d85c46a69
d_3_22:         .dword 0xf15e8b3f25ddd798, 0x2c0b5f5df768476f
d_3_23:         .dword 0x9d778a287bc97c9a, 0x5ae59c165953ce97
d_3_24:         .dword 0x2a215917845aefc4, 0xf539cc6148d5cd15
d_3_25:         .dword 0x4fcb0d2bb0e53b11, 0xf64c1e8492f337e7
d_3_26:         .dword 0xdd77a25f7415942e, 0x896764501c085ee7
d_3_27:         .dword 0xf22df2e7a945ccb8, 0x5c770e3d4855f2ae
                .dword 0x9f008f205932bae6, 0xd206b888017ec2fd
                .dword 0xfd57b62cf30eff0a, 0xa308bfc03b0b8a44
        /* Random data */
_end_data3:


    .section .data.random4;
    .align  8;

_random_data4:
                .dword 0x92b062297d11f91b, 0xbd124e983cb92ce2
                .dword 0x981857c471d1cdb3, 0x6004f1d5cfff46fd
d_4_0:          .dword 0x28fc6fa40b23bcbf, 0x7dc19d3a93709ca7
d_4_1:          .dword 0x513579ef9c4329c5, 0xb97b8a4af1cde683
d_4_2:          .dword 0xe9cd370a13953d1d, 0xb86bc96dd227255f
d_4_3:          .dword 0x19a04aa684546547, 0x102f524a3d1555e4
d_4_4:          .dword 0xfa06cb0445248654, 0xf0ad6eebbcb3f8fc
d_4_5:          .dword 0xbe2ad00d7c9b34fa, 0x39c7437867932ec0
d_4_6:          .dword 0x6af4e4794b6a541f, 0x1a2ccbb94bd4b45f
d_4_7:          .dword 0x101dbdeb878ca1ef, 0x7a83b92683691f4b
d_4_8:          .dword 0xf8edb9ff32308814, 0xfc9c706cad9660b2
d_4_9:          .dword 0x96d7e207a47f965e, 0xa56affcd79976c6b
d_4_10:         .dword 0xe8fcdb027844141d, 0xd2b044bc8c2413d6
d_4_11:         .dword 0xf015c3468eed6134, 0xc4fe7da700216949
d_4_12:         .dword 0x74d4b2ce6de327a6, 0xfc2f2cea6717f9b4
d_4_13:         .dword 0x0b7d0991bea0ca50, 0x2554e0b857197757
d_4_14:         .dword 0x14d7c759ba2a0b2f, 0x72d9cf9c2eeb5dad
d_4_15:         .dword 0xedeef3ee15c202c0, 0x0cbf6118a52b3a8a
d_4_16:         .dword 0x44139f202142071d, 0xe8f8270fb328a544
d_4_17:         .dword 0x6db849e03c9cefa6, 0xbde9406f1a0cc4f2
d_4_18:         .dword 0x561cc10cee5526c2, 0x4d3a1867b56cd813
d_4_19:         .dword 0x94676615674bf10b, 0xd0df16ce0c6c05bb
d_4_20:         .dword 0x5fa2a01d631b6188, 0x4cad765da2bae916
d_4_21:         .dword 0x1d1f88c023d266c1, 0xf86d04ec1b112458
d_4_22:         .dword 0xa0489e5d5f3700ed, 0x0fe43256b1405120
d_4_23:         .dword 0xc0714c2a77e29586, 0x48defd5a59cae83f
d_4_24:         .dword 0xf2f3e6fa5f0aad56, 0xa5e786150824f96a
d_4_25:         .dword 0xe1255b92d25d0fd0, 0xc8d3201c6fb7d90e
d_4_26:         .dword 0x9b134156c19164fc, 0x959aa708f620a998
d_4_27:         .dword 0x6ff1f285eb578f8b, 0x6af1aec21097f52f
                .dword 0xc7d63187b0ac69a6, 0xe6f1d52b9519db00
                .dword 0x7d1c8eeff875a50b, 0x3c0e9525075e5c99
        /* Random data */
_end_data4:


    .section .data.random5;
    .align  8;

_random_data5:
                .dword 0xd1080e3f6165d7c4, 0x85b0199210ba5716
                .dword 0x0fec658a69d1f7a1, 0xf536d0034ada08a0
d_5_0:          .dword 0xb5be2caab0e51c50, 0x265efcae78210b64
d_5_1:          .dword 0xba3070d84eef218b, 0x7730ece8b918419a
d_5_2:          .dword 0xb987839ce42f4188, 0xaa76ea03e1415d87
d_5_3:          .dword 0x6f7e71faaeb93d7c, 0x6339ab2054d9c1ce
d_5_4:          .dword 0x51750d641d4d8f20, 0x4146ff768b55e758
d_5_5:          .dword 0xc30c91947ffa0893, 0x4bf63e40a2594be7
d_5_6:          .dword 0xc28d1833a37da20b, 0xcaefe21900f7d742
d_5_7:          .dword 0x662b319c12d8e2fb, 0xf62adab35f3a8ccb
d_5_8:          .dword 0xab8c69d7836a1743, 0x922e0bff50d87484
d_5_9:          .dword 0xda5094664b775dc1, 0x3f9421f74033b253
d_5_10:         .dword 0x3c418c8b72ae9183, 0xc27c8a181de16d4f
d_5_11:         .dword 0xc3a38af21ae73275, 0x19c05ac561d30271
d_5_12:         .dword 0x8600b02f294e40ac, 0xe009462581a16c85
d_5_13:         .dword 0xafb328590b2b4434, 0xc9280b46f76bb8d3
d_5_14:         .dword 0x74bfc813fa5c5350, 0x5b402274d31dd351
d_5_15:         .dword 0xcd2f9e5b5a6c1772, 0xba7b0b5e1e87fa8d
d_5_16:         .dword 0x04cc846bccb6dc79, 0x3f1f7dfd50e8a371
d_5_17:         .dword 0x29876bcd1387bb70, 0x1660b4fd63f03d75
d_5_18:         .dword 0xc75624ef2df0811d, 0x159f3bc113b53df9
d_5_19:         .dword 0xd02d819b74b7de1f, 0x80813ff57f1eb1e9
d_5_20:         .dword 0x548baa0ba4a60241, 0x346ff8617b8f4dc6
d_5_21:         .dword 0x7c74b5f3be793239, 0x41f005f5fcecc427
d_5_22:         .dword 0x01bea2e9e4971f29, 0x717e2ab9ab60727c
d_5_23:         .dword 0x06cf5fa492832e14, 0xae225ae318a07224
d_5_24:         .dword 0x870960db9a0f0827, 0xd39fe92ff62a50ea
d_5_25:         .dword 0x46b33e260815f1b5, 0x1ede2bc7b506932d
d_5_26:         .dword 0xa2ba7b4b9a9c8ef6, 0x9c9000d5729c6110
d_5_27:         .dword 0x4973726da084e885, 0xc4ed7ed7237b9b5d
                .dword 0x1cd5a75f3f739a57, 0x2b8f2fca71907b05
                .dword 0xde07db8c1647737a, 0x19010b33c83ed08c
         /* Random data */
_end_data5:
              
