const functions = require("firebase-functions");
const admin = require("firebase-admin");
admin.initializeApp();

// // Create and Deploy Your First Cloud Functions
// // https://firebase.google.com/docs/functions/write-firebase-functions
//
// exports.helloWorld = functions.https.onRequest((request, response) => {
//   functions.logger.info("Hello logs!", {structuredData: true});
//   response.send("Hello from Firebase!");
// });

exports.onCreateFollower = functions.firestore.document("/followers/{userId}/usersFollowers/{followerId}")
.onCreate(async(snapshot, context) => {
    console.log("Follower Created", snapshot.id);
    const userId = context.params.userId;
    const followerId = context.params.followerId;

    //1.) create followed users post
    const followedUserPostRef = admin.firestore().collection('posts').doc(userId).collection('usersPost');

    //2.) create following users timeline
    const timelinePostsRef = admin.firestore().collection('timeline').doc(followerId).collection('timelinePost');

    //3.) get followed usersw post
    const querySnapshot = await followedUserPostRef.get();

    //4.) add each users post to following users timeline
    querySnapshot.forEach(doc => {
        if(doc.exists){
            const postId = doc.id;
            const postData = doc.data();
            timelinePostsRef.doc(postId).set(postData);
        }
    })
})

exports.onDeleteFollower = functions.firestore.document("/followers/{userId}/usersFollowers/{followerId}")
.onDelete(async(snapshot, context) => {
    console.log("Follower Deleted", snapshot.id);
    const userId = context.params.userId;
    const followerId = context.params.followerId;

    const timelinePostsRef = admin.firestore().collection('timeline').doc(followerId).collection('timelinePost').where("ownerId", "==" , userId);

    const querySnapshot = await timelinePostsRef.get();
    querySnapshot.forEach(doc => {
        if(doc.exists){
            doc.ref.delete();
        }
    })

})

exports.onCreatePost = functions.firestore.document("/posts/{userId}/usersPost/{postId}")
.onCreate(async(snapshot, context) => {
    const postCreated = snapshot.data();
    const userId = context.params.userId;
    const postId = context.params.postId;

    //1.) get all the followers of the user who created the post
    const userFollowerRef = admin.firestore().collection('followers').doc(userId).collection('usersFollowers');

    const querySnapshot = await userFollowerRef.get();

    //2.) get each post to each timeline
    querySnapshot.forEach(doc => {
        const followerId = doc.id;

        admin.firestore().collection('timeline').doc(followerId)
        .collection('timelinePost').doc(postId).set(postCreated);
    })
})

exports.onUpdatePost = functions.firestore.document("/posts/{userId}/usersPost/{postId}")
.onUpdate(async(change, context) => {
    const postUpdated = change.after.data();
    const userId = context.params.userId;
    const postId = context.params.postId;

    //1.) get all the followers of the user who created the post
    const userFollowerRef = admin.firestore().collection('followers').doc(userId).collection('usersFollowers');
    const querySnapshot = await userFollowerRef.get();

    //2.) update each post to each timeline
    querySnapshot.forEach(doc => {
        const followerId = doc.id;

        admin.firestore().collection('timeline').doc(followerId)
        .collection('timelinePost').doc(postId).get().then(doc => {
            if(doc.exists){
                doc.ref.update(postUpdated);
            }
        })
    })
})

exports.onDeletePost = functions.firestore.document("/posts/{userId}/usersPost/{postId}")
.onDelete(async(snapshot, context) => {
    const userId = context.params.userId;
    const postId = context.params.postId;

    //1.) get all the followers of the user who created the post
    const userFollowerRef = admin.firestore().collection('followers').doc(userId).collection('usersFollowers');
    const querySnapshot = await userFollowerRef.get();

    //2.) update each post to each timeline
    querySnapshot.forEach(doc => {
        const followerId = doc.id;

        admin.firestore().collection('timeline').doc(followerId)
        .collection('timelinePost').doc(postId).get().then(doc => {
            if(doc.exists){
                doc.ref.delete();
            }
        })
    })
})