const express = require('express');
const app = express();
const port = process.env.PORT || 3000;

app.get('/health', (req, res) => {
  res.json({ status: 'ok', env: process.env.NODE_ENV || 'development' });
});

app.get('/', (req, res) => {
  res.json({ message: 'Hello from Secure DevSecOps Node API' });
});

app.listen(port, () => {
  console.log(`Server listening on port ${port}`);
});
