import * as functions from 'firebase-functions';
import * as admin from 'firebase-admin';
import * as keys from './keys';
import * as Twilio from 'twilio';
admin.initializeApp();


const accountSid = keys.accountSID;
const authToken = keys.authToken;
const twilioNumber = keys.twilioNumber;

const client = Twilio(accountSid, authToken);
const fcm = admin.messaging();


exports.bookingConfirmationMsg = functions.https.onCall((data, context) => {

    const message = data.message;
    const textContent = {
        body: `${message}`,
        to: '+94774064048',
        from: twilioNumber
    }
    client.messages.create(textContent).then((msg) => {
        console.log(msg.sid)
    }).catch((error) => {
        console.log(error)
    })


})


export const sendToDevice = functions.firestore
.document('reservations/{reservationId}/{records}/{recordsId}')
.onUpdate((change,context) => {
    const token = keys.token;
    const payload : admin.messaging.MessagingPayload = {
        notification: {
            title: 'You are on your way',
            body: 'Please do not remove your ticket until you reach the destination. ',
            clickAction: 'FLUTTER_NOTIFICTION_CLICK'

        }
    };
    return fcm.sendToDevice(token, payload);
});
