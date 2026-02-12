// import '../core/development/console.dart';
// import '../core/enums/enums.dart';
// import '../models/query_request_model.dart';

// String? getQuery(QueryRequestModel? queryRequestModel) {
//   String fullquery = '?';
//   if (queryRequestModel?.limit != null) {
//     logger(queryRequestModel?.limit, loggerType: LoggerType.warning);
//     fullquery += "page_size=${queryRequestModel?.limit}";
//   } else {
//     fullquery += "page_size=20";
//   }
//   if (queryRequestModel?.page != null) {
//     fullquery += "&page=${queryRequestModel?.page}";
//   } else {
//     fullquery += "&page=1";
//   }

//   if (queryRequestModel?.search != null && queryRequestModel?.search != '') {
//     fullquery += "&search=${queryRequestModel?.search}";
//   }

//   return fullquery == '?' ? '' : fullquery;
// }
