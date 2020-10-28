const functions = require('firebase-functions');
const admin = require('firebase-admin');

admin.initializeApp();

exports.myFunction = functions.firestore
  .document('chat/{message}')
  .onCreate((snapshot, context) => {
    const data = snapshot.data();
    admin.messaging().sendToTopic('chat', {
        notification: {
            title: data.username,
            body: data.text,
            clickAction: 'FLUTTER_NOTIFICATION_CLICK',
        },
        },
    );

    return;
  });
