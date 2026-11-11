import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import '../../domain/entities/agent_customer_entity.dart';
import '../../domain/usecases/get_agent_customers_usecase.dart';

abstract class AgentCustomersState extends Equatable {
  const AgentCustomersState();
  @override
  List<Object?> get props => [];
}

class AgentCustomersInitial extends AgentCustomersState {}

class AgentCustomersLoading extends AgentCustomersState {}

class AgentCustomersLoaded extends AgentCustomersState {
  final List<AgentCustomerEntity> customers;
  final List<AgentCustomerEntity> filteredCustomers;
  final String searchQuery;

  const AgentCustomersLoaded({
    required this.customers,
    required this.filteredCustomers,
    this.searchQuery = '',
  });

  @override
  List<Object?> get props => [customers, filteredCustomers, searchQuery];
}

class AgentCustomersError extends AgentCustomersState {
  final String message;
  const AgentCustomersError(this.message);

  @override
  List<Object?> get props => [message];
}

class AgentCustomersCubit extends Cubit<AgentCustomersState> {
  final GetAgentCustomersUseCase getCustomersUseCase;

  AgentCustomersCubit(this.getCustomersUseCase)
      : super(AgentCustomersInitial());

  Future<void> loadCustomers() async {
    emit(AgentCustomersLoading());
    try {
      final customers = await getCustomersUseCase();
      emit(AgentCustomersLoaded(
        customers: customers,
        filteredCustomers: customers,
      ));
    } catch (e) {
      emit(AgentCustomersError(e.toString()));
    }
  }

  void searchCustomers(String query) {
    if (state is AgentCustomersLoaded) {
      final current = state as AgentCustomersLoaded;
      final filtered =
          current.customers.where((c) => c.matches(query)).toList();
      emit(AgentCustomersLoaded(
        customers: current.customers,
        filteredCustomers: filtered,
        searchQuery: query,
      ));
    }
  }

  void reset() {
    emit(AgentCustomersInitial());
  }
}

