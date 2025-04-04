class Constants {
  // app info
  static final String APP_VERSION = "0.0.5";
  static final String APP_NAME = "Formula ticket";

  // addresses
  static final String ADDRESS_STORE_SERVER = "192.168.1.4:8091";
  static final String ADDRESS_AUTHENTICATION_SERVER = "192.168.1.4:8080";

  // authentication
  static final String REALM = "FormulaTicket";
  static final String CLIENT_ID = "springboot-keycloak";
  static final String CLIENT_SECRET = "yJs8i1xy9MZqL60tRgmsalQtfsAn6Vxd";
  static final String REQUEST_LOGIN = "/auth/realms/" + REALM + "/protocol/openid-connect/token";
  static final String REQUEST_LOGOUT = "/auth/realms/" + REALM + "/protocol/openid-connect/logout";

  // requests
  static final String REQUEST_SEARCH_TICKETS = "/tickets/search/by_all";
  static final String REQUEST_ALL_GRANDPRIX = "/grandprix/paged";
  static final String REQUEST_SEARCH_GRANDPRIX="/grandprix/search/by_grandPrix_name";
  static final String REQUEST_ADD_USER = "/users/create";
  static final String REQUEST_ADD_PURCHASE="/purchases/create";
  static final String REQUEST_PURCHASES="/purchases/getPurchases";
  static final String REQUEST_GET_USER="/users/getUser";

  // states
  static final String STATE_CLUB = "club";

  // responses
  static final String RESPONSE_ERROR_MAIL_USER_ALREADY_EXISTS = "ERROR_MAIL_USER_ALREADY_EXISTS";
  static final String RESPONSE_ERROR_QUANTITY_UNAVAILABLE="Product quantity unavailable!";
  static String ERROR_SAME_EMAIL="INTERNAL_ERROR: MORE THAN ON USER FIND WITH THE SAME EMAIL";

  // messages
  static final String MESSAGE_CONNECTION_ERROR = "connection_error";


  //util
  static final int MIN_DESCR_SIZE=60;













}