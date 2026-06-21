# Stablecoin Payments Architect Skill

> A production-grade Solana AI Kit skill for designing, reviewing, and deploying stablecoin payment systems on Solana.

---

## What Problem Does This Skill Solve?

Building stablecoin payment infrastructure on Solana is genuinely hard. Founders run into the same problems repeatedly:

- **Architecture decisions** with no clear answers — hot wallets vs. custodial wallets, settlement timing, reconciliation strategies
- **Treasury complexity** — how to manage float, multi-sig thresholds, cold wallet policies, and operational procedures
- **Compliance unknowns** — when KYC is required, what AML controls look like for crypto payments, stablecoin-specific regulatory considerations
- **Security blind spots** — key management failures, webhook vulnerabilities, replay attacks, oracle manipulation risks
- **Cost surprises** — unexpected RPC costs, per-transaction overhead, batch settlement economics
- **Subscription architecture** — there is no native recurring billing on Solana; you have to build it correctly from scratch

This skill acts as a senior fintech architect with deep Solana ecosystem knowledge. It does not write code. It helps you make the right architectural decisions before you write a single line.

---

## Who Is This For?

| Audience | Primary Use Case |
|---|---|
| Solana Founders | Design payment systems before building |
| Fintech Startups | Architect stablecoin checkout and settlement flows |
| SaaS Companies | Build subscription billing on USDC/PYUSD |
| Marketplaces | Design escrow and payout systems |
| Payment Processors | Build merchant onboarding and settlement pipelines |
| Wallet Developers | Integrate Solana Pay and stablecoin support |
| Stablecoin Infrastructure Teams | Design treasury and compliance controls |
| Hackathon Builders | Get to a solid architecture quickly |

---

## Installation

### Prerequisites

- [Solana AI Kit](https://github.com/solana-labs/solana-agent-kit) installed
- Node.js 18+ or compatible runtime

### Install via Script

```bash
curl -fsSL https://raw.githubusercontent.com/abhiramsakaray/stablecoin-payments-architect-skill/main/install.sh | bash
```

### Manual Install

```bash
git clone https://github.com/abhiramsakaray/stablecoin-payments-architect-skill.git
cd stablecoin-payments-architect-skill
cp -r skill/ ~/.solana-ai-kit/skills/stablecoin-payments-architect/
cp -r agents/ ~/.solana-ai-kit/agents/
cp -r commands/ ~/.solana-ai-kit/commands/
```

### Verify Installation

```bash
solana-ai-kit skills list | grep stablecoin
```

---

## Usage Examples

### Design a New Payment System

```
/design-payment-system

Business type: SaaS platform
Revenue model: Monthly subscriptions ($49/month)
Currencies: USDC
Monthly volume: ~$200,000
Users: B2B, 500 businesses
Regions: US and EU
Compliance needs: Basic KYC required
```

### Review an Existing Architecture

```
/review-payment-architecture

We have: hot wallet per merchant, Solana Pay QR checkout,
nightly batch settlement to a multisig treasury,
webhooks via our own server, PostgreSQL for ledger.
Volumes: 10,000 txns/day
```

### Estimate Costs

```
/estimate-costs

Transaction volume: 50,000 payments/month
Average payment: $85 USDC
Settlement: daily batch
RPC provider: Helius
```

### Build a Subscription System

```
/build-subscription-system

Product: API access, usage-based + base subscription
Pricing tiers: $0 free, $99/mo, $499/mo, enterprise custom
Billing currency: USDC on Solana
Trial period: 14 days
Failed payment handling: needed
```

---

## Example Prompts

These natural language prompts route to the correct skill module automatically:

```
How should I structure my merchant checkout for a marketplace with 1,000 sellers?
```

```
What are the treasury management best practices for a $5M stablecoin float?
```

```
Walk me through a compliant KYC flow for a crypto payment processor in the EU.
```

```
What security controls should I put on my hot wallet that processes $500K/day?
```

```
Design an escrow system for a freelance marketplace using USDC.
```

```
What does a production settlement pipeline look like for daily batch payouts?
```

```
Compare Solana Pay vs custom payment API for a high-volume e-commerce checkout.
```

```
How do I build subscription billing on Solana without native recurring payments?
```

---

## Supported Workflows

### Payment Architecture
- Merchant checkout systems (Solana Pay, QR, web, mobile)
- Invoice and payment link generation
- Escrow and conditional payment patterns
- Payment API design

### Treasury & Settlement
- Hot/warm/cold wallet topology
- Multi-signature treasury setup
- Settlement pipeline design
- Reconciliation and ledger systems

### Subscription Billing
- Recurring billing architecture on Solana
- Usage-based billing systems
- Trial management and failed payment recovery
- SaaS payment flows

### Security & Compliance
- Key management frameworks
- Wallet security architecture
- KYC/AML implementation guidance (educational)
- Regulatory considerations by jurisdiction

### Architecture Review
- Scalability analysis
- Security gap identification
- Cost optimization review
- Compliance risk assessment

---

## Supported Stablecoins

| Stablecoin | Issuer | Primary Use Case |
|---|---|---|
| USDC | Circle | General payments, treasury, settlement |
| PYUSD | PayPal | Consumer payments, PayPal integration |
| EURC | Circle | Euro-denominated payments and treasury |
| USDT | Tether | High-volume trading, emerging markets |

---

## Skill Modules

| Module | File | Covers |
|---|---|---|
| Payment Architecture | `payment-architecture.md` | System design patterns |
| Merchant Checkout | `merchant-checkout.md` | Checkout flows, Solana Pay |
| Subscriptions | `subscriptions.md` | Recurring billing architecture |
| Treasury Management | `treasury-management.md` | Wallet topology, treasury ops |
| Settlement Systems | `settlement-systems.md` | Batch settlement, pipelines |
| Invoicing | `invoicing.md` | Invoice generation, payment links |
| Escrow | `escrow.md` | Escrow patterns, dispute resolution |
| Payment Links | `payment-links.md` | Dynamic and static payment links |
| Compliance | `compliance.md` | KYC, AML, regulatory guidance |
| Security | `security.md` | Key management, wallet security |
| Cost Estimation | `cost-estimation.md` | Transaction and infrastructure costs |
| Architecture Review | `architecture-review.md` | Review framework, risk scoring |

---

## License

MIT License — see [LICENSE](./LICENSE)

---

## Contributing

This skill is designed to be maintained alongside the evolving Solana ecosystem. Contributions are welcome for:

- New payment architecture patterns
- Updated stablecoin support (new issuers, new tokens)
- Jurisdiction-specific compliance guidance
- Cost estimation updates as Solana fee markets evolve
- New command workflows

Please open a PR against `main` with a clear description of what changed and why.
