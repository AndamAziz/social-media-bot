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
