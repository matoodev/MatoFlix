#!/bin/bash
cd "$(dirname "$0")"
echo "=== MatoFlix Debug Terminal ==="
echo "Build: $(date)"
echo ""
./MatoFlix.app/Contents/MacOS/MatoFlix 2>&1
EXIT_CODE=$?
echo ""
if [ $EXIT_CODE -eq 0 ]; then
    echo "--- App closed normally (exit code 0) ---"
else
    echo "--- App CRASHED with exit code $EXIT_CODE ---"
fi
echo "Press Enter to close this window."
read
