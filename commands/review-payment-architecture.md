---
command: review-payment-architecture
description: >
  Performs a structured security, scalability, reliability, cost, and
  compliance review of an existing stablecoin payment architecture.
  Outputs a scored review with prioritized remediation recommendations.
agent: security-reviewer
skill_modules:
  - architecture-review
  - security
  - treasury-management
  - settlement-systems
---

# /review-payment-architecture

Review an existing stablecoin payment system architecture and identify strengths, weaknesses, risks, and concrete recommendations.

---

## Command Usage

```
/review-payment-architecture

[Describe your current architecture. Include:]

Wallet setup: [e.g., single hot wallet / per-merchant PDAs / custodial managed]
Key storage: [e.g., env file / AWS KMS / hardware wallet]
Multisig: [e.g., Squads 2/3 / none]
Payment verification: [e.g., webhook from Helius / polling / frontend-reported]
Settlement: [e.g., daily batch / real-time / weekly]
Reconciliation: [e.g., daily job / manual / none]
API auth: [e.g., API keys / JWT / none]
Webhook security: [e.g., HMAC signed / none]
Monitoring: [e.g., Datadog / basic alerts / none]
Monthly volume: [approximate USD volume]
Number of merchants: [if multi-party]
```

The more context provided, the more specific and actionable the review.

---

## Review Process

### Phase 1: Architecture Mapping

Before scoring, produce a **Current State Summary**:

```
## Current State Summary

**System Type**: [What you understand the system to be]
**Volume**: [As stated by user]
**Wallet Model**: [Summary of wallet architecture]
**Settlement Model**: [How funds move]
**Security Posture**: [Initial read]
**Notable Gaps**: [What's obviously missing from the description]
```

If critical information is missing to complete a meaningful review, ask for it before proceeding.

---

### Phase 2: Dimension Scoring

Score each dimension 1-5 with explicit justification:

**Security** (30% weight)

| Area | Score | Justification |
|---|---|---|
| Key management | /5 | [Why] |
| Payment verification | /5 | [Why] |
| API security | /5 | [Why] |
| Operational security | /5 | [Why] |
| **Security Average** | **/5** | |

**Scalability** (25% weight)

| Area | Score | Justification |
|---|---|---|
| Throughput ceiling | /5 | [Why] |
| Database design | /5 | [Why] |
| RPC provisioning | /5 | [Why] |
| Settlement efficiency | /5 | [Why] |
| **Scalability Average** | **/5** | |

**Reliability** (20% weight)

| Area | Score | Justification |
|---|---|---|
| Single points of failure | /5 | [Why] |
| Failure recovery | /5 | [Why] |
| Observability | /5 | [Why] |
| **Reliability Average** | **/5** | |

**Cost Efficiency** (15% weight)

| Area | Score | Justification |
|---|---|---|
| Transaction fee optimization | /5 | [Why] |
| Infrastructure sizing | /5 | [Why] |
| RPC plan fit | /5 | [Why] |
| **Cost Average** | **/5** | |

**Compliance Readiness** (10% weight)

| Area | Score | Justification |
|---|---|---|
| Auditability / logging | /5 | [Why] |
| KYC/AML posture | /5 | [Why] |
| Data handling | /5 | [Why] |
| **Compliance Average** | **/5** | |

**Weighted Overall Score:**
```
overall = (security_avg × 0.30) + (scalability_avg × 0.25) + (reliability_avg × 0.20) + (cost_avg × 0.15) + (compliance_avg × 0.10)
```

---

### Phase 3: Findings

#### Critical Findings (Fix Before Launch / Fix in 24h)

For each critical finding:

```
### [CRIT-XX] [Finding Title]

**Severity**: Critical
**Affects**: [Component or flow]

**What is wrong:**
[Clear description of the vulnerability or gap]

**Attack scenario / failure scenario:**
[Exactly how this causes fund loss or system failure — be specific]

**Business impact:**
[What happens in the worst case — quantify if possible]

**Remediation:**
[Specific, actionable steps to fix — not generic advice]

**Effort to fix:** Low / Medium / High
**Time to fix:** [Realistic estimate]
```

#### High Severity Findings

Same format, lower urgency framing.

#### Medium Severity Findings

Condensed format — table with ID, title, description, remediation.

#### Low / Informational Findings

Bullet list only.

---

### Phase 4: Strengths

Always acknowledge what is well-designed. A balanced review is more actionable and credible than a purely negative one.

```
## Strengths

- [What the team got right and why it matters]
- [Another strength]
```

---

### Phase 5: Prioritized Remediation Roadmap

```
## Remediation Roadmap

### This Week (Critical)
- [ ] [CRIT-01] [Specific action] — [Owner suggestion]
- [ ] [CRIT-02] [Specific action]

### Next 7 Days (High)
- [ ] [HIGH-01] [Specific action]
- [ ] [HIGH-02] [Specific action]

### Next 30 Days (Medium)
- [ ] [MED-01] [Specific action]
- [ ] [MED-02] [Specific action]

### Next 90 Days (Low / Optimization)
- [ ] [LOW-01] [Specific action]
```

---

### Phase 6: Overall Assessment

End with a plain-English assessment:

```
## Overall Assessment

[System Name] is [launch-ready / needs critical work / needs significant redesign].

The most important thing to fix is [specific finding] because [specific reason].

After addressing the critical and high findings, this architecture will be [assessment of post-fix state].
```

---

## Review Calibration Guidelines

### Score 5 — Excellent

No meaningful gaps. Would recommend this as a reference implementation.

### Score 4 — Good

Minor gaps or optimizations. Safe for production with existing controls.

### Score 3 — Adequate

Some notable gaps. Production-viable but improvements needed within 30-60 days.

### Score 2 — Needs Work

Significant gaps. Not recommended for production without addressing high-severity findings.

### Score 1 — Critical Gaps

Fundamental design problems. Do not launch until critical findings are resolved.

---

## Anti-Patterns That Automatically Cap Scores

If any of the following are present, the overall score cannot exceed 2.5/5 regardless of other factors:

- Plaintext private key storage for any operational key
- No on-chain payment verification (frontend-trusted)
- No authentication on payment API endpoints
- Single signer controlling > $100K in treasury
- No reconciliation system of any kind
