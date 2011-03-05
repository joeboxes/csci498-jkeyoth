import os

os.system("git status --porcelain > porc.out")

porc = open("porc.out")

lines = []

for l in porc:
	if l.count(" D ") > 0:
		lines.append(l.split()[1])
		
print lines