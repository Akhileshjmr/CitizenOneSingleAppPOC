import 'package:citizenone_app/modules/agency_banking/presentation/blocs/lms_blocs/products-list/products_list_event.dart';
import 'package:citizenone_app/modules/agency_banking/presentation/blocs/lms_blocs/products-list/products_list_state.dart';
import 'package:citizenone_app/modules/agency_banking/utils/AppLogger.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../data/services/AuthService.dart';

class ProductsListBloc extends Bloc<ProductsListEvent, ProductsListState> {
  final AuthService authService;

  ProductsListBloc(this.authService) : super(ProductsListInitial()) {
    on<ProductsListSubmitted>(_onProductsListSubmitted);
  }

  Future<void> _onProductsListSubmitted(
      ProductsListSubmitted event, Emitter<ProductsListState> emit) async {
    emit(ProductsListLoading());

    try {
      final response =
          await authService.product_list(event.gdbMerchantDisProductPurRequest);
      AppLogger.debug('Products list response received');
      // Ensure the response is not null
      if (response != null && response.responseCode == "AB-ATTEMPT-100") {
        // Successful search
        emit(ProductsListSuccess(response.responseCode, response));
      } else if (response != null) {
        // Search failed with error description
        emit(ProductsListFailure(response.responseDesc));
      } else {
        // Null response scenario
        emit(ProductsListFailure('No data returned from the search'));
      }
    } catch (e) {
      // Error handling during search
      emit(ProductsListFailure('An error occurred during the account search'));
    }
  }
}
