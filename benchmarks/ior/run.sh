SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )
export IOR_CASE="fpp_wo"

export RABBITS_ENV_FOLDER_NAME=$(date +%Y%m%d%H%M%S)
export RABBITS_SUBS_BLOCK_SIZE=$((32*1024*1024))
export RABBITS_SUBS_TRANSFER_SIZE=4k

pushd ${SCRIPT_DIR} > /dev/null
source setup.sh $IOR_CASE
popd > /dev/null

date_echo "Executing in ${SCRIPT_DIR}"
alloc="-q ${RABBITS_JOB_QUEUE} -n ${RABBITS_JOB_NODES} -N ${RABBITS_JOB_NODES} -t ${RABBITS_JOB_TIME} --cores-per-slot=${RABBITS_JOB_PPN}  --exclusive"
job="--job-name=${RABBITS_JOB_NAME} --cwd=$SCRIPT_DIR --output=${RABBITS_JOB_LOG}/${RABBITS_NAME}.log"

if [ "${RABBITS_RABBIT_ENABLE}" == "1" ]; then
    rabbit="-S dw=\"#DW jobdw type=${RABBITS_RABBIT_TYPE} capacity=${RABBITS_RABBIT_CAPACITY}GiB name=${RABBITS_RABBIT_NAME}\""
    cmd="flux alloc ${alloc} ${job} ${rabbit} ${SCRIPT_DIR}/script.sh $IOR_CASE"
    echo $cmd
    ${cmd}
else 
    cmd="flux alloc ${alloc} ${job} ${SCRIPT_DIR}/script.sh $IOR_CASE"
    echo $cmd
    ${cmd}
fi