'use strict';

console.log('Loading function');

var AWS = require('aws-sdk');
AWS.config.update({region: process.env.AWS_REGION});
var ec2 = new AWS.EC2();
var cw = new AWS.CloudWatch();


// Create a generator to split the result to chunks of 20 items
function* chunks(arr, n) {
    for (let i = 0; i < arr.length; i += n) {
      yield arr.slice(i, i + n);
    }
}

/**
 * Checks all subnets in an account for IP address availability, and reports
 * metrics on that availability.
 */
exports.handler = (event, context, callback) => {
    //console.log('Received event:', JSON.stringify(event, null, 2));
    var MetricData = [];

    ec2.describeSubnets({}, function(err,data) {
        if (err) {
            console.log(err, err.stack);
            callback(err, err.stack);
        }
        else {
            console.log("Success { Count:", data['Subnets'].length, "}");
            
            data['Subnets'].forEach(function(subnet) {
                //Available IP Addresses (Count)
                MetricData.push({
                    MetricName: "AvailableIpAddressCount",
                    Dimensions: [
                        {
                            Name: "SubnetId",
                            Value: subnet.SubnetId
                        }
                    ],
                    Unit: 'Count',
                    Value: subnet.AvailableIpAddressCount
                });
                
                var TotalIpAddressCount = Math.pow(2, 32 - parseInt(subnet.CidrBlock.split('/')[1], 10));
                
                //Available IP Addresses (Percent)
                MetricData.push({
                    MetricName: "AvailableIpAddressPercent",
                    Dimensions: [
                        {
                            Name: "SubnetId",
                            Value: subnet.SubnetId
                        }
                    ],
                    Unit: 'Percent',
                    Value: parseFloat(subnet.AvailableIpAddressCount) / parseFloat(TotalIpAddressCount)
                });
                
                // Total IP Addresses (Count)
                MetricData.push({
                    MetricName: "TotalIpAddressCount",
                    Dimensions: [
                        {
                            Name: "SubnetId",
                            Value: subnet.SubnetId
                        }
                    ],
                    Unit: 'Count',
                    Value: TotalIpAddressCount
               });
               
            });
            
            // putMetricData can only accept 20 metrics at a time.
            chunk(MetricData, 20).forEach(function (MetricChunk) {
                cw.putMetricData({Namespace: 'VPC', MetricData: MetricChunk}, function(err, data) {
                    if (err) {
                        console.log(err,err.stack);
                        callback(err, err.stack);

                    }
                    else {
                        console.log("Success", data);
                    }
                });
            });
        }
    });
    
    callback();
};
