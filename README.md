# CI/CD Demo Project (Jenkins Multi-Branch Pipeline)

This project demonstrates a **real-world CI/CD pipeline** using **Jenkins**, with:

* Multi-branch Git workflow
* Automated promotions across environments
* QA gates (manual + automated)
* Rollback strategy
* Fully runnable locally

---

## 🧱 Project Structure

```
ci-cd-demo/
│
├── app/               # Node.js application
├── test/              # Unit tests (Jest)
├── Jenkinsfile        # CI/CD pipeline definition
├── .gitignore
└── README.md
```

---

## Branch Strategy

| Branch | Purpose                        |
| ------ | ------------------------------ |
| dev    | Development (trigger pipeline) |
| stage  | QA / staging                   |
| prod   | Production simulation          |
| main   | Final stable release           |

### 🔄 Promotion Flow

```
dev → stage → prod → main
```

---

## ⚙️ Pipeline Flow

1. **Push to `dev` triggers pipeline**
2. Build & install dependencies
3. Run unit tests
4. Auto-merge `dev → stage`
5. QA Gate (manual approval)
6. Auto-merge `stage → prod`
7. Run production smoke tests
8. Auto-merge `prod → main`

---

## 🧪 Tech Stack

* Node.js (Express)
* Jest (testing)
* Jenkins (CI/CD)
* Git (branching strategy)

---

## Getting Started

### 1. Clone Repo

```
git clone https://github.com/YOUR_USERNAME/ci-cd-demo.git
cd ci-cd-demo
```

---

### 2. Install Dependencies

```
npm install
```

---

### 3. Run App Locally

```
npm start
```

App runs at:

```
http://localhost:3000
```

---

### 4. Run Tests

```
npm test
```

---

## 🏗️ Jenkins Setup

### 1. Run Jenkins (Docker)

```
docker run -p 8080:8080 -p 50000:50000 jenkins/jenkins:lts
```

---

### 2. Install Plugins

* Git
* Pipeline
* GitHub Integration
* Credentials Binding

---

### 3. Add Git Credentials

* Go to: Manage Jenkins → Credentials
* Add:

  * Username/password OR SSH key
  * ID: `git-creds`

---

### 4. Create Pipeline Job

* New Item → Pipeline
* Select: **Pipeline script from SCM**
* SCM: Git
* Branch: `*/dev`
* Script path: `Jenkinsfile`

---

## 🔗 Webhook Setup (GitHub)

1. Go to Repo → Settings → Webhooks
2. Add webhook:

```
http://<jenkins-url>/github-webhook/
```

3. Select:

* Push events

---

## 🔁 Rollback Strategy

If production fails:

```
git reset --hard HEAD~1
git push --force
```

---

## 🔔 Optional Enhancements

* Slack notifications
* Docker build stage
* Kubernetes deployment
* SonarQube integration

---

## ✅ Key Features

✔ Fully automated CI/CD pipeline
✔ Manual QA approval gate
✔ Multi-branch promotion strategy
✔ Production validation
✔ Rollback support
✔ Local setup (no cloud required)

---

## 👨‍💻 Developer Workflow

```
git checkout dev
git add .
git commit -m "feature update"
git push origin dev
```

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
