const AUTH_BASE_URL = 'https://hestia-auth.herokuapp.com/api/user';

// const BASE_URL = 'https://akina-auth.herokuapp.com/api/user';
const BASE_URL = 'https://akina.ayushpriya.tech/api/user';

const URL_USER_LOGIN = '$BASE_URL/login';
const URL_USER_REGISTER = '$BASE_URL/registerapp';
const URL_USER_UPDATE = '$BASE_URL/updateUser';
const URL_GET_DETAILS = '$BASE_URL/getuserdetail';
const URL_USER_VERIFY = '$BASE_URL/verifyuser';
const URL_RESET_PASSWORD = '$BASE_URL/forgotPassword';
const URL_UPDATE_USER = '$BASE_URL/updateUser';
const URL_RESEND_VERIFICATION = '$BASE_URL/resendverify';

// const REQUEST_BASE_URL = 'hestia-requests.herokuapp.com';
const REQUEST_BASE_URL = 'akina.ayushpriya.tech';

const URL_NEW_ITEM_REQUEST = 'api/requests/item_requests/';
const URL_VIEW_ALL_ITEM_REQUESTS = 'api/requests/view_all_item_requests/';
const URL_ACCEPT_REQUEST = 'https://$REQUEST_BASE_URL/api/requests/accept/';
const URL_VIEW_MY_REQUESTS = 'api/requests/my_requests/';
const URL_VIEW_ORGS = 'api/requests/user_organization_view/';

const URL_REGISTER_DEVICE = 'https://$REQUEST_BASE_URL/api/notification/register_device/';


// const ITEM_REQUEST_BASE_URL = 'hestia-requests.herokuapp.com';
// const URL_NEW_REQUEST = 'api/requests/item_requests/';
// const URL_VIEW_ALL_REQUESTS = 'api/requests/view_all_item_requests/';

const URL_GET_ID = 'https://$REQUEST_BASE_URL/api/user/getuserdetail';

// const REPORT_BASE_URL = 'https://hestia-report-do.herokuapp.com';
const REPORT_BASE_URL = 'https://akina.ayushpriya.tech';

const URL_SHOW_CREATE_SUGGESTIONS = '$REPORT_BASE_URL/api/recommend/';
const URL_REPORT_A_PERSON = '$REPORT_BASE_URL/api/report/';
const URL_CHECK_REPORT_STATUS = '$REPORT_BASE_URL/api/report/check/';
// const SHOP_BASE_URL = 'https://hestia-report.herokuapp.com';
//const SHOP_BASE_URL = 'akina.ayushpriya.tech';

const NEWS_BASE_URL = 'http://hestia-info.herokuapp.com';
const URL_NEWS = "http://hestia-info.herokuapp.com/node";
const URL_WORLD_STATISTICS = '$NEWS_BASE_URL/stats';

//const CHAT_BASE_URL = 'https://hestia-chat.herokuapp.com';
const CHAT_BASE_URL = 'https://akina.ayushpriya.tech';

const URL_GET_MY_CHATS = '$CHAT_BASE_URL/api/v1/getMyChats';
const URL_GET_OTHER_CHATS = '$CHAT_BASE_URL/api/v1/getOtherChats';
const URL_CREATE_MESSAGE = '$CHAT_BASE_URL/api/v1/sendMessage';
const URL_CREATE_CHAT = '$CHAT_BASE_URL/api/v1/createChat';
const URL_GET_MESSAGES = '$CHAT_BASE_URL/api/v1/getMessages';
const URL_DELETE_CHAT = '$CHAT_BASE_URL/api/v1/delChat';
const URL_UPDATE_CHAT = '$CHAT_BASE_URL/api/v1/updateChat' ;
const URL_ADD_ITEM = '$CHAT_BASE_URL/api/v1/addItem';
