# Error Reference

All SnapAPI errors follow a consistent format:

```json
{
  "error": {
    "code": "ERROR_CODE",
    "message": "Human-readable description",
    "details": {}
  }
}
```

---

## HTTP Status Codes

| Status | Code | Description | What to do |
|--------|------|-------------|------------|
| `400` | `INVALID_REQUEST` | Missing or invalid request parameters | Check required fields |
| `400` | `INVALID_URL` | URL is malformed or missing scheme | Ensure URL starts with `http://` or `https://` |
| `400` | `INVALID_FORMAT` | Unsupported output format | Use `png`, `jpeg`, `webp`, `avif`, or `pdf` |
| `401` | `INVALID_API_KEY` | API key is missing, invalid, or revoked | Check your key in the Dashboard |
| `402` | `QUOTA_EXCEEDED` | Monthly screenshot quota exceeded | Upgrade plan or wait for monthly reset |
| `404` | `NOT_FOUND` | Endpoint or resource not found | Check the endpoint URL |
| `422` | `CONTENT_CHECK_FAILED` | `failIfContentMissing` or `failIfContentContains` triggered | Expected content not found (or unwanted content found) |
| `429` | `RATE_LIMITED` | Too many requests per second | Implement exponential backoff |
| `500` | `SCREENSHOT_FAILED` | Internal error during capture | Retry — if persistent, check URL accessibility |
| `500` | `RENDER_FAILED` | HTML/Markdown rendering failed | Check your HTML/Markdown syntax |
| `504` | `TIMEOUT` | Page load exceeded timeout | Increase `timeout`, or check if the URL is reachable |

---

## Error Details

### `400 INVALID_REQUEST`

Missing required parameter or invalid value.

```json
{
  "error": {
    "code": "INVALID_REQUEST",
    "message": "Request validation failed",
    "details": {
      "url": "URL is required when html and markdown are not provided"
    }
  }
}
```

**Fix:** Ensure `url`, `html`, or `markdown` is included.

---

### `400 INVALID_URL`

```json
{
  "error": {
    "code": "INVALID_URL",
    "message": "The provided URL is not valid: 'example.com'",
    "details": {
      "url": "example.com"
    }
  }
}
```

**Fix:** Add `https://` prefix — use `https://example.com` not `example.com`.

---

### `401 INVALID_API_KEY`

```json
{
  "error": {
    "code": "INVALID_API_KEY",
    "message": "The provided API key is invalid or has been revoked."
  }
}
```

**Fix:**
1. Check that you're passing the key correctly: `X-Api-Key: YOUR_API_KEY`
2. Verify the key in your [Dashboard](https://snapapi.pics/dashboard.html)
3. If recently regenerated, update all references

---

### `402 QUOTA_EXCEEDED`

```json
{
  "error": {
    "code": "QUOTA_EXCEEDED",
    "message": "You have exceeded your monthly quota of 200 screenshots.",
    "details": {
      "used": 200,
      "limit": 200,
      "resetAt": "2026-04-01T00:00:00Z"
    }
  }
}
```

**Fix:** [Upgrade your plan](https://snapapi.pics/#pricing) or wait for the monthly reset.

---

### `422 CONTENT_CHECK_FAILED`

```json
{
  "error": {
    "code": "CONTENT_CHECK_FAILED",
    "message": "Content check failed: 'Please log in' was found on the page.",
    "details": {
      "trigger": "failIfContentContains",
      "match": "Please log in"
    }
  }
}
```

**Fix:** Review your cookies/auth setup, or adjust `failIfContentContains`/`failIfContentMissing`.

---

### `429 RATE_LIMITED`

```json
{
  "error": {
    "code": "RATE_LIMITED",
    "message": "Rate limit exceeded. Maximum 5 requests per second on your plan.",
    "details": {
      "limit": 5,
      "retryAfter": 1
    }
  }
}
```

The response includes a `Retry-After` header (seconds to wait before retrying).

**Fix:** Implement exponential backoff — see [Retry Logic](#retry-logic).

---

### `504 TIMEOUT`

```json
{
  "error": {
    "code": "TIMEOUT",
    "message": "Page load timed out after 30000ms.",
    "details": {
      "timeout": 30000,
      "url": "https://slow-site.example.com"
    }
  }
}
```

**Fix:**
1. Increase `timeout` (up to 60000ms)
2. Use `waitUntil: "domcontentloaded"` instead of `networkidle` for faster capture
3. Check if the URL is publicly accessible

---

## Retry Logic

For `429 RATE_LIMITED` and `5xx` errors, implement exponential backoff:

### JavaScript

```typescript
async function screenshotWithRetry(client, options, maxRetries = 3) {
  let delay = 1000; // Start with 1 second

  for (let attempt = 0; attempt <= maxRetries; attempt++) {
    try {
      return await client.screenshot(options);
    } catch (error) {
      if (attempt === maxRetries) throw error;

      // Only retry on rate limit or server errors
      if (error.statusCode === 429 || error.statusCode >= 500) {
        const retryAfter = error.details?.retryAfter ?? delay / 1000;
        const waitMs = retryAfter * 1000;

        console.log(`Attempt ${attempt + 1} failed. Retrying in ${waitMs}ms...`);
        await new Promise(resolve => setTimeout(resolve, waitMs));

        delay *= 2; // Exponential backoff
      } else {
        throw error; // Don't retry 4xx errors (except 429)
      }
    }
  }
}
```

### Python

```python
import time

def screenshot_with_retry(client, options, max_retries=3):
    delay = 1.0

    for attempt in range(max_retries + 1):
        try:
            return client.screenshot(**options)
        except Exception as e:
            if attempt == max_retries:
                raise

            status = getattr(e, 'status_code', None)
            if status in (429,) or (status and status >= 500):
                wait = getattr(e, 'retry_after', delay)
                print(f"Attempt {attempt + 1} failed. Retrying in {wait}s...")
                time.sleep(wait)
                delay *= 2
            else:
                raise
```

---

## Which Errors to Retry

| Status | Should Retry? | Strategy |
|--------|---------------|----------|
| `400` | ❌ No | Fix the request parameters |
| `401` | ❌ No | Fix the API key |
| `402` | ❌ No | Upgrade plan |
| `422` | ❌ No | Fix content check conditions |
| `429` | ✅ Yes | Wait for `Retry-After` header |
| `500` | ✅ Yes | Exponential backoff (usually transient) |
| `504` | ⚠️ Maybe | Increase `timeout`, then retry once |

---

## Debugging Tips

1. **Check `/v1/usage`** — confirm quota isn't the issue
2. **Test the URL in a browser** — confirm it's publicly accessible
3. **Try `waitUntil: "load"`** — simpler wait condition catches fewer timeouts
4. **Add `"delay": 2000"`** — give JS-heavy pages time to render
5. **Check `failIfContentContains` patterns** — overly broad strings trigger false positives
