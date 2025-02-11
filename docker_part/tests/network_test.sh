#!/bin/bash

# Define server and clients
SERVER="master"
CLIENTS=("worker1" "worker2")
DURATION=30  # Test duration in seconds
PARALLEL_STREAMS=2  # Number of parallel streams

# Ensure iperf3 is installed on all nodes
for NODE in "${SERVER}" "${CLIENTS[@]}"; do
    ssh $NODE "command -v iperf3 >/dev/null 2>&1 || (sudo apt update && sudo apt install -y iperf3)"
done

# File to save results
RESULT_FILE="/shared/results/network_test_results.txt"
chmod 777 /shared/results/*.txt
echo "📡 Network Performance Test Results" > $RESULT_FILE
echo "---------------------------------" >> $RESULT_FILE

# Start iperf3 server on 192.168.0.1
echo "🚀 Starting iperf3 server on 192.168.0.1..."
iperf3 -s &

# Function to run iperf3 test
run_iperf_test() {
    CLIENT=$1
    MODE=$2  # "upload" or "download"
    OUTPUT_FILE="/shared/results/iperf_${CLIENT}_${MODE}.txt"

    if [ "$MODE" == "upload" ]; then
        echo "🚀 Testing UPLOAD from $CLIENT to $SERVER..."
        ssh $CLIENT "iperf3 -c $SERVER -t $DURATION -P $PARALLEL_STREAMS" > $OUTPUT_FILE
    else
        echo "📥 Testing DOWNLOAD from $SERVER to $CLIENT..."
        ssh $CLIENT "iperf3 -c $SERVER -t $DURATION -P $PARALLEL_STREAMS -R" > $OUTPUT_FILE
    fi

    # Extract relevant data and save to result file
    THROUGHPUT=$(grep "sender" $OUTPUT_FILE | awk '{print $7, $8}')
    echo "$CLIENT $MODE Speed: $THROUGHPUT" | tee -a $RESULT_FILE
}

# Run tests for each client
for CLIENT in "${CLIENTS[@]}"; do
    run_iperf_test $CLIENT "upload"
    run_iperf_test $CLIENT "download"
done

echo "✅ All network tests completed! Results saved in $RESULT_FILE"

