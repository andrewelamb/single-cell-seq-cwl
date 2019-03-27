#!/usr/bin/env cwl-runner
# Author: Andrew lamb

cwlVersion: v1.0
class: Workflow

inputs:

  idquery: string
  sample_query: string
  synapse_config: File
  index_id:
    type: string
    default: "syn18460306"
  reference_genome: string?
  protocol: string?

outputs:


- id: tsv
  type: File
  outputSource: 
  - get-fv/query_result

- id: names
  type: string[]
  outputSource: 
  - get-samples-from-fv/names



requirements:
  - class: SubworkflowFeatureRequirement
  - class: ScatterFeatureRequirement

steps:

- id: get-fv
  run: https://raw.githubusercontent.com/Sage-Bionetworks/synapse-client-cwl-tools/master/synapse-query-tool.cwl
  in:
    synapse_config: synapse_config
    query: idquery
  out: 
  - query_result

- id: get-samples-from-fv
  run: steps/breakdown.cwl
  in:
     query_tsv: get-fv/query_result
  out:
  - names
  - mate1_id_arrays
  - mate2_id_arrays


