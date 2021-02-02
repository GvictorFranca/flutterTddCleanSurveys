import 'package:flutterClean/domain/usecases/usecases.dart';
import 'package:flutterClean/presentation/mixins/mixins.dart';
import 'package:flutterClean/ui/pages/pages.dart';
import 'package:meta/meta.dart';

class GetxSplashPresenter with NavigationManager implements SplashPresenter {
  final LoadCurrentAccount loadCurrentAccount;

  GetxSplashPresenter({@required this.loadCurrentAccount});

  Future<void> checkAccount({int durationInSeconds = 2}) async {
    await Future.delayed(Duration(seconds: durationInSeconds));
    try {
      final account = await loadCurrentAccount.load();
      navigateTo = account?.token == null ? '/login' : '/surveys';
    } catch (error) {
      navigateTo = '/login';
    }
  }
}
