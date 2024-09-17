#!/usr/bin/env nextflow

params.input = 'data/*.fastq'
params.sketchdir = 'sketches'
params.kmer = 21
params.pwmat = 'pairwise_matrix_' + params.kmer

Channel
    .fromFilePairs(params.input, size: 1)
    .set{ samples_ch }

process sketch {
    input:
    set val(sample_id), file(reads) from samples_ch

    output:
    file("${params.sketchdir}/${sample_id}.sketch") into sketches_ch

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
