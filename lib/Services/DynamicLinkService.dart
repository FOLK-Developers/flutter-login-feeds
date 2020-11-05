import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';
import 'package:flutter/material.dart';
import 'package:folk/Services/Locator.dart';
import 'package:shared_preferences/shared_preferences.dart';

class NavigationService {
  GlobalKey<NavigatorState> _navigationKey = GlobalKey<NavigatorState>();
  GlobalKey<NavigatorState> get navigationKey => _navigationKey;
  void pop() {
    return _navigationKey.currentState.pop();
  }

  Future<dynamic> navigateTo(String routeName, {dynamic arguments}) {
    return _navigationKey.currentState
        .pushReplacementNamed(routeName, arguments: arguments);
  }
}

class DynamicLinkService {
  Future handleDynamicLinks() async {
    final PendingDynamicLinkData data =
        await FirebaseDynamicLinks.instance.getInitialLink();
    _handleDeepLink(data);
    FirebaseDynamicLinks.instance.onLink(
        onSuccess: (PendingDynamicLinkData dynamicLink) async {
      _handleDeepLink(dynamicLink);
    }, onError: (OnLinkErrorException e) async {
      print('Link Failed: ${e.message}');
    });
  }

  void _handleDeepLink(PendingDynamicLinkData data) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var check = prefs.getBool('Login');
    final Uri deepLink = data?.link;

    if (deepLink != null) {
      print('_handleDeepLink | deeplink: $deepLink');
      var isPost = deepLink.pathSegments.contains('post');
      if (isPost) {
        var title = deepLink.queryParameters['title'];
        if (title != null) {
          print(title);
          if (check == true)
            locator<NavigationService>().navigateTo('home', arguments: title);
        }
      }
    }
  }

  Future<String> createLink(String title) async {
    final DynamicLinkParameters parameters = DynamicLinkParameters(
      uriPrefix: 'https://folkapp.page.link',
      link: Uri.parse('https://www.folk_app.com/post?title=$title'),
      androidParameters: AndroidParameters(
        packageName: 'com.aikya.folk_app',
      ),
    );
    final Uri dynamicUrl = await parameters.buildUrl();
    return dynamicUrl.toString();
  }
}
