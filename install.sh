#!/usr/bin/env bash
# install.sh — Stablecoin Payments Architect Skill Installer
# Installs the skill into the local Solana AI Kit configuration directory.

set -euo pipefail

SKILL_NAME="stablecoin-payments-architect"
SKILL_VERSION="1.0.0"
INSTALL_BASE="${SOLANA_AI_KIT_HOME:-$HOME/.solana-ai-kit}"
SKILLS_DIR="$INSTALL_BASE/skills/$SKILL_NAME"
AGENTS_DIR="$INSTALL_BASE/agents"
COMMANDS_DIR="$INSTALL_BASE/commands"

GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
CYAN='\033[0;36m'
NC='\033[0m'

log_info()    { echo -e "${CYAN}[INFO]${NC}  $*"; }
log_success() { echo -e "${GREEN}[OK]${NC}    $*"; }
log_warn()    { echo -e "${YELLOW}[WARN]${NC}  $*"; }
log_error()   { echo -e "${RED}[ERROR]${NC} $*" >&2; }

banner() {
  echo ""
  echo -e "${CYAN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
  echo -e "${CYAN}  Stablecoin Payments Architect Skill v${SKILL_VERSION}${NC}"
  echo -e "${CYAN}  Solana AI Kit Plugin Installer${NC}"
  echo -e "${CYAN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
  echo ""
}

check_prerequisites() {
  log_info "Checking prerequisites..."

  if ! command -v git &>/dev/null; then
    log_error "git is required but not installed. Install git and retry."
    exit 1
  fi

  if ! command -v cp &>/dev/null; then
    log_error "cp (coreutils) is required. Check your PATH."
    exit 1
  fi

  if [ ! -d "$INSTALL_BASE" ]; then
    log_warn "Solana AI Kit directory not found at $INSTALL_BASE"
    log_info "Creating directory: $INSTALL_BASE"
    mkdir -p "$INSTALL_BASE"
  fi

  log_success "Prerequisites OK"
}

backup_existing() {
  if [ -d "$SKILLS_DIR" ]; then
    BACKUP_DIR="${SKILLS_DIR}.backup.$(date +%Y%m%d%H%M%S)"
    log_warn "Existing skill found. Backing up to: $BACKUP_DIR"
    mv "$SKILLS_DIR" "$BACKUP_DIR"
    log_success "Backup complete"
  fi
}

install_skill() {
  log_info "Installing skill module to $SKILLS_DIR..."
  mkdir -p "$SKILLS_DIR"

  SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

  if [ ! -d "$SCRIPT_DIR/skill" ]; then
    log_error "skill/ directory not found at $SCRIPT_DIR/skill"
    log_error "Run this script from the root of the stablecoin-payments-architect-skill repository."
    exit 1
  fi

  cp -r "$SCRIPT_DIR/skill/." "$SKILLS_DIR/"
  log_success "Skill modules installed"
}

install_agents() {
  log_info "Installing agents to $AGENTS_DIR..."
  mkdir -p "$AGENTS_DIR"

  SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

  if [ -d "$SCRIPT_DIR/agents" ]; then
    cp -r "$SCRIPT_DIR/agents/." "$AGENTS_DIR/"
    log_success "Agents installed"
  else
    log_warn "agents/ directory not found — skipping agent installation"
  fi
}

install_commands() {
  log_info "Installing commands to $COMMANDS_DIR..."
  mkdir -p "$COMMANDS_DIR"

  SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

  if [ -d "$SCRIPT_DIR/commands" ]; then
    cp -r "$SCRIPT_DIR/commands/." "$COMMANDS_DIR/"
    log_success "Commands installed"
  else
    log_warn "commands/ directory not found — skipping command installation"
  fi
}

verify_installation() {
  log_info "Verifying installation..."

  REQUIRED_FILES=(
    "$SKILLS_DIR/SKILL.md"
    "$SKILLS_DIR/payment-architecture.md"
    "$SKILLS_DIR/merchant-checkout.md"
    "$SKILLS_DIR/subscriptions.md"
    "$SKILLS_DIR/treasury-management.md"
    "$SKILLS_DIR/settlement-systems.md"
    "$SKILLS_DIR/escrow.md"
    "$SKILLS_DIR/compliance.md"
    "$SKILLS_DIR/security.md"
    "$SKILLS_DIR/cost-estimation.md"
    "$SKILLS_DIR/architecture-review.md"
  )

  MISSING=0
  for f in "${REQUIRED_FILES[@]}"; do
    if [ ! -f "$f" ]; then
      log_error "Missing: $f"
      MISSING=$((MISSING + 1))
    fi
  done

  if [ "$MISSING" -gt 0 ]; then
    log_error "$MISSING required file(s) missing. Installation may be incomplete."
    exit 1
  fi

  log_success "All required files verified"
}

print_summary() {
  echo ""
  echo -e "${GREEN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
  echo -e "${GREEN}  Installation Complete!${NC}"
  echo -e "${GREEN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
  echo ""
  echo -e "  Skill installed to:   ${CYAN}$SKILLS_DIR${NC}"
  echo -e "  Agents installed to:  ${CYAN}$AGENTS_DIR${NC}"
  echo -e "  Commands installed to:${CYAN}$COMMANDS_DIR${NC}"
  echo ""
  echo -e "  ${YELLOW}Getting Started:${NC}"
  echo ""
  echo -e "    /design-payment-system"
  echo -e "    /review-payment-architecture"
  echo -e "    /estimate-costs"
  echo -e "    /build-subscription-system"
  echo ""
  echo -e "  ${YELLOW}Example prompts:${NC}"
  echo ""
  echo -e "    \"Design a merchant checkout system for my marketplace\""
  echo -e "    \"Review my stablecoin treasury architecture\""
  echo -e "    \"What security controls do I need for hot wallets?\""
  echo ""
  echo -e "${GREEN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
  echo ""
}

# --- Main ---

banner
check_prerequisites
backup_existing
install_skill
install_agents
install_commands
verify_installation
print_summary
