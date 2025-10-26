#!/bin/bash
echo "=== Deploying Vehicle Tracking System ==="

echo "1. Applying ConfigMaps..."
kubectl apply -f configmap.yaml

echo "2. Applying Databases..."
kubectl apply -f databases.yaml

echo "3. Waiting for databases to be ready..."
sleep 30

echo "4. Checking database status..."
kubectl exec -it deployment/postgres-db -- psql -U postgres -l | grep vehicle_

echo "5. Applying Services..."
kubectl apply -f 02-services.yaml

echo "6. Applying Deployments..."
kubectl apply -f 03-deployments.yaml

echo "7. Deployment complete! Checking status..."
kubectl get pods