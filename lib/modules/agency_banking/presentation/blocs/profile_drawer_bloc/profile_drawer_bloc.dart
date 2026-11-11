import 'package:citizenone_app/modules/agency_banking/core/services/connectivity_service.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:citizenone_app/modules/agency_banking/data/services/AuthService.dart';
import 'profile_drawer_event.dart';
import 'profile_drawer_state.dart';

class ProfileDrawerBloc extends Bloc<ProfileDrawerEvent, ProfileDrawerState> {
  final AuthService authService;

  ProfileDrawerBloc(this.authService) : super(ProfileDrawerInitial()) {
    on<FetchProfileDrawerData>(_onFetchProfileDrawerData);
  }

  Future<void> _onFetchProfileDrawerData(
      FetchProfileDrawerData event, Emitter<ProfileDrawerState> emit) async {
    final isConnected = await ConnectivityService.hasConnection();

    if (!isConnected) {
      emit(ProfileDrawerFailure(
          "You're offline. Please check your internet connection and try again."));
      return;
    }

    emit(ProfileDrawerLoading());

    try {
      final response = await authService.userProfile(event.agentDetails);

      if (response != null &&
          response.resMessage.errorCode == "AB-ATTEMPT-100") {
        emit(ProfileDrawerSuccess(response));
      } else if (response != null) {
        emit(ProfileDrawerFailure(response.resMessage.errorDescription));
      } else {
        emit(ProfileDrawerFailure('No data returned from the search'));
      }
    } catch (e) {
      emit(
          ProfileDrawerFailure('An error occurred while getting user profile'));
    }
  }
}
