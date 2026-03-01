# Scheduled Screenshots

Automate recurring screenshots with SnapAPI's built-in scheduling or by integrating with your own cron system.

---

## Option 1: SnapAPI Dashboard Scheduling

Configure scheduled screenshots directly in the [Dashboard](https://snapapi.pics/dashboard.html) → **Scheduled Jobs**:

1. Click **New Schedule**
2. Enter the URL and screenshot options
3. Set a cron expression or pick an interval
4. Configure delivery: storage URL, webhook, or email
5. Save — SnapAPI runs it automatically

**Supported intervals via UI:**
- Every hour
- Every 6 hours
- Daily
- Weekly
- Monthly
- Custom cron expression

---

## Option 2: External Cron + SnapAPI API

For maximum control, use your own scheduler (Linux cron, GitHub Actions, Vercel Cron, etc.).

### Linux / macOS cron

```bash
# Edit your crontab
crontab -e
```

```cron
# Capture dashboard screenshot every day at 9:00 AM UTC
0 9 * * * curl -s -X POST "https://api.snapapi.pics/v1/screenshot" \
  -H "X-Api-Key: YOUR_API_KEY" \
  -H "Content-Type: application/json" \
  -d '{"url":"https://your-dashboard.example.com","format":"png","fullPage":true}' \
  -o "/var/screenshots/dashboard-$(date +\%Y\%m\%d).png"

# Capture competitor pricing page every hour
0 * * * * curl -s -X POST "https://api.snapapi.pics/v1/screenshot" \
  -H "X-Api-Key: YOUR_API_KEY" \
  -d '{"url":"https://competitor.com/pricing","format":"png"}' \
  -o "/var/screenshots/competitor-pricing-$(date +\%Y\%m\%d-\%H\%M).png"
```

### Cron Expression Reference

```
┌───────────── Minute (0-59)
│ ┌─────────── Hour (0-23)
│ │ ┌───────── Day of month (1-31)
│ │ │ ┌─────── Month (1-12)
│ │ │ │ ┌───── Day of week (0-7, both 0 and 7 = Sunday)
│ │ │ │ │
* * * * *
```

| Expression | Description |
|------------|-------------|
| `* * * * *` | Every minute |
| `0 * * * *` | Every hour (at minute 0) |
| `0 9 * * *` | Every day at 9:00 AM |
| `0 9 * * 1` | Every Monday at 9:00 AM |
| `0 9 1 * *` | 1st of every month at 9:00 AM |
| `*/15 * * * *` | Every 15 minutes |
| `0 9,18 * * *` | Twice a day at 9 AM and 6 PM |
| `0 9 * * 1-5` | Weekdays at 9 AM |

---

### Node.js with node-cron

```typescript
import cron from 'node-cron';
import { SnapAPI } from '@snapapi/sdk';
import fs from 'fs';

const client = new SnapAPI({ apiKey: process.env.SNAPAPI_KEY! });

// Every day at 9 AM
cron.schedule('0 9 * * *', async () => {
  try {
    const screenshot = await client.screenshot({
      url: 'https://your-dashboard.example.com',
      format: 'png',
      fullPage: true,
      blockAds: true
    });

    const filename = `dashboard-${new Date().toISOString().split('T')[0]}.png`;
    fs.writeFileSync(`/var/screenshots/${filename}`, screenshot as Buffer);
    console.log(`✅ Saved: ${filename}`);
  } catch (err) {
    console.error('Screenshot failed:', err);
  }
});
```

### Python with APScheduler

```python
from apscheduler.schedulers.blocking import BlockingScheduler
from snapapi import SnapAPI
from datetime import datetime

client = SnapAPI(api_key='YOUR_API_KEY')
scheduler = BlockingScheduler()

@scheduler.scheduled_job('cron', hour=9, minute=0)
def capture_daily():
    screenshot = client.screenshot(
        url='https://your-dashboard.example.com',
        format='png',
        full_page=True
    )
    date = datetime.now().strftime('%Y%m%d')
    with open(f'/var/screenshots/dashboard-{date}.png', 'wb') as f:
        f.write(screenshot)
    print(f'✅ Saved dashboard-{date}.png')

scheduler.start()
```

---

### GitHub Actions

Run scheduled screenshots via GitHub Actions (free for public repos):

```yaml
# .github/workflows/scheduled-screenshot.yml
name: Daily Screenshot

on:
  schedule:
    - cron: '0 9 * * *'  # Every day at 9 AM UTC
  workflow_dispatch:       # Also allow manual trigger

jobs:
  screenshot:
    runs-on: ubuntu-latest
    steps:
      - name: Take screenshot
        run: |
          curl -X POST "https://api.snapapi.pics/v1/screenshot" \
            -H "X-Api-Key: ${{ secrets.SNAPAPI_KEY }}" \
            -H "Content-Type: application/json" \
            -d '{
              "url": "https://your-site.example.com",
              "format": "png",
              "fullPage": true
            }' \
            --output screenshot.png

      - name: Upload screenshot artifact
        uses: actions/upload-artifact@v4
        with:
          name: screenshot-${{ github.run_id }}
          path: screenshot.png
          retention-days: 30
```

---

### Vercel Cron Jobs

```typescript
// app/api/cron/screenshot/route.ts
export const runtime = 'edge';

export async function GET(request: Request) {
  // Verify this is actually from Vercel Cron
  const authHeader = request.headers.get('authorization');
  if (authHeader !== `Bearer ${process.env.CRON_SECRET}`) {
    return new Response('Unauthorized', { status: 401 });
  }

  const response = await fetch('https://api.snapapi.pics/v1/screenshot', {
    method: 'POST',
    headers: {
      'X-Api-Key': process.env.SNAPAPI_KEY!,
      'Content-Type': 'application/json'
    },
    body: JSON.stringify({
      url: 'https://your-site.example.com',
      format: 'png',
      fullPage: true
    })
  });

  // Save to Vercel Blob or send to storage
  const buffer = await response.arrayBuffer();
  // ...

  return new Response('OK');
}
```

```json
// vercel.json
{
  "crons": [
    {
      "path": "/api/cron/screenshot",
      "schedule": "0 9 * * *"
    }
  ]
}
```

---

## Use Cases

| Use Case | Schedule | Setup |
|----------|----------|-------|
| Daily status page archive | `0 9 * * *` | Cron + S3 storage |
| Hourly competitor price monitoring | `0 * * * *` | Cron + Extract API |
| Weekly design regression testing | `0 9 * * 1` | GitHub Actions |
| Real-time uptime monitoring | `*/5 * * * *` | Cron + Webhook alert |
| Monthly SEO screenshot snapshots | `0 9 1 * *` | Dashboard scheduler |
