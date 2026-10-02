import 'package:news_app_clean_architecture/features/auth/domain/entities/user.dart';
import 'package:news_app_clean_architecture/features/auth/domain/repository/auth_repository.dart';

/// Follows who is signed in. It returns a stream instead of a single result, so it does not implement
/// [UseCase], whose `call` returns a `Future`.
class WatchSessionUseCase {
  final AuthRepository _authRepository;

  WatchSessionUseCase(this._authRepository);

  Stream<UserEntity?> call() => _authRepository.watchSession();
}
