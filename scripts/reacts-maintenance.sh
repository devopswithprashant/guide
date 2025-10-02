#!/bin/bash

set -eo pipefail


unzipArtifact() {
    echo "Unzipping artifact to $tempDir"
    unzip -o $tempDir/$zipFileName -d $tempDir
    if [[ $? -ne 0 ]]; then
        echo "Failed to unzip artifact."
        exit 1
    fi
    echo "Artifact unzipped successfully."
}


replaceFiles() {
    echo "Cleaning up target directory $TARGET_DIR"
    rm -rf $TARGET_DIR/*
    if [[ $? -ne 0 ]]; then
        echo "Failed to clean up target directory $TARGET_DIR"
        exit 1
    fi

    echo "Replacing files in $TARGET_DIR with new artifact files"
    cp -r $tempDir/blog-$artifactVersion/* $TARGET_DIR
    if [[ $? -ne 0 ]]; then
        echo "Failed to copy files to $TARGET_DIR"
        exit 1
    fi
    echo "Files replaced successfully."
}


refreshService() {
    echo "Refreshing service to apply new changes"
    # Add commands to refresh/restart the service if needed
    sudo systemctl daemon-reload
    sudo systemctl restart nginx
    if [[ $? -ne 0 ]]; then
        echo "Failed to refresh/restart the service"
        exit 1
    fi
    echo "Service refreshed successfully."
}





################################### Main Script ###################################


artifactVersion=$1
TARGET_DIR=$2
JOB_ID=$3
zipFileName="app.zip"
tempDir="/tmp/$JOB_ID"


unzipArtifact
replaceFiles
refreshService

