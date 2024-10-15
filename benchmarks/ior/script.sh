#!/bin/bash
SCRIPT_DIR=${RABBITS_PROJECT_HOME}/benchmarks/ior
export IOR_CASE=$1

echo "Initializing environment."
source ${SCRIPT_DIR}/setup.sh $IOR_CASE

flux resource list
flux jobs -o {user.rabbits} $FLUX_JOB_ID
spack env activate -p ${RABBITS_ENV_VENVS}/ior_env
ior_exec=$(which ior)

if [[ "$RABBITS_JOB_MULTI" != "" ]]; then
    end_node=$(echo "sqrt($RABBITS_JOB_NODES)" | bc)
    for ((i=RABBITS_JOB_MULTI; i<=end_node; i++)); do 
        node=$((2**i))
        date_echo Running test for $node;
        RABBITS_IOR_OUTPUT_FILE_PREFIX="${RABBITS_JOB_RESULT}/${RABBITS_JOB_NAME}_${node}_${RABBITS_JOB_PPN}_${RABBITS_IOR_BLOCK_SIZE}_${RABBITS_IOR_TRANSFER_SIZE}_write.${RABBITS_IOR_OUTPUT_FORMAT}"
        RABBITS_IOR_OUTPUT_FORMAT_CMD="-O summaryFormat=${RABBITS_IOR_OUTPUT_FORMAT^^} -O summaryFile=${RABBITS_IOR_OUTPUT_FILE_PREFIX}"
        cmd="flux run -N$node --tasks-per-node=$RABBITS_JOB_PPN ${ior_exec} -o=${RABBITS_RABBIT_MOUNT}/test.bat ${RABBITS_IOR_FILE_SHARING_CMD} ${RABBITS_IOR_BLOCK_SIZE_CMD} ${RABBITS_IOR_TRANSFER_SIZE_CMD} ${RABBITS_IOR_SYNC_OPTIONS_CMD} ${RABBITS_IOR_OUTPUT_FORMAT_CMD}  ${RABBITS_IOR_ITERATION_CMD}  ${RABBITS_IOR_REORDER_TASK_CMD} ${RABBITS_IOR_OPERATION_CMD}"
        date_echo $cmd
        $cmd
    done
else
    cmd="flux run -N$RABBITS_JOB_NODES --tasks-per-node=$RABBITS_JOB_PPN ${ior_exec} -o=${RABBITS_RABBIT_MOUNT}/test.bat ${RABBITS_IOR_FILE_SHARING_CMD} ${RABBITS_IOR_BLOCK_SIZE_CMD} ${RABBITS_IOR_TRANSFER_SIZE_CMD} ${RABBITS_IOR_SYNC_OPTIONS_CMD} ${RABBITS_IOR_OUTPUT_FORMAT_CMD}  ${RABBITS_IOR_ITERATION_CMD}  ${RABBITS_IOR_REORDER_TASK_CMD} ${RABBITS_IOR_OPERATION_CMD}"
    date_echo $cmd
    $cmd
fi


