import '../enums/enums.dart';

class ApiConfig {
  //prod,dev,stage
  static const Environment env = Environment.staging;
  static const String localhost = "http://192.168.100.34:8080";
  static const String stagingServerUrl = 'https://v1.agcar.cloud';
  static String prodServerUrl = 'https://janna-mart.com';
  static const String apiUrl = "/api";
  static const String apiVersion1 = "/v1";
  // static String baseUrl = prodServerUrl + apiUrl;
  static String baseUrl = (env == Environment.production
          ? prodServerUrl
          : env == Environment.staging
              ? stagingServerUrl
              : localhost) +
      apiUrl +
      apiVersion1;
  static const String loginUrl = '/login?type=camera';
  static const String authUrl = '/auth';
  static const String userAuthUrl = '/user-auth';
  static const String uploadImageUrl = '/upload-images';
  static const String otpUrl = '/otp';
  static const String sendUrl = '/send';
  static const String verificationUrl = '/verification';

  static const String validateUrl = '/validate';
  static const String registerUrl = '/register';
  static const String campaignsUrl = '/campaigns';
  static const String profileUrl = '/profile';
  static const String passwordUrl = "/password";
  static const String categoriesUrl = "/categories";
  static const String couponsUrl = "/coupons";
  static const String customerUrl = "/customers";
  static const String deletecustomerUrl = "/deletecustomer";

  static const String adsUrl = '/ads';
  static const String placementUrl = '/placement';
  static const String userUrl = '/user';
  static const String countriesUrl = '/countries';
  static const String availableUrl = '/available';
  static const String galleryUrl = '/gallery';
  static const String galleryEditUrl = '/gallery-edit/';
  static const String refreshUrl = '/refresh/';
  static const String tokenUrl = '/token';
  static const String checkoutUrl = '/checkout';
  static const String teamUrl = '/teams';
  static const String listingUrl = '/listings';
  static const String carnumberUrl = '/carnumber';
  static const String makesUrl = '/makes';
  static const String masterUrl = '/master';
  static const String modelsUrl = '/models';
  static const String releasesUrl = '/releases';
  static const String makeoriginsUrl = '/make-origins';
  static const String optionsUrl = '/options';
  static const String labelsUrl = '/labels';
  static const String propsUrl = '/props';
  static const String colorsUrl = '/colors';
  static const String transmissionUrl = '/transmission';
  static const String sheetColorsUrl = '/sheet-colors';
  static const String allUrl = '/all';
  static const String agUrl = '/ag';
  static const String filtersUrl = '/filters';
  static const String mediaUrl = '/media';
  static const String permissionsGuardUrl = '/permissions-guard';

  static const String versionCheckUrl =
      'https://files.theyetilabs.com/eNirman/version/app_version.json';
}
