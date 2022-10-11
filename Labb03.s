.data
  nul:          .byte 0x00

  inBuff:    	  .space 64
  inBuff_ptr: 	.quad  0
  
  outBuff:    	.space 64
  outBuff_ptr:	.quad  0

.text
.global inImage, getInt, getText, getChar, getInPos, setInPos, outImage, putInt, putText, putChar, getOutPos, setOutPos
/*-------------- Inmatning --------------*/
  inImage:
    movq $inBuff, %rdi
    movq $64, %rsi
    movq stdin, %rdx
    call fgets
    leaq inBuff, %rdi
  inGetLen:
    incq %r14
    incq %rdi
    movq (%rdi), %r12
    cmpq $0x0, %r12
    jne inGetLen
    
    decq %r14
    movq %r14, inBuff_ptr

    ret
  getInt:
    xor %r11, %r11
    leaq inBuff, %r12
  getIntLoop:
    movb (%r12), %dl
    incq %r12

    cmpb $48, %dl
    jl getIntNotInt
    cmpb $57, %dl 
    jg getIntNotInt
    // Add to buffer
    movb %dl, %r15b
    subb $48, %r15b
    //
  getIntNotInt:
    movq inBuff_ptr, %r14
    inc %r11
    cmpq inBuff_ptr, %r11
    jge getIntDone
    jmp getIntLoop
    // 48 - 57
  getIntDone:
    ret
  getText:
    //
  getChar:
    //
  getInPos:
    //
  setInPos:
    //
/*-------------- Utmatning --------------*/
  outImage:
    movq (outBuff_ptr), %rdx   # message length
    movq $outBuff, %rsi        # message
    movq $1, %rdi              # stdout
    movq $1, %rax              # sys_write????
    syscall                    # call kernel

    movq $0, outBuff_ptr
    movq outBuff_ptr, %r14

    ret
  putInt:
    //
  putText:
    leaq outBuff, %r10
    addq outBuff_ptr, %r10
    movb (%rdi), %dl
  putTextLoop:
    movb %dl, (%r10)
    incq %rdi
    incq %r10
    incq outBuff_ptr
    call checkBuffSize
    movb (%rdi), %dl
    cmpb %dl, nul
    jne putTextLoop
    ret
  putChar:
    //
  getOutPos:
    //
  setOutPos:
    //
  checkBuffSize:
    cmpq $63, outBuff_ptr
    jge outImage
    ret
 
