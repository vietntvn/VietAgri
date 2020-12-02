import 'package:bloc/bloc.dart';
import 'package:vietagri/blocs/user/Bloc.dart';
import 'package:vietagri/config/Constants.dart';
import 'package:vietagri/models/User.dart';
import 'package:vietagri/repositories/UserRepository.dart';
import 'package:vietagri/utils/SharedObjects.dart';

class UserBloc extends Bloc<UserEvent, UserState> {
  final UserRepository userRepository;

  UserBloc({this.userRepository}) : super(InitialUserState());

  @override
  Stream<UserState> mapEventToState(UserEvent event) async* {
    if (event is SignupEvent) {
      yield* mapSignupEventToState(event);
    }
    if (event is LoginEvent) {
      yield* mapLoginEventToState(event);
    }
    if (event is LogoutEvent) {
      yield* mapLogoutEventToState(event);
    }
  }

  Stream<UserState> mapSignupEventToState(SignupEvent event) async* {
    try {
      yield AuthenticationInProgress();
      if (event.userId != null) {
        final User user = await userRepository.updateProfile(event.userId, event.fullName, event.email, event.address, event.password, event.username, event.image);
        if (user != null) {
          yield LoggedInState(user);
        } else {
          yield SignupIsDuplicate();
        }
      } else {
        final bool isDuplicate = await userRepository.signup(event.fullName,
            event.email, event.address, event.password, event.username, event.image);
        if (isDuplicate) {
          yield SignupIsDuplicate();
        } else {
          yield AuthenticationCompleted();
          final User user = await userRepository.login(event.username, event.password);
          yield LoggedInState(user);
        }
      }
    } on Exception catch (exception) {
      yield AuthenticationErrorState(exception);
    }
  }

  Stream<UserState> mapLoginEventToState(LoginEvent event) async* {
    try {
      yield AuthenticationInProgress();
      final User user =
          await userRepository.login(event.username, event.password, isSessionLogin: event.sessionLogin);
      if (user != null) {
        yield LoggedInState(user);
      } else {
        if (event.sessionLogin) {
          yield LoggedOutState();
        } else {
          yield LoginInfoNotExist();
        }
      }
    } on Exception catch (exception) {
      yield AuthenticationErrorState(exception);
    }
  }

  Stream<UserState> mapLogoutEventToState(LogoutEvent event) async* {
    try {
      SharedObjects.prefs.setValue(Constants.sessionId, null, 'string');
      yield LoggedOutState();
    } on Exception catch (exception) {
      yield AuthenticationErrorState(exception);
    }
  }
}
