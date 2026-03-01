# Proxy Guide

Use proxies with SnapAPI to bypass geo-restrictions, access region-locked content, or screenshot websites that block data-center IPs.

---

## Why Proxies Matter for Screenshots

Most websites can detect and block headless browsers originating from data-center IP ranges. Common symptoms:

- 403 Forbidden responses
- CAPTCHA pages instead of content
- Redirects to "Access Denied" pages
- Blank or incomplete screenshots
- **Bing search results** — almost always require a residential proxy

Proxies route your request through a real residential or ISP IP address, making your screenshot request look like a real user.

---

## Option 1: Custom Proxy

Pass your own proxy configuration in the `proxy` field:

```json
{
  "url": "https://example.com",
  "proxy": {
    "server": "http://proxy.example.com:8080",
    "username": "proxy_user",
    "password": "proxy_pass"
  }
}
```

**Proxy config fields:**

| Field | Type | Description |
|-------|------|-------------|
| `server` | string | Proxy URL: `http://host:port` or `socks5://host:port` |
| `username` | string | Proxy authentication username (optional) |
| `password` | string | Proxy authentication password (optional) |
| `bypass` | array | List of domains to bypass the proxy (optional) |

**Supported proxy protocols:**
- `http://` — HTTP proxy (most common)
- `https://` — HTTPS proxy
- `socks5://` — SOCKS5 proxy

**Example with SOCKS5:**
```json
{
  "url": "https://example.com",
  "proxy": {
    "server": "socks5://proxy.example.com:1080",
    "username": "user",
    "password": "pass"
  }
}
```

**Example with bypass list:**
```json
{
  "url": "https://example.com",
  "proxy": {
    "server": "http://proxy.example.com:8080",
    "bypass": ["localhost", "*.internal.example.com"]
  }
}
```

---

## Option 2: `premiumProxy` Flag

For convenience, SnapAPI offers a managed residential proxy pool via the `premiumProxy: true` flag:

```json
{
  "url": "https://www.bing.com/search?q=screenshot+api",
  "premiumProxy": true
}
```

- No proxy credentials needed — SnapAPI handles it
- Automatically selects a residential IP
- Best for: Bing searches, Google, heavily-protected sites
- **Note:** `premiumProxy` uses Oxylabs' residential network by default

---

## Proxy Provider Comparison

Choose a proxy provider based on your use case:

### 🥇 Decodo (ex-Smartproxy) — Best for general use

- **Pool size:** 115M+ residential IPs
- **Price:** From $3.5/GB
- **Trial:** 3-day free trial
- **Best for:** General web scraping, e-commerce monitoring, SEO tools
- **Website:** [decodo.com](https://decodo.com)

**Example:**
```json
{
  "url": "https://amazon.com/dp/B0EXAMPLE",
  "proxy": {
    "server": "http://gate.smartproxy.com:10001",
    "username": "user-country-US",
    "password": "your_password"
  }
}
```

---

### 🔍 Bright Data — Best for search engines

- **Pool size:** 150M+ residential IPs
- **Price:** From $8.4/GB (residential), free trial available
- **Unique feature:** Dedicated Bing SERP API and Google SERP API
- **Best for:** Search engine result scraping, SERP monitoring
- **Website:** [brightdata.com](https://brightdata.com)

**Example:**
```json
{
  "url": "https://www.bing.com/search?q=best+screenshot+api",
  "proxy": {
    "server": "http://brd.superproxy.io:22225",
    "username": "brd-customer-CUSTOMER-zone-residential",
    "password": "your_password"
  }
}
```

---

### 💰 IPRoyal — Best budget option

- **Pool size:** 2M+ residential IPs
- **Price:** $1.75/GB — non-expiring traffic (unused GB rolls over)
- **Best for:** Small to medium projects, cost-sensitive workloads
- **Website:** [iproyal.com](https://iproyal.com)

**Example:**
```json
{
  "url": "https://example.com",
  "proxy": {
    "server": "http://geo.iproyal.com:12321",
    "username": "your_username",
    "password": "your_password_country-us"
  }
}
```

---

### 🏢 Oxylabs — Enterprise grade

- **Pool size:** 100M+ residential IPs
- **Price:** From $4/GB
- **Trial:** 7-day free trial
- **Best for:** Enterprise workloads, high reliability SLAs, advanced geo-targeting
- **Note:** This is the default provider for SnapAPI's `premiumProxy: true` flag
- **Website:** [oxylabs.io](https://oxylabs.io)

**Example:**
```json
{
  "url": "https://example.com",
  "proxy": {
    "server": "http://pr.oxylabs.io:7777",
    "username": "customer-YOUR_USERNAME",
    "password": "your_password"
  }
}
```

---

### ⚖️ Webshare — Good mid-range

- **Price:** From $2.99/GB
- **Best for:** Medium-volume projects, balance of cost and quality
- **Website:** [webshare.io](https://webshare.io)

---

## Bing Search — Always Use Proxy

Bing aggressively blocks data-center IPs. **Always** use a proxy for Bing:

```json
{
  "url": "https://www.bing.com/search?q=screenshot+api+comparison",
  "premiumProxy": true,
  "blockAds": true,
  "waitUntil": "networkidle"
}
```

Or with your own Bright Data / Decodo residential proxy:
```json
{
  "url": "https://www.bing.com/search?q=best+saas+tools+2024",
  "proxy": {
    "server": "http://gate.smartproxy.com:10001",
    "username": "your_user",
    "password": "your_pass"
  },
  "waitUntil": "networkidle",
  "delay": 1000
}
```

---

## Geo-Targeting

Most proxy providers support geo-targeted IPs. Append country/city codes to the proxy username:

```json
{
  "url": "https://example.co.uk",
  "proxy": {
    "server": "http://gate.smartproxy.com:10001",
    "username": "user-country-gb",
    "password": "pass"
  },
  "locale": "en-GB",
  "timezone": "Europe/London"
}
```

Combine with `locale` and `timezone` for a fully localized screenshot.

---

## Tips

1. **Test without proxy first** — Many sites work fine without one; save proxy bandwidth
2. **Use `premiumProxy: true`** for quick tests before setting up your own proxy
3. **Rotate sessions** — Add `-session-RANDOM` to proxy usernames if your provider supports session pinning
4. **For Google/Bing SERP:** Bright Data's dedicated SERP APIs are more reliable than generic proxies
5. **Check proxy logs** — If screenshots still fail, your proxy IP may be in a blocklist; try a different provider or country
