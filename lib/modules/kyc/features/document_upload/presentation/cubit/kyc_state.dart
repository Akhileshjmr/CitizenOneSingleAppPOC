import 'package:equatable/equatable.dart';
import '../../domain/entities/kyc_document_entity.dart';

abstract class KycState extends Equatable {
  const KycState();

  @override
  List<Object?> get props => [];
}

class KycInitial extends KycState {
  const KycInitial();
}

class KycLoading extends KycState {
  const KycLoading();
}

class KycSuccess extends KycState {
  final KycDocumentEntity document;

  const KycSuccess(this.document);

  @override
  List<Object?> get props => [document];
}

class KycFailure extends KycState {
  final String message;

  const KycFailure(this.message);

  @override
  List<Object?> get props => [message];
}
