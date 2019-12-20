TEST_COUNT=3
CURRENT_TEST=0
OUTPUT_FILE="test_output.txt"
BINARY_NAME="./exploring_mars"

if [ ! -f $BINARY_NAME ]; then
    mix escript.build
fi
while [ $TEST_COUNT -gt $CURRENT_TEST ]; do
    echo "Test case ${CURRENT_TEST}:"
    INPUT_FILE="examples/input_${CURRENT_TEST}.txt"
    EXPECTED_OUTPUT="examples/output_${CURRENT_TEST}.txt"
    $BINARY_NAME -f $INPUT_FILE -o $OUTPUT_FILE
    diff $OUTPUT_FILE $EXPECTED_OUTPUT
    [ $? == 0 ] && echo "OK"

    ((CURRENT_TEST++))
done
rm $OUTPUT_FILE
