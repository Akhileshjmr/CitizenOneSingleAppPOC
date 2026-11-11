import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:citizenone_app/features/agent/customers/domain/entities/agent_customer_entity.dart';
import 'package:citizenone_app/features/agent/customers/domain/usecases/get_agent_customers_usecase.dart';
import 'package:citizenone_app/features/agent/customers/presentation/state/agent_customers_state.dart';

class AgentCustomersCubit extends Cubit<AgentCustomersState> {
  final GetAgentCustomersUseCase _getCustomersUseCase;

  AgentCustomersCubit({required GetAgentCustomersUseCase getCustomersUseCase})
      : _getCustomersUseCase = getCustomersUseCase,
        super(const AgentCustomersState());

  Future<void> loadCustomers() async {
    emit(state.copyWith(isLoading: true, errorMessage: null));
    try {
      final customers = await _getCustomersUseCase();
      emit(state.copyWith(customers: customers, isLoading: false));
    } catch (_) {
      emit(state.copyWith(
        isLoading: false,
        errorMessage: 'Failed to load customers.',
      ));
    }
  }

  void setFilter(CustomerStatus? status) {
    emit(state.copyWith(
      filterStatus: status,
      clearFilter: status == null,
    ));
  }

  void search(String query) {
    emit(state.copyWith(searchQuery: query));
  }
}
