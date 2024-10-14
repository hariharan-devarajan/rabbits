SCRIPT_DIR=${RABBITS_PROJECT_HOME}/benchmarks/ior
export IOR_CASE=$1

date_echo "Initializing environment."
source ${SCRIPT_DIR}/setup.sh $IOR_CASE

spack env activate -p ${RABBITS_ENV_VENVS}/ior_env
ior_exec=$(which ior)
cmd="flux run -N$RABBITS_JOB_NODES --tasks-per-node=$RABBITS_JOB_PPN ${ior_exec} -o=${RABBITS_RABBIT_MOUNT}/test.bat ${RABBITS_IOR_FILE_SHARING_CMD} ${RABBITS_IOR_BLOCK_SIZE_CMD} ${RABBITS_IOR_TRANSFER_SIZE_CMD} ${RABBITS_IOR_SYNC_OPTIONS_CMD} ${RABBITS_IOR_OUTPUT_FORMAT_CMD}  ${RABBITS_IOR_ITERATION_CMD}  ${RABBITS_IOR_REORDER_TASK_CMD} ${RABBITS_IOR_OPERATION_CMD}"
echo $cmd
$cmd