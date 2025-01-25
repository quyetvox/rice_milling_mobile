enum Env { DEV, PROD }

class AppConfig {
  static const appName = 'Rice Milling';
  static const appIcon = 'assets/app_icons/app_icon_main.png';
  static const organizationName = 'Rice Milling';

  static const env = Env.DEV;
  static const DOMAIN_DEV = "http://192.168.1.4:8080";
  static const DOMAIN_PRO = "https://localhost:";
  static const API_ENDPATH = "/api/v1";
  static const RAW_BASE_URL = env == Env.DEV ? DOMAIN_DEV : DOMAIN_PRO;
  static const BASE_URL = RAW_BASE_URL + API_ENDPATH;
}
