#!/bin/bash

# Given input array
arr=(-1 2 3 -7 12 -4 0 1 3)

# Initialize variables
max_sum=${arr[0]}
current_sum=${arr[0]}

# Iterate through the array
for ((i = 1; i < ${#arr[@]}; i++)); do
    # Update current_sum
    current_sum=$((current_sum + arr[i]))

    # If current_sum becomes negative, reset it
    if ((current_sum < 0)); then
        current_sum=0
    fi

    # Update max_sum
    if ((current_sum > max_sum)); then
        max_sum=$current_sum
    fi
done

# Print the maximum subarray sum
echo "Maximum subarray sum: $max_sum"
