// ✅ Full Updated server.js with New APIs Added
require('dotenv').config();
const express = require('express');
const cors = require('cors');
const pool = require('./db');
const bcrypt = require('bcrypt');
const rateLimit = require('express-rate-limit');
const { body, validationResult } = require('express-validator');

const app = express();
const port = process.env.PORT || 5000;

app.use(cors());
app.use(express.json());

// --------------------------------------
// Root Test
// --------------------------------------
app.get('/', (req, res) => {
  res.send('BigBoss Gym Backend Running!');
});

// --------------------------------------
// Rate limiter for login
// --------------------------------------
const loginLimiter = rateLimit({
  windowMs: 15 * 60 * 1000,
  max: 10,
  handler: (req, res) => {
    res.status(429).json({ error: 'Too many login attempts, please try again later.' });
  }
});

// --------------------------------------
// Login API
// --------------------------------------
app.post('/api/login', loginLimiter, [
  body('email').isEmail(),
  body('password').notEmpty()
], async (req, res) => {
  const errors = validationResult(req);
  if (!errors.isEmpty()) {
    return res.status(400).json({ error: 'Validation failed', details: errors.array() });
  }

  const { email, password } = req.body;
  try {
    const [rows] = await pool.query(`SELECT * FROM members WHERE member_email = ?`, [email]);
    if (!rows.length) return res.status(401).json({ error: 'Invalid email or password' });

    const user = rows[0];
    const isValid = await bcrypt.compare(password, user.member_password);
    if (!isValid) return res.status(401).json({ error: 'Invalid email or password' });

    res.json({
      member_id: user.member_id,
      member_name: user.member_name,
      member_tel: user.member_tel,
      member_email: user.member_email,
      dob: user.dob,
      membership_type: user.membership_type || 'Standard Membership'
    });
  } catch (err) {
    console.error('Login error:', err);
    res.status(500).json({ error: 'Login failed' });
  }
});

// --------------------------------------
// Member Registration API
// --------------------------------------
app.post('/api/members', [
  body('member_name').notEmpty(),
  body('member_email').isEmail(),
  body('member_tel').notEmpty(),
  body('member_password').isLength({ min: 6 })
], async (req, res) => {
  const errors = validationResult(req);
  if (!errors.isEmpty()) return res.status(400).json({ error: 'Validation failed', details: errors.array() });

  const { member_name, member_email, member_tel, membership_type = 'Standard Membership', join_date, dob, member_password } = req.body;

  try {
    const hashed = await bcrypt.hash(member_password, 10);
    const member_id = `MBR${Math.floor(100000 + Math.random() * 900000)}`;
    const today = new Date().toISOString().split('T')[0];

    await pool.query(`
      INSERT INTO members (member_id, member_name, member_email, member_tel, membership_type, join_date, dob, member_password)
      VALUES (?, ?, ?, ?, ?, ?, ?, ?)`,
      [member_id, member_name, member_email, member_tel, membership_type, join_date || today, dob || null, hashed]
    );

    res.status(201).json({ message: 'Member added successfully', member_id });
  } catch (err) {
    console.error('Insert member error:', err);
    res.status(500).json({ error: 'Failed to register member' });
  }
});

// --------------------------------------
// Get All Members
// --------------------------------------
app.get('/api/members', async (req, res) => {
  try {
    const [rows] = await pool.query(`SELECT * FROM members`);
    res.json(rows);
  } catch (err) {
    console.error('Fetch members error:', err);
    res.status(500).json({ error: 'Fetch members failed' });
  }
});

// ✅ NEW: Get Member by ID
app.get('/api/members/:id', async (req, res) => {
  const { id } = req.params;
  try {
    const [rows] = await pool.query('SELECT * FROM members WHERE member_id = ?', [id]);
    if (!rows.length) return res.status(404).json({ error: 'Member not found' });
    res.json(rows[0]);
  } catch (err) {
    console.error('Fetch member error:', err);
    res.status(500).json({ error: 'Fetch member failed' });
  }
});

// ✅ NEW: Update Member Info
app.put('/api/members/:id', async (req, res) => {
  const { id } = req.params;
  const { member_name, member_email, member_tel, dob } = req.body;
  if (!member_name || !member_email) return res.status(400).json({ error: 'Name and email required' });

  try {
    await pool.query(`
      UPDATE members
      SET member_name = ?, member_email = ?, member_tel = ?, dob = ?
      WHERE member_id = ?`,
      [member_name, member_email, member_tel, dob, id]
    );
    res.json({ message: 'Member updated successfully' });
  } catch (err) {
    console.error('Update member error:', err);
    res.status(500).json({ error: 'Update failed' });
  }
});

// ✅ NEW: Update Member Password
app.post('/api/members/password', async (req, res) => {
  const { member_id, new_password } = req.body;
  if (!member_id || !new_password) return res.status(400).json({ error: 'Missing fields' });

  try {
    const hashed = await bcrypt.hash(new_password, 10);
    await pool.query(`UPDATE members SET member_password = ? WHERE member_id = ?`, [hashed, member_id]);
    res.json({ message: 'Password updated successfully' });
  } catch (err) {
    console.error('Password update error:', err);
    res.status(500).json({ error: 'Update password failed' });
  }
});

// ✅ NEW: Get Bookings by Member
app.get('/api/bookings/member/:id', async (req, res) => {
  const { id } = req.params;
  try {
    const [rows] = await pool.query('SELECT * FROM bookings WHERE member_id = ?', [id]);
    res.json(rows);
  } catch (err) {
    console.error('Fetch bookings error:', err);
    res.status(500).json({ error: 'Fetch bookings failed' });
  }
});

// --------------------------------------
// Payments API
// --------------------------------------
app.post('/api/payments', async (req, res) => {
  const { member_id, total_amount, payment_method, promo_used } = req.body;
  if (!member_id || !total_amount || !payment_method) {
    return res.status(400).json({ error: 'Missing fields' });
  }

  try {
    const [result] = await pool.query(`
      INSERT INTO payments (member_id, total_amount, payment_method, promo_used)
      VALUES (?, ?, ?, ?)`, [member_id, total_amount, payment_method, promo_used || 'None']
    );
    res.status(201).json({ message: 'Payment saved', payment_id: result.insertId });
  } catch (err) {
    console.error('Save payment error:', err);
    res.status(500).json({ error: 'Save payment failed' });
  }
});

// Feedback
app.post('/api/feedback', async (req, res) => {
  const { trainer_name, member_id, rating, comment } = req.body;
  if (!trainer_name || !member_id || !rating || !comment) {
    return res.status(400).json({ error: 'Missing fields' });
  }
  try {
    const [result] = await pool.query(`
      INSERT INTO feedbacks (trainer_name, member_id, rating, comment)
      VALUES (?, ?, ?, ?)`, [trainer_name, member_id, rating, comment]
    );
    res.status(201).json({ message: 'Feedback submitted', feedback_id: result.insertId });
  } catch (err) {
    console.error('Save feedback error:', err);
    res.status(500).json({ error: 'Save feedback failed' });
  }
});

// Booking
app.post('/api/bookings', async (req, res) => {
  const { member_id, workout_name } = req.body;
  if (!member_id || !workout_name) {
    return res.status(400).json({ error: 'Missing fields' });
  }
  try {
    const [result] = await pool.query(`
      INSERT INTO bookings (member_id, workout_name)
      VALUES (?, ?)`, [member_id, workout_name]
    );
    res.status(201).json({ message: 'Booking saved', booking_id: result.insertId });
  } catch (err) {
    console.error('Save booking error:', err);
    res.status(500).json({ error: 'Save booking failed' });
  }
});

// Contact
app.post('/api/contact', async (req, res) => {
  const { name, email, subject, message } = req.body;
  if (!name || !email || !subject || !message) {
    return res.status(400).json({ error: 'Missing fields' });
  }
  try {
    const [result] = await pool.query(`
      INSERT INTO contacts (name, email, subject, message)
      VALUES (?, ?, ?, ?)`, [name, email, subject, message]
    );
    res.status(201).json({ message: 'Contact submitted', contact_id: result.insertId });
  } catch (err) {
    console.error('Save contact error:', err);
    res.status(500).json({ error: 'Save contact failed' });
  }
});

// Start Server
app.listen(port, () => {
  console.log(`Server running at http://localhost:${port}`);
});
