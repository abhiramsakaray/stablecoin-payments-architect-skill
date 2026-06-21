---
command: design-payment-system
description: >
  Designs a complete stablecoin payment system architecture for Solana.
  Outputs an architecture diagram, component inventory, payment flow,
  security model, and implementation roadmap.
agent: payment-architect
skill_modules:
  - payment-architecture
  - merchant-checkout
  - treasury-management
  - security
---

# /design-payment-system

Design a complete stablecoin payment system architecture tailored to the user's specific business model, volume, and requirements.

---

## Command Usage

```
/design-payment-system

Business type: [e.g., marketplace, SaaS, e-commerce, freelance platform]
Revenue model: [e.g., monthly subscriptions, per-transaction fee, marketplace commission]
Monthly volume: [e.g., $200,000 USD]
Stablecoin: [USDC / PYUSD / EURC / Multi-currency]
Customer type: [B2C / B2B / Both]
Regions: [US / EU / Global]
Merchants: [Single merchant / Multiple merchants — approx. count]
Compliance level: [Basic / Standard / Regulated]
```

All fields are optional — the command will ask follow-up questions for any missing context.

---

## Output Structure

When this command runs, produce the following sections in order:

---

### Section 1: System Overview

**Heading format**: `## [System Name] — Payment Architecture`

Provide a 3-5 sentence description of what this system does, its design philosophy, and what it explicitly does not handle in v1. Be specific to the user's context — not generic.

---

### Section 2: Architecture Diagram

Produce a Mermaid diagram that includes:
- Customer/payer entry point
- Checkout / payment interface
- Payment processing and verification layer
- Solana on-chain components (wallets, PDAs, programs)
- Settlement and treasury
- Off-chain ledger
- Background jobs (sweep, settlement, reconciliation)

```mermaid
graph TD
    [Build the actual diagram for this specific system]
```

Label all nodes clearly. Use subgraphs to group related components.

---

### Section 3: Component Inventory

Provide a table:

| Component | Type | Purpose | Technology Recommendation |
|---|---|---|---|
| [Name] | On-chain / Off-chain / Hybrid | [What it does] | [Specific tool or approach] |

Include all components: API servers, databases, Solana accounts, background jobs, monitoring, RPC provider.

---

### Section 4: Payment Flow (Step-by-Step)

Numbered sequence, from customer initiation to merchant settlement:

```
1. Customer initiates checkout at [entry point]
2. [Your API] creates a checkout session and reference keypair
3. [Your frontend] displays Solana Pay QR code or wallet connect button
4. Customer connects wallet and approves USDC transfer
5. Transaction submitted to Solana via customer's wallet
...
N. Funds sweep to cold treasury on monthly schedule
```

Include:
- Which actor takes each action (customer, frontend, backend, on-chain)
- The Solana commitment level used at each verification step
- Any off-chain records created at each step

---

### Section 5: Solana Account Architecture

Describe:
- **Merchant receiving accounts**: Type (PDA/ATA/custodial), derivation seeds if PDA
- **Treasury accounts**: Wallet addresses, multisig config
- **Fee collection accounts**: Where platform fees accumulate
- **Escrow accounts** (if applicable): PDA design, authority model

Include rent cost estimates where relevant.

---

### Section 6: Security Model

**Top 5 security controls for this specific system:**

| Control | What It Protects | How Implemented |
|---|---|---|
| [Control name] | [Asset protected] | [Specific implementation] |

Flag any security decisions that are specific to the user's architecture.

---

### Section 7: Cost Estimate

| Cost Category | Monthly Estimate | Notes |
|---|---|---|
| Solana transaction fees | $ | Based on [volume] payments + settlements |
| RPC provider | $ | Recommended: [provider + plan] |
| Infrastructure (server/DB) | $ | Minimum production setup |
| KYC (if applicable) | $ | Based on [user count] |
| **Total estimated** | **$** | |

---

### Section 8: Implementation Roadmap

**v1 (Launch — 6-8 weeks):**
- [ ] [Core feature 1 — essential for any transaction to work]
- [ ] [Core feature 2]
- [ ] [Core feature 3]

**v2 (Post-launch — 4-8 weeks after):**
- [ ] [Important but not blocking]
- [ ] [Important but not blocking]

**v3 (Scale — 3-6 months):**
- [ ] [Optimization and compliance]
- [ ] [Advanced features]

---

### Section 9: Open Questions

List any design decisions that depend on user context not yet provided. These are explicit choices the user must make before building:

1. [Question about custody model]
2. [Question about compliance level]
3. [Question about payout timing]

---

## Context-Specific Customizations

The command must adapt its output based on the user's inputs:

### If Business Type = Marketplace
- Include per-merchant PDA architecture
- Include commission/fee deduction in payment flow
- Include merchant onboarding checklist
- Include dispute resolution reference (→ escrow.md)

### If Business Type = SaaS
- Focus on subscription billing architecture
- Include trial period design
- Include failed payment / dunning flow
- Reference subscriptions.md for detailed billing architecture

### If Volume > $1M/month
- Emphasize institutional-grade treasury setup
- Recommend Squads multisig at all tiers
- Include monitoring and alerting requirements
- Mention compliance considerations

### If Regions = EU
- Flag EURC as a stablecoin option
- Mention MiCA and GDPR considerations
- Recommend EURC for Euro-denominated flows

### If Compliance = Regulated
- Include KYC at merchant onboarding
- Include transaction monitoring framework
- Reference compliance.md for detailed guidance
- Recommend legal counsel engagement
