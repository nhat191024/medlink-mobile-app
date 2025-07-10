class Apis {
  static const int timeOut = 10;
  static const appEnv = 'host';
  static const String serverAddress = 'http://113.186.124.48:33003';
  static const String api = appEnv == 'local'
      ? 'http://192.168.1.4:8000/api/'
      : 'https://medlink.taiyo.space/api/';
}
