abstract class LoginState{}

class InitialLoginState extends LoginState{

}

class SuccesLoginState extends LoginState{

}

class LoadingLoginState extends LoginState {

}

class FailureLoginState extends LoginState{
String msg;

FailureLoginState(this.msg);
}