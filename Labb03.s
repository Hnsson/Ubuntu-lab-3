.data
  null:          .byte 0x00
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
    xor %r14, %r14
  inGetLen:
    incq %r14
    incq %rdi
    movb (%rdi), %r12b
    cmpb %r12b, null
    jne inGetLen
    
    decq %r14
    movq %r14, end_ptr
    movq $0, inBuff_ptr

    ret
  getInt:
    call checkInBuffSize
    xor %rsi, %rsi
    xor %r15, %r15

    movq end_ptr, %rbx

    leaq inBuff, %r12
    addq inBuff_ptr, %r12
    jmp getIntLoop
  getIntAddNegSymbol:
    movq	$'-',%rdi
    call	putChar
    jmp getIntBegining
  getIntAddSymbol:
    cmpq $1, %rsi
    je getIntAddNegSymbol
    movq	$'+',%rdi
    call	putChar
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
    // Return after first number
    //je getIntBegining
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
  #  jmp getIntBegining
    jmp getIntAddSymbol
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
    leaq outBuff, %rsi

    pushq %rsi
    movb $0x0, %r10b
    addq outBuff_ptr, %rsi
    movb %r10b, (%rsi)
    popq %rsi

    movq (outBuff_ptr), %rdx   # message length
    movq $outBuff, %rsi        # message
    movq $1, %rdi              # stdout
    movq $1, %rax              # sys_write????
    syscall                    # call kernel

    movq $0, outBuff_ptr
    movq outBuff_ptr, %rsi
    addq outBuff_ptr, %rsi

    ret
  putInt:
    // %rdi -> n
    xor %r14, %r14 # Counter
    xor %r15, %r15 # Maybe not necessary
    xor %rsi, %rsi # Negative ?
    leaq outBuff, %r15
    addq outBuff_ptr, %r15
    movq $10, %rcx
    movq %rdi, %rax


    cmpq $0, %rdi
    jge putIntLoop
    // Number is negative
    incq %rsi
    negq %rdi
    xor %rax, %rax
    movq %rdi, %rax
  putIntLoop:
    // Separating the individual numbers
    xor %rdx, %rdx
    divq %rcx
    pushq %rdx
    incq %r14
    cmpq $0, %rax # Everything is seperated
    je putIntCheckSign
    jmp putIntLoop

  putIntCheckSign:
    cmpq $0, %rsi
    je putIntAssemble
    movb $'-', (%r15)
    incq %r15
    incq outBuff_ptr
  putIntAssemble:
    xor %rdx, %rdx
    cmpq $0, %r14   # Is counter 0?
    je putIntEnd
    popq %rdx
    addb $48, %dl
    movb %dl, (%r15) # Add char to buffer
    incq %r15 # Next pos
    incq outBuff_ptr # Next pos
    decq %r14 # Go backwards in counter because of stack appliance
    jmp putIntAssemble
  putIntEnd:
    ret

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
  checkBuffSizeImage:
    call inImage
  checkInBuffSize:
    cmpq $0, inBuff_ptr
    jz checkBuffSizeImage
    movq end_ptr, %r10
    cmpq %r10, inBuff_ptr
    jz checkBuffSizeImage
    ret
