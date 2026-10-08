# DevOps Assignment 2 — Dockerized Diagnostic CLI

A lightweight, containerized Linux diagnostic command-line interface (CLI) built with Alpine Linux, Docker, and Docker Compose.

---

## Table of Contents

- [Overview](#overview)
- [Project Structure](#project-structure)
- [Prerequisites](#prerequisites)
- [CLI Command Reference](#cli-command-reference)
- [Docker & Docker Compose Usage](#docker--docker-compose-usage)
- [Exit Codes](#exit-codes)
- [Testing & Verification](#testing--verification)

---

## Overview

This application packages a Bash-based diagnostic utility into an isolated, multi-platform Docker container.
Key features include:
- **System Information**: Hostname, OS, kernel, uptime, user, architecture.
- **Network Resolution & Ping**: Host IP resolution and ICMP connectivity check.
- **Disk Usage Reporting**: File system space inspection (`df -h`).
- **Health Check Integration**: Container health check via `app/health-check.sh`.
- **Docker Compose Orchestration**: `compose.yaml` specification for local container execution.

---

## Project Structure

```text
assignment-2/
├── README.md
├── app/
│   ├── diagnostic.sh
│   └── health-check.sh
├── Dockerfile
├── compose.yaml
├── .dockerignore
├── test.sh
└── grade.sh
```

---

## Prerequisites

- **Docker Engine**: Version 20.10+
- **Docker Compose**: Version 2.0+
- **Bash Shell**: POSIX-compliant execution environment for local testing scripts.

---

## CLI Command Reference

The application entrypoint routes to `app/diagnostic.sh`:

| Command | Arguments | Description |
| :--- | :--- | :--- |
| `system` | None | Displays Linux OS, kernel, uptime, user, and memory stats. |
| `network` | `<host>` | Resolves hostname/IP and tests ICMP reachability. |
| `disk` | None | Displays mounted filesystem space utilization. |
| `help` | None | Displays command usage instructions. |

---

## Docker & Docker Compose Usage

### Build Docker Image
```bash
docker build -t diagnostic-tool .
```

### Execute Commands via Docker
```bash
# Display system info
docker run --rm diagnostic-tool system

# Perform network check on google.com
docker run --rm diagnostic-tool network google.com

# Display disk usage
docker run --rm diagnostic-tool disk

# Display usage help
docker run --rm diagnostic-tool help
```

### Execute via Docker Compose
```bash
docker compose run --rm diagnostic system
docker compose run --rm diagnostic network localhost
```

---

## Exit Codes

| Exit Code | Meaning | Example |
| :---: | :--- | :--- |
| `0` | Success | Command executed without errors |
| `1` | Operational / Runtime Failure | Network host unreachable |
| `2` | Invalid Input or Command | Missing host parameter, unknown command |

---

## Testing & Verification

1. Make all scripts executable:
   ```bash
   chmod +x app/*.sh test.sh grade.sh
   ```

2. Run student test suite:
   ```bash
   ./test.sh
   ```

3. Run automated grader script:
   ```bash
   ./grade.sh
   ```
