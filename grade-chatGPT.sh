#!/bin/bash

# Check that the first argument is not empty
rm -rf student-submission
if [ -z "$1" ]; then
  echo "Please provide the command line argument"
  exit 1
fi

# Clone the command line argument to student-submission directory
git clone "$1" student-submission

# Check if list-examples.java exists
if [ ! -f "student-submission/ListExamples.java" ]; then
  echo "Error: ListExamples.java not found"
  exit 1
fi

# Change to the student-submission directory
cd student-submission

# Copy test-list-examples.java from parent directory
cp ../TestListExamples.java .

# Compile all files with junit files in lib
javac -cp ".;../lib/hamcrest-core-1.3.jar;../lib/junit-4.13.2.jar" *.java

# Check if the code compiles
if [ $? -ne 0 ]; then
  echo "Error: Compilation failed"
  exit 1
fi

# Run testListExamples and output result
test_result=$(java -cp ".;../lib/hamcrest-core-1.3.jar;../lib/junit-4.13.2.jar" org.junit.runner.JUnitCore TestListExamples)
passed=$(grep -oP '(Test run: )[0-9]+' test_result)
failed=$(echo "$test_result" | grep -E "^FAILURES\!\!\!$" -A 100 | grep -E "^[0-9]+\) TestListExamples\.[A-Za-z0-9]+ " | wc -l)
total=$((passed+failed))
total=1
echo $passed
grade=$((100*passed/total))

echo "Total tests run: $total"
echo "Tests passed: $passed"
echo "Tests failed: $failed"
echo "Final grade: $grade/100"