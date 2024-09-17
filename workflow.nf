#!/usr/bin/env nextflow

params.input = 'data/*.fastq'
params.sketchdir = 'sketches'
params.kmer = 21
params.pwmat = 'pairwise_matrix'
params.pairwisedir = 'pairwise_results'

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
    publishDir "${params.pairwisedir}", mode: 'copy'

    input:
    path all_sketches

    output:
    path "${params.pwmat}"
    path "${params.pwmat}.labels.txt"

    script:
    """
    sourmash compare ${all_sketches.join(' ')} -o ${params.pwmat}
    """
}


process plot_distmat {
    tag "Plotting distance matrix"
    publishDir "${params.pairwisedir}", mode: 'copy'

    input:
    path pairwise_matrix
    path labels

    output:
    path "${pairwise_matrix}.pdf"

    script:
    """
    python ${projectDir}/plot_distance_matrix.py ${pairwise_matrix} ${pairwise_matrix}.pdf
    """
}


workflow {
    sketches_ch = sketch(samples_ch)
    pw_ch = pairwise_matrix(sketches_ch.collect())
    plot_distmat(pw_ch)
}
