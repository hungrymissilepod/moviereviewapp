part of 'user_cubit.dart';

@immutable
abstract class UserState {
  const UserState();
}

class UserInitial extends UserState {
  const UserInitial();
}

class UserLoading extends UserState {
  const UserLoading();
}

class UserLoaded extends UserState {
  final User user;
  const UserLoaded(this.user);

  @override
  bool operator ==(Object o) {
    if (identical(this, o)) return true;

    return o is UserLoaded && o.user == user;
  }

  @override
  int get hashCode => user.hashCode;
}

class UserError extends UserState {
  final String message;
  const UserError(this.message);

  @override
  bool operator ==(Object o) {
    if (identical(this, o)) return true;

    return o is UserError && o.message == message;
  }

  @override
  int get hashCode => message.hashCode;
}