# Getting Started with SnapAPI

Get your first screenshot in under 5 minutes.

## Step 1: Get Your API Key

1. Go to [snapapi.pics/register.html](https://snapapi.pics/register.html)
2. Sign up — no credit card required
3. Copy your API key from the [Dashboard](https://snapapi.pics/dashboard.html)

Your key looks like: `YOUR_API_KEYxxxxxxxxxxxxxxxxxxxxx`

**Free tier:** 200 API calls/month — enough to explore every feature.

---

## Step 2: Take Your First Screenshot

```bash
curl -X POST "https://api.snapapi.pics/v1/screenshot" \
  -H "X-Api-Key: YOUR_API_KEY" \
  -H "Content-Type: application/json" \
  -d '{"url": "https://example.com", "format": "png"}' \
  --output screenshot.png

# ✅ screenshot.png saved!
```

Open `screenshot.png` — you should see a full-browser screenshot of example.com.

---

## Step 3: Install a SDK (Optional)

For production use, install the SDK for your language:

```bash
# JavaScript / TypeScript
npm install @snapapi/sdk

# Python
pip install snapapi

# PHP
composer require snapapi/sdk

# Go
go get github.com/Sleywill/snapapi-go
```

**JavaScript quick test:**

```javascript
const { SnapAPI } = require('@snapapi/sdk');
const fs = require('fs');

const client = new SnapAPI({ apiKey: 'YOUR_API_KEY' });

async function main() {
  const screenshot = await client.screenshot({
    url: 'https://example.com',
    format: 'png'
  });
  fs.writeFileSync('screenshot.png', screenshot);
  console.log('✅ Screenshot saved!');
}

main();
```

---

## Step 4: Try Each Endpoint

### Screenshot with options

```bash
curl -X POST "https://api.snapapi.pics/v1/screenshot" \
  -H "X-Api-Key: YOUR_API_KEY" \
  -H "Content-Type: application/json" \
  -d '{
    "url": "https://github.com",
    "format": "webp",
    "fullPage": true,
    "blockAds": true,
    "blockCookieBanners": true,
    "darkMode": true,
    "quality": 90
  }' \
  --output github-dark.webp
```

### Generate a PDF

```bash
curl -X POST "https://api.snapapi.pics/v1/pdf" \
  -H "X-Api-Key: YOUR_API_KEY" \
  -H "Content-Type: application/json" \
  -d '{
    "url": "https://example.com",
    "pdfOptions": {
      "pageSize": "a4",
      "marginTop": "20mm",
      "marginBottom": "20mm",
      "printBackground": true
    }
  }' \
  --output document.pdf
```

### Extract article text (for AI/LLM use)

```bash
curl -X POST "https://api.snapapi.pics/v1/extract" \
  -H "X-Api-Key: YOUR_API_KEY" \
  -H "Content-Type: application/json" \
  -d '{
    "url": "https://en.wikipedia.org/wiki/Web_scraping",
    "type": "article",
    "cleanOutput": true
  }'
```

### Capture a mobile screenshot (iPhone 15 Pro)

```bash
curl -X POST "https://api.snapapi.pics/v1/screenshot" \
  -H "X-Api-Key: YOUR_API_KEY" \
  -H "Content-Type: application/json" \
  -d '{
    "url": "https://example.com",
    "device": "iphone-15-pro",
    "format": "png"
  }' \
  --output mobile.png
```

### Capture a video scroll

```bash
curl -X POST "https://api.snapapi.pics/v1/video" \
  -H "X-Api-Key: YOUR_API_KEY" \
  -H "Content-Type: application/json" \
  -d '{
    "url": "https://example.com",
    "format": "mp4",
    "scroll": true,
    "scrollEasing": "ease_in_out",
    "scrollBack": true
  }' \
  --output scroll.mp4
```

---

## Step 5: Check Your Usage

```bash
curl "https://api.snapapi.pics/v1/usage" \
  -H "X-Api-Key: YOUR_API_KEY"
```

```json
{
  "used": 12,
  "limit": 200,
  "remaining": 188,
  "resetAt": "2026-04-01T00:00:00Z"
}
```

---

## Next Steps

| I want to… | Read this |
|------------|-----------|
| Learn all screenshot options | [screenshot.md](screenshot.md) |
| Extract content for AI | [extract.md](extract.md) |
| Use AI to analyze pages | [analyze.md](analyze.md) |
| Use proxies for blocked sites | [proxy.md](proxy.md) |
| Capture hundreds of URLs | [webhooks.md](webhooks.md) |
| Schedule daily screenshots | [scheduled.md](scheduled.md) |
| Handle errors & retries | [errors.md](errors.md) |

---

## Common Questions

**My screenshot is blank / wrong**
- Add `"delay": 2000` to wait for JS to render
- Try `"waitUntil": "networkidle"` for SPAs

**I get 401 Unauthorized**
- Check your API key in the [Dashboard](https://snapapi.pics/dashboard.html)
- Use header `X-Api-Key`, not `Authorization`

**I get 402 Quota Exceeded**
- Check usage: `GET /v1/usage`
- [Upgrade your plan](https://snapapi.pics/#pricing)

**Page loads but content is in another language**
- Set `"locale": "en-US"` and `"timezone": "America/New_York"`
