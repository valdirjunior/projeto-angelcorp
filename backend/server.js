const express = require('express');
const cors = require('cors');
require('dotenv').config();

const ticketRoutes = require('./src/routes/ticketRoutes');

const app = express();

app.use(cors({
  origin: '*'
}));
app.use(express.json());

const PORT = process.env.PORT || 3000;

app.get('/', (req, res) => {
  res.json({
    message: 'AngelDesk API funcionando!'
  });
});

app.use('/tickets', ticketRoutes);

app.get('/health', (req, res) => {
  res.status(200).json({
    status: 'ok'
  });
});

app.listen(PORT, '0.0.0.0', () => {
  console.log(`Servidor rodando na porta ${PORT}`);
});