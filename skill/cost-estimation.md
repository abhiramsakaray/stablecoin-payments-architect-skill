# Cost Estimation

Transaction fees, infrastructure costs, and total cost of ownership for stablecoin payment systems on Solana.

---

## Solana Transaction Costs

Solana's fee model is one of the most attractive aspects of building payment infrastructure on the network.

### Base Transaction Fees (2026)

| Fee Type | Cost | Notes |
|---|---|---|
| Base signature fee | 0.000005 SOL per signature | Approximately $0.001 at $200/SOL |
| Priority fee | Variable | 0 to ~0.001 SOL depending on congestion |
| Account creation (ATA) | 0.00203928 SOL | One-time rent exemption per token account |
| PDA creation | 0.00089088 SOL | Varies by account size |
| Compute unit price | 1 microlamport per CU (default) | Increase for priority processing |

### Real Payment Transaction Cost

A typical USDC payment transaction involves:
- 1 signature (payer)
- 1 SPL Token transfer instruction
- 1 memo instruction (optional)

**Cost breakdown:**
```
Base fee:       0.000005 SOL   ($0.0010)
Priority fee:   0.000002 SOL   ($0.0004)  [low congestion estimate]
Total per tx:   0.000007 SOL   ($0.0014)
```

At $200/SOL, a Solana payment transaction costs approximately **$0.001–$0.004 USD**.

Compare to: Ethereum (~$0.50–5.00), Stripe (2.9% + $0.30).

### Fee Scenarios at Scale

| Monthly Volume | Payment Count | Est. Total Tx Fees | Cost Per Transaction |
|---|---|---|---|
| $10,000 | 500 @ $20 avg | ~$0.70 | $0.0014 |
| $100,000 | 2,000 @ $50 avg | ~$2.80 | $0.0014 |
| $1,000,000 | 20,000 @ $50 avg | ~$28 | $0.0014 |
| $10,000,000 | 200,000 @ $50 avg | ~$280 | $0.0014 |

**Solana transaction fees are effectively negligible** compared to every other payment infrastructure option. Your significant costs are infrastructure and RPC.

---

## RPC Infrastructure Costs

This is where most Solana payment businesses spend real money.

### RPC Provider Pricing (2026 Estimates)

| Provider | Free Tier | Growth Plan | Business Plan | Enterprise |
|---|---|---|---|---|
| Helius | 50 RPS, limited CUs | $99/mo — 500 RPS | $499/mo — 2,000 RPS | Custom |
| QuickNode | 15 RPS | $99/mo — 150 RPS | $299/mo — 500 RPS | Custom |
| Triton One | None | $150/mo | $500/mo | Custom |
| Syndica | 10 RPS free | $49/mo | $199/mo | Custom |

### RPC Usage Estimation

| RPC Call | Frequency | Notes |
|---|---|---|
| `getSignaturesForAddress` (polling) | Per checkout, every 500ms | High usage for checkout monitoring |
| `getTransaction` | Per confirmed payment | 1 call per payment |
| `sendTransaction` | Per payout | 1+ call per settlement tx |
| `getLatestBlockhash` | Per transaction built | 1 call per tx submitted |
| `getAccountInfo` | Per balance check | Merchant balance queries |

### RPC Cost Calculator

For a platform processing 5,000 payments/month with 5,000 payouts/month:

```
Checkout polling (5,000 sessions × 30 avg polls):  150,000 calls
Payment verification (getTransaction):               5,000 calls
Settlement transactions (500 batches × 3 calls):    1,500 calls
Balance checks + misc:                              ~10,000 calls

Total monthly RPC calls:                           ~166,500

At Helius Growth ($99/mo): Well within 500 RPS tier
Estimated RPC cost:        $99/month
```

**Recommendation**: Start with Helius Growth. Move to Business when you consistently hit rate limits or exceed 50,000 payments/month.

### Webhook vs. Polling RPC Cost Comparison

| Method | RPC Cost | Latency | Reliability |
|---|---|---|---|
| Polling (every 500ms) | High — 120 calls/min per checkout | 500ms–2s | High (you control it) |
| Helius Webhooks | Low — 1 push per event | 400ms–1.5s | High (requires webhook reliability) |
| QuickNode Streams | Low — 1 push per event | 400ms–1s | High |

At 100+ concurrent active checkouts, webhooks become significantly cheaper. Implement polling for v1, migrate to webhooks at scale.

---

## Infrastructure Costs

### Minimum Production Infrastructure

| Component | Service | Estimated Monthly Cost |
|---|---|---|
| API server | AWS t3.medium / 2 instances | $70 |
| Database (PostgreSQL) | AWS RDS db.t3.medium | $60 |
| Redis (sessions, rate limiting) | AWS ElastiCache t3.micro | $20 |
| Background job worker | AWS t3.small | $15 |
| Load balancer | AWS ALB | $25 |
| RPC provider | Helius Growth | $99 |
| Secrets management | AWS Secrets Manager | $5 |
| Monitoring | Datadog / New Relic (basic) | $50–100 |
| Email (transactional) | Resend / SendGrid | $10–50 |
| SSL certificates | AWS ACM | Free |
| **Total (minimum)** | | **~$354–$444/month** |

### Growth-Stage Infrastructure

| Component | Service | Estimated Monthly Cost |
|---|---|---|
| API servers (4× auto-scale) | AWS t3.large | $280 |
| Database (PostgreSQL + read replica) | AWS RDS db.t3.large | $200 |
| Redis cluster | AWS ElastiCache r6g.large | $100 |
| Background workers (4×) | AWS t3.medium | $140 |
| RPC provider | Helius Business | $499 |
| Blockchain analytics | TRM Labs (starter) | $500 |
| Monitoring + alerting | Datadog Pro | $300 |
| CDN + WAF | AWS CloudFront + WAF | $100 |
| **Total** | | **~$2,119/month** |

---

## KYC / Compliance Costs

| Provider | Pricing Model | Estimate |
|---|---|---|
| Persona | Per verification | $1.00–$3.00 per KYC check |
| Onfido | Per check | $0.80–$2.50 per check |
| TRM Labs | SaaS + per check | $500/mo base + $0.10/tx screening |
| Chainalysis KYT | Enterprise — contact for pricing | $1,000+/mo |

**Compliance cost at 1,000 new users/month:**
- KYC: 1,000 × $1.50 avg = $1,500/month
- Transaction screening: 10,000 txns × $0.10 = $1,000/month
- Total compliance: ~$2,500/month at growth stage

---

## Total Cost of Ownership — Example Scenarios

### Scenario A: Hackathon / MVP (< $50K/month volume)

| Cost Category | Monthly |
|---|---|
| Infrastructure (minimal) | $354 |
| RPC (Helius Growth) | $99 |
| KYC (optional at MVP) | $0 |
| Solana tx fees | < $5 |
| **Total** | **~$458/month** |

**As % of revenue at $50K/month**: 0.9% — excellent economics

### Scenario B: Growth Stage ($500K/month volume)

| Cost Category | Monthly |
|---|---|
| Infrastructure (growth) | $2,119 |
| RPC (Helius Business) | $499 |
| KYC / Compliance | $2,500 |
| Solana tx fees | < $50 |
| Legal / Accounting | $2,000 |
| **Total** | **~$7,168/month** |

**As % of revenue at $500K/month**: 1.4% — still excellent

### Scenario C: Scale ($5M/month volume)

| Cost Category | Monthly |
|---|---|
| Infrastructure (scaled) | $8,000 |
| RPC (Enterprise) | $2,000 |
| Compliance (Chainalysis) | $3,000 |
| KYC (high volume) | $5,000 |
| Institutional custody | $2,500 |
| Legal / Compliance staff | $15,000 |
| Solana tx fees | < $500 |
| **Total** | **~$36,000/month** |

**As % of revenue at $5M/month**: 0.72% — still highly competitive vs. traditional payment processors

---

## Fee Revenue Modeling

If you charge merchants a platform fee, here is the revenue math:

```
Platform fee rate: 0.5% (competitive for crypto payments)
Monthly volume:    $1,000,000
Gross fee revenue: $5,000/month
Infrastructure:    $7,168/month
Net margin:        -$2,168/month (needs 1% fee or higher volume)

At 1% fee + $1M volume:
Gross fee revenue: $10,000
Infrastructure:    $7,168
Net margin:        +$2,832 (28% margin — viable)

At 1% fee + $5M volume:
Gross fee revenue: $50,000
Infrastructure:    $36,000
Net margin:        +$14,000 (28% margin — scales well)
```

**Insight**: Stablecoin payment platforms need meaningful volume or a higher fee rate than traditional processors to cover compliance costs. The unit economics only work if you are processing at scale OR charging more than legacy processors (justified by instant settlement, no chargebacks, global reach).

---

## Cost Optimization Strategies

| Strategy | Potential Savings | Implementation Effort |
|---|---|---|
| Batch settlement (reduce tx count) | 80% on settlement tx fees | Medium |
| Webhook instead of polling | 60–80% on RPC calls | Medium |
| Compressed accounts for high-volume data | 50–90% on rent | High |
| Spot instances for background workers | 60–70% on worker compute | Low |
| Database connection pooling (PgBouncer) | Avoid RDS scaling costs | Medium |
| Cache getLatestBlockhash aggressively | 20–30% RPC call reduction | Low |
| Reserve RPC capacity upfront | 10–20% discount vs. pay-as-you-go | Low |

See `settlement-systems.md` for batch settlement architecture and `merchant-checkout.md` for webhook vs. polling checkout implementation.
