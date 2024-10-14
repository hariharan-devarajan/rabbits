SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )

pushd ${SCRIPT_DIR} > /dev/null

source ../../env/scripts/setup.sh

date_echo "Initializing environment."

spack env activate -p ${RABBITS_ENV_VENVS}/ior_env
