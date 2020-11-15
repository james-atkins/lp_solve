echo %1 >>solve.txt
lp_solve -mps -S1 -timeout 60 %1 >>solve.txt
