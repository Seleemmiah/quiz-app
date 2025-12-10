// Firebase Cloud Functions for Push Notifications
// Deploy with: firebase deploy --only functions

const functions = require('firebase-functions');
const admin = require('firebase-admin');
admin.initializeApp();

// Send push notification when a new notification document is created
exports.sendPushNotification = functions.firestore
    .document('notifications/{notificationId}')
    .onCreate(async (snapshot, context) => {
        try {
            const notification = snapshot.data();
            const userId = notification.userId;

            // Get user's FCM token
            const userDoc = await admin.firestore()
                .collection('users')
                .doc(userId)
                .get();

            const fcmToken = userDoc.data()?.fcmToken;

            if (!fcmToken) {
                console.log('No FCM token for user:', userId);
                return null;
            }

            // Send push notification
            const message = {
                notification: {
                    title: notification.title,
                    body: notification.message,
                },
                data: {
                    type: notification.type || 'general',
                    notificationId: context.params.notificationId,
                    ...(notification.data || {}),
                },
                token: fcmToken,
            };

            const response = await admin.messaging().send(message);
            console.log('Successfully sent notification:', response);

            return response;
        } catch (error) {
            console.error('Error sending notification:', error);
            return null;
        }
    });

// Process scheduled notifications
exports.processScheduledNotifications = functions.pubsub
    .schedule('every 1 minutes')
    .onRun(async (context) => {
        const now = admin.firestore.Timestamp.now();

        // Get notifications that should be sent
        const snapshot = await admin.firestore()
            .collection('scheduled_notifications')
            .where('sendAt', '<=', now)
            .where('sent', '==', false)
            .limit(100)
            .get();

        const batch = admin.firestore().batch();
        const promises = [];

        snapshot.docs.forEach((doc) => {
            const data = doc.data();

            // Send notification to each student
            data.studentIds.forEach((studentId) => {
                const notificationRef = admin.firestore()
                    .collection('notifications')
                    .doc();

                promises.push(
                    notificationRef.set({
                        userId: studentId,
                        title: '🎓 Exam Reminder',
                        message: `Your exam "${data.examTitle}" is starting soon!`,
                        type: 'exam_reminder',
                        data: {
                            examId: data.examId,
                            examTitle: data.examTitle,
                        },
                        createdAt: admin.firestore.FieldValue.serverTimestamp(),
                        read: false,
                    })
                );
            });

            // Mark as sent
            batch.update(doc.ref, { sent: true });
        });

        await Promise.all(promises);
        await batch.commit();

        console.log(`Processed ${snapshot.size} scheduled notifications`);
        return null;
    });

// Clean up old notifications (older than 30 days)
exports.cleanupOldNotifications = functions.pubsub
    .schedule('every 24 hours')
    .onRun(async (context) => {
        const thirtyDaysAgo = new Date();
        thirtyDaysAgo.setDate(thirtyDaysAgo.getDate() - 30);

        const snapshot = await admin.firestore()
            .collection('notifications')
            .where('createdAt', '<', admin.firestore.Timestamp.fromDate(thirtyDaysAgo))
            .limit(500)
            .get();

        const batch = admin.firestore().batch();
        snapshot.docs.forEach((doc) => {
            batch.delete(doc.ref);
        });

        await batch.commit();
        console.log(`Deleted ${snapshot.size} old notifications`);
        return null;
    });
