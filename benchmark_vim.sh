#!/bin/zsh

# Benchmark script for Vim file opening performance

echo "=== Vim File Opening Benchmark ==="
echo ""

# Test 1: Opening a new file with :tabe
echo "Test 1: Opening new file with :tabe"
for i in {1..5}; do
    /usr/bin/time -p vim --startuptime /tmp/startup_$i.log \
        -c "tabe /tmp/newfile_test_$RANDOM.py" \
        -c "q!" \
        2>&1 | grep real | awk '{print "  Run '$i': " $2 " seconds"}'
done

# Calculate average from startup logs
echo ""
echo "Detailed timing from last run:"
tail -1 /tmp/startup_5.log | awk '{print "  Total time: " $1/1000 " seconds"}'
grep "first screen update" /tmp/startup_5.log | awk '{print "  First screen update: " $2/1000 " seconds"}'

echo ""
echo "Test 2: Opening existing file with :tabe"
echo "test content" > /tmp/existing_test.py
for i in {1..5}; do
    /usr/bin/time -p vim --startuptime /tmp/startup_exist_$i.log \
        -c "tabe /tmp/existing_test.py" \
        -c "q!" \
        2>&1 | grep real | awk '{print "  Run '$i': " $2 " seconds"}'
done

echo ""
echo "Detailed timing from last run:"
tail -1 /tmp/startup_exist_5.log | awk '{print "  Total time: " $1/1000 " seconds"}'
grep "first screen update" /tmp/startup_exist_5.log | awk '{print "  First screen update: " $2/1000 " seconds"}'

# Cleanup
rm -f /tmp/newfile_test_*.py /tmp/existing_test.py /tmp/startup*.log

echo ""
echo "=== Benchmark Complete ==="
