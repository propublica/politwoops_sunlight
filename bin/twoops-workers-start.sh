#!/bin/bash

# export LD_LIBRARY_PATH=/projects/twoops/phantomjs/lib:$LD_LIBRARY_PATH

cd  /projects/twoops/politwoops-twitter-client
nohup ./bin/politwoops-worker.py -v -i > politwoops-worker.out
