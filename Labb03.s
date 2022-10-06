.data
  inBuff:     .asciz "################################################################"
  inBuff_ptr  .quad
  
  outBuff:    .asciz "################################################################"
  outBuff_ptr .quad

.text
.global inImage, getInt, getText, getChar, getInPos, setInPos, outImage, putInt, putText, putChar, getOutPos, setOutPos
  // Inmatning
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
    //
  putInt:
    //
  putText:
    leaq outBuff, %rdi
    addq outBuff_ptr, %rdi
  putTextLoop:
    inc %rdi
    
    incr $outBuff_ptr
    call checkBuffSize
    
    cmpq (%rdi), $0
    jne putTextLoop
    
    ret
  putChar:
    //
  getOutPos:
    //
  setOutPos:
    //
  checkBuffSize:
    cmpq $63, $outBuff_ptr
    jge outImage
    
    ret
 
