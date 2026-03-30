importScripts('https://www.gstatic.com/firebasejs/10.0.0/firebase-app-compat.js');
importScripts('https://www.gstatic.com/firebasejs/10.0.0/firebase-messaging-compat.js');

firebase.initializeApp({
  apiKey: 'AIzaSyDmKDErg3PWG4C7ttsXFzNrXq3wf6cpbPM',
  authDomain: 'ihk-ap1-prep.firebaseapp.com',
  projectId: 'ihk-ap1-prep',
  storageBucket: 'ihk-ap1-prep.firebasestorage.app',
  messagingSenderId: '316155377702',
  appId: '1:316155377702:web:b7765f1ef5c54b43ce0ee7'
});

const messaging = firebase.messaging();

messaging.onBackgroundMessage((payload) => {
  self.registration.showNotification(
    payload.notification?.title ?? 'IHK AP1 Prep', {
      body: payload.notification?.body ?? 'Zeit zum Lernen!',
      icon: '/icons/Icon-192.png',
      badge: '/icons/Icon-192.png'
    }
  );
});
