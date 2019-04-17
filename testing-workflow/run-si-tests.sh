#!/bin/bash

if (($# != 3))
then
    echo "There is something wrong with the command line, expecting three parameters!"
    echo "usage: <problem-files-dir> <patch-dir> <verilogsrc-dir>"
    echo "  <problem-files-dir>   : directory of files containing BMC problems to be solved using CoSA"
    echo "  <patch-dir>           : directory containing patch files for bug injection. The naming scheme of"
    echo "                          the patch files is '*_OPNAME.patch', where OPNAME the name of the operator"
    echo "                          found in the file <problem-file>. The file '*_OPNAME.patch' is used to inject" 
    echo "                          a bug to test the single instruction check for operator OPNAME."
    echo "  <verilogsrc-dir>      : directory containing the original Verilog source files of the design."
    echo "                          These files will be patched to inject bugs using the patch files in <patch-dir>."
    echo "                          After a test, 'git reset --hard' is called to undo the patch."
    exit 1
fi

INPUTFILESDIR=$1
PATCHDIR=$2
VERILOGSRC=$3
TMPFILECOSALOG=/tmp/tmpfilecosalog-$$.txt

function cleanup
{
  echo "Cleaning up temporary files." 1>&2
  rm -f $TMPFILECOSALOG
  # function parameter indicates whether to reset
  if (($1))
  then
      echo "  cleanup: resetting any local changes"
      git reset --hard
  fi
}

trap 'cleanup "1"; exit 1' SIGHUP SIGINT SIGTERM

# Check if local git repository has uncommited changes. If so, then we
# will abort to avoid losing uncommitted changes due to calls of 'git
# reset' during this workflow.

#TODO: catch newly added but not yet committed files

LOCALCHANGES=`git diff | wc -l`
if (($LOCALCHANGES))
then
    echo "ERROR: repository has uncommitted changes! All changes should be"
    echo "       committed before running these script, will abort now."
    cleanup "0";
    exit 1
fi

# Collect all CoSA problem files in INPUTFILESDIR
declare -a INPUTFILES=(`find $INPUTFILESDIR -name "single_property_*.txt"`);

# Loop over all CoSA problem files, inject bug provided that a
# respective patch file is available, and run CoSA on the problem file
# to detect a counterexample.
for INPUTFILE in "${INPUTFILES[@]}";
do
    echo "CoSA problem file: $INPUTFILE"
    
    OP=`grep "\[Single Instruction [fF]or" $INPUTFILE | awk '{print $4}' | awk -F] '{print $1}'`;
    echo "Operator name: $OP"

    # Find patch files related to operator OP, assuming its file name
    # contains the strin "$OP" (i.e., the current operator name)
    BUGINJECTIONPATCHFILES=`find $PATCHDIR -iname "$OP"`

    declare -a BUGINJECTIONPATCHFILES=(`find $PATCHDIR -iname "*_$OP.patch"`);

    if (( ${#BUGINJECTIONPATCHFILES[@]} == 0 ))
    then
        echo "  No bug injection patches found for instruction $OP, skipping tests."
        continue
    fi

    # Loop over all bug injection files found for current operator and
    # call CoSA on the Verilog sources of Ridecore modified by bug
    # injections.
    for BUGINJECTIONPATCHFILE in "${BUGINJECTIONPATCHFILES[@]}";
    do
        echo "  Bug injection patch file for instruction $OP: " $BUGINJECTIONPATCHFILE
        ORIGFILENAME=`head -n 1 $BUGINJECTIONPATCHFILE | awk '{print $2}' | xargs -I FILE basename FILE`
        echo "  Original Verilog file name: $ORIGFILENAME"

        # Reset changes from bug inserted in previous iteration of loop.
        git reset --hard
        
        echo "  Patching original file $ORIGFILENAME"
        patch -i $BUGINJECTIONPATCHFILE $VERILOGSRC/$ORIGFILENAME

        echo "  Running CoSA --problems $INPUTFILE"
        
        CoSA --problems $INPUTFILE 2>&1 | tee $TMPFILECOSALOG

        grep "Result: FALSE" $TMPFILECOSALOG >/dev/null 2>&1
        RESEXPECTED=$?

        if (($RESEXPECTED))
        then
            echo "  Test for $OP using $BUGINJECTIONPATCHFILE failed, CoSA proved the property unexpectedly."
        else
            echo "  Test for $OP using $BUGINJECTIONPATCHFILE succeeded, CoSA found a counterexample as expected."
        fi
    done
    echo ""
done

cleanup "1";

exit 0
