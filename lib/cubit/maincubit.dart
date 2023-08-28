
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:news/login/cubit/state.dart';

import '../../models/UserModel.dart';





class LoginCubit extends Cubit<LoginState> {
  LoginCubit() : super(LoginInitialState());
  static LoginCubit get(context) => BlocProvider.of(context);
  void createUser({
    required String image,
    required String email,
    required String uId,
    required String name,
    required String phone,

  }) {
    UserModel model=UserModel(
        email: email,
        name: name,
        phone: phone,
        uId: uId,
        image: image, date: '', lastmessage: ''

    );

    FirebaseFirestore.instance.collection("users").doc(uId).set(model.Tomap()).then((value) {

      emit(LoginSuccessState(uId));
    }).catchError((error) {
      emit(LoginSuccessState(error.toString()));
    });
  }
  String name='';
  String email='';
  String phone='';
  String photo='';
  signInWithGoogle()async{
    final GoogleSignInAccount? guser=await GoogleSignIn().signIn();
    final GoogleSignInAuthentication gAuth= await guser!.authentication;
    final credential= GoogleAuthProvider.credential(
      accessToken: gAuth.accessToken,
      idToken: gAuth.idToken,
    );
    emit(LoginLoadingState());
    return await FirebaseAuth.instance.signInWithCredential(credential).then((value) {
      name= value.user!.displayName!;
      email=value.user!.email!;
      phone=value.user!.photoURL!;
      createUser(image: phone, email: email, uId: value.user!.uid, name: name, phone: phone);

      emit(LoginSuccessState(value.user!.uid));
    });
  }

  // LoginModel? loginModel;

  Future<void> userLogin({required String email, required String password}) async {
    emit(LoginLoadingState());
    await  FirebaseAuth.instance.signInWithEmailAndPassword(email: email, password: password) .then((value) {

      emit(LoginSuccessState(value.user!.uid));
    }).catchError((error) {
      emit(LoginErrorState(error.toString()));
    });
  }

  IconData suffix = Icons.visibility_outlined;
  bool isPassword = true;

  // ignore: non_constant_identifier_names
  void ChangePassword() {
    isPassword = !isPassword;
    suffix =
    isPassword ? Icons.visibility_outlined : Icons.visibility_off_outlined;

    emit(ChangePasswordState());
  }
}
