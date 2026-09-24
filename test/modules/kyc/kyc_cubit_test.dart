import 'package:flutter_test/flutter_test.dart';
import 'package:citizenone_app/core/core.dart';
import 'package:citizenone_app/modules/kyc/kyc.dart';
import 'package:citizenone_app/modules/kyc/features/document_upload/data/api/kyc_api.dart';
import 'package:citizenone_app/modules/kyc/features/document_upload/data/repository/kyc_repository.dart';
import 'package:citizenone_app/modules/kyc/features/document_upload/domain/usecases/upload_kyc_document.dart';

void main() {
  group('KycCubit Tests', () {
    late KycCubit cubit;

    setUp(() {
      final apiClient = ApiClient();
      final api = KycApi(apiClient);
      final repo = KycRepositoryImpl(api);
      final useCase = UploadKycDocumentUseCase(repo);
      cubit = KycCubit(useCase);
    });

    tearDown(() {
      cubit.close();
    });

    test('Initial state is KycInitial', () {
      expect(cubit.state, isA<KycInitial>());
    });

    test('Document submission emits Loading then Success', () async {
      final expectation = expectLater(
        cubit.stream,
        emitsInOrder([
          isA<KycLoading>(),
          isA<KycSuccess>(),
        ]),
      );

      await cubit.submitDocument(type: 'National ID', number: 'ID-8820192');
      await expectation;
    });
  });
}
