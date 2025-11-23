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

Observações importantes
- As syscalls em `fibonacci_iter.s` e `fibonacci_rec.s` usam a convenção do RARS (usando `ecall` com números em `a7`). Exemplos RARS:
	- `a7 = 4` : print_string
	- `a7 = 5` : read_int
	- `a7 = 1` : print_int
	- `a7 = 10`: exit


