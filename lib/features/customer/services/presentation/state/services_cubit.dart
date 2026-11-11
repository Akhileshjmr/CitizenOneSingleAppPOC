import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:citizenone_app/features/customer/services/domain/entities/service_category.dart';
import 'package:citizenone_app/features/customer/services/domain/usecases/get_services_use_case.dart';

part 'services_state.dart';

class ServicesCubit extends Cubit<ServicesState> {
  final GetServicesUseCase getServicesUseCase;

  ServicesCubit(this.getServicesUseCase) : super(ServicesInitial());

  Future<void> loadServices() async {
    emit(ServicesLoading());
    try {
      final services = await getServicesUseCase.execute();
      emit(ServicesLoaded(services));
    } catch (e) {
      emit(ServicesError(e.toString()));
    }
  }
}
