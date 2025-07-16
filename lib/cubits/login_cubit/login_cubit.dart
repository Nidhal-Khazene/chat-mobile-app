import 'package:bloc/bloc.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:meta/meta.dart';

part 'login_state.dart';

class LoginCubit extends Cubit<LoginState> {
  LoginCubit() : super(LoginInitial());
  Future<void> loginUser({
    required String email,
    required String password,
  }) async {
    emit(LoginLoading());
    try {
      UserCredential useCredential = await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: email, password: password);
      emit(LoginSuccess());
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        emit(LoginFailure(errMessage: "User not found."));
      } else if (e.code == 'wrong-password') {
        emit(LoginFailure(errMessage: "Wrong password"));
      } else {
        emit(LoginFailure(errMessage: "Authentication failed."));
      }
    } catch (e) {
      emit(LoginFailure(errMessage: "Something went wrong."));
    }
  }
}
