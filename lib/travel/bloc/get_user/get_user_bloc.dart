import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_nhu_nguyen/travel/model/user_model.dart';
import 'package:flutter_nhu_nguyen/travel/repository/user_repository.dart';

part 'get_user_event.dart';
part 'get_user_state.dart';

class GetUserBloc extends Bloc<GetUserEvent, GetUserState> {
  final UserRepository userRepository;
  GetUserBloc(this.userRepository) : super(GetUserLoading()) {
    on<LoadUserEvent>(_onUserLoaded);
  }

  void _onUserLoaded(event, Emitter<GetUserState> emit) async {
    try {
      User user = await userRepository.getUserById(event.Id);
      print(user.name);
      if(user == null){
        emit(GetUsergEmpty());
      }else{
        emit(GetUserLoaded(user: user));
      }
    } catch (e) {
      emit(GetUserFailure());
    }
  }
}