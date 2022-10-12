.data
  nul:          .byte 0x00
  end_ptr:      .quad 0

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
    movq %r14, end_ptr
    movq $0, inBuff_ptr

    ret
  getInt:
    call checkInBuffSize
    xor %rsi, %rsi

    leaq inBuff, %r12
    addq inBuff_ptr, %r12
    jmp getIntLoop
  getIntBegining:
    incq %r12
    incq inBuff_ptr
  getIntLoop:
    movb (%r12), %dl
    
    cmpb $'+', %dl
    je getIntBegining

    cmpb $'-', %dl
    je getIntNeg

    cmpb $' ', %dl
    // Concatenate ALL numbers
    //je getIntNotInt
    // Like Adam
    je getIntBegining
    
    cmpb $'0', %dl
    jl getIntDone
    cmpb $'9', %dl 
    jg getIntDone
    // Add to buffer
    imulq $10, %r15
    subb $48, %dl
    addb %dl, %r15b

    jmp getIntBegining
    //
  getIntNeg:
    movq $1, %rsi
    jmp getIntBegining
  getIntMakeNeg:
    negq %r15
    movq $0, %rsi
  getIntDone:
    cmpq $1, %rsi
    je getIntMakeNeg
    movq %r15, %rax
    ret

  getText:
    // %rsi -> längd
    // %rdi -> buf
    leaq inBuff, %r11

  getTextLoop:
  getTextDone:
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
    // %rdi -> n
    xor %r14, %r14
    xor %r15, %r15
    xor %rsi, %rsi
    leaq outBuff, %r15
    addq outBuff_ptr, %r15

    cmpq $0, %rdi
    jge putIntLoop
    movq

  putIntLoop:




  putText:
    leaq outBuff, %r10
    addq outBuff_ptr, %r10
    movb (%rdi), %dl
  putTextLoop:
    movb %dl, (%r10)
    incq %rdi
    incq %r10
    incq outBuff_ptr
    call checkOutBuffSize
    movb (%rdi), %dl
    cmpb %dl, nul
    jne putTextLoop
    ret
  putChar:
    call checkOutBuffSize
    leaq outBuff, %rdx
    addq outBuff_ptr, %rdx
    movq %rdi, (%rdx)
    incq outBuff_ptr
    ret
  getOutPos:
    movq outBuff_ptr, %rax
    ret
  setOutPos:
    cmpq $0, %rdi
    jle setOutPosZ
    cmpq $63, %rdi
    jge setOutPosM
    movq %rdi, outBuff_ptr
    ret
  setOutPosM:
    movq $63, outBuff_ptr
    ret
  setOutPosZ:
    movq $0, outBuff_ptr
    ret
  checkOutBuffSize:
    cmpq $63, outBuff_ptr
    jge outImage
    ret
  checkInBuffSize:
    movq end_ptr, %r10
    cmpq %r10, inBuff_ptr
    jz checkBuffSizeImage
    ret
  checkBuffSizeImage:
    call inImage
