#!/bin/bash
echo "=====:: Icebox Docker ::====="
# Sample usage:  docker run -v "$(PWD)":/app  -e t=@login -it kryptonite
echo $t
ls
export RUBYOPT="-W0"
bundle install
bundle exec rake icebox:parallel_run
TEST_EXIT_CODE=$?
if [ $TEST_EXIT_CODE -ne 0 ]
then
  echo "icebox failed!"
  echo $TEST_EXIT_CODE
  exit 1
fi