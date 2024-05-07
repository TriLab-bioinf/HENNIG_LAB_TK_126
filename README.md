### HENNIG_LAB_TK_126

*input.txt* file contains the full-path to the input fastq files

#### START THE SWARM JOB (2hr/sample)

```
swarm -f run.swarm -t 40 -g 60 --time 2:00:00
```

#### IF YOU WANT TO CHANGE THE RUNTIME

```
type: newwall --jobid JOBID --time 24:00:00
```

