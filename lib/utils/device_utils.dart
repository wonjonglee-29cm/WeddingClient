import "dart:html" as html;

String getPlatform() {
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