#!/bin/bash

mkdir -p benchmarks/results/

for xml in $(ls benchmarks/*.xml | grep -v Dengue997_s3_codon_hmc)
do
       ./benchmark.sh $xml 1 2
done

# Denuge requires 2 GPUs due to memory constraints
./benchmark.sh benchmarks/Dengue997_s3_codon_hmc.xml 2 2,3
