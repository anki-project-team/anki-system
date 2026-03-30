import * as functions from "firebase-functions";
import * as admin from "firebase-admin";

admin.initializeApp();

export const sendDailyLearningNotification =
  functions.pubsub.schedule("30 5 * * *")
  .timeZone("Europe/Berlin")
  .onRun(async () => {

    const usersSnapshot = await admin.firestore()
      .collection("users").get();

    const messages: admin.messaging.Message[] = [];

    for (const userDoc of usersSnapshot.docs) {
      const data = userDoc.data();
      const fcmToken = data.fcmToken;
      if (!fcmToken) continue;

      const now = admin.firestore.Timestamp.now();
      const progressSnapshot = await admin.firestore()
        .collection("users").doc(userDoc.id)
        .collection("progress")
        .where("dueDate", "<=", now).get();

      const dueCount = progressSnapshot.size;

      const title = dueCount > 0
        ? `Heute ${dueCount} Karten fällig 🎯`
        : "Gut gemacht! 🎉";

      const body = dueCount > 0
        ? "IHK AP1 Prep — Jetzt lernen!"
        : "Alle Karten für heute wiederholt.";

      messages.push({
        token: fcmToken,
        notification: { title, body },
        webpush: {
          notification: {
            icon: "https://ihk-ap1-prep.web.app/icons/Icon-192.png",
          }
        }
      });
    }

    if (messages.length > 0) {
      const response = await admin.messaging().sendEach(messages);
      console.log(`Sent: ${response.successCount}, Failed: ${response.failureCount}`);
    }

    return null;
  });
