label: breakdownfile-tool
id: breakdownfile-tool
cwlVersion: v1.0


class: CommandLineTool
baseCommand: 
- python 
- breakdownfiles.py


requirements:
 - class: InlineJavascriptRequirement
 - class: DockerRequirement
   dockerPull: amancevice/pandas
 - class: InitialWorkDirRequirement
   listing:
     - entryname: breakdownfiles.py
       entry: |
         #!/usr/bin/env python
         import json
         import sys
         import pandas as pd
         fname=sys.argv[1]
         res = pd.read_csv(fname,delimiter='\t')
         gdf = res.groupby('specimenID')
         mate1ids = []
         mate2ids = []
         for key,value in gdf:
            rps = gdf.get_group(key).groupby('readPair')
            g1=[i for i in rps.get_group(1)['id']][0]
            g2=[i for i in rps.get_group(2)['id']][0]
            mate1ids.append(g1)
            mate2ids.append(g2)
         allspecs=set(res['specimenID'])
         res={'specimens':list(allspecs), 'mate1ids':mate1ids,'mate2ids': mate2ids}
         with open('cwl.json','w') as outfile:
           json.dump(res,outfile)


inputs:

- id: fileName
  type: File
  inputBinding:
    position: 1

outputs:

- id: specIds
  type: string[]
  outputBinding:
    glob: cwl.json
    loadContents: true
    outputEval: $(JSON.parse(self[0].contents)['specimens'])

- id: mate1ids
  type: string[]
  outputBinding:
    glob: cwl.json
    loadContents: true
    outputEval: $(JSON.parse(self[0].contents)['mate1ids'])

- id: mate2ids
  type: string[]
  outputBinding:
    glob: cwl.json
    loadContents: true
    outputEval: $(JSON.parse(self[0].contents)['mate2ids'])
