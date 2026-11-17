# Cynbit DevOps Demo

A small Express API prepared to demonstrate automated testing, Docker packaging, and GitHub Actions CI.

## Requirements
- Node.js 22 or newer
- npm
- Docker (for container build)

## Run locally
```bash
npm install
npm start
```
Open `http://localhost:3000/health`. Expected response:
```json
{"status":"healthy"}
```

## Run tests
```bash
npm install
npm test
```

## Build and run with Docker
```bash
docker build -t cynbit-devops-demo .
docker run --rm -p 3000:3000 cynbit-devops-demo
```

## CI
GitHub Actions runs on pushes and pull requests targeting `main`. It installs dependencies, runs the automated tests, and builds the Docker image.

> This is a demonstration project for the DevOps audit workflow, not Cynbit's private production application or infrastructure.
