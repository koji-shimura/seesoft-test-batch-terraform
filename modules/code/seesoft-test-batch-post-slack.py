#!/usr/bin/python3.13
import json
import boto3
import os
#import requests
import urllib.request
from datetime import datetime, timezone, timedelta

def lambda_handler(event, context):
    slack_webhook_url = os.environ.get("SLACK_WEBHOOK_URL")
    env = os.environ.get("ENVIRONMENT")

    print (event)
    event_detail = event['detail']
    print (event_detail)
    detail_status = event_detail['status']
    print (detail_status)
    
    event_time_utc = event['time']
    event_time_utc = datetime.fromisoformat(event_time_utc[:-1])
    event_time_local = event_time_utc.astimezone(timezone(timedelta(hours=9)))
    print("ローカル時間:", event_time_local)

    if detail_status == 'FAILED':
        message = f"[{env}] The batch job has failed.\n\tTime: {event_time_local}\n\tJobName: {event_detail['jobName']}\n\tJobId: {event_detail['jobId']}"
        print(message)
        
        send_slack_notification(slack_webhook_url, message)

def send_slack_notification(webhook_url, message):
    payload = {
        "text": message
    }

    headers = {
        "Content-Type": "application/json"
    }

    #response = requests.post(webhook_url, data=json.dumps(payload), headers=headers)
    req = urllib.request.Request(webhook_url, json.dumps(payload).encode(), headers)
    try:
        with urllib.request.urlopen(req) as res:
            body = res.read()
    except urllib.error.HTTPError as err:
        print(f"Slack通知の送信に失敗しました。ステータスコード: {err.code}")
    except urllib.error.URLError as err:
        print(f"Slack通知の送信に失敗しました。理由: {err.reason}")
    except Exception as err:
        print(errn)
    else:
        print("Slack通知が正常に送信されました。")
