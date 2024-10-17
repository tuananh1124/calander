const String serverURL = 'http://dev-api-giaoviec.ngn.com.vn';

const String loginAPI = '$serverURL/website/login';
const String getColorAPI = '$serverURL/website/event-calendar/get-colors';
const String getTypeAPI = '$serverURL/website/event-calendar/get-types';

const String getUserOrganizationAPI =
    '$serverURL/website/user-organization/search?keyword=&scope=user';

// const String getListOfPersonalAPI = '$serverURL/website/event-calendar/list-of-personal';

const String getListEveneCalendarAPI =
    '$serverURL/website/event-calendar?organizationId=605b064ad9b8222a8db47eb8'; // theo id VĂN PHÒNG TRUNG ƯƠNG ĐẢNG

const String getListSubSearchOrganizationAPI =
    '$serverURL/website/organization/605b064ad9b8222a8db47eb8/list-sub-organizations'; // theo id VĂN PHÒNG TRUNG ƯƠNG ĐẢNG

const String getListRootOrganizationAPI =
    '$serverURL/website/organization/list-root-organizations?childLevel=10';

const int statusOk = 200;
const int statusCreated = 201;
const int statusAccepted = 202;
const int statusBadRequest = 400;
const int statusNotAuthorized = 403;
const int statusNotfound = 404;
const int statusInternalError = 500;
