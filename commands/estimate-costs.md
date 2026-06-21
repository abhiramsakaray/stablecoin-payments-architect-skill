---
command: estimate-costs
description: >
  Estimates the total cost of ownership for a stablecoin payment system
  on Solana. Covers transaction fees, RPC costs, infrastructure, KYC/compliance,
  and fee revenue projections.
agent: treasury-advisor
skill_modules:
  - cost-estimation
  - settlement-systems
---

# /estimate-costs

Produce a detailed cost estimate for a stablecoin payment system on Solana, broken down by category with monthly totals and cost-per-transaction analysis.

---

## Command Usage

```
/estimate-costs

Monthly payment volume: [e.g., $500,000 USD]
Number of payments: [e.g., 5,000 payments/month]
Average payment size: [e.g., $100 USDC]
Number of merchants: [e.g., 50 merchants receiving payouts]
Settlement frequency: [daily / weekly / on-demand]
RPC provider preference: [Helius / QuickNode / Triton / unsure]
Compliance needs: [None / Basic KYC / Full KYC + AML monitoring]
Team size: [for infrastructure sizing]
Cloud provider: [AWS / GCP / Azure / unsure]
```

---

## Output Structure

### Section 1: Solana Network Costs

Produce a table of on-chain transaction costs:

```
## Solana Network Costs

| Transaction Type          | Count/Month | Cost/Tx (SOL) | Cost/Tx (USD)* | Monthly Total |
|--------------------------|-------------|----------------|----------------|---------------|
| Payment receipt txns     |             | 0.000005       | ~$0.001        |               |
| Settlement payouts       |             | 0.000005       | ~$0.001        |               |
| Account creation (ATAs)  |             | 0.00204        | ~$0.41         |               |
| Priority fees (estimated)|             | variable       | ~$0.001-0.003  |               |
| **Solana total**         |             |                |                | **$X/month**  |

*Assumes $200/SOL. Adjust for current price.
```

Explain the calculation for each line item. Be explicit about assumptions.

---

### Section 2: RPC Infrastructure Costs

```
## RPC Infrastructure Costs

### Estimated Monthly RPC Calls

| RPC Method                    | Usage Pattern                    | Calls/Month |
|-------------------------------|----------------------------------|-------------|
| getSignaturesForAddress        | Checkout monitoring (polling)    |             |
| getTransaction                 | Payment verification             |             |
| sendTransaction               | Settlement payouts               |             |
| getLatestBlockhash            | Transaction building             |             |
| getAccountInfo                | Balance checks                   |             |
| **Total estimated calls**     |                                  |             |

### RPC Provider Comparison

| Provider    | Plan        | Monthly Cost | RPS Limit | Suitable? |
|-------------|-------------|--------------|-----------|-----------|
| Helius      | Growth      | $99          | 500 RPS   | Yes/No    |
| Helius      | Business    | $499         | 2,000 RPS | Yes/No    |
| QuickNode   | Build       | $99          | 150 RPS   | Yes/No    |
| Triton One  | Standard    | $150         | ~500 RPS  | Yes/No    |

**Recommendation**: [Specific provider and plan] — explain why based on their call volume
```

---

### Section 3: Infrastructure Costs

```
## Infrastructure Costs

Sized for [monthly volume] processing with [N] merchants.

| Component              | Service                    | Monthly Cost |
|------------------------|----------------------------|--------------|
| API server(s)          | [Instance type × count]    | $            |
| Database (PostgreSQL)  | [RDS size]                 | $            |
| Cache (Redis)          | [ElastiCache size]         | $            |
| Background workers     | [Instance type × count]    | $            |
| Load balancer          | AWS ALB                    | $            |
| Secrets management     | AWS Secrets Manager        | $            |
| Monitoring             | [Tool + plan]              | $            |
| Transactional email    | [Resend / SendGrid]        | $            |
| CDN (payment pages)    | AWS CloudFront             | $            |
| **Infrastructure total**|                           | **$X/month** |

Note: These estimates assume [AWS region]. Adjust for your cloud provider.
```

---

### Section 4: Compliance Costs

Include only if compliance was specified:

```
## Compliance Costs

| Component              | Provider         | Pricing Model        | Monthly Estimate |
|------------------------|------------------|----------------------|------------------|
| KYC verification       | Persona / Onfido | $X per check         | $                |
| AML / blockchain analytics | TRM Labs    | $X base + per-tx     | $                |
| Sanctions screening    | [Provider]       | Included / $X        | $                |
| **Compliance total**   |                  |                      | **$X/month**     |

Based on [N] new customers/month at [rate] per check.
```

---

### Section 5: Total Cost of Ownership

```
## Total Monthly Cost Summary

| Category           | Monthly Cost | % of Total |
|--------------------|--------------|------------|
| Solana network fees| $            |            |
| RPC infrastructure | $            |            |
| App infrastructure | $            |            |
| Compliance         | $            |            |
| **Grand total**    | **$X/month** | **100%**   |

### Cost Per Transaction
Total monthly cost:  $X
Transactions/month:  Y
Cost per transaction: $X/Y = $Z
```

---

### Section 6: Fee Revenue Modeling

```
## Fee Revenue Scenarios

Monthly volume: $[X]

| Fee Rate | Monthly Gross Revenue | Monthly Cost | Net Margin | Margin % |
|----------|----------------------|--------------|------------|----------|
| 0.5%     | $                    | $            | $          | %        |
| 1.0%     | $                    | $            | $          | %        |
| 1.5%     | $                    | $            | $          | %        |
| 2.0%     | $                    | $            | $          | %        |

**Break-even fee rate**: X% (the minimum fee to cover costs at current volume)
**Recommended fee rate**: Y% — explain rationale
```

---

### Section 7: Cost Scaling Projections

```
## Cost at Scale

| Monthly Volume | Payments | Est. Total Cost | Cost/Transaction | At 1% Fee: Net |
|---------------|----------|-----------------|------------------|----------------|
| $100K         |          | $               | $                | $              |
| $500K         |          | $               | $                | $              |
| $1M           |          | $               | $                | $              |
| $5M           |          | $               | $                | $              |
| $10M          |          | $               | $                | $              |
```

---

### Section 8: Cost Optimization Opportunities

```
## Top Cost Optimization Opportunities

| Optimization               | Potential Savings | Effort | When to Do |
|---------------------------|-------------------|--------|------------|
| Batch settlements          | 80% on payout fees| Medium | Before scale|
| Webhooks vs. polling      | 60% RPC reduction | Medium | >100 daily active checkouts |
| Reserved infrastructure   | 20-30% compute    | Low    | After 3 months stable |
| Connection pooling (PgBouncer)| Defer DB scale | Medium | >25 connections |
| Compress payment page assets | CDN cost reduction | Low  | Any time |
```

---

## Assumptions and Caveats

Always include at the end:

```
## Assumptions

- SOL price: $200 USD (adjust estimates proportionally for current price)
- All prices in USD; cloud provider: AWS us-east-1
- Estimates are for production-grade infrastructure with redundancy
- Does not include: engineering salaries, legal fees, office costs
- Compliance costs vary significantly by jurisdiction and provider contract
- RPC prices subject to change — verify current pricing directly with providers

These are estimates. Actual costs depend on your specific usage patterns,
negotiated rates, and growth trajectory.
```
