#!/bin/bash

RESULT_FILE="/shared/results/disk_io_test_results.txt"
# chmod 777 /shared/results/*.txt
echo "💾 Distributed Disk I/O Performance Test Results" > $RESULT_FILE
echo "------------------------------------------------" >> $RESULT_FILE
MIN_SIZE=32768
MIN_RECLEN=64

# Run IOZone in parallel across all nodes
echo "📂 Running IOZone Test across all nodes..."
mpirun --host worker1,worker2 -np 2 iozone -n $MIN_SIZE -y $MIN_RECLEN -a -R -O -f /shared/results/iozone_tempfile.txt| awk '/Excel output is below:/ {found=1; print; next} found' > excel_output.xls 

echo "📂 Running IOZone Test on the /shared folder (small file size)" >> $RESULT_FILE
mpirun --host worker1,worker2 -np 2 iozone -s 56M -r 1k -n $MIN_SIZE -y $MIN_RECLEN -a -R -O -f /shared/results/iozone_tempfile2.txt | awk '/Excel output is below:/ {found=1; print; next} found'> excel_output2.xls 

echo "✅ Distributed Disk I/O test completed! Results saved in $RESULT_FILE"

