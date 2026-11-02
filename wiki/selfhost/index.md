---
title: "Self-hosted tools"
---
{% raw %}

## Pdf Utilities

### Stirling-PDF
- **Website:** [GitHub — Stirling-Tools/Stirling-PDF](https://github.com/Stirling-Tools/Stirling-PDF)
- **Deploy:** desktop app or standalone JAR (Java)
- **Features:**
  - Manual and automatic redaction (regex-based, e.g. IBAN, tax codes)
  - Merge / split, conversion, OCR, compression

## Notes & Sync

### Joplin Server
- **Website:** [joplinapp.org](https://joplinapp.org) · source: [GitHub — laurent22/joplin](https://github.com/laurent22/joplin) (`packages/server`)
- **Deploy:** Node.js, built from the Joplin repository; default port `22300`
- **Database:** PostgreSQL (recommended); SQLite only for testing
- **Features:**
  - Sync target for Joplin desktop / mobile clients
  - Note sharing and collaboration between users
  - Publish notes as public web pages

{% endraw %}
