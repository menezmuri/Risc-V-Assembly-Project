# Fibonacci em RISC-V

Arquivos incluídos:
- `fibonacci_iter.s` — implementação iterativa (RARS-style syscalls)
- `fibonacci_rec.s` — implementação recursiva (usa pilha)
 - `rars.jar` — versão do simulador RARS incluída nesta pasta (use `java -jar rars.jar`)

Como executar

- Usando o RARS (recomendado para este projeto):
	1. A pasta do projeto já contém uma cópia do RARS em `rars.jar` — você pode rodá-lo com Java.
	2. Abra o RARS ou execute diretamente (PowerShell):

```powershell
java -jar rars.jar fibonacci_iter.s
```

	3. No RARS escolha `RV32I` (ou a configuração padrão que suporte syscalls do RARS), clique em "Assemble & Run" e digite um inteiro quando o prompt aparecer.

- Usando o toolchain GNU + simuladores (`spike` / `qemu`):
	- Se você tem o toolchain RISC-V instalado, pode montar e linkar os arquivos `.s` usando `riscv64-unknown-elf-as` / `gcc` / `ld`. Exemplo:

```powershell
# Assembler + link (bare-metal)
riscv64-unknown-elf-as -march=rv32i -o fib.o fibonacci_iter.s
riscv64-unknown-elf-ld -o fib.elf fib.o

# Usando gcc + linker script (recomendado quando tiver linker.ld):
riscv64-unknown-elf-gcc -march=rv32i -mabi=ilp32 -nostdlib -nostartfiles -T linker.ld -o fib.elf fibonacci_iter.s

# Executar em Spike com proxy-kernel 'pk':
spike pk fib.elf

# Ou em QEMU (rv32 example):
qemu-system-riscv32 -nographic -machine sifive_u -kernel fib.elf
```

Observações importantes
- As syscalls em `fibonacci_iter.s` e `fibonacci_rec.s` usam a convenção do RARS (usando `ecall` com números em `a7`). Exemplos RARS:
	- `a7 = 4` : print_string
	- `a7 = 5` : read_int
	- `a7 = 1` : print_int
	- `a7 = 10`: exit

- Se você compilar o código com o toolchain GNU e executar em `spike`/`qemu` com `pk` (proxy-kernel) ou em Linux, esses números de syscall NÃO correspondem às mesmas rotinas — você precisará adaptar as chamadas syscalls (ou usar código C com `printf/scanf`).

- `fibonacci_rec.s` cresce exponencialmente em tempo para entradas grandes; use limites baixos (ex.: n <= 20).

Se quiser que eu:
- adicione um `linker.ld` mínimo e atualize o script `run_fib.ps1` para montar/linkar/rodar automaticamente, responda "sim".

