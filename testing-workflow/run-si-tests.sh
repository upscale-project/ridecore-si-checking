#!/bin/bash

if (($# != 3))
then
    echo "There is something wrong with the command line, expecting three parameters!"
    echo "usage: <problem-file> <patch-dir> <verilogsrc-dir>"
    echo "  <problem-file>   : single file containing a list of BMC problems to be solved using CoSA"
    echo "  <patch-dir>      : directory containing patch files for bug injection. The naming scheme of"
    echo "                     the patch files is '*_OPNAME.patch', where OPNAME the name of the operator"
    echo "                     found in the file <problem-file>. The file '*_OPNAME.patch' is used to inject" 
    echo "                     a bug to test the single instruction check for operator OPNAME."
    echo "  <verilogsrc-dir> : directory containing the original Verilog source files of the design."
    echo "                     These files will be patched to inject bugs using the patch files in <patch-dir>."
    echo "                     After a test, 'git reset --hard' is called to undo the patch."
    exit 1
fi

INPUTFILE=$1
DIRNAME=`dirname $INPUTFILE`
PATCHDIR=$2
VERILOGSRC=$3
TMPFILEBMCSETUP=/tmp/tmpfilebmcsetup-$$.txt
TMPFILEBMCTEST=$DIRNAME/tmpfilebmctest-$$.txt
TMPFILECOSALOG=/tmp/tmpfilecosalog-$$.txt

function cleanup
{
  echo "Cleaning up temporary files." 1>&2
  rm -f $TMPFILEBMCSETUP
  rm -f $TMPFILEBMCTEST
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

LOCALCHANGES=`git diff | wc -l`
if (($LOCALCHANGES))
then
    echo "ERROR: repository has uncommitted changes! All changes should be"
    echo "       committed before running these script, will abort now."
    cleanup "0";
    exit 1
fi

# Extract default BMC setup, which will appear in every temporary
# problem file we set up for a CoSA run
# NOTE: extraction depends on the format of file "../cosa/single.txt"
grep -A 3 "\[GENERAL\]" $INPUTFILE > $TMPFILEBMCSETUP
echo "" >> $TMPFILEBMCSETUP
grep -A 6 "\[DEFAULT\]" $INPUTFILE >> $TMPFILEBMCSETUP
echo "" >> $TMPFILEBMCSETUP

# Extract the names of operators from INPUTFILE
declare -a OPNAMES=(`grep "\[Single Instruction [fF]or" $INPUTFILE | awk '{print $4}' | awk -F] '{print $1}'`);

# Extract BMC tests listed in INPUTFILE for each operator
for OP in "${OPNAMES[@]}";
do    
    # Copy basic setup to new problem file
    cat $TMPFILEBMCSETUP > $TMPFILEBMCTEST

    echo "Operator name: $OP"

    # Copy actual test to problem file
    grep -A 5 "\[Single Instruction [[:alnum:]]* $OP\]" $INPUTFILE >> $TMPFILEBMCTEST

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

        echo "  Running CoSA --problems $TMPFILEBMCTEST"
        
        CoSA --problems $TMPFILEBMCTEST 2>&1 | tee $TMPFILECOSALOG

        grep "Result: FALSE" $TMPFILECOSALOG >/dev/null 2>&1
        RESEXPECTED=$?

        if (($RESEXPECTED))
        then
            echo "  Test for $OP using $BUGINJECTIONPATCHFILE failed, CoSA proved the property unexpectedly."
            echo "  Will abort now."
            cleanup "1";
            exit 1
        else
            echo "  Test for $OP using $BUGINJECTIONPATCHFILE succeeded, CoSA found a counterexample as expected."
        fi
    done
    echo ""
done

cleanup "1";

exit 0
