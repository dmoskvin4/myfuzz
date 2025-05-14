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
_p0:    xor x12, x12, x12                         ;
        addi x12, zero, 1                         ;
        slli x12, x12, 20                         ;
        add x12, x12, x12                         ;
        csrrw x13, sepc, x12                      ;
_p1:    csrrci x13, fflags, 24                    ;
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
_l0:    fcvt.s.w f4, x10, rne                    ;
_l1:    addi x0, x1, 0                    ;
_l2:    fle.s x14, f13, f11                    ;
_l3:    fmadd.s f4, f10, f21, f30, rne                    ;
_l4:    csrrsi x4, sepc, 30                    ;
_l5:    la x15, d_1_24                    ;
      addi x15, x15, 16         ;
      amominu.w x11, x25, (x15)         ;
_l6:    xor x24, x24, x24                    ;
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
_l7:    la x17, d_4_0                    ;
      addi x17, x17, -8         ;
      sc.d x17, x17, (x17)         ;
_l8:    flt.s x12, f3, f9                    ;
_l9:    srli x17, x28, 63                    ;
_l10:    csrrsi x21, pmpaddr5, 4                    ;
_l11:    ori x6, x30, -4                    ;
_l12:    auipc x23, 547979                    ;
_l13:    feq.s x17, f10, f16                    ;
_l14:    fmv.w.x f8, x18                    ;
_l15:    fclass.s x17, f9                    ;
_l16:    la x22, d_0_7                    ;
      lh x11, 22(x22)         ;
_l17:    la x20, d_0_4                    ;
      sb x15, 15(x20)         ;
_l18:    csrrsi x6, sstatus, 1                    ;
_l19:    fclass.s x15, f11                    ;
_l20:    addi x15, x17, -888                    ;
_l21:    la x4, d_3_4                    ;
      addi x4, x4, -0         ;
      lui x7, 0xffe00         ;
      xor x4, x4, x7         ;
      sc.d x14, x4, (x4)         ;
_l22:    fcvt.s.wu f0, x21, rne                    ;
_l23:    csrrwi x16, fflags, 1                    ;
_l24:    sraw x28, x22, x17                    ;
_l25:    uret                    ;
_l26:    la x12, d_0_23                    ;
      lw x28, 28(x12)         ;
_l27:    xori x2, x10, 19                    ;
_l28:    mret                    ;
_l29:    la x10, d_0_23                    ;
      addi x10, x10, -20         ;
      amomin.w x17, x22, (x10)         ;
_l30:    fdiv.s f24, f23, f18, rne                    ;
_l31:    la x16, _l56                    ;
      lb x22, 26(x16)         ;
_l32:    slliw x29, x3, 0                    ;
_l33:    fnmadd.s f9, f28, f16, f6, rne                    ;
_l34:    la x2, d_5_14                    ;
      addi x2, x2, -24         ;
      amoswap.w x4, x4, (x2)         ;
_l35:    fmul.s f22, f19, f27, rne                    ;
_l36:    sret                    ;
_l37:    la x10, d_1_27                    ;
      addi x10, x10, 16         ;
      amomin.w x19, x20, (x10)         ;
_l38:    subw x29, x15, x12                    ;
_l39:    sraw x16, x28, x11                    ;
_l40:    fsqrt.s f1, f20, rne                    ;
_l41:    la x27, d_3_11                    ;
      srai x27, x27, 1         ;
      csrrc x9, pmpaddr2, x27         ;
_l42:    sltiu x22, x22, -2047                    ;
_l43:    fmin.s f27, f4, f0                    ;
_l44:    la x25, d_0_19                    ;
      addi x25, x25, -16         ;
      sc.w x6, x20, (x25)         ;
_l45:    la x9, d_4_13                    ;
      addi x9, x9, 24         ;
      sc.w x14, x18, (x9)         ;
_l46:    mret                    ;
_l47:    la x4, d_5_13                    ;
      addi x4, x4, -0         ;
      sc.d x3, x4, (x4)         ;
_l48:    fmadd.s f25, f8, f18, f21, rne                    ;
_l49:    fmadd.s f0, f22, f22, f14, rne                    ;
_l50:    fmv.x.w x5, f26                    ;
_l51:    feq.s x3, f9, f0                    ;
_l52:    la x1, d_4_22                    ;
      addi x1, x1, 20         ;
      amomin.w x21, x1, (x1)         ;
_l53:    fadd.s f11, f2, f16, rne                    ;
_l54:    fcvt.s.l f12, x1, rne                    ;
_l55:    la x7, d_1_14                    ;
      addi x7, x7, 8         ;
      amoand.d x12, x6, (x7)         ;
_l56:    la x19, d_5_27                    ;
      addi x19, x19, 8         ;
      amominu.w x19, x27, (x19)         ;
_l57:    la x27, d_2_15                    ;
      addi x27, x27, 16         ;
      lr.d x1, (x27)         ;
_l58:    andi x20, x20, 2047                    ;
_l59:    srlw x18, x30, x25                    ;
_l60:    sltiu x5, x5, 0                    ;
_l61:    la x14, d_5_27                    ;
      lbu x1, 9(x14)         ;
_l62:    ori x23, x4, -1903                    ;
_l63:    srliw x22, x4, 31                    ;
_l64:    la x11, d_4_7                    ;
      addi x11, x11, 24         ;
      amoadd.d x8, x24, (x11)         ;
_l65:    la x17, d_2_13                    ;
      addi x17, x17, -8         ;
      amominu.w x20, x18, (x17)         ;
_l66:    flt.s x25, f13, f25                    ;
_l67:    la x24, d_3_1                    ;
      addi x24, x24, 28         ;
      amoswap.w x16, x10, (x24)         ;
_l68:    sllw x15, x29, x29                    ;
_l69:    slti x19, x23, 146                    ;
_l70:    fcvt.s.w f11, x9, rne                    ;
_l71:    addi x15, x23, -769                    ;
_l72:    fcvt.l.s x15, f11, rne                    ;
_l73:    la x6, d_0_0                    ;
      addi x6, x6, 16         ;
      amomin.d x12, x21, (x6)         ;
_l74:    fcvt.s.wu f8, x21, rne                    ;
_l75:    slli x14, x12, 63                    ;
_l76:    fcvt.s.lu f14, x17, rne                    ;
_l77:    fmax.s f23, f21, f16                    ;
_l78:    la x21, d_0_5                    ;
      sh x29, 12(x21)         ;
_l79:    li x29, 0                    ;
      la x4, pt0         ;
      addi x4, x4, 0         ;
      sfence.vma x29, x4         ;
_l80:    addiw x17, x11, 1838                    ;
_l81:    la x19, d_1_10                    ;
      addi x19, x19, -0         ;
      amoand.d x2, x1, (x19)         ;
_l82:    srli x16, x5, 43                    ;
_l83:    la x30, d_1_0                    ;
      fsw f18, -24(x30)         ;
_l84:    la x10, d_1_2                    ;
      addi x10, x10, -8         ;
      sc.d x20, x10, (x10)         ;
_l85:    la x28, d_2_18                    ;
      sw x25, -4(x28)         ;
_l86:    fmv.w.x f27, x19                    ;
_l87:    fsgnj.s f28, f0, f18                    ;
_l88:    lui x12, 13                    ;
_l89:    slli x9, x27, 61                    ;
_l90:    auipc x2, 865825                    ;
_l91:    fcvt.l.s x27, f29, rne                    ;
_l92:    csrrwi x4, frm, 3                    ;
_l93:    andi x3, x15, -1501                    ;
_l94:    fcvt.s.l f18, x11, rne                    ;
_l95:    la x29, d_5_5                    ;
      addi x29, x29, 24         ;
      amomax.d x29, x4, (x29)         ;
_l96:    fnmsub.s f25, f12, f22, f1, rne                    ;
_l97:    la x4, d_4_21                    ;
      sw x13, 28(x4)         ;
_l98:    la x8, d_4_7                    ;
      sw x5, -4(x8)         ;
_l99:    la x14, d_5_1                    ;
      lbu x12, 11(x14)         ;
_l100:    addi x0, x1, 0                    ;
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
                .dword 0xdcd043d20576f7ea, 0x3eb377d5ba69ce0d
                .dword 0x8029844343a5f517, 0xe23e2b8f8088c3d8
d_0_0:          .dword 0x707b4e9802c6803f, 0xf313dd746e6909d2
d_0_1:          .dword 0x75e768bc62185479, 0x413ab4f52e8f60e8
d_0_2:          .dword 0xee2943c9a28d853d, 0xe26d5f7f686382a0
d_0_3:          .dword 0xd3a01d61f907911b, 0x1bceedbef05be4b0
d_0_4:          .dword 0x2ec4d736799908d6, 0xb801cccd3af1e509
d_0_5:          .dword 0x2a1f484ce69afb26, 0xd99213dd206cb8f5
d_0_6:          .dword 0x23adc105efd0cd1d, 0xf16ca7736c05e3e3
d_0_7:          .dword 0x8a665ec46a4c6c59, 0x1461a5105f1d41dc
d_0_8:          .dword 0x368d4b3b6cead0e6, 0x5d02e7f2e89ddcac
d_0_9:          .dword 0x4162c871e6dc732f, 0xb4b03122d4f7d69f
d_0_10:         .dword 0x30718a19c38dc35c, 0xb8600c89b535c285
d_0_11:         .dword 0x5d113ddf4ff2c2e8, 0x90af2f9e6e690149
d_0_12:         .dword 0x980f631dd5690aa7, 0xda4176d0d66b4cd1
d_0_13:         .dword 0x1071eb30f97fdf8f, 0x4cc527debd446658
d_0_14:         .dword 0x0ab9f0f6d1fe48e5, 0xbc81005a7b11f383
d_0_15:         .dword 0xcae33ac5b1c4fb23, 0xbc3bebe428f791b7
d_0_16:         .dword 0x124069992fbe1831, 0x7f545da278734e9d
d_0_17:         .dword 0x865f029770c512ce, 0x311a4b045934993f
d_0_18:         .dword 0x2dced5eec6cf76bb, 0x6471b5420cc0c1fa
d_0_19:         .dword 0xcccf78a639eb8b5c, 0xc4e8f78554cb1d54
d_0_20:         .dword 0xaf3590e3351486b5, 0x513f068578283653
d_0_21:         .dword 0xccbbd589d0f4a29d, 0x5accd81f4d795131
d_0_22:         .dword 0x7f3be340c01f32cf, 0xf4577e65fc93fe46
d_0_23:         .dword 0xae7a877cbb4aaf22, 0x25f4316dba6600bb
d_0_24:         .dword 0xeec9ac9231bd45ef, 0x82ab9f32382a97be
d_0_25:         .dword 0x9a86856c67d9737d, 0x491c03c14013a5f3
d_0_26:         .dword 0x403703c2f145bc51, 0x4da40e66198ea2e5
d_0_27:         .dword 0x396ea139cc1e1f2f, 0x3289b996313a6e76
                .dword 0x17d491924c9168a6, 0xa71c53ae0b735bfa
                .dword 0xb97c8a37a324af07, 0x03c6929f5f52a9e4
        /* Random data */
_end_data0:
                 

    .section .data.random1;
    .align  8;

_random_data1:
                .dword 0xc248d658e32253eb, 0x7e854e9fee9b0648
                .dword 0xb12cbc08c5009db3, 0xbd7788eb2c3f8721
d_1_0:          .dword 0xbf6402815a236b24, 0xe8cc020477487df0
d_1_1:          .dword 0xf5308df56ce69718, 0x68948f46438607e0
d_1_2:          .dword 0xba4bf4b3ae8febfd, 0xb1c7d7ade59b567a
d_1_3:          .dword 0xa96b65b970ac8511, 0x52491693284f5c08
d_1_4:          .dword 0x386269660db06c3a, 0x6b34791845846b20
d_1_5:          .dword 0x007ecc2aedc8410a, 0xbb4f087442e6f4d9
d_1_6:          .dword 0x5a9bf194dcc3bd59, 0x8d6d6f044c5893c2
d_1_7:          .dword 0xe3a72e97221d93d7, 0x27e000bcf7825c3c
d_1_8:          .dword 0xeb07e1e4e3525c0f, 0xd6b9befc04f97448
d_1_9:          .dword 0x124b17b09c09af15, 0xf1ec8976c5249264
d_1_10:         .dword 0xb99cbe2bbed6cfa0, 0xa9b8a5503a7a85ad
d_1_11:         .dword 0xdedeae750681b655, 0x33f008fc0276598f
d_1_12:         .dword 0xf0199a1d7361dc4e, 0x9c45f274ae835f7a
d_1_13:         .dword 0x8233335098899b8c, 0x41392bbe24d32810
d_1_14:         .dword 0x4a58b9e200acf6fc, 0x26969d479728a727
d_1_15:         .dword 0x3cfe1f174e402378, 0x3b56c600f2716b1b
d_1_16:         .dword 0xa42952426c751738, 0x60298b1197653733
d_1_17:         .dword 0x33a6699b1711d4be, 0x01df672a72316426
d_1_18:         .dword 0xddd9c19c38cd30e9, 0x7dead5180dd06247
d_1_19:         .dword 0xd5802bff00388c7f, 0x4a1e0faebd5401f2
d_1_20:         .dword 0xa2fb92c6fa875717, 0x12a84fe7b4a3093c
d_1_21:         .dword 0xcf751e83e38eaa63, 0x5da1fed92c6a1a3d
d_1_22:         .dword 0x3694f74cd5ab1a1f, 0xc055ead8b7cb57ba
d_1_23:         .dword 0x5147d6b093b0cc05, 0xf24dd5dc8e69cdbe
d_1_24:         .dword 0x28cdb42675304f2b, 0xd27f281a26432fec
d_1_25:         .dword 0x8a66a8ad7aa78475, 0x3fde424bd9b4bcb0
d_1_26:         .dword 0x244cfd2599b9de1f, 0x43eae63a49ad5bc4
d_1_27:         .dword 0xe43bddcc17507801, 0x2fe1575d5f638ba1
                .dword 0xc2a43f62b38ad40e, 0xfba8604f141015c4
                .dword 0x861b3020603172e6, 0x5c7cd11bea1de6ef
        /* Random data */
_end_data1:


    .section .data.random2;
    .align  8;

_random_data2:
                .dword 0xbe280b81935dcb20, 0x012e8f4437469fa9
                .dword 0x6f21c03f59d63095, 0x78c10649d0ed7eab
d_2_0:          .dword 0x21cdb62cda640e80, 0x7f95be8105755d91
d_2_1:          .dword 0x0c92ee18f3b67dca, 0x557112c3b1955e6b
d_2_2:          .dword 0xfb61de57a5dfab68, 0x50d4be025634842c
d_2_3:          .dword 0xf01e31972ec3b389, 0xf6fe213cadc4d233
d_2_4:          .dword 0x042d0eb56e2e6003, 0xd69a929664f9b482
d_2_5:          .dword 0xff11e235f68d655b, 0x202bf8a097738f83
d_2_6:          .dword 0xb35387edb4b53a31, 0x5b5e1decd51ef47f
d_2_7:          .dword 0x2d08e7743e93a9f1, 0x46f7e5ec38ca1f11
d_2_8:          .dword 0xface75a352a32572, 0x29bcd8315a5ec48a
d_2_9:          .dword 0xed4f34c216d792c9, 0xeecd58c110c8aae1
d_2_10:         .dword 0xd525435b8e94b9fc, 0x5eadec966b46ef9b
d_2_11:         .dword 0xc2aab22d80d9d154, 0x32e1dc6771d1138a
d_2_12:         .dword 0x8e6673867223b499, 0x1b8204d32635db34
d_2_13:         .dword 0x35beee13c161a941, 0x95517872d8e9254e
d_2_14:         .dword 0xfaad9bae6f081637, 0xffafa0d0cc436c6a
d_2_15:         .dword 0xe4d65d28c65b81ce, 0x15ca8ad57ba01cdf
d_2_16:         .dword 0xb80c6ac66a6c47be, 0x80e14140e0c304b5
d_2_17:         .dword 0xe0b0310950c0507f, 0x9bae42ec44e4abcb
d_2_18:         .dword 0x94a75442672b3fda, 0x032265be2599d499
d_2_19:         .dword 0xa365b48768b80a6d, 0xf63e1410376d0b69
d_2_20:         .dword 0xc371c65cea5396e1, 0x2b7562cb153652a0
d_2_21:         .dword 0xa52938cc09cf3554, 0xc4c71ce30c1861b1
d_2_22:         .dword 0xc4ffd95cbd87ed65, 0x82ed3a4f123b0f5c
d_2_23:         .dword 0xc37ead20b196169f, 0x65c89dd14a006595
d_2_24:         .dword 0x3a31fc3caa62a1b2, 0x40243656f4f99c15
d_2_25:         .dword 0x15656ddb5e67c291, 0x73350ec5861fb36a
d_2_26:         .dword 0x8077e68ed163ad25, 0x11be490f41b6cc5b
d_2_27:         .dword 0x3163dbe741d504ab, 0x4a19799b489fa021
                .dword 0x14d55003b772742f, 0x39ecd6d632d5b6ee
                .dword 0xdac85cb831256249, 0xe1676e190ead08a5
         /* Random data */
_end_data2:
                

    .section .data.random3;
    .align  8;

_random_data3:
                .dword 0xa2b787111a67bd4d, 0xcce31bdfbc11342c
                .dword 0x189594d46d350dfa, 0xe1e98fec9417a824
d_3_0:          .dword 0xf08b15d2b55c4ee0, 0xb71a9fa86581367e
d_3_1:          .dword 0x8cb4e7b19297da1e, 0x49c84eee1c0e8f74
d_3_2:          .dword 0x96681e3086a75884, 0xa1ea0639b7cfd50f
d_3_3:          .dword 0xe6f0e62764b706e8, 0x0f41d2f1cc3b8e24
d_3_4:          .dword 0x831b2f866f3c1149, 0x87cfcc32d0c87d02
d_3_5:          .dword 0x7fc80c86db3e8bd7, 0x9829265b1c76d54f
d_3_6:          .dword 0xe4fac528bf1c7493, 0x0c7aee74378ebbd2
d_3_7:          .dword 0xe61a80e6af570074, 0xb37583a532fd5d56
d_3_8:          .dword 0x1c5072f710eb58e2, 0xa010ecca86a45878
d_3_9:          .dword 0x1a468449d1057d42, 0xfd16d0a6750a45f7
d_3_10:         .dword 0x33343ef67f5b7f0e, 0x0a09269c868231b2
d_3_11:         .dword 0xb67a122168c859d9, 0xad439fc4649d37aa
d_3_12:         .dword 0x325e7052a1f8731b, 0x70c084e850b6bd93
d_3_13:         .dword 0x34c30ec06269064a, 0xbe9e6cb2a78fb98d
d_3_14:         .dword 0x2710a5fa4aa56e9b, 0x2b8e9d67cf1baebb
d_3_15:         .dword 0xbe04243544086c29, 0xb3c01cfecb2b1274
d_3_16:         .dword 0xe643046d7388da84, 0xa8050346c5e2cd32
d_3_17:         .dword 0x2dd46f62f3dde86b, 0xf624442965cd358a
d_3_18:         .dword 0xe74542c9dfa790b4, 0x8cb84ef2f4daeccb
d_3_19:         .dword 0xe3abe40ccb0bc94c, 0x87c8444835cbd779
d_3_20:         .dword 0xbe5be33b599acccc, 0x920d08c8340d7088
d_3_21:         .dword 0x091d6f69672b830c, 0x4c5b397f9e8b9626
d_3_22:         .dword 0x84cee784c82e8a64, 0x315c1253d9ba98fc
d_3_23:         .dword 0xe46855c0919811a1, 0x523b7ed667d765a0
d_3_24:         .dword 0x5c50a3a8269899fb, 0xe0140a479604ec25
d_3_25:         .dword 0xe9d76c2675590ee0, 0xe832fe721b8dccac
d_3_26:         .dword 0xf62509282b432b52, 0x7a0ef5b261122c79
d_3_27:         .dword 0x1fcfc3358d429a8a, 0x9fa7f180b10c6b6e
                .dword 0x0eb6b30e44fe4a49, 0xd73ec290d433061d
                .dword 0xad9fb43d8707d6c2, 0x6061ac159481978d
        /* Random data */
_end_data3:


    .section .data.random4;
    .align  8;

_random_data4:
                .dword 0x2f25bb3622c953e2, 0x53f7a9a864a29ce0
                .dword 0xba94bac94674d9ad, 0xa200244bb49f8619
d_4_0:          .dword 0xbcf4b7afefbe1fd9, 0x6b7cc8749484c99c
d_4_1:          .dword 0x91ed245f71dedeb4, 0x289d9016c5a806fb
d_4_2:          .dword 0xb82e69d13bbe89fe, 0x7ca0b8f665ca5e6c
d_4_3:          .dword 0xb8dc4e6545be59c6, 0xb014b02288bebe24
d_4_4:          .dword 0x8850b9368fe06a42, 0x3fece0a9c81528b9
d_4_5:          .dword 0xb44118238a5f954a, 0xe9ea9de0745e6785
d_4_6:          .dword 0x47de1d59508c7b5b, 0xc4ec65f49d8bcfe1
d_4_7:          .dword 0xea45d5dbd72bb2d3, 0x91d0b7eb65774551
d_4_8:          .dword 0xad536eff411cd843, 0x1c2a95f1e9437fff
d_4_9:          .dword 0xc74a696b1fa42274, 0xe698359aae6a8397
d_4_10:         .dword 0x93819fdde4e937d4, 0x1350998937ebfcd3
d_4_11:         .dword 0x2b950ae3df2340f4, 0xc8a5534069263847
d_4_12:         .dword 0x993881294551c034, 0x052bbc55bcc4b8e9
d_4_13:         .dword 0x43acfaafac2f8691, 0xd704f082945e6043
d_4_14:         .dword 0xa31da747497097de, 0x2112c52b0142f6ee
d_4_15:         .dword 0xa717bb9a5227b9a0, 0xdd3d94845eacb9e2
d_4_16:         .dword 0xb601f6b0bedda4f7, 0xd5def522af2ecfa4
d_4_17:         .dword 0x90fa02a04807f63a, 0xb82566b2a4577cc1
d_4_18:         .dword 0xa119970c3c8d3825, 0x91b6f61e08ad0cf8
d_4_19:         .dword 0x5c8e1cc8c304f5d9, 0xdefb8e9f51641885
d_4_20:         .dword 0x20eb346722f8dc65, 0x162bd59c03a27ad2
d_4_21:         .dword 0x502ddfe30cdcb750, 0xc66fa2c4b1c382fc
d_4_22:         .dword 0x704ad5999059db78, 0x7960230c194a8d25
d_4_23:         .dword 0x65386575b6163f94, 0x682b6609afbe48f5
d_4_24:         .dword 0x2783827e285df89b, 0x8eac8ab509834e5b
d_4_25:         .dword 0xf6b66a01c19f0b58, 0x57c031a3539015ed
d_4_26:         .dword 0x93d650294dd21dd7, 0xed39ef208aa43a61
d_4_27:         .dword 0x8e5e0ad7354f301e, 0x7755cfe44919d357
                .dword 0x564989a5e8ded707, 0x5ee62f4066acad70
                .dword 0xa1f75612f2b52f40, 0x62495f3dbffc3baa
        /* Random data */
_end_data4:


    .section .data.random5;
    .align  8;

_random_data5:
                .dword 0x6bb53fbaedc918c4, 0x5f28256484f50ce8
                .dword 0xae1683ccbed8741f, 0xa7b3c5c9ca7dc1b6
d_5_0:          .dword 0xdd3788e943800229, 0x2ac88083266e6fd1
d_5_1:          .dword 0xd05919514a38d7e8, 0x3527e90a07328016
d_5_2:          .dword 0x4cca0e977991d714, 0x479a38b1e5623da4
d_5_3:          .dword 0xef1898f911c7b264, 0xde7b2d7c36a09ed7
d_5_4:          .dword 0x39a1e13f6d0d7a31, 0xda0cfb92bea3d439
d_5_5:          .dword 0xb328845cdb96884a, 0xa563adb1deafcc66
d_5_6:          .dword 0x131ece172e9bdf8f, 0xf559208727b99371
d_5_7:          .dword 0x5727a1f9971805a7, 0xb55b4f80acb360ca
d_5_8:          .dword 0x055fb72e8f24137b, 0x9d1fde249287a9db
d_5_9:          .dword 0x16b53401afe492e6, 0x28196cd8e9daa9ae
d_5_10:         .dword 0x5f0e08b8679d8af2, 0x80c5eaa0081a3e73
d_5_11:         .dword 0x3f40d0bbcdf7148a, 0x7563b682796439bc
d_5_12:         .dword 0x3c5cadd23b9d71da, 0x2af0ebce1746e5dd
d_5_13:         .dword 0xcbbd4885505dc75b, 0x94fb9554f1327031
d_5_14:         .dword 0x896553079b0a2aca, 0x953f5891e012cdf9
d_5_15:         .dword 0xa2dcb96a09ffd1b3, 0xa38be6a6ad484e06
d_5_16:         .dword 0x541c115fbb50f8d5, 0x9af141d02cf8c3c2
d_5_17:         .dword 0xae36a74493ae047e, 0x3f12906ebc3c58f1
d_5_18:         .dword 0x465999e979116ea0, 0x1eb2e5c2d54f4a43
d_5_19:         .dword 0x2bdace1ff81a0e33, 0x1d4bd46ed20a184f
d_5_20:         .dword 0xd5e1a780790e488a, 0x611a38c2a12babc4
d_5_21:         .dword 0x2ebb3504e9c46017, 0xb4fd62f13fb0b32f
d_5_22:         .dword 0x2934b23b1d8105c3, 0xb51317d336354754
d_5_23:         .dword 0xfb150497a297f2ef, 0x1fc98d6eb6c1ea45
d_5_24:         .dword 0xc796a94334059c0c, 0x63e854ce5c5c9395
d_5_25:         .dword 0xdc44590b33788688, 0xef7a699b288852ce
d_5_26:         .dword 0x436b96c66ec9c7c9, 0x35ae447d8454ffc0
d_5_27:         .dword 0xcdb91fcc0b253e9a, 0xcff383a225e02321
                .dword 0xec77b43323d7c9d0, 0x95005fc767ba9a8d
                .dword 0xc5e14480b36f3b71, 0x7eebf17fa25e76f7
         /* Random data */
_end_data5:
              
                 
