# Webhooks & Async Jobs

SnapAPI supports asynchronous screenshot capture via the Batch API and webhook notifications.

---

## Why Async?

Synchronous requests work great for single screenshots. But for:
- **100+ URLs at once** → Batch API
- **Long-running pages** (heavy JS, animations) → Async + webhook
- **Scheduled captures** → Cron + webhook

Use the Batch API with a webhook URL to receive results as they complete.

---

## Batch API

### Submit a batch job

`POST https://api.snapapi.pics/v1/screenshot/batch`

```bash
curl -X POST "https://api.snapapi.pics/v1/screenshot/batch" \
  -H "X-Api-Key: YOUR_API_KEY" \
  -H "Content-Type: application/json" \
  -d '{
    "urls": [
      "https://site1.com",
      "https://site2.com",
      "https://site3.com"
    ],
    "format": "png",
    "fullPage": false,
    "blockAds": true,
    "webhookUrl": "https://your-server.com/snapapi/webhook"
  }'
```

**Response:**
```json
{
  "success": true,
  "jobId": "job_a1b2c3d4",
  "status": "pending",
  "total": 3,
  "createdAt": "2026-03-01T12:00:00Z"
}
```

---

### Poll job status

`GET https://api.snapapi.pics/v1/screenshot/batch/{jobId}`

```bash
curl "https://api.snapapi.pics/v1/screenshot/batch/job_a1b2c3d4" \
  -H "X-Api-Key: YOUR_API_KEY"
```

**Response (in progress):**
```json
{
  "success": true,
  "jobId": "job_a1b2c3d4",
  "status": "processing",
  "total": 3,
  "completed": 1,
  "failed": 0
}
```

**Response (complete):**
```json
{
  "success": true,
  "jobId": "job_a1b2c3d4",
  "status": "completed",
  "total": 3,
  "completed": 3,
  "failed": 0,
  "createdAt": "2026-03-01T12:00:00Z",
  "completedAt": "2026-03-01T12:00:45Z",
  "results": [
    {
      "url": "https://site1.com",
      "status": "completed",
      "data": "base64_encoded_image...",
      "duration": 1240
    },
    {
      "url": "https://site2.com",
      "status": "completed",
      "data": "base64_encoded_image...",
      "duration": 980
    },
    {
      "url": "https://site3.com",
      "status": "failed",
      "error": "Timeout: page took too long to load",
      "duration": 30000
    }
  ]
}
```

**Job statuses:**

| Status | Description |
|--------|-------------|
| `pending` | Job queued, not started |
| `processing` | Actively capturing screenshots |
| `completed` | All captures done |
| `failed` | Job failed (check `results` for per-URL errors) |

---

## Webhooks

When you provide a `webhookUrl`, SnapAPI sends an HTTP POST to your URL when:
1. Individual screenshots in a batch complete
2. The entire batch completes

### Webhook Event Payload

```json
{
  "event": "batch.completed",
  "jobId": "job_a1b2c3d4",
  "timestamp": "2026-03-01T12:00:45Z",
  "data": {
    "total": 3,
    "completed": 3,
    "failed": 0,
    "results": [
      {
        "url": "https://site1.com",
        "status": "completed",
        "data": "base64...",
        "duration": 1240
      }
    ]
  }
}
```

**Event types:**

| Event | Triggered when |
|-------|----------------|
| `batch.created` | Batch job is submitted |
| `screenshot.completed` | Single URL completed within a batch |
| `screenshot.failed` | Single URL failed within a batch |
| `batch.completed` | All URLs in batch are done |
| `batch.failed` | Entire batch failed |

---

## HMAC Signature Verification

SnapAPI signs every webhook request with an HMAC-SHA256 signature so you can verify it's genuinely from SnapAPI.

The signature is sent in the `X-SnapAPI-Signature` header:
```
X-SnapAPI-Signature: sha256=abc123...
```

### Verifying the signature

**Node.js:**
```javascript
const crypto = require('crypto');

function verifyWebhook(payload, signature, secret) {
  const expected = 'sha256=' + crypto
    .createHmac('sha256', secret)
    .update(payload, 'utf8')
    .digest('hex');

  // Use timingSafeEqual to prevent timing attacks
  return crypto.timingSafeEqual(
    Buffer.from(expected),
    Buffer.from(signature)
  );
}

// Express.js example
app.post('/snapapi/webhook', express.raw({ type: 'application/json' }), (req, res) => {
  const signature = req.headers['x-snapapi-signature'];
  const secret = process.env.SNAPAPI_WEBHOOK_SECRET;

  if (!verifyWebhook(req.body, signature, secret)) {
    return res.status(401).json({ error: 'Invalid signature' });
  }

  const event = JSON.parse(req.body);
  console.log('Received event:', event.event);

  if (event.event === 'batch.completed') {
    // Process results
    for (const result of event.data.results) {
      if (result.status === 'completed') {
        const buffer = Buffer.from(result.data, 'base64');
        // Save or process buffer
      }
    }
  }

  res.status(200).json({ received: true });
});
```

**Python (FastAPI):**
```python
import hmac
import hashlib
from fastapi import FastAPI, Request, HTTPException

app = FastAPI()
WEBHOOK_SECRET = "your_webhook_secret"

@app.post("/snapapi/webhook")
async def handle_webhook(request: Request):
    body = await request.body()
    signature = request.headers.get("x-snapapi-signature", "")

    expected = "sha256=" + hmac.new(
        WEBHOOK_SECRET.encode(),
        body,
        hashlib.sha256
    ).hexdigest()

    if not hmac.compare_digest(expected, signature):
        raise HTTPException(status_code=401, detail="Invalid signature")

    event = await request.json()
    print(f"Received event: {event['event']}")

    if event["event"] == "batch.completed":
        for result in event["data"]["results"]:
            if result["status"] == "completed":
                import base64
                image_data = base64.b64decode(result["data"])
                # Process image_data

    return {"received": True}
```

**PHP:**
```php
<?php
$payload = file_get_contents('php://input');
$signature = $_SERVER['HTTP_X_SNAPAPI_SIGNATURE'] ?? '';
$secret = getenv('SNAPAPI_WEBHOOK_SECRET');

$expected = 'sha256=' . hash_hmac('sha256', $payload, $secret);

if (!hash_equals($expected, $signature)) {
    http_response_code(401);
    echo json_encode(['error' => 'Invalid signature']);
    exit;
}

$event = json_decode($payload, true);
echo json_encode(['received' => true]);
```

---

## Polling Pattern (Without Webhooks)

If you can't receive webhooks (e.g., serverless functions without public URL), poll for status:

```javascript
async function waitForBatch(client, jobId, intervalMs = 2000, maxWaitMs = 300000) {
  const start = Date.now();

  while (Date.now() - start < maxWaitMs) {
    const status = await client.getBatchStatus(jobId);

    if (status.status === 'completed' || status.status === 'failed') {
      return status;
    }

    console.log(`Progress: ${status.completed}/${status.total}`);
    await new Promise(resolve => setTimeout(resolve, intervalMs));
  }

  throw new Error('Batch timed out');
}

// Usage
const batch = await client.batch({
  urls: ['https://site1.com', 'https://site2.com'],
  format: 'png'
});

const result = await waitForBatch(client, batch.jobId);
console.log('Done:', result.results);
```

---

## Webhook Best Practices

1. **Return 200 quickly** — Process the event asynchronously; respond immediately
2. **Idempotent handlers** — Webhooks may be retried on failure; handle duplicates safely
3. **Always verify HMAC** — Never skip signature verification in production
4. **Use HTTPS** — Webhook endpoints must use HTTPS
5. **Log everything** — Store raw payloads for debugging and reprocessing
