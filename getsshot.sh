#!/bin/bash
declare -A GETSSHOT__VARS
GETSSHOT__VARS["MY_DIR"]=$(readlink -f $(dirname ${BASH_SOURCE[0]}))

if [[ ! -v __SHELL_API_CORE_LOADED__ ]]; then
    source "${GETSSHOT__VARS["MY_DIR"]}/../shell-api/shell-api-core.sh" "getshot"
fi

source "${GETSSHOT__VARS["MY_DIR"]}/shotplan_lib.sh"

eval $_loadm<<<'shell-api-packing'
eval $_loadm<<<'shell-api-yaml'
eval $_loadm<<<'shell-api-net'

WIN_ID="0"
TARGET_FOLDER=~/Pictures
IMG_COPY=~/Pictures
COMPACT=true
ACTUAL_CMD=""

getshot__susage() {
cat << EOF

Usage: $(basename $0) 

Arguments in order:

    0) APP_NAME
    1) PLAN_NAME
    2) STEP_NAME
    3) IMG_TITLE
    4) CMDDSP=
    5) CMD
    6) PRECMDDSP
    7) PRECMD
    8) POSTCMDDSP
    9) POSTCMD
    10) COMMENT
    11) STEP_TEMPL
    12) WIN_ID
    13) TARGET_FOLDER
    14) IMG_COPY
    15) OUTPUT_FILE
EOF
}

:<<'EOF'
Short usage display callback 
EOF
getshot__usage() {
    local susage_txt="$(Shotplan__susage|grep -v -E ^Basic options\:|grep -v -E ^[[:blank:]]*-o|grep -v -E ^[[:blank:]]*-h)"  #|grep -v -E ^Options\:|grep -- -v -E ^\ -f|grep -- -v -E ^\ -h)"
cat << EOF
${susage_txt}

    Performs a screenshot of window of ID '${WIN_ID}' and saves it into the specified image file path.

    Configure the following variable of the script as follows:

    WIN_ID: The ID of the window to screenshot. This can be found by running wmctrl -lp and checking the window name (sudo apt install wmctrl)


EOF
}

# wmctrl -lp

getshot__parseArgs() {
	local argc=0
	local arg_cnt=0

	_parseFromArgToVars GETSHOT__OPTION_LIST_DESC GETSHOT__OPTION_LIST_ARGS GETSHOT__OPTION_LIST_ACTI GETSHOT__OPTION_LIST_VALS argc arg_cnt "$@"
}    

getshot__parseArgsHandleOptionLessArg() {
	local index=$1
	shift
	local value="$@"
    #_log "Shotplan__parseArgsHandleOptionLessArg $index '$value'"
	case ${index} in
			0) APP_NAME="$value"
				return 0 ;; 
			1) PLAN_NAME="$value"
				return 0 ;; 
			2) PLAN_TITLE="$value"
				return 0 ;; 
			3) STEP_NAME="$value"
				return 0 ;; 
			4) IMG_TITLE="$value"
				return 0 ;; 
			5) CMDDSP="$value "
				return 0 ;; 
			6) CMD="$value"
                ACTUAL_CMD="$value"
				return 0 ;; 
			7) PRECMDDSP="$value"
				return 0 ;; 
			8) PRECMD="$value"
				return 0 ;; 
			9) POSTCMDDSP="$value"
				return 0 ;; 
			10) POSTCMD="$value"
				return 0 ;; 
			11) COMMENT="$value"
                Str__trim "${COMMENT}" COMMENT 
                if [ -z "${COMMENT}" ] ; then COMMENT=" "; fi
				return 0 ;; 
			12) STEP_TEMPL="$value"
				return 0 ;; 
			13) WIN_ID="$value"
				return 0 ;; 
			14) TARGET_FOLDER="$value"
				return 0 ;; 
			15) IMG_COPY="$value"
				return 0 ;; 
			16) OUTPUT_FILE="$value"
				return 0 ;; 
			*) return 1 ;;
	esac        
	return 1 # we should not reach this end


}

getshot__loadDep()
{
    Pkg__install "$1" "" apt     
}

getshot__main() {
	_parseArgs "$@"
	_initLogs

    _loadDep "wmctrl"
    _loadDep "xclip"
    _loadDep "gettext-base" # for envsubst

    IMG_PATH="$(echo "${TARGET_FOLDER}/${APP_NAME}_sshot_${PLAN_NAME}_${STEP_NAME}.png")"
    _log_dbg "GETSHOT main: cmd: $CMD"
    _log_dbg "IMG_PATH '$IMG_PATH'"

    Shotplan__exeShotCommand "$PRECMD" 
    Shotplan__exeShotCommand "$CMD" 
    Shotplan__exeShotCommand "$POSTCMD" 
    sync
    sleep 1

    if [ "${OUTPUT_FILE}" != "/dev/null" ] ; then
        import -window "${WIN_ID}" "${IMG_PATH}"
        if [ $? -ne 0 ] ; then exit -1 ; fi


        if [ -d  "${IMG_COPY}" ] ; then
            cp "${IMG_PATH}" "${IMG_COPY}"/
        else
            echo "'${IMG_COPY}' does not exist"
            exit -1
        fi

        echo "Image path: ${IMG_PATH}"
        SCREENSHOT_IMAGE="$(basename "$IMG_PATH")"

        #SUBST_STEP_TEMPL="$(echo "${STEP_TEMPL}"|envsubst)"
        CMD="$(echo "${CMD}"|envsubst)"
        Shotplan__removePreprocChar CMD
        Shotplan__removePreprocChar CMDDSP
        Shotplan__removePreprocChar PRECMD
        Shotplan__removePreprocChar PRECMDDSP
        Shotplan__removePreprocChar POSTCMD
        Shotplan__removePreprocChar POSTCMDDSP
        if [ ! -z "CMDDSP" ] ; then
            CMD="${CMDDSP}"
            CMDDSP=""
        fi
        COMMENT="$(echo "${COMMENT}"|envsubst)"
        eval echo \""${STEP_TEMPL}"\" >> "${OUTPUT_FILE}"
        if [ $? -ne 0 ] ; then exit -1 ; fi

        eval echo \""${STEP_TEMPL}"\" | xclip           # Put in clipboard
    fi

    #sshot="$(ls -Art "${SCREENSHOT_FOLDER}" | tail -n 1)"
    #echo $sshot
}

allArgs=("$@")
if _main "${allArgs[@]}" ; then
        _quit "getshot has finished."
else
        _exit -1 "Operation ended with a failure. Please check above messages."
fi


