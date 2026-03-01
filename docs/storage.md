# Storage Guide

By default, SnapAPI returns screenshots directly in the API response. For production workflows, you can configure storage to save files automatically.

---

## Default Behavior (No Storage)

The API returns the image as binary in the response body:

```bash
curl -X POST "https://api.snapapi.pics/v1/screenshot" \
  -H "X-Api-Key: YOUR_API_KEY" \
  -d '{"url": "https://example.com"}' \
  --output screenshot.png
```

Binary response is great for one-off requests. For bulk or scheduled captures, configure storage so files are saved automatically and you receive a URL.

---

## SnapAPI Managed Storage

SnapAPI offers built-in CDN storage. Enable it in your [Dashboard](https://snapapi.pics/dashboard.html) under **Storage Settings**.

When enabled:
- Screenshots are saved to SnapAPI's CDN
- The API response includes a `url` field with the public CDN link
- Files are available for download without additional auth
- Configurable retention period (default: 30 days)

**Response with storage enabled:**
```json
{
  "success": true,
  "url": "https://cdn.snapapi.pics/screenshots/2026/03/01/abc123.png",
  "format": "png",
  "fileSize": 245632,
  "took": 1240
}
```

---

## Custom S3 Storage

Connect your own S3-compatible bucket to have full control over file storage.

Supported providers:
- AWS S3
- Cloudflare R2
- Backblaze B2
- DigitalOcean Spaces
- MinIO (self-hosted)
- Any S3-compatible storage

### Configuration

In your [Dashboard](https://snapapi.pics/dashboard.html) → **Storage Settings** → **Custom S3**:

| Field | Description |
|-------|-------------|
| **Bucket** | S3 bucket name |
| **Region** | AWS region (e.g., `us-east-1`) |
| **Endpoint** | Custom endpoint URL (for non-AWS providers) |
| **Access Key ID** | S3 access key |
| **Secret Access Key** | S3 secret key |
| **Path Prefix** | Optional prefix for all uploaded files (e.g., `screenshots/`) |
| **ACL** | File ACL: `private`, `public-read` |
| **Custom Domain** | CDN domain to use in returned URLs |

### AWS S3 Setup

1. Create an S3 bucket
2. Create an IAM user with `s3:PutObject` and `s3:GetObject` permissions on your bucket
3. Enter credentials in SnapAPI Dashboard

**Minimal IAM policy:**
```json
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Action": [
        "s3:PutObject",
        "s3:GetObject",
        "s3:DeleteObject"
      ],
      "Resource": "arn:aws:s3:::your-bucket-name/*"
    }
  ]
}
```

### Cloudflare R2 Setup

R2 is S3-compatible and has no egress fees:

1. Create an R2 bucket in Cloudflare Dashboard
2. Create an API token with **Object Read & Write** permissions
3. Set endpoint to `https://{account_id}.r2.cloudflarestorage.com`

### File Naming

Files are stored with auto-generated names based on:
- Timestamp
- URL hash (for deduplication)
- Format extension

Example: `screenshots/2026/03/01/1709294400_a1b2c3d4.png`

Set a `pathPrefix` like `screenshots/{date}/` to organize by date.

---

## Using Storage in Requests

Once storage is configured, it applies automatically. Each response includes the storage URL:

```json
{
  "success": true,
  "url": "https://your-bucket.s3.amazonaws.com/screenshots/2026/03/01/abc123.png",
  "format": "png",
  "took": 1840
}
```

---

## File Management

### Retention Policies

- **SnapAPI Storage:** Configure retention in Dashboard (7 days to forever)
- **Custom S3:** Set lifecycle rules in your S3 bucket directly

### Deleting Files

Files stored in your own S3 bucket can be deleted directly via the AWS SDK or console.

For SnapAPI Managed Storage, file management is available in the [Dashboard](https://snapapi.pics/dashboard.html).

---

## Storage + Webhooks

Combine storage with batch webhooks for a fully async workflow:

1. Submit batch job with `webhookUrl`
2. SnapAPI captures each screenshot, stores to S3
3. Webhook fires with `url` for each completed screenshot — no base64 blob transfer needed

```json
{
  "event": "screenshot.completed",
  "data": {
    "url": "https://example.com",
    "storageUrl": "https://your-bucket.s3.amazonaws.com/screenshots/abc123.png",
    "status": "completed"
  }
}
```

This is the recommended pattern for high-volume production workflows.
