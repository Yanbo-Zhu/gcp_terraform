!/bin/bash

# uses the sysbench command to perform the 4 benchmarks
sudo apt-get update && sudo apt upgrade
sudo apt install -y sysbench

#####################
# writes the benchmark.sh content to a file.
#####################

# Define the script name
SCRIPT_NAME="/tmp/benchmark.sh"

# Write the benchmark script to the file
cat << 'EOF' > $SCRIPT_NAME
#!/bin/bash

echo "Starting benchmark..."
START=$(date +%s)

# Example benchmark task: Calculate the sum of numbers from 1 to 1,000,000
SUM=0
i=1
while [ "$i" -le 1000 ]; do
  SUM=$((SUM + i))
  i=$((i + 1))
done

END=$(date +%s)

echo "Benchmark completed. Result: $SUM"
echo "Time elapsed: $((END - START)) seconds"
EOF

# Make the script executable
sudo chmod +x $SCRIPT_NAME

echo "Script '$SCRIPT_NAME' has been created and made executable."

