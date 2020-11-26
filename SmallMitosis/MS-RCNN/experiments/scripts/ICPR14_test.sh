#!/bin/bash
# Usage:
# ./experiments/scripts/faster_rcnn_end2end_test_14.sh GPU NET DATASET [options args to {train,test}_net.py]

set -x
set -e

export PYTHONUNBUFFERED="True"

GPU_ID=$1
NET=$2
NET_lc=${NET,,}
DATASET=$3

array=( $@ )
len=${#array[@]}
EXTRA_ARGS=${array[@]:3:$len}
EXTRA_ARGS_SLUG=${EXTRA_ARGS// /_}

case $DATASET in
    ICPR12)
    TRAIN_IMDB="ICPR_2012_train"
    TEST_IMDB="ICPR_2012_test"
    PT_DIR="ICPR12"
    ITERS=150000
    ;;
  ICPR14)
    TRAIN_IMDB="ICPR_2014_train"
    TEST_IMDB="ICPR_2014_test"
    PT_DIR="ICPR14"
    ITERS=150000
    ;;
  AMIDA13)
    TRAIN_IMDB="AMIDA_2013_train"
    TEST_IMDB="AMIDA_2013_test"
    PT_DIR="AMIDA13"
    ITERS=150000
    ;;
  *)
    echo "No dataset given"
    exit
    ;;
esac

LOG="experiments/logs/faster_rcnn_end2end_${NET}_${EXTRA_ARGS_SLUG}.txt.`date +'%Y-%m-%d_%H-%M-%S'`"
exec &> >(tee -a "$LOG")
echo Logging output to "$LOG"
set +x
set -x
NET_FINAL="output/ICPR14.caffemodel"

time ./tools/test_net.py --gpu ${GPU_ID} \
  --def models/${PT_DIR}/${NET}/ICPR14/test.prototxt \
  --net ${NET_FINAL} \
  --imdb ${TEST_IMDB} \
  --cfg experiments/cfgs/ICPR14.yml \
  ${EXTRA_ARGS}
