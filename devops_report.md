# Django DRF Template – CI/CD, Docker & Testing Pipeline

This project is a fully containerized **Django REST Framework (DRF)** application designed to demonstrate a modern **DevOps workflow** using **Docker** and **GitHub Actions**.  
It automates the build, test, and deployment process from code commit to DockerHub push.

---

## Project Overview

The project showcases how a Django-based backend can be:

- **Containerized** using Docker for consistent environment management.
- **Tested automatically** on every push or pull request.
- **Built and deployed** through a continuous integration and delivery pipeline (CI/CD).
- **Secured** using encrypted GitHub Secrets for authentication and image publishing.

---

## Technologies Used

| Category               | Tool / Framework      | Purpose                             |
| ---------------------- | --------------------- | ----------------------------------- |
| **Backend Framework**  | Django REST Framework | API development                     |
| **Language**           | Python 3.9            | Core application logic              |
| **Containerization**   | Docker                | Isolated environment for deployment |
| **CI/CD**              | GitHub Actions        | Automates testing and deployment    |
| **Package Management** | pip                   | Python dependency management        |
| **Database (Local)**   | SQLite3               | Lightweight database for testing    |
| **Registry**           | DockerHub             | Container image repository          |

---

## ⚙️ Pipeline Design

The GitHub Actions pipeline is designed to automatically handle every major stage of the software lifecycle.

### **Pipeline Stages**

1. **Checkout Code**  
   The pipeline starts by pulling the latest version of the repository.

2. **Set Up Python Environment**  
   Python 3.9 is configured for dependency installation and testing.

3. **Install Dependencies**  
   All project requirements are installed from `requirements.txt`.

4. **Run Tests**  
   The Django test suite runs using a dedicated test settings file (`test.py`), ensuring no interference with production data.

5. **Docker Login**  
   The pipeline logs into DockerHub securely using GitHub Secrets.

6. **Build and Push Docker Image**  
   Finally, it builds the Docker image and pushes it to DockerHub under the latest tag.

The pipeline runs automatically on:

- Every push to the `main` branch.
- Every pull request targeting `main`.

---

## Secret Management Strategy

To ensure security, all sensitive credentials are **stored as GitHub Secrets**.  
This avoids hardcoding credentials in the workflow file.

| Secret Name          | Description                           |
| -------------------- | ------------------------------------- |
| `DOCKERHUB_USERNAME` | DockerHub account username            |
| `DOCKERHUB_TOKEN`    | Access token generated from DockerHub |

GitHub Actions masks these values automatically during runtime, ensuring they’re never exposed in logs or builds.

---

## Testing Process

Testing is an integral part of this pipeline.  
A custom Django test settings file (`test.py`) is configured to use an **SQLite3 test database** for lightweight execution.

### **How it Works**

1. When the pipeline runs, it automatically executes:

   python manage.py test --settings=django_project.config.settings.test

2. The tests validate models, serializers, and API endpoints.

3. The workflow fails early if any test case fails, preventing broken builds from being deployed.

Deployment Workflow:

When a new commit is pushed to the main branch:

GitHub Actions automatically runs the pipeline.

The Docker image is built and pushed to DockerHub.

You can deploy the container on any server using:

docker pull <your_dockerhub_username>/django-drf-template:latest
docker run -d -p 8000:8000 <your_dockerhub_username>/django-drf-template:latest

This ensures zero manual deployment steps and consistent builds across environments.

Lessons Learned:

Building this project offered valuable insights into how DevOps practices enhance software reliability:

Automation is powerful: Replacing manual testing and deployment with GitHub Actions dramatically reduced human error.

Consistency matters: Docker ensures the same environment for developers, testers, and servers.

Security is essential: Managing credentials through GitHub Secrets keeps pipelines safe.

Iterative improvement: Debugging workflow path issues emphasized the importance of correct relative paths and repository structure.

Testing as a gatekeeper: Automated tests act as a safety net, ensuring code integrity before deployment.
