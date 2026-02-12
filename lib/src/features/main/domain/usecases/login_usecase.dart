part of 'usecase.dart';

@injectable
class UploadImageUsecase
    extends UseCase<CommonResponseModel, UploadImageRequestModel> {
  final MainRepository _repository;

  UploadImageUsecase(this._repository);
  @override
  Future<Either<Failure, CommonResponseModel>> call(
      UploadImageRequestModel params) {
    return _repository.uploadImages(params);
  }
}
