part of 'usecase.dart';

@injectable
class LoginUsecase extends UseCase<LoginResponseModel, LoginRequestModel> {
  final AuthRepository _repository;

  LoginUsecase(this._repository);
  @override
  Future<Either<Failure, LoginResponseModel>> call(LoginRequestModel params) {
    return _repository.login(params);
  }
}
