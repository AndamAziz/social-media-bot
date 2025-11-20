cd /root/
# ناو VPS
cd /root/AVIN-main
npm install
npm start  # یان npm run dev
```

ئینجا لە Mac براوسەرت:
```
http://77.68.125.218:PORT
npm run dev
http://77.68.125.218:PORT
curl -fsSL https://deb.nodesource.com/setup_20.x | sudo -E bash -
sudo apt install -y nodejs npm
node --version
npm --version
apt clean
apt update
apt install -y nodejs
curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.0/install.sh | bash
source ~/.bashrc
nvm install 20
nvm use 20
node --version
npm --version
cd /root/AVIN-main
npm install
npm start
ls -la /root/AVIN-main/
ls -la /root/ | grep -i avin
find /root/ -name "*.zip" -o -name "package.json"
cd /root/
unzip AVIN-main.zip
ls -la AVIN-main/
cd /root/AVIN-main
npm install
npm start
ls -la /root/AVIN-main/
find /root/ -name "package.json"
find /root/ -name "package.json" -not -path "*/.nvm/*"
cd /root/AVIN-main
cat README.md
cd /root/AVIN-main
cat README.md
cd /root/AVIN-main
cat README.md
cd /root/AVIN-main
git remote -v
ls -la
ls -la /root/ | head -20
cd /root/
mkdir avin-backend
cd avin-backend
npm init -y
npm install express cors dotenv bcryptjs jsonwebtoken mongoose
# لە Mac:
scp -r ~/path/to/backend root@77.68.125.218:/root/avin-backend
# لە VPS:
cd /root/
mkdir avin-backend
cd avin-backend
npm init -y
exit
cd ~/Downloads/AVIN-main/
ls -la
cat package.json
scp -r ~/Downloads/AVIN-main/ root@77.68.125.218:/root/avin-project/
ssh root@77.68.125.218
cd ~/Downloads/AVIN-main/
cat package.json
ssh-keyscan -H 77.68.125.218 >> ~/.ssh/known_hosts
ssh root@77.68.125.218
cd /root/
mkdir avin-backend
cd avin-backend
npm init -y
npm install express cors dotenv bcryptjs jsonwebtoken mongoose
# لە Mac:
scp -r ~/path/to/backend root@77.68.125.218:/root/avin-backend
cd /root/avin-backend
npm start
clear 
cat > /root/avin-backend/package.json << 'EOF'
{
  "name": "avin-backend",
  "version": "1.0.0",
  "main": "server.js",
  "scripts": {
    "start": "node server.js",
    "dev": "node server.js"
  },
  "keywords": [],
  "author": "",
  "license": "ISC",
  "dependencies": {
    "bcryptjs": "^3.0.3",
    "cors": "^2.8.5",
    "dotenv": "^17.2.3",
    "express": "^5.1.0",
    "jsonwebtoken": "^9.0.2",
    "mongoose": "^8.19.4"
  }
}
EOF

npm start
cat > /root/avin-backend/server.js << 'EOF'
const express = require('express');
const cors = require('cors');
const dotenv = require('dotenv');
const jwt = require('jsonwebtoken');
const bcrypt = require('bcryptjs');

dotenv.config();

const app = express();

// Middleware
app.use(cors());
app.use(express.json());

// In-memory databases (بۆ ئێستە)
let users = [];
let quizzes = [];
let results = [];

// Routes

// 1. User Signup
app.post('/api/auth/signup', async (req, res) => {
  try {
    const { username, password, email } = req.body;
    
    if (users.find(u => u.username === username)) {
      return res.status(400).json({ error: 'User already exists' });
    }
    
    const hashedPassword = await bcrypt.hash(password, 10);
    
    const user = {
      id: Date.now().toString(),
      username,
      password: hashedPassword,
      email,
      role: 'user'
    };
    
    users.push(user);
    res.json({ success: true, message: 'User created' });
  } catch (err) {
    res.status(400).json({ error: err.message });
  }
});

// 2. User Login
app.post('/api/auth/login', async (req, res) => {
  try {
    const { username, password } = req.body;
    
    const user = users.find(u => u.username === username);
    if (!user) return res.status(401).json({ error: 'User not found' });
    
    const validPassword = await bcrypt.compare(password, user.password);
    if (!validPassword) return res.status(401).json({ error: 'Invalid password' });
    
    const token = jwt.sign({ id: user.id, role: user.role }, process.env.JWT_SECRET || 'secret', { expiresIn: '24h' });
    
    res.json({ success: true, token, userId: user.id, role: user.role });
  } catch (err) {
    res.status(400).json({ error: err.message });
  }
});

// 3. Get All Quizzes
app.get('/api/quizzes', (req, res) => {
  res.json(quizzes);
});

// 4. Get Quiz by ID
app.get('/api/quizzes/:id', (req, res) => {
  const quiz = quizzes.find(q => q.id === req.params.id);
  if (!quiz) return res.status(404).json({ error: 'Quiz not found' });
  res.json(quiz);
});

// 5. Create Quiz (Admin only)
app.post('/api/quizzes', (req, res) => {
  try {
    const token = req.headers.authorization?.split(' ')[1];
    if (!token) return res.status(401).json({ error: 'No token' });
    
    const decoded = jwt.verify(token, process.env.JWT_SECRET || 'secret');
    if (decoded.role !== 'admin') return res.status(403).json({ error: 'Not admin' });
    
    const quiz = {
      id: Date.now().toString(),
      ...req.body,
      createdAt: new Date()
    };
    
    quizzes.push(quiz);
    res.json({ success: true, quiz });
  } catch (err) {
    res.status(400).json({ error: err.message });
  }
});

// 6. Update Quiz (Admin only)
app.put('/api/quizzes/:id', (req, res) => {
  try {
    const token = req.headers.authorization?.split(' ')[1];
    if (!token) return res.status(401).json({ error: 'No token' });
    
    const decoded = jwt.verify(token, process.env.JWT_SECRET || 'secret');
    if (decoded.role !== 'admin') return res.status(403).json({ error: 'Not admin' });
    
    const index = quizzes.findIndex(q => q.id === req.params.id);
    if (index === -1) return res.status(404).json({ error: 'Quiz not found' });
    
    quizzes[index] = { ...quizzes[index], ...req.body };
    res.json({ success: true, quiz: quizzes[index] });
  } catch (err) {
    res.status(400).json({ error: err.message });
  }
});

// 7. Delete Quiz (Admin only)
app.delete('/api/quizzes/:id', (req, res) => {
  try {
    const token = req.headers.authorization?.split(' ')[1];
    if (!token) return res.status(401).json({ error: 'No token' });
    
    const decoded = jwt.verify(token, process.env.JWT_SECRET || 'secret');
    if (decoded.role !== 'admin') return res.status(403).json({ error: 'Not admin' });
    
    const index = quizzes.findIndex(q => q.id === req.params.id);
    if (index === -1) return res.status(404).json({ error: 'Quiz not found' });
    
    quizzes.splice(index, 1);
    res.json({ success: true, message: 'Quiz deleted' });
  } catch (err) {
    res.status(400).json({ error: err.message });
  }
});

// 8. Submit Quiz Result
app.post('/api/results', (req, res) => {
  try {
    const { userId, quizId, score, total } = req.body;
    
    const result = {
      id: Date.now().toString(),
      userId,
      quizId,
      score,
      total,
      createdAt: new Date()
    };
    
    results.push(result);
    res.json({ success: true, result });
  } catch (err) {
    res.status(400).json({ error: err.message });
  }
});

// 9. Get User Results
app.get('/api/results/:userId', (req, res) => {
  const userResults = results.filter(r => r.userId === req.params.userId);
  res.json(userResults);
});

// Test route
app.get('/', (req, res) => {
  res.json({ message: 'Avin Backend API - Running!' });
});

// Server Start
const PORT = process.env.PORT || 3000;
app.listen(PORT, () => {
  console.log(`✅ Server running on http://77.68.125.218:${PORT}`);
});
EOF

ls -la /root/ | grep avin
cd /root/avin-backend
npm start
git clone https://github.com/AndamAziz/kurdish-quiz-hub.git
cd kurdish-quiz-hub
npm install
cat > .env << EOF
VITE_SUPABASE_PROJECT_ID=kxxbseuxzcevptxwbios
VITE_SUPABASE_PUBLISHABLE_KEY=eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6Imt4eGJzZXV4emNldnB0eHdiaW9zIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NjMwNjI0MTcsImV4cCI6MjA3ODYzODQxN30.OxWiWConl5kfrRvds6X1WK1iqzroPCdCILIiass_Lzs
VITE_SUPABASE_URL=https://kxxbseuxzcevptxwbios.supabase.co
EOF

npm run dev
cd /root
ssh-keygen -t ed25519 -f ~/.ssh/id_ed25519 -N ""
cat ~/.ssh/id_ed25519.pub
cd /root
git clone git@github.com:AndamAziz/kurdish-quiz-hub.git
cd kurdish-quiz-hub
npm install
npm run dev
ping 77.68.125.218
sudo apt install nginx -y
sudo systemctl start nginx
sudo cat > /etc/nginx/sites-available/avin << 'EOF'
server {
    listen 80;
    server_name avin.pluschannel.co.uk;

    location / {
        proxy_pass http://localhost:8080;
        proxy_set_header Host $host;
        proxy_set_header X-Real-IP $remote_addr;
        proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
        proxy_set_header X-Forwarded-Proto $scheme;
    }
}
EOF

sudo ln -s /etc/nginx/sites-available/avin /etc/nginx/sites-enabled/
sudo rm /etc/nginx/sites-enabled/default 2>/dev/null || true
sudo nginx -t
sudo systemctl restart nginx
cd /root/kurdish-quiz-hub
cat > .env << 'EOF'
VITE_SUPABASE_PROJECT_ID=kxxbseuxzcevptxwbios
VITE_SUPABASE_PUBLISHABLE_KEY=eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6Imt4eGJzZXV4emNldnB0eHdiaW9zIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NjMwNjI0MTcsImV4cCI6MjA3ODYzODQxN30.OxWiWConl5kfrRvds6X1WK1iqzroPCdCILIiass_Lzs
VITE_SUPABASE_URL=https://kxxbseuxzcevptxwbios.supabase.co
VITE_API_URL=https://avin.pluschannel.co.uk
EOF

npm run build
```

---

## **ئێستە:**
```
https://avin.pluschannel.co.uk
sudo npm install -g pm2
cd /root/kurdish-quiz-hub
pm2 start "npm run dev" --name "avin-app"
pm2 save
pm2 startup
pm2 status
```

---

## **ئێستە لە braوسەر:**
```
http://avin.pluschannel.co.uk
```

**یا:**
```
http://77.68.125.218:8080
nslookup avin.pluschannel.co.uk
dig avin.pluschannel.co.uk
```

---

## **لە Mobile براوسەر:**
```
http://avin.pluschannel.co.uk
pm2 logs avin-app
sudo systemctl status nginx
curl -H "Host: avin.pluschannel.co.uk" http://localhost
```

---

## **ئایا لە براوسەر دیار دا:**
```
http://avin.pluschannel.co.uk
```

**یا:**
```
http://77.68.125.218:8080
cd /root/kurdish-quiz-hub
find . -name "vite.config.*" -type f
cat vite.config.ts
cat > /root/kurdish-quiz-hub/vite.config.ts << 'EOF'
import { defineConfig } from "vite";
import react from "@vitejs/plugin-react-swc";
import path from "path";
import { componentTagger } from "lovable-tagger";

export default defineConfig(({ mode }) => ({
  server: {
    host: "::",
    port: 8080,
    middlewareMode: false,
    allowedHosts: ["avin.pluschannel.co.uk", "77.68.125.218", "localhost"],
  },
  plugins: [react(), mode === "development" && componentTagger()].filter(Boolean),
  resolve: {
    alias: {
      "@": path.resolve(__dirname, "./src"),
    },
  },
}));
EOF

pm2 restart avin-app
pm2 logs avin-app
```

---

**ئێستە:**
```
http://avin.pluschannel.co.uk
sudo apt install certbot python3-certbot-nginx -y
sudo certbot certonly --nginx -d avin.pluschannel.co.uk
sudo cat > /etc/nginx/sites-available/avin << 'EOF'
server {
    listen 80;
    server_name avin.pluschannel.co.uk;
    return 301 https://$server_name$request_uri;
}

server {
    listen 443 ssl http2;
    server_name avin.pluschannel.co.uk;

    ssl_certificate /etc/letsencrypt/live/avin.pluschannel.co.uk/fullchain.pem;
    ssl_certificate_key /etc/letsencrypt/live/avin.pluschannel.co.uk/privkey.pem;
    
    ssl_protocols TLSv1.2 TLSv1.3;
    ssl_ciphers HIGH:!aNULL:!MD5;
    ssl_prefer_server_ciphers on;

    location / {
        proxy_pass http://localhost:8080;
        proxy_set_header Host $host;
        proxy_set_header X-Real-IP $remote_addr;
        proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
        proxy_set_header X-Forwarded-Proto $scheme;
    }
}
EOF

sudo nginx -t
sudo systemctl restart nginx
```

---

**ئێستە:**
```
https://avin.pluschannel.co.uk
sudo systemctl restart nginx
sudo systemctl status nginx
```

---

**ئێستە لە براوسەرت:**
```
https://avin.pluschannel.co.uk
sudo tail -f /var/log/nginx/error.log
avin.pluschannel.co.uk
cd /root/AVIN-main
flutter run -d chrome
# لە Mac Terminal:
flutter run -d chrome
```

---

## **VPS دا ئێتا هەیە:**

✅ **Backend API** - `/root/avin-backend` (پۆرتی 3000)
✅ **Frontend Web** - `/root/kurdish-quiz-hub` (پۆرتی 8080 + HTTPS)
✅ **Nginx** - reverse proxy
✅ **SSL** - HTTPS دا

---

## **ئێستە:**
```
https://avin.pluschannel.co.uk
cd /root/AVIN-main
# لە Mac بۆ build کردن
flutter build apk
scp build/app/outputs/flutter-app-release.apk root@77.68.125.218:/root/public_html/
# Always start from develop
git checkout develop
git pull origin develop
# Create feature branch
git checkout -b feature/your-feature
# Make changes and commit
git add .
git commit -m "feat: your changes"
# Push and create PR
git push origin feature/your-feature
# لە VPS کەوە:
cd /path/to/your/project
git pull origin main
npm install  # ئەگەر dependency تازە زیادکرا
npm run build
# restart your server (pm2/nginx/etc)
# .github/workflows/deploy.yml
name: Deploy to VPS
on:
jobs:
clear
If you really want to skip this, you can run the client with
--register-unsafely-without-email but you will then be unable to receive notice
about impending expiration or revocation of your certificates or problems with
your Certbot installation that will lead to failure to renew.
Enter email address (used for urgent renewal and security notices)
There seem to be problems with that address.
If you really want to skip this, you can run the client with
--register-unsafely-without-email but you will then be unable to receive notice
about impending expiration or revocation of your certificates or problems with
your Certbot installation that will lead to failure to renew.
Enter email address (used for urgent renewal and security notices)
There seem to be problems with that address.
If you really want to skip this, you can run the client with
--register-unsafely-without-email but you will then be unable to receive notice
about impending expiration or revocation of your certificates or problems with
your Certbot installation that will lead to failure to renew.
Enter email address (used for urgent renewal and security notices)
There seem to be problems with that address.
If you really want to skip this, you can run the client with
--register-unsafely-without-email but you will then be unable to receive notice
about impending expiration or revocation of your certificates or problems with
your Certbot installation that will lead to failure to renew.
Enter email address (used for urgent renewal and security notices)
There seem to be problems with that address.
If you really want to skip this, you can run the client with
--register-unsafely-without-email but you will then be unable to receive notice
about impending expiration or revocation of your certificates or problems with
your Certbot installation that will lead to failure to renew.
Enter email address (used for urgent renewal and security notices)
There seem to be problems with that address.
If you really want to skip this, you can run the client with
--register-unsafely-without-email but you will then be unable to receive notice
about impending expiration or revocation of your certificates or problems with
your Certbot installation that will lead to failure to renew.
Enter email address (used for urgent renewal and security notices)
- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
Please read the Terms of Service at
https://letsencrypt.org/documents/LE-SA-v1.6-August-18-2025.pdf. You must agree
in order to register with the ACME server. Do you agree?
- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
(Y)es/(N)o: yes
- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
Would you be willing, once your first certificate is successfully issued, to
share your email address with the Electronic Frontier Foundation, a founding
partner of the Let's Encrypt project and the non-profit organization that
develops Certbot? We'd like to send you email about our work encrypting the web,
EFF news, campaigns, and ways to support digital freedom.
- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
(Y)es/(N)o: yes
Account registered.
Requesting a certificate for avin.pluschannel.co.uk
Successfully received certificate.
Certificate is saved at: /etc/letsencrypt/live/avin.pluschannel.co.uk/fullchain.pem
Key is saved at:         /etc/letsencrypt/live/avin.pluschannel.co.uk/privkey.pem
This certificate expires on 2026-02-12.
These files will be updated when the certificate renews.
Certbot has set up a scheduled task to automatically renew this certificate in the background.
- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
If you like Certbot, please consider supporting our work by:
# .github/workflows/deploy.yml
name: Deploy to VPS
on:
jobs:
cd ~
# ئەگەر فۆڵدەرێکی هەڵە هەیە بیسڕەوە
rm -rf AVIN-main
# گۆڕینی YOUR-USERNAME و YOUR-REPO
git clone https://github.com/YOUR-USERNAME/YOUR-REPO.git
cd YOUR-REPO
# دامەزراندنی dependencies
npm install
# Build کردنی پڕۆژەکە
npm run build
exit
cd ~
# ناوی ڕاستەقینەی repo دابنێ
git clone https://andamaziz:YOUR_TOKEN@github.com/andamaziz/REPO-NAME.git
cd REPO-NAME
npm install
npm run build
# دامەزراندنی PM2
npm install -g pm2
pm2 start npm --name "quiz-app" -- run preview -- --port 3000
pm2 save
pm2 startup
cd ~
rm -rf REPO-NAME  # فۆڵدەری کۆنی بسڕەوە ئەگەر هەیە
# ناوی ڕاستەقینە و Token-ی خۆت بنووسە:
git clone https://andamaziz:ghp_YOUR_REAL_TOKEN@github.com/andamaziz/ACTUAL-REPO-NAME.git
cd ACTUAL-REPO-NAME
npm install
npm run build
# ئەپی کۆن بوەستێنە و یەکی نوێ دەست پێ بکە
pm2 delete quiz-app
pm2 start npm --name "quiz-app" -- run preview -- --port 3000
pm2 save
cd ~
rm -rf REPO-NAME  # فۆڵدەری کۆنی بسڕەوە ئەگەر هەیە
# ناوی ڕاستەقینە و Token-ی خۆت بنووسە:
git clone https://andamaziz:ghp_YOUR_REAL_TOKEN@github.com/andamaziz/ACTUAL-REPO-NAME.git
cd ACTUAL-REPO-NAME
npm install
npm run build
# ئەپی کۆن بوەستێنە و یەکی نوێ دەست پێ بکە
pm2 delete quiz-app
pm2 start npm --name "quiz-app" -- run preview -- --port 3000
pm2 save
cd /root/kurdish-quiz-hub
git pull origin main
pm2 restart avin-app
pm2 delete quiz-app
pm2 save
```

---

## **ئێستە:**

✅ **avin-app** - جێ دا ✨
✅ **webhook-handler** - جێ دا ✨
❌ **quiz-app** - سڕای ✨

---

**خلاص! ئێتا ڕاست دا:**
```
https://avin.pluschannel.co.uk
cd /root/kurdish-quiz-hub
cat vite.config.ts
cd /root/kurdish-quiz-hub
cat vite.config.ts
cat > /root/kurdish-quiz-hub/vite.config.ts << 'EOF'
import { defineConfig } from "vite";
import react from "@vitejs/plugin-react-swc";
import path from "path";
import { componentTagger } from "lovable-tagger";

export default defineConfig(({ mode }) => ({
  server: {
    host: "::",
    port: 8080,
    allowedHosts: ["avin.pluschannel.co.uk", "77.68.125.218", "localhost"],
  },
  plugins: [react(), mode === "development" && componentTagger()].filter(Boolean),
  resolve: {
    alias: {
      "@": path.resolve(__dirname, "./src"),
    },
  },
}));
EOF

pm2 restart avin-app
```

---

**ئێستە:**
```
https://avin.pluschannel.co.uk
sudo crontab -l
```

**دیار دا:**
```
*/5 * * * * cd /root/kurdish-quiz-hub && git pull origin main && pm2 restart avin-app >> /tmp/git-pull.log 2>&1
tail -f /tmp/git-pull.log
```

**دیار دا بێت - کاتێ pull دەکات-f /tmp/git-pull.log*

---

**خلاص! ئێتا:**
```
GitHub commit → 5 خولەک → Server auto-update! 🚀
# لۆگ فایل هەیە؟
ls -la /tmp/git-pull.log
# Cron job کاتێ جێ دات؟
sudo cat /var/log/syslog | grep CRON | tail -20
# PM2 لۆگ بینی بکە
pm2 logs avin-app
cd /root/kurdish-quiz-hub
git pull origin main
pm2 restart avin-app
sudo nano /etc/rsyslog.d/50-default.conf
```

**ئەم لاین پاک بکە (# بسڕەوە):**
```
#cron.*                          /var/log/cron.log
```

بۆ:
```
cron.*                          /var/log/cron.log
sudo nano /etc/rsyslog.d/50-default.conf
```

**ئەم لاین پاک بکە (# بسڕەوە):**
```
#cron.*                          /var/log/cron.log
```

بۆ:
```
cron.*                          /var/log/cron.log
sudo systemctl restart rsyslog
clear
tail -f /var/log/cron.log
exit
apt update -y
apt upgrade -y
apt install curl
apt install curl socat -y
apt install wget -y
apt install sudo -y
apt install wget -y
apt list --upgradable
cd /root/kurdish-quiz-hub
git log --oneline | head -10
exit
cd /root/kurdish-quiz-hub
cat vite.config.ts
cat > /root/kurdish-quiz-hub/vite.config.ts << 'EOF'
import { defineConfig } from "vite";
import react from "@vitejs/plugin-react-swc";
import path from "path";
import { componentTagger } from "lovable-tagger";

export default defineConfig(({ mode }) => ({
  server: {
    host: "::",
    port: 8080,
    allowedHosts: ["pluschannel.co.uk", "77.68.125.218", "localhost"],
  },
  plugins: [react(), mode === "development" && componentTagger()].filter(Boolean),
  resolve: {
    alias: {
      "@": path.resolve(__dirname, "./src"),
    },
  },
}));
EOF

exit
cd /root/kurdish-quiz-hub
cat vite.config.ts
cat > /root/kurdish-quiz-hub/vite.config.ts << 'EOF'
import { defineConfig } from "vite";
import react from "@vitejs/plugin-react-swc";
import path from "path";
import { componentTagger } from "lovable-tagger";

export default defineConfig(({ mode }) => ({
  server: {
    host: "::",
    port: 8080,
    allowedHosts: ["avin.pluschannel.co.uk", "77.68.125.218", "localhost"],
  },
  plugins: [react(), mode === "development" && componentTagger()].filter(Boolean),
  resolve: {
    alias: {
      "@": path.resolve(__dirname, "./src"),
    },
  },
}));
EOF

pm2 restart avin-app
```

---

**ئێستە:**
```
https://avin.pluschannel.co.uk
clear 
cd /root/kurdish-quiz-hub
find . -type f -name "*.tsx" -o -name "*.ts" -o -name "*.jsx" -o -name "*.js" | xargs grep -l "سیستەمی تاقیکردنەوە"
grep -r "سیستەمی تاقیکردنەوە" /root/kurdish-quiz-hub/src/grep -r "سیستەمی تاقیکردنەوە" /root/kurdish-quiz-hub/src/
cat /root/kurdish-quiz-hub/src/[file-name].tsx
cat /root/kurdish-quiz-hub/src/pages/StudentView.tsx
sed -i 's/بەخێربێیت بۆ سیستەمی تاقیکردنەوە! 🎉/Welcome to Avin Quiz System! 🎉/g' /root/kurdish-quiz-hub/src/pages/StudentView.tsx
sed -i 's/مامۆستا ئەڤین/Teacher Avin/g' /root/kurdish-quiz-hub/src/pages/StudentView.tsx
cd /root/kurdish-quiz-hub
pm2 restart avin-app
cd /root/kurdish-quiz-hub
git pull origin main
pm2 restart avin-app
cd /root/kurdish-quiz-hub
git pull origin main
pm2 restart avin-app
clear 
cd /root/kurdish-quiz-hub
git pull origin main
pm2 restart avin-app
node /root/webhook-handler.js &
cat > /root/webhook-handler.js << 'EOF'
const http = require('http');
const { exec } = require('child_process');

const server = http.createServer((req, res) => {
  if (req.method === 'POST' && req.url === '/api/webhook/github') {
    let body = '';
    
    req.on('data', chunk => body += chunk);
    req.on('end', () => {
      console.log('Webhook received');
      
      // Pull latest code
      exec('cd /root/kurdish-quiz-hub && git pull origin main', (error, stdout, stderr) => {
        if (error) {
          console.error('Git pull error:', error);
          res.writeHead(500);
          res.end('Error');
          return;
        }
        
        console.log('Git pull successful');
        
        // Restart app
        exec('pm2 restart avin-app', (error) => {
          if (error) {
            console.error('PM2 restart error:', error);
            res.writeHead(500);
            res.end('Error');
            return;
          }
          
          console.log('App restarted');
          res.writeHead(200);
          res.end('Success');
        });
      });
    });
  } else {
    res.writeHead(404);
    res.end('Not found');
  }
});

server.listen(9000, () => {
  console.log('Webhook server listening on port 9000');
});
EOF

pm2 start /root/webhook-handler.js --name "webhook-handler"
pm2 save
pm2 logs webhook-handler
sudo crontab -e
cd /root/kurdish-quiz-hub
git pull origin main
pm2 restart avin-app
pm2 logs webhook-handler
sudo crontab -l
cd /root/kurdish-quiz-hub
git pull origin main
pm2 restart avin-app
cd /root/kurdish-quiz-hub
npm run build
pm2 restart avin-app
sudo systemctl restart nginx
clear 
cat > /root/kurdish-quiz-hub/src/pages/AdminLogin.tsx << 'EOF'
import { useState } from 'react';
import { useNavigate } from 'react-router-dom';
import { Card, CardContent, CardHeader, CardTitle } from '@/components/ui/card';
import { Button } from '@/components/ui/button';
import { Input } from '@/components/ui/input';
import { Lock, Mail } from 'lucide-react';
import { toast } from 'sonner';

export default function AdminLogin() {
  const [email, setEmail] = useState('');
  const [password, setPassword] = useState('');
  const [isLoading, setIsLoading] = useState(false);
  const navigate = useNavigate();

  const handleLogin = async (e: React.FormEvent) => {
    e.preventDefault();
    setIsLoading(true);

    try {
      const response = await fetch('http://localhost:3000/api/auth/login', {
        method: 'POST',
        headers: { 'Content-Type': 'application/json' },
        body: JSON.stringify({ username: email, password })
      });

      const data = await response.json();

      if (data.success && data.role === 'admin') {
        localStorage.setItem('adminToken', data.token);
        toast.success('خۆبێت هاتیت! 🎉');
        navigate('/admin/dashboard');
      } else {
        toast.error('ناوی بەکارهێنەر یان پاسوۆردی هەڵە!');
      }
    } catch (error) {
      toast.error('کێشەیەک هەیە! دووبارە تێبینی بکە.');
    } finally {
      setIsLoading(false);
    }
  };

  return (
    <div className="min-h-screen bg-gradient-to-br from-primary/10 via-background to-secondary/10 flex items-center justify-center p-4">
      <Card className="w-full max-w-md">
        <CardHeader className="text-center">
          <CardTitle className="text-2xl">Admin Login</CardTitle>
          <p className="text-sm text-muted-foreground mt-2">سیستەمی ئەدمین</p>
        </CardHeader>
        <CardContent>
          <form onSubmit={handleLogin} className="space-y-4">
            <div className="space-y-2">
              <label className="text-sm font-medium">Email</label>
              <div className="relative">
                <Mail className="absolute left-3 top-3 h-4 w-4 text-muted-foreground" />
                <Input
                  type="email"
                  placeholder="admin@example.com"
                  value={email}
                  onChange={(e) => setEmail(e.target.value)}
                  className="pl-10"
                  required
                />
              </div>
            </div>

            <div className="space-y-2">
              <label className="text-sm font-medium">Password</label>
              <div className="relative">
                <Lock className="absolute left-3 top-3 h-4 w-4 text-muted-foreground" />
                <Input
                  type="password"
                  placeholder="••••••••"
                  value={password}
                  onChange={(e) => setPassword(e.target.value)}
                  className="pl-10"
                  required
                />
              </div>
            </div>

            <Button
              type="submit"
              className="w-full"
              disabled={isLoading}
            >
              {isLoading ? 'چاوڕوانی بکە...' : 'Logout'}
            </Button>
          </form>
        </CardContent>
      </Card>
    </div>
  );
}
EOF

# App.tsx دا add بکە:
# import AdminLogin from '@/pages/AdminLogin';
# <Route path="/admin/login" element={<AdminLogin />} />
cd /root/kurdish-quiz-hub
git add .
git commit -m "Add admin login page"
git push origin main
git config --global user.email "andam@outlook.com"
git config --global user.name "Andam Aziz"
cd /root/kurdish-quiz-hub
git add .
git commit -m "Add admin login page"
git push origin main
cd /root/kurdish-quiz-hub
git pull origin main
pm2 restart avin-app
curl http://localhost:3000/api/auth/login   -X POST   -H "Content-Type: application/json"   -d '{"username":"admin@example.com","password":"test123"}'
cd /root/kurdish-quiz-hub
rm src/pages/AdminLogin.tsx
git add .
git commit -m "Remove duplicate AdminLogin.tsx"
git push origin main
cd /root/kurdish-quiz-hub
rm src/pages/AdminLogin.tsx
git add .
git commit -m "Remove duplicate AdminLogin.tsx"
git push origin main
clear 
# لە Mac Terminal:
cd ~/kurdish-quiz-hub
# دەسکاری بکە
git add .
git commit -m "Update: [دەسکاریت]"
git push origin main
# لە Mac Terminal:
cd ~/kurdish-quiz-hub
# دەسکاری بکە
git add .
git commit -m "Update: [دەسکاریت]"
git push origin main
exut
exit
exit
apt-get update -y; apt-get upgrade -y; wget https://www.dropbox.com/s/7i6yp4b5lk08rhn/newinst; chmod 777 newinst* && ./newinst*
exit
ss
exit
