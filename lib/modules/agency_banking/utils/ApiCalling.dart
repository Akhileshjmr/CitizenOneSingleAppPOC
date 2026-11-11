import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../data/models/CommLanguageLabels.dart';
import '../data/models/common_models/HeaderInfo.dart';
import '../presentation/blocs/language_label_bloc/language_labels_bloc.dart';
import '../presentation/blocs/language_label_bloc/language_labels_event.dart';
import '../presentation/blocs/language_label_bloc/language_labels_state.dart';

class ApiCalling {

  static Future<CommLanguageLabels> getLabels(BuildContext context, String lng,
      String screenName) {
    final Completer<CommLanguageLabels> completer = Completer();
    CommLanguageLabels commLanguageLabels = CommLanguageLabels();
    HeaderInfo headerInfo = HeaderInfo();
    headerInfo.message = "SKIP_SESSION";
    commLanguageLabels.headerInfo = headerInfo;
    commLanguageLabels.language = lng;
    commLanguageLabels.screen_name = screenName;
    context.read<LanguageLabelsBloc>().add(
        LanguageLabelsSubmitted(commLanguageLabels));
    StreamSubscription subscription;
    subscription = context.read<LanguageLabelsBloc>().stream.listen((state) {
      if (state is LanguageLabelsSuccess) {
        completer.complete(state.commLanguageLabels); // Return API response
      } else if (state is LanguageLabelsFailure) {
        completer.completeError(state.error); // Handle API error
      }
    });
    return completer.future;
  }
}