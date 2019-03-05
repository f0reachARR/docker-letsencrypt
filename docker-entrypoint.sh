#!/bin/bash
set -e
#set -x

if [ "${LOG}" == "TRUE" ]; then
    LOG_DIR=/var/log/letsencrypt
	LOG_FILE=${LOG_DIR}/runtime.log
	mkdir -p ${LOG_DIR}
	touch ${LOG_FILE}

	UUID=$(cat /proc/sys/kernel/random/uuid)
	exec > >(read message; echo "${UUID} $(date -Iseconds) [info] $message" | tee -a ${LOG_FILE} )
	exec 2> >(read message; echo "${UUID} $(date -Iseconds) [error] $message" | tee -a ${LOG_FILE} >&2)
fi

echo "${@}"
exec "${@}"
