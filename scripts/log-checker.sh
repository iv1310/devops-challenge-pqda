#!/usr/bin/env bash

set -e

# Colors
GREEN='\033[0;32m'
RED='\033[0;31m'
NC='\033[0m' # No Color

usage() {
    echo -e "${GREEN}Usage: $0 [-f <log_filename>]"
    echo -e "Options:"
    echo -e "  -f  LOG_FILENAME     Set the log filename with absolute path."
    echo -e "  -h                   Show this help message${NC}"
    exit 0
}

# Parse command line options
while getopts ":f:h" opt; do
    case ${opt} in
        f)
            LOG_FILENAME=$OPTARG
            ;;
        h)
            usage
            ;;
        \?)
            echo -e "${RED}[!] Invalid option: $OPTARG.........${NC}" >&2
            usage
            ;;
    esac
done
shift $((OPTIND -1))

if [ "$OPTIND" -eq 1 ]; then
    echo -e "${RED}[!] No log_filename assigned.${NC}"
    usage
fi

sleep 1

if test -f "$LOG_FILENAME"; then
    echo -e "${GREEN}[+] File exists '${LOG_FILENAME}'...............${NC}"
else
    echo -e "${RED}[!] File doesn't exist '${LOG_FILENAME}'................${NC}"
    exit 1
fi

sleep 1

IP_COUNTS=$(grep -oE "\b([0-9]{1,3}\.){3}[0-9]{1,3}\b" "$LOG_FILENAME" | sort | uniq -c | sort -nr)

sleep 1

# Print the table header
printf "\033[1m%-15s | %s\033[0m\n" "IP Address" "Frequency"
echo "-----------------------------"

# Loop through each line of the ip_counts variable and parse into table
while IFS= read -r line; do
    IP=$(echo "$line" | awk '{print $2}')
    FREQ=$(echo "$line" | awk '{print $1}')
    printf "%-15s | %s \n" "$IP" "$FREQ"
done <<< "$IP_COUNTS"

echo "-----------------------------"
