import 'package:firebase_auth/firebase_auth.dart';
import 'package:odysseusrecipes/screens/Root.dart';

/* Helper function that logs in and updates app state. */
void login(RootState rootState, String email, String password) async {
  rootState.widget.getAuth().signInWithEmailAndPassword(email: email, password: password);
  FirebaseUser user = await rootState.widget.getAuth().currentUser();
  rootState.setUser(user);
}

void logOut(RootState rootState) {
  rootState.widget.getAuth().signOut();
  rootState.clearUser();
}

