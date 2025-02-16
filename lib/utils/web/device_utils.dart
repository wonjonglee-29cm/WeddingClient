import 'package:universal_html/html.dart' as html;

String getPlatformInWeb() {
  final userAgent = html.window.navigator.userAgent.toLowerCase();

  if (userAgent.contains('android')) {
    return 'Android';
  } else if (userAgent.contains('iphone') || userAgent.contains('ipad') || userAgent.contains('ipod')) {
    return 'iOS';
  } else if (userAgent.contains('windows')) {
    return 'Windows';
  } else if (userAgent.contains('macintosh') || userAgent.contains('mac os x')) {
    return 'macOS';
  } else if (userAgent.contains('linux')) {
    return 'Linux';
  }

  return 'Unknown';
}

void launchAppStoreInWeb(String platform) {
  if (platform == 'Android') {
    html.window.location.href = 'market://details?id=ming.jong.wedding';
  } else if (platform == 'iOS') {
    html.window.location.href = 'https://apps.apple.com/app/id6741857330';
  }
}