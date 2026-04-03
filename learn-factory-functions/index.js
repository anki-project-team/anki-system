// functions/index.js
// Firebase Cloud Function — Digistore24 IPN Webhook
//
// SETUP:
// 1. firebase init functions (falls noch nicht gemacht)
// 2. Diese Datei nach functions/index.js kopieren
// 3. npm install express in /functions
// 4. firebase deploy --only functions
// 5. Webhook-URL in Digistore24 eintragen:
//    https://us-central1-ihk-ap1-prep.cloudfunctions.net/digistore24Webhook

const { onRequest } = require('firebase-functions/v2/https');
const { setGlobalOptions } = require('firebase-functions/v2');
setGlobalOptions({ region: 'europe-west1' });
const admin = require('firebase-admin');
const express = require('express');

admin.initializeApp();
const db = admin.firestore();
const app = express();
app.use(express.urlencoded({ extended: true }));
app.use(express.json());

// ── Digistore24 Produkt-ID (muss mit Flutter-App übereinstimmen)
const PRODUCT_ID = 'iwilfried49'; 

// ════════════════════════════════════════════════════════
// IPN ENDPOINT
// Digistore24 sendet POST-Request nach jedem Kauf
// ════════════════════════════════════════════════════════
app.post('/ipn', async (req, res) => {
  try {
    const body = req.body;

    console.log('Digistore24 IPN erhalten:', JSON.stringify(body));

    // ── Pflichtfelder prüfen ──────────────────────────
    const {
      event,           // "ipn_buy" bei Kauf
      product_id,      // Produkt-ID aus Digistore24
      buy_custom_1,    // Wir senden hier die Firebase UID mit
      order_id,        // Bestell-ID von Digistore24
      buyer_email,
    } = body;

    // Nur Käufe verarbeiten
    if (event !== 'ipn_buy' && event !== 'ipn_rebuy') {
      console.log('Kein Kauf-Event, ignoriert:', event);
      return res.status(200).send('OK');
    }

    // Produkt-ID validieren
    if (product_id !== PRODUCT_ID) {
      console.error('Falsche Produkt-ID:', product_id);
      return res.status(400).send('Invalid product');
    }

    // ── User-ID aus custom Parameter lesen ───────────
    // Wir übergeben die UID in der Checkout-URL als ?uid=...
    // Digistore24 leitet das als buy_custom_1 weiter
    const userId = buy_custom_1;

    if (!userId) {
      // Fallback: Suche User anhand E-Mail
      console.warn('Keine UID in buy_custom_1, suche per E-Mail');
      if (buyer_email) {
        const users = await admin.auth().getUserByEmail(buyer_email);
        if (users) {
          await _grantPremium(users.uid, order_id, buyer_email);
        }
      }
      return res.status(200).send('OK');
    }

    // ── Premium freischalten ──────────────────────────
    await _grantPremium(userId, order_id, buyer_email);

    res.status(200).send('OK');

  } catch (error) {
    console.error('IPN Fehler:', error);
    res.status(500).send('Error');
  }
});

// ── Refund: Premium entziehen ─────────────────────────
app.post('/refund', async (req, res) => {
  try {
    const { buy_custom_1, buyer_email, event } = req.body;

    if (event !== 'ipn_refund') {
      return res.status(200).send('OK');
    }

    const userId = buy_custom_1;
    if (userId) {
      await db.collection('users').doc(userId).set(
        {
          isPremium: false,
          plan: 'gratis',
          premiumRevokedAt: admin.firestore.FieldValue.serverTimestamp(),
        },
        { merge: true }
      );
      console.log('Premium entzogen für:', userId);
    }

    res.status(200).send('OK');
  } catch (error) {
    console.error('Refund Fehler:', error);
    res.status(500).send('Error');
  }
});

// ════════════════════════════════════════════════════════
// HILFSFUNKTION: Premium setzen
// ════════════════════════════════════════════════════════
async function _grantPremium(userId, orderId, email) {
  await db.collection('users').doc(userId).set(
    {
      isPremium: true,
      plan: 'vollversion',
      premiumSince: admin.firestore.FieldValue.serverTimestamp(),
      digistore24OrderId: orderId,
      email: email,
    },
    { merge: true }
  );
  console.log(`✅ Premium freigeschaltet: ${userId} (Order: ${orderId})`);
}

// ════════════════════════════════════════════════════════
// SUCCESS PAGE (Redirect nach Kauf)
// ════════════════════════════════════════════════════════
app.get('/purchase-success', (req, res) => {
  // Redirect zurück zur App
  res.redirect('https://ihk-ap1-prep.web.app/?purchase=success');
});

exports.digistore24Webhook = onRequest(app);
