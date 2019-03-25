  download_index:
    run: https://raw.githubusercontent.com/Sage-Bionetworks/synapse-client-cwl-tools/master/synapse-get-tool.cwl
    in:
      synapseid: index_id
      synapse_config: synapse_config
    out: [filepath]  

   untar_index:
    run: steps/untar.cwl
    in:
      tar_file: download_index/filepath
    out: [dir]