// loading_cubit.dart
import 'package:citizenone_app/modules/agency_banking/theme/colors/Appcolors.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:citizenone_app/modules/loans_module/app/components/utils/app_utils.dart';

class LoadingCubit extends Cubit<bool> {
  LoadingCubit() : super(false);

  void show() {
    hideKeyboard();
    emit(true);
  }
  void hide() => emit(false);
}
class GlobalLoader extends StatelessWidget {
  const GlobalLoader({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LoadingCubit, bool>(
      builder: (context, isLoading) {
        if (!isLoading) return const SizedBox.shrink();
        return Container(
          color: Colors.black.withOpacity(0.3),
          child: Center(
            child: LoadingAnimationWidget.progressiveDots(
              color: AppColors.fbTooLite,
              size: 60,
            ),
          ),
        );
      },
    );
  }
}
