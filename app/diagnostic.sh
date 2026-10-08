#!/usr/bin/env bash
set -euo pipefail

usage() {
  echo "Diagnostic CLI Tool v1.0"
  echo "Usage: diagnostic <command> [arguments]"
  echo
  echo "Available Commands:"
  echo "  system           Display useful Linux system information"
  echo "  network <host>   Check connectivity and resolve specified host"
  echo "  disk             Display filesystem disk usage"
  echo "  help             Display this help message"
  echo
  echo "Exit Codes:"
  echo "  0  Success"
  echo "  1  Operational / runtime failure"
  echo "  2  Invalid command or missing input"
}

cmd_system() {
  echo "=========================================="
  echo "          SYSTEM INFORMATION              "
  echo "=========================================="
  echo "Hostname:                 $(hostname 2>/dev/null || echo "${HOSTNAME:-localhost}")"
  echo "Current User:             $(whoami 2>/dev/null || echo "${USER:-unknown}")"
  echo "Date / Time:              $(date '+%Y-%m-%d %H:%M:%S %Z' 2>/dev/null || echo "Unknown")"
  echo "Operating System:         $(uname -o 2>/dev/null || uname -s 2>/dev/null || echo "Linux")"
  echo "Kernel Version:           $(uname -r 2>/dev/null || echo "Unknown")"
  echo "Uptime:                   $(uptime 2>/dev/null || echo "Active")"
  echo "Architecture:             $(uname -m 2>/dev/null || echo "Unknown")"
  echo "Working Directory:        $(pwd)"
  echo "=========================================="
  exit 0
}

cmd_network() {
  local host="${1:-}"
  if [ -z "$host" ]; then
    echo "Error: Missing host argument." >&2
    echo "Usage: diagnostic network <host>" >&2
    exit 2
  fi

  echo "=========================================="
  echo "          NETWORK DIAGNOSTICS             "
  echo "=========================================="
  echo "Target Host: $host"

  local resolved_ip=""
  if command -v getent >/dev/null 2>&1; then
    resolved_ip=$(getent hosts "$host" 2>/dev/null | awk '{print $1}' | head -n 1 || true)
  fi
  if [ -z "$resolved_ip" ] && command -v nslookup >/dev/null 2>&1; then
    resolved_ip=$(nslookup "$host" 2>/dev/null | awk '/Address:/ {print $2}' | tail -n 1 || true)
  fi
  if [ -z "$resolved_ip" ]; then
    resolved_ip="$host"
  fi

  echo "Resolved IP: ${resolved_ip:-Unknown}"

  local ping_success=false
  if command -v ping >/dev/null 2>&1; then
    if ping -c 1 -W 2 "$host" >/dev/null 2>&1 || ping -n 1 -w 2000 "$host" >/dev/null 2>&1; then
      ping_success=true
    fi
  fi

  if [ "$ping_success" = true ]; then
    echo "Connectivity Status: REACHABLE"
    echo "=========================================="
    exit 0
  else
    echo "Connectivity Status: UNREACHABLE"
    echo "=========================================="
    exit 1
  fi
}

cmd_disk() {
  echo "=========================================="
  echo "            DISK INFORMATION              "
  echo "=========================================="
  df -h 2>/dev/null || df -P 2>/dev/null || echo "Disk stats unavailable"
  echo "=========================================="
  exit 0
}

# Main command routing
if [ $# -lt 1 ]; then
  usage
  exit 2
fi

COMMAND="$1"
shift || true

case "$COMMAND" in
  system)
    cmd_system
    ;;
  network)
    cmd_network "$@"
    ;;
  disk)
    cmd_disk
    ;;
  help|--help|-h)
    usage
    exit 0
    ;;
  *)
    echo "Error: Invalid command '$COMMAND'." >&2
    echo >&2
    usage >&2
    exit 2
    ;;
esac
