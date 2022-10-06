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
    //
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
    // Right parameters, but syscall not printing

    movq (outBuff_ptr), %rdx  # message length
    movq outBuff, %rcx        # message
    movq $1, %rbx             # stdout
    movq $4, %rax             # sys_write
    syscall                   # call kernel

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
 
