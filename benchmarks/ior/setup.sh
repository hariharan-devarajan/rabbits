SCRIPT_DIR=${RABBITS_PROJECT_HOME}/benchmarks/ior
IOR_CASE=$1
pushd ${SCRIPT_DIR} > /dev/null
source ../../env/scripts/setup.sh

date_echo "Create run specific configurations at ${RABBITS_JOB_RUN_DIR}"

mkdir -p ${RABBITS_JOB_CONF} ${RABBITS_JOB_RESULT} ${RABBITS_JOB_LOG}
cp ../../env/scripts/conf.yaml ${RABBITS_JOB_CONF}/
cp confs/base.yaml ${RABBITS_JOB_CONF}/
cp confs/${IOR_CASE}.yaml ${RABBITS_JOB_CONF}/

PREFIX=RABBITS_SUBS_
SUBS_VARS=$(env | grep $PREFIX | awk -F= '{print $1}')
eval 'SUBS_VARS=('"$SUBS_VARS"')'

for var in "${SUBS_VARS[@]}"; 
do 
    sed -i "s|${var}|${!var}|" ${RABBITS_JOB_CONF}/conf.yaml
    sed -i "s|${var}|${!var}|" ${RABBITS_JOB_CONF}/base.yaml
    sed -i "s|${var}|${!var}|" ${RABBITS_JOB_CONF}/${IOR_CASE}.yaml
done

eval $(parse_yaml ${RABBITS_JOB_CONF}/conf.yaml RABBITS_)
eval $(parse_yaml ${RABBITS_JOB_CONF}/base.yaml RABBITS_)
eval $(parse_yaml ${RABBITS_JOB_CONF}/${IOR_CASE}.yaml RABBITS_)

date_echo "Finished creating run specific configurations"
popd  > /dev/null
