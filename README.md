# AVX instructions in NASM x64
### Introduction
In this example we will follow the use of AVX instructions in the NASM x64 language. The concrete example involves performing the operation `D = s * A + B. * C` where:

- **s** - is a scalar
- 3 vectors, **A**, **B** and **C**, and their size, **n** (must be the same for all vectors)
- where `. *` is the element-by-element multiplication of 2 vectors(`[1, 2, 3] .* [4, 5, 6] = [1 * 4, 2 * 5, 3 * 6] = [4, 10, 18]`).
- **D** is the final vector of dimension **n**, allocated in the **main**, in which the result of the operation will be stored

The function in asm has the following header:
`void vectorial_ops(int s, int A[], int B[], int C[], int n, int D[])`

### Remarks
- To use the AVX instructions they must be supported by the processor, check with `cat /proc/cpuinfo`.
- It is guaranteed that ** n ** is a multiple of 16.
- The vectors size (**n**) must be guaranteed a multiple of 16

### Running and testing
- `./check.sh` - will run all tests from `tests/in` will write the output to `tests/out` and will compare the results with `tests/ref`
- `make && ./checker < tests/in/$(test_nr).in`  will send the input from the test file and display it on  `stdout`
- You can also create a custom input file, in which on the first line will be the size of the vectors **n**, on the second line will be the scalar **s**, the next line the vector **A** with **n** elements, the next line the vector **B** with **n** elements and the last line vector **C** with **n** elements. And running as in the previous step, the only difference is that we will send the created file to the executable

### Details about implementation

I reserve on the stack space for each parameter. In this task I worked with **AVX** instructions, and the registers required for operations with such instructions allow simultaneous operation with `8 dword integers`. Because of this, at first I find out how many such operations I will do by dividing `n` by 8. Next, I save `rax` (the number of iterations), to do the multiplication that will tell me which group of 8 integers from the received vectors as a parameter I process now. After that, populate the register `ymm0` with 8 integers equal to `s`. In `rdx` I will save the address to the beginning of the group of 8 integers that I process at the current step. I multiply `s * A.` Next, I will do the same with the groups of 8 integers from B and C. Finally, I make a sum between `s * A` and `B .* C`. In `ymm2` the vector with the 8 final integers will be saved after all processing, which will place them in the required position in `D`.

- `vbroadcastss` - populated `ymm0` with my scalar `s`
- `vmovdqu` - in `ymm1` I place my address towards the beginning of the group of 8 necessary integers
- `vpmulld` - it multiplied between the second and the third operand, and the result places it in the first
- `vpaddd` - similar to `vpmulld`, only it does addition