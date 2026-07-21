class Country {
  const Country({required this.name, required this.flag, required this.dialCode});
  final String name;
  final String flag;
  final String dialCode;

  static const egypt = Country(name: 'Egypt', flag: '🇪🇬', dialCode: '+20');
  static const all = [
    egypt,
    Country(name: 'United States', flag: '🇺🇸', dialCode: '+1'),
    Country(name: 'United Kingdom', flag: '🇬🇧', dialCode: '+44'),
    Country(name: 'United Arab Emirates', flag: '🇦🇪', dialCode: '+971'),
  ];
}
