#!/bin/bash -xe
yum update -y
yum install wget git -y
amazon-linux-extras install docker -y
service docker start
usermod -a -G docker ec2-user