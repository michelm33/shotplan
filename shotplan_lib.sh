#!/bin/bash
declare -A SHOTPLANLIB__VARS
declare -A REPLACE_MAP
declare -A REPLACE_POST_MAP

SHOTPLANLIB__VARS["MY_DIR"]=$(readlink -f $(dirname ${BASH_SOURCE[0]}))

preproc="${SHOTPLANLIB__VARS["MY_DIR"]}/shotplan__cmdpreproc.sh"
if [ -f "$preproc" ] ; then
    source  "$preproc"
fi
postproc="${SHOTPLANLIB__VARS["MY_DIR"]}/shotplan__cmdpostproc.sh"
if [ -f "$postproc" ] ; then
    source  "$postproc"
fi

Shotplan__replaceMappedStrings()
{
    local -n __in_map=$1
    local -n __inout_str=$2
    local item=""
    for item in "${!__in_map[@]}" ; do
        local replaceItem="${__in_map[$item]}"
        #echo "${__inout_str} : replacing '$item' with '$replaceItem'" # DEBUG
        __inout_str="${__inout_str//$item/$replaceItem}"
        #echo "${__inout_str} : after " # DEBUG
    done
}

Shotplan__removePreprocChar()
{
    local -n __inout_s=$1
    if [ "${__inout_s:0:1}" = "!" ] ; then
        __inout_s="${__inout_s:1}"
        return 0
    else
        return 1
    fi
}

Shotplan__removeSilentCommandPreprocChar()
{
    local -n __inout_s=$1
    if [ "${__inout_s:0:1}" = "?" ] ; then
        __inout_s="${__inout_s:1}"
        return 0
    else
        return 1
    fi
}


:<<'EOF'
@param[1] Multi-line command to execute
EOF
Shotplan__exeShotCommand()
{
    local preproc="${SHOTPLANLIB__VARS["MY_DIR"]}/shotplan__cmdpreproc.sh"
    local postproc="${SHOTPLANLIB__VARS["MY_DIR"]}/shotplan__cmdpostproc.sh"

    local _exeCommand="$1"
    if [ ! -z "${_exeCommand}" ] && [ "${_exeCommand}" != null ] ;then
        local _cmdLine=""
        local _actualCmdLine=""
        local arr=()
        while IFS='' read -r _cmdLine
        do
            arr+=("$(echo "$_cmdLine"|envsubst)")

        done <<< "${_exeCommand}"
        for _cmdLine in "${arr[@]}" ; do
            local forceReplace=false
            local silentCmd=false

            if Shotplan__removeSilentCommandPreprocChar _cmdLine ; then
                silentCmd=true
            fi

            if Shotplan__removePreprocChar _cmdLine ; then
                forceReplace=true
            fi

            #echo "CHECK '$postcmdLine'"
            if ! $silentCmd ; then
                if [[ ! "$_cmdLine" =~ ^sleep.* ]] && [[ ! "$_cmdLine" =~ ^sync.* ]] && [[ ! "$_cmdLine" =~ ^test.* ]]  && [[ ! "$_cmdLine" =~ ^"sudo ip route".* ]]  ; then 
                    if ! $COMPACT ; then echo ; fi
                    # Display RAW command line
                    echo "\$ ${_cmdLine}"
                fi
            fi

            # Execute the command, replacing secret predefined strings
            if $forceReplace ; then
                Shotplan__replaceMappedStrings REPLACE_MAP _cmdLine
                #_log_vars _cmdLine
                #_log_vars _actualCmdLine
            fi
            #_log_vars _actualCmdLine
            if $forceReplace ; then
                local cmdRes="$(eval "${_cmdLine}")"
                if $forceReplace ; then
                    Shotplan__replaceMappedStrings REPLACE_POST_MAP cmdRes
                fi
                echo "$cmdRes"
            else
                eval "${_cmdLine}"
            fi
        done
    fi
}
