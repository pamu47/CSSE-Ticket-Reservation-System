import * as functions from 'firebase-functions';
import * as keys from './keys';
import * as Twilio from 'twilio';


const accountSid = keys.accountSID;
const authToken = keys.authToken;
const twilioNumber = keys.twilioNumber; 

const client = Twilio(accountSid,authToken);


exports.bookingConfirmationMsg = functions.https.onCall((data, context) => {

        const message = data.message;
        const textContent = {
            body: `${message}`,
            to: '+94774064048',
            from: twilioNumber
        }
        client.messages.create(textContent).then((msg)=>{
            console.log(msg.sid)
        }).catch((error)=>{
            console.log(error)
        })

    
})


