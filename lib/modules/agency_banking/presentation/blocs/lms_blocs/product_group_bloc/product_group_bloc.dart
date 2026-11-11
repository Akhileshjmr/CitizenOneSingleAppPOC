import 'package:citizenone_app/modules/agency_banking/presentation/blocs/lms_blocs/product_group_bloc/product_group_event.dart';
import 'package:citizenone_app/modules/agency_banking/presentation/blocs/lms_blocs/product_group_bloc/product_group_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../data/services/AuthService.dart';

class ProductGroupBloc extends Bloc<ProductGroupEvent, ProductGroupState> {
  final AuthService authService;

  ProductGroupBloc(this.authService) : super(ProductGroupInitial()) {
    on<ProductGroupSubmitted>(_onProductGroupSubmitted);
  }

  Future<void> _onProductGroupSubmitted(
      ProductGroupSubmitted event, Emitter<ProductGroupState> emit) async {
    emit(ProductGroupLoading());

    try {
      final response = await authService.productGroup(event.productGroup);
      if (response != null && response.responseCode == "AB-ATTEMPT-100") {
        // Successful search
        emit(ProductGroupSuccess(response,response.responseCode));
      } else if (response != null) {
        // Search failed with error description
        emit(ProductGroupFailure(response.responseDesc));
      } else {
        // Null response scenario
        emit(ProductGroupFailure('No data returned from the search'));
      }
    } catch (e) {
      // Error handling during search
      emit(ProductGroupFailure('An error occurred during the account search'));
    }
  }
}