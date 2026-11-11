import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:citizenone_app/features/auth/domain/entities/user_role.dart';
import 'package:citizenone_app/features/customer/dashboard/domain/usecases/get_services_usecase.dart';
import 'package:citizenone_app/features/customer/dashboard/presentation/state/services_state.dart';

class ServicesCubit extends Cubit<ServicesState> {
  final GetServicesUseCase _getServicesUseCase;

  ServicesCubit({required GetServicesUseCase getServicesUseCase})
      : _getServicesUseCase = getServicesUseCase,
        super(const ServicesState());

  Future<void> loadServices(UserRole role) async {
    emit(state.copyWith(isLoading: true));
    try {
      final services = await _getServicesUseCase(role);
      emit(state.copyWith(services: services, isLoading: false));
    } catch (e) {
      emit(state.copyWith(isLoading: false));
      // Handle error
    }
  }
}
