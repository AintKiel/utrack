class UTexts {
  // -- LogIn Heading Text
  static const String loginTitle = "Welcome back";
  static const String loginSubTitle = "Smart Borrowing, Simple Tracking.";
  static const String signupTitle= "Let's  create your account";
  static const String forgetPasswordTitle= "Forget Password";
  static const String changeYourPasswordTitle = "Password Reset Email Sent";
  static const String confirmEmail= "Verify your email contacts!";
  static const String confirmEmailSentCode = "We sent a code to";
  static const String emailNotReceiveCode = "Didn't get the code? ";
  static const String verifyID = "Verify your identity! ";
  static const String yourAccountCreatedTitle = "Your account successfully created.";
  static const String submit = "Submit";
  static const String savePass = "Save Password";
  static const String enterNewPass = "Enter a new password!";
  static const String accountCreated ="Account Created Successfully!";
  static const String passwordUpdated ="Password Updated Successfully!";
  static const String changePasswordTitle= "Change Password";

  //subtitles
  static const String createdSuccessfullySub ="All set! You can now login to your account";
  static const String enterNewPassSubTitle = "Create a fresh password to get back on track.";
  static const String yourAccountCreatedSubTitle = "Welcome to Your Trusted Lending Companion: Your Account is Created, Discover Hassle-Free Debt Tracking.";
  static const String verifyIDsubtitle = "Congratulations, your email has now been verified. Please submit your valid ID to complete verification process.";
  static const String changeYourPasswordSubTitle= "Your Account Security is Our Priority! We've Sent You a Secure Link to Safely Change Your Password and Keep Your Account Protected.";
  static const String forgetPasswordSubtitle = "Don't worry sometimes people can forget too, enter your email to verify your identity.";
  static const String changePasswordSubtitle = "Change your password anytime to help protect your account, enter your email to verify your identity.";

  // -- SignUp Form texts
  static const String firstName = "First Name";
  static const String lastName = "Last Name";
  static const String email = "Email";
  static const String password = "Password";
  static const String newPassword = "New Password";
  static const String confirmPassword = "Confirm Password";
  static const String username= "Username";
  static const String phoneNo= "Phone Number";
  static const String address= "Address";
  static const String rememberMe= "Remember Me";
  static const String forgetPassword = "Forget Password?";
  static const String signIn = "Sign In";
  static const String createAccount = "Create Account";
  static const String orSignInWith = "or sign in with";
  static const String orSignUpWith = "or sign up with";
  static const String iAgreeto = "I agree to";
  static const String privacyPolicy = "Privacy Policy";
  static const String termsOfUse = "Terms of Use";
  static const String verificationCode = "verification code";
  static const String resendEmail= "Resend Email";
  static const String resendEmailIn = "Resend Email in";

  // -- AppBar
  static const String utrack = "UTrack";
  static const String utrackSubTitle = "Your trusted utang tracker";

  // -- Home Page
  static const String personalAccount = "Personal Account";
  static const String storeAccount = "Store Account";
  static const String welcome = "Welcome,";
  static const String avatar = "JDC";
  static const String myQr = "My QR";
  static const String scan = "Scan";
  static const String totalLent = "Total Lent";
  static const String totalOwed = "Total Owed";
  static const String borrower = " Borrower/s";
  static const String lender = " Lender/s";
  static const String sumBorrower = "10";
  static const String sumLender = "2";
  static const String totalLend = "15,500";
  static const String totalBorrowed = "3,500";
  static const String financialHealth = "Financial Health";
  static const String creditScore = "Credit Score";
  static const String paymentHistory = "Payment History";
  static const String trustRating = "Trust Rating";
  static const String viewDetails = "View Details";
  static const String viewRequest = "View Request";
  static const String remind = "Remind";

  ///alert messages
  static const String youHave= "You have";
  static const String total= "1,000php";
  static const String youHavecon= " overdue\npayment";
  static const String overdue = "Overdue Payment";
  static const String paynow = "Pay Now";

  static const String dueSubtitle= "Pay before due for good\nrating!";
  static const String dueAlert = "DueAlert";

  static const String noteSubtitle= "Ratings in good condition";
  static const String goodConditon = "Keep it up!";

  /// ------- Notifications ---------
  static const String notif = "Notifications";
  static const String notifSubTitle =
      "Stay updated on your lending and borrowing activities.";

// Payment Related
  static const String overduePaymentTitle = "Overdue Payment Alert";
  static const String overduePaymentBody =
      "Your payment for {loanTitle} is now overdue. Please settle it soon to avoid credit score deductions.";

  static const String paymentReminderTitle = "Payment Reminder";
  static const String paymentReminderBody =
      "Your payment for {loanTitle} is due in 2 days. Pay on time to maintain your good credit standing.";

  static const String paymentReceivedTitle = "Repayment Received";
  static const String paymentReceivedBody =
      "{borrowerName} has sent a repayment of {amount}. Check your transaction details for confirmation.";

  static const String paymentSentTitle = "Repayment Sent";
  static const String paymentSentBody =
      "You successfully sent a repayment of {amount} to {lenderName}. Thank you for paying on time!";

  static const String upcomingPaymentTitle = "Upcoming Payment Due";
  static const String upcomingPaymentBody =
      "You have an upcoming due date for {loanTitle}. Stay on track and avoid overdue penalties!";

// Credit Score Related
  static const String creditScoreIncreaseTitle = "Credit Score Increased 🎉";
  static const String creditScoreIncreaseBody =
      "Great job! Your credit score increased by {percentage}% due to consistent and timely payments.";

  static const String creditScoreDecreaseTitle = "Credit Score Decreased ⚠️";
  static const String creditScoreDecreaseBody =
      "Your credit score dropped by {percentage}% due to missed or overdue payments. Try to settle soon to recover points.";

// Borrowing / Lending
  static const String newBorrowRequestTitle = "New Borrow Request";
  static const String newBorrowRequestBody =
      "{borrowerName} wants to borrow {amount} from you. Review and respond to their request.";

  static const String requestApprovedTitle = "Request Approved ✅";
  static const String requestApprovedBody =
      "Good news! Your lending request to {lenderName} has been approved.";

  static const String requestRejectedTitle = "Request Declined";
  static const String requestRejectedBody =
      "Unfortunately, your lending request to {lenderName} was declined.";

  static const String loanFullyRepaidTitle = "Loan Fully Repaid 🎯";
  static const String loanFullyRepaidBody =
      "Your borrower, {borrowerName}, has fully repaid their utang. Great job on completing the transaction!";

  static const String loanDueSoonTitle = "Loan Due Soon ⏰";
  static const String loanDueSoonBody =
      "Reminder: {borrowerName}’s repayment is due tomorrow. Make sure to confirm once payment is received.";

// Interest Related
  static const String interestAddedTitle = "Interest Added ⚠️";
  static const String interestAddedBody =
      "An additional {interestPercent}% interest has been applied due to 1 month overdue.";

  // Empty Notif
  static const String noNotifTitle = "No Recent Notifications";
  static const String noNotifBody = "You don’t have any new updates right now. Check back later for lending or borrowing activity.";


  ///qr code texts
  static const String qrCode = "QR Code";
  static const String nameExample = "Juan Dela Cruz";
  static const String addressExample = "Brgy. Maligaya, Quezon City";
  static const String phoneExample = "+63 917 4567";
  static const String creditScoreEx = ": 85%";
  static const String userID = "User ID: ";
  static const String userIDex = "user123";
  static const String qrUse = "📌 You can show this QR code to your lender or borrower to share your credit activityTransaction quickly and securely.";
  static const String download = "Download";
  static const String share = "Share";

  ///scan qr texts
  static const String requestUtang = "Request Utang";
  static const String typeUserid = "Input User ID";
  static const String amount = "Amount";
  static const String enterAmount = "Enter Amount";
  static const String singleRepay = "Single Repayment";

  ///credit score dashboard
  static const String creditSubTitle = "This is your borrowing reputation\nin the community";
  static const String creditTitle1 = "Repayment Behavior";
  static const String creditTitle2 = "Outstanding Debts";
  static const String creditTitle3 = "Borrowing Frequency";
  static const String creditSubTitle1 = "On-time and early payments\nimprove your score.";
  static const String creditSubTitle2 = "Lower debt amounts increase\nyour score.";
  static const String creditSubTitle3 = "Moderate borrowing is ideal";
  static const String creditTipTitle = "Tips how to improve credit score: ";
  static const String creditTip1 = "Pay on time or early to avoid daily −0.3%\ndeductions and earn +0.3% bonuses.";
  static const String creditTip2 = "Repay missed dues quickly to prevent\nfurther score and interest penalties.";
  static const String creditTip3 = "Borrow responsibly — only take amounts\nyou can manage within your repayment period.";
  static const String creditTip4 = "Maintain good lender relationships to\nbuild trust and credit reliability.";
  static const String creditTip5 = "Monitor your debts and due dates regularly\nusing UTrack to stay consistent.";

  ///lending text
  static const String noDebtors = "No debtor records yet.\nStart adding one to track lending.";
}