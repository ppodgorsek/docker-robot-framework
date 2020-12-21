#!/bin/sh

HOME=${ROBOT_WORK_DIR}

if [ "${ROBOT_TEST_RUN_ID}" = "" ]
then
    ROBOT_REPORTS_FINAL_DIR="${ROBOT_REPORTS_DIR}/"
else
    ROBOT_REPORTS_FINAL_DIR="${ROBOT_REPORTS_DIR}/${ROBOT_TEST_RUN_ID}/"
fi

# No need for the overhead of Pabot if no parallelisation is required
if [ $ROBOT_THREADS -eq 1 ]
then
    xvfb-run \
        --server-args="-screen 0 ${SCREEN_WIDTH}x${SCREEN_HEIGHT}x${SCREEN_COLOUR_DEPTH} -ac" \
        robot \
        --outputDir $ROBOT_REPORTS_DIR \
        ${ROBOT_OPTIONS} \
        $ROBOT_TESTS_DIR
else
    xvfb-run \
        --server-args="-screen 0 ${SCREEN_WIDTH}x${SCREEN_HEIGHT}x${SCREEN_COLOUR_DEPTH} -ac" \
        pabot \
        --verbose \
        --processes $ROBOT_THREADS \
        ${PABOT_OPTIONS} \
        --outputDir $ROBOT_REPORTS_DIR \
        ${ROBOT_OPTIONS} \
        $ROBOT_TESTS_DIR
fi

if [ ${UPLOAD_TO_S3} = true ] ; then
    upload_s3
fi
