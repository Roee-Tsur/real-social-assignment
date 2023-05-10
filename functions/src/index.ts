import * as functions from 'firebase-functions';
import * as admin from 'firebase-admin';
admin.initializeApp();

export const onNewUser = functions.region("europe-central2").auth.user().onCreate((user) => {
  const uid = user.uid;
  const email = user.email;
  const displayName = user.displayName;

  const db = admin.firestore();
  const userRef = db.collection('users').doc(uid);

  return userRef.set({
    email: email ?? null,
    displayName: displayName ?? email ?? null,
    places: []
  });
});