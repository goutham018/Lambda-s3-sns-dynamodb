
import boto3
import os
from datetime import datetime

dynamodb = boto3.resource('dynamodb')
sns = boto3.client('sns')

table = dynamodb.Table(os.environ['DDB_TABLE'])

def lambda_handler(event, context):
    record = event['Records'][0]
    bucket = record['s3']['bucket']['name']
    key = record['s3']['object']['key']
    timestamp = datetime.utcnow().isoformat()

    # Log to DynamoDB
    table.put_item(Item={
        'FileName': key,
        'Bucket': bucket,
        'Timestamp': timestamp
    })

    # Publish to SNS
    message = f"A file named '{key}' was uploaded to bucket '{bucket}' at {timestamp}."
    sns.publish(
        TopicArn=os.environ['SNS_TOPIC_ARN'],
        Message=message,
        Subject="New File Uploaded"
    )

    return {
        'statusCode': 200,
        'body': 'Logged to DynamoDB and SNS notification sent.'
    }
