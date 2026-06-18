import 'package:ethiopian_date_picker/ethiopian_date_picker.dart'
    hide EthiopianDate;
import 'package:intl/intl.dart';

import '../../shared/models/app_models.dart';
import 'app_language_provider.dart';

/// Centralized UI strings and calendar labels for English and Amharic.
class AppLocalizations {
  const AppLocalizations(this.language);

  final AppLanguage language;

  bool get isAmharic => language == AppLanguage.amharic;

  static const _englishMonths = [
    'Meskerem',
    'Tikimt',
    'Hidar',
    'Tahsas',
    'Tir',
    'Yekatit',
    'Megabit',
    'Miazia',
    'Ginbot',
    'Sene',
    'Hamle',
    'Nehase',
    'Pagume',
  ];

  static const _amharicMonths = [
    'መስከረም',
    'ጥቅምት',
    'ህዳር',
    'ታህሳስ',
    'ጥር',
    'የካቲት',
    'መጋቢት',
    'ሚያዝያ',
    'ግንቦት',
    'ሰኔ',
    'ሐምሌ',
    'ነሐሴ',
    'ጳጉሜ',
  ];

  static const _englishMonthShort = [
    'Mes',
    'Tik',
    'Hid',
    'Tah',
    'Tir',
    'Yek',
    'Meg',
    'Mia',
    'Gin',
    'Sen',
    'Ham',
    'Neh',
    'Pag',
  ];

  static const _englishWeekdaysShort = [
    'Mon',
    'Tue',
    'Wed',
    'Thu',
    'Fri',
    'Sat',
    'Sun',
  ];

  static const _amharicWeekdaysShort = [
    'ሰኞ',
    'ማክሰ',
    'ረቡዕ',
    'ሐሙስ',
    'አርብ',
    'ቅዳሜ',
    'እሁድ',
  ];

  static const _englishWeekdaysFull = [
    'Monday',
    'Tuesday',
    'Wednesday',
    'Thursday',
    'Friday',
    'Saturday',
    'Sunday',
  ];

  static const _amharicWeekdaysFull = [
    'ሰኞ',
    'ማክሰኞ',
    'ረቡዕ',
    'ሐሙስ',
    'አርብ',
    'ቅዳሜ',
    'እሁድ',
  ];

  String get appTitle =>
      isAmharic ? 'የኢትዮጵያ ቀን መቁጠሪያ' : 'Ethiopian Calendar';

  String get appSubtitle =>
      isAmharic ? 'እና የቀን መለወጫ' : '& Date Converter';

  String get navHome => isAmharic ? 'መነሻ' : 'Home';
  String get navCalendar => isAmharic ? 'ቀን መቁጠሪያ' : 'Calendar';
  String get navConverter => isAmharic ? 'ቀን መለወጫ' : 'Converter';
  String get navAge => isAmharic ? 'ዕድሜ' : 'Age';
  String get navSettings => isAmharic ? 'ቅንብሮች' : 'Settings';

  String get today => isAmharic ? 'ዛሬ' : 'Today';
  String get quickActions => isAmharic ? 'ፈጣን አገልግሎቶች' : 'Quick Actions';
  String get dayOfWeek => isAmharic ? 'የሳምንቱ ቀን' : 'Day of week';
  String get ethiopianMonth => isAmharic ? 'የኢትዮጵያ ወር' : 'Ethiopian month';

  String get calendarTitle =>
      isAmharic ? 'የኢትዮጵያ ቀን መቁጠሪያ' : 'Ethiopian Calendar';
  String get swipeHint => isAmharic
      ? 'ወር ለመቀየር ወደ ግራ ወይም ወደ ቀኝ ያንሸራትቱ'
      : 'Swipe left or right to change month';
  String get selected => isAmharic ? 'የተመረጠ' : 'Selected';
  String get previousMonth => isAmharic ? 'ያለፈው ወር' : 'Previous month';
  String get nextMonth => isAmharic ? 'የሚቀጥለው ወር' : 'Next month';

  String get converterTitle => isAmharic ? 'የቀን መለወጫ' : 'Date Converter';
  String get gregorianToEthiopian =>
      isAmharic ? 'ፈረንጆች → ኢትዮጵያ' : 'Gregorian → Ethiopian';
  String get ethiopianToGregorian =>
      isAmharic ? 'ኢትዮጵያ → ፈረንጆች' : 'Ethiopian → Gregorian';
  String get inputDate => isAmharic ? 'የሚቀየር ቀን' : 'Input Date';
  String get enterGregorian =>
      isAmharic ? 'እባክዎ የፈረንጆችን ቀን ያስገቡ።' : 'Enter a Gregorian date to convert.';
  String get enterEthiopian =>
      isAmharic ? 'እባክዎ የኢትዮጵያን ቀን ያስገቡ።' : 'Enter an Ethiopian date to convert.';
  String get pickFromCalendar =>
      isAmharic ? 'ከቀን መቁጠሪያው ይምረጡ' : 'Pick from calendar';
  String get pickHint => isAmharic
      ? 'ለቀደሙት ዓመታት እባክዎ ቀኑን በእጅ ያስገቡ — የቀን መምረጫው የተወሰነ ዓመት ብቻ ነው የሚያሳየው።'
      : 'For older years, type the date manually — the picker shows a limited year range.';
  String get convert => isAmharic ? 'ለውጥ' : 'Convert';
  String get year => isAmharic ? 'ዓመት' : 'Year';
  String get month => isAmharic ? 'ወር' : 'Month';
  String get day => isAmharic ? 'ቀን' : 'Day';
  String get convertedDate => isAmharic ? 'የተለወጠ ቀን' : 'Converted Date';
  String get fromLabel => isAmharic ? 'ከ' : 'From';
  String get invalidDate => isAmharic ? 'ልክ ያልሆነ ቀን' : 'Invalid Date';

  String get settingsTitle => isAmharic ? 'ቅንብሮች' : 'Settings';
  String get languageSection => isAmharic ? 'ቋንቋ' : 'Language';
  String get languageDescription => isAmharic
      ? 'የወራትን ስም እና የመተግበሪያውን ቋንቋ ይምረጡ።'
      : 'Choose month names and app text display language.';
  String get englishLabel => 'English';
  String get amharicLabel => 'አማርኛ';
  String get aboutSection => isAmharic ? 'ስለ መተግበሪያው' : 'About';
  String get versionLabel => isAmharic ? 'ስሪት' : 'Version';

  String get browseCalendar =>
      isAmharic ? 'የኢትዮጵያን ቀን መቁጠሪያ ይመልከቱ' : 'Browse the Ethiopian calendar';
  String get convertDates => isAmharic
      ? 'ቀናትን ከአንዱ የቀን መቁጠሪያ ወደ ሌላው ይለውጡ'
      : 'Convert between calendar systems';

  String get ageTitle => isAmharic ? 'ዕድሜ ማስያ' : 'Age Calculator';
  String get birthDate => isAmharic ? 'የትውልድ ቀን' : 'Birth date';
  String get selectBirthDate =>
      isAmharic ? 'የትውልድ ቀንዎን ይምረጡ' : 'Select your birth date';
  String get yourAge => isAmharic ? 'ዕድሜዎ' : 'Your age';
  String get ageLabel => isAmharic ? 'ዕድሜ:' : 'Age:';
  String get ageAtDate => isAmharic ? 'ዕድሜ በቀን' : 'Age at date';
  String get ageAtDateHint => isAmharic
      ? 'ዕድሜውን በየትኛው ቀን መለኪያ እንደሚሰላ ይምረጡ። ነባሪው ዛሬ ነው።'
      : 'Choose the date to measure age from. Defaults to today.';
  String get calculateAge => isAmharic
      ? 'ዕድሜን በዓመት፣ በወር እና በቀን ያስላ'
      : 'Calculate your age in years, months, and days';
  String get orPrefix => isAmharic ? 'ወይም' : 'or';
  String get live => isAmharic ? 'በቀጥታ' : 'Live';
  String get gregorianDate => isAmharic ? 'የፈረንጆች ቀን' : 'Gregorian date';

  String get supportSection => isAmharic ? 'ድጋፍ' : 'Support';
  String get rateApp => isAmharic ? 'መተግበሪያውን ደረጃ ይስጡ' : 'Rate this app';
  String get shareApp => isAmharic ? 'መተግበሪያውን ያጋሩ' : 'Share this app';
  String get shareMessage => isAmharic
      ? 'የኢትዮጵያ ቀን መቁጠሪያ እና የቀን መለወጫ — ከፍተኛ የኢትዮጵያ ቀን መቁጠሪያ መተግበሪያ!'
      : 'Ethiopian Calendar & Date Converter — a beautiful offline Ethiopian calendar app!';

  EthiopianDatePickerLocalization get pickerLocalization =>
      isAmharic
          ? EthiopianDatePickerLocalization.am
          : EthiopianDatePickerLocalization.us;

  String monthName(int month) {
    assert(month >= 1 && month <= 13);
    final names = isAmharic ? _amharicMonths : _englishMonths;
    return names[month - 1];
  }

  String monthShort(int month) {
    assert(month >= 1 && month <= 13);
    if (isAmharic) return monthName(month);
    return _englishMonthShort[month - 1];
  }

  List<String> get weekdayHeadersShort =>
      isAmharic ? _amharicWeekdaysShort : _englishWeekdaysShort;

  String weekdayFull(int index) {
    assert(index >= 0 && index <= 6);
    final names = isAmharic ? _amharicWeekdaysFull : _englishWeekdaysFull;
    return names[index];
  }

  /// Monday-first weekday index (0 = Monday … 6 = Sunday).
  int weekdayIndexFromDateTime(DateTime dateTime) => dateTime.weekday - 1;

  String formatGregorianShort(DateTime dateTime) {
    final months = isAmharic
        ? const [
            'ጃን',
            'ፌብ',
            'ማር',
            'ኤፕ',
            'ሜይ',
            'ጁን',
            'ጁላ',
            'ኦገ',
            'ሴፕ',
            'ኦክ',
            'ኖቬ',
            'ዲሴ',
          ]
        : const [
            'Jan',
            'Feb',
            'Mar',
            'Apr',
            'May',
            'Jun',
            'Jul',
            'Aug',
            'Sep',
            'Oct',
            'Nov',
            'Dec',
          ];
    return '${months[dateTime.month - 1]} ${dateTime.day}';
  }

  String formatGregorianLong(DateTime dateTime) {
    return DateFormat('EEEE, MMMM d, y').format(dateTime);
  }

  String formatEthiopianDate(EthiopianDate date) =>
      '${date.day} ${monthName(date.month)} ${date.year}';

  String ethiopianYearSuffix(int year) =>
      isAmharic ? '$year ዓ.ም.' : '$year E.C.';

  String _unit(int count, String singular, String plural) =>
      count == 1 ? singular : plural;

  String ageYearsMonthsDays(int years, int months, int days) {
    if (isAmharic) {
      return '$years ${_unit(years, 'ዓመት', 'ዓመታት')} '
          '$months ${_unit(months, 'ወር', 'ወራት')} '
          '$days ${_unit(days, 'ቀን', 'ቀናት')}';
    }
    return '$years ${_unit(years, 'year', 'years')} '
        '$months ${_unit(months, 'month', 'months')} '
        '$days ${_unit(days, 'day', 'days')}';
  }

  String ageTotalMonthsDays(int totalMonths, int days) {
    if (isAmharic) {
      return '$totalMonths ${_unit(totalMonths, 'ወር', 'ወራት')} '
          '$days ${_unit(days, 'ቀን', 'ቀናት')}';
    }
    return '$totalMonths ${_unit(totalMonths, 'month', 'months')} '
        '$days ${_unit(days, 'day', 'days')}';
  }

  String ageWeeksDays(int weeks, int weekDays) {
    if (isAmharic) {
      return '$weeks ${_unit(weeks, 'ሳምንት', 'ሳምንታት')} '
          '$weekDays ${_unit(weekDays, 'ቀን', 'ቀናት')}';
    }
    return '$weeks ${_unit(weeks, 'week', 'weeks')} '
        '$weekDays ${_unit(weekDays, 'day', 'days')}';
  }

  String ageTotalDays(int totalDays) {
    final formatted = NumberFormat('#,###').format(totalDays);
    return isAmharic
        ? '$formatted ${_unit(totalDays, 'ቀን', 'ቀናት')}'
        : '$formatted ${_unit(totalDays, 'day', 'days')}';
  }

  String ageTotalHours(int totalHours) {
    final formatted = NumberFormat('#,###').format(totalHours);
    return isAmharic
        ? '$formatted ${_unit(totalHours, 'ሰዓት', 'ሰዓታት')}'
        : '$formatted ${_unit(totalHours, 'hour', 'hours')}';
  }

  String ageTotalMinutes(int totalMinutes) {
    final formatted = NumberFormat('#,###').format(totalMinutes);
    return isAmharic
        ? '$formatted ${_unit(totalMinutes, 'ደቂቃ', 'ደቂቃዎች')}'
        : '$formatted ${_unit(totalMinutes, 'minute', 'minutes')}';
  }

  String ageTotalSeconds(int totalSeconds) {
    final formatted = NumberFormat('#,###').format(totalSeconds);
    return isAmharic
        ? '$formatted ${_unit(totalSeconds, 'ሰከንድ', 'ሰከንዶች')}'
        : '$formatted ${_unit(totalSeconds, 'second', 'seconds')}';
  }
}
