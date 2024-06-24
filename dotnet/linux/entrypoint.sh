#!/bin/bash
#set -e 

# Wait for CosmosDB to be available, a health check from the container that is connecting to CosmosDB
echo "Waiting for CosmosDB at $COSMOS_HOST:$COSMOS_PORT..."
until [ "$(curl -k -s --connect-timeout 5 -o /dev/null -w "%{http_code}" https://$COSMOS_HOST:${COSMOS_PORT}/_explorer/emulator.pem)" == "200" ]; do
    sleep 5;
    echo "Waiting for CosmosDB at $COSMOS_HOST:$COSMOS_PORT..."
done;
echo "CosmosDB is available."

# Download the CosmosDB Cert and add it to the Trusted Certs
echo "Downloading CosmosDB Cert..."
curl -k https://$COSMOS_HOST:${COSMOS_PORT}/_explorer/emulator.pem > emulatorcert.crt

echo "Adding CosmosDB Cert to Trusted Certs..."
cp emulatorcert.crt /usr/local/share/ca-certificates/
update-ca-certificates

# Run the tests
echo "Running Basic CosmosDB Tests using .NET SDK.."
dotnet ./out/DotNet.Docker.dll