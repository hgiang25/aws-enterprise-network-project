#!/usr/bin/env bash
set -euo pipefail

: "${AWS_REGION:=ap-southeast-1}"
: "${PROJECT:=aws-enterprise-network}"
: "${DEPLOYMENT:=aws}"

echo "Checking enterprise network readiness..."
echo "Region: ${AWS_REGION}"
echo "Project: ${PROJECT}"
echo "Deployment: ${DEPLOYMENT}"

echo "Checking VPCs..."
VPC_COUNT=$(aws ec2 describe-vpcs   --region "${AWS_REGION}"   --filters "Name=tag:Project,Values=${PROJECT}" "Name=tag:Deployment,Values=${DEPLOYMENT}"   --query 'length(Vpcs)'   --output text)

if [ "${VPC_COUNT}" -lt 3 ]; then
  echo "Expected at least 3 VPCs, found ${VPC_COUNT}."
  exit 1
fi

echo "Checking Transit Gateway..."
TGW_COUNT=$(aws ec2 describe-transit-gateways   --region "${AWS_REGION}"   --filters "Name=tag:Project,Values=${PROJECT}" "Name=tag:Deployment,Values=${DEPLOYMENT}"   --query 'length(TransitGateways)'   --output text)

if [ "${TGW_COUNT}" -lt 1 ]; then
  echo "Expected at least 1 Transit Gateway, found ${TGW_COUNT}."
  exit 1
fi

echo "Checking Transit Gateway attachments..."
ATTACHMENT_COUNT=$(aws ec2 describe-transit-gateway-attachments   --region "${AWS_REGION}"   --filters "Name=tag:Project,Values=${PROJECT}" "Name=tag:Deployment,Values=${DEPLOYMENT}"   --query 'length(TransitGatewayAttachments)'   --output text)

if [ "${ATTACHMENT_COUNT}" -lt 3 ]; then
  echo "Expected at least 3 TGW attachments, found ${ATTACHMENT_COUNT}."
  exit 1
fi

echo "Checking NAT Gateways..."
NAT_COUNT=$(aws ec2 describe-nat-gateways   --region "${AWS_REGION}"   --filter "Name=tag:Project,Values=${PROJECT}" "Name=tag:Deployment,Values=${DEPLOYMENT}"   --query 'length(NatGateways[?State==`available`])'   --output text)

if [ "${NAT_COUNT}" -lt 1 ]; then
  echo "Expected at least 1 available NAT Gateway, found ${NAT_COUNT}."
  exit 1
fi

echo "Checking VPC Flow Logs..."
FLOW_LOG_COUNT=$(aws ec2 describe-flow-logs   --region "${AWS_REGION}"   --filter "Name=tag:Project,Values=${PROJECT}" "Name=tag:Deployment,Values=${DEPLOYMENT}"   --query 'length(FlowLogs)'   --output text)

if [ "${FLOW_LOG_COUNT}" -lt 3 ]; then
  echo "Expected at least 3 VPC Flow Logs, found ${FLOW_LOG_COUNT}."
  exit 1
fi

echo "Enterprise network readiness checks passed."
