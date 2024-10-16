#!/bin/bash
SCRIPT_DIR=${RABBITS_PROJECT_HOME}/benchmarks/ior
export IOR_CASE=$1

echo "Initializing environment."
source ${SCRIPT_DIR}/setup.sh $IOR_CASE

flux resource list
flux jobs -o {user.rabbits} $FLUX_JOB_ID
spack env activate -p ${RABBITS_ENV_VENVS}/ior_env
ior_exec=$(which ior)

if [[ "$RABBITS_JOB_MULTI_NODE_START" != "" ]] || [[ "$RABBITS_JOB_MULTI_NODE_END" != "" ]] || [[ "$RABBITS_JOB_MULTI_PPN_START" != "" ]] || [[ "$RABBITS_JOB_MULTI_PPN_END" != "" ]]; then
    start_node=$(echo "sqrt($RABBITS_JOB_NODES)" | bc)
    end_node=$(echo "sqrt($RABBITS_JOB_NODES)" | bc)
    if [[ "$RABBITS_JOB_MULTI_NODE_START" != "" ]]; then
        start_node=$RABBITS_JOB_MULTI_NODE_START
    fi
    if [[ "$RABBITS_JOB_MULTI_NODE_END" != "" ]]; then
        end_node=$RABBITS_JOB_MULTI_NODE_END
    fi
    start_ppn=$RABBITS_JOB_PPN
    end_ppn=$RABBITS_JOB_PPN
    if [[ "$RABBITS_JOB_MULTI_PPN_START" != "" ]]; then
        start_ppn=$RABBITS_JOB_MULTI_PPN_START
    fi
    if [[ "$RABBITS_JOB_MULTI_PPN_END" != "" ]]; then
        end_ppn=$RABBITS_JOB_MULTI_PPN_END
    fi
    for ((i=start_node; i<=end_node; i++)); do 
        node=$((2**i))
        for ((j=start_ppn; j<=end_ppn; j++)); do 
            ppn=$((2**j))
            date_echo Running test for node $node and ppn $ppn;
            RABBITS_IOR_OUTPUT_FILE_PREFIX="${RABBITS_JOB_RESULT}/${RABBITS_JOB_NAME}_${node}_${ppn}_${RABBITS_IOR_BLOCK_SIZE}_${RABBITS_IOR_TRANSFER_SIZE}_write.${RABBITS_IOR_OUTPUT_FORMAT}"
            RABBITS_IOR_OUTPUT_FORMAT_CMD="-O summaryFormat=${RABBITS_IOR_OUTPUT_FORMAT^^} -O summaryFile=${RABBITS_IOR_OUTPUT_FILE_PREFIX}"
            cmd="flux run -N$node --tasks-per-node=$ppn ${ior_exec} -o=${RABBITS_RABBIT_MOUNT}/test.bat ${RABBITS_IOR_FILE_SHARING_CMD} ${RABBITS_IOR_BLOCK_SIZE_CMD} ${RABBITS_IOR_TRANSFER_SIZE_CMD} ${RABBITS_IOR_SYNC_OPTIONS_CMD} ${RABBITS_IOR_OUTPUT_FORMAT_CMD}  ${RABBITS_IOR_ITERATION_CMD}  ${RABBITS_IOR_REORDER_TASK_CMD} ${RABBITS_IOR_OPERATION_CMD}"
            date_echo $cmd
            $cmd
        done
    done
else
    cmd="flux run -N$RABBITS_JOB_NODES --tasks-per-node=$RABBITS_JOB_PPN ${ior_exec} -o=${RABBITS_RABBIT_MOUNT}/test.bat ${RABBITS_IOR_FILE_SHARING_CMD} ${RABBITS_IOR_BLOCK_SIZE_CMD} ${RABBITS_IOR_TRANSFER_SIZE_CMD} ${RABBITS_IOR_SYNC_OPTIONS_CMD} ${RABBITS_IOR_OUTPUT_FORMAT_CMD}  ${RABBITS_IOR_ITERATION_CMD}  ${RABBITS_IOR_REORDER_TASK_CMD} ${RABBITS_IOR_OPERATION_CMD}"
    date_echo $cmd
    $cmd
fi


