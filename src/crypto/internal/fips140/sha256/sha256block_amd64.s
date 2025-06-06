// Code generated by command: go run sha256block_amd64_asm.go -out ../sha256block_amd64.s. DO NOT EDIT.

//go:build !purego

#include "textflag.h"

// func blockAVX2(dig *Digest, p []byte)
// Requires: AVX, AVX2, BMI2
TEXT ·blockAVX2(SB), $536-32
	MOVQ dig+0(FP), SI
	MOVQ p_base+8(FP), DI
	MOVQ p_len+16(FP), DX
	LEAQ -64(DI)(DX*1), DX
	MOVQ DX, 512(SP)
	CMPQ DX, DI
	JE   avx2_only_one_block

	// Load initial digest
	MOVL (SI), AX
	MOVL 4(SI), BX
	MOVL 8(SI), CX
	MOVL 12(SI), R8
	MOVL 16(SI), DX
	MOVL 20(SI), R9
	MOVL 24(SI), R10
	MOVL 28(SI), R11

avx2_loop0:
	// at each iteration works with one block (512 bit)
	VMOVDQU (DI), Y0
	VMOVDQU 32(DI), Y1
	VMOVDQU 64(DI), Y2
	VMOVDQU 96(DI), Y3
	VMOVDQU flip_mask<>+0(SB), Y13

	// Apply Byte Flip Mask: LE -> BE
	VPSHUFB Y13, Y0, Y0
	VPSHUFB Y13, Y1, Y1
	VPSHUFB Y13, Y2, Y2
	VPSHUFB Y13, Y3, Y3

	// Transpose data into high/low parts
	VPERM2I128 $0x20, Y2, Y0, Y4
	VPERM2I128 $0x31, Y2, Y0, Y5
	VPERM2I128 $0x20, Y3, Y1, Y6
	VPERM2I128 $0x31, Y3, Y1, Y7
	LEAQ       K256<>+0(SB), BP

avx2_last_block_enter:
	ADDQ $0x40, DI
	MOVQ DI, 520(SP)
	XORQ SI, SI

avx2_loop1:
	// Do 4 rounds and scheduling
	VPADDD   (BP)(SI*1), Y4, Y9
	VMOVDQU  Y9, (SP)(SI*1)
	MOVL     AX, DI
	RORXL    $0x19, DX, R13
	RORXL    $0x0b, DX, R14
	ADDL     (SP)(SI*1), R11
	ORL      CX, DI
	VPALIGNR $0x04, Y6, Y7, Y0
	MOVL     R9, R15
	RORXL    $0x0d, AX, R12
	XORL     R14, R13
	XORL     R10, R15
	VPADDD   Y4, Y0, Y0
	RORXL    $0x06, DX, R14
	ANDL     DX, R15
	XORL     R14, R13
	RORXL    $0x16, AX, R14
	ADDL     R11, R8
	ANDL     BX, DI
	VPALIGNR $0x04, Y4, Y5, Y1
	XORL     R12, R14
	RORXL    $0x02, AX, R12
	XORL     R10, R15
	VPSRLD   $0x07, Y1, Y2
	XORL     R12, R14
	MOVL     AX, R12
	ANDL     CX, R12
	ADDL     R13, R15
	VPSLLD   $0x19, Y1, Y3
	ORL      R12, DI
	ADDL     R14, R11
	ADDL     R15, R8
	VPOR     Y2, Y3, Y3
	VPSRLD   $0x12, Y1, Y2
	ADDL     R15, R11
	ADDL     DI, R11
	MOVL     R11, DI
	RORXL    $0x19, R8, R13
	RORXL    $0x0b, R8, R14
	ADDL     4(SP)(SI*1), R10
	ORL      BX, DI
	VPSRLD   $0x03, Y1, Y8
	MOVL     DX, R15
	RORXL    $0x0d, R11, R12
	XORL     R14, R13
	XORL     R9, R15
	RORXL    $0x06, R8, R14
	XORL     R14, R13
	RORXL    $0x16, R11, R14
	ANDL     R8, R15
	ADDL     R10, CX
	VPSLLD   $0x0e, Y1, Y1
	ANDL     AX, DI
	XORL     R12, R14
	VPXOR    Y1, Y3, Y3
	RORXL    $0x02, R11, R12
	XORL     R9, R15
	VPXOR    Y2, Y3, Y3
	XORL     R12, R14
	MOVL     R11, R12
	ANDL     BX, R12
	ADDL     R13, R15
	VPXOR    Y8, Y3, Y1
	VPSHUFD  $0xfa, Y7, Y2
	ORL      R12, DI
	ADDL     R14, R10
	VPADDD   Y1, Y0, Y0
	ADDL     R15, CX
	ADDL     R15, R10
	ADDL     DI, R10
	VPSRLD   $0x0a, Y2, Y8
	MOVL     R10, DI
	RORXL    $0x19, CX, R13
	ADDL     8(SP)(SI*1), R9
	VPSRLQ   $0x13, Y2, Y3
	RORXL    $0x0b, CX, R14
	ORL      AX, DI
	MOVL     R8, R15
	XORL     DX, R15
	RORXL    $0x0d, R10, R12
	XORL     R14, R13
	VPSRLQ   $0x11, Y2, Y2
	ANDL     CX, R15
	RORXL    $0x06, CX, R14
	VPXOR    Y3, Y2, Y2
	ADDL     R9, BX
	ANDL     R11, DI
	XORL     R14, R13
	RORXL    $0x16, R10, R14
	VPXOR    Y2, Y8, Y8
	XORL     DX, R15
	VPSHUFB  shuff_00BA<>+0(SB), Y8, Y8
	XORL     R12, R14
	RORXL    $0x02, R10, R12
	VPADDD   Y8, Y0, Y0
	XORL     R12, R14
	MOVL     R10, R12
	ANDL     AX, R12
	ADDL     R13, R15
	VPSHUFD  $0x50, Y0, Y2
	ORL      R12, DI
	ADDL     R14, R9
	ADDL     R15, BX
	ADDL     R15, R9
	ADDL     DI, R9
	MOVL     R9, DI
	RORXL    $0x19, BX, R13
	RORXL    $0x0b, BX, R14
	ADDL     12(SP)(SI*1), DX
	ORL      R11, DI
	VPSRLD   $0x0a, Y2, Y11
	MOVL     CX, R15
	RORXL    $0x0d, R9, R12
	XORL     R14, R13
	XORL     R8, R15
	VPSRLQ   $0x13, Y2, Y3
	RORXL    $0x06, BX, R14
	ANDL     BX, R15
	ADDL     DX, AX
	ANDL     R10, DI
	VPSRLQ   $0x11, Y2, Y2
	XORL     R14, R13
	XORL     R8, R15
	VPXOR    Y3, Y2, Y2
	RORXL    $0x16, R9, R14
	ADDL     R13, R15
	VPXOR    Y2, Y11, Y11
	XORL     R12, R14
	ADDL     R15, AX
	RORXL    $0x02, R9, R12
	VPSHUFB  shuff_DC00<>+0(SB), Y11, Y11
	VPADDD   Y0, Y11, Y4
	XORL     R12, R14
	MOVL     R9, R12
	ANDL     R11, R12
	ORL      R12, DI
	ADDL     R14, DX
	ADDL     R15, DX
	ADDL     DI, DX

	// Do 4 rounds and scheduling
	VPADDD   32(BP)(SI*1), Y5, Y9
	VMOVDQU  Y9, 32(SP)(SI*1)
	MOVL     DX, DI
	RORXL    $0x19, AX, R13
	RORXL    $0x0b, AX, R14
	ADDL     32(SP)(SI*1), R8
	ORL      R10, DI
	VPALIGNR $0x04, Y7, Y4, Y0
	MOVL     BX, R15
	RORXL    $0x0d, DX, R12
	XORL     R14, R13
	XORL     CX, R15
	VPADDD   Y5, Y0, Y0
	RORXL    $0x06, AX, R14
	ANDL     AX, R15
	XORL     R14, R13
	RORXL    $0x16, DX, R14
	ADDL     R8, R11
	ANDL     R9, DI
	VPALIGNR $0x04, Y5, Y6, Y1
	XORL     R12, R14
	RORXL    $0x02, DX, R12
	XORL     CX, R15
	VPSRLD   $0x07, Y1, Y2
	XORL     R12, R14
	MOVL     DX, R12
	ANDL     R10, R12
	ADDL     R13, R15
	VPSLLD   $0x19, Y1, Y3
	ORL      R12, DI
	ADDL     R14, R8
	ADDL     R15, R11
	VPOR     Y2, Y3, Y3
	VPSRLD   $0x12, Y1, Y2
	ADDL     R15, R8
	ADDL     DI, R8
	MOVL     R8, DI
	RORXL    $0x19, R11, R13
	RORXL    $0x0b, R11, R14
	ADDL     36(SP)(SI*1), CX
	ORL      R9, DI
	VPSRLD   $0x03, Y1, Y8
	MOVL     AX, R15
	RORXL    $0x0d, R8, R12
	XORL     R14, R13
	XORL     BX, R15
	RORXL    $0x06, R11, R14
	XORL     R14, R13
	RORXL    $0x16, R8, R14
	ANDL     R11, R15
	ADDL     CX, R10
	VPSLLD   $0x0e, Y1, Y1
	ANDL     DX, DI
	XORL     R12, R14
	VPXOR    Y1, Y3, Y3
	RORXL    $0x02, R8, R12
	XORL     BX, R15
	VPXOR    Y2, Y3, Y3
	XORL     R12, R14
	MOVL     R8, R12
	ANDL     R9, R12
	ADDL     R13, R15
	VPXOR    Y8, Y3, Y1
	VPSHUFD  $0xfa, Y4, Y2
	ORL      R12, DI
	ADDL     R14, CX
	VPADDD   Y1, Y0, Y0
	ADDL     R15, R10
	ADDL     R15, CX
	ADDL     DI, CX
	VPSRLD   $0x0a, Y2, Y8
	MOVL     CX, DI
	RORXL    $0x19, R10, R13
	ADDL     40(SP)(SI*1), BX
	VPSRLQ   $0x13, Y2, Y3
	RORXL    $0x0b, R10, R14
	ORL      DX, DI
	MOVL     R11, R15
	XORL     AX, R15
	RORXL    $0x0d, CX, R12
	XORL     R14, R13
	VPSRLQ   $0x11, Y2, Y2
	ANDL     R10, R15
	RORXL    $0x06, R10, R14
	VPXOR    Y3, Y2, Y2
	ADDL     BX, R9
	ANDL     R8, DI
	XORL     R14, R13
	RORXL    $0x16, CX, R14
	VPXOR    Y2, Y8, Y8
	XORL     AX, R15
	VPSHUFB  shuff_00BA<>+0(SB), Y8, Y8
	XORL     R12, R14
	RORXL    $0x02, CX, R12
	VPADDD   Y8, Y0, Y0
	XORL     R12, R14
	MOVL     CX, R12
	ANDL     DX, R12
	ADDL     R13, R15
	VPSHUFD  $0x50, Y0, Y2
	ORL      R12, DI
	ADDL     R14, BX
	ADDL     R15, R9
	ADDL     R15, BX
	ADDL     DI, BX
	MOVL     BX, DI
	RORXL    $0x19, R9, R13
	RORXL    $0x0b, R9, R14
	ADDL     44(SP)(SI*1), AX
	ORL      R8, DI
	VPSRLD   $0x0a, Y2, Y11
	MOVL     R10, R15
	RORXL    $0x0d, BX, R12
	XORL     R14, R13
	XORL     R11, R15
	VPSRLQ   $0x13, Y2, Y3
	RORXL    $0x06, R9, R14
	ANDL     R9, R15
	ADDL     AX, DX
	ANDL     CX, DI
	VPSRLQ   $0x11, Y2, Y2
	XORL     R14, R13
	XORL     R11, R15
	VPXOR    Y3, Y2, Y2
	RORXL    $0x16, BX, R14
	ADDL     R13, R15
	VPXOR    Y2, Y11, Y11
	XORL     R12, R14
	ADDL     R15, DX
	RORXL    $0x02, BX, R12
	VPSHUFB  shuff_DC00<>+0(SB), Y11, Y11
	VPADDD   Y0, Y11, Y5
	XORL     R12, R14
	MOVL     BX, R12
	ANDL     R8, R12
	ORL      R12, DI
	ADDL     R14, AX
	ADDL     R15, AX
	ADDL     DI, AX

	// Do 4 rounds and scheduling
	VPADDD   64(BP)(SI*1), Y6, Y9
	VMOVDQU  Y9, 64(SP)(SI*1)
	MOVL     AX, DI
	RORXL    $0x19, DX, R13
	RORXL    $0x0b, DX, R14
	ADDL     64(SP)(SI*1), R11
	ORL      CX, DI
	VPALIGNR $0x04, Y4, Y5, Y0
	MOVL     R9, R15
	RORXL    $0x0d, AX, R12
	XORL     R14, R13
	XORL     R10, R15
	VPADDD   Y6, Y0, Y0
	RORXL    $0x06, DX, R14
	ANDL     DX, R15
	XORL     R14, R13
	RORXL    $0x16, AX, R14
	ADDL     R11, R8
	ANDL     BX, DI
	VPALIGNR $0x04, Y6, Y7, Y1
	XORL     R12, R14
	RORXL    $0x02, AX, R12
	XORL     R10, R15
	VPSRLD   $0x07, Y1, Y2
	XORL     R12, R14
	MOVL     AX, R12
	ANDL     CX, R12
	ADDL     R13, R15
	VPSLLD   $0x19, Y1, Y3
	ORL      R12, DI
	ADDL     R14, R11
	ADDL     R15, R8
	VPOR     Y2, Y3, Y3
	VPSRLD   $0x12, Y1, Y2
	ADDL     R15, R11
	ADDL     DI, R11
	MOVL     R11, DI
	RORXL    $0x19, R8, R13
	RORXL    $0x0b, R8, R14
	ADDL     68(SP)(SI*1), R10
	ORL      BX, DI
	VPSRLD   $0x03, Y1, Y8
	MOVL     DX, R15
	RORXL    $0x0d, R11, R12
	XORL     R14, R13
	XORL     R9, R15
	RORXL    $0x06, R8, R14
	XORL     R14, R13
	RORXL    $0x16, R11, R14
	ANDL     R8, R15
	ADDL     R10, CX
	VPSLLD   $0x0e, Y1, Y1
	ANDL     AX, DI
	XORL     R12, R14
	VPXOR    Y1, Y3, Y3
	RORXL    $0x02, R11, R12
	XORL     R9, R15
	VPXOR    Y2, Y3, Y3
	XORL     R12, R14
	MOVL     R11, R12
	ANDL     BX, R12
	ADDL     R13, R15
	VPXOR    Y8, Y3, Y1
	VPSHUFD  $0xfa, Y5, Y2
	ORL      R12, DI
	ADDL     R14, R10
	VPADDD   Y1, Y0, Y0
	ADDL     R15, CX
	ADDL     R15, R10
	ADDL     DI, R10
	VPSRLD   $0x0a, Y2, Y8
	MOVL     R10, DI
	RORXL    $0x19, CX, R13
	ADDL     72(SP)(SI*1), R9
	VPSRLQ   $0x13, Y2, Y3
	RORXL    $0x0b, CX, R14
	ORL      AX, DI
	MOVL     R8, R15
	XORL     DX, R15
	RORXL    $0x0d, R10, R12
	XORL     R14, R13
	VPSRLQ   $0x11, Y2, Y2
	ANDL     CX, R15
	RORXL    $0x06, CX, R14
	VPXOR    Y3, Y2, Y2
	ADDL     R9, BX
	ANDL     R11, DI
	XORL     R14, R13
	RORXL    $0x16, R10, R14
	VPXOR    Y2, Y8, Y8
	XORL     DX, R15
	VPSHUFB  shuff_00BA<>+0(SB), Y8, Y8
	XORL     R12, R14
	RORXL    $0x02, R10, R12
	VPADDD   Y8, Y0, Y0
	XORL     R12, R14
	MOVL     R10, R12
	ANDL     AX, R12
	ADDL     R13, R15
	VPSHUFD  $0x50, Y0, Y2
	ORL      R12, DI
	ADDL     R14, R9
	ADDL     R15, BX
	ADDL     R15, R9
	ADDL     DI, R9
	MOVL     R9, DI
	RORXL    $0x19, BX, R13
	RORXL    $0x0b, BX, R14
	ADDL     76(SP)(SI*1), DX
	ORL      R11, DI
	VPSRLD   $0x0a, Y2, Y11
	MOVL     CX, R15
	RORXL    $0x0d, R9, R12
	XORL     R14, R13
	XORL     R8, R15
	VPSRLQ   $0x13, Y2, Y3
	RORXL    $0x06, BX, R14
	ANDL     BX, R15
	ADDL     DX, AX
	ANDL     R10, DI
	VPSRLQ   $0x11, Y2, Y2
	XORL     R14, R13
	XORL     R8, R15
	VPXOR    Y3, Y2, Y2
	RORXL    $0x16, R9, R14
	ADDL     R13, R15
	VPXOR    Y2, Y11, Y11
	XORL     R12, R14
	ADDL     R15, AX
	RORXL    $0x02, R9, R12
	VPSHUFB  shuff_DC00<>+0(SB), Y11, Y11
	VPADDD   Y0, Y11, Y6
	XORL     R12, R14
	MOVL     R9, R12
	ANDL     R11, R12
	ORL      R12, DI
	ADDL     R14, DX
	ADDL     R15, DX
	ADDL     DI, DX

	// Do 4 rounds and scheduling
	VPADDD   96(BP)(SI*1), Y7, Y9
	VMOVDQU  Y9, 96(SP)(SI*1)
	MOVL     DX, DI
	RORXL    $0x19, AX, R13
	RORXL    $0x0b, AX, R14
	ADDL     96(SP)(SI*1), R8
	ORL      R10, DI
	VPALIGNR $0x04, Y5, Y6, Y0
	MOVL     BX, R15
	RORXL    $0x0d, DX, R12
	XORL     R14, R13
	XORL     CX, R15
	VPADDD   Y7, Y0, Y0
	RORXL    $0x06, AX, R14
	ANDL     AX, R15
	XORL     R14, R13
	RORXL    $0x16, DX, R14
	ADDL     R8, R11
	ANDL     R9, DI
	VPALIGNR $0x04, Y7, Y4, Y1
	XORL     R12, R14
	RORXL    $0x02, DX, R12
	XORL     CX, R15
	VPSRLD   $0x07, Y1, Y2
	XORL     R12, R14
	MOVL     DX, R12
	ANDL     R10, R12
	ADDL     R13, R15
	VPSLLD   $0x19, Y1, Y3
	ORL      R12, DI
	ADDL     R14, R8
	ADDL     R15, R11
	VPOR     Y2, Y3, Y3
	VPSRLD   $0x12, Y1, Y2
	ADDL     R15, R8
	ADDL     DI, R8
	MOVL     R8, DI
	RORXL    $0x19, R11, R13
	RORXL    $0x0b, R11, R14
	ADDL     100(SP)(SI*1), CX
	ORL      R9, DI
	VPSRLD   $0x03, Y1, Y8
	MOVL     AX, R15
	RORXL    $0x0d, R8, R12
	XORL     R14, R13
	XORL     BX, R15
	RORXL    $0x06, R11, R14
	XORL     R14, R13
	RORXL    $0x16, R8, R14
	ANDL     R11, R15
	ADDL     CX, R10
	VPSLLD   $0x0e, Y1, Y1
	ANDL     DX, DI
	XORL     R12, R14
	VPXOR    Y1, Y3, Y3
	RORXL    $0x02, R8, R12
	XORL     BX, R15
	VPXOR    Y2, Y3, Y3
	XORL     R12, R14
	MOVL     R8, R12
	ANDL     R9, R12
	ADDL     R13, R15
	VPXOR    Y8, Y3, Y1
	VPSHUFD  $0xfa, Y6, Y2
	ORL      R12, DI
	ADDL     R14, CX
	VPADDD   Y1, Y0, Y0
	ADDL     R15, R10
	ADDL     R15, CX
	ADDL     DI, CX
	VPSRLD   $0x0a, Y2, Y8
	MOVL     CX, DI
	RORXL    $0x19, R10, R13
	ADDL     104(SP)(SI*1), BX
	VPSRLQ   $0x13, Y2, Y3
	RORXL    $0x0b, R10, R14
	ORL      DX, DI
	MOVL     R11, R15
	XORL     AX, R15
	RORXL    $0x0d, CX, R12
	XORL     R14, R13
	VPSRLQ   $0x11, Y2, Y2
	ANDL     R10, R15
	RORXL    $0x06, R10, R14
	VPXOR    Y3, Y2, Y2
	ADDL     BX, R9
	ANDL     R8, DI
	XORL     R14, R13
	RORXL    $0x16, CX, R14
	VPXOR    Y2, Y8, Y8
	XORL     AX, R15
	VPSHUFB  shuff_00BA<>+0(SB), Y8, Y8
	XORL     R12, R14
	RORXL    $0x02, CX, R12
	VPADDD   Y8, Y0, Y0
	XORL     R12, R14
	MOVL     CX, R12
	ANDL     DX, R12
	ADDL     R13, R15
	VPSHUFD  $0x50, Y0, Y2
	ORL      R12, DI
	ADDL     R14, BX
	ADDL     R15, R9
	ADDL     R15, BX
	ADDL     DI, BX
	MOVL     BX, DI
	RORXL    $0x19, R9, R13
	RORXL    $0x0b, R9, R14
	ADDL     108(SP)(SI*1), AX
	ORL      R8, DI
	VPSRLD   $0x0a, Y2, Y11
	MOVL     R10, R15
	RORXL    $0x0d, BX, R12
	XORL     R14, R13
	XORL     R11, R15
	VPSRLQ   $0x13, Y2, Y3
	RORXL    $0x06, R9, R14
	ANDL     R9, R15
	ADDL     AX, DX
	ANDL     CX, DI
	VPSRLQ   $0x11, Y2, Y2
	XORL     R14, R13
	XORL     R11, R15
	VPXOR    Y3, Y2, Y2
	RORXL    $0x16, BX, R14
	ADDL     R13, R15
	VPXOR    Y2, Y11, Y11
	XORL     R12, R14
	ADDL     R15, DX
	RORXL    $0x02, BX, R12
	VPSHUFB  shuff_DC00<>+0(SB), Y11, Y11
	VPADDD   Y0, Y11, Y7
	XORL     R12, R14
	MOVL     BX, R12
	ANDL     R8, R12
	ORL      R12, DI
	ADDL     R14, AX
	ADDL     R15, AX
	ADDL     DI, AX
	ADDQ     $0x80, SI
	CMPQ     SI, $0x00000180
	JB       avx2_loop1

avx2_loop2:
	VPADDD  (BP)(SI*1), Y4, Y9
	VMOVDQU Y9, (SP)(SI*1)
	MOVL    R9, R15
	RORXL   $0x19, DX, R13
	RORXL   $0x0b, DX, R14
	XORL    R10, R15
	XORL    R14, R13
	RORXL   $0x06, DX, R14
	ANDL    DX, R15
	XORL    R14, R13
	RORXL   $0x0d, AX, R12
	XORL    R10, R15
	RORXL   $0x16, AX, R14
	MOVL    AX, DI
	XORL    R12, R14
	RORXL   $0x02, AX, R12
	ADDL    (SP)(SI*1), R11
	ORL     CX, DI
	XORL    R12, R14
	MOVL    AX, R12
	ANDL    BX, DI
	ANDL    CX, R12
	ADDL    R13, R15
	ADDL    R11, R8
	ORL     R12, DI
	ADDL    R14, R11
	ADDL    R15, R8
	ADDL    R15, R11
	MOVL    DX, R15
	RORXL   $0x19, R8, R13
	RORXL   $0x0b, R8, R14
	XORL    R9, R15
	XORL    R14, R13
	RORXL   $0x06, R8, R14
	ANDL    R8, R15
	ADDL    DI, R11
	XORL    R14, R13
	RORXL   $0x0d, R11, R12
	XORL    R9, R15
	RORXL   $0x16, R11, R14
	MOVL    R11, DI
	XORL    R12, R14
	RORXL   $0x02, R11, R12
	ADDL    4(SP)(SI*1), R10
	ORL     BX, DI
	XORL    R12, R14
	MOVL    R11, R12
	ANDL    AX, DI
	ANDL    BX, R12
	ADDL    R13, R15
	ADDL    R10, CX
	ORL     R12, DI
	ADDL    R14, R10
	ADDL    R15, CX
	ADDL    R15, R10
	MOVL    R8, R15
	RORXL   $0x19, CX, R13
	RORXL   $0x0b, CX, R14
	XORL    DX, R15
	XORL    R14, R13
	RORXL   $0x06, CX, R14
	ANDL    CX, R15
	ADDL    DI, R10
	XORL    R14, R13
	RORXL   $0x0d, R10, R12
	XORL    DX, R15
	RORXL   $0x16, R10, R14
	MOVL    R10, DI
	XORL    R12, R14
	RORXL   $0x02, R10, R12
	ADDL    8(SP)(SI*1), R9
	ORL     AX, DI
	XORL    R12, R14
	MOVL    R10, R12
	ANDL    R11, DI
	ANDL    AX, R12
	ADDL    R13, R15
	ADDL    R9, BX
	ORL     R12, DI
	ADDL    R14, R9
	ADDL    R15, BX
	ADDL    R15, R9
	MOVL    CX, R15
	RORXL   $0x19, BX, R13
	RORXL   $0x0b, BX, R14
	XORL    R8, R15
	XORL    R14, R13
	RORXL   $0x06, BX, R14
	ANDL    BX, R15
	ADDL    DI, R9
	XORL    R14, R13
	RORXL   $0x0d, R9, R12
	XORL    R8, R15
	RORXL   $0x16, R9, R14
	MOVL    R9, DI
	XORL    R12, R14
	RORXL   $0x02, R9, R12
	ADDL    12(SP)(SI*1), DX
	ORL     R11, DI
	XORL    R12, R14
	MOVL    R9, R12
	ANDL    R10, DI
	ANDL    R11, R12
	ADDL    R13, R15
	ADDL    DX, AX
	ORL     R12, DI
	ADDL    R14, DX
	ADDL    R15, AX
	ADDL    R15, DX
	ADDL    DI, DX
	VPADDD  32(BP)(SI*1), Y5, Y9
	VMOVDQU Y9, 32(SP)(SI*1)
	MOVL    BX, R15
	RORXL   $0x19, AX, R13
	RORXL   $0x0b, AX, R14
	XORL    CX, R15
	XORL    R14, R13
	RORXL   $0x06, AX, R14
	ANDL    AX, R15
	XORL    R14, R13
	RORXL   $0x0d, DX, R12
	XORL    CX, R15
	RORXL   $0x16, DX, R14
	MOVL    DX, DI
	XORL    R12, R14
	RORXL   $0x02, DX, R12
	ADDL    32(SP)(SI*1), R8
	ORL     R10, DI
	XORL    R12, R14
	MOVL    DX, R12
	ANDL    R9, DI
	ANDL    R10, R12
	ADDL    R13, R15
	ADDL    R8, R11
	ORL     R12, DI
	ADDL    R14, R8
	ADDL    R15, R11
	ADDL    R15, R8
	MOVL    AX, R15
	RORXL   $0x19, R11, R13
	RORXL   $0x0b, R11, R14
	XORL    BX, R15
	XORL    R14, R13
	RORXL   $0x06, R11, R14
	ANDL    R11, R15
	ADDL    DI, R8
	XORL    R14, R13
	RORXL   $0x0d, R8, R12
	XORL    BX, R15
	RORXL   $0x16, R8, R14
	MOVL    R8, DI
	XORL    R12, R14
	RORXL   $0x02, R8, R12
	ADDL    36(SP)(SI*1), CX
	ORL     R9, DI
	XORL    R12, R14
	MOVL    R8, R12
	ANDL    DX, DI
	ANDL    R9, R12
	ADDL    R13, R15
	ADDL    CX, R10
	ORL     R12, DI
	ADDL    R14, CX
	ADDL    R15, R10
	ADDL    R15, CX
	MOVL    R11, R15
	RORXL   $0x19, R10, R13
	RORXL   $0x0b, R10, R14
	XORL    AX, R15
	XORL    R14, R13
	RORXL   $0x06, R10, R14
	ANDL    R10, R15
	ADDL    DI, CX
	XORL    R14, R13
	RORXL   $0x0d, CX, R12
	XORL    AX, R15
	RORXL   $0x16, CX, R14
	MOVL    CX, DI
	XORL    R12, R14
	RORXL   $0x02, CX, R12
	ADDL    40(SP)(SI*1), BX
	ORL     DX, DI
	XORL    R12, R14
	MOVL    CX, R12
	ANDL    R8, DI
	ANDL    DX, R12
	ADDL    R13, R15
	ADDL    BX, R9
	ORL     R12, DI
	ADDL    R14, BX
	ADDL    R15, R9
	ADDL    R15, BX
	MOVL    R10, R15
	RORXL   $0x19, R9, R13
	RORXL   $0x0b, R9, R14
	XORL    R11, R15
	XORL    R14, R13
	RORXL   $0x06, R9, R14
	ANDL    R9, R15
	ADDL    DI, BX
	XORL    R14, R13
	RORXL   $0x0d, BX, R12
	XORL    R11, R15
	RORXL   $0x16, BX, R14
	MOVL    BX, DI
	XORL    R12, R14
	RORXL   $0x02, BX, R12
	ADDL    44(SP)(SI*1), AX
	ORL     R8, DI
	XORL    R12, R14
	MOVL    BX, R12
	ANDL    CX, DI
	ANDL    R8, R12
	ADDL    R13, R15
	ADDL    AX, DX
	ORL     R12, DI
	ADDL    R14, AX
	ADDL    R15, DX
	ADDL    R15, AX
	ADDL    DI, AX
	ADDQ    $0x40, SI
	VMOVDQU Y6, Y4
	VMOVDQU Y7, Y5
	CMPQ    SI, $0x00000200
	JB      avx2_loop2
	MOVQ    dig+0(FP), SI
	MOVQ    520(SP), DI
	ADDL    AX, (SI)
	MOVL    (SI), AX
	ADDL    BX, 4(SI)
	MOVL    4(SI), BX
	ADDL    CX, 8(SI)
	MOVL    8(SI), CX
	ADDL    R8, 12(SI)
	MOVL    12(SI), R8
	ADDL    DX, 16(SI)
	MOVL    16(SI), DX
	ADDL    R9, 20(SI)
	MOVL    20(SI), R9
	ADDL    R10, 24(SI)
	MOVL    24(SI), R10
	ADDL    R11, 28(SI)
	MOVL    28(SI), R11
	CMPQ    512(SP), DI
	JB      done_hash
	XORQ    SI, SI

avx2_loop3:
	MOVL  R9, R15
	RORXL $0x19, DX, R13
	RORXL $0x0b, DX, R14
	XORL  R10, R15
	XORL  R14, R13
	RORXL $0x06, DX, R14
	ANDL  DX, R15
	XORL  R14, R13
	RORXL $0x0d, AX, R12
	XORL  R10, R15
	RORXL $0x16, AX, R14
	MOVL  AX, DI
	XORL  R12, R14
	RORXL $0x02, AX, R12
	ADDL  16(SP)(SI*1), R11
	ORL   CX, DI
	XORL  R12, R14
	MOVL  AX, R12
	ANDL  BX, DI
	ANDL  CX, R12
	ADDL  R13, R15
	ADDL  R11, R8
	ORL   R12, DI
	ADDL  R14, R11
	ADDL  R15, R8
	ADDL  R15, R11
	MOVL  DX, R15
	RORXL $0x19, R8, R13
	RORXL $0x0b, R8, R14
	XORL  R9, R15
	XORL  R14, R13
	RORXL $0x06, R8, R14
	ANDL  R8, R15
	ADDL  DI, R11
	XORL  R14, R13
	RORXL $0x0d, R11, R12
	XORL  R9, R15
	RORXL $0x16, R11, R14
	MOVL  R11, DI
	XORL  R12, R14
	RORXL $0x02, R11, R12
	ADDL  20(SP)(SI*1), R10
	ORL   BX, DI
	XORL  R12, R14
	MOVL  R11, R12
	ANDL  AX, DI
	ANDL  BX, R12
	ADDL  R13, R15
	ADDL  R10, CX
	ORL   R12, DI
	ADDL  R14, R10
	ADDL  R15, CX
	ADDL  R15, R10
	MOVL  R8, R15
	RORXL $0x19, CX, R13
	RORXL $0x0b, CX, R14
	XORL  DX, R15
	XORL  R14, R13
	RORXL $0x06, CX, R14
	ANDL  CX, R15
	ADDL  DI, R10
	XORL  R14, R13
	RORXL $0x0d, R10, R12
	XORL  DX, R15
	RORXL $0x16, R10, R14
	MOVL  R10, DI
	XORL  R12, R14
	RORXL $0x02, R10, R12
	ADDL  24(SP)(SI*1), R9
	ORL   AX, DI
	XORL  R12, R14
	MOVL  R10, R12
	ANDL  R11, DI
	ANDL  AX, R12
	ADDL  R13, R15
	ADDL  R9, BX
	ORL   R12, DI
	ADDL  R14, R9
	ADDL  R15, BX
	ADDL  R15, R9
	MOVL  CX, R15
	RORXL $0x19, BX, R13
	RORXL $0x0b, BX, R14
	XORL  R8, R15
	XORL  R14, R13
	RORXL $0x06, BX, R14
	ANDL  BX, R15
	ADDL  DI, R9
	XORL  R14, R13
	RORXL $0x0d, R9, R12
	XORL  R8, R15
	RORXL $0x16, R9, R14
	MOVL  R9, DI
	XORL  R12, R14
	RORXL $0x02, R9, R12
	ADDL  28(SP)(SI*1), DX
	ORL   R11, DI
	XORL  R12, R14
	MOVL  R9, R12
	ANDL  R10, DI
	ANDL  R11, R12
	ADDL  R13, R15
	ADDL  DX, AX
	ORL   R12, DI
	ADDL  R14, DX
	ADDL  R15, AX
	ADDL  R15, DX
	ADDL  DI, DX
	MOVL  BX, R15
	RORXL $0x19, AX, R13
	RORXL $0x0b, AX, R14
	XORL  CX, R15
	XORL  R14, R13
	RORXL $0x06, AX, R14
	ANDL  AX, R15
	XORL  R14, R13
	RORXL $0x0d, DX, R12
	XORL  CX, R15
	RORXL $0x16, DX, R14
	MOVL  DX, DI
	XORL  R12, R14
	RORXL $0x02, DX, R12
	ADDL  48(SP)(SI*1), R8
	ORL   R10, DI
	XORL  R12, R14
	MOVL  DX, R12
	ANDL  R9, DI
	ANDL  R10, R12
	ADDL  R13, R15
	ADDL  R8, R11
	ORL   R12, DI
	ADDL  R14, R8
	ADDL  R15, R11
	ADDL  R15, R8
	MOVL  AX, R15
	RORXL $0x19, R11, R13
	RORXL $0x0b, R11, R14
	XORL  BX, R15
	XORL  R14, R13
	RORXL $0x06, R11, R14
	ANDL  R11, R15
	ADDL  DI, R8
	XORL  R14, R13
	RORXL $0x0d, R8, R12
	XORL  BX, R15
	RORXL $0x16, R8, R14
	MOVL  R8, DI
	XORL  R12, R14
	RORXL $0x02, R8, R12
	ADDL  52(SP)(SI*1), CX
	ORL   R9, DI
	XORL  R12, R14
	MOVL  R8, R12
	ANDL  DX, DI
	ANDL  R9, R12
	ADDL  R13, R15
	ADDL  CX, R10
	ORL   R12, DI
	ADDL  R14, CX
	ADDL  R15, R10
	ADDL  R15, CX
	MOVL  R11, R15
	RORXL $0x19, R10, R13
	RORXL $0x0b, R10, R14
	XORL  AX, R15
	XORL  R14, R13
	RORXL $0x06, R10, R14
	ANDL  R10, R15
	ADDL  DI, CX
	XORL  R14, R13
	RORXL $0x0d, CX, R12
	XORL  AX, R15
	RORXL $0x16, CX, R14
	MOVL  CX, DI
	XORL  R12, R14
	RORXL $0x02, CX, R12
	ADDL  56(SP)(SI*1), BX
	ORL   DX, DI
	XORL  R12, R14
	MOVL  CX, R12
	ANDL  R8, DI
	ANDL  DX, R12
	ADDL  R13, R15
	ADDL  BX, R9
	ORL   R12, DI
	ADDL  R14, BX
	ADDL  R15, R9
	ADDL  R15, BX
	MOVL  R10, R15
	RORXL $0x19, R9, R13
	RORXL $0x0b, R9, R14
	XORL  R11, R15
	XORL  R14, R13
	RORXL $0x06, R9, R14
	ANDL  R9, R15
	ADDL  DI, BX
	XORL  R14, R13
	RORXL $0x0d, BX, R12
	XORL  R11, R15
	RORXL $0x16, BX, R14
	MOVL  BX, DI
	XORL  R12, R14
	RORXL $0x02, BX, R12
	ADDL  60(SP)(SI*1), AX
	ORL   R8, DI
	XORL  R12, R14
	MOVL  BX, R12
	ANDL  CX, DI
	ANDL  R8, R12
	ADDL  R13, R15
	ADDL  AX, DX
	ORL   R12, DI
	ADDL  R14, AX
	ADDL  R15, DX
	ADDL  R15, AX
	ADDL  DI, AX
	ADDQ  $0x40, SI
	CMPQ  SI, $0x00000200
	JB    avx2_loop3
	MOVQ  dig+0(FP), SI
	MOVQ  520(SP), DI
	ADDQ  $0x40, DI
	ADDL  AX, (SI)
	MOVL  (SI), AX
	ADDL  BX, 4(SI)
	MOVL  4(SI), BX
	ADDL  CX, 8(SI)
	MOVL  8(SI), CX
	ADDL  R8, 12(SI)
	MOVL  12(SI), R8
	ADDL  DX, 16(SI)
	MOVL  16(SI), DX
	ADDL  R9, 20(SI)
	MOVL  20(SI), R9
	ADDL  R10, 24(SI)
	MOVL  24(SI), R10
	ADDL  R11, 28(SI)
	MOVL  28(SI), R11
	CMPQ  512(SP), DI
	JA    avx2_loop0
	JB    done_hash

avx2_do_last_block:
	VMOVDQU (DI), X4
	VMOVDQU 16(DI), X5
	VMOVDQU 32(DI), X6
	VMOVDQU 48(DI), X7
	VMOVDQU flip_mask<>+0(SB), Y13
	VPSHUFB X13, X4, X4
	VPSHUFB X13, X5, X5
	VPSHUFB X13, X6, X6
	VPSHUFB X13, X7, X7
	LEAQ    K256<>+0(SB), BP
	JMP     avx2_last_block_enter

avx2_only_one_block:
	MOVL (SI), AX
	MOVL 4(SI), BX
	MOVL 8(SI), CX
	MOVL 12(SI), R8
	MOVL 16(SI), DX
	MOVL 20(SI), R9
	MOVL 24(SI), R10
	MOVL 28(SI), R11
	JMP  avx2_do_last_block

done_hash:
	VZEROUPPER
	RET

DATA flip_mask<>+0(SB)/8, $0x0405060700010203
DATA flip_mask<>+8(SB)/8, $0x0c0d0e0f08090a0b
DATA flip_mask<>+16(SB)/8, $0x0405060700010203
DATA flip_mask<>+24(SB)/8, $0x0c0d0e0f08090a0b
GLOBL flip_mask<>(SB), RODATA, $32

DATA K256<>+0(SB)/4, $0x428a2f98
DATA K256<>+4(SB)/4, $0x71374491
DATA K256<>+8(SB)/4, $0xb5c0fbcf
DATA K256<>+12(SB)/4, $0xe9b5dba5
DATA K256<>+16(SB)/4, $0x428a2f98
DATA K256<>+20(SB)/4, $0x71374491
DATA K256<>+24(SB)/4, $0xb5c0fbcf
DATA K256<>+28(SB)/4, $0xe9b5dba5
DATA K256<>+32(SB)/4, $0x3956c25b
DATA K256<>+36(SB)/4, $0x59f111f1
DATA K256<>+40(SB)/4, $0x923f82a4
DATA K256<>+44(SB)/4, $0xab1c5ed5
DATA K256<>+48(SB)/4, $0x3956c25b
DATA K256<>+52(SB)/4, $0x59f111f1
DATA K256<>+56(SB)/4, $0x923f82a4
DATA K256<>+60(SB)/4, $0xab1c5ed5
DATA K256<>+64(SB)/4, $0xd807aa98
DATA K256<>+68(SB)/4, $0x12835b01
DATA K256<>+72(SB)/4, $0x243185be
DATA K256<>+76(SB)/4, $0x550c7dc3
DATA K256<>+80(SB)/4, $0xd807aa98
DATA K256<>+84(SB)/4, $0x12835b01
DATA K256<>+88(SB)/4, $0x243185be
DATA K256<>+92(SB)/4, $0x550c7dc3
DATA K256<>+96(SB)/4, $0x72be5d74
DATA K256<>+100(SB)/4, $0x80deb1fe
DATA K256<>+104(SB)/4, $0x9bdc06a7
DATA K256<>+108(SB)/4, $0xc19bf174
DATA K256<>+112(SB)/4, $0x72be5d74
DATA K256<>+116(SB)/4, $0x80deb1fe
DATA K256<>+120(SB)/4, $0x9bdc06a7
DATA K256<>+124(SB)/4, $0xc19bf174
DATA K256<>+128(SB)/4, $0xe49b69c1
DATA K256<>+132(SB)/4, $0xefbe4786
DATA K256<>+136(SB)/4, $0x0fc19dc6
DATA K256<>+140(SB)/4, $0x240ca1cc
DATA K256<>+144(SB)/4, $0xe49b69c1
DATA K256<>+148(SB)/4, $0xefbe4786
DATA K256<>+152(SB)/4, $0x0fc19dc6
DATA K256<>+156(SB)/4, $0x240ca1cc
DATA K256<>+160(SB)/4, $0x2de92c6f
DATA K256<>+164(SB)/4, $0x4a7484aa
DATA K256<>+168(SB)/4, $0x5cb0a9dc
DATA K256<>+172(SB)/4, $0x76f988da
DATA K256<>+176(SB)/4, $0x2de92c6f
DATA K256<>+180(SB)/4, $0x4a7484aa
DATA K256<>+184(SB)/4, $0x5cb0a9dc
DATA K256<>+188(SB)/4, $0x76f988da
DATA K256<>+192(SB)/4, $0x983e5152
DATA K256<>+196(SB)/4, $0xa831c66d
DATA K256<>+200(SB)/4, $0xb00327c8
DATA K256<>+204(SB)/4, $0xbf597fc7
DATA K256<>+208(SB)/4, $0x983e5152
DATA K256<>+212(SB)/4, $0xa831c66d
DATA K256<>+216(SB)/4, $0xb00327c8
DATA K256<>+220(SB)/4, $0xbf597fc7
DATA K256<>+224(SB)/4, $0xc6e00bf3
DATA K256<>+228(SB)/4, $0xd5a79147
DATA K256<>+232(SB)/4, $0x06ca6351
DATA K256<>+236(SB)/4, $0x14292967
DATA K256<>+240(SB)/4, $0xc6e00bf3
DATA K256<>+244(SB)/4, $0xd5a79147
DATA K256<>+248(SB)/4, $0x06ca6351
DATA K256<>+252(SB)/4, $0x14292967
DATA K256<>+256(SB)/4, $0x27b70a85
DATA K256<>+260(SB)/4, $0x2e1b2138
DATA K256<>+264(SB)/4, $0x4d2c6dfc
DATA K256<>+268(SB)/4, $0x53380d13
DATA K256<>+272(SB)/4, $0x27b70a85
DATA K256<>+276(SB)/4, $0x2e1b2138
DATA K256<>+280(SB)/4, $0x4d2c6dfc
DATA K256<>+284(SB)/4, $0x53380d13
DATA K256<>+288(SB)/4, $0x650a7354
DATA K256<>+292(SB)/4, $0x766a0abb
DATA K256<>+296(SB)/4, $0x81c2c92e
DATA K256<>+300(SB)/4, $0x92722c85
DATA K256<>+304(SB)/4, $0x650a7354
DATA K256<>+308(SB)/4, $0x766a0abb
DATA K256<>+312(SB)/4, $0x81c2c92e
DATA K256<>+316(SB)/4, $0x92722c85
DATA K256<>+320(SB)/4, $0xa2bfe8a1
DATA K256<>+324(SB)/4, $0xa81a664b
DATA K256<>+328(SB)/4, $0xc24b8b70
DATA K256<>+332(SB)/4, $0xc76c51a3
DATA K256<>+336(SB)/4, $0xa2bfe8a1
DATA K256<>+340(SB)/4, $0xa81a664b
DATA K256<>+344(SB)/4, $0xc24b8b70
DATA K256<>+348(SB)/4, $0xc76c51a3
DATA K256<>+352(SB)/4, $0xd192e819
DATA K256<>+356(SB)/4, $0xd6990624
DATA K256<>+360(SB)/4, $0xf40e3585
DATA K256<>+364(SB)/4, $0x106aa070
DATA K256<>+368(SB)/4, $0xd192e819
DATA K256<>+372(SB)/4, $0xd6990624
DATA K256<>+376(SB)/4, $0xf40e3585
DATA K256<>+380(SB)/4, $0x106aa070
DATA K256<>+384(SB)/4, $0x19a4c116
DATA K256<>+388(SB)/4, $0x1e376c08
DATA K256<>+392(SB)/4, $0x2748774c
DATA K256<>+396(SB)/4, $0x34b0bcb5
DATA K256<>+400(SB)/4, $0x19a4c116
DATA K256<>+404(SB)/4, $0x1e376c08
DATA K256<>+408(SB)/4, $0x2748774c
DATA K256<>+412(SB)/4, $0x34b0bcb5
DATA K256<>+416(SB)/4, $0x391c0cb3
DATA K256<>+420(SB)/4, $0x4ed8aa4a
DATA K256<>+424(SB)/4, $0x5b9cca4f
DATA K256<>+428(SB)/4, $0x682e6ff3
DATA K256<>+432(SB)/4, $0x391c0cb3
DATA K256<>+436(SB)/4, $0x4ed8aa4a
DATA K256<>+440(SB)/4, $0x5b9cca4f
DATA K256<>+444(SB)/4, $0x682e6ff3
DATA K256<>+448(SB)/4, $0x748f82ee
DATA K256<>+452(SB)/4, $0x78a5636f
DATA K256<>+456(SB)/4, $0x84c87814
DATA K256<>+460(SB)/4, $0x8cc70208
DATA K256<>+464(SB)/4, $0x748f82ee
DATA K256<>+468(SB)/4, $0x78a5636f
DATA K256<>+472(SB)/4, $0x84c87814
DATA K256<>+476(SB)/4, $0x8cc70208
DATA K256<>+480(SB)/4, $0x90befffa
DATA K256<>+484(SB)/4, $0xa4506ceb
DATA K256<>+488(SB)/4, $0xbef9a3f7
DATA K256<>+492(SB)/4, $0xc67178f2
DATA K256<>+496(SB)/4, $0x90befffa
DATA K256<>+500(SB)/4, $0xa4506ceb
DATA K256<>+504(SB)/4, $0xbef9a3f7
DATA K256<>+508(SB)/4, $0xc67178f2
GLOBL K256<>(SB), RODATA|NOPTR, $512

DATA shuff_00BA<>+0(SB)/8, $0x0b0a090803020100
DATA shuff_00BA<>+8(SB)/8, $0xffffffffffffffff
DATA shuff_00BA<>+16(SB)/8, $0x0b0a090803020100
DATA shuff_00BA<>+24(SB)/8, $0xffffffffffffffff
GLOBL shuff_00BA<>(SB), RODATA, $32

DATA shuff_DC00<>+0(SB)/8, $0xffffffffffffffff
DATA shuff_DC00<>+8(SB)/8, $0x0b0a090803020100
DATA shuff_DC00<>+16(SB)/8, $0xffffffffffffffff
DATA shuff_DC00<>+24(SB)/8, $0x0b0a090803020100
GLOBL shuff_DC00<>(SB), RODATA, $32

// func blockSHANI(dig *Digest, p []byte)
// Requires: AVX, SHA, SSE2, SSE4.1, SSSE3
TEXT ·blockSHANI(SB), $0-32
	MOVQ    dig+0(FP), DI
	MOVQ    p_base+8(FP), SI
	MOVQ    p_len+16(FP), DX
	SHRQ    $0x06, DX
	SHLQ    $0x06, DX
	CMPQ    DX, $0x00
	JEQ     done
	ADDQ    SI, DX
	VMOVDQU (DI), X1
	VMOVDQU 16(DI), X2
	PSHUFD  $0xb1, X1, X1
	PSHUFD  $0x1b, X2, X2
	VMOVDQA X1, X7
	PALIGNR $0x08, X2, X1
	PBLENDW $0xf0, X7, X2
	VMOVDQA flip_mask<>+0(SB), X8
	LEAQ    K256<>+0(SB), AX

roundLoop:
	// save hash values for addition after rounds
	VMOVDQA X1, X9
	VMOVDQA X2, X10

	// do rounds 0-59
	VMOVDQU     (SI), X0
	PSHUFB      X8, X0
	VMOVDQA     X0, X3
	PADDD       (AX), X0
	SHA256RNDS2 X0, X1, X2
	PSHUFD      $0x0e, X0, X0
	SHA256RNDS2 X0, X2, X1
	VMOVDQU     16(SI), X0
	PSHUFB      X8, X0
	VMOVDQA     X0, X4
	PADDD       32(AX), X0
	SHA256RNDS2 X0, X1, X2
	PSHUFD      $0x0e, X0, X0
	SHA256RNDS2 X0, X2, X1
	SHA256MSG1  X4, X3
	VMOVDQU     32(SI), X0
	PSHUFB      X8, X0
	VMOVDQA     X0, X5
	PADDD       64(AX), X0
	SHA256RNDS2 X0, X1, X2
	PSHUFD      $0x0e, X0, X0
	SHA256RNDS2 X0, X2, X1
	SHA256MSG1  X5, X4
	VMOVDQU     48(SI), X0
	PSHUFB      X8, X0
	VMOVDQA     X0, X6
	PADDD       96(AX), X0
	SHA256RNDS2 X0, X1, X2
	VMOVDQA     X6, X7
	PALIGNR     $0x04, X5, X7
	PADDD       X7, X3
	SHA256MSG2  X6, X3
	PSHUFD      $0x0e, X0, X0
	SHA256RNDS2 X0, X2, X1
	SHA256MSG1  X6, X5
	VMOVDQA     X3, X0
	PADDD       128(AX), X0
	SHA256RNDS2 X0, X1, X2
	VMOVDQA     X3, X7
	PALIGNR     $0x04, X6, X7
	PADDD       X7, X4
	SHA256MSG2  X3, X4
	PSHUFD      $0x0e, X0, X0
	SHA256RNDS2 X0, X2, X1
	SHA256MSG1  X3, X6
	VMOVDQA     X4, X0
	PADDD       160(AX), X0
	SHA256RNDS2 X0, X1, X2
	VMOVDQA     X4, X7
	PALIGNR     $0x04, X3, X7
	PADDD       X7, X5
	SHA256MSG2  X4, X5
	PSHUFD      $0x0e, X0, X0
	SHA256RNDS2 X0, X2, X1
	SHA256MSG1  X4, X3
	VMOVDQA     X5, X0
	PADDD       192(AX), X0
	SHA256RNDS2 X0, X1, X2
	VMOVDQA     X5, X7
	PALIGNR     $0x04, X4, X7
	PADDD       X7, X6
	SHA256MSG2  X5, X6
	PSHUFD      $0x0e, X0, X0
	SHA256RNDS2 X0, X2, X1
	SHA256MSG1  X5, X4
	VMOVDQA     X6, X0
	PADDD       224(AX), X0
	SHA256RNDS2 X0, X1, X2
	VMOVDQA     X6, X7
	PALIGNR     $0x04, X5, X7
	PADDD       X7, X3
	SHA256MSG2  X6, X3
	PSHUFD      $0x0e, X0, X0
	SHA256RNDS2 X0, X2, X1
	SHA256MSG1  X6, X5
	VMOVDQA     X3, X0
	PADDD       256(AX), X0
	SHA256RNDS2 X0, X1, X2
	VMOVDQA     X3, X7
	PALIGNR     $0x04, X6, X7
	PADDD       X7, X4
	SHA256MSG2  X3, X4
	PSHUFD      $0x0e, X0, X0
	SHA256RNDS2 X0, X2, X1
	SHA256MSG1  X3, X6
	VMOVDQA     X4, X0
	PADDD       288(AX), X0
	SHA256RNDS2 X0, X1, X2
	VMOVDQA     X4, X7
	PALIGNR     $0x04, X3, X7
	PADDD       X7, X5
	SHA256MSG2  X4, X5
	PSHUFD      $0x0e, X0, X0
	SHA256RNDS2 X0, X2, X1
	SHA256MSG1  X4, X3
	VMOVDQA     X5, X0
	PADDD       320(AX), X0
	SHA256RNDS2 X0, X1, X2
	VMOVDQA     X5, X7
	PALIGNR     $0x04, X4, X7
	PADDD       X7, X6
	SHA256MSG2  X5, X6
	PSHUFD      $0x0e, X0, X0
	SHA256RNDS2 X0, X2, X1
	SHA256MSG1  X5, X4
	VMOVDQA     X6, X0
	PADDD       352(AX), X0
	SHA256RNDS2 X0, X1, X2
	VMOVDQA     X6, X7
	PALIGNR     $0x04, X5, X7
	PADDD       X7, X3
	SHA256MSG2  X6, X3
	PSHUFD      $0x0e, X0, X0
	SHA256RNDS2 X0, X2, X1
	SHA256MSG1  X6, X5
	VMOVDQA     X3, X0
	PADDD       384(AX), X0
	SHA256RNDS2 X0, X1, X2
	VMOVDQA     X3, X7
	PALIGNR     $0x04, X6, X7
	PADDD       X7, X4
	SHA256MSG2  X3, X4
	PSHUFD      $0x0e, X0, X0
	SHA256RNDS2 X0, X2, X1
	SHA256MSG1  X3, X6
	VMOVDQA     X4, X0
	PADDD       416(AX), X0
	SHA256RNDS2 X0, X1, X2
	VMOVDQA     X4, X7
	PALIGNR     $0x04, X3, X7
	PADDD       X7, X5
	SHA256MSG2  X4, X5
	PSHUFD      $0x0e, X0, X0
	SHA256RNDS2 X0, X2, X1
	VMOVDQA     X5, X0
	PADDD       448(AX), X0
	SHA256RNDS2 X0, X1, X2
	VMOVDQA     X5, X7
	PALIGNR     $0x04, X4, X7
	PADDD       X7, X6
	SHA256MSG2  X5, X6
	PSHUFD      $0x0e, X0, X0
	SHA256RNDS2 X0, X2, X1

	// do rounds 60-63
	VMOVDQA     X6, X0
	PADDD       480(AX), X0
	SHA256RNDS2 X0, X1, X2
	PSHUFD      $0x0e, X0, X0
	SHA256RNDS2 X0, X2, X1

	// add current hash values with previously saved
	PADDD X9, X1
	PADDD X10, X2

	// advance data pointer; loop until buffer empty
	ADDQ $0x40, SI
	CMPQ DX, SI
	JNE  roundLoop

	// write hash values back in the correct order
	PSHUFD  $0x1b, X1, X1
	PSHUFD  $0xb1, X2, X2
	VMOVDQA X1, X7
	PBLENDW $0xf0, X2, X1
	PALIGNR $0x08, X7, X2
	VMOVDQU X1, (DI)
	VMOVDQU X2, 16(DI)

done:
	RET
