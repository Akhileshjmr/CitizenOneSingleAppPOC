import 'package:flutter_bloc/flutter_bloc.dart';
import 'citizen_state.dart';
import '../../domain/usecases/get_citizen_services.dart';

class CitizenCubit extends Cubit<CitizenState> {
  final GetCitizenServicesUseCase getServicesUseCase;

  CitizenCubit(this.getServicesUseCase) : super(const CitizenInitial());

  Future<void> loadServices() async {
    emit(const CitizenLoading());
    try {
      final services = await getServicesUseCase();
      emit(CitizenLoaded(services));
    } catch (e) {
      emit(CitizenFailure(e.toString()));
    }
  }
}
