#################################
### START THE SWARM JOB (2hr/sample)
#################################

dos2unix run.swarm
dos2unix adapters.txt
dos2unix input.txt
dos2unix all-steps-mm10.sh
dos2unix step-01-fastqc.sh
dos2unix step-02-trimming.sh
dos2unix step-03-mapping.sh
dos2unix step-04-htseq.sh
dos2unix parameters-mm10

swarm -f run.swarm -t 40 -g 60 --time 2:00:00


#################################
### IF YOU WANT TO CHANGE THE RUNTIME
#################################

type: newwall --jobid JOBID --time 24:00:00



#####check the processing
less swarm_21082325_0.e




