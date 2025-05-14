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
_p0:    la x10, d_1_11                            ;
        srai x10, x10, 1                          ;
        csrrc x13, pmpaddr5, x10                  ;
_p1:    xor x11, x11, x11                         ;
        addi x13, zero, 1                         ;
        slli x13, x13, 21                         ;
        add x11, x11, x13                         ;
        csrrc x14, sstatus, x11                   ;
_p2:    xor x12, x12, x12                         ;
        addi x12, zero, 1                         ;
        slli x12, x12, 25                         ;
        add x12, x12, x12                         ;
        csrrc x14, fflags, x12                    ;
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
_l0:    xor x18, x18, x18                    ;
      addi x22, zero, 1         ;
      slli x22, x22, 1         ;
      add x18, x18, x22         ;
      csrrw x29, scause, x18         ;
_l1:    addi x0, x1, 0                    ;
_l2:    la x11, d_4_19                    ;
      ld x22, 8(x11)         ;
_l3:    la x21, d_5_25                    ;
      addi x21, x21, -16         ;
      lui x22, 0xffe00         ;
      xor x21, x21, x22         ;
      amomin.d x18, x22, (x21)         ;
_l4:    la x19, d_2_16                    ;
      addi x19, x19, 20         ;
      amomaxu.w x3, x22, (x19)         ;
_l5:    fmsub.s f17, f2, f14, f21, rne                    ;
_l6:    fmul.s f24, f24, f23, rne                    ;
_l7:    la x10, d_5_12                    ;
      addi x10, x10, -24         ;
      amomin.d x11, x11, (x10)         ;
_l8:    sret                    ;
_l9:    la x18, d_5_11                    ;
      fsw f12, 28(x18)         ;
_l10:    fmul.s f12, f0, f20, rne                    ;
_l11:    slliw x17, x23, 13                    ;
_l12:    fcvt.l.s x3, f5, rne                    ;
_l13:    la x8, d_4_12                    ;
      addi x8, x8, 16         ;
      lui x30, 0xffe00         ;
      xor x8, x8, x30         ;
      lr.d x4, (x8)         ;
_l14:    la x12, d_3_15                    ;
      addi x12, x12, 24         ;
      amomin.d x30, x2, (x12)         ;
_l15:    fclass.s x23, f30                    ;
_l16:    la x15, d_4_16                    ;
      addi x15, x15, 20         ;
      sc.w x5, x13, (x15)         ;
_l17:    fcvt.w.s x9, f0, rne                    ;
_l18:    ori x18, x3, 633                    ;
_l19:    la x10, _l26                    ;
      lw x25, 28(x10)         ;
_l20:    la x7, d_1_8                    ;
      addi x7, x7, 24         ;
      amoand.d x24, x14, (x7)         ;
_l21:    la x24, d_0_16                    ;
      ld x10, -0(x24)         ;
_l22:    subw x24, x27, x28                    ;
_l23:    sraiw x3, x16, 31                    ;
_l24:    fle.s x3, f17, f26                    ;
_l25:    la x19, d_0_8                    ;
      addi x19, x19, 4         ;
      amoor.w x15, x25, (x19)         ;
_l26:    la x10, d_2_19                    ;
      flw f9, 0(x10)         ;
_l27:    srai x18, x0, 18                    ;
_l28:    fsgnjx.s f11, f5, f17                    ;
_l29:    la x15, d_3_10                    ;
      lhu x18, 0(x15)         ;
_l30:    srai x15, x10, 6                    ;
_l31:    fdiv.s f19, f13, f14, rne                    ;
_l32:    la x15, d_2_18                    ;
      addi x15, x15, 0         ;
      sc.d x30, x15, (x15)         ;
_l33:    xori x19, x25, 728                    ;
_l34:    la x26, d_3_14                    ;
      addi x26, x26, -28         ;
      amomax.w x8, x10, (x26)         ;
_l35:    la x4, d_3_22                    ;
      addi x4, x4, -20         ;
      amoand.w x6, x11, (x4)         ;
_l36:    fmax.s f1, f9, f29                    ;
_l37:    srlw x26, x5, x28                    ;
_l38:    flt.s x29, f0, f6                    ;
_l39:    la x18, d_1_23                    ;
      srai x18, x18, 1         ;
      csrrw x7, pmpaddr3, x18         ;
_l40:    lui x1, 465564                    ;
_l41:    feq.s x28, f26, f5                    ;
_l42:    la x21, d_0_0                    ;
      lb x6, -31(x21)         ;
_l43:    la x3, d_2_3                    ;
      lb x20, 0(x3)         ;
_l44:    fcvt.s.wu f31, x20, rne                    ;
_l45:    la x15, d_0_21                    ;
      addi x15, x15, 8         ;
      amomin.d x23, x12, (x15)         ;
_l46:    sltiu x0, x14, -117                    ;
_l47:    la x12, d_3_4                    ;
      addi x12, x12, 0         ;
      lui x2, 0xffe00         ;
      xor x12, x12, x2         ;
      amomaxu.d x19, x2, (x12)         ;
_l48:    la x26, d_5_24                    ;
      sh x19, 4(x26)         ;
_l49:    sraw x0, x2, x21                    ;
_l50:    sraiw x7, x21, 0                    ;
_l51:    fsgnj.s f13, f10, f12                    ;
_l52:    fnmadd.s f16, f6, f12, f26, rne                    ;
_l53:    fmadd.s f8, f5, f14, f31, rne                    ;
_l54:    srai x6, x15, 62                    ;
_l55:    sltiu x29, x30, 2047                    ;
_l56:    csrrci x22, sstatus, 20                    ;
_l57:    sltiu x12, x27, -1144                    ;
_l58:    addiw x21, x15, 742                    ;
_l59:    fmul.s f20, f3, f6, rne                    ;
_l60:    la x5, d_1_22                    ;
      addi x5, x5, 24         ;
      amoor.d x4, x7, (x5)         ;
_l61:    sltiu x12, x27, 2047                    ;
_l62:    la x15, d_2_21                    ;
      addi x15, x15, -28         ;
      amoadd.w x24, x29, (x15)         ;
_l63:    la x8, d_3_26                    ;
      lh x13, -14(x8)         ;
_l64:    la x18, d_3_0                    ;
      sb x13, -28(x18)         ;
_l65:    la x5, d_2_0                    ;
      addi x5, x5, 8         ;
      amoxor.d x18, x28, (x5)         ;
_l66:    la x5, d_5_15                    ;
      srai x5, x5, 1         ;
      csrrs x16, pmpaddr2, x5         ;
_l67:    fsgnjn.s f0, f23, f7                    ;
_l68:    fmax.s f30, f14, f17                    ;
_l69:    fcvt.s.l f9, x7, rne                    ;
_l70:    fcvt.lu.s x3, f30, rne                    ;
_l71:    fsgnjx.s f26, f21, f5                    ;
_l72:    li x24, 1                    ;
      la x9, pt3         ;
      addi x9, x9, 56         ;
      sfence.vma x24, x9         ;
_l73:    la x23, d_3_3                    ;
      fsw f25, 8(x23)         ;
_l74:    sret                    ;
_l75:    csrrwi x11, sscratch, 7                    ;
_l76:    la x28, d_5_16                    ;
      addi x28, x28, -0         ;
      lui x19, 0xffe00         ;
      xor x28, x28, x19         ;
      amoor.d x12, x19, (x28)         ;
_l77:    fle.s x25, f11, f21                    ;
_l78:    la x14, d_5_19                    ;
      addi x14, x14, -16         ;
      amoadd.d x13, x30, (x14)         ;
_l79:    fcvt.lu.s x27, f21, rne                    ;
_l80:    fcvt.l.s x29, f2, rne                    ;
_l81:    fcvt.wu.s x23, f12, rne                    ;
_l82:    slti x27, x16, -0                    ;
_l83:    la x18, d_0_2                    ;
      flw f27, 4(x18)         ;
_l84:    uret                    ;
_l85:    la x3, d_3_13                    ;
      sw x5, 20(x3)         ;
_l86:    fcvt.s.wu f15, x3, rne                    ;
_l87:    slliw x23, x30, 20                    ;
_l88:    la x21, d_3_13                    ;
      addi x21, x21, 20         ;
      amoswap.w x15, x6, (x21)         ;
_l89:    la x20, d_1_27                    ;
      fsw f5, -8(x20)         ;
_l90:    srai x5, x2, 2                    ;
_l91:    mret                    ;
_l92:    la x24, d_1_25                    ;
      addi x24, x24, -0         ;
      amomin.d x26, x15, (x24)         ;
_l93:    la x25, d_4_1                    ;
      ld x20, -0(x25)         ;
_l94:    fcvt.s.lu f1, x17, rne                    ;
_l95:    la x23, d_3_20                    ;
      ld x19, 0(x23)         ;
_l96:    fcvt.s.l f0, x24, rne                    ;
_l97:    sraiw x20, x29, 31                    ;
_l98:    la x28, d_3_24                    ;
      addi x28, x28, 0         ;
      lr.d x20, (x28)         ;
_l99:    la x24, d_3_18                    ;
      addi x24, x24, 24         ;
      amoand.w x20, x1, (x24)         ;
_l100:    xor x11, x11, x11                    ;
      addi x16, zero, 1         ;
      slli x16, x16, 11         ;
      add x11, x11, x16         ;
      csrrs x9, sip, x11         ;
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
                .dword 0xafe17e84774ff67d, 0xb7a0f5683beb4537
                .dword 0xd28b42778b9c5bb3, 0x1d1ae46c3068744e
d_0_0:          .dword 0xbcd46a8f237a491f, 0xedc762735a0d20b3
d_0_1:          .dword 0x5ef8942a1487954d, 0x7a84a1d246a8b3e3
d_0_2:          .dword 0x638d392294fd54a2, 0x4eacd8e7d9e818c1
d_0_3:          .dword 0xcedbcd90267da7aa, 0xadec04e3a773c9d1
d_0_4:          .dword 0x5869afc113d73c9b, 0x69ca7b423e3d9a53
d_0_5:          .dword 0x466222b0740914fb, 0xfdb5cfdea481bc43
d_0_6:          .dword 0xaf8ca09fbff55d7d, 0x52349be4b950bd50
d_0_7:          .dword 0x4a23c422be1ecede, 0xb36f50e674135392
d_0_8:          .dword 0x0dc946e21027b291, 0x63b5ccc6e7bdc49c
d_0_9:          .dword 0x7ad3f492ee86169b, 0x94fe5105d0fa117a
d_0_10:         .dword 0xbf0aa199de90822e, 0x47ddb22cb2b7c8ab
d_0_11:         .dword 0xde4fa43bc4c6f524, 0xdb34f4e3a7263f00
d_0_12:         .dword 0x441e138479d1a245, 0x6ae3d8cb6541f9a6
d_0_13:         .dword 0xd9e87aa0b1a354ba, 0x2b268e9f6cb2c7fc
d_0_14:         .dword 0x4713db876dc9d4a2, 0x91fefd0e5884acb1
d_0_15:         .dword 0x0c101504d03db4e8, 0xa0640d0dbd6b0b16
d_0_16:         .dword 0x13b97ece5915bba0, 0x90fe96542bd205d3
d_0_17:         .dword 0x7b162b25b6d4a28c, 0x751e43b8e6791066
d_0_18:         .dword 0x52d0f187b560c753, 0x9cb2185a44945437
d_0_19:         .dword 0xc706d3c2218791f8, 0xe7f923f6873c337c
d_0_20:         .dword 0x77057ae550e3dc08, 0x20a1726fcada4498
d_0_21:         .dword 0x91b8439a76ff635c, 0xbc979f7221a89ce7
d_0_22:         .dword 0x264b8b7156a65d1d, 0x47ec79f1d590c02b
d_0_23:         .dword 0x1a1429894ad2277b, 0xdbe33e6fb1e5afad
d_0_24:         .dword 0x35408ac9b4102366, 0xc279f9c0c96e5c23
d_0_25:         .dword 0xa7682b01ec0f551b, 0x2e761f30da64ccdd
d_0_26:         .dword 0x17f83e03392e4343, 0x3f7f2168a5ab6874
d_0_27:         .dword 0xf6cea64abaa5560e, 0x9adbe8ed084e43a3
                .dword 0x9450334a86c7a580, 0x19521281746ed29e
                .dword 0x0d525e7da4f85280, 0xb4f14062d5216339
        /* Random data */
_end_data0:
                 

    .section .data.random1;
    .align  8;

_random_data1:
                .dword 0x2a724b3efaa03354, 0xa3af6e65470b8d26
                .dword 0x3aec676b2d3298dd, 0xefb09b2006299c80
d_1_0:          .dword 0x42a37db17b4ad09e, 0xfea74ea1f7ecd629
d_1_1:          .dword 0x0a6c7dd0a0b78d02, 0xc1582a663fe1b7e2
d_1_2:          .dword 0xcc19a2b218f8a087, 0xa3abaa6ff23435b3
d_1_3:          .dword 0x3c2d480f98ffc967, 0x8922a7c37b262578
d_1_4:          .dword 0x8dd97f8e11bd78f4, 0xf5e7ac790c6b67b5
d_1_5:          .dword 0x20525fdbc288f832, 0x4e5f4bb102f842ad
d_1_6:          .dword 0x6f70638e541aaee9, 0x243279b42520dfb8
d_1_7:          .dword 0x01ab92d7cf99d255, 0xe0b1fff5c40ebd34
d_1_8:          .dword 0xe57d22bb8425f61e, 0x7fb86d4c2ca72f8b
d_1_9:          .dword 0x58796bb37e61c8a0, 0x16ee31f226a57d04
d_1_10:         .dword 0xf3551e7af8a620c6, 0x778fe05b45954fc5
d_1_11:         .dword 0x4b22d504e7996580, 0x1df6265414c9b2ce
d_1_12:         .dword 0xb9f7eda68d154961, 0x726612c68aa28936
d_1_13:         .dword 0xf6507b5819f6df34, 0x03a34bf797087f32
d_1_14:         .dword 0xca1868a9454d113c, 0x85fa7942f81263d5
d_1_15:         .dword 0xf0510bd2c9f27f92, 0xb3d0addc27a8212a
d_1_16:         .dword 0xc18c436d3ebdfab9, 0xbbd3783f37a628b6
d_1_17:         .dword 0x5320d74210981988, 0x4b73c034c3adc2e6
d_1_18:         .dword 0x6276ea1fe29be8ab, 0xb2921098a6551be4
d_1_19:         .dword 0x27080fc42d65f84f, 0xf9584a47973e6388
d_1_20:         .dword 0xc1f13204c3fbab1a, 0xaa58c9e204ca9a62
d_1_21:         .dword 0x1258ab49082520e6, 0x898829613e607e56
d_1_22:         .dword 0x7ce27278877894a0, 0x241b56c92fd86f92
d_1_23:         .dword 0xfd798f2aa54f8338, 0xf081e4a7d56aed3a
d_1_24:         .dword 0x0076ff7aacfb7920, 0xbf5378bcf25841a2
d_1_25:         .dword 0xc17da0107d15b74a, 0xb95e356894856295
d_1_26:         .dword 0x585a5b5cb3e2d9bc, 0xb418b5c8af0cff69
d_1_27:         .dword 0xc722bba71cec92da, 0x96c8f416863b324a
                .dword 0x41d1d8613f7418a4, 0x9dfdab52629bd5e9
                .dword 0x57f61044875c4be6, 0x6f090ed15aebef25
        /* Random data */
_end_data1:


    .section .data.random2;
    .align  8;

_random_data2:
                .dword 0x04d88c767c41f44e, 0x7ee974af0d75e4a8
                .dword 0x6b3507e66c6a8a49, 0xd206933745984633
d_2_0:          .dword 0xf70bfdab3452c24e, 0x7e487c2822259272
d_2_1:          .dword 0x7c44e68fa07509d4, 0x68dd08df7e54abf6
d_2_2:          .dword 0x4f52f8c107b13a45, 0xbcdaee6302d4e71d
d_2_3:          .dword 0x18584f6775839798, 0x1fd82b82fdc47236
d_2_4:          .dword 0x410f350de5a53809, 0x0182aae151bd0336
d_2_5:          .dword 0x9ce18391176a4167, 0x4a56679447264c77
d_2_6:          .dword 0xd5c4268bf265834d, 0x523344cdd712e17f
d_2_7:          .dword 0xb10cd3b7c17af1e2, 0x0485a80d1f69bb78
d_2_8:          .dword 0xdb4d22b2d161b0a7, 0x05212ae657209dd0
d_2_9:          .dword 0x8c21a2d05c87c6d2, 0xfd5c067bd6c360fd
d_2_10:         .dword 0x1f82c5b24e9b9446, 0x9f8ee37ae88cccd0
d_2_11:         .dword 0xc3f24b9106559e5a, 0xd8d87ac2564db9c4
d_2_12:         .dword 0xa326f4d968708e72, 0xa5ac3b313fe75afc
d_2_13:         .dword 0x63ebf4c65e974ea9, 0x9b92449743c39816
d_2_14:         .dword 0xae1c7f291ab04307, 0xbe818d22b4695645
d_2_15:         .dword 0xa84feaf86901f9a3, 0x12563a2af15fa742
d_2_16:         .dword 0xb2274d793bf09bfd, 0xadcd44a3bd13be5e
d_2_17:         .dword 0x7b8af2b8508146ae, 0x913ff7cb22f85c95
d_2_18:         .dword 0xb3dcfaae7813e41a, 0x4c20ce00d5b52bf3
d_2_19:         .dword 0xb2d7c9867af7c966, 0x4385835bce6c9181
d_2_20:         .dword 0xdb99aeb10a5ecc31, 0xe56045597a787853
d_2_21:         .dword 0xd7f9684be65dc11f, 0x3a3c3d74f5d7d292
d_2_22:         .dword 0x4d7cc8965279ff98, 0x0ec4c912e62b8b84
d_2_23:         .dword 0x5e9de938d1e59a69, 0xb49b2d0ed7046afb
d_2_24:         .dword 0x244c8972229f9d07, 0x7b84ec5849aa6605
d_2_25:         .dword 0x08a4b20dc387ab5c, 0x2a4d3008c13b8616
d_2_26:         .dword 0xef44a94070ad387d, 0x3fb35ccdaad8d4af
d_2_27:         .dword 0x0135ccc892d5ee0a, 0xdf8405ec5b10dcca
                .dword 0xe0d461147bd09c07, 0xf4b398f472660bed
                .dword 0x8e71470929800b4b, 0xe5743f66337bd16a
         /* Random data */
_end_data2:
                

    .section .data.random3;
    .align  8;

_random_data3:
                .dword 0x36e5ed28cac31134, 0xab03392757b3ef3d
                .dword 0x68fdfe1197c459d5, 0xe05ce5244422a361
d_3_0:          .dword 0x1ea161d90bba136b, 0xb55587100ad204f8
d_3_1:          .dword 0x2386df4ac20b6086, 0xafeb49c3e5e063ae
d_3_2:          .dword 0xbaeb1ca3473f775f, 0x02a056f269a7fd03
d_3_3:          .dword 0xb45d719b07a1e43a, 0xd90242786221a3cf
d_3_4:          .dword 0x53312ed7f6a40963, 0x435138a366fa5c9a
d_3_5:          .dword 0x4cb85eddda4765e3, 0x7640016b2f433bcf
d_3_6:          .dword 0x4d2b6e5eedfe521f, 0x79d5937a04dbe4c3
d_3_7:          .dword 0x2c772bcf9db1db2d, 0xb8ce5ac82155279b
d_3_8:          .dword 0x73c3e200da18d514, 0x01b7737bf1379d91
d_3_9:          .dword 0x43c8aafa4f66366b, 0xc64e871093c08f8f
d_3_10:         .dword 0x560959735168f606, 0x9f8870c2b129e737
d_3_11:         .dword 0x641a0ac4af8f6623, 0x947ccad2678f9beb
d_3_12:         .dword 0x50595637a7952511, 0x6d0f47776362d204
d_3_13:         .dword 0x692971bd892cceba, 0x99c284087c5e9ea9
d_3_14:         .dword 0x14556c2dbb29779b, 0xfee8346e9d7a9462
d_3_15:         .dword 0x8acb967949074272, 0x3b4fcf3e66a3b06c
d_3_16:         .dword 0x642f4116b446d5bb, 0x600bbff055b4a3eb
d_3_17:         .dword 0x6ff51927b144ec8c, 0x2fe77c7d605bdac5
d_3_18:         .dword 0x2274d90d40ce4f19, 0xd982365ccd46e036
d_3_19:         .dword 0x9e7691c28aec89e7, 0x50625152b6bb5b94
d_3_20:         .dword 0x7815d302757eea51, 0x7f6cdb50ffe67f03
d_3_21:         .dword 0x70a971d175e66cc2, 0x88c62c1490447019
d_3_22:         .dword 0xe5dc37cb2b3df78e, 0x6923f7f771ed6547
d_3_23:         .dword 0x0a75e3408258386c, 0xe075bcc7e167b86b
d_3_24:         .dword 0xb9add48138367c10, 0xcfae73f2ad007fd4
d_3_25:         .dword 0x0505e8178e5792ed, 0x86ed9b7c883d57f7
d_3_26:         .dword 0x74629048942f691b, 0x39c5a86a400865a6
d_3_27:         .dword 0x296b9a89e4ba3043, 0xb2b527bea557f332
                .dword 0x274a481c1ffd1b60, 0x02c28f96c6478fac
                .dword 0x421b449c713ff380, 0x1150186cb893188e
        /* Random data */
_end_data3:


    .section .data.random4;
    .align  8;

_random_data4:
                .dword 0xf3f5d93b2d0d14c5, 0x836e292bef7c2bd7
                .dword 0x7995797c28e8da27, 0x6a6e753e015ffc3d
d_4_0:          .dword 0x60b391da94d0e682, 0x0ba54de3628eb1da
d_4_1:          .dword 0xa196b1fc7357271c, 0xb0de79a16e7aafda
d_4_2:          .dword 0x7aa04898cd814857, 0x66ff1b6a1513abea
d_4_3:          .dword 0xb8817e961130ab21, 0x38a938b98867f873
d_4_4:          .dword 0x8c4b3f56bcc3c6eb, 0xa65cf2ff5414e969
d_4_5:          .dword 0x222eafdb4fe7be1f, 0xaa1b1fc304f710ae
d_4_6:          .dword 0xa314d60147c6e35f, 0xd7e956bdef9cab6b
d_4_7:          .dword 0x8200fc20811b297f, 0x100f2aca667fc12f
d_4_8:          .dword 0x59b9ded1d66a3f15, 0x0906be0d5a969523
d_4_9:          .dword 0x820fd192806ebee2, 0x4ffda980548e90c1
d_4_10:         .dword 0x5f01cd3e51d1c80d, 0xfc0240633145e51a
d_4_11:         .dword 0xa5b6fa053b8d7463, 0x7bddad13b049cc52
d_4_12:         .dword 0x47678c44899b7322, 0x8b0331f01e7f78ac
d_4_13:         .dword 0xcdcd536975fc2325, 0x08c282c06ca5e802
d_4_14:         .dword 0xc624f4e0bca5ab63, 0x6bfef4a1b00224ab
d_4_15:         .dword 0x8ebdff442df1ed60, 0x891f751897791ee0
d_4_16:         .dword 0x911258d1c85baa59, 0x11f203e66511d779
d_4_17:         .dword 0xbe275f1e27631c0a, 0xccdc2cb94d4548eb
d_4_18:         .dword 0xda87aee2b72af592, 0x4adbf228c4d8558b
d_4_19:         .dword 0x5a3667b932ea165b, 0x9b34ab88e927b490
d_4_20:         .dword 0xbd70d3c1ac7432fb, 0x19f236d13a5f6050
d_4_21:         .dword 0xf1b5fb137a78bef9, 0x19ba74d20223607e
d_4_22:         .dword 0x89c0d093cd8e28e5, 0x6126c5a75c75ae81
d_4_23:         .dword 0x8f910d6f025538a4, 0x45203a14fe391059
d_4_24:         .dword 0xb736f5c48c19045b, 0xb450703800f738c5
d_4_25:         .dword 0x0d09cdbc30004c47, 0x77747a8b72a6c600
d_4_26:         .dword 0xe7d4e4f5d27f4b46, 0xdb38d0c89558f058
d_4_27:         .dword 0x8ad04455c6493763, 0x27296bbea1e77c61
                .dword 0x1fc811ce902ed238, 0xb14cc95797b8b4ee
                .dword 0x4c927bcdb9318b77, 0x1487d2662bc4c8da
        /* Random data */
_end_data4:


    .section .data.random5;
    .align  8;

_random_data5:
                .dword 0x9db7752f27336c46, 0x515a35c923d7be66
                .dword 0x01ba7832c11f8249, 0x67f698957038e8cb
d_5_0:          .dword 0x541e6e9230578eb4, 0x9b7f002acd4f088e
d_5_1:          .dword 0xe91bfd420a16b869, 0x5a0ccbe86523e139
d_5_2:          .dword 0xb2a5777d8ed47cd6, 0x03e2e04ec930aa27
d_5_3:          .dword 0x0a60d1800200e637, 0x4082ab32e20e3505
d_5_4:          .dword 0x2161e34b8b82d588, 0x7093004a71df5117
d_5_5:          .dword 0x02b1c2bfa0775a4a, 0xb63dbe66cdb65a11
d_5_6:          .dword 0xfc3fd0b5ac1c081a, 0xb0e0dfbb5d76bf40
d_5_7:          .dword 0x371263de5a027007, 0xcc11e8992427b4c3
d_5_8:          .dword 0xd0f2056f1380c3b9, 0x51069ff2ea2c80c9
d_5_9:          .dword 0x693994e27eb207b7, 0x64a570f6035b8fd1
d_5_10:         .dword 0xd4f5d28b061de678, 0xd6e74cb7f6a1f709
d_5_11:         .dword 0x7daffde7d92725f0, 0xac8dad4fc3c2170a
d_5_12:         .dword 0x5c9dd0d3c4b766e4, 0xa39e230f41397c8e
d_5_13:         .dword 0xbda4fb78614a329f, 0xfe60ebbdbbd50d58
d_5_14:         .dword 0xbda2a77ecf6d00c8, 0x7aa8ee1ec0f3045e
d_5_15:         .dword 0x88662bf679ff7818, 0xe41a874d522a7037
d_5_16:         .dword 0x3ffb38852d4456ad, 0x3754015e3f927466
d_5_17:         .dword 0xea7f698775d50796, 0xf6a902451a75cbb4
d_5_18:         .dword 0x254ae6a1d43b19de, 0x47c9853894724ec3
d_5_19:         .dword 0x46305276cbad78fb, 0x7ecc8633fb9c0a39
d_5_20:         .dword 0x6ea1130c7011e9a8, 0xf5e612c8a3dfff27
d_5_21:         .dword 0x01284c1e39138942, 0x973312cba95eac30
d_5_22:         .dword 0x1c7d090a2d2fac7e, 0xd3a7ac9c3257ba08
d_5_23:         .dword 0x421f8fcc90e6e01e, 0x5831cb3b290bceb4
d_5_24:         .dword 0x11c383ea7d6b2e63, 0x5d683be3bbabc932
d_5_25:         .dword 0xa9c458c72351e01f, 0x841ccc9253c030d1
d_5_26:         .dword 0xa7d5c7aa79412ecd, 0x624947e32b0d73df
d_5_27:         .dword 0x3c7a071638575a9c, 0xe847adadb932bf6e
                .dword 0x160d3522eba89c44, 0x417af5170eadf7de
                .dword 0x3a6c0636de639413, 0xbb3dc8d87563e3dc
         /* Random data */
_end_data5:
              
                 
