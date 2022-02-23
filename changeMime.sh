BUCKETNAME="villa-remove-bg-output"
aws s3 cp s3://${BUCKETNAME}/ s3://${BUCKETNAME}/ --recursive --content-type="image/png" --no-guess-mime-type --metadata-directive="REPLACE"
