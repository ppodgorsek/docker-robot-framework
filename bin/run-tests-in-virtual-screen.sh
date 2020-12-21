#!/bin/sh

HOME=${ROBOT_WORK_DIR}

if [ "${ROBOT_TEST_RUN_ID}" = "" ]
then
    ROBOT_REPORTS_FINAL_DIR="${ROBOT_REPORTS_DIR}"
else
    REPORTS_DIR_HAS_TRAILING_SLASH=`echo ${ROBOT_REPORTS_DIR} | grep '/$'`

    if [ ${REPORTS_DIR_HAS_TRAILING_SLASH} -eq 0 ]
    then
        ROBOT_REPORTS_FINAL_DIR="${ROBOT_REPORTS_DIR}${ROBOT_TEST_RUN_ID}"
    else
        ROBOT_REPORTS_FINAL_DIR="${ROBOT_REPORTS_DIR}/${ROBOT_TEST_RUN_ID}"
    fi
fi

# Ensure the output folder exists
mkdir -p ${ROBOT_REPORTS_FINAL_DIR}

# No need for the overhead of Pabot if no parallelisation is required
if [ $ROBOT_THREADS -eq 1 ]
then
    xvfb-run \
        --server-args="-screen 0 ${SCREEN_WIDTH}x${SCREEN_HEIGHT}x${SCREEN_COLOUR_DEPTH} -ac" \
        robot \
        --outputDir $ROBOT_REPORTS_FINAL_DIR \
        ${ROBOT_OPTIONS} \
        $ROBOT_TESTS_DIR
else
    xvfb-run \
        --server-args="-screen 0 ${SCREEN_WIDTH}x${SCREEN_HEIGHT}x${SCREEN_COLOUR_DEPTH} -ac" \
        pabot \
        --verbose \
        --processes $ROBOT_THREADS \
        ${PABOT_OPTIONS} \
        --outputDir $ROBOT_REPORTS_FINAL_DIR \
        ${ROBOT_OPTIONS} \
        $ROBOT_TESTS_DIR
fi

if [ ${AWS_UPLOAD_TO_S3} = true ]
then
    echo "Uploading report to AWS S3..."
    aws s3 sync $ROBOT_REPORTS_FINAL_DIR/ s3://${AWS_BUCKET_NAME}/robot-reports/
    echo "Reports have been successfully uploaded to AWS S3!"
fi
