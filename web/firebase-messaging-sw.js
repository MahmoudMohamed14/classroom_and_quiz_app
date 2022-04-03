importScripts("https://www.gstatic.com/firebasejs/8.10.0/firebase-app.js");
importScripts("https://www.gstatic.com/firebasejs/8.10.0/firebase-messaging.js");

firebase.initializeApp({
 apiKey: "AIzaSyBynkwpZzRTui5lfLo6j_u3M9YrJ5G9zRg",
   authDomain: "quiz-app-185cd.firebaseapp.com",
   projectId: "quiz-app-185cd",
   storageBucket: "quiz-app-185cd.appspot.com",
   messagingSenderId: "280309312143",
   appId: "1:280309312143:web:09a93b33f5cb6d16b09efa",
   measurementId: "G-3M7GJV63BL"
});
// Necessary to receive background messages:
const messaging = firebase.messaging();

// Optional:
messaging.onBackgroundMessage((m) => {
  console.log("onBackgroundMessage", m);
})