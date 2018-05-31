#!/usr/bin/env bash

set -e

echo "Waiting ${STARTUP_DELAY} seconds"

sleep ${STARTUP_DELAY}

# Generate nvidia.txt config file

echo "Generate nvidia.txt config file"

echo "Threads: ${THREADS}, Blocks: ${BLOCKS}"
echo "\"gpu_threads_conf\" :" > /opt/xmr-stak/nvidia.txt
echo "[" >> /opt/xmr-stak/nvidia.txt
nvidia-smi --query-gpu=index --format=csv,noheader | while read INDEX
do
  echo "{ \"index\" : ${INDEX}, \"threads\" : ${THREADS}, \"blocks\" : ${BLOCKS}, \"bfactor\" : 0, \"bsleep\" :  0, \"affine_to_cpu\" : false, \"sync_mode\" : 3, }," >> /opt/xmr-stak/nvidia.txt
  echo "Enabled GPU ${INDEX}"
done
echo "]," >> /opt/xmr-stak/nvidia.txt

echo "Starting miner"

/usr/local/bin/xmr-stak --url ${STRATUM} --rigid ${MINER_ID} --user ${WALLET} --pass ${PASSWORD} --currency ${CURRENCY}
