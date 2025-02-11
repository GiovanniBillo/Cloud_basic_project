#!/bin/bash

RESULT_FILE="/shared/results/disk_io_test_results.txt"
chmod 777 /shared/results/*.txt
echo "💾 Distributed Disk I/O Performance Test Results" > $RESULT_FILE
echo "------------------------------------------------" >> $RESULT_FILE

# Run IOZone in parallel across all nodes
echo "📂 Running IOZone Test across all nodes..."
# mpirun --host 192.168.0.1,192.168.0.2,192.168.0.4 -np 3 iozone -a -s 1G -r 4k -i 0 -i 1 -i 2 | tee -a $RESULT_FILE
mpirun --host 192.168.0.1,192.168.0.2,192.168.0.4 -np 3 iozone -a -s 1G -r 4k -i 0 -i 1 -i 2 O -f /shared/iozone_testfile.txt 
# run all kinds of tests with max 1G offile size (-g 1G), using multiple buffers (-m) in throughput mode (-t)
# mpirun --host 192.168.0.1,192.168.0.2,192.168.0.4 -np 3 iozone -a -i0 -i1 -i2 -i3 -i4- -i5 -i6 -i7 -i8 -i9 -i10 -i11 -i12 -g 1G -f $RESULT_FILE

# mpirun --host 192.168.0.1,192.168.0.2,192.168.0.4 -np 3 iozone -t2 -i0 -i1 -i2 -i3 -i4- -i5 -i6 -i7 -i8 -i9 -i10 -i11 -i12 -g 1G -f $RESULT_FILE

echo "📂 Running IOZone Test on the /shared folder (small file size)" >> $RESULT_FILE
touch /shared/iozone_testfile.txt
mpirun -np 2 --host 192.168.0.1,192.168.0.2,192.168.0.4 iozone -s 256M -r 1k -i0 -i1 -i2 -i3 -i4- -i5 -i6 -i7 -i8 -i9 -i10 -i11 -i12 -g 1G -f /shared/iozone_testfile.txt | tee -a $RESULT_FILE
# mpirun -np 2 --host 192.168.0.2:1,192.168.0.4:1 iozone -s 256M -r 1k -i 0 -i 1 -i 2 -f /shared/iozone_testfile.txt -Rb /shared/iozone_results.xls

echo "✅ Distributed Disk I/O test completed! Results saved in $RESULT_FILE"

