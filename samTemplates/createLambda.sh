sam package \
  --template-file template.yml \
  --output-template-file package.yml \
  --s3-bucket my-bucket

sam deploy \
  --template-file package.yml \
  --stack-name my-sam-application \
  --capabilities CAPABILITY_IAM

aws lambda create-function \
        --function-name udacityMetric \
          --runtime nodejs8.10 \
          --role arn:aws:iam::277726656832:role/service-role/lambda_basic_execution \
          --handler handler \
          --code index.js
