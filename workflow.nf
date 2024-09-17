#!/usr/bin/env nextflow

params.input = 'data/*.fastq'
params.sketchdir = 'sketches'
params.kmer = 21
params.pwmat = 'pairwise_matrix_' + params.kmer

Channel
    .fromFilePairs(params.input, size: 1)
    .set{ samples_ch }

workflow {
    // show the samples
    samples_ch.view { it }
}
