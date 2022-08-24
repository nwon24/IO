#!/usr/bin/env python3

f_in = open("cavalryin.txt", "r");
f_out = open("cavalryout.txt", "w");

answer = None
knights = []
N = int(f_in.readline())
for i in range(N):
    knights.append(int(f_in.readline()))

groups = {}
for i in knights:
    if i not in groups:
        groups[i] = 1
    else:
        groups[i] += 1

answer = "YES"
for i in groups:
    if groups[i] % i != 0:
        answer = "NO"

f_out.write("{}\n".format(answer))
