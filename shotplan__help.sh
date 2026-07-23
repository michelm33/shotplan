#!/bin/bash
Shotplan__version() {

  local verfile="${SHOTPLAN__VARS["MYDIR"]}/VERSION.txt"
  local revfile="${SHOTPLAN__VARS["MYDIR"]}/REVISION.txt"
  local copyright="${SHOTPLAN__VARS["MYDIR"]}/COPYRIGHT.txt"

  # Version info
  # Version file contains one line giving the version x.y.z
  echo -n "${__SHELL_CURRENT_APPNAME__} "
  if [ -f "${verfile}" ] ;  then
    cat "${verfile}"
  else
    echo "?.?.?"
  fi
  
  # Revision info if any
  # Revision file contains 2 lines
  # Line 1: the revision number in the configuration management system
  # Line 2: a signature like a hash code computed over the source files 
  if [ -f "${revfile}" ] ;  then
    echo -n "Revision "
    local line
    local cnt=0
    while IFS=''  read -r line
    do
      if [ $cnt -eq 0 ] ; then
        echo -n "$line"
      elif [ $cnt -eq 1 ] ; then
        echo -n " signed $line"
      fi
      cnt=$(($cnt + 1))
    done < <(cat "${revfile}")

    if [ $cnt -eq 1 ] ; then
          echo -n " (unsigned)"
    fi    
    echo
  fi

  # Copyright
  # The trailing line from 4th line are displayed
  if [ -f "${copyright}" ] ;  then
    echo
    local content="$(cat "${copyright}")"
    echo "${content}"|tail -n+3
  fi

  # Author
  # Author fullname is retrieved from passwd
  local fnUser=""
  User__getFullUserName fnUser
cat<<EOF

Written by ${fnUser}

EOF
}

Shotplan__revision() {
  local revfile="${SHOTPLAN__VARS["MYDIR"]}/REVISION.txt"

  # Revision info if any
  if [ -f "${revfile}" ] ;  then
    local line
    local __lcnt=0
    local revisionnum=""
    while IFS=''  read -r line
    do
      if [ ${__lcnt} -eq 0 ] ; then
        revisionnum="$line"
        break
      fi
      __lcnt=$((${__lcnt} + 1))
    done < <(cat "${revfile}")

    if [ -z "$revisionnum" ] ; then
      echo "?"
    else
      echo "$revisionnum"
    fi
  else
    echo "?"
  fi
}

Shotplan__hash() {
  local revfile="${SHOTPLAN__VARS["MYDIR"]}/REVISION.txt"

  # Revision info if any
  if [ -f "${revfile}" ] ;  then
    local line
    local __lcnt=0
    local hashcode=""
    while IFS=''  read -r line
    do
      if [ ${__lcnt} -eq 1 ] ; then
        hashcode="$line"
        break
      fi
      __lcnt=$((${__lcnt} + 1))
    done < <(cat "${revfile}")

    if [ -z "$hashcode" ] ; then
      echo "?"
    else
      echo "$hashcode"
    fi
  else
    echo "?"
  fi
}

Shotplan__versionnum() {
  local vfile="${SHOTPLAN__VARS["MYDIR"]}/VERSION.txt"
  if [ -f "$vfile" ] ; then
cat << EOF
$(cat "$vfile")
EOF
  else
    echo "?"
  fi
}

:<<'EOF'
Help display callback (-h) for usage
EOF

Shotplan__help() {
  echo
  Shotplan__usage
}

:<<'EOF'
Short usage display callback without the option details
EOF

Shotplan__susage_without_options() {
  local __cmdbasename="$(basename $0)"
cat << EOF
Usage: ${__cmdbasename} OPTIONS [ <SHOTPLAN PATH> [ <PLAN NAME> [ ANY ] ] ]
EOF
}

:<<'EOF'
Usage display callback 
EOF

Shotplan__susage() {

  local ctrlFlag=""
  if [ $# -gt 0 ] ; then
    ctrlFlag="$1"
  fi

cat << EOF
$(Shotplan__susage_without_options)

OPTIONS:

$(_soptions SHOTPLAN__OPTION_LIST_DESC SHOTPLAN__OPTION_LIST_SDESC SHOTPLAN__OPTION_LIST_ARGS SHOTPLAN__OPTION_LIST_ARGS_TYPE SHOTPLAN__OPTION_LIST_INTERN "" $ctrlFlag)

EOF
}

Shotplan__usage_args() {
cat << EOF

Arguments:

 <plan file path>       
          The shotplan file where the tests are defined (YAML format)
 
 [<plan name>]           
          Optional: the name of the test (shot) plan to execute (instead of all).
 
 [<any string>]          
          Optional: the providing of any third argument indicates only to run the last step of the specified shot plan.

EOF
}

:<<'EOF'
Usage display callback 
EOF

Shotplan__usage() {
cat << EOF
$(Shotplan__susage)
$(Shotplan__usage_args)

EOF
}

Shotplan__examples() {
  local exampleFile="${SHOTPLAN__VARS["MYDIR"]}/EXAMPLES.txt"
  if [ -f "${exampleFile}" ] ; then
    cat "${exampleFile}"
  fi
}

Shotplan__man() {
cat << EOF | less
*SYNOPSIS*

$(Shotplan__susage_without_options)
$(Shotplan__usage_args)

OPTIONS:

$(_soptions SHOTPLAN__OPTION_LIST_DESC SHOTPLAN__OPTION_LIST_SDESC SHOTPLAN__OPTION_LIST_ARGS SHOTPLAN__OPTION_LIST_ARGS_TYPE SHOTPLAN__OPTION_LIST_INTERN "" "man")

*DESCRIPTION*

shotplan is a test execution and reporting tool which enables to define and execute tests launched and controlled by script.

The tests to run and the control scripts are defined in a YAML configuration file where the sequence of tests are defined and programmed in script. The YAML file is also called test plan or shot plan, and is by convention named `shotplan.yml`.

A test plan splits into a sequence of test cases (also called test plans), in which a sequence of test steps are defined. 

shotplan reports about each executed test and its result on the standard output, including a dated test banners indicating version and revision control numbers of tested items, test tools and dependencies.

Shotplan takes its name by the fact that the tool is capable of producing screenshots and video captures for executed tests.

*EXAMPLES*

$(Shotplan__examples)

Report bugs to <michel.mehl@slashetc.fr>

EOF
}

