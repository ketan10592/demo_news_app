
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'home_page_provider/home_page_provider.dart';

final homePageProvider = ChangeNotifierProvider.autoDispose((ref) => HomePageProvider(ref));