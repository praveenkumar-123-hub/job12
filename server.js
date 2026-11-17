const express = require('express');

const app = express();
app.use(express.json());

app.get('/', (_req, res) => {
  res.status(200).json({
    message: 'Cynbit DevOps Demo API is running',
    status: 'ok'
  });
});

app.get('/health', (_req, res) => {
  res.status(200).json({ status: 'healthy' });
});

const PORT = Number(process.env.PORT) || 3000;

// Export the app so automated tests can exercise it without opening a port.
if (require.main === module) {
  app.listen(PORT, '0.0.0.0', () => {
    console.log(`Cynbit demo API listening on port ${PORT}`);
  });
}

module.exports = app;
