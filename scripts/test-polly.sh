#!/bin/bash
# scripts/test-polly.sh

# Exit immediately if a command exits with a non-zero status
set -e

echo "----------------------------------------------------"
echo "Starting Integration Test: AWS Polly Pipeline"
echo "Input Bucket:  $INPUT_BUCKET"
echo "Output Bucket: $OUTPUT_BUCKET"
echo "----------------------------------------------------"

# Create a unique test file
TEST_FILENAME="test-trigger-$(date +%s)"
echo "This is an automated test for the Polly Text-to-Speech pipeline." > "${TEST_FILENAME}.txt"

# Upload to Input Bucket
echo "Step 1: Uploading text file to S3..."
aws s3 cp "${TEST_FILENAME}.txt" "s3://$INPUT_BUCKET/${TEST_FILENAME}.txt"

# Wait for Processing
# Based on the architecture, S3 triggers Lambda, which calls Polly and writes back to S3.
echo "Step 2: Waiting 20 seconds for Lambda and Polly processing..."
sleep 20

# Verify the Output
echo "Step 3: Checking for generated MP3 in Output Bucket..."
if aws s3 ls "s3://$OUTPUT_BUCKET/${TEST_FILENAME}.mp3"; then
    echo "SUCCESS: Audio file '${TEST_FILENAME}.mp3' found!"

    # Cleanup: Remove test artifacts to keep buckets clean
    echo "Step 4: Cleaning up test files..."
    aws s3 rm "s3://$INPUT_BUCKET/${TEST_FILENAME}.txt"
    aws s3 rm "s3://$OUTPUT_BUCKET/${TEST_FILENAME}.mp3"
    rm "${TEST_FILENAME}.txt"

    echo "Test completed successfully."
    exit 0
else
    echo "ERROR: Audio file was not generated in the expected timeframe."
    exit 1
fi
