class ApiEndPoints {
  static const String login = "agrinet/security/user/login";
  static const String refreshToken = 'agrinet/security/user/refresh/token';

  static const String homeImage = "mobile/image-slides";
  static const String farmerOnBoard = "farmer/farmer-on-board";
  static const String farmerOnBoardSearch = "farmer/farmer-on-board-search";
  static const String farmerOnBoardList = "farmer/farmer-on-board-list";
  static const String farmerOnBoardDocUpload =
      "farmer/farmer-on-board-doc-upload";
  static const String groupFarmerList = "farming-plan/group-farmer-list";
  static const String performance = "pal/pal-dashboard";
  static const String getServiceRequest = "farmer/get-service-request";
  static const String serviceRequest = "farmer/service_request";
  static const String serviceRequestSearch = "farmer/service_request_search";
  static const String serviceRequestDocUpload =
      "farmer/service_request_doc_upload";
  static const String farmerGroupList = "farmer/farmer-group-search";
  static const String farmerList = "farmer/farmer-list";
  static const String createFarmerGroup = "farmer/farmer-group";
  static const String saveFarmingPlan = "farming-plan/farming-plan-save";
  static const String advertiseHistory = "market/pal/advertise-history";
  static const String acceptBidPlan = "market/pal/accept-bid-plan";
  static const String rejectBidPlan = "market/pal/reject-bid-plan";
  static const String individualAdvertiseHistory =
      "market/pal/one-advertise-history";
  static const String bitChat = "mobile/chat-det";
  static const String bitChatSave = "mobile/chat-det-save";
  static const String plantProtection = "mobile/plant-protection";
  static const String farmPlanList = "market/pal/farmplan";
  static const String planDetails = "market/pal/cropname";
  static const String farmingPlanProfitability =
      "farming-plan/farming-plan-profitabilty";
  static const String advertiseAds = 'market/pal/advertise';
  static const String uploadAdvertiseDocuments =
      'market/pal/advertise-doc-upload';
  static const String farmPlan = "farming-plan/group-farmer-list";
  static const String deleteLandDetails = "farming-plan/delete-land-detail";
  static const String shgGroupList = "farming-plan/group-farmer-list";
  static const String saveGroupFarm = "farming-plan/save-land-detail";
  static const String soilAssessment = "farming-plan/group-farmer-list";
  static const String factors = "farming-plan/farming-plan-save";
  static const String reschedule = "farming-plan/reschedule-eventdate";
  static const String serviceList = "farmer/service-request-list";
  static const String serviceDetail = "farmer/one-service-request-list";
  static const String updatePalProfile = "mobile/pal-profile-update";
  static const String buyerAdvertiseHistory = "market/advertise-history";
  static const String buyerIndividualAdsHistory =
      "market/one-advertise-history";
  static const String buyerBidHistory = "market/bid-plan-history";
  static const String buyerIndividualBidHistory = "market/one-bid-history";
  static const String buyerPlaceBid = "market/bid-plan";
  static const String buyerCancelBid = "market/cancel-bid";
  static const String buyerDemandList = "market/pal/buyer-commodity-list";
  static const String buyerCreateDemand = "market/pal/save-buyer-commodity";
  static const String getStateCommodities = "market/pal/get-states-commodities";
  static const String getCommoditiesPrice = "market/pal/commodity-prices";
  static const String getPlanSummary = "farming-plan/farming-plan-summary";
  static const String userRegistration = "buyer/buyer-registration";
  static const String getRegistrationOtp = "buyer/get-otp";
  static const String purchaseBaseUrl = 'channel/JAM/customer/shop';
  static const String purchaseHome = '$purchaseBaseUrl/home';
  static const String purchaseCategoryView = '$purchaseBaseUrl/category-view';
  static const String categoryProductView = '$purchaseBaseUrl/product-view';
  static const String palCreation = "buyer/home-branch-list";
  static const String palSignUp = "buyer/master-pal-registration";
  static const String demandList = "market/pal/buyer-commodity-list-to-pal";
  static const String aboutus = "mobile/about-us";
  static const String addWishList = "$purchaseBaseUrl/account/add-wishlist";
  static const String removeWishList =
      "$purchaseBaseUrl/account/remove-wishlist";
  static const String crossSaleProds = '$purchaseBaseUrl/cross-sale-prds';
  static const String upSaleProds = '$purchaseBaseUrl/up-sale-prds';
  static const String buyNowPrds = '$purchaseBaseUrl/account/buy-now';
}
