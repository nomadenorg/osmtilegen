import boto3
import datetime
import json

client = boto3.client('ec2')

launch_data = open('spot-spec.json').read()
launch_spec = json.loads(launch_data)

response = client.request_spot_instances(
    DryRun=False,
    InstanceCount=1,
    Type='one-time',
    LaunchSpecification=launch_spec
)

sir = response['SpotInstanceRequests'][0]['SpotInstanceRequestId']

waiter = client.get_waiter('spot_instance_request_fulfilled')

waiter.wait(SpotInstanceRequestIds=[sir])

result = client.describe_spot_instance_requests(SpotInstanceRequestIds=[sir])

instance_id = result['SpotInstanceRequests'][0]['InstanceId']

ires = client.describe_instances(InstanceIds=[instance_id])

print(ires['Reservations'][0]['Instances'][0]['PublicDnsName'])
