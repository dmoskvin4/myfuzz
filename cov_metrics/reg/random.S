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
_s0:    fcvt.s.wu f1, x0, rne                     ;
_s1:    la x2, d_5_7                              ;
        addi x2, x2, 12                           ;
        sc.w x25, x2, (x2)                        ;
_s2:    sraiw x16, x23, 16                        ;
_s3:    la x8, d_4_1                              ;
        addi x8, x8, 12                           ;
        amomin.w x26, x9, (x8)                    ;
_s4:    la x8, d_2_7                              ;
        addi x8, x8, 16                           ;
        lr.d x24, (x8)                            ;
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
_p0:    xor x11, x11, x11                         ;
        addi x14, zero, 1                         ;
        slli x14, x14, 30                         ;
        add x11, x11, x14                         ;
        csrrc x14, frm, x11                       ;
_p1:    la x11, d_1_7                             ;
        srai x11, x11, 1                          ;
        csrrw x12, pmpaddr7, x11                  ;
_p2:    xor x14, x14, x14                         ;
        addi x14, zero, 1                         ;
        slli x14, x14, 3                          ;
        add x14, x14, x14                         ;
        addi x12, zero, 1                         ;
        slli x12, x12, 16                         ;
        add x14, x14, x12                         ;
        addi x12, zero, 3                         ;
        slli x12, x12, 25                         ;
        add x14, x14, x12                         ;
        csrrc x10, sscratch, x14                  ;
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
_l0:    csrrsi x15, fflags, 31                    ;
_l1:    fnmadd.s f27, f8, f5, f14, rne            ;
_l2:    xori x7, x15, 2047                        ;
_l3:    la x23, d_2_8                             ;
        addi x23, x23, -24                        ;
        amomin.w x6, x22, (x23)                   ;
_l4:    la x28, d_4_7                             ;
        addi x28, x28, -0                         ;
        amoand.d x14, x6, (x28)                   ;
_l5:    fmadd.s f14, f11, f19, f27, rne           ;
_l6:    fcvt.wu.s x1, f6, rne                     ;
_l7:    fsqrt.s f0, f28, rne                      ;
_l8:    la x19, d_3_20                            ;
        addi x19, x19, -0                         ;
        lui x26, 0xffe00                          ;
        xor x19, x19, x26                         ;
        lr.w x11, (x19)                           ;
_l9:    fsgnjx.s f4, f1, f0                       ;
_l10:   sllw x11, x28, x23                        ;
_l11:   la x12, _l75                              ;
        flw f20, 0(x12)                           ;
_l12:   la x30, d_5_4                             ;
        addi x30, x30, 24                         ;
        amomaxu.d x1, x30, (x30)                  ;
_l13:   fle.s x26, f21, f3                        ;
_l14:   fcvt.s.l f20, x14, rne                    ;
_l15:   csrrwi x26, pmpaddr3, 12                  ;
_l16:   la x13, d_2_4                             ;
        addi x13, x13, 4                          ;
        amomin.w x28, x15, (x13)                  ;
_l17:   sraiw x4, x19, 6                          ;
_l18:   la x24, d_3_24                            ;
        addi x24, x24, -16                        ;
        lui x20, 0xffe00                          ;
        xor x24, x24, x20                         ;
        amomax.w x5, x20, (x24)                   ;
_l19:   la x11, d_5_8                             ;
        addi x11, x11, 0                          ;
        amomaxu.d x28, x30, (x11)                 ;
_l20:   sraw x7, x5, x2                           ;
_l21:   la x11, d_4_4                             ;
        lhu x4, 20(x11)                           ;
_l22:   la x3, d_3_5                              ;
        sb x20, -14(x3)                           ;
_l23:   fsgnjx.s f21, f11, f20                    ;
_l24:   la x16, d_4_26                            ;
        addi x16, x16, -24                        ;
        amomax.d x7, x10, (x16)                   ;
_l25:   sraw x14, x5, x22                         ;
_l26:   la x22, d_5_17                            ;
        addi x22, x22, -24                        ;
        amominu.w x15, x13, (x22)                 ;
_l27:   fnmadd.s f24, f3, f2, f4, rne             ;
_l28:   slti x0, x14, 1920                        ;
_l29:   fmv.x.w x22, f4                           ;
_l30:   fcvt.lu.s x15, f1, rne                    ;
_l31:   fmin.s f11, f2, f5                        ;
_l32:   lui x16, 755219                           ;
_l33:   fcvt.s.w f26, x19, rne                    ;
_l34:   slliw x2, x2, 21                          ;
_l35:   fsqrt.s f21, f1, rne                      ;
_l36:   fcvt.s.l f11, x12, rne                    ;
_l37:   addiw x20, x8, -0                         ;
_l38:   sltiu x1, x2, 0                           ;
_l39:   subw x25, x2, x26                         ;
_l40:   fcvt.s.l f10, x4, rne                     ;
_l41:   la x15, d_3_16                            ;
        addi x15, x15, -8                         ;
        lr.w x9, (x15)                            ;
_l42:   la x12, d_5_11                            ;
        flw f28, 28(x12)                          ;
_l43:   srli x18, x2, 44                          ;
_l44:   andi x19, x23, 25                         ;
_l45:   slti x4, x5, -25                          ;
_l46:   la x8, d_4_10                             ;
        sw x9, 16(x8)                             ;
_l47:   la x5, d_4_17                             ;
        addi x5, x5, 0                            ;
        amoand.d x7, x25, (x5)                    ;
_l48:   fcvt.wu.s x4, f14, rne                    ;
_l49:   fmin.s f24, f25, f27                      ;
_l50:   fmadd.s f22, f1, f2, f20, rne             ;
_l51:   uret                                      ;
_l52:   fcvt.s.lu f13, x13, rne                   ;
_l53:   la x20, d_3_10                            ;
        addi x20, x20, 24                         ;
        amoxor.w x9, x26, (x20)                   ;
_l54:   fcvt.l.s x9, f6, rne                      ;
_l55:   la x18, d_2_10                            ;
        addi x18, x18, -16                        ;
        amomin.d x27, x24, (x18)                  ;
_l56:   csrrsi x17, pmpaddr2, 18                  ;
_l57:   la x2, d_3_23                             ;
        sw x1, -16(x2)                            ;
_l58:   fsub.s f13, f6, f6, rne                   ;
_l59:   la x14, d_2_19                            ;
        addi x14, x14, -16                        ;
        amomax.d x20, x7, (x14)                   ;
_l60:   mret                                      ;
_l61:   la x6, d_2_1                              ;
        lb x2, -27(x6)                            ;
_l62:   la x4, _l0                                ;
        lw x3, -4(x4)                             ;
_l63:   mret                                      ;
_l64:   fcvt.s.wu f1, x19, rne                    ;
_l65:   la x8, d_2_26                             ;
        addi x8, x8, 8                            ;
        lr.d x3, (x8)                             ;
_l66:   fsgnjn.s f0, f8, f24                      ;
_l67:   la x13, d_5_6                             ;
        addi x13, x13, 24                         ;
        lr.w x6, (x13)                            ;
_l68:   addiw x3, x27, 127                        ;
_l69:   ori x24, x1, 0                            ;
_l70:   la x2, d_5_4                              ;
        addi x2, x2, 8                            ;
        sc.w x17, x14, (x2)                       ;
_l71:   addi x24, x5, -2006                       ;
_l72:   srai x22, x18, 16                         ;
_l73:   la x8, d_3_1                              ;
        lw x1, 28(x8)                             ;
_l74:   fmax.s f15, f21, f5                       ;
_l75:   la x4, d_5_7                              ;
        addi x4, x4, 16                           ;
        lr.d x15, (x4)                            ;
_l76:   fadd.s f20, f3, f3, rne                   ;
_l77:   fmadd.s f23, f18, f2, f14, rne            ;
_l78:   fmin.s f8, f21, f25                       ;
_l79:   la x8, d_2_20                             ;
        addi x8, x8, -16                          ;
        lui x24, 0xffe00                          ;
        xor x8, x8, x24                           ;
        amoswap.d x20, x24, (x8)                  ;
_l80:   fdiv.s f12, f15, f28, rne                 ;
_l81:   xor x2, x2, x2                            ;
        addi x9, zero, 3                          ;
        slli x9, x9, 19                           ;
        add x2, x2, x9                            ;
        csrrw x14, sepc, x2                       ;
_l82:   feq.s x1, f8, f0                          ;
_l83:   la x8, d_4_12                             ;
        sh x29, -24(x8)                           ;
_l84:   lui x20, 697800                           ;
_l85:   fcvt.s.w f4, x25, rne                     ;
_l86:   lui x13, 697800                           ;
_l87:   fmadd.s f0, f21, f13, f27, rne            ;
_l88:   fsub.s f7, f11, f3, rne                   ;
_l89:   addw x29, x28, x3                         ;
_l90:   la x15, d_2_16                            ;
        addi x15, x15, 0                          ;
        amoadd.d x10, x29, (x15)                  ;
_l91:   la x7, d_0_7                              ;
        addi x7, x7, -28                          ;
        amoor.w x23, x13, (x7)                    ;
_l92:   fnmsub.s f26, f28, f15, f30, rne          ;
_l93:   fdiv.s f21, f13, f12, rne                 ;
_l94:   andi x27, x30, 105                        ;
_l95:   flt.s x17, f9, f15                        ;
_l96:   la x3, d_0_2                              ;
        addi x3, x3, -12                          ;
        amoor.w x1, x16, (x3)                     ;
_l97:   slliw x17, x4, 4                          ;
_l98:   fmul.s f26, f8, f9, rne                   ;
_l99:   srli x23, x26, 42                         ;
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
                .dword 0x44c87ffcc96b0c95, 0xda734ff13eefc4cf
                .dword 0x14bd16328aa3e82e, 0x7c09d9c4047ec914
d_0_0:          .dword 0x9ece9ee2ac8bfbd9, 0xc0139e057b6e37e4
d_0_1:          .dword 0xc3d1edf99ea3e709, 0xd41950763b7fbd6f
d_0_2:          .dword 0x5b0d00570c21c898, 0xbcf8bf649dfed59d
d_0_3:          .dword 0xf138b060a3a8e8c3, 0x13451bf04dd25583
d_0_4:          .dword 0x5d31a8bdf44355ca, 0x3730902a544c7bc5
d_0_5:          .dword 0xa5d88a622ef8bd16, 0x3c3410dc737e91ae
d_0_6:          .dword 0x9d7acd514cbbcd91, 0x8f773d5fca4785fd
d_0_7:          .dword 0xc9a8f47c30cdf35f, 0x29131c5b3f4fafab
d_0_8:          .dword 0xecbd0749f597c9a4, 0x55e90777ddc288f0
d_0_9:          .dword 0x62fc3f9f63fd52e6, 0x0a3bb356ae9e6c35
d_0_10:         .dword 0x4114dca95107afcb, 0x7dc7c616571adece
d_0_11:         .dword 0x12d3e9ca01b931be, 0x0524f1d15ea3b764
d_0_12:         .dword 0xac61543c22a25504, 0x5b068b1c382ed496
d_0_13:         .dword 0x070cb9286c5c7c09, 0xf9357d2a67e5bc10
d_0_14:         .dword 0x6568244d77537646, 0x86704b219353dfdb
d_0_15:         .dword 0x5a837337bd5382b1, 0xad0d495564aa864a
d_0_16:         .dword 0x06286894f06f3735, 0x79e52f38830f365a
d_0_17:         .dword 0xcace1a8f867c4c7a, 0x28f6979206071245
d_0_18:         .dword 0x3e457cb20ea34c70, 0x4005ac7876dc6920
d_0_19:         .dword 0xc488b1a8dc2075f0, 0x075ed73f329aefc3
d_0_20:         .dword 0x9d0a79f8e492a312, 0x948463a674af6ef7
d_0_21:         .dword 0xe9b1cee2cc9a3e4d, 0x6d99f1241bf35eea
d_0_22:         .dword 0xcb5e88936ef0efbb, 0x27645c3879bc5379
d_0_23:         .dword 0xbb3d53c0cc0d88dd, 0xe945821427e4790e
d_0_24:         .dword 0x39c83d1458dbad4a, 0x41c0f88443d89002
d_0_25:         .dword 0xb041e1a701248251, 0x8ef82eaa0f9d9fe7
d_0_26:         .dword 0x2591ca5114e05e25, 0x5f39ad49c409e274
d_0_27:         .dword 0x7a74855eb1aaf6f8, 0x74fb78e5a67cbb14
                .dword 0x50158dec37f061fa, 0x377c4b7533fa2e66
                .dword 0x333c787c345b318c, 0x6e4b072404a297db
        /* Random data */
_end_data0:
                 

    .section .data.random1;
    .align  8;

_random_data1:
                .dword 0xdc91b70a9e562e93, 0xca2873e6a3e204d4
                .dword 0x5a03688ea2d3d5f4, 0x6532971e868d5953
d_1_0:          .dword 0x3ed712c3763b93e6, 0xaa37f241e553f528
d_1_1:          .dword 0xf7e651ed06c7d588, 0x521c7564c3669b8b
d_1_2:          .dword 0x4cf35da75e5918b6, 0xbc1c1d84237c485e
d_1_3:          .dword 0x9b9da60ee9108acf, 0xccd803724222f010
d_1_4:          .dword 0x41acd22b6685e6fd, 0x5ed5c208498c630c
d_1_5:          .dword 0x91235139d7ed3676, 0xf2763f934da2d068
d_1_6:          .dword 0x98f28515509eaec5, 0x74b715117a8188f7
d_1_7:          .dword 0x18c57f195ba62c1d, 0xa9bef5efd5d73145
d_1_8:          .dword 0x4a3038f838d95f4d, 0x2015785459b0d719
d_1_9:          .dword 0xb2c27cb60008467a, 0xe4a1b21b92e69f29
d_1_10:         .dword 0x6c52ace5081c9aea, 0x81cefd228579de0c
d_1_11:         .dword 0xdd9ef8da2ddbb50d, 0xcfa7be7660344f97
d_1_12:         .dword 0x496c92da7613b39a, 0xfa99506f425a628c
d_1_13:         .dword 0x473ce3ea7b22c842, 0xee7f4a09852478ec
d_1_14:         .dword 0x58019a253d74020f, 0x1be1ba213910dcfa
d_1_15:         .dword 0x07d1074cd524ce9e, 0xf2ae6bbb5755c064
d_1_16:         .dword 0x4b4f076c952f33e3, 0x56417e7b494c7991
d_1_17:         .dword 0xc5db8a5bc68488e8, 0x32ec50422b4831be
d_1_18:         .dword 0xb88f8d6655cdc0de, 0x073122f4c1691e1f
d_1_19:         .dword 0x6cbe25d3768ad8c2, 0x1938aad8c42f4c1a
d_1_20:         .dword 0xcf27c3dd30a9a909, 0x5895592b3d8fbe90
d_1_21:         .dword 0x44e8a9511a33db6c, 0x030a5de92609bad6
d_1_22:         .dword 0xbc85d5c8334b44e5, 0x0a5e4fcdeafd3546
d_1_23:         .dword 0xbcecea00027ce19d, 0x438ebc99f4384e73
d_1_24:         .dword 0xe563e2df92b83776, 0x85bb408c2a132774
d_1_25:         .dword 0x1a8dd130527678e3, 0xb6360022bf4abb0d
d_1_26:         .dword 0x87bc816f6a99ba5e, 0x4a46cd97914fcd3a
d_1_27:         .dword 0xdb6d836ea4d53d32, 0xa5fe66eb941cdc53
                .dword 0xa881d7025f320df0, 0xe29882fb45edcdf6
                .dword 0x6ef2b893c81b4892, 0x34bda2db135c86a0
        /* Random data */
_end_data1:


    .section .data.random2;
    .align  8;

_random_data2:
                .dword 0x68f6e518a843d5d3, 0x915247e863c75727
                .dword 0x45de9aedc2e066db, 0x1e53095fc2a4c70e
d_2_0:          .dword 0x6a2747854b299e70, 0x6e605eb613bffc9f
d_2_1:          .dword 0x70ee5002cc9464bf, 0x183d2fa8215ed508
d_2_2:          .dword 0xedf5defe45b7c687, 0xddb28629e3b9e0e2
d_2_3:          .dword 0xbabae0cdf3d74a84, 0xfe27f6efe243137c
d_2_4:          .dword 0x282d6627f2355397, 0xaed21efcc300bf7d
d_2_5:          .dword 0x081a7e99d0e94a60, 0x4074f44ba579fce2
d_2_6:          .dword 0x69f9160e203c2d84, 0x0afeb42ce0529ea5
d_2_7:          .dword 0xce3264a9d4ed893c, 0xde909e622e7983bf
d_2_8:          .dword 0xf076d8d59cfce1bf, 0x828a32824d31b428
d_2_9:          .dword 0x71ee758da496b58d, 0x54d184d7cbce9743
d_2_10:         .dword 0xa6a37eefa94ea009, 0x95a04b968d298b95
d_2_11:         .dword 0xe99bd05d3c06a150, 0x56b431f45cb9ae58
d_2_12:         .dword 0x56d96ed8e54fc4bf, 0x862e120ef55909db
d_2_13:         .dword 0xff1c97b5c20b9916, 0xe0cc66fd0c53130a
d_2_14:         .dword 0xc20c506c0cd78536, 0x6d619d9109a70747
d_2_15:         .dword 0xbc3d0469de0f1f3a, 0x9f3e17fec33459ab
d_2_16:         .dword 0xcfb1ffb090c4d9f0, 0x6b10267570b39342
d_2_17:         .dword 0x808d731d43afec83, 0x2b5a11859575a205
d_2_18:         .dword 0x5f67033ee284f3bf, 0x32955026c6a4667e
d_2_19:         .dword 0x19eab08ddcba90f1, 0xafb5a99c758cae18
d_2_20:         .dword 0xb691002f0f003ed9, 0x6bc9609bf835c8b8
d_2_21:         .dword 0xdc9dd551a2e946f4, 0xf7bb50d1ca1da5d3
d_2_22:         .dword 0x4932ee58ac4fa9d7, 0x27c9d6271930a4b8
d_2_23:         .dword 0x10ff4d71845fa98c, 0x4c1b651ba30227ee
d_2_24:         .dword 0x56fa4994af9d16c8, 0xb87c4c99973f30e7
d_2_25:         .dword 0xa6a69b3f10703a50, 0xf25bcc0d6f9972f9
d_2_26:         .dword 0xca47b55e4179665a, 0x9160c1b82e4ff6ad
d_2_27:         .dword 0xc93c17dc2c5170a5, 0xfb315874fa6f667e
                .dword 0x5313220adc6c8f67, 0x2911da7249f21fc3
                .dword 0x1534f47b9519b117, 0xc4cc4850397068a6
         /* Random data */
_end_data2:
                

    .section .data.random3;
    .align  8;

_random_data3:
                .dword 0x3467f34455ff96b1, 0xa661bda4ec4e0b17
                .dword 0x46898fb15b07b00d, 0x5eb6c8a5454d43b6
d_3_0:          .dword 0x7e8edae47af5c4a2, 0xa7eccda762ecc36e
d_3_1:          .dword 0xa4790a4824e41bfa, 0xd9a76e1bb5cbcc38
d_3_2:          .dword 0x6b09d258b5ee7c3b, 0xf0cad58e7a439c75
d_3_3:          .dword 0x58217dfe7b505fbc, 0xbfa333d779fa4220
d_3_4:          .dword 0xc6fe3e1fa6689384, 0x1510c6557cef1479
d_3_5:          .dword 0x13663c0bfa0aaa0b, 0x89097b785f5fc55a
d_3_6:          .dword 0x9f28c9b3e954326f, 0x233b84c7437dfc06
d_3_7:          .dword 0x1c4e2920e8f5f654, 0x672c9161cb309f34
d_3_8:          .dword 0x43d3cdce4a4cd14d, 0x303bfce6b308ac70
d_3_9:          .dword 0xe232fe3108dcbf4e, 0x4b2a9f23d5ece63a
d_3_10:         .dword 0xac9ac81d456b13ef, 0xe79ddcdbc57a6454
d_3_11:         .dword 0x7cb4fe2ad968f5eb, 0x3870edca07e691a8
d_3_12:         .dword 0x081616121384bf87, 0x46dbacb178a47c20
d_3_13:         .dword 0xa2aa23d6e321dd1a, 0x048acbe1c3dcc5ee
d_3_14:         .dword 0xf2ce6383da8a978f, 0x25a8530b5a62aec0
d_3_15:         .dword 0x35bd3f3d9a067a62, 0xfed208ed4e79e66e
d_3_16:         .dword 0x751a7f398a201c4e, 0xb19bea2dcc6443a7
d_3_17:         .dword 0xd65db30b0b8a9b7b, 0x9b72f310de4a27ca
d_3_18:         .dword 0xcb9ca01723b2bc1f, 0xc685ef3ae4a2593a
d_3_19:         .dword 0xebb12af5538b25bb, 0x5deb7e79f6f0d068
d_3_20:         .dword 0x97fdb73b9ffa557c, 0x6eafa8b6cdaa4ba7
d_3_21:         .dword 0x85edd1d6d7f4c077, 0x0a9ef5d018538757
d_3_22:         .dword 0xdfaa8ea6390caffa, 0xf6968add4598cb07
d_3_23:         .dword 0x38a2200dd37ff208, 0xece9c153d61dc9f6
d_3_24:         .dword 0x6b4c1f74ced20d74, 0xd181af0a4c3ab349
d_3_25:         .dword 0xf14fb020714b525b, 0x3f1aeaf2f73d9bb4
d_3_26:         .dword 0x278483b834fd6168, 0xe315612e8eda8277
d_3_27:         .dword 0x7d285d7a7a782c08, 0x0c9337e1bb6cb699
                .dword 0xb030a93bd9c7dd59, 0x88105d0fa5017d74
                .dword 0xed1b3db68f2d89a6, 0x9dd2966a7b4b0ecc
        /* Random data */
_end_data3:


    .section .data.random4;
    .align  8;

_random_data4:
                .dword 0xfb6bee1fa6fcf910, 0xc639f61bd7ae38ed
                .dword 0x3e54f310c60a8807, 0x3498cc02d14942fb
d_4_0:          .dword 0xd2a46994be80938c, 0xafcdef00cda9be1c
d_4_1:          .dword 0xbe6f1e9224ea5eff, 0xf7cdb21e189d0a99
d_4_2:          .dword 0x493192a2993c9d3f, 0xc39964b7b0c34101
d_4_3:          .dword 0x067c985147d5abc3, 0x299c6cffa59ab999
d_4_4:          .dword 0x2ed098444fc292f0, 0x929e81a32baea518
d_4_5:          .dword 0x8e16a37163ec3a9e, 0x12cb677f7315d20a
d_4_6:          .dword 0x20018a829b9a5d52, 0xa16ef96bad8eb979
d_4_7:          .dword 0xcf7ed45aa0347d87, 0xa9a07ec2366793b8
d_4_8:          .dword 0xcdfe25fc7159b36e, 0x4355b61717b75521
d_4_9:          .dword 0xea35e77f3865c2a0, 0xf8110dfbe2c07894
d_4_10:         .dword 0x25d08dd5293a12a6, 0x2a59f8361cf1b560
d_4_11:         .dword 0x2d8f25cc98b5d466, 0x579e6426314b0e0f
d_4_12:         .dword 0xcdfc637735f4db1c, 0x5c4d9af546b58bca
d_4_13:         .dword 0x7d12468d2b319b56, 0x4f3fe0026cbdc155
d_4_14:         .dword 0xc2fe385475f4a3ba, 0x1999562555bbe7af
d_4_15:         .dword 0x77df53a90c0dd5c5, 0xa523c4aa714a1dbd
d_4_16:         .dword 0x07243a0f1b3eb293, 0xa80909ff5d008344
d_4_17:         .dword 0x1c4dd81f1a0e70a8, 0xfae5335a51770568
d_4_18:         .dword 0x42a7355f3cf655da, 0xefc75347862f09b3
d_4_19:         .dword 0xd785d1c17a428658, 0x12ad3579bcbbfaec
d_4_20:         .dword 0x8495de5a5dcc6430, 0x789aa97ec3d51ee2
d_4_21:         .dword 0x721cbe51f723e859, 0xae97ac580ef8e637
d_4_22:         .dword 0xdb2dca97164a7069, 0x58bb28d94e6a9a2a
d_4_23:         .dword 0xb8b32cdc8b89edd0, 0xd0f2f11ccfa9a99d
d_4_24:         .dword 0xc7c6bfaf2ddab736, 0x76833f79e42be684
d_4_25:         .dword 0x3b941aa9e89650ae, 0xe80061077550ef01
d_4_26:         .dword 0xb8e6c6a1a204387c, 0x6f101f987fd6350e
d_4_27:         .dword 0x4beb6ab93d1234f2, 0x9a40715178ad0ab9
                .dword 0x61c8fea5535f7580, 0x08c3d4642eb2ea72
                .dword 0xbf1f4b9cabf44dd7, 0x9049370f45b24235
        /* Random data */
_end_data4:


    .section .data.random5;
    .align  8;

_random_data5:
                .dword 0x090ca62da89bc995, 0xacb4693ffb5af237
                .dword 0xb7c03fc90bdaad9d, 0x0374168043a54d71
d_5_0:          .dword 0xdbcfff032c8cf405, 0x1079cbced5ea0d43
d_5_1:          .dword 0xb7e25350085a0faf, 0xdab3d5ddb1a7cf44
d_5_2:          .dword 0x01505917bfaafbb7, 0x283da5b4fd4f0a9a
d_5_3:          .dword 0xae94dbee6cb4d952, 0x9547a7c4b2adc832
d_5_4:          .dword 0xffe3da0e964acf6c, 0xaf901c0f30590ef1
d_5_5:          .dword 0xfeac60a0419defa7, 0x131cebdc7f851277
d_5_6:          .dword 0x166123b0e44f635d, 0x5eec234c91e1e5b9
d_5_7:          .dword 0x9668d1e84eff6485, 0xf191d48fc4ff4107
d_5_8:          .dword 0xc9de5de43c1f3276, 0x1ae06e28f2a0c6b3
d_5_9:          .dword 0x4063da81e8f13442, 0x9209725ebdb480eb
d_5_10:         .dword 0xbe8f7466ac103a64, 0xc50569cf50640689
d_5_11:         .dword 0xf589104f028678d0, 0x28a740b9b19e6935
d_5_12:         .dword 0xa256764c091d1578, 0x98a9480647afd640
d_5_13:         .dword 0xee059fdcd4b0f697, 0x18c1596cb74ed6f8
d_5_14:         .dword 0xa064a28843ce384c, 0x215f9ef1c260cf66
d_5_15:         .dword 0x25ab437746883881, 0x9a3862b3515087ec
d_5_16:         .dword 0xf49143c127ee0736, 0x2b07212be17f9cc4
d_5_17:         .dword 0xfcea0c6d8dbcd80e, 0xddd88361e15ae3af
d_5_18:         .dword 0x229ccf490922550e, 0x291e345ec08b17dc
d_5_19:         .dword 0xe4af47b598525cf8, 0xeb7fab7bd59789c8
d_5_20:         .dword 0xd2e28753b711b428, 0xa6bfa936a55b2e66
d_5_21:         .dword 0xdd92e92b3369e61f, 0x8c9e66d4910c9339
d_5_22:         .dword 0xae31088223c5f7ee, 0x3cfe1528eb3705ea
d_5_23:         .dword 0x3853f77ae9d3e1e7, 0x55d0a04dc29fb35b
d_5_24:         .dword 0xe426409475c3fe1b, 0xa4a0eeb9bc0bacd7
d_5_25:         .dword 0x19516b35f2922b37, 0x362b561da12f54e3
d_5_26:         .dword 0x86732b321d4d1e71, 0x0ad93b9281522b7f
d_5_27:         .dword 0x39f624991d7ca29c, 0x502ac259084d1162
                .dword 0xa602a7831f27953a, 0x748a275baab655ca
                .dword 0x11740a705425af77, 0x79f241bf0d2c6ba8
         /* Random data */
_end_data5:
              
                 
