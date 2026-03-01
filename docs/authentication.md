# Authentication

All SnapAPI requests require an API key.

---

## Getting Your API Key

1. Sign up at [snapapi.pics/register.html](https://snapapi.pics/register.html)
2. After login, go to the [Dashboard](https://snapapi.pics/dashboard.html)
3. Copy your API key

Your key looks like: `YOUR_API_KEYxxxxxxxxxxxxxxxxxxxxxxxxxxxxx`

**Security:** Your API key is shown once on creation. Store it securely — treat it like a password.

---

## Using Your API Key

### Method 1: HTTP Header (Recommended)

```http
X-Api-Key: YOUR_API_KEY
```

Example:
```bash
curl -X POST "https://api.snapapi.pics/v1/screenshot" \
  -H "X-Api-Key: YOUR_API_KEY" \
  -H "Content-Type: application/json" \
  -d '{"url": "https://example.com"}'
```

### Method 2: Query Parameter

Append `?access_key=` to the URL. Useful for quick testing or environments where setting headers is difficult:

```bash
curl -X POST "https://api.snapapi.pics/v1/screenshot?access_key=YOUR_API_KEY" \
  -H "Content-Type: application/json" \
  -d '{"url": "https://example.com"}'
```

> ⚠️ **Avoid in production:** Query parameters can appear in server logs and browser history. Always use the header method in production.

---

## SDK Authentication

All official SDKs accept the API key in the constructor:

```typescript
// JavaScript
const client = new SnapAPI({ apiKey: 'YOUR_API_KEY' });
```

```python
# Python
client = SnapAPI(api_key='YOUR_API_KEY')
```

```go
// Go
client := snapapi.NewClient("YOUR_API_KEY")
```

```php
// PHP
$client = new \SnapAPI\Client('YOUR_API_KEY');
```

```swift
// Swift
let client = SnapAPI(apiKey: "YOUR_API_KEY")
```

```kotlin
// Kotlin
val client = SnapAPI("YOUR_API_KEY")
```

---

## Environment Variables (Best Practice)

Never hardcode API keys. Use environment variables:

```bash
# .env
SNAPAPI_KEY=YOUR_API_KEY
```

```typescript
const client = new SnapAPI({ apiKey: process.env.SNAPAPI_KEY! });
```

```python
import os
client = SnapAPI(api_key=os.environ['SNAPAPI_KEY'])
```

---

## Key Management

### Rotating Your API Key

If your key is compromised:
1. Go to [Dashboard](https://snapapi.pics/dashboard.html)
2. Click **Regenerate API Key**
3. Update your environment variables
4. The old key is immediately invalidated

### Multiple Keys (Enterprise)

Enterprise plans support multiple API keys for:
- Separating production and staging environments
- Per-team or per-service access control
- Usage tracking per key

Contact [support@snapapi.pics](mailto:support@snapapi.pics) for multi-key setup.

---

## Error Responses

| HTTP Status | Meaning |
|-------------|---------|
| `401 Unauthorized` | Missing or invalid API key |
| `402 Payment Required` | Quota exceeded — upgrade your plan |
| `429 Too Many Requests` | Rate limit hit — slow down requests |

**401 response body:**
```json
{
  "error": {
    "code": "INVALID_API_KEY",
    "message": "The provided API key is invalid or has been revoked."
  }
}
```
