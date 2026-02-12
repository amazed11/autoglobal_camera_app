part of 'usecase.dart';

@injectable
class RegisterUsecase
    extends UseCase<RegisterResponseModel, RegisterRequestModel> {
  final AuthRepository _repository;

  RegisterUsecase(this._repository);
  @override
  Future<Either<Failure, RegisterResponseModel>> call(
      RegisterRequestModel params) {
    return _repository.register(params);
  }
}
