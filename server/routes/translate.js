const axios = require('axios');

module.exports = async function (req, res) {
  try {
    const { text, source, target } = req.body;
    // Example using DeepL API
    const apiKey = process.env.DEEPL_KEY;
    const resp = await axios.post(
      'https://api-free.deepl.com/v2/translate',
      new URLSearchParams({ auth_key: apiKey, text: text, target_lang: target }),
      { headers: { 'Content-Type': 'application/x-www-form-urlencoded' } }
    );
    const translated = resp.data.translations[0].text;
    res.json({ translated });
  } catch (err) {
    console.error(err.message);
    res.status(500).json({ error: 'translate_failed' });
  }
};