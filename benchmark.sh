#!/bin/bash

xml=$1
gpuinstances=$2
gpu=$3

n=$(basename $xml)
maxcpu=$(nproc --all)

for cpus in 1 2 4 8 16 32 96
do
    if (( cpus <= maxcpu )); then
	echo "Benchmarking ${xml} with ${cpus} threads ... "
    	java -jar /root/beast-mcmc/build/dist/beast.jar -seed 112358 -beagle_instances $cpus -beagle_CPU -overwrite $xml > benchmarks/results/${n/.xml/_cpu}_${cpus}.txt 2>&1
    else 
        echo "System has only ${maxcpu} cores available. Skipping benchmark using ${cpus} threads ... "
    fi
done

echo "Benchmarking ${xml} on GPU ... "
java -jar /root/beast-mcmc/build/dist/beast.jar -seed 112358 -beagle_GPU -beagle_order $gpu -beagle_instances $gpuinstances -overwrite $xml > benchmarks/results/${n/.xml/_gpu.txt} 2>&1