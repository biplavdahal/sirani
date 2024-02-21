// All API endpoints are stored here
import 'package:mysirani/config.dart';

const auHostUrl = cnHostUrl;
const auBaseUrl = "$auHostUrl/api/web/v1/";
const auImageBaseUrl = "$auHostUrl/public/images/";
const auHerokuUrl = "https://call-mysirani.herokuapp.com/";

// SECTION:: - Authentication

/// @method POST

/// * @param {string} username
/// * @param {string} password
const auSignIn = "user/login";

/// @method POST
/// * @body {string} username
/// * @body {string} password
/// * @body {string} email
/// * @body {string} address
/// * @body {string} mobile
/// * @body {string} full_name
const auSignUp = "user/signup";

/// @method POST
/// * @body {string} username
/// * @body {string} email
/// * @query {string} type
/// * @query {string} id
/// * @query {string} name
/// * @query {string} email
const auSocialSignIn = "user/social-login";

/// @method POST
/// * @query {string} email
const auRequestResetPassword = "user/request-password-reset";

/// @method POST
/// * @query {string} access_token
const auSignOut = "user/logout";

// SECTION:: - User

/// @method GET
/// * @query {string} access_token
const auGetUserFeeling = "user/feeling";

/// @method POST
/// * @query {string} access_token
/// * @body {string} feeling
const auUpdateUserFeeling = "user/feelingpost";

/// @method POST
/// * @body {string} access_token
/// * @body {string} full_name
/// * @body {string} email
/// * @body {string} address
/// * @body {string} mobile
/// * @body {string} type
/// * @body {string} language
/// * @body {string} skills
/// * @body {string} education
/// * @body {string} experience
/// * @body {string} summary
/// * @body {string} details
/// * @body (string) image -> This must be base64 image
const auUpdateProfile = "user/edit";

/// @method GET
/// * @query {string} access_token
const auUserProfile = "user/profile";

/// @method GET
/// * @query {string} access_token
const auGetUserFreeSessions = "counselor/freesession";

/// @method POST
/// * @query {string} access_token
/// * @body {string} user_id
/// * @body {string} password
/// * @body {string} password_repeat
const auChangePassword = "user/change-password";

/// @method GET
/// * @query {string} access_token
/// * @query {int} page
/// * @query {int} limit
const auAvailablePackages = "my-package/index";

/// @method GET
/// * @query {string} access_token
const auChatPlans = "chat-plan/index";

/// @method POST
/// * @query {string} access_token
/// * @body {string} chat_plan_id
const auBuyChatPlan = "chat-plan/buy";

/// @method GET
/// * @query {string} access_token
const auFreeSessionThreads = 'message/contaclist';

/// @method GET
/// * @query {string} access_token
/// * @query {int} sender_id -> Current loggedin user
/// * @query {int} receiver_id
const auMessages = 'message/index';

/// @method POST
/// * @body {string} access_token
/// * @body {int} receiver_id
/// * @body {string} message
const auSendMessage = 'message/post';

// SECTION:: - Forum

/// @method GET
/// * @query {string} access_token
/// * @query {string} (page)
/// * @query {int} (limit)
/// * @query {string} (post_by) -> Us
const auForumThreads = "forum/index";

/// @method POST
/// * @body {string} access_token
/// * @body {string} forum_id
const auForumLikeToggle = "forum/like";

/// @method GET
/// * @query {string} access_token
/// * @query {string} forum_id
/// * @query {string} (page)
/// * @query {int} (limit)
const auForumCommentThreads = "forum-comment/index";

/// @method POST
/// * @body {string} access_token
/// * @body {string} forum_id
/// * @body {string} comments
const auForumCommentAdd = "forum-comment/add";

/// @method POST
/// * @body {string} access_token
/// * @body {string} id -> forum_comment_id
const auForumCommentRemove = "forum-comment/remove";

/// @method POST
/// * @body {string} access_token
/// * @body {string} forum_comment_id
/// * @body {string} review_by -> auth!.user_id
const auForumCommentLikeToggle = "forum-comment/review";

/// @method POST
/// * @body {string} access_token
/// * @body {string} forum_id
const auForumThreadDelete = "forum/remove";

/// @method POST
/// * @body {string} access_token
/// * @body {string} description
/// * @body {string} title -> ""
/// * @body {string} forum_category_id -> 0
/// * @body {string} status -> "Active"
/// * @body {string} tags -> ""
/// * @body {int} anonymous -> 0/1
const auForumThreadAdd = "forum/add";

/// @method POST
/// * @body {string} access_token
/// * @body {string} description
/// * @body {string} title -> ""
/// * @body {string} forum_category_id -> 0
/// * @body {string} status -> "Active"
/// * @body {string} tags -> ""
/// * @body {int} anonymous -> 0/1
/// * @body {string} forum_id
const auForumThreadEdit = "forum/edit";

/// @method POST
/// * @body {string} access_token
/// * @body {string} forum_id
/// * @body {string} details
const auForumThreadReport = "forum/report-post";

/// @method POST
/// * @body {string} access_token
/// * @body {string} forum_id
/// * @body {string} details
const auForumThreadIssue = "forum/issue";

/// SECTION:: - Counsellor

/// @method GET
/// * @query {string} access_token
/// * @query {string} role -> "counselor", "buddies", "volunteer_counselor"
const auCounsellorList = "counselor/index";

/// @method POST
/// * @query {string} access_token
/// * @query {int} counselor_id
const auCounsellorProfile = "counselor/profile";

/// @method POST
/// * @body {string} access_token
/// * @body {int} counselor_id
const auCounsellorLike = "counselor/like";

/// @method POST
/// * @body {string} access_token
/// * @body {int} counselor_id
/// * @body {string} review
/// * @body {string} ratting
/// * @body {string} name
/// * @body {string} email
const auCounsellorRating = "counselor/review";

/// @method POST
/// * @body {string} access_token
/// * @body {string} days -> Weekday
/// * @body {string} from_time
/// * @body {string} to_time
/// * @body {string} status
const auCounsellorScheduleAdd = "counselor/addschedule";

/// @method POST
/// * @body {string} access_token
/// * @body {string} id -> schedule_id
const auCounsellorScheduleRemove = "counselor/removeschedule";

/// @method POST
/// * @body {string} access_token
/// * @body {string} id -> schedule_id
/// * @body {string} days -> Weekday
/// * @body {string} from_time
/// * @body {string} to_time
/// * @body {string} status
const auCounsellorScheduleEdit = "counselor/editschedule";

/// @method POST
/// * @body {string} access_token
const auCounsellorChatList = "counselor/chatlist";

/// SECTION:: - Wallet

/// @method GET
/// * @query {string} access_token
/// * @query {int} (page)
/// * @query {int} (limit)
const auGetStatement = "statement/index";

/// @method POST
/// * @body {string} access_token
/// * @body {string} amount
/// * @body {string} source
const auLoadBalance = "chat-plan/loadfund";

// SECTION:: - Resources

/// method @GET
/// * @query {string} access_token
/// * @query {int} (page)
/// * @query {int} (limit)
const auGetBlogs = "blogs/index";

/// method @GET
/// * @query {string} access_token
/// * @query {int} (page)
/// * @query {int} (limit)
const auGetVideos = "blogs/video";

// SECTION:: - Appointment

/// @method GET
/// * @query {string} access_token
const auGetAppointments = "counselor/user-appointment";

/// @method GET
/// * @query {string} access_token
/// * @query {int} user_id
const auGetSurveyAnswer = "survey/user-answer";

/// * @method GET
/// * @query {string} access_token
const auGetSurveyQuestions = "survey/get-questions";

/// @method POST
/// * @body {string} access_token
/// * @body (int) id -> 0
/// * @body {string} image
const auUploadSurveyDocument = "survey/upload";

/// @method POST
/// * @body {string} access_token
/// * @body {int} counselor_id
/// * @body {string} date
/// * @body {string} time
/// * @body {string} details
/// * @body {string} type
const auAddAppointment = "counselor/appointment";

/// @method POST
/// * @body {string} access_token
/// * @body {int} id -> Appointment ID
/// * @body {string} status -> "Approved", "Declined", "Canceled"
const auAppointmentAction = "counselor/appointmentapprove";

/// @method POST
/// * @body {string} access_token
/// * @body {json} question
/// * @body {string} question.user_answer
/// * @body {int} question.question_id
/// * @body {string} question.question_title
const auSaveSurvey = "survey/post-survey";

// SECTION:: - Page

/// @method GET
/// * @query {string} access_token
/// * @query {string} slug
const auPage = "page/index";

// SECTION:: - Notification

/// @method POST
/// * @body {string} access_token
/// * @body {string} type -> "android", "ios"
/// * @body {string} token -> FCM Token
/// * @body {int} user_id
const auFCMNotificationPost = "token/post";

// SECTION:: - Programs

/// @method GET
/// * @query {string} access_token
/// * @query {int} page
/// * @query {int} limit
const auPrograms = "program/index";

// SECTION:: - Call

/// @method GET
/// * @query {string} channel -> channel name should be the username of user who initiated the call
/// * @query {string} uid -> 0
const auCallToken = "access_token";

/// @method POST
/// * @body {string} access_token
/// * @body {string} channel -> channel name should be the username of user who initiated the call
/// * @body {string} token -> Agora token
/// * @body {string} user_id -> The userid of the user2 whom the user1 is calling
const auSendCallNotification = "token/call-start";

/// @method POST
/// * body {string} access_token
/// * body {id} id -> caller_id from notification or user id of counsellor
/// * body {string} end_time -> new end time for the session in hh:mm:ss format (24 hr format)
const auSessionExtend = "token/session-extend";

/// @method POST
/// * body {string} access_token
/// * body {id} id -> caller_id from notification or user id of counsellor
const auSessionEndTime = "token/session-end";
