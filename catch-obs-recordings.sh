#!/bin/bash
declare -A CAR__VARS
CAR__VARS["MY_DIR"]=$(readlink -f $(dirname ${BASH_SOURCE[0]}))
REC_VID_DIR=~/Videos/obs_recordings
OBS_PID=0

if [[ ! -v __SHELL_API_CORE_LOADED__ ]]; then
    source "${CAR__VARS["MY_DIR"]}/../shell-api/shell-api-core.sh" "getshot"
fi

source "${CAR__VARS["MY_DIR"]}/shotplan_lib.sh"

eval $_loadm<<<'shell-api-yaml'
eval $_loadm<<<'shell-api-packing'
eval $_loadm<<<'shell-api-sys'

:<<'EOF'
Screen__getResolution resX resY
echo "Screen__getResolution $resX $resY"
echo "$(( $resX - ($resX/10) )) $(( $resY - ($resY/10) ))"
exit 0
EOF

WIN_ID="0"

car__susage() {
cat << EOF

Usage: $(basename $0) [Arguments]
Arguments in order:
        0) APP_NAME
        1) PLAN_NAME
        2) STEP_NAME
        3) IMG_TITLE
        4) MANUAL_TEST
        5) CMDDSP=
        6) CMD
        7) COMMENT
        8) STEP_TEMPL
        9) WIN_ID
        10) TARGET_FOLDER
        11) IMG_COPY
        12) OUTPUT_FILE
EOF
}

:<<'EOF'
Short usage display callback 
EOF
car__usage() {
    local susage_txt="$(Shotplan__susage|grep -v -E ^Basic options\:|grep -v -E ^[[:blank:]]*-o|grep -v -E ^[[:blank:]]*-h)"  #|grep -v -E ^Options\:|grep -- -v -E ^\ -f|grep -- -v -E ^\ -h)"
cat << EOF
${susage_txt}

    Performs a video recording session with OBS tool.

     WIN_ID: The name of the OBS collection used as configuration for the OBS recording , or a special command starting with ?
 


EOF
}

car__reset()
{
    if [ ${OBS_PID} != 0 ] ; then
        #echo "Killing OBS"
        kill -9 "${OBS_PID}" 2>/dev/null || echo "OBS already killed"
    fi
    _log_dbg "Resetting screen keyboard"
    gnome__setScreenKeyboardVisibile false

    #xdotool mousemove restore
}

car__cleanup() {
    car__reset
    rm "${REC_VID_DIR}"/*.mp4 &>/dev/null
    rm "${REC_VID_DIR}"/*.mkv &>/dev/null
    trap - EXIT SIGHUP SIGINT SIGTERM SIGQUIT SIGABRT
    exit 0
}

car__loadDep() {
    Pkg__install "$c" "" apt 
}

car__welcomeMessage()
{
    #clear    

    echo
    echo "Prepare for the recording:"
    echo
    echo "- Clean the recording screen"
    echo "- Prepare the windows to be recorded and initial state"
    echo "- Screen keyboard will be displayed at the bottom.  Leave that area empty"
    echo
    read -n1 -p "Press a key to start recording (ALT-s to stop recording)" startkey
    echo
    echo
}

car__parseArgs() {
	local argc=0
	local arg_cnt=0

	_parseFromArgToVars CAR__OPTION_LIST_DESC CAR__OPTION_LIST_ARGS CAR__OPTION_LIST_ACTI CAR__OPTION_LIST_VALS argc arg_cnt "$@"
}    

car__parseArgsHandleOptionLessArg() {
	local index=$1
	shift
	local value="$@"
    #_log "Shotplan__parseArgsHandleOptionLessArg $index '$value'"

# "${__app}" "$selectedPlanName" "$i" "$name    

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
			5) MANUAL_TEST="$value"
				return 0 ;; 
			6) CMDDSP="$value "
				return 0 ;; 
			7) CMD="$value"
                ACTUAL_CMD="$value"
				return 0 ;; 
			8) COMMENT="$value"
                Str__trim "${COMMENT}" COMMENT 
                if [ -z "${COMMENT}" ] ; then COMMENT=" "; fi
				return 0 ;; 
			9) STEP_TEMPL="$value"
				return 0 ;; 
			10) WIN_ID="$value"
				return 0 ;; 
			11) TARGET_FOLDER="$value"
				return 0 ;; 
			12) IMG_COPY="$value"
				return 0 ;; 
			13) OUTPUT_FILE="$value"
				return 0 ;; 
			*) return 1 ;;
	esac        
	return 1 # we should not reach this end


}

car__main() {
	_parseArgs "$@"
	_initLogs

    _loadDep "xdotool@xdotool"
    _loadDep "wmctrl@wmctrl"
    _loadDep "xrandr@x11-xserver-utils"

    #_log "APP_NAME = $APP_NAME PLAN_NAME = $PLAN_NAME STEP_NAME = $STEP_NAME IMG_TITLE = $IMG_TITLE MANUAL_TEST = $MANUAL_TEST CMDDSP= = $CMDDSP= CMD = $CMD COMMENT = $COMMENT STEP_TEMPL = $STEP_TEMPL WIN_ID = $WIN_ID  TARGET_FOLDER = $TARGET_FOLDER  IMG_COPY = $IMG_COPY  OUTPUT_FILE = $OUTPUT_FILE "

    car__welcomeMessage

    #echo "process ID is :$OBS_PID"

    if [ "${MANUAL_TEST}" == "yes" ] ; then
        echo "Launching OBS recording for collection ${APP_NAME}"
        obs --startrecording --collection="${APP_NAME}" --minimize-to-tray &> /dev/null &
        OBS_PID=$!

        echo "Running the manual test"
        read -n1 -p "Press a key when the manual running of the test is finished." userkey
    else
        # See closing bracket: this block will close stdin, because after the call to 'gsettings', for every new line, a return input is buffered.
        # So stty will fail and consequently all terminal menu
        { 
            if [ "${OUTPUT_FILE}" != "/dev/null" ] ; then

                if ! Str__contains "${WIN_ID}" "no-screenkeyboard" ; then
                    echo "Activating screen keyboard"
                    gnome__setScreenKeyboardVisibile true
                fi

                # Placing the mouse near the keyboard, at the bottom right
                Screen__getResolution resX resY
                xdotool mousemove $(( $resX - ($resX/15) )) $(( $resY - ($resY/20) ))

            fi

            echo "Running the command (manual ? '${MANUAL_TEST}')"
            #clear
            cd ~
            Shotplan__exeShotCommand "$CMD" &
            cmdPID=$!
            sleep 4

            if [ "${OUTPUT_FILE}" != "/dev/null" ] ; then
                echo "Launching OBS recording for collection ${APP_NAME}"
                obs --startrecording --collection="${APP_NAME}" --minimize-to-tray &> /dev/null & #obs --startrecording --collection="${APP_NAME}" &> /dev/null &
                OBS_PID=$!
            fi

            wait $cmdPID
        } <&- # This closes stdin, because after the call to 'gsettings', for every new line, a return input is buffered.
    fi

    if [ "${OUTPUT_FILE}" = "/dev/null" ] ; then
        return 0
    fi

    # stop recording
    #fg
    sleep 1
    arr=(1 2 3 4 5)
    for a in "${arr[@]}" ; do 
        #xdotool key --window 0x0284761c alt+s  &>/dev/null
        xdotool key alt+s &>/dev/null
    done
    sleep 2
    for a in "${arr[@]}" ; do 
        #xdotool key --window 0x0284761c alt+s  &>/dev/null
        xdotool key alt+s &>/dev/null
    done

    cd "${REC_VID_DIR}"
    Term__clear
    for i in *; do
        ext=${i##*.}
        if [ "$ext" != "$i" ] ; then
            #echo $ext
            if [ "$ext" = "mp4" ] || [ "$ext" = "mkv" ] ; then
                #echo "found $i !!!"
                echo
                #read -n1 -p "Press a key to continue"

                if ! Input__confirm "Press y when ok and save" ; then
                #if ! Input__confirm "Found image '$i'. Save or drop?" ; then
                    car__reset
                    echo
                    sync
                    sleep 1
                    rm "$i"
                    if [ $? -eq 0 ] ; then
                        echo "DELETED --> $i was removed"                    
                        exit 0
                    else
                        echo "FAILED TO DELETE --> $i was removed. ABORTED"
                        exit -1
                    fi
                    echo "Current vids in home:"
                    ls "${REC_VID_DIR}"/*.${ext}
                    break
                fi

                car__reset
                echo

                if [ -z "${IMG_TITLE}" ] ; then
                    read  -ep "Enter title of video (it will be prefixed with 'vid'): " IMG_TITLE
                fi

                targetImageFileName="vid_${IMG_TITLE// /_}.${ext}"


                # Create the adoc line
                #
                if [ ! -z "CMDDSP" ] ; then
                    CMD="${CMDDSP}"
                    CMDDSP=""
                fi

                LIVE_RECORDING="$targetImageFileName" # This variable is used in the template
                eval echo \""${STEP_TEMPL}"\" >> "${OUTPUT_FILE}"


                # Copy the generated vids to their specified target folders
                #
                target="${TARGET_FOLDER}/${targetImageFileName}"
                target_release="${IMG_COPY}/${targetImageFileName}"
                echo "COPY --> $i to $target"  
                cp "$i" "$target"
                echo "COPY --> $i to $target_release"  
                cp "$i" "$target_release"
                rm $i
                echo "TO REMOVE:"
                echo "rm \"${target}\" && rm \"${target_release}\""

                if Input__confirm "View?" ; then
                    vlc "$target_release" &
                fi

                break
            fi
        fi
    done
}

allArgs=("$@")
if _main "${allArgs[@]}" ; then
        _quit "Operation finished."
else
        _exit -1 "Operation ended with a failure. Please check above messages."
fi
