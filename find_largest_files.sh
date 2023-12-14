#!/bin/bash

find_largest_files() {
    echo "Finding the first 10 biggest files in the file system..."
    
    # Use find to locate all files, execute du -h to get their sizes, sort in reverse order, and select the first 10
    find / -type f -exec du -h {} + | sort -rh | head -n 10 > largest_files.txt
    
    echo "Done. Results written to 'largest_files.txt'."
}

# Call the function
find_largest_files
