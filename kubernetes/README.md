# 🚀 Vehicle Management System — Kubernetes Deployment

This repository contains the **Kubernetes configuration files** for deploying the microservices architecture of the Vehicle Management System project.  
It includes database, backend, and frontend configurations — all running in a Kubernetes cluster.

---

## 🧑‍💻 Team Members & Roles

| Role | Name | Responsibilities |
|------|------|------------------|
| **Team Lead / Cluster Manager** | Flourish | Cluster setup, namespace creation, database deployment, final integration, and cluster management. |
| **Deployment Engineer** | Iman | Creates and manages all deployment manifests for backend and frontend microservices. |
| **Networking Engineer** | Nathan | Manages Kubernetes Services, networking between pods, and pod forwarding. |
| **Testing & Validation Engineer** | Andre | Tests pod connectivity, verifies internal communications between services. |
| **Documentation & Config Manager** | Bright | Maintains YAML folder structure, README updates, and environment variable consistency. |

---

## 🧱 Folder Structure

k8s/
├── deployments/
│ ├── postgres-deployment.yaml
│ ├── mongo-deployment.yaml
│ └── (other service deployments)
├── services/
│ ├── postgres-service.yaml
│ ├── mongo-service.yaml
│ └── (other service files)
└── volumes/
├── postgres-pvc.yaml
├── mongo-pvc.yaml
└── (persistent volume files)

markdown
Copy code

---

## 🗄️ Database Setup

### 1️⃣ PostgreSQL
- **Service Name:** `postgres-db`
- **Port:** 5432
- **Used By:** Auth, Dispatch, Vehicle services
- **Persistent Volume:** `postgres-pvc`
- **Environment Variables:**
  POSTGRES_USER=postgres
  POSTGRES_PASSWORD=super_secret_password
  POSTGRES_DB=postgres

markdown
Copy code

### 2️⃣ MongoDB
- **Service Name:** `mongo-logging`
- **Port:** 27017
- **Used By:** Logging Service
- **Persistent Volume:** `mongo-pvc`

---

## 🧩 Deployment Commands

To apply configurations:
```bash
kubectl apply -f k8s/volumes/
kubectl apply -f k8s/deployments/
kubectl apply -f k8s/services/
To verify:

bash
Copy code
kubectl get pods
kubectl get svc
kubectl get pvc
🔍 Testing Database Connections
PostgreSQL
bash
Copy code
kubectl run pg-client --rm -it --image=postgres:15 -- bash
psql -h postgres-db -U postgres
MongoDB
bash
Copy code
kubectl run mongo-client --rm -it --image=mongo:6 -- bash
mongosh "mongodb://mongo-logging:27017"