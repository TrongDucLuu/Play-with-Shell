#!/bin/bash

# Function to monitor system resources
monitor_resources() {
    # Set thresholds
    CPU_THRESHOLD=90
    MEMORY_THRESHOLD=90
    DISK_THRESHOLD=90

    # Get current date and time
    TIMESTAMP=$(date +"%Y-%m-%d %H:%M:%S")

    #--- Get system resource usage Unix
    #CPU_USAGE=$(top -b -n 1 | awk '/^%Cpu/{print $2}' | cut -d. -f1)
    #MEMORY_USAGE=$(free | awk '/Mem/{printf "%.2f", $3/$2*100}')
    #DISK_USAGE=$(df -h / | awk 'NR==2{print $5}' | cut -d% -f1)
    
    # Get system resource usage Mac

    CPU_USAGE=$(top -l 1 | grep "CPU usage" | awk '{print $3}' | cut -d% -f1)
    MEMORY_USAGE=$(vm_stat | awk '/free|inactive/{getline; print $3*4096/1024^2}' | xargs printf "%.2f")
    DISK_USAGE=$(df -h / | awk 'NR==2{print $5}' | cut -d% -f1)

    # Output to a file in table format
    echo -e "Timestamp\tCPU Usage (%)\tMemory Usage (%)\tDisk Usage (%)" >> resource_usage.txt
    echo -e "$TIMESTAMP\t$CPU_USAGE\t\t$MEMORY_USAGE\t\t$DISK_USAGE" >> resource_usage.txt

    # Check if any resource exceeds the threshold
    if [ "$CPU_USAGE" -gt "$CPU_THRESHOLD" ]; then
        echo "Alert: CPU usage exceeds threshold! Current CPU usage: $CPU_USAGE%" >> alerts.txt
    fi

    if [ "$MEMORY_USAGE" -gt "$MEMORY_THRESHOLD" ]; then
        echo "Alert: Memory usage exceeds threshold! Current Memory usage: $MEMORY_USAGE%" >> alerts.txt
    fi

    if [ "$DISK_USAGE" -gt "$DISK_THRESHOLD" ]; then
        echo "Alert: Disk usage exceeds threshold! Current Disk usage: $DISK_USAGE%" >> alerts.txt
    fi
}

# Call the function
monitor_resources
