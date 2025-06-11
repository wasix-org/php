#! /usr/bin/env bash

set -u

TEST_SERVER=${TEST_SERVER:-localhost:8080}

while ! curl -s $TEST_SERVER > /dev/null; do
  echo "Waiting for test server to start..."
  sleep 10
done

ALL_TESTS=( \
  sqlite \
  sqlite-pdo \
# skipped because having a mail server with proper credentials is difficult -.-
# mail \
  mysql \
  mysql-pdo \
  pgsql \
  pgsql-pdo \
  ssl-over-fopen \
  curl \
  gd \
)

FAILED_TESTS=()

for TEST in ${ALL_TESTS[@]}; do
  OUT=$(curl -s $TEST_SERVER?test=$TEST)
  if [ "$?" != "0" ] || [ "$OUT" != "Success" ]; then
    FAILED_TESTS+=("Test $TEST failed with output: $OUT")
  fi
done

if (( ${#FAILED_TESTS[@]} == 0 )); then
  echo "All tests passed!"
else
  for FAIL in "${FAILED_TESTS[@]}"; do
    echo $FAIL
  done
  exit -1
fi
