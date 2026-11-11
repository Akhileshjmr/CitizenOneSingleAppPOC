import 'package:citizenone_app/features/customer/services/data/models/service_model.dart';

abstract class ServiceDataSource {
  Future<List<ServiceModel>> getServices();
}

class ServiceDataSourceImpl implements ServiceDataSource {
  @override
  Future<List<ServiceModel>> getServices() async {
    // Simulating a local data fetch of the previously hardcoded services
    return const [
      ServiceModel(id: 'wealth', titleKey: 'serviceWealthTitle'),
      ServiceModel(id: 'health', titleKey: 'serviceHealthTitle'),
      ServiceModel(id: 'sport', titleKey: 'serviceSportTitle'),
      ServiceModel(id: 'bills', titleKey: 'serviceBillPayTitle'),
      ServiceModel(id: 'insurance', titleKey: 'serviceInsuranceTitle'),
      ServiceModel(id: 'gov', titleKey: 'serviceGovtTitle'),
      ServiceModel(id: 'common', titleKey: 'serviceCommonTitle'),
      ServiceModel(id: 'banking', titleKey: 'serviceBankingTitle'),
      ServiceModel(id: 'mobile', titleKey: 'serviceMobileTitle'),
      ServiceModel(id: 'market', titleKey: 'serviceMarketplaceTitle'),
      ServiceModel(id: 'agri', titleKey: 'serviceAgriTitle'),
      ServiceModel(id: 'logistics', titleKey: 'serviceLogisticsTitle'),
      ServiceModel(id: 'sme', titleKey: 'serviceSmeTitle'),
    ];
  }
}
