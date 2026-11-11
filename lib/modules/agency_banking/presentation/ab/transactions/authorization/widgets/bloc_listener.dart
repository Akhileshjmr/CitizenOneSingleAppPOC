import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../../utils/Loader.dart';

BlocListener<B, S> loadingAwareListener<B extends StateStreamable<S>, S>({
  required bool Function(S state) isLoading,
  void Function(BuildContext context, S state)? onState,
}) {
  return BlocListener<B, S>(
    listener: (context, state) {
      if (isLoading(state)) {
        context.read<LoadingCubit>().show();
      } else {
        context.read<LoadingCubit>().hide();
      }
      onState?.call(context, state);
    },
  );
}