# aws credentials must be stored in ~/.aws/credentials

# stage determination
if [[ "$1" == "staging" ]]; then
  lambda_name='my_menu_callbacks_lambda_staging'
elif [[ "$1" == "production" ]]; then
  read -p "Type 'i_am_deploying_to_production' to deploy to production: " text
  if [[ "$text" == "i_am_deploying_to_production" ]]; then
    lambda_name='my_menu_callbacks_lambda'
  else
    echo 'wrong input. Aborting...'
    exit
  fi
else
  echo 'Invalid stage name. Possible options: staging, production'
  echo 'Usage: ./deploy staging OR ./deploy production'
  exit
fi

echo 'Compressing files...'
zip -r function.zip lambda_function.rb services vendor > /dev/null
echo "Deploying to $1 ..."
aws lambda update-function-code --function-name "$lambda_name" --zip-file fileb://function.zip
rm function.zip > /dev/null
echo 'Completed!'
