#!/bin/bash

# ✅ Define result file
RESULT_FILE="/shared/results/system_test_results.txt"
chmod 777 /shared/results/*.txt
echo "🔧 Distributed System Performance Test Results" > $RESULT_FILE
echo "--------------------------------------------" >> $RESULT_FILE

# ✅ Ensure a writable temporary directory
TMP_DIR="/shared/tmp"
mkdir -p $TMP_DIR
chmod 777 $TMP_DIR

# ✅ Run memory stress test across all nodes, explicitly setting TMPDIR and --temp-path
echo "⚡ Running distributed memory test..."
mpirun --host 192.168.0.1:2,192.168.0.2:2,192.168.0.4:2 -np 5 env TMPDIR=$TMP_DIR stress-ng --vm 2 --vm-bytes 512M --timeout 60s --metrics-brief --temp-path $TMP_DIR 2>&1 | tee -a $RESULT_FILE

echo "⚡ Running disk test..."
mpirun --host 192.168.0.1:2,192.168.0.2:2,192.168.0.4:2 -np 5 env TMPDIR=$TMP_DIR stress-ng  --hdd 2 --hdd-write-size 10 --timeout 60s --metrics-brief --temp-path $TMP_DIR 2>&1 | tee -a $RESULT_FILE
# mpirun -np 2 --host 192.168.0.2:1,192.168.0.4:1 hpcc 2>&1 | tee -a $RESULT_FILE
echo "✅ Distributed System test completed! Results saved in $RESULT_FILE"
