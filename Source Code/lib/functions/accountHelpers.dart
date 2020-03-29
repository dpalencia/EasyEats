import 'package:firebase_auth/firebase_auth.dart'; 
import 'package:odysseusrecipes/screens/Root.dart';

/* Helper function that logs in and updates app state. */
void login(RootState rootState, String email, String password) async {
  FirebaseUser user;
  try {
    await rootState.widget.getAuth().signInWithEmailAndPassword(email: email, password: password);
    user = await rootState.widget.getAuth().currentUser();
  } catch(e) {
 
    return;
  }
  rootState.setUser(user);
}

void logOut(RootState rootState) {
  rootState.widget.getAuth().signOut();
  rootState.clearUser();
}

