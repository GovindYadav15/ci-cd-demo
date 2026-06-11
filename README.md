# CI/CD Demo Project

A simple end-to-end CI/CD demo using Jenkins and Docker.

This repository includes:

* A Node.js Express app in `app/`
* A Dockerfile for containerization
* A Jenkins pipeline for build and deploy
* A Docker Compose file for local testing

---

## Project Structure

```text
ci-cd-demo/
├── app/               # Node.js application
├── test/              # Tests (Jest)
├── Dockerfile         # Docker image build
├── Jenkinsfile        # Jenkins pipeline definition
├── docker-compose.yml # Local Docker compose
├── .gitignore
└── README.md
```

---

## Local Setup

### 1. Clone repository

```bash
git clone https://github.com/GovindYadav15/ci-cd-demo.git
cd ci-cd-demo
```

### 2. Install dependencies

```bash
cd app
npm install
```

### 3. Run locally

```bash
npm start
```

Open:

```text
http://localhost:3000
```

### 4. Run tests

```bash
npm test
```

---

## Docker

### Build image

```bash
docker build -t ci-cd-demo .
```

### Run container

```bash
docker run -p 3000:3000 ci-cd-demo
```

### Local compose

```bash
docker-compose up --build
```

---

## Jenkins Pipeline

The pipeline builds the Docker image and deploys it as a container on the Jenkins agent.

### Recommended Jenkins job configuration

* Create a Pipeline job
* Set **Pipeline script from SCM**
* SCM: Git
* Repository: `https://github.com/GovindYadav15/ci-cd-demo.git`
* Script path: `Jenkinsfile`

---

## App Endpoints

* `GET /` → returns a JSON status message
* `GET /health` → returns `OK`

---

## Notes

* The Docker build uses `npm ci` with the included `app/package-lock.json` for consistent dependency installs.
* The Jenkins pipeline deploys the container and verifies the application with a health check.

---

## License

MIT

👉 Jenkins handles everything else automatically.

---

## 📌 Notes

* Ensure Jenkins has push access to repo
* Keep Jenkinsfile in root directory
* Always push changes to `dev` branch only

---

## ⭐ Contribution

Feel free to fork and enhance:

* Add Docker/K8s
* Add security scans
* Improve test coverage

---

## 📜 License

MIT License
