# Vyuha Finance — Personal Money Manager

**Built by Manjeet Ahuja** | Vyuha Systems

A personal finance PWA for tracking purchases, savings, transactions, goals, and trip expenses — with full CRUD operations backed by IndexedDB.

## 🚀 Live

**GitHub Pages:** https://manjeetahuja23.github.io/Vyuha-Finance-PWA/

**Local:** http://localhost:8080/

## 📱 Features

- **Purchases** — Add, edit, delete, and categorize purchases with full IndexedDB persistence
- **Savings** — Track savings goals and progress
- **Transactions** — Log and view all financial transactions
- **Trips** — Manage trip expenses and budgets
- **Gmail Import** — Bulk-import purchase receipts from Gmail via `import.html`

## 📥 Import Gmail Purchases

Visit `http://localhost:8080/import.html` to upload cleaned Gmail purchase JSON files:

| File | Description |
|------|-------------|
| `gmail_purchases_inr.json` | 1,797 INR purchases |
| `gmail_purchases_cad.json` | 261 CAD purchases |
| `gmail_purchases_merged.json` | 2,058 merchant+bank merged entries |

## 🛠️ Tech Stack

- Vanilla HTML/CSS/JS (no frameworks)
- IndexedDB for local data persistence
- PWA-ready with manifest and service worker
- Deployed on GitHub Pages

## 💬 Public Note

**This is Vyuha Finance — Manjeet's personal money manager, built in the open.**  
If you're seeing this on GitHub, welcome! This project tracks real purchases extracted from Gmail receipts, bifurcated by currency (INR/CAD), and ready for anyone to fork and adapt for their own PFM needs.

---

Made with ⚡ by Vyuha Systems
