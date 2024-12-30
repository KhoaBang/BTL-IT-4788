const admin = require('firebase-admin');
const sequelize = require('../config/database'); // Ensure this function is correctly imported

const sendPushNotification = async (title, body, UUID, imageUrl, resourceId) => {
  try {
    // The function below is a db call. Replace with your respective db query
    const user = await sequelize.models._User(UUID);

    if (!user) {
      throw new Error('User not found');
    }

    const firebase_token = user.firebase_token;
    let badge = user.badge ?? 0; // If user.badge is null, badge is assigned a 0 value

    if (!firebase_token || firebase_token.length < 2) {
      throw new Error('This is an invalid firebase_token');
    }

    badge++;
    const message = {
      notification: {
        title,
        body,
      },
      android: {
        notification: {
          channel_id: 'MESSAGE_CHANNEL',// *
          icon: 'message_icon', // *
          tag: 'message', // *
          image: imageUrl,
        },
      },
      apns: {
        payload: {
          aps: {
            badge,
            sound: 'chime.caf',
          },
        },
      },
      data: {
        click_action: 'FLUTTER_NOTIFICATION_CLICK', // *
        type: 'MESSAGE', // *
        resourceId,
      },
      firebase_token,
   };

    const response = await admin.messaging().send(message);
    console.log('Successfully sent message:', response);
  } catch (error) {
    console.error('Error sending message:', error);
  }
};

module.exports = {
  sendPushNotification,
};