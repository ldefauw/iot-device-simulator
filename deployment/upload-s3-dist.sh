#!/bin/bash
#
# This script uploads all assets needed to run iot-device-simulator to the S3 bucket.
#
# This script should be run from the repo's deployment directory
# cd deployment
# ./build-s3-dist.sh source-bucket-base-name solution-name version-code
#
# Parameters:
#  - source-bucket-base-name: Name for the S3 bucket location where the template will source the Lambda
#    code from. The template will append '-[region_name]' to this bucket name.
# - The template will then expect the source code to be located in the solutions-[region_name] bucket
#  - solution-name: name of the solution, needed due to naming convention of many components
#  - version-code: version of the package

# Check to see if input has been provided:
if [ -z "$1" ] || [ -z "$2" ] || [ -z "$3" ] || [ -z "$4" ]; then
  echo "USAGE: $0 \$DIST_BUCKET_PREFIX \$SOLUTION_NAME \$VERSION \$REGION "
  echo "For example: $0 my-solutions my-solution-name v1.0.0 us-east-1"
  exit 1
fi

# Set needed variables
template_dir="$PWD"
template_dist_dir="$template_dir/global-s3-assets"
build_dist_dir="$template_dir/regional-s3-assets"
s3_key_prefix_uri="s3://$1-$4/$2/$3/"
template_dist_url="https://$1-$4.s3.amazonaws.com/$2/$3/iot-device-simulator.template"

echo "------------------------------------------------------------------------------"
echo "Uploading Regional Assets to S3"
echo "$s3_key_prefix_uri"
echo "------------------------------------------------------------------------------"
aws s3 cp ./regional-s3-assets/ $s3_key_prefix_uri --recursive --acl bucket-owner-full-control

echo -e "\n"
echo "------------------------------------------------------------------------------"
echo "Uploading Cloudformation Template to S3"
echo "$s3_key_prefix_uri"
echo "------------------------------------------------------------------------------"
aws s3 cp ./global-s3-assets/iot-device-simulator.template $s3_key_prefix_uri

echo -e "\n"

echo -e "To deploy the simulator, create a Cloudformation stack using the following template:\n"
echo $template_dist_url

echo -e "\n"