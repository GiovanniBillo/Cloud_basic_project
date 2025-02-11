#!/bin/bash

RESULT_FILE="/shared/results/sysbench_test_results.txt"
chmod 777 /shared/results/*.txt
echo "🔥 Distributed CPU Performance Test Results" > $RESULT_FILE
echo "------------------------------------------" >> $RESULT_FILE

HOSTLIST="worker1:2,worker2:2"
# Run sysbench across all nodes using MPI
echo "⚙️ Running MPI Sysbench CPU test across all nodes..."
mpirun --host $HOSTLIST -np 2 sysbench cpu run --cpu-max-prime=20000 --threads=2 2>&1 | tee -a $RESULT_FILE

echo "⚙️ Running MPI Sysbench memory test across all nodes..."
mpirun --host $HOSTLIST -np 2 sysbench memory run 2>&1 | tee -a $RESULT_FILE

echo "✅ Distributed CPU test completed! Results saved in $RESULT_FILE"

##!/bin/bash

## File to store results
#RESULT_FILE="/shared/results/cpu_test_results.txt"
#echo "🔥 CPU Performance Test Results" > $RESULT_FILE
#echo "------------------------------" >> $RESULT_FILE

#echo "⚙️ Running Sysbench CPU test..."
#sysbench cpu run --cpu-max-prime=20000 --threads=2 | tee -a $RESULT_FILE

#echo "⚙️ Running Stress-ng CPU test..."
#stress-ng --cpu 2 --timeout 60s --metrics-brief | tee -a $RESULT_FILE

#echo "⚙️ Running HPCC Benchmark..."
#hpcc | tee -a $RESULT_FILE

#echo "✅ CPU tests completed! Results saved in $RESULT_FILE"

