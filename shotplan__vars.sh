#!/bin/bash
###############################################################################
#
# Shotplan
#
# Copyright (c) 2026 Michel MEHL. All rights reserved.
#
# ------------------------------------------------------------------------------
#
# This file contains the definition of all internal variables used by Shotplan.
# These variables may e.g. set by options and when reading data from a YAML file
#
# ------------------------------------------------------------------------------
#
# Report bugs to michel.mehl@slashetc.fr
#
###############################################################################

SHOTPLAN__VARS["verbose"]=false
SHOTPLAN__VARS["silent"]=false

SHOTPLAN__VARS["ONLY_LAST_PLAN"]=false
SHOTPLAN__VARS["PLAN"]=""
SHOTPLAN__VARS["PLAN_FILE_PATH"]=""
SHOTPLAN__VARS["CATEGORY"]="all"            # by default all
SHOTPLAN__VARS["INTERACTIVE"]=true
SHOTPLAN__VARS["GENERATE_REPORT"]=false
SHOTPLAN__VARS["GENERATE_FOR_MANPAGE"]=false
SHOTPLAN__VARS["GENERATE_OUTPUTFILE_LIST"]=false
SHOTPLAN__VARS["LIST_PLAN_IDS"]=false
SHOTPLAN__VARS["LIST_CATEGORY"]=false
SHOTPLAN__VARS["START_PLAN"]=""
SHOTPLAN__VARS["force-defaults"]=false

SHOTPLAN__VARS["executePlan"]=false
SHOTPLAN__VARS["__posttestScript"]=false
