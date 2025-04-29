
# Big Boss Gym - Local Setup Guide

## 📂 Project Structure
- `/frontend` ➔ Website (members, trainers, shop, payments, invoice)
- `/backend` ➔ Node.js Express server (APIs: login, members, payments, feedback)
- `/admin-dashboard` ➔ Admin Dashboard (manage members, trainers, payments)

## 🛠 How to Run Locally

### 1. Start Backend Server
```bash
cd backend
npm install
node server.js
```
Backend will run at `http://localhost:5000/`

### 2. Start Frontend
- Open `frontend/index.html` directly in browser
- Or use a simple live server extension (example: VSCode "Live Server").

### 3. Start Admin Dashboard
- Open `admin-dashboard/index.html` directly in browser
- Or use Live Server for better experience.

## 🛜 API URL
Frontend and Admin Dashboard talk to backend at `http://localhost:5000/api/...`
