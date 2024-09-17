#!/usr/bin/env nextflow

params.input = 'data/*.fastq'
params.sketchdir = 'sketches'
params.kmer = 21
params.pwmat = 'pairwise_matrix'
params.paiwisedir = 'pairwise_results'

Channel
    .fromFilePairs(params.input, size: 1)
    .set{ samples_ch }

process sketch {
    tag "Sketch on ${sample_id}"
    publishDir params.sketchdir, mode: 'copy'

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

process pairwise_matrix {
    tag "Pairwise matrix on all sketches"
    publishDir params.pairwisedir, mode: 'copy'

    input:
    path all_sketches

    output:
    path "${params.pwmat}"

    script:
    """
    sourmash compare ${all_sketches.join(' ')} -o ${params.pwmat}
    """
}

workflow {
    sketches_ch = sketch(samples_ch)
    pairwise_matrix(sketches_ch.collect())
}
