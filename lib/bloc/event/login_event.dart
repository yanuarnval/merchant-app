abstract class LoginEvent {

}

class PostLogin extends LoginEvent{
  String email;
  String password;

  PostLogin(this.email, this.password);
}