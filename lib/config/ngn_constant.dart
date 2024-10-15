const String serverURL = 'http://dev-api-giaoviec.ngn.com.vn';

const String loginAPI = '$serverURL/website/login';
const String getColorAPI = '$serverURL/website/event-calendar/get-colors';
const String getTypeAPI = '$serverURL/website/event-calendar/get-types';
const String getUserOrganizationAPI =
    '$serverURL/website/user-organization/search?keyword=a';

const String getListOfPersonalAPI =
    '$serverURL/website/event-calendar/list-of-personal';

const String getListSubOrganizationAPI = '$serverURL/website/organization';

const String getListRootOrganizationAPI =
    '$serverURL/website/organization/list-root-organizations';

const int statusOk = 200;
const int statusCreated = 201;
const int statusAccepted = 202;
const int statusBadRequest = 400;
const int statusNotAuthorized = 403;
const int statusNotfound = 404;
const int statusInternalError = 500;
