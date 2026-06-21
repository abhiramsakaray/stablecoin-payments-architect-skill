# Architecture Review

Framework for reviewing and scoring stablecoin payment system architectures on Solana. Use this module when a user presents an existing architecture for review or asks "is my design good?"

---

## Review Framework

Every architecture review covers five dimensions. Score each from 1–5.

| Dimension | Weight | What It Measures |
|---|---|---|
| Security | 30% | Key management, authorization, attack surface |
| Scalability | 25% | Throughput ceiling, bottlenecks, growth path |
| Reliability | 20% | Failure modes, recovery, observability |
| Cost Efficiency | 15% | Infrastructure spend, fee optimization |
| Compliance Readiness | 10% | KYC/AML posture, auditability |

**Score calculation:**
```
weighted_score = (security × 0.30) + (scalability × 0.25) + (reliability × 0.20) + (cost × 0.15) + (compliance × 0.10)

1.0–2.4: Critical gaps — do not launch
2.5–3.4: Needs significant work before production
3.5–4.2: Production-viable with improvements
4.3–5.0: Strong architecture — minor optimizations only
```

---

## Security Review

### Key Management Checklist

| Check | Pass | Fail |
|---|---|---|
| Hot wallet key stored in HSM or KMS | ✅ | ❌ Plaintext in env file |
| No private keys in source code or git | ✅ | ❌ Keys hardcoded |
| Cold treasury uses hardware wallets | ✅ | ❌ Software wallet for cold storage |
| Multisig required for treasury operations | ✅ | ❌ Single signer for all treasury |
| Key rotation process documented | ✅ | ❌ No rotation policy |
| Secrets in secrets manager (not .env) | ✅ | ❌ .env file in production |

### Payment Security Checklist

| Check | Pass | Fail |
|---|---|---|
| All payments verified on-chain (not frontend-reported) | ✅ | ❌ Trusts frontend confirmation |
| Amount, token, and recipient all validated | ✅ | ❌ Only checks tx existence |
| Duplicate payment prevention (idempotency) | ✅ | ❌ No duplicate check |
| Replay attack prevention on webhooks | ✅ | ❌ No timestamp/signature check |
| Webhook signatures verified (HMAC-SHA256) | ✅ | ❌ No webhook authentication |
| Reference keys are single-use | ✅ | ❌ Reusing reference keys |

### API Security Checklist

| Check | Pass | Fail |
|---|---|---|
| API authentication on all endpoints | ✅ | ❌ Unauthenticated endpoints |
| Rate limiting implemented | ✅ | ❌ No rate limiting |
| Input validation on all parameters | ✅ | ❌ SQL injection or injection risk |
| Admin endpoints restricted to internal network | ✅ | ❌ Admin endpoints public |
| MFA on admin accounts | ✅ | ❌ Password-only admin access |

---

## Scalability Review

### Throughput Analysis Questions

When reviewing for scalability, ask:

1. **What is the peak TPS (transactions per second) the system must handle?**
   - Solana can handle ~65,000 TPS at network level
   - Your bottleneck is your application layer, not Solana
   - A single Node.js API server can handle ~500-2,000 req/sec before needing horizontal scaling

2. **Is the database a bottleneck?**
   - PostgreSQL with proper indexing can handle ~10,000 writes/sec on a single instance
   - At 1,000+ payments/second, you need read replicas + connection pooling + sharding strategy

3. **Can the RPC tier keep up?**
   - At 10,000 payments/day = ~0.12 TPS — any RPC plan handles this
   - At 1,000,000 payments/day = ~11.6 TPS of confirmations — needs Helius Business or higher

4. **How does settlement scale?**
   - Daily batch: creates a burst load spike at settlement time
   - Review whether the settlement batch can complete within the batch window

### Scalability Red Flags

| Red Flag | Risk Level | Recommendation |
|---|---|---|
| Single database, no read replicas | Medium | Add read replica before hitting 5,000 txns/day |
| Synchronous payment polling (not webhook) | High | Migrate to webhooks before 100 concurrent active checkouts |
| Settlement runs in a single transaction loop | High | Parallelize with worker pools |
| No connection pooling on database | Medium | Add PgBouncer before 50 concurrent connections |
| RPC on free tier | High | Upgrade to paid tier before launch |
| No CDN for payment pages | Low | Add CDN for latency |

---

## Reliability Review

### Single Points of Failure

Every architecture review must identify SPOFs:

```
Common SPOFs in Solana payment systems:

1. Single RPC provider → Add failover RPC (secondary provider)
2. Single hot wallet → Implement sweep failover (wallet B if wallet A unreachable)
3. Single availability zone database → Multi-AZ RDS
4. Single background worker process → Multiple worker instances
5. Single alert recipient → PagerDuty with escalation policy
6. Webhook without retry logic → Implement exponential backoff + dead letter queue
```

### Failure Mode Analysis

| Failure | Detection Method | Recovery Action | RTO |
|---|---|---|---|
| RPC outage | Health check pings every 30s | Switch to secondary RPC | < 60s |
| Database outage | Application error rate spike | Failover to read replica (reads), queue writes | < 5 min |
| Hot wallet key inaccessible | Signing service health check | Alert ops; halt new payouts; use backup signing path | < 30 min |
| Solana network degradation | Tx confirmation time > 30s | Alert; queue payments; retry when resolved | Automatic |
| Settlement job failure | Job completion monitoring | Alert ops; manual retry with same batch | < 4h |
| Webhook delivery failure | Delivery failure rate > 5% | Retry queue with exponential backoff | Automatic |

### Observability Checklist

| Capability | Present | Notes |
|---|---|---|
| Transaction confirmation latency tracked | ✅/❌ | P50, P95, P99 latencies |
| Failed payment rate monitored | ✅/❌ | Alert if > 2% failure rate |
| Settlement success rate tracked | ✅/❌ | Alert on any failure |
| RPC error rate monitored | ✅/❌ | Alert if > 1% RPC errors |
| Hot wallet balance monitored | ✅/❌ | Alert if below 48h operating float |
| Reconciliation discrepancies alerted | ✅/❌ | Zero tolerance for unresolved discrepancies |

---

## Cost Efficiency Review

### Fee Optimization Checks

| Check | Optimized | Not Optimized |
|---|---|---|
| Settlement uses batched transactions | Batch 6-8 transfers per tx | One tx per payout |
| Account creation amortized | Pre-create ATAs for known merchants | Create ATA per payment |
| Rent recovered from closed accounts | Closing PDA after escrow complete | Abandoned accounts |
| RPC plan matches actual usage | On appropriate paid tier | Over/under-provisioned |
| Polling replaced by webhooks | Webhook-driven | Polling every 500ms indefinitely |

---

## Compliance Readiness Review

### Auditability Checklist

| Capability | Present | Notes |
|---|---|---|
| Complete audit log of all transactions | ✅/❌ | Immutable, timestamped |
| On-chain tx signature recorded for every payment | ✅/❌ | Required for reconciliation |
| User identity linked to transactions | ✅/❌ | For KYC-covered transactions |
| Role-based access control on admin actions | ✅/❌ | Who did what, when |
| Log retention ≥ 5 years | ✅/❌ | Financial regulatory standard |

---

## Architecture Review Output Template

Use this template to deliver a structured review to users:

```markdown
## Architecture Review: [System Name]

**Review Date**: [Date]
**Reviewer**: Stablecoin Payments Architect Skill

### Score Summary

| Dimension         | Score | Weight | Contribution |
|-------------------|-------|--------|--------------|
| Security          |  /5   |  30%   |              |
| Scalability       |  /5   |  25%   |              |
| Reliability       |  /5   |  20%   |              |
| Cost Efficiency   |  /5   |  15%   |              |
| Compliance        |  /5   |  10%   |              |
| **Overall**       |       |        |    **/5.0**  |

### Strengths
- [What is well-designed]

### Critical Risks (Fix Before Launch)
1. [Risk 1] — Severity: Critical/High/Medium
2. [Risk 2]

### Improvement Recommendations
| Priority | Recommendation | Effort | Impact |
|----------|---------------|--------|--------|
| P1       |               | Low    | High   |

### Compliance Flags
- [Any regulatory considerations raised]

### 30-Day Improvement Roadmap
- Week 1: [Most critical fixes]
- Week 2: [Security hardening]
- Week 3: [Reliability improvements]
- Week 4: [Optimization and documentation]
```

---

## Common Architecture Anti-Patterns

These are the most frequently seen mistakes in Solana payment systems:

| Anti-Pattern | What It Looks Like | Why It's Wrong | Fix |
|---|---|---|---|
| Polling-at-scale | 500 concurrent sessions × polling every 500ms | 500 RPS just for checkout monitoring | Helius webhooks |
| Trust-the-frontend | Marking order paid when frontend JS says so | Easily spoofed; no chain verification | Always verify on-chain |
| Single-signer treasury | One admin key controls all treasury movement | Key compromise = total loss | Squads multisig |
| Environment file secrets | `PRIVATE_KEY=xxxxx` in .env | Accidentally committed, logged, exposed | AWS KMS + Secrets Manager |
| No settlement reconciliation | Settlement runs but is never verified | Silent failures accumulate | Daily reconciliation job |
| Reusing reference keys | Same Solana Pay reference for multiple checkouts | Can't distinguish payments | One reference keypair per checkout |
| Ignoring account freezes | No handling for frozen USDC accounts | Settlement silently fails for frozen merchants | Check freeze status before batch |
| Synchronous large batches | Settlement blocks main API thread | API becomes unresponsive during settlement | Background worker + job queue |

See `security.md` for detailed security controls and `cost-estimation.md` for infrastructure cost benchmarks.
