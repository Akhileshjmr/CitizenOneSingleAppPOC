import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import '../../domain/entities/insurance_category_entity.dart';
import '../../domain/usecases/get_insurance_categories_usecase.dart';

abstract class InsuranceCategoriesState extends Equatable {
  const InsuranceCategoriesState();
  @override
  List<Object?> get props => [];
}

class InsuranceCategoriesInitial extends InsuranceCategoriesState {}

class InsuranceCategoriesLoading extends InsuranceCategoriesState {}

class InsuranceCategoriesLoaded extends InsuranceCategoriesState {
  final List<InsuranceCategoryEntity> categories;
  final InsuranceCategoryEntity? selectedCategory;

  const InsuranceCategoriesLoaded(this.categories, {this.selectedCategory});

  @override
  List<Object?> get props => [categories, selectedCategory];
}

class InsuranceCategoriesError extends InsuranceCategoriesState {
  final String message;
  const InsuranceCategoriesError(this.message);

  @override
  List<Object?> get props => [message];
}

class InsuranceCategoriesCubit extends Cubit<InsuranceCategoriesState> {
  final GetInsuranceCategoriesUseCase getCategoriesUseCase;

  InsuranceCategoriesCubit(this.getCategoriesUseCase)
      : super(InsuranceCategoriesInitial());

  Future<void> loadCategories({String? vendorCode}) async {
    emit(InsuranceCategoriesLoading());
    try {
      final categories = await getCategoriesUseCase(vendorCode: vendorCode);
      emit(InsuranceCategoriesLoaded(
        categories,
        selectedCategory: categories.isNotEmpty ? categories.first : null,
      ));
    } catch (e) {
      emit(InsuranceCategoriesError(e.toString()));
    }
  }

  void selectCategory(InsuranceCategoryEntity category) {
    if (state is InsuranceCategoriesLoaded) {
      final current = state as InsuranceCategoriesLoaded;
      emit(InsuranceCategoriesLoaded(current.categories, selectedCategory: category));
    }
  }

  void reset() {
    emit(InsuranceCategoriesInitial());
  }
}

