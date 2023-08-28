abstract class LoginState {}

class LoginInitialState extends LoginState {}

class LoginLoadingState extends LoginState {}
class   CreateUserSuccessState extends LoginState {}



class CreateUserErrorState extends LoginState {
  final String error;

  CreateUserErrorState(this.error);
}

class LoginSuccessState extends LoginState {
  final String uId;

  LoginSuccessState(this.uId);

}

class LoginErrorState extends LoginState {
  final String error;

  LoginErrorState(this.error);
}

class ChangePasswordState extends LoginState {}
