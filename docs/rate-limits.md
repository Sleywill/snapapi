# Rate Limits

SnapAPI enforces per-plan rate limits to ensure fair usage and API stability.

---

## Limits by Plan

| Plan | Requests/second | Requests/month | Concurrent |
|------|-----------------|----------------|------------|
| **Free** | 1 | 200 | 1 |
| **Starter** | 5 | 5,000 | 3 |
| **Pro** | 20 | 50,000 | 10 |
| **Enterprise** | Custom | Unlimited | Custom |

Rate limits apply **per API key**.

---

## Rate Limit Headers

Every response includes headers to help you track your rate limit status:

```http
X-RateLimit-Limit: 5
X-RateLimit-Remaining: 3
X-RateLimit-Reset: 1709294400
X-RateLimit-Window: 1s
```

| Header | Description |
|--------|-------------|
| `X-RateLimit-Limit` | Max requests allowed per window |
| `X-RateLimit-Remaining` | Requests remaining in current window |
| `X-RateLimit-Reset` | Unix timestamp when the window resets |
| `X-RateLimit-Window` | Window duration (e.g., `1s`) |

When a monthly quota limit is approaching:
```http
X-Quota-Used: 4800
X-Quota-Limit: 5000
X-Quota-Reset: 2026-04-01T00:00:00Z
```

---

## When You Hit the Limit: 429 Response

```json
{
  "error": {
    "code": "RATE_LIMITED",
    "message": "Rate limit exceeded. Maximum 5 requests per second.",
    "details": {
      "limit": 5,
      "retryAfter": 1
    }
  }
}
```

Plus the header:
```http
Retry-After: 1
```

---

## Handling 429 Responses

### Simple backoff

```javascript
async function screenshot(client, options) {
  while (true) {
    try {
      return await client.screenshot(options);
    } catch (err) {
      if (err.statusCode === 429) {
        const wait = (err.details?.retryAfter ?? 1) * 1000;
        await new Promise(r => setTimeout(r, wait));
      } else {
        throw err;
      }
    }
  }
}
```

### Batch with rate limiting

When processing many URLs, use a concurrency limiter:

```javascript
import PQueue from 'p-queue';

const queue = new PQueue({
  concurrency: 5,   // Max concurrent requests (match your plan)
  intervalCap: 5,   // Max per interval
  interval: 1000    // Interval: 1 second
});

const urls = ['https://a.com', 'https://b.com', /* ... */];

const results = await Promise.all(
  urls.map(url => queue.add(() =>
    client.screenshot({ url, format: 'png' })
  ))
);
```

### Python with rate limiting

```python
import asyncio
from asyncio import Semaphore

async def capture_all(urls, max_concurrent=5):
    sem = Semaphore(max_concurrent)

    async def capture_one(url):
        async with sem:
            return await client.screenshot_async(url=url)

    return await asyncio.gather(*[capture_one(url) for url in urls])
```

---

## Quota Limits

Monthly quotas reset on the **1st of each month at 00:00 UTC**.

Check your current usage:
```bash
curl "https://api.snapapi.pics/v1/usage" \
  -H "X-Api-Key: YOUR_API_KEY"
```

```json
{
  "used": 4234,
  "limit": 5000,
  "remaining": 766,
  "resetAt": "2026-04-01T00:00:00Z"
}
```

### Pay-as-you-go overages

On Starter and Pro plans, you can go over your quota at **$0.002 per screenshot** rather than being cut off. Configure overage limits in your [Dashboard](https://snapapi.pics/dashboard.html).

---

## Enterprise / High Volume

Need >20 req/s or >50,000 screenshots/month? [Contact us](mailto:support@snapapi.pics) for:
- Custom rate limits
- Dedicated infrastructure
- Volume pricing
- SLA guarantees
