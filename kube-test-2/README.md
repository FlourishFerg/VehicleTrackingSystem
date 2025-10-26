## 🚀 **Quick Deployment Commands**

### Step 1: Clean Up (if needed)
```bash
kubectl delete all --all
kubectl delete pvc --all
kubectl delete configmaps --all
```

### Step 2: Deploy in Order
```bash
# 1. ConfigMaps first
kubectl apply -f configmap.yaml

# 2. Databases second
kubectl apply -f databases.yaml

# 3. Wait for databases to be READY
kubectl get pods -w
```
**Wait until you see both:**
```
postgres-db-xxx     1/1     Running   0          2m
mongo-logging-xxx   1/1     Running   0          2m
```
**Then press `Ctrl+C`**

### Step 3: Verify Databases
```bash
# Check if databases were created
kubectl exec -it deployment/postgres-db -- psql -U postgres -c "\l"
```
**You should see your 3 databases in the list**

### Step 4: Continue Deployment
```bash
# 4. Services
kubectl apply -f services.yaml

# 5. Deployments (your Spring Boot apps)
kubectl apply -f deployments.yaml
```

### Step 5: Wait for Everything to Start
```bash
# Watch all services come up
kubectl get pods -w
```
**Wait until ALL pods show "Running":**
- api-gateway-xxx
- auth-service-xxx  
- dispatch-service-xxx
- vehicle-service-xxx
- logging-service-xxx
- postgres-db-xxx
- mongo-logging-xxx

**Press `Ctrl+C` when all are Running**

## 🌐 **Access Your Application**

### Method 1: Port Forwarding (Recommended)
```bash
# Run this in a separate terminal and KEEP IT RUNNING:
kubectl port-forward service/api-gateway 8102:8102
```

### Then open your browser to:
```
http://localhost:8102
or just open the frontend app if you have it running locally....its works on my machine if it dosent work on yours...idk what to tell you
```

### Method 2: Check Service Status
```bash
# See your API Gateway URL
kubectl get service api-gateway
```

## ✅ **Verification Commands**

```bash
# Check everything is running
kubectl get all

# Check pod status
kubectl get pods

# Check service URLs
kubectl get services

# Test API Gateway health (after port-forwarding)
curl http://localhost:8102/actuator/health
```

## 🐛 **Quick Troubleshooting**

If any pods aren't starting:

```bash
# Check what's wrong with a pod
kubectl describe pod <pod-name>

# Check logs for errors
kubectl logs <pod-name>

# Restart a problematic deployment
kubectl rollout restart deployment/<service-name>
```

## 📋 **One-Line Status Check**
```bash
kubectl get pods,services
```

## 🎯 **Expected Final Result**
After successful deployment, running `kubectl get pods` should show:
```
✅ All 7 pods in "Running" status
✅ 0 restarts (or very few)
✅ All "1/1" ready
```

## 🔄 **If You Need to Restart Everything**
```bash
# Delete and redeploy
kubectl delete -f 03-deployments.yaml
kubectl delete -f 02-services.yaml  
kubectl delete -f 01-databases.yaml
kubectl delete -f 00-configmaps.yaml

# Then start from Step 2 again
```

**Just run these commands in order and your entire application will be live at `http://localhost:8102`!** 🎉

The key is waiting for databases to be fully running before deploying the Spring Boot services....I CAN NOT STRESS THIS ENOUGH WAIT FOR THE DATABASES TO BE READY THEEN DEPLOY THE REST OF THE SERVICES