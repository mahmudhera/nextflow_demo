#!/usr/bin/env nextflow

params.input = 'data/*.fastq'
params.sketchdir = 'sketches'
params.kmer = 21
params.pwmat = 'pairwise_matrix_' + params.kmer

Channel
    .fromFilePairs(params.input, size: 1)
    .set{ samples_ch }

process sketch {
    tag "Sketch on ${sample_id}"
    publishDir "${params.sketchdir}", mode: 'copy'

    input:
    tuple val(sample_id), path(reads)

    output:
    path "${sample_id}.sketch"

    script:
    // command: fracKmcSketch infilename outfilename --ksize 21 --scaled 1000 --fq --n 8
    """
    fracKmcSketch ${reads} ${sample_id}.sketch --ksize ${params.kmer} --scaled 1000 --fq --n 8
    """
}

workflow {
    sketches_ch = sketch(samples_ch.flatten())
    sketch_ch.view { it }
}
