#!/bin/bash

##################################################################
# Automated test scripts for lde
#
# (C) 2002 Scott Heavner (sdh@po.cwru.edu), GPL
#
# $ Id: $
#
##################################################################

# Configuration ----------------------
LDE=../lde/lde
DIFF="diff -b"
TMPFILE="/tmp/ldetests.$$"
RM="rm -f"
VERBOSE=1
# End Configuration ------------------

let TESTS=0
let SUCCESS=0

function ldetest {

  # $1 = test label
  # $2+ = command

  success=0

  num=$1
  shift

  if [ x$VERBOSE = x1 ] ; then
	echo -n "Test: $num ... "
  fi

  $* > $TMPFILE 2>&1
  if ! $DIFF $TMPFILE expected/${num} > results/diff1.$$ 2>&1 ; then
	success=1
  fi

  if [ -f results/${num} ] ; then
	if ! $DIFF results/${num} expected/${num}_RESULTS > results/diff2.$$ 2>&1 ; then
		success=2
	fi
  fi

  if [ x$success != x0 ] ; then
	echo "*** failed with code $success ***************"
	exit
  else
	if [ x$VERBOSE = x1 ] ; then
		echo ok
	fi
  	let SUCCESS=$SUCCESS+1

  fi
  $RM $TMPFILE results/diff1.$$ results/diff2.$$ results/${num}

  let TESTS=$TESTS+1
}

ldetest SEARCH_EXT2_MAGIC $LDE --all -t no -T search/ext2mag test.ext2 -O 56 -L 2

ldetest SEARCH_MINIX_MAGIC $LDE --all -t no -T search/minix-mag test.minix -O 16 -L 2

ldetest SEARCH_XIAFS_MAGIC $LDE -s 512 --all -t no -T search/xiafs-mag test.xiafs -O 60 -L 2

ldetest EXT2_INODE2 $LDE -i 2 test.ext2
ldetest MINIX_INODE2 $LDE -i 2 test.minix
ldetest XIAFS_INODE2 $LDE -i 2 test.xiafs

ldetest EXT2_BLOCK55 $LDE -b 55 test.ext2
ldetest MINIX_BLOCK15 $LDE -b 15 test.minix
ldetest XIAFS_BLOCK55 $LDE -b 55 test.xiafs

ldetest EXT2_SUPERSCAN $LDE --superscan test.ext2
ldetest XIAFS_SUPERSCAN $LDE --superscan test.xiafs
ldetest MINIX_SUPERSCAN $LDE --superscan test.minix

ldetest EXT2_ILOOKUP $LDE --ilookup --recoverable -S BBBBBBBBB test.ext2
ldetest XIAFS_ILOOKUP $LDE --ilookup --recoverable -S BBBBBBBBB test.xiafs
ldetest MINIX_ILOOKUP $LDE --ilookup --recoverable -S BBBBBBBBB test.minix

ldetest EXT2_ILOOKUPALL $LDE --ilookup --all -S BBBBBBBBB test.ext2
ldetest XIAFS_ILOOKUPALL $LDE --ilookup --all -S Basic test.xiafs
ldetest MINIX_ILOOKUPALL $LDE --ilookup --all -S ,, -O 18 test.minix

ldetest MINIX_RECOVER $LDE -i 0xC --file results/MINIX_RECOVER test.minix
ldetest XIAFS_RECOVER $LDE -i 0x1B --file results/XIAFS_RECOVER test.xiafs

ldetest EXT2_INDIRECTS $LDE --indirects test.ext2
ldetest XIAFS_INDIRECTS $LDE --indirects test.xiafs
ldetest MINIX_INDIRECTS $LDE --indirects test.minix

echo ${SUCCESS} of ${TESTS} tests completed successfully

if [ x$SUCCESS != x$TESTS ] ; then
	exit $SUCCESS
fi

exit 0
