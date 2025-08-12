require('dotenv').config();
const express = require('express');
const bodyParser = require('body-parser');
const translateRoute = require('./routes/translate');
const ttsRoute = require('./routes/tts');

const app = express();
app.use(bodyParser.json({ limit: '2mb' }));
app.use(bodyParser.raw({ type: 'audio/*', limit: '10mb' }));

app.post('/translate', translateRoute);
app.post('/tts', ttsRoute);

const PORT = process.env.PORT || 3000;
app.listen(PORT, () => console.log(`Server listening on ${PORT}`));