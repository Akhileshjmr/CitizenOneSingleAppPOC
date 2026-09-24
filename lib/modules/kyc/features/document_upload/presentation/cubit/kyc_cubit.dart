import 'package:flutter_bloc/flutter_bloc.dart';
import 'kyc_state.dart';
import '../../domain/usecases/upload_kyc_document.dart';

class KycCubit extends Cubit<KycState> {
  final UploadKycDocumentUseCase uploadUseCase;

  KycCubit(this.uploadUseCase) : super(const KycInitial());

  Future<void> submitDocument({
    required String type,
    required String number,
  }) async {
    emit(const KycLoading());
    try {
      final doc = await uploadUseCase(type: type, number: number);
      emit(KycSuccess(doc));
    } catch (e) {
      emit(KycFailure(e.toString()));
    }
  }

  void reset() {
    emit(const KycInitial());
  }
}
