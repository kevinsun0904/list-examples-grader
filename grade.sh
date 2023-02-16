CPATH='".;../lib/hamcrest-core-1.3.jar;../lib/junit-4.13.2.jar"'

rm -rf student-submission
git clone $1 student-submission
echo 'Finished cloning'

cd student-submission
if [[ -f ListExamples.java ]]
then
  echo "student submission found"
else
  echo "wrong file submitted"
  exit 1
fi


cp ../TestListExamples.java ./
javac -cp ".;../lib/hamcrest-core-1.3.jar;../lib/junit-4.13.2.jar" *.java 2>compiler-error.txt

if [[ $? == 0 ]]
then
  echo "successfully compiled"
else
  echo "compiler error"
  exit 1
fi

java -cp ".;../lib/hamcrest-core-1.3.jar;../lib/junit-4.13.2.jar" org.junit.runner.JUnitCore TestListExamples>results.txt 2>&1
if [[ $? == 0 ]]
then
  echo "tests passed"
  cat results.txt
else
  echo "tests failed"
  cat results.txt
  exit 1
fi