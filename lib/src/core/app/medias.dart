//svg data here...
const baseSVGPath = 'assets/svg/';

//image data here...
const baseImagePath = 'assets/images/';

//json data here...
const baseJsonPath = 'assets/json/';
const baseModelPath = 'assets/model/';

//network basepath
const baseNetworkPath = 'https://files.theyetilabs.com/eNirman/';

//images
final kLogoImage = _getImageBasePath('logo.png');
final kLoadingGif = _getImageBasePath('487.gif');
final kBackground = _getImageBasePath('background.jpeg');
final kGoogle = _getImageBasePath('google.png');
final kForgotPassword = _getImageBasePath('forgot-password.png');
final kEmail = _getImageBasePath('email.png');
final kCleaner = _getImageBasePath('cleaner.png');
final kTester = _getImageBasePath('tester.png');
final kSample1 = _getImageBasePath('sample1.png');
final kSample2 = _getImageBasePath('sample2.png');
final kSample3 = _getImageBasePath('sample3.png');
final kSample4 = _getImageBasePath('sample4.png');
//model
final kTFModel = _getModelBasePath('model.tflite');
final kTFLabel = _getModelBasePath('labels.txt');

//svgs
final kLanguageSvg = _getSvgBasePath('language.svg');

//jsons
//country
final kCountriesJson = _getJsonBasePath('countries.json');
final kCar1 = _getJsonBasePath('car_1.json');
final kCar2 = _getJsonBasePath('car_2.json');
final kCar3 = _getJsonBasePath('car_3.json');

//network image
final kErrorUrl = _getNetworkImageBasePath('error.png');

//svg function here...
String _getSvgBasePath(String name) {
  return baseSVGPath + name;
}

//image function here...
String _getImageBasePath(String name) {
  return baseImagePath + name;
}

//json function here...
String _getJsonBasePath(String name) {
  return baseJsonPath + name;
}

String _getNetworkImageBasePath(String name) {
  return baseNetworkPath + name;
}

String _getModelBasePath(String name) {
  return baseModelPath + name;
}
