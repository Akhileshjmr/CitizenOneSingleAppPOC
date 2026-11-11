class InsurancePlan {
  final String id;
  final String title;
  final String company;
  final String premium;
  final String cover;
  final String claim;
  final String network;
  final String highlight;

  const InsurancePlan({
    required this.id,
    required this.title,
    required this.company,
    required this.premium,
    required this.cover,
    required this.claim,
    required this.network,
    required this.highlight,
  });

  String get priceOnly {
    if (premium.endsWith('/yr')) {
      return premium.substring(0, premium.length - 3);
    }
    return premium;
  }

  String get premiumWithYr {
    if (premium.endsWith('/yr')) {
      return premium;
    }
    return '$premium/yr';
  }
}

const List<InsurancePlan> mockInsurancePlans = [
  InsurancePlan(
    id: '1',
    title: 'Health Shield\nStarter',
    company: 'Health Shield',
    premium: 'ZMW 950/yr',
    cover: 'ZMW 40,000',
    claim: '94.2%',
    network: '200+ Hospitals',
    highlight: 'Affordable Individual\nHealth Coverage',
  ),
  InsurancePlan(
    id: '2',
    title: 'Health Shield\nSupreme',
    company: 'Health Shield',
    premium: 'ZMW 3500/yr',
    cover: 'ZMW 200,000',
    claim: '98.6%',
    network: '650+ Hospitals',
    highlight: 'Maternity + Critical\nIllness Included',
  ),
  InsurancePlan(
    id: '3',
    title: 'Family Care\nPremium',
    company: 'Family Care',
    premium: 'ZMW 4200/yr',
    cover: 'ZMW 300,000',
    claim: '96.8%',
    network: '500+ Hospitals',
    highlight: 'Family Coverage\nwith OPD Benefits',
  ),
  InsurancePlan(
    id: '4',
    title: 'Medi Secure\nElite',
    company: 'Medi Secure',
    premium: 'ZMW 5200/yr',
    cover: 'ZMW 500,000',
    claim: '99.1%',
    network: '850+ Hospitals',
    highlight: 'Critical Illness +\nWorldwide Coverage',
  ),
  InsurancePlan(
    id: '5',
    title: 'Family Care\nPremium',
    company: 'Family Care',
    premium: 'ZMW 4200/yr',
    cover: 'ZMW 300,000',
    claim: '96.8%',
    network: '500+ Hospitals',
    highlight: 'Family Coverage\nwith OPD Benefits',
  ),
];
