import 'package:citizenone_app/modules/agrinet/app/modules/publish_ads/bindings/publish_ads_binding.dart';
import 'package:get/get.dart';

import '../modules/AgriInput/bindings/agri_input_binding.dart';
import '../modules/AgriInput/views/agri_input_view.dart';
import '../modules/CropSuggestion/bindings/crop_suggestion_binding.dart';
import '../modules/CropSuggestion/views/crop_suggestion_view.dart';
import '../modules/EventDisplay/bindings/event_display_binding.dart';
import '../modules/EventDisplay/views/event_display_view.dart';
import '../modules/FactorsRisk/bindings/factors_risk_binding.dart';
import '../modules/FactorsRisk/views/factors_risk_view.dart';
import '../modules/FarmPlans/bindings/farm_plans_binding.dart';
import '../modules/FarmPlans/views/farm_plans_view.dart';
import '../modules/FarmingDashboard/bindings/farming_dashboard_binding.dart';
import '../modules/FarmingDashboard/views/farming_dashboard_view.dart';
import '../modules/FinanceRequest/bindings/finance_request_binding.dart';
import '../modules/FinanceRequest/views/finance_request_view.dart';
import '../modules/LandDetails/bindings/land_details_binding.dart';
import '../modules/LandDetails/views/land_details_view.dart';
import '../modules/LandFarmDetails/bindings/land_farm_details_binding.dart';
import '../modules/LandFarmDetails/views/land_farm_details_view.dart';
import '../modules/ServiceDetails/bindings/service_details_binding.dart';
import '../modules/ServiceDetails/views/service_details_view.dart';
import '../modules/ServiceRequest/bindings/service_request_binding.dart';
import '../modules/ServiceRequest/views/service_request_view.dart';
import '../modules/ShgDetails/bindings/shg_details_binding.dart';
import '../modules/ShgDetails/views/shg_details_view.dart';
import '../modules/SoilAssessment/bindings/soil_assessment_binding.dart';
import '../modules/SoilAssessment/views/soil_assessment_view.dart';
import '../modules/SoilMaps/bindings/soil_maps_binding.dart';
import '../modules/SoilMaps/views/soil_maps_view.dart';
import '../modules/YieldDetails/bindings/yield_details_binding.dart';
import '../modules/YieldDetails/views/yield_details_view.dart';
import '../modules/about_us/bindings/about_us_binding.dart';
import '../modules/about_us/views/about_us_view.dart';
import '../modules/add_dependent/bindings/add_dependent_binding.dart';
import '../modules/add_dependent/views/add_dependent_view.dart';
import '../modules/add_farmer/bindings/add_farmer_binding.dart';
import '../modules/add_farmer/views/add_farmer_view.dart';
import '../modules/add_farmer_group/bindings/add_farmer_group_binding.dart';
import '../modules/add_farmer_group/views/add_farmer_group_view.dart';
import '../modules/buyer_ads_demand/bindings/buyer_ads_demand_binding.dart';
import '../modules/buyer_ads_demand/views/buyer_ads_demand_view.dart';
import '../modules/buyer_ads_detail/bindings/buyer_ads_detail_binding.dart';
import '../modules/buyer_ads_detail/views/buyer_ads_detail_view.dart';
import '../modules/buyer_bid_view/bindings/buyer_bid_view_binding.dart';
import '../modules/buyer_bid_view/views/buyer_bid_view_view.dart';
import '../modules/buyer_demands/bindings/buyer_demands_binding.dart';
import '../modules/buyer_demands/views/buyer_demands_view.dart';
import '../modules/buyer_home/bindings/buyer_home_binding.dart';
import '../modules/buyer_home/views/buyer_home_view.dart';
import '../modules/buyer_my_bids/bindings/buyer_my_bids_binding.dart';
import '../modules/buyer_my_bids/views/buyer_my_bids_view.dart';
import '../modules/buyer_place_bid/bindings/buyer_place_bid_binding.dart';
import '../modules/buyer_place_bid/views/buyer_place_bid_view.dart';
import '../modules/chat/bindings/chat_binding.dart';
import '../modules/chat/views/chat_view.dart';
import '../modules/communication_details/bindings/communication_details_binding.dart';
import '../modules/communication_details/views/communication_details_view.dart';
import '../modules/contact_us/bindings/contact_us_binding.dart';
import '../modules/contact_us/views/contact_us_view.dart';
import '../modules/crop_insurance/bindings/crop_insurance_binding.dart';
import '../modules/crop_insurance/views/crop_insurance_view.dart';
import '../modules/crop_yield/bindings/crop_yield_binding.dart';
import '../modules/crop_yield/views/crop_yield_view.dart';
import '../modules/edit_profile/bindings/edit_profile_binding.dart';
import '../modules/edit_profile/views/edit_profile_view.dart';
import '../modules/farm_plan_list_view/bindings/farm_plan_list_binding.dart';
import '../modules/farm_plan_list_view/views/farm_plan_list_view.dart';
import '../modules/farmer_group/bindings/farmer_group_binding.dart';
import '../modules/farmer_group/views/farmer_group_list_view.dart';
import '../modules/farmer_list/bindings/farmer_list_binding.dart';
import '../modules/farmer_list/views/farmer_list_view.dart';
import '../modules/farmer_profile/bindings/farmer_profile_binding.dart';
import '../modules/farmer_profile/views/farmer_profile_view.dart';
import '../modules/fin_details/bindings/fin_details_binding.dart';
import '../modules/fin_details/views/fin_details_view.dart';
import '../modules/google_map/bindings/google_map_binding.dart';
import '../modules/google_map/views/google_map_view.dart';
import '../modules/home/bindings/home_binding.dart';
import '../modules/home/views/home_view.dart';
import '../modules/land_and_corp_details/bindings/land_and_corp_details_binding.dart';
import '../modules/land_and_corp_details/views/land_and_corp_details_view.dart';
import '../modules/login/bindings/login_binding.dart';
import '../modules/login/views/login_view.dart';
import '../modules/market_filter/bindings/market_filter_binding.dart';
import '../modules/market_filter/views/market_filter_view.dart';
import '../modules/market_price/bindings/market_price_binding.dart';
import '../modules/market_price/views/market_price_view.dart';
import '../modules/measure_land/bindings/measure_land_binding.dart';
import '../modules/measure_land/views/measure_land_view.dart';
import '../modules/my_profile/bindings/my_profile_binding.dart';
import '../modules/my_profile/views/my_profile_view.dart';
import '../modules/notification/bindings/notification_binding.dart';
import '../modules/notification/views/notification_view.dart';
import '../modules/otp/bindings/otp_binding.dart';
import '../modules/otp/views/otp_view.dart';
import '../modules/pal_creation/bindings/pal_creation_binding.dart';
import '../modules/pal_creation/views/pal_creation_view.dart';
import '../modules/payment_type/bindings/payment_type_binding.dart';
import '../modules/payment_type/views/payment_type_view.dart';
import '../modules/perfomance/bindings/perfomance_binding.dart';
import '../modules/perfomance/views/perfomance_view.dart';
import '../modules/plan/bindings/plan_binding.dart';
import '../modules/plan/views/plan_view.dart';
import '../modules/plan_summary/bindings/plan_summary_binding.dart';
import '../modules/plan_summary/views/plan_summary_view.dart';
import '../modules/plant_protection/bindings/plant_protection_binding.dart';
import '../modules/plant_protection/views/plant_protection_view.dart';
import '../modules/product_view/bindings/product_view_binding.dart';
import '../modules/product_view/views/products_view.dart';
import '../modules/profitability/bindings/profitability_binding.dart';
import '../modules/profitability/views/profitability_view.dart';
import '../modules/publish_ads/views/publish_ads_view.dart';
import '../modules/purchase/bindings/purchase_binding.dart';
import '../modules/purchase/views/purchase_view.dart';
import '../modules/registration/bindings/registration_binding.dart';
import '../modules/registration/views/registration_view.dart';
import '../modules/service_enquiry/bindings/service_enquiry_binding.dart';
import '../modules/service_enquiry/views/service_enquiry_view.dart';
import '../modules/sign_up_type/bindings/sign_up_type_binding.dart';
import '../modules/sign_up_type/views/sign_up_type_view.dart';
import '../modules/splash/bindings/splash_binding.dart';
import '../modules/splash/views/splash_view.dart';
import '../modules/success_info/bindings/success_info_binding.dart';
import '../modules/success_info/views/success_info_view.dart';
import '../modules/view_bids/bindings/view_bids_binding.dart';
import '../modules/view_bids/views/view_bids_view.dart';
import '../modules/weather/bindings/weather_binding.dart';
import '../modules/weather/views/weather_view.dart';
import '../modules/weather_graphs/bindings/weather_graphs_binding.dart';
import '../modules/weather_graphs/views/weather_graphs_view.dart';
import '../modules/weather_maps/bindings/weather_maps_binding.dart';
import '../modules/weather_maps/views/weather_maps_view.dart';

part 'app_routes.dart';

class AppPages {
  AppPages._();

  static const INITIAL = Routes.SPLASH;

  static final routes = [
    GetPage(
      name: _Paths.SPLASH,
      page: () => const SplashView(),
      binding: SplashBinding(),
    ),
    GetPage(
      name: _Paths.HOME,
      page: () => const HomeView(),
      binding: HomeBinding(),
    ),
    GetPage(
      name: _Paths.FARMER_LIST,
      page: () => const FarmerListView(),
      binding: FarmerListBinding(),
    ),
    GetPage(
      name: _Paths.PLAN,
      page: () => const PlanView(),
      binding: PlanBinding(),
    ),
    GetPage(
      name: _Paths.FARMER_GROUP,
      page: () => const FarmerGroupListView(),
      binding: FarmerGroupBinding(),
    ),
    GetPage(
      name: _Paths.ADD_FARMER_GROUP,
      page: () => const AddFarmerGroupView(),
      binding: AddFarmerGroupBinding(),
    ),
    GetPage(
      name: _Paths.ADD_FARMER,
      page: () => const AddFarmerView(),
      binding: AddFarmerBinding(),
    ),
    GetPage(
      name: _Paths.SUCCESS_INFO,
      page: () => const SuccessInfoView(),
      binding: SuccessInfoBinding(),
    ),
    GetPage(
      name: _Paths.ADD_DEPENDENT,
      page: () => const AddDependentView(),
      binding: AddDependentBinding(),
    ),
    GetPage(
      name: _Paths.LOGIN,
      page: () => const LoginView(),
      binding: LoginBinding(),
    ),
    GetPage(
      name: _Paths.PUBLISH_ADS,
      page: () => const PublishAdsView(),
      binding: PublishAdsBinding(),
    ),
    GetPage(
      name: _Paths.VIEW_BIDS,
      page: () => ViewBidsView(),
      binding: ViewBidsBinding(),
    ),
    GetPage(
      name: _Paths.COMMUNICATION_DETAILS,
      page: () => const CommunicationDetailsView(),
      binding: CommunicationDetailsBinding(),
    ),
    GetPage(
      name: _Paths.FIN_DETAILS,
      page: () => const FinDetailsView(),
      binding: FinDetailsBinding(),
    ),
    GetPage(
      name: _Paths.WEATHER,
      page: () => const WeatherView(),
      binding: WeatherBinding(),
    ),
    GetPage(
      name: _Paths.FARM_PLANS,
      page: () => const FarmPlansView(),
      binding: FarmPlansBinding(),
    ),
    GetPage(
      name: _Paths.PURCHASE,
      page: () => const PurchaseView(),
      binding: PurchaseBinding(),
    ),
    GetPage(
      name: _Paths.PRODUCT_VIEW,
      page: () => const ProductView(),
      binding: ProductViewBinding(),
    ),
    GetPage(
      name: _Paths.PERFORMANCE,
      page: () => const PerformanceView(),
      binding: PerfomanceBinding(),
    ),
    GetPage(
      name: _Paths.PAYMENT_TYPE,
      page: () => const PaymentTypeView(),
      binding: PaymentTypeBinding(),
    ),
    GetPage(
      name: _Paths.SERVICE_ENQUIRY,
      page: () => const ServiceEnquiryView(),
      binding: ServiceEnquiryBinding(),
    ),
    GetPage(
      name: _Paths.GOOGLE_MAP,
      page: () => const GoogleMapView(),
      binding: GoogleMapBinding(),
    ),
    GetPage(name: _Paths.CHAT, page: () => ChatView(), binding: ChatBinding()),
    GetPage(
      name: _Paths.PLANT_PROTECTION,
      page: () => PlantProtectionView(),
      binding: PlantProtectionBinding(),
    ),
    GetPage(
      name: _Paths.PROFITABILITY,
      page: () => const ProfitabilityView(),
      binding: ProfitabilityBinding(),
    ),
    GetPage(
      name: _Paths.FARM_PLAN_LIST_VIEW,
      page: () => const FarmPlanListView(),
      binding: FarmPlanListViewBinding(),
    ),
    GetPage(
      name: _Paths.FARMING_DASHBOARD,
      page: () => const FarmingDashboardView(),
      binding: FarmingDashboardBinding(),
    ),
    GetPage(
      name: _Paths.CROP_SUGGESTION,
      page: () => const CropSuggestionView(),
      binding: CropSuggestionBinding(),
    ),
    GetPage(
      name: _Paths.SHG_DETAILS,
      page: () => const ShgDetailsView(),
      binding: ShgDetailsBinding(),
    ),
    GetPage(
      name: _Paths.LAND_DETAILS,
      page: () => const LandDetailsView(),
      binding: LandDetailsBinding(),
    ),
    GetPage(
      name: _Paths.LAND_FARM_DETAILS,
      page: () => const LandFarmDetailsView(),
      binding: LandFarmDetailsBinding(),
    ),
    GetPage(
      name: _Paths.SOIL_ASSESSMENT,
      page: () => const SoilAssessmentView(),
      binding: SoilAssessmentBinding(),
    ),
    GetPage(
      name: _Paths.FACTORS_RISK,
      page: () => const FactorsRiskView(),
      binding: FactorsRiskBinding(),
    ),
    GetPage(
      name: _Paths.YIELD_DETAILS,
      page: () => const YieldDetailsView(),
      binding: YieldDetailsBinding(),
    ),
    GetPage(
      name: _Paths.EVENT_DISPLAY,
      page: () => const EventDisplayView(),
      binding: EventDisplayBinding(),
    ),
    GetPage(
      name: _Paths.FINANCE_REQUEST,
      page: () => const FinanceRequestView(),
      binding: FinanceRequestBinding(),
    ),
    GetPage(
      name: _Paths.AGRI_INPUT,
      page: () => const AgriInputView(),
      binding: AgriInputBinding(),
    ),
    GetPage(
      name: _Paths.SERVICE_REQUEST,
      page: () => const ServiceRequestView(),
      binding: ServiceRequestBinding(),
    ),
    GetPage(
      name: _Paths.SERVICE_DETAILS,
      page: () => const ServiceDetailsView(),
      binding: ServiceDetailsBinding(),
    ),
    GetPage(
      name: _Paths.SOIL_MAPS,
      page: () => const SoilMapsView(),
      binding: SoilMapsBinding(),
    ),
    GetPage(
      name: _Paths.MEASURE_LAND,
      page: () => const MeasureLandView(),
      binding: MeasureLandBinding(),
    ),
    GetPage(
      name: _Paths.MY_PROFILE,
      page: () => const MyProfileView(),
      binding: MyProfileBinding(),
    ),
    GetPage(
      name: _Paths.NOTIFICATION,
      page: () => const NotificationView(),
      binding: NotificationBinding(),
    ),
    GetPage(
      name: _Paths.PAL_CREATION,
      page: () => const PalCreationView(),
      binding: PalCreationBinding(),
    ),
    GetPage(
      name: _Paths.BUYER_DEMANDS,
      page: () => BuyerDemandsView(),
      binding: BuyerDemandsBinding(),
    ),
    GetPage(
      name: _Paths.CONTACT_US,
      page: () => const ContactUsView(),
      binding: ContactUsBinding(),
    ),
    GetPage(
      name: _Paths.ABOUT_US,
      page: () => const AboutUsView(),
      binding: AboutUsBinding(),
    ),
    GetPage(
      name: _Paths.EDIT_PROFILE,
      page: () => const EditProfileView(),
      binding: EditProfileBinding(),
    ),
    GetPage(
      name: _Paths.WEATHER_GRAPHS,
      page: () => WeatherGraphsView(),
      binding: WeatherGraphsBinding(),
    ),
    GetPage(
      name: _Paths.WEATHER_MAPS,
      page: () => const WeatherMapsView(),
      binding: WeatherMapsBinding(),
    ),
    GetPage(
      name: _Paths.LAND_AND_CORP_DETAILS,
      page: () => const LandAndCorpDetailsView(),
      binding: LandAndCorpDetailsBinding(),
    ),
    GetPage(
      name: _Paths.BUYER_HOME,
      page: () => BuyerHomeView(),
      binding: BuyerHomeBinding(),
    ),
    GetPage(
      name: _Paths.BUYER_MY_BIDS,
      page: () => const BuyerMyBidsView(),
      binding: BuyerMyBidsBinding(),
    ),
    GetPage(
      name: _Paths.BUYER_ADS_DETAIL,
      page: () => BuyerAdsDetailView(),
      binding: BuyerAdsDetailBinding(),
    ),
    GetPage(
      name: _Paths.BUYER_ADS_DEMAND,
      page: () => BuyerAdsDemandView(),
      binding: BuyerAdsDemandBinding(),
    ),
    GetPage(
      name: _Paths.CROP_YIELD,
      page: () => const CropYieldView(),
      binding: CropYieldBinding(),
    ),
    GetPage(
      name: _Paths.BUYER_BID_VIEW,
      page: () => BuyerBidViewView(),
      binding: BuyerBidViewBinding(),
    ),
    GetPage(
      name: _Paths.BUYER_PLACE_BID,
      page: () => BuyerPlaceBidView(),
      binding: BuyerPlaceBidBinding(),
    ),
    GetPage(
      name: _Paths.MARKET_PRICE,
      page: () => const MarketPriceView(),
      binding: MarketPriceBinding(),
    ),
    GetPage(
      name: _Paths.MARKET_FILTER,
      page: () => const MarketFilterView(),
      binding: MarketFilterBinding(),
    ),
    GetPage(
      name: _Paths.PLAN_SUMMARY,
      page: () => const PlanSummaryView(),
      binding: PlanSummaryBinding(),
    ),
    GetPage(
      name: _Paths.SIGN_UP_TYPE,
      page: () => const SignUpTypeView(),
      binding: SignUpTypeBinding(),
    ),
    GetPage(
      name: _Paths.REGISTRATION,
      page: () => const RegistrationView(),
      binding: RegistrationBinding(),
    ),
    GetPage(
      name: _Paths.OTP,
      page: () => const OtpView(),
      binding: OtpBinding(),
    ),
    GetPage(
      name: _Paths.CROP_INSURANCE,
      page: () => const CropInsuranceView(),
      binding: CropInsuranceBinding(),
    ),
    GetPage(
      name: _Paths.FARMER_PROFILE,
      page: () => const FarmerProfileView(),
      binding: FarmerProfileBinding(),
    ),
  ];
}
