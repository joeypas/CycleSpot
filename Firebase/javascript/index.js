/**
 * Import function triggers from their respective submodules:
 *
 * const {onCall} = require("firebase-functions/v2/https");
 * const {onDocumentWritten} = require("firebase-functions/v2/firestore");
 *
 * See a full list of supported triggers at https://firebase.google.com/docs/functions
 */

const logger = require("firebase-functions/logger");
const functions = require("firebase-functions/v1");
const admin = require("firebase-admin");
admin.initializeApp();
// For cost control, you can set the maximum number of containers that can be
// running at the same time. This helps mitigate the impact of unexpected
// traffic spikes by instead downgrading performance. This limit is a
// per-function limit. You can override the limit for each function using the
// `maxInstances` option in the function's options, e.g.
// `onRequest({ maxInstances: 5 }, (req, res) => { ... })`.
// NOTE: setGlobalOptions does not apply to functions using the v1 API. V1
// functions should each use functions.runWith({ maxInstances: 10 }) instead.
// In the v1 API, each function can only serve one request per container, so
// this will be the maximum concurrent request count.
functions.runWith({ maxInstances: 10 })

// Create and deploy your first functions
// https://firebase.google.com/docs/functions/get-started

// exports.helloWorld = onRequest((request, response) => {
//   logger.info("Hello logs!", {structuredData: true});
//   response.send("Hello from Firebase!");
// });
//
exports.onUserCreated = functions.auth.user().onCreate(async (user) => {
  const userId = user.uid;

  const data = {
    uid: userId,
    email: user.email || null,
    profileImagePath: user.photoURL || null,
    badges: [],
    pinnedLocations: [],
    reviews: [],
    createdAt: admin.firestore.FieldValue.serverTimestamp(),
  };

  await admin.firestore().collection("users").doc(userId).set(data);

  console.log(`Created Firestore document for ${userId}`);
})
