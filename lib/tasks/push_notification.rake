# -*- encoding: utf-8 -*-
ACCESS_KEY = 'your-aws-access-key'
SECRET_KEY = 'your-aws-secret-key'
SQS_ENDPOINT = 'sqs.ap-southeast-1.amazonaws.com' #使用しているリージョンにあわせて変更
SNS_REGION = 'ap-southeast-1' #使用しているリージョンにあわせて変更
QUEUE_NAME = 'SampleQueue' #SQSで設定したキューの名前
SNS_APPLICATION_ARN =  "arn:aws:sns:ap-southeast-1:xxxxxxx:app/GCM/Sample"

namespace :batch do
  desc 'SQSにキューを登録する'
  task :register_queue => :environment do
    sqs = AWS::SQS.new(
     :access_key_id => ACCESS_KEY,
     :secret_access_key => SECRET_KEY,
     :sqs_endpoint => SQS_ENDPOINT
    ).client
    queue_url = sqs.get_queue_url(:queue_name => QUEUE_NAME)[:queue_url]
    PushNotification.waiting.each do | notification|
      message = {:id => notification.id, :token => notification.token, :message => notification.message}.to_json
      sqs.send_message(:queue_url => queue_url, :message_body => message)
      notification.status = PushNotification::REGISTERED
      notification.save
    end
  end

  desc 'SQSからキューを取り出し、SNSでプッシュ通知を配信する'
  task :broadcast => :environment do
    sqs = AWS::SQS.new(
      :access_key_id => ACCESS_KEY,
      :secret_access_key => SECRET_KEY,
      :sqs_endpoint => SQS_ENDPOINT
    ).client
    queue_url = sqs.get_queue_url(:queue_name => QUEUE_NAME)[:queue_url]
    messages = sqs.receive_message(:queue_url => queue_url)[:messages]
    messages.each do |message|
       json = JSON.parse(message[:body])
       broadcast_via_sns json
    end
  end

end


def broadcast_via_sns json
  sns = AWS::SNS.new(
    :access_key_id => ACCESS_KEY,
    :secret_access_key => SECRET_KEY,
    :region => SNS_REGION
  )
  client = sns.client
  response = client.create_platform_endpoint(
    :platform_application_arn => SNS_APPLICATION_ARN,
    :token => json["token"]
    )
  endpoint_arn = response[:endpoint_arn]
  client.publish(:target_arn => endpoint_arn, :message => json["message"])
  notification = PushNotification.find_by_id json["id"]
  notification.status = PushNotification::DELIVERED
  notification.save
end



