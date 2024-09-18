# nextflow demo
In this repo, I will do the following task using nextflow. This is an effort to get myself familiarized with nextflow.

## The task
The task is to take in a list of files, then compute fracminhash sketch of the files, and then using all sketches, compute the pairwise distance metric, and generate a plot.

1. Read all files
1. Compute sketches of all files
1. Compute pairwise metric using all sketches, generate a matrix
1. Plot the matrix

## Benchmarking using trace

```
trace {
    enabled = true
    file = 'trace.txt'
}
```

This generates a trace file. After the generation of trace file, it is very easy to parse the csv file and get statistics.