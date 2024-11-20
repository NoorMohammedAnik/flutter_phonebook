
class API {


  //for local testing using xampp
  static const mainUrl = "http://192.168.26.120/phonebook";
  //To get ip address go to cmd and run ipconfig command and copy ipv4 address

  //main api url for live server
  //static const mainUrl = "https://demo.onlinesoftsell.com/phonebook";

  //user signup api url
  static const userSignup="$mainUrl/signup.php";

  //user login api url
  static const userLogin="$mainUrl/login.php";

  //get contacts data from api url
  static const getContact="$mainUrl/get_contact.php";

  //save contact data api url
  static const addContact="$mainUrl/add_contact.php";

  //update contact data api url
  static const updateContact="$mainUrl/update_contact.php";

  //delete contact data api url
  static const deleteContact="$mainUrl/delete_contact.php";



}