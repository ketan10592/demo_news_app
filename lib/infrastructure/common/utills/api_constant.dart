class ApiConstant{
  static const String baseUrl = 'https://newsapi.org';
  static const String topHeadLines = '/v2/top-headlines';
  static const String everything = '/v2/everything';




  final Map<String,String> apiHeader ={'Content-Type':'application/json'};
}