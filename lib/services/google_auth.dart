// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:google_sign_in/google_sign_in.dart';
// import 'package:project_hestia/services/shared_prefs_custom.dart';

// final FirebaseAuth _auth = FirebaseAuth.instance;
// final GoogleSignIn googleSignIn = GoogleSignIn(
//     scopes: ['email', 'https://www.googleapis.com/auth/contacts.readonly']);

// Future<String> signInWithGoogle() async {
//   GoogleSignInAccount googleSignInAccount;

//   try {
//     googleSignInAccount = await googleSignIn.signIn();
//     final GoogleSignInAuthentication googleSignInAuthentication =
//         await googleSignInAccount.authentication;

//     final AuthCredential credential = GoogleAuthProvider.getCredential(
//       accessToken: googleSignInAuthentication.accessToken,
//       idToken: googleSignInAuthentication.idToken,
//     );

//     final AuthResult authResult = await _auth.signInWithCredential(credential);
//     final FirebaseUser user = authResult.user;

//     assert(!user.isAnonymous);
//     assert(await user.getIdToken() != null);

//     final FirebaseUser currentUser = await _auth.currentUser();
//     assert(user.uid == currentUser.uid);
//     final SharedPrefsCustom sp = SharedPrefsCustom();
//     sp.setIfUsedGauth(true);
//     // print(user.email);
//     // sp.setUserEmail(user.email??"");
//     // print(user.displayName);
//     // sp.setUserName(user.displayName??"");
//     // print(user.phoneNumber);
//     // sp.setPhone(user.phoneNumber??"");
//     return 'signInWithGoogle succeeded: $user';
//   } catch (e) {
//     print(e);
//     return '';
//   }
// }

// void signOutGoogle() async {
//   await googleSignIn.signOut();

//   print("User Sign Out");
// }
