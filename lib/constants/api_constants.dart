class ApiConstants{

 /* appCredentials
  email-teacher@yopmail.com
  password-12345678*/

  static const String baseUrl =
    //  "http://47.106.99.86:8081/admin/";
  "https://m.vanasy.cn:8080/admin/";

  static const login = "login";
  static const addStudent = "addstudent";
  static const getStudentsData = "getstudents";
  static const editStudent = "editstudent";
  static const changePassword = "changestudentpass";
  static const addScores = "addscores";
  static const addScorePose30 = "addingScore";
  static const getScores = "getscores";
  static const updateScores = "updatescore";
  static const chartData = "chartdata";
  static const uploadVideo = "uploadvideo";
  static const deleteStudent = "deletestudent/";
  static const aiPoseCompare = "https://ml.vanasy.cn/pose_compare";
  static const aiPoseCompareId30 = "https://ml.vanasy.cn/pose_compare_action30";
}
class ApiConstantsStudentSide{
  static const String baseUrlStudentSide = 'https://m.vanasy.cn:8080/';
  static const String getStudentScore = 'users/getscores/';
  static const String uploadVideoStudent = "admin/uploadvideo";
  static const  String aiPoseCompare = "https://ml.vanasy.cn/pose_compare";
  static const String addScore = 'users/addscore';
  static const String chartData = 'users/studentchartdata';
  static const String lastScore ='users/lastscores/';

}