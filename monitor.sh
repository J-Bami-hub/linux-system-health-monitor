#!/bin/bash

# Report configuration
REPORT_DIR="$HOME/linux-system-health-monitor/reports"
TIMESTAMP=$(date +"%Y-%m-%d_%H%M%S")
REPORT_FILE="$REPORT_DIR/health_report_$TIMESTAMP.txt"

mkdir -p "$REPORT_DIR"

#Save terminal output to a report file while displaying it
exec > >(tee "$REPORT_FILE") 2>&1

#
==========================================
# LINUX SYSTEM HEALTH MONITOR
# Version: 1.0
# Description: Displays basic system health
#
==========================================

echo
"========================================="
echo " LINUX SYSTEM HEALTH MONITOR"
echo
"========================================="
echo

# 1. Hostname
echo "[SYSTEM INFORMATION]"
echo "Hostname: $(hostname)"

# 2. Operating System
if [ -f /etc/os-release ]; then
   . /etc/os-release
   echo "Operating System: $PRETTY_NAME"
fi

echo

# 3. System Uptime
echo "[SYSTEM UPTIME]"
uptime -p

echo

# 4. CPU Information
echo "[CPU INFORMATION]"
echo "CPU Architecture: $(uname -m)"
echo "CPU Cores: $(nproc)"

echo

# 5. Memory Usage
echo "[MEMORY USAGE]"
free -h


echo
echo "[MEMORY HEALTH CHECK]"

MEMORY_USAGE=$(free | awk '/Mem:/ {printf
"%.Of", $3/$2 * 100}')

if [ "$MEMORY_USAGE" -ge 90 ]; then
    echo "CRITICAL: Memory usage is ${MEMORY_USAGE}%!"
elif [ "$MEMORY_USAGE" -ge 80 ]; then
    echo "WARNING: Memory usage is ${MEMORY_USAGE}%."
else
    echo "HEALTHY: Memory usage is ${MEMORY_USAGE}%."
fi

echo

# 6. Disk Usage
echo "[DISK USAGE]"
df -h /


echo
echo "[DISK HEALTH CHECK]"

DISK_USAGE=$(df / | awk 'NR==2
{gsub("%","",$5); print $5}')

if [ "$DISK_USAGE" -ge 90 ]; then
    echo "CRITICAL: Disk usage is ${DISK_USAGE}%!"
elif [ "$DISK_USAGE" -ge 80 ]; then
    echo "WARNING: Disk usage is ${DISK_USAGE}%."
else
    echo "HEALTHY: Disk usage is ${DISK_USAGE}%."
fi

echo

# 7. Top Five Memory-Consuming Processes
echo "[TOP 5 MEMORY-CONSUMING PROCESSES]"
ps -eo pid,comm,%mem,%cpu --sort=-%mem |
head -n 6

echo
echo
"=========================================="
echo " SYSTEM REPORT COMPLETE"
echo
"=========================================="
