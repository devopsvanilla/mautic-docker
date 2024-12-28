#!/usr/bin/env bash
# This script monitors the change to the definitions of Cron absent in the official images of MAUTIC in the docker hub

# Fail on error
#set -e
#set -o pipefail

# Replace these lines
apt-get update
apt-get install inotify-tools


# Default jobs path
JOBS_PATH="/opt/mautic/cron"

# Initialize empty JOBS_LIST array
JOBS_LIST=()

# Function to show usage
usage() {
    echo "Usage: $0 [-j job_path] ... "
    echo "Example: $0 -j /opt/mautic/cron/mautic-geoipupdate -j /opt/mautic/cron/mautic-import"
    exit 1
}

# Parse command line arguments
while getopts "j:h" opt; do
    case $opt in
        j)
            JOBS_LIST+=("$OPTARG")
            ;;
        h)
            usage
            ;;
        \?)
            echo "Invalid option: -$OPTARG" >&2
            usage
            ;;
    esac
done

# If no jobs specified, use default jobs
if [ ${#JOBS_LIST[@]} -eq 0 ]; then
    JOBS_LIST=("${JOBS_PATH}/mautic-geoipupdate" "${JOBS_PATH}/mautic-import")
    echo "No jobs specified, using default jobs:"
    printf '%s\n' "${JOBS_LIST[@]}"
fi

# Create the monitor script
cat << 'EOF' > /opt/mautic/monitor_crontab.sh
#!/bin/bash

# Get the jobs list from arguments
JOBS_LIST=("$@")

# Verify if there are jobs to monitor
if [ ${#JOBS_LIST[@]} -eq 0 ]; then
    echo "Error: No jobs to monitor"
    exit 1
fi

echo "Starting monitoring for the following jobs:"
printf '%s\n' "${JOBS_LIST[@]}"

while inotifywait -e modify,create,delete,move "${JOBS_LIST[@]}"; do
    for job_file in "${JOBS_LIST[@]}"; do
        if [ -r "$job_file" ]; then
            crontab "$job_file"
            echo "Crontab updated successfully from $job_file at $(date)"
        else
            echo "Error: Cannot read crontab file: $job_file"
        fi
    done
done
EOF

# Make the script executable
chmod +x /opt/mautic/monitor_crontab.sh

# Start the monitoring script in background with the specified jobs
/opt/mautic/monitor_crontab.sh "${JOBS_LIST[@]}" &
