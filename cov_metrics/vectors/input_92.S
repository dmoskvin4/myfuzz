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
_p0:    la x14, _p0                               ;
        srai x14, x14, 1                          ;
        csrrs x10, pmpaddr7, x14                  ;
_p1:    la x14, _p2                               ;
        srai x14, x14, 1                          ;
        csrrc x10, pmpaddr4, x14                  ;
_p2:    la x11, d_2_11                            ;
        srai x11, x11, 1                          ;
        csrrs x14, pmpaddr0, x11                  ;
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
_l0:    addi x0, x1, 0                    ;
_l1:    addi x0, x1, 0                    ;
_l2:    la x18, d_1_23                    ;
      srai x18, x18, 1         ;
      csrrw x7, pmpaddr3, x18         ;
_l3:    sraw x26, x7, x1                    ;
_l4:    subw x21, x1, x14                    ;
_l5:    addi x0, x1, 0                    ;
_l6:    sllw x14, x16, x0                    ;
_l7:    addi x0, x1, 0                    ;
_l8:    andi x7, x15, 1016                    ;
_l9:    la x28, d_3_22                    ;
      sh x25, -30(x28)         ;
_l10:    fle.s x14, f16, f27                    ;
_l11:    auipc x28, 25                    ;
_l12:    flt.s x29, f0, f6                    ;
_l13:    xor x30, x30, x30                    ;
      addi x27, zero, 3         ;
      slli x27, x27, 25         ;
      add x30, x30, x27         ;
      addi x22, zero, 1         ;
      slli x22, x22, 4         ;
      add x30, x30, x22         ;
      csrrs x30, satp, x30         ;
_l14:    la x7, d_5_26                    ;
      addi x7, x7, -16         ;
      amominu.d x5, x21, (x7)         ;
_l15:    fcvt.s.wu f10, x23, rne                    ;
_l16:    fmax.s f7, f19, f3                    ;
_l17:    la x10, d_2_19                    ;
      flw f9, 0(x10)         ;
_l18:    la x18, d_2_25                    ;
      sb x12, 0(x18)         ;
_l19:    fmadd.s f19, f11, f10, f3, rne                    ;
_l20:    la x16, d_3_12                    ;
      addi x16, x16, 16         ;
      lui x26, 0xffe00         ;
      xor x16, x16, x26         ;
      amominu.d x30, x26, (x16)         ;
_l21:    srlw x26, x5, x28                    ;
_l22:    la x2, d_0_16                    ;
      lhu x28, -28(x2)         ;
_l23:    csrrsi x27, pmpaddr3, 17                    ;
_l24:    fmax.s f31, f27, f4                    ;
_l25:    fmax.s f1, f9, f29                    ;
_l26:    feq.s x20, f5, f27                    ;
_l27:    la x4, d_3_22                    ;
      addi x4, x4, -20         ;
      amoand.w x6, x11, (x4)         ;
_l28:    la x5, d_1_16                    ;
      addi x5, x5, -24         ;
      amoand.w x6, x22, (x5)         ;
_l29:    la x26, d_3_14                    ;
      addi x26, x26, -28         ;
      amomax.w x8, x10, (x26)         ;
_l30:    fmul.s f17, f7, f3, rne                    ;
_l31:    csrrsi x22, sscratch, 31                    ;
_l32:    la x11, d_0_7                    ;
      addi x11, x11, -24         ;
      amoswap.d x8, x6, (x11)         ;
_l33:    la x18, d_0_4                    ;
      addi x18, x18, -24         ;
      amoor.d x18, x7, (x18)         ;
_l34:    la x13, d_3_23                    ;
      addi x13, x13, 16         ;
      amoxor.w x7, x13, (x13)         ;
_l35:    addi x0, x1, 0                    ;
_l36:    xori x19, x25, 728                    ;
_l37:    csrrsi x22, sscratch, 31                    ;
_l38:    la x18, d_0_2                    ;
      lui x26, 0xffe00         ;
      xor x18, x18, x26         ;
      sd x18, 8(x18)         ;
_l39:    fsqrt.s f0, f5, rne                    ;
_l40:    fmul.s f17, f7, f3, rne                    ;
_l41:    fcvt.s.lu f18, x14, rne                    ;
_l42:    fsub.s f31, f2, f10, rne                    ;
_l43:    fclass.s x5, f23                    ;
_l44:    sraw x10, x25, x12                    ;
_l45:    la x15, d_2_18                    ;
      addi x15, x15, 0         ;
      sc.d x30, x15, (x15)         ;
_l46:    la x12, d_3_20                    ;
      addi x12, x12, -16         ;
      amoxor.d x26, x10, (x12)         ;
_l47:    srliw x25, x21, 12                    ;
_l48:    fcvt.s.l f14, x30, rne                    ;
_l49:    xori x19, x6, -0                    ;
_l50:    la x14, d_0_14                    ;
      addi x14, x14, 16         ;
      lr.d x4, (x14)         ;
_l51:    ori x19, x30, 418                    ;
_l52:    la x3, d_5_2                    ;
      addi x3, x3, -0         ;
      amoor.w x3, x11, (x3)         ;
_l53:    fcvt.l.s x4, f13, rne                    ;
_l54:    srai x15, x10, 6                    ;
_l55:    sret                    ;
_l56:    fcvt.s.lu f19, x26, rne                    ;
_l57:    la x1, d_3_14                    ;
      sw x20, -12(x1)         ;
_l58:    la x13, _l7                    ;
      lw x27, 16(x13)         ;
_l59:    fmv.x.w x22, f10                    ;
_l60:    sllw x0, x17, x23                    ;
_l61:    flt.s x13, f18, f18                    ;
_l62:    la x6, d_1_24                    ;
      addi x6, x6, -8         ;
      amoadd.w x25, x16, (x6)         ;
_l63:    la x15, d_3_10                    ;
      lhu x18, 0(x15)         ;
_l64:    fmax.s f23, f6, f8                    ;
_l65:    la x25, d_2_12                    ;
      lui x21, 0xffe00         ;
      xor x25, x25, x21         ;
      lh x25, -30(x25)         ;
_l66:    fmadd.s f11, f26, f13, f2, rne                    ;
_l67:    la x2, d_3_25                    ;
      flw f19, -0(x2)         ;
_l68:    subw x24, x27, x28                    ;
_l69:    fsgnjx.s f11, f5, f17                    ;
_l70:    la x26, d_3_24                    ;
      lb x6, -31(x26)         ;
_l71:    fdiv.s f3, f9, f3, rne                    ;
_l72:    fle.s x10, f29, f14                    ;
_l73:    la x18, d_2_17                    ;
      addi x18, x18, -0         ;
      amoxor.w x5, x16, (x18)         ;
_l74:    srai x18, x0, 18                    ;
_l75:    fmax.s f27, f3, f20                    ;
_l76:    fcvt.s.lu f15, x9, rne                    ;
_l77:    la x8, _l35                    ;
      lhu x11, 14(x8)         ;
_l78:    feq.s x13, f28, f21                    ;
_l79:    la x11, d_3_12                    ;
      sb x10, -16(x11)         ;
_l80:    addw x17, x1, x12                    ;
_l81:    fcvt.l.s x0, f6, rne                    ;
_l82:    la x19, d_0_8                    ;
      addi x19, x19, 4         ;
      amoor.w x15, x25, (x19)         ;
_l83:    la x13, d_5_19                    ;
      addi x13, x13, 12         ;
      amoxor.w x16, x4, (x13)         ;
_l84:    la x10, d_2_19                    ;
      flw f9, 0(x10)         ;
_l85:    la x23, d_1_11                    ;
      addi x23, x23, 24         ;
      amoxor.d x6, x10, (x23)         ;
_l86:    fnmsub.s f21, f22, f7, f1, rne                    ;
_l87:    la x17, d_3_25                    ;
      addi x17, x17, 16         ;
      lr.w x4, (x17)         ;
_l88:    fsub.s f14, f8, f19, rne                    ;
_l89:    subw x15, x21, x28                    ;
_l90:    la x5, d_3_10                    ;
      addi x5, x5, 0         ;
      lr.d x24, (x5)         ;
_l91:    la x19, d_0_8                    ;
      addi x19, x19, 4         ;
      amoor.w x15, x25, (x19)         ;
_l92:    fle.s x3, f17, f26                    ;
_l93:    la x15, d_4_22                    ;
      fsw f6, -0(x15)         ;
_l94:    srlw x28, x6, x5                    ;
_l95:    mret                    ;
_l96:    sraiw x3, x16, 31                    ;
_l97:    la x3, d_5_27                    ;
      lh x14, -2(x3)         ;
_l98:    fcvt.lu.s x3, f29, rne                    ;
_l99:    la x26, d_5_14                    ;
      addi x26, x26, 12         ;
      amomax.w x30, x8, (x26)         ;
_l100:    fnmadd.s f0, f16, f24, f11, rne                    ;
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
                .dword 0xb240f31b6902408a, 0x9fe9994b3e764485
                .dword 0x02922e80e31acc10, 0x22eb1fe6d4cac2d1
d_0_0:          .dword 0xdf22bbf1f9d7c218, 0x688e04c462625d75
d_0_1:          .dword 0x7dfc39154d81f145, 0x33f240b9f28e6ea8
d_0_2:          .dword 0x6e1ffff1e03dae5b, 0xb86d21338e829254
d_0_3:          .dword 0x75e8f67b4a317218, 0xcf8a08cc7eeee9da
d_0_4:          .dword 0xc7c6ab11096b3454, 0xe14afb6b4b85c7ae
d_0_5:          .dword 0x686b7fc5b14f216e, 0x568b5f63204ea7f1
d_0_6:          .dword 0x69a82d82b5ab0420, 0xdbfa6c34eb5d57fa
d_0_7:          .dword 0x02e33249365b3661, 0xcfe19cc7a8ae431d
d_0_8:          .dword 0xafaefc35af66ef29, 0x295428dc24c88eaa
d_0_9:          .dword 0x37bf773f04040502, 0xbcf7a412b2725888
d_0_10:         .dword 0x454f45d0325cf7d4, 0x5b535f3c5e86d56f
d_0_11:         .dword 0xe12bbfa92bffe120, 0xfb15c662652c7917
d_0_12:         .dword 0x8da553aad8ee4323, 0xe8cdabacf0bc41c4
d_0_13:         .dword 0x03d326b46c3cf8e0, 0x5a6828cc4e164b34
d_0_14:         .dword 0xf015d08f6269d1aa, 0xe2167e047ae2b529
d_0_15:         .dword 0xd15ac8124eb480f2, 0xca03766408e61bb7
d_0_16:         .dword 0x6aea3ccc8dbfe753, 0x5a448fa61ea04ae4
d_0_17:         .dword 0x9ab882c3543e1d83, 0x33d6642aa62a2f67
d_0_18:         .dword 0xdb92af4e4778a98a, 0xc9c70986a9e7e360
d_0_19:         .dword 0xabf545374d803e76, 0xdd27212a02437a61
d_0_20:         .dword 0xccc06044bf97916e, 0x9eb220b2a253a148
d_0_21:         .dword 0xc508103e432294ea, 0x4aa5efad0f1e5d89
d_0_22:         .dword 0xb949cc9521ff8ef9, 0xc53e78bd19a7a1ed
d_0_23:         .dword 0xc697b39a2429c8a4, 0x159edd12452f7c52
d_0_24:         .dword 0x0cb6371e94dc3256, 0x7bfb213d77f58fa5
d_0_25:         .dword 0x7c8542be0f1c604c, 0x6631abc527678db2
d_0_26:         .dword 0x806c2f4b20d35603, 0xe3e3d83bda230f57
d_0_27:         .dword 0x4320edede78f7bf1, 0xc8cf92bae47f95d2
                .dword 0xe596e18165d0816e, 0x72f1f0615b4e1871
                .dword 0x39686b8d3df4efb7, 0x7efd3ac51a695654
        /* Random data */
_end_data0:
                 

    .section .data.random1;
    .align  8;

_random_data1:
                .dword 0x8e316d656404bf0c, 0x37b14ed298e39707
                .dword 0x879418389a33af5b, 0x1328ddde03995e1f
d_1_0:          .dword 0x424eb6e45bc68de3, 0x354189c90dcef111
d_1_1:          .dword 0x237cfd5c4d87c0c8, 0xacf6ccbd6d323037
d_1_2:          .dword 0x429a77ba5580f0e1, 0x5db7c10ae6abe06e
d_1_3:          .dword 0xc24209f40fc2b967, 0xbb261f20c75c6914
d_1_4:          .dword 0x7e84f0d6a42dbf1b, 0x2c286599c75a404b
d_1_5:          .dword 0xfdd26eaa37168e76, 0xd4b15ce8f71c09ff
d_1_6:          .dword 0xfcf7acff6ae130c6, 0x947e250fd428260b
d_1_7:          .dword 0x2e922aec6ad11c66, 0x9896f5695fd2a1f7
d_1_8:          .dword 0xcedec8dc93c4ce1d, 0xe505f29f735ac639
d_1_9:          .dword 0x5371b46cd78f2aed, 0x28da0481a2d780cd
d_1_10:         .dword 0x3bd7566b9d0a8690, 0x4fd5849f00e396b8
d_1_11:         .dword 0x811c31290996f431, 0x295ba1a93f49e34f
d_1_12:         .dword 0x292a90b995c08ab5, 0xf712b37529c9d679
d_1_13:         .dword 0x64f2c86d51d64a2b, 0x65fe239728496555
d_1_14:         .dword 0xfefab48f37b05607, 0xa9a1ff0968459635
d_1_15:         .dword 0x7da5118aa29ecf9d, 0x3e25d9dcb70cd043
d_1_16:         .dword 0x60c74e43426c56e6, 0x921a5617fd74242a
d_1_17:         .dword 0xa871086e70c0bae6, 0x3dfd41ea26b44061
d_1_18:         .dword 0xbfbfb754da087292, 0xbd59b22167a9c7b3
d_1_19:         .dword 0xeb533f4c91c94db6, 0xcd0b955a528b7358
d_1_20:         .dword 0xd06aac37b83e0a86, 0xbfdd296a9a9bae20
d_1_21:         .dword 0x354b18c01c8d0898, 0xe9ffb7a8f2072ace
d_1_22:         .dword 0x326c593ea598d02b, 0x7668577b5d90a1a3
d_1_23:         .dword 0x4011e6ce293c5a2e, 0x2e3fd9419e6e2a51
d_1_24:         .dword 0x5a07050f31dba993, 0x70a2fa11fc0a207c
d_1_25:         .dword 0xb43a32de66801958, 0x5af5aa63f56c59a6
d_1_26:         .dword 0xa55e02dc0a986df2, 0x1b0f2a88ffc54858
d_1_27:         .dword 0x12a3e9ab06eaa097, 0x3dd4a1df31b4bcd1
                .dword 0x0d977a522af79ce2, 0x4daa4a3ffa90fdb7
                .dword 0x898ec8f5baa5a42f, 0x51c795333c71c713
        /* Random data */
_end_data1:


    .section .data.random2;
    .align  8;

_random_data2:
                .dword 0x932a5a5e2d24076c, 0x0fe021223d8dc7ef
                .dword 0x6789958209bb6892, 0x8593f2e45b3869ed
d_2_0:          .dword 0x16057244aa8f0cdc, 0x690c3b97df535c8a
d_2_1:          .dword 0x4fa17221f3b913a2, 0x0fd4dd0afc6c6a6e
d_2_2:          .dword 0x047d472ba6726528, 0x78063c4d70d0f355
d_2_3:          .dword 0x4a101ef9626be699, 0x570a12326b7f4d8c
d_2_4:          .dword 0x8ffa2fe18c208f26, 0x5bc08f3dfb4ed72a
d_2_5:          .dword 0x7bf3c98893f111e6, 0xdf682492c85d9817
d_2_6:          .dword 0x0dc0c9619e234bde, 0x3bd7a2a09d0a4e45
d_2_7:          .dword 0x082aea79204f98f7, 0x41c5c8e37ca314d1
d_2_8:          .dword 0x6da71c02ccf56dc2, 0xe2e51d740fcc8a44
d_2_9:          .dword 0x571c127b20e6cb11, 0x3c8d4157420670ce
d_2_10:         .dword 0x551f4183d9b29d15, 0x9332f3992e81253d
d_2_11:         .dword 0x0de4372d6b4969a5, 0x5f42e4501679a22e
d_2_12:         .dword 0x0cd8612add270617, 0x539733bb42167aa8
d_2_13:         .dword 0xb5dcf5ebe06f3b9e, 0x9fcbdf7c91e12ee1
d_2_14:         .dword 0x0f2c016006e0b24b, 0xcf8785337827c35c
d_2_15:         .dword 0x97488f7a94b5011e, 0x727119200badf3f1
d_2_16:         .dword 0x72809173160e0c83, 0xa568874167adcd0c
d_2_17:         .dword 0xfa53773626e10000, 0x3f9457fee32030f9
d_2_18:         .dword 0x97967131015f2889, 0xbffd290c850919b6
d_2_19:         .dword 0x0ad49947770cb547, 0x046263aaec53e15b
d_2_20:         .dword 0xa5c7c9b0c6fdcc4d, 0x19199f014869d685
d_2_21:         .dword 0xa75376dcea60fad8, 0xe677b5a84ed512fe
d_2_22:         .dword 0xfbe77aef70a089e3, 0x2e73a16bb41da611
d_2_23:         .dword 0x1866dbfdce9ad89a, 0x0252e3d5499c512d
d_2_24:         .dword 0x925f27736188b896, 0x5a713ae393d5cefa
d_2_25:         .dword 0x9e3d60c4d03b851b, 0xa9fc2b43fbe9d92f
d_2_26:         .dword 0x9fc40dfcbd3363f7, 0xe47af521eed97117
d_2_27:         .dword 0x594882f081e92732, 0xb12378282cb7de6a
                .dword 0x709d185e965d76ea, 0xe09f95b608e38fca
                .dword 0x58be4bac94765c56, 0xc72cce954e7d3fd3
         /* Random data */
_end_data2:
                

    .section .data.random3;
    .align  8;

_random_data3:
                .dword 0xf17bb5d0ec60c4d1, 0xb18c07fc77b99295
                .dword 0xa10c9635f950483d, 0x2db37ff3439b719a
d_3_0:          .dword 0x9691b1d1ec07477f, 0xda5fa166d56fdcae
d_3_1:          .dword 0xc9086d1591f93a3d, 0x114072c4d972fe95
d_3_2:          .dword 0x1e47ed9158291ff2, 0xa2def171f367ad43
d_3_3:          .dword 0x8d9153a60c98d1a2, 0xe13af314b04a9d41
d_3_4:          .dword 0xed435780033c53f7, 0xff23189412be328b
d_3_5:          .dword 0xaf407aff805e17d5, 0x30dd3ec010eee73e
d_3_6:          .dword 0x6c1a5d6027c7009b, 0x4b86484ef8902d08
d_3_7:          .dword 0x7fe53954c71b1739, 0x60db5a3b326de500
d_3_8:          .dword 0x70ae02852eb41ee1, 0x7333a97cc95e696e
d_3_9:          .dword 0x414157b02fc56df7, 0x5b680a4b2706b9c7
d_3_10:         .dword 0x1ed7e8e9eae9070f, 0xca372f8f32e5fe1a
d_3_11:         .dword 0x93c7396fe19080c6, 0x880ab323c6498ec6
d_3_12:         .dword 0x8e5a6c551744603d, 0xb770a18ebe9924a1
d_3_13:         .dword 0x14c2e0a211c24a8e, 0x190a2d87b53640b8
d_3_14:         .dword 0x2bd6cb6bbe8d0800, 0x9aa34a4b54fcab9a
d_3_15:         .dword 0x6c28205e11728c9b, 0x5ec1e0222462cd72
d_3_16:         .dword 0xdf719b3a45dd9110, 0x27147d35ce29bffa
d_3_17:         .dword 0x1afe36ce88a57404, 0x8ee7fb8c9c9cef5e
d_3_18:         .dword 0x864a3fc39c32d300, 0xa7ac414de8ce05c0
d_3_19:         .dword 0x8c448003a212e88f, 0x288352170795aa3c
d_3_20:         .dword 0xaf0844d5062f307c, 0xaec0d9644dffae0e
d_3_21:         .dword 0xc026cf6bf7276f61, 0xbce1c06248fd48b7
d_3_22:         .dword 0x89d7b33c425bf7e3, 0xf45c93ae00341fe1
d_3_23:         .dword 0x47c62ab04e25843a, 0xe6406a686f5a8e67
d_3_24:         .dword 0x9d6f9853605935fd, 0x819cc523884a18f7
d_3_25:         .dword 0xa802142d63964d06, 0x4704801949289996
d_3_26:         .dword 0xa13ac8d554fc3f43, 0x5ad2067081d02159
d_3_27:         .dword 0x0322ac3b96fa386d, 0xce2106a59913ce6c
                .dword 0x1a4128c8a3f7333c, 0x3dcfd16e44744f4e
                .dword 0x54973f3b6d0fe88c, 0x0bd74ad7836f65d7
        /* Random data */
_end_data3:


    .section .data.random4;
    .align  8;

_random_data4:
                .dword 0xebec0bf3e2fbc083, 0xd65917f2af14f2ba
                .dword 0xc360241259fc1661, 0x515ceaceabdc5af6
d_4_0:          .dword 0x04d415bba17f44a8, 0xee895c9fd05403d0
d_4_1:          .dword 0x7ee4de20ae0ca162, 0xa838f190b892efc9
d_4_2:          .dword 0x14a340c01e382757, 0x55ffe3055929cda2
d_4_3:          .dword 0x88c14d439b0818f1, 0x63b2ae3e7d6ddf33
d_4_4:          .dword 0x6d54e321642b673e, 0xa6271858cd000aa4
d_4_5:          .dword 0x9d4568a1cb951818, 0x60ed7576a135d696
d_4_6:          .dword 0x0288ca77ca0828d6, 0xfe5a92221f35a80b
d_4_7:          .dword 0xb95448c6d74f8353, 0xd44f26c091853f33
d_4_8:          .dword 0xa312597f92689eeb, 0xb6ddbe8d45d73d69
d_4_9:          .dword 0xa86e90d65d16457c, 0x768a40cc0f55f7b1
d_4_10:         .dword 0x8e5a22d0f83303ec, 0x380af4940b9d1636
d_4_11:         .dword 0x2ce11a5932e49d95, 0x941c30c076c0e22a
d_4_12:         .dword 0xb94d097bec35e8b4, 0xb3a20d3dab2e8e38
d_4_13:         .dword 0x5b5b3c1e0eb39c5b, 0x433e0637d08810f9
d_4_14:         .dword 0x4e7f704f264fddb1, 0x739e319637824d6b
d_4_15:         .dword 0xa26139befa6b7655, 0x4e2a8d0f5c48257c
d_4_16:         .dword 0xe877f8f1bdc955be, 0x96530d2766bdfc48
d_4_17:         .dword 0x89989a379725c9bc, 0xea4b3246b6811acf
d_4_18:         .dword 0xfa84c45203a0422c, 0xa138d663fb895f6a
d_4_19:         .dword 0x0ac92b3e912c257b, 0x4585953845f535de
d_4_20:         .dword 0x42e27c19d7672b0e, 0x0658d30bded20751
d_4_21:         .dword 0xa29e4e727727d50c, 0x3b5374a04e53aa5b
d_4_22:         .dword 0x066195214d303b43, 0xa97e08617a66bdf7
d_4_23:         .dword 0x5f4e9fe1351063b7, 0x49dcd3c742ab4d74
d_4_24:         .dword 0xeb1212e4a9d4fa4f, 0x12d6b6afe9d6fa7f
d_4_25:         .dword 0xb6bb83c9416ecd73, 0x9574fca45fec9b55
d_4_26:         .dword 0x5691941f61fe3fee, 0xe8ae3ca2631eb616
d_4_27:         .dword 0x6af34123b8b11a73, 0x04dd19f3756311b9
                .dword 0x4097d81b840b1d62, 0xcf050a0eb9c3b4a4
                .dword 0x76eaa8a2651be9ba, 0x160089680b755429
        /* Random data */
_end_data4:


    .section .data.random5;
    .align  8;

_random_data5:
                .dword 0xfcdc26165fbc1c73, 0x5c9020ed9ae29d9b
                .dword 0x036ae4f5a5a1ac60, 0xd10811b51cf73494
d_5_0:          .dword 0x1c7caf63a9514ccb, 0xf5a42848fcaa534a
d_5_1:          .dword 0x19b2b2c2d0902d13, 0x1565b15141495b17
d_5_2:          .dword 0x72095e8c08287482, 0xc48b5018719e5bbf
d_5_3:          .dword 0xa7e4d3cc2566a2a4, 0x1dce8d0119f9bc6f
d_5_4:          .dword 0x2cd87fb80d31399f, 0xfbf907b79f372951
d_5_5:          .dword 0x61d4d62564b05afb, 0x9f7e32790bbb1b3a
d_5_6:          .dword 0xbd8efb9347fad085, 0x4c399e92e89ca4fe
d_5_7:          .dword 0x3a05f44d1a714da9, 0x8e71129cb9127a56
d_5_8:          .dword 0xd8180889d5bd300b, 0x85dc5eea582b00ed
d_5_9:          .dword 0x237115cfb409cfc4, 0xa9148cb39e639a22
d_5_10:         .dword 0x3583079dd146c3b7, 0x1ee7d7224255363b
d_5_11:         .dword 0xc681912f9b021f9e, 0x9fdebb1ef106b739
d_5_12:         .dword 0x57fac379861ee35e, 0xfa0f530cdfe853bd
d_5_13:         .dword 0x33067f9318e7b24d, 0x54818d6690302a41
d_5_14:         .dword 0x03224151798722c2, 0x51c7b8498388a5e9
d_5_15:         .dword 0x875d4682fc9d6290, 0x741bb3ee547c614b
d_5_16:         .dword 0x2d859374e19a2d48, 0x3c9cf02839a86253
d_5_17:         .dword 0x903340218b7e3db4, 0x720213b7d14a2f51
d_5_18:         .dword 0x9e1829ba60484984, 0xd0aefbcfcf536d5d
d_5_19:         .dword 0x3ec4eae94bae44ba, 0xe4b46eda8db623d5
d_5_20:         .dword 0x29772aa0d784dab7, 0x5a05607ef1d53f23
d_5_21:         .dword 0x66d3d85cbb95c5c7, 0x129b91c937da7556
d_5_22:         .dword 0xf7fb983581c25aa6, 0x1548a104e45ad2f2
d_5_23:         .dword 0xc4cf0c8e18c77e91, 0xbc011b0c4e90ffcd
d_5_24:         .dword 0xc32eabe84dc907d4, 0xaa2eda7f6b604499
d_5_25:         .dword 0x72f9e848495239c1, 0x27225a6cb40c681e
d_5_26:         .dword 0xfc7d06f65e406ffb, 0x0ec7b4c934b18b94
d_5_27:         .dword 0xab5009b786a7da5e, 0xa061858430b349f4
                .dword 0x11eef65cd38527ff, 0xbb4c63db42e44167
                .dword 0x70c6d227f763902a, 0x661de6ec8a3341e0
         /* Random data */
_end_data5:
              
                 
