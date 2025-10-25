# Vehicle Tracking System – Kubernetes Deployment (Minikube)

This directory contains the **Kubernetes deployment files** for the Vehicle Tracking System (VTS).
It sets up the **Spring Boot API Gateway** backend inside a Minikube cluster and connects it to a **Next.js frontend** running locally.

---

## 🚀 Prerequisites

Before you start, make sure you have these installed:

* [Docker Desktop](https://www.docker.com/products/docker-desktop)
* [Minikube](https://minikube.sigs.k8s.io/docs/start/)
* [kubectl](https://kubernetes.io/docs/tasks/tools/)
* [Git](https://git-scm.com/)
* [Node.js](https://nodejs.org/en/) (for the frontend)

---


## 🧱 1. Start Minikube

Start a new Minikube cluster (or reuse an existing one):

```bash
minikube start --driver=docker --cpus=4 --memory=5000mb
```

Confirm it’s running:

```bash
minikube status
```

---

## ⚙️ 2. Apply Kubernetes Configuration

Inside the project root folder, run:

```bash
kubectl apply -f kubernetes-deployment-experiment/
```

Check pods:

```bash
kubectl get pods
```

Expected output (names will vary):

```
NAME                            READY   STATUS    RESTARTS   AGE
api-gateway-7d9cfbf9cc-xxxx     1/1     Running   0          2m
```

---

## 🌐 3. Start the Minikube Tunnel

Run **in a separate terminal** (keep this terminal open):

```bash
minikube tunnel
```

* This exposes `LoadBalancer` services to your host machine.
* You should see something like:

```
* Tunnel successfully started
* Starting tunnel for service api-gateway.
```

---

## 📡 4. Get the External IP

Once the tunnel is running, check your services:

```bash
kubectl get svc
```

Example output:

```
NAME           TYPE           CLUSTER-IP      EXTERNAL-IP     PORT(S)          AGE
api-gateway    LoadBalancer   10.105.169.55   192.168.49.2   8102:30001/TCP   3m
```

* `EXTERNAL-IP` → IP to use for frontend/backend access.
* `PORT(S)` → Use the service port (8102 for API Gateway).

---

## 🔗 5. Access the Backend

Your backend is accessible at:

```
http://<EXTERNAL-IP>:8102
```

Example:

```
http://192.168.49.2:8102/v1/users
```
just replace `<EXTERNAL-IP>` with the actual IP from the previous step.

Test it in a browser or Postman — you should get a JSON response(actually expect an error cause youre not yet authorized to accss the application and stuff..but dw it worked!).

---

## 💻 6. Connect the Frontend (Next.js)

Inside your frontend folder (`VIEWS`), create/update `.env.local`:

now the important part!

the frontend is agnostic to where the backend is hosted, so you just need to set the base URL for API calls.

what i mean that right now it expects the backend to be at `http://localhost:8102` but since we are using minikube tunnel, we need to change that to the external IP we got earlier.

this is a diffenent story if we did this with like docker compose or something, but since we are using minikube, we need to set it manually.

i could write a script to do this automatically, but for now, just do it manually.

its not rocket science.


Then start your frontend:

```bash
npm run dev
```

Now your frontend can call APIs like:

```
${process.env.NEXT_PUBLIC_API_BASE_URL}/v1/users
```

---

## 🧰 7. Common Commands

| Command                              | Description                |
| ------------------------------------ | -------------------------- |
| `kubectl get pods`                   | See all running pods       |
| `kubectl get svc`                    | Check exposed services     |
| `minikube ip`                        | Get Minikube’s IP address  |
| `minikube tunnel`                    | Open LoadBalancer tunnel   |
| `minikube dashboard`                 | Open Minikube UI dashboard |
| `kubectl logs <pod-name>`            | View logs for debugging    |
| `kubectl delete -f api-gateway.yaml` | Remove the deployment      |

---

## ⚠️ Troubleshooting

* If you can’t access the backend, make sure the pod is running and the service shows a valid `EXTERNAL-IP`.
* Ensure your firewall allows traffic to Minikube.
* Keep the `minikube tunnel` terminal open. Closing it removes the external IP.
* Restart Minikube if needed:

```bash
minikube delete
minikube start --driver=docker --cpus=4 --memory=5000mb
```

* Check pod logs:

```bash
kubectl logs <pod-name>
```

---

## 🧠 Notes

* The NodePort range is `30000–32767`, but with `LoadBalancer` + tunnel, you don’t need to manually use NodePort.
* Every time you restart Minikube, the external IP might change. Update your `.env.local` accordingly.
* To automatically open the backend in a browser:

```bash
minikube service api-gateway
```

*(Keep the tunnel open if using LoadBalancer...very IMPORTANT)*



## Helpful Links(actually READ THE DOCS???)

* [Minikube Docs](https://minikube.sigs.k8s.io/docs/)
* [Kubernetes Services Overview](https://kubernetes.io/docs/concepts/services-networking/service/)
* [Spring Boot CORS Docs](https://spring.io/guides/gs/rest-service-cors/)
