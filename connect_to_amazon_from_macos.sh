#!/usr/bin/env bash
ssh -i /Users/thanakijwanavit/scripts/amazonfree.pem -NTC -R 12345:localhost:22 ubuntu@ec2-54-70-87-233.us-west-2.compute.amazonaws.com
