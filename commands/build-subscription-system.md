---
command: build-subscription-system
description: >
  Designs a complete subscription billing architecture for Solana stablecoin
  payments. Outputs billing architecture, data model, payment flow, dunning
  logic, and security considerations.
agent: payment-architect
skill_modules:
  - subscriptions
  - treasury-management
  - security
---

# /build-subscription-system

Design a complete subscription billing system for stablecoin payments on Solana, including recurring billing architecture, data model, payment flow, and failure handling.

---

## Command Usage

```
/build-subscription-system

Product type: [SaaS / API / Marketplace / Content / Other]
Billing model: [Flat rate / Usage-based / Tiered / Hybrid]
Pricing tiers: [e.g., Free, $49/mo, $199/mo, Enterprise]
Billing currency: [USDC / PYUSD / EURC]
Billing interval: [Monthly / Annual / Both]
Trial period: [None / 7 days / 14 days / 30 days]
Trial type: [Free trial (no payment info) / Card-on-file trial]
Expected subscribers at launch: [estimate]
Expected subscribers at 12 months: [estimate]
Failed payment handling: [Basic / Advanced dunning]
Plan changes: [Allow upgrades/downgrades mid-cycle? Yes/No]
```

---

## Output Structure

### Section 1: Subscription Architecture Overview

```
## Subscription Billing Architecture: [Product Name]

### Billing Model
[Description of how billing works, what triggers a charge, how amounts are calculated]

### Core Design Decision: [Billing Mechanism]
[Explain whether this uses pre-authorized pull, custodial deposit, or push-only,
and WHY this was chosen for their specific context]

### What This System Does
- [Capability 1]
- [Capability 2]

### What This System Does NOT Do (v1 Scope)
- [Out of scope item]
- [Out of scope item]
```

---

### Section 2: Architecture Diagram

Produce a full Mermaid diagram:

```mermaid
graph TD
    [Full subscription system architecture]
```

Must include:
- Signup / onboarding flow
- Pre-authorization setup
- Billing cycle trigger
- Successful payment path
- Failed payment path
- Dunning flow
- Cancellation path

---

### Section 3: Data Model

Provide the complete schema needed for this specific subscription system:

```
## Data Model

### Core Tables

plans {
  [schema with all fields relevant to their pricing tiers]
}

subscriptions {
  [schema adapted to their billing model]
}

billing_events {
  [schema]
}

[usage_records — only if usage-based billing requested]

[payment_methods — adapted for their authorization mechanism]
```

Mark which fields are required for v1 vs. which can be deferred.

---

### Section 4: Subscription Lifecycle

```
## Subscription States

[Mermaid state diagram showing all subscription states and transitions]
```

Explicitly map every state transition to:
- What triggers it
- What action is taken on-chain (if any)
- What notification is sent to the subscriber

---

### Section 5: Billing Flow (Step-by-Step)

```
## Billing Cycle Flow

### Trial Start
1. [Step 1 — what happens when user signs up]
2. [Step 2]
...

### First Charge (Trial → Paid conversion)
1. [What triggers this]
2. [How the on-chain transaction is built]
3. [How success is confirmed]
4. [How access is granted]

### Recurring Billing
1. [Cron job trigger]
2. [Balance pre-check]
3. [Transaction execution]
4. [Confirmation and ledger update]
5. [Access continuation]

### Failed Payment
1. [Detection]
2. [Immediate action]
3. [Retry schedule]
```

---

### Section 6: Plan Change Handling

Only include if plan changes are requested:

```
## Plan Changes

### Upgrade Flow
[Step-by-step including proration logic if applicable]

### Downgrade Flow
[When effective, any credits issued]

### Cancellation Flow
[When access ends, refund policy, data retention]

### Proration Calculation (if applicable)
[Formula and example]
```

---

### Section 7: Dunning Architecture

```
## Failed Payment Handling

### Retry Schedule

| Attempt | Timing          | Notification    |
|---------|-----------------|-----------------|
| 1       | Immediately     | Email: payment failed |
| 2       | +24 hours       | Email: retry scheduled |
| 3       | +72 hours       | Email: action required |
| 4       | +7 days         | Email: final warning |
| Final   | +14 days        | Email: account suspended |

### Access During Past_Due Period
[Define: full access / degraded access / read-only / full suspension]

### Recovery Flow
When payment finally succeeds after past_due:
1. [What happens on-chain]
2. [How subscription status updates]
3. [How access is restored]
```

---

### Section 8: Usage-Based Billing (If Applicable)

Only include if usage-based billing was requested:

```
## Usage Tracking Architecture

### What to Track
[Specific usage events for their product type]

### Tracking Schema
[usage_records and usage_summaries tables]

### Aggregation Strategy
[How and when usage is aggregated]

### Billing Calculation
[Formula: base_fee + usage_units × unit_price]

### Billing Preview
[How users see their current bill before it's charged]

### Usage Alerts
[When to notify users of approaching plan limits]
```

---

### Section 9: Security Considerations

```
## Security Considerations

### Billing-Specific Risks

| Risk | Mitigation |
|------|-----------|
| Double billing on retry | Idempotency keys on all billing transactions |
| Delegate authority revoked without canceling | Monitor for revocation events; treat as past_due |
| Deposit wallet drained externally | Expected failure — dunning handles it |
| Clock skew in billing cron | Use database-side timestamps; avoid local server time |
| Race condition on plan upgrade | Database row lock on subscription record during changes |

### Solana-Specific Considerations
- [Delegate authority limits and how to handle them]
- [ATA creation cost on first subscription]
- [Blockhash expiry when building deferred billing transactions]
```

---

### Section 10: Implementation Roadmap

```
## Implementation Roadmap

### v1 — Launch Ready (6-8 weeks)
Core billing functionality:
- [ ] Plan and subscription data model
- [ ] Signup + pre-authorization flow
- [ ] First charge execution
- [ ] Monthly billing cron job
- [ ] Basic dunning (3 retries, then cancel)
- [ ] Email notifications (billing events)
- [ ] Subscriber portal (view plan, cancel)
- [ ] Merchant dashboard (subscriber list, revenue)

### v2 — Growth (4-6 weeks after launch)
- [ ] Plan upgrade/downgrade with proration
- [ ] Annual billing option
- [ ] Advanced dunning with pause option
- [ ] Usage-based billing (if in scope)
- [ ] Subscription analytics dashboard

### v3 — Scale
- [ ] Enterprise custom billing
- [ ] Multi-currency support
- [ ] Affiliate/referral discount tracking
- [ ] Revenue recognition accounting exports
```

---

### Section 11: Key Operational Questions

Before building, the user must answer:

```
## Open Decisions for Your Team

1. **Trial without payment info**: How long will you allow before requiring payment?
   If never required, what triggers account suspension at trial end?

2. **Subscription pause**: Will you allow subscribers to pause billing?
   If yes, how long? What happens to their data during pause?

3. **Refund policy**: If a subscriber cancels mid-month, do they receive a pro-rata refund?
   This must be in your Terms of Service before you launch.

4. **Delegate authority ceiling**: What is the maximum you will request delegate authority for?
   Should match or exceed your highest plan price × 13 months (annual buffer).

5. **Currency for Enterprise**: Will enterprise contracts be invoiced manually?
   If yes, invoicing.md covers the invoice architecture for that flow.
```
