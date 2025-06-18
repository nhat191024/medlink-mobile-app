class Apis {
  static const int timeOut = 10;
  static const appEnv = 'local';
  static const String serverAddress = 'http://113.186.124.48:33003';
  static const String api = appEnv == 'local'
      ? 'https://medlink.test/api/'
      : 'https://medlink.taiyo.space/api/';
}
