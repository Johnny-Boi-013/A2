# A terminal calculator
#
# Reads a line of input, interprets it as a simple arithmetic expression,
# and prints the result. The input format is
# <long_integer> <operation> <long_integer>

# Make `main` accessible outside of this module
.global main

# Start of the code section
.text

main:
  # Function prologue
  enter $0, $0

  # Use scanf to retrieve and process a line of input
  # This block implements the following line of C code: 
  #   scanf("%ld %c %ld", &a, &op, &b);
  # Take a look at the man page for scanf and ask questions. You can also look 
  # at scanf_example.c
  movq $scanf_fmt, %rdi
  movq $a, %rsi
  movq $op, %rdx
  movq $b, %rcx
  xorb %al, %al
  call scanf

  movb op, %cl
  movq a, %rax

  cmpb $43, %cl
  je add
  cmpb $45, %cl
  je subtract
  cmpb $42, %cl
  je multiply
  cmpb $47, %cl
  je divide
  jmp error_unknown

  add:
    addq b, %rax
    jmp print

  subtract:
    subq b, %rax
    jmp print

  multiply:
    imulq b, %rax
    jmp print

  divide:
    cmpq $0, b
    je error_zero

    cqto
    idivq b
    jmp print

  print:
    movq %rax, %rsi
    movq $output_fmt, %rdi
    xorb %al, %al
    call printf
    movq $0, %rax
    jmp return

  error_unknown:
    movq $error_unknown_message, %rdi
    xorb %al, %al
    call printf
    movq $1, %rax
    jmp return

  error_zero:
    movq $error_divide_by_zero, %rdi
    xorb %al, %al
    call printf
    movq $1, %rax
    jmp return

  return:
    leave
    ret

  # if (op_char == '+') {
  #   ...
  # }
  # else if (op_char == '-') {
  #  ...
  # }
  # ...
  # else {
  #   // print error
  #   // return 1 from main
  # }

# Start of the data section
.data

output_fmt: 
  .asciz "%ld\n"
scanf_fmt: 
  .asciz "%ld %c %ld"
error_unknown_message:
  .asciz "Unknown operation\n"
error_divide_by_zero:
  .asciz "Can't divide by zero\n"

# "Slots" for scanf
a:  .quad 0
b:  .quad 0
op: .byte 0

