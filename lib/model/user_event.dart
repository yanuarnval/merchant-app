

abstract class UserEvent {
}

class getUserFromFirestore extends UserEvent {}

class getUserByEmailFirestore extends UserEvent {
  String email;

  getUserByEmailFirestore(this.email);
}
