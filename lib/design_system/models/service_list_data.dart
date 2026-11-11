class ServiceListData {
  final String title;
  final String? subtitle;
  final void Function()? onTap;

  const ServiceListData({
    required this.title,
    this.subtitle,
    this.onTap,
  });
}
