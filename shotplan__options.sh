#!/bin/bash
###############################################################################
#
# Shotplan
#
# Copyright (c) 2026 Michel MEHL. All rights reserved.
#
# ------------------------------------------------------------------------------
#
# This file contains the definition of all options supported by Shotplan.
#
# ------------------------------------------------------------------------------
#
# Report bugs to michel.mehl@slashetc.fr
#
###########################################################################
declare -A SHOTPLAN__OPTION_LIST_SDESC
declare -A SHOTPLAN__OPTION_LIST_DESC
declare -A SHOTPLAN__OPTION_LIST_ARGS
declare -A SHOTPLAN__OPTION_LIST_ARGS_TYPE
declare -A SHOTPLAN__OPTION_LIST_ACTI
declare -A SHOTPLAN__OPTION_LIST_VALS
declare -A SHOTPLAN__OPTION_LIST_INTERN

SHOTPLAN__OPTION_LIST_SDESC["--from"]="The test plan from which to start the test execution"
SHOTPLAN__OPTION_LIST_DESC["--from"]="
The test plan from which to start the test execution. All tests defined before will be skipped.
"
SHOTPLAN__OPTION_LIST_ARGS["--from"]="0" 
SHOTPLAN__OPTION_LIST_ARGS_TYPE["--from"]="STRING"
SHOTPLAN__OPTION_LIST_ACTI["--from"]=""
SHOTPLAN__OPTION_LIST_VALS["--from"]='SHOTPLAN__VARS["START_PLAN"]="$__myarg"'



SHOTPLAN__OPTION_LIST_SDESC["-C"]="Test category to run"
SHOTPLAN__OPTION_LIST_DESC["-C"]="Test category to run"
SHOTPLAN__OPTION_LIST_ARGS["-C"]="0" 
SHOTPLAN__OPTION_LIST_ARGS_TYPE["-C"]="STRING"
SHOTPLAN__OPTION_LIST_ACTI["-C"]=""
SHOTPLAN__OPTION_LIST_VALS["-C"]='SHOTPLAN__VARS["CATEGORY"]="$__myarg"'


SHOTPLAN__OPTION_LIST_SDESC["-i"]="Switch on interactivity (default)"
SHOTPLAN__OPTION_LIST_DESC["-i"]="
When this option is set, the operator is asked to press a key before running the next step.
"
SHOTPLAN__OPTION_LIST_ARGS["-i"]="1"
SHOTPLAN__OPTION_LIST_ACTI["-i"]='SHOTPLAN__VARS["INTERACTIVE"]=true'


SHOTPLAN__OPTION_LIST_SDESC["-a"]="Switch off interactivity"
SHOTPLAN__OPTION_LIST_DESC["-a"]="
Runs the tests automatically without requesting the operator to press a key before running the next step.
"
SHOTPLAN__OPTION_LIST_ARGS["-a"]="1"
SHOTPLAN__OPTION_LIST_ACTI["-a"]='SHOTPLAN__VARS["INTERACTIVE"]=false'



SHOTPLAN__OPTION_LIST_SDESC["-T|--no-report"]="Switch off generation of run reports (default)"
SHOTPLAN__OPTION_LIST_DESC["-T|--no-report"]="
Switches off the generation of the reports including the AsciiDoc document fragments and all screenshots
"
SHOTPLAN__OPTION_LIST_ARGS["-T|--no-report"]="1"
SHOTPLAN__OPTION_LIST_ACTI["-T|--no-report"]='SHOTPLAN__VARS["GENERATE_REPORT"]=false'


SHOTPLAN__OPTION_LIST_SDESC["-R|--report"]="Switch on generation of run reports"
SHOTPLAN__OPTION_LIST_DESC["-R|--report"]="
Switches off the generation of the reports including the AsciiDoc document fragments and all screenshots
"
SHOTPLAN__OPTION_LIST_ARGS["-R|--report"]="1"
SHOTPLAN__OPTION_LIST_ACTI["-R|--report"]='SHOTPLAN__VARS["GENERATE_REPORT"]=true'



SHOTPLAN__OPTION_LIST_SDESC["-M|--manpage"]="Generates command samples for manpages based on the shot plan"
SHOTPLAN__OPTION_LIST_DESC["-M|--manpage"]="
Generates command samples for manpages based on the shot plan
"
SHOTPLAN__OPTION_LIST_ARGS["-M|--manpage"]="1"
SHOTPLAN__OPTION_LIST_ACTI["-M|--manpage"]='
SHOTPLAN__VARS["GENERATE_FOR_MANPAGE"]=true
SHOTPLAN__VARS["INTERACTIVE"]=false
SHOTPLAN__VARS["GENERATE_REPORT"]=false
'




SHOTPLAN__OPTION_LIST_SDESC["-F|--filelist"]="Prints the list of output files (images and videos) as they would have been generated during plan execution."
SHOTPLAN__OPTION_LIST_DESC["-F|--filelist"]="
Prints the list of output files (images and videos) as they would have been generated during plan execution.
"
SHOTPLAN__OPTION_LIST_ARGS["-F|--filelist"]="1"
SHOTPLAN__OPTION_LIST_ACTI["-F|--filelist"]='
SHOTPLAN__VARS["GENERATE_OUTPUTFILE_LIST"]=true
SHOTPLAN__VARS["INTERACTIVE"]=false
SHOTPLAN__VARS["GENERATE_REPORT"]=false
'


SHOTPLAN__OPTION_LIST_SDESC["-P|--planids"]="Prints the logical Ids of all defined test plans."
SHOTPLAN__OPTION_LIST_DESC["-P|--planids"]="
Prints the logical Ids of all defined test plans.
"
SHOTPLAN__OPTION_LIST_ARGS["-P|--planids"]="1"
SHOTPLAN__OPTION_LIST_ACTI["-P|--planids"]='
SHOTPLAN__VARS["LIST_PLAN_IDS"]=true
SHOTPLAN__VARS["INTERACTIVE"]=false
SHOTPLAN__VARS["GENERATE_REPORT"]=false
'




SHOTPLAN__OPTION_LIST_SDESC["--cat"]="List available categories"
SHOTPLAN__OPTION_LIST_DESC["--cat"]="
Lists all categories defined in the plans
"
SHOTPLAN__OPTION_LIST_ARGS["--cat"]="1"
SHOTPLAN__OPTION_LIST_ACTI["--cat"]='SHOTPLAN__VARS["LIST_CATEGORY"]=true'


SHOTPLAN__OPTION_LIST_SDESC["--debug"]="Activates debug logs"
SHOTPLAN__OPTION_LIST_DESC["--debug"]="
Show the debug logs. This may only be used for bug tracking purposes.
"
SHOTPLAN__OPTION_LIST_ARGS["--debug"]="1"
SHOTPLAN__OPTION_LIST_ACTI["--debug"]='__LOG_DEBUG__=0'

SHOTPLAN__OPTION_LIST_SDESC["-y"]="Assume 'Yes' when prompted for confirmation"
SHOTPLAN__OPTION_LIST_DESC["-y"]="
Assume 'Yes' answer for any confirmation request
"
SHOTPLAN__OPTION_LIST_ARGS["-y"]="1"
SHOTPLAN__OPTION_LIST_ACTI["-y"]='
Input__pushForcedInput "y"
SHOTPLAN__VARS["assume-yes"]=true
'




SHOTPLAN__OPTION_LIST_SDESC["--force-defaults"]="Forces default values for required user input to be used and do not ask user to enter a value"
SHOTPLAN__OPTION_LIST_DESC["--force-defaults"]="
Forces default values for required user input to be used and do not ask user to enter a value. This allows to automate further tests if valid default input is supplied in the local_test_vars.sh file.
"
SHOTPLAN__OPTION_LIST_ARGS["--force-defaults"]="1"
SHOTPLAN__OPTION_LIST_ACTI["--force-defaults"]='
SHOTPLAN__VARS["force-defaults"]=true
'

