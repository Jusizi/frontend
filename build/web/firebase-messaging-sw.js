importScripts("https://www.gstatic.com/firebasejs/10.7.0/firebase-app-compat.js");
importScripts("https://www.gstatic.com/firebasejs/10.7.0/firebase-messaging-compat.js");

firebase.initializeApp({
    databaseURL:'https://jusizi-2999c-default-rtdb.europe-west1.firebasedatabase.app',
    apiKey: 'AIzaSyCckVkZEkVlFnNVNOLRkwZ-Yp20UY4PR5c',
    appId: '1:913916913322:web:a8c1b1ac8fe658a2ea12d3',
    messagingSenderId: '913916913322',
    projectId: 'jusizi-2999c',
    authDomain: 'jusizi-2999c.firebaseapp.com',
    storageBucket: 'jusizi-2999c.appspot.com',
    measurementId: 'G-XW2521C8TM',

});

// Necessary to receive background messages:
const messaging = firebase.messaging();

// Optional:
messaging.onBackgroundMessage((m) => {
  console.log("onBackgroundMessage", m);
});

messaging.onMessage((m) => {
  console.log("onMessage", m);
});