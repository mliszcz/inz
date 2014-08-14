
#!/bin/bash

# 
# accept.sh storage node acceptance test
# author: Michal Liszcz
# 
# test POST, PUT, GET & DELETE methods
#
# generating large tests files requires some seconds,
# but this is needed to test chunked request reading
#

function random_file {

	# NOTE: openssl is required, but this is
	# MUCH faster than reading from /dev/urandom
	openssl rand -out $2 $(( $1 * 2**20 ))
	
	# dd if=/dev/urandom of=$2 bs=1M count=$1
}

function pass {
	printf "$1\t[OK]\n"
}

function fail {
	printf "$1\t[FAIL] result: $2\n"
	exit 1
}


if [ -n "$1" ]
then
	STORAGE_NODE=$1
else
	echo "gateway not specified!";
	echo "usage: $0 host:address";
	exit 1
fi


TEST_INPUT="/tmp/storage_accept_in"
TEST_OUTPUT="/tmp/storage_accept_out"
TEST_REMOTE="storage/test/accept/test_file.dat"

rm -f $TEST_INPUT > /dev/null 2>&1
rm -f $TEST_OUTPUT > /dev/null 2>&1

random_file 128 $TEST_INPUT		# 128 MB
RESULT=$(curl -XPOST --data-binary @"$TEST_INPUT" "$STORAGE_NODE"/"$TEST_REMOTE" 2>/dev/null)
[ "$RESULT" == "HTTP/1.0 201 Created" ] && pass "POST" || fail "POST" "$RESULT"


RESULT=$(wget -O "$TEST_OUTPUT" "$STORAGE_NODE"/"$TEST_REMOTE" > /dev/null 2>&1)
diff "$TEST_INPUT" "$TEST_OUTPUT" >/dev/null && pass "GET" || fail "GET" "diffrent files"


random_file 256 $TEST_INPUT		# 256 MB
RESULT=$(curl -XPUT --data-binary @"$TEST_INPUT" "$STORAGE_NODE"/"$TEST_REMOTE" 2>/dev/null)
[ "$RESULT" == "HTTP/1.1 202 Accepted" ] && pass "PUT" || fail "PUT" "$RESULT"


RESULT=$(wget -O "$TEST_OUTPUT" "$STORAGE_NODE"/"$TEST_REMOTE" > /dev/null 2>&1)
diff "$TEST_INPUT" "$TEST_OUTPUT" >/dev/null && pass "GET" || fail "GET" "diffrent files"


RESULT=$(curl -XDELETE "$STORAGE_NODE"/"$TEST_REMOTE" 2>/dev/null)
[ "$RESULT" == "HTTP/1.1 202 Accepted" ] && pass "DELETE" || fail "DELETE" "$RESULT"


RESULT=$(curl "$STORAGE_NODE"/"$TEST_REMOTE" 2>/dev/null)
[ "$RESULT" == "HTTP/1.0 404 Not Found" ] && pass "GET" || fail "GET" "$RESULT"
