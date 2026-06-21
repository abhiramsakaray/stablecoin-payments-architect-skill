# Compliance

Educational guidance on KYC, AML, and regulatory considerations for stablecoin payment systems. This module provides informational context only and does not constitute legal advice. Consult a licensed attorney for jurisdiction-specific compliance requirements.

---

## Compliance Landscape for Stablecoin Payments

Stablecoin payment systems occupy a complex regulatory space. The regulatory obligations you face depend on:

1. **Where you are incorporated** (jurisdiction of your legal entity)
2. **Where your customers are located** (customer jurisdictions)
3. **What you do with the funds** (are you a custodian? a payment processor? a marketplace?)
4. **The volume of transactions you process**
5. **Which stablecoin you use** (each issuer has their own compliance requirements)

There is no single global standard. Regulatory treatment of crypto payments varies significantly across the US, EU, UK, Singapore, UAE, and other major jurisdictions.

---

## Key Regulatory Concepts

### Money Services Business (MSB) / Money Transmitter

In the United States, a company that transfers money or value on behalf of others may be classified as a Money Services Business (MSB) by FinCEN and as a Money Transmitter at the state level.

**Indicators that you may be a money transmitter:**
- You hold customer funds in your wallets before disbursing them to merchants
- You convert between currencies (e.g., USDC → USD fiat)
- You provide wallet services where you control the keys

**Indicators that you may NOT be a money transmitter:**
- You act purely as a technology conduit (payments go directly from buyer to seller, never through your wallet)
- You are operating under a payment processing exemption
- Your transactions are clearly commercial, not personal remittances

**Action**: If you hold customer funds, even briefly, consult a financial regulatory attorney before launching.

### Payment Institution (EU — PSD2/MiCA)

In the European Union, entities that provide payment services may need to be authorized as a Payment Institution under PSD2. The Markets in Crypto-Assets Regulation (MiCA), which came into full effect in late 2024, adds crypto-asset-specific rules for stablecoin issuers and service providers.

**MiCA relevance for payment platforms:**
- If you provide crypto-asset transfer services, you may need CASP (Crypto-Asset Service Provider) authorization
- EURC and USDC qualify as e-money tokens under MiCA — their issuers (Circle) must be authorized
- Using authorized stablecoins (USDC, EURC from Circle's EU entity) reduces your own authorization burden

### Electronic Money Institution (EMI)

Companies that issue electronic money or provide e-money storage services may need EMI authorization in the EU and UK. If your platform maintains a balance for users (even in stablecoins), consult whether EMI licensing applies.

---

## KYC (Know Your Customer)

### What KYC Involves

KYC is the process of verifying the identity of your customers. For payment platforms, this typically means:

| KYC Level | What Is Verified | When Required |
|---|---|---|
| Basic (Tier 1) | Email + phone | Low-volume consumer transactions |
| Standard (Tier 2) | Government ID + selfie | Most business-facing platforms |
| Enhanced (Tier 3) | ID + address + source of funds | High-value or high-risk customers |
| KYB (Business) | Business registration + UBO + directors | Merchant onboarding |

### KYC Thresholds (US Context — Educational)

FinCEN requires identification for certain transaction thresholds. These are general educational reference points:

- **$1,000**: Common informal threshold for enhanced scrutiny on single transactions
- **$3,000**: FinCEN rule requiring name, address, and ID for certain money transfers
- **$10,000**: CTR (Currency Transaction Report) threshold — but crypto/stablecoin reporting rules differ by entity type

**Do not rely on these thresholds as definitive compliance guidance.** Your obligations depend on your specific classification and jurisdiction.

### KYC Provider Options

| Provider | Capabilities | Integration Complexity |
|---|---|---|
| Persona | ID verification, liveness, business KYB | Medium |
| Onfido | ID + biometrics + AML screening | Medium |
| Jumio | AI-driven identity, global coverage | Medium |
| Socure | ML-based fraud + identity | High |
| Synaps | Crypto-native KYC, supports Solana addresses | Low-Medium |

**Integration pattern:**
1. Merchant/user initiates KYC flow via your frontend
2. Your API creates a KYC session with provider
3. User completes verification in provider's hosted flow
4. Provider sends webhook to your API with result
5. You store verification status, do not store raw PII — reference provider's record ID only

---

## AML (Anti-Money Laundering)

### Core AML Controls

| Control | Description | Implementation |
|---|---|---|
| Transaction monitoring | Flag unusual patterns | Rule-based + ML scoring |
| Sanctions screening | OFAC, EU, UN sanctions lists | Chainalysis, Elliptic, TRM Labs |
| Blockchain analytics | Trace transaction history and risk score | Chainalysis, Elliptic, TRM |
| Suspicious Activity Reports (SARs) | File with FinCEN if you detect suspicious activity | Legal counsel required |
| Customer risk scoring | Score each customer by risk | Combination of KYC data + behavior |

### Transaction Monitoring Patterns

Common patterns that warrant review:

- **Structuring**: Multiple transactions just below reporting thresholds (e.g., $9,800 × 10)
- **Round-number anomalies**: Exact $10,000 USDC transactions with no business explanation
- **High-velocity unusual activity**: Customer who averaged $500/month suddenly sends $50,000
- **Geographic inconsistency**: US-registered customer transacting from sanctioned-country IP
- **Mixer/tumbler interactions**: Funds that originated from or passed through a known mixer service

### On-Chain Risk Scoring

For stablecoin payments, you can screen the **sending wallet** against blockchain analytics databases:

- **Chainalysis KYT (Know Your Transaction)**: Risk scores for wallets and transactions
- **Elliptic Navigator**: Wallet screening and transaction monitoring
- **TRM Labs**: Real-time risk scoring

**Workflow:**
1. Customer initiates payment
2. Before order fulfillment (or as a background check), submit payer wallet address to Chainalysis/TRM
3. If wallet returns HIGH risk (darknet, mixer, sanctioned entity), flag for review
4. If wallet returns CRITICAL, reject and file SAR if required

---

## Stablecoin-Specific Regulatory Considerations

### USDC and Circle's Compliance

Circle, as a regulated entity, maintains its own AML/KYC program. By using USDC, you benefit from Circle's blacklist — Circle can (and does) freeze accounts associated with sanctioned entities, fraud, or illegal activity at the protocol level.

**What this means for you:**
- If a sanctioned wallet sends you USDC, Circle may freeze those USDC in your wallet
- You cannot control this — it is a feature of the stablecoin design
- This reduces your risk of unknowingly holding proceeds of sanctioned activity

**What it does NOT do:**
- It does not replace your own KYC/AML program
- It does not protect you from liability for knowingly transacting with bad actors
- It does not cover pre-freezing transactions already in your system

### PYUSD and PayPal's Compliance

PayPal's PYUSD inherits PayPal's existing compliance infrastructure. PayPal is a licensed money transmitter in all 50 US states. If you integrate PYUSD payments, you are interacting with a regulated payment network.

### EURC and MiCA

Circle's EURC is designed for the European market and is issued in compliance with MiCA's e-money token provisions. Using EURC for EU customers provides a regulatory-friendly foundation, but does not eliminate your own CASP or PSD2 authorization requirements.

---

## Sanctioned Countries and Jurisdictions

**Educational reference only — maintain your own up-to-date OFAC list.**

OFAC (US) sanctions currently apply to entities and individuals in or connected to:
- Iran, North Korea, Cuba, Syria
- Specific regions of Ukraine (Crimea, Donetsk, Luhansk)
- Various designated individuals globally (Specially Designated Nationals list)

If you operate a payment platform and process transactions involving sanctioned entities, the legal exposure is severe (civil and criminal penalties). Use a real-time OFAC screening service, not a static list.

---

## Compliance Architecture Recommendations

### Minimum Viable Compliance Stack (Early Stage)

```
1. Email verification at signup (prevent throwaway accounts)
2. Terms of Service with prohibited use policy
3. KYC at $1,000 cumulative or $500 single transaction threshold
4. OFAC screening via free API (initial; upgrade to commercial at scale)
5. Transaction amount limits per unverified user
6. Geo-blocking of sanctioned countries at the IP level
7. Suspicious activity log reviewed weekly by founders
```

### Growth-Stage Compliance Stack

```
1. Full KYC/KYB provider integration (Persona or Onfido)
2. Commercial blockchain analytics (TRM Labs or Chainalysis KYT)
3. Automated transaction monitoring rules
4. Dedicated compliance officer or outsourced compliance service
5. SAR filing capability
6. AML policy documentation and staff training
7. Regular third-party compliance audit
```

### Compliance Documentation You Need

Before launching a payment platform, have these documents prepared (with legal counsel):
- Privacy Policy (GDPR-compliant if serving EU customers)
- Terms of Service (clear prohibited use cases)
- AML Policy (internal document)
- KYC Policy (internal document)
- Data Retention Policy

---

## Geographic Strategy

If you are early-stage and compliance is a concern:
1. Launch in a single jurisdiction where you have clear regulatory guidance (often Singapore, UAE, or UK for crypto payments)
2. Explicitly geo-block jurisdictions with unclear or hostile regulatory treatment
3. Expand to additional jurisdictions only after legal review

**Do not launch globally by default** and assume you can "figure out compliance later." The cost of retroactive compliance cleanup is significantly higher than proactive planning.

This module provides educational context only. Engage a licensed financial regulatory attorney before making compliance decisions for your specific platform.
