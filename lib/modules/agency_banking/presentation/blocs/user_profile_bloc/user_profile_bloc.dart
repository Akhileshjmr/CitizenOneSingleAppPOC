import 'package:citizenone_app/modules/agency_banking/core/services/connectivity_service.dart';
import 'package:citizenone_app/modules/agency_banking/presentation/blocs/user_profile_bloc/user_profile_event.dart';
import 'package:citizenone_app/modules/agency_banking/presentation/blocs/user_profile_bloc/user_profile_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../data/services/AuthService.dart';

class UserProfileBloc extends Bloc<UserProfileEvent, UserProfileState> {
  final AuthService authService;
  UserProfileBloc(this.authService) : super(UserProfileInitial()) {
    on<UserProfileSubmitted>(_onUserProfileSubmitted);
  }

  Future<void> _onUserProfileSubmitted(
      UserProfileSubmitted event, Emitter<UserProfileState> emit) async {
    // Check internet connection first
    final isConnected = await ConnectivityService.hasConnection();

    if (!isConnected) {
      emit(UserProfileFailure(
          "You're offline. Please check your internet connection and try again."));
      return;
    }
    emit(UserProfileLoading());

    try {
      final response = await authService.userProfile(event.agentDetails);

      // Ensure the response is not null
      if (response != null &&
          response.resMessage.errorCode == "AB-ATTEMPT-100") {
        // Successful search
        emit(
            UserProfileSuccess(response.resMessage.errorDescription, response));
      } else if (response != null) {
        // Search failed with error description
        emit(UserProfileFailure(response.resMessage.errorDescription));
      } else {
        // Null response scenario
        emit(UserProfileFailure('No data returned from the search'));
      }
    } catch (e) {
      // Error handling during search
      emit(UserProfileFailure('An error occurred while getting user profile'));
    }
  }
}
