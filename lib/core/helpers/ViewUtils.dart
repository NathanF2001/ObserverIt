class ViewUtils {
  static getTotalHoursPeriod(int period, String typePeriod) {
    int factor = 1;

    if (typePeriod == "Days") {
      factor = 24;
    } else if (typePeriod == "Weeks") {
      factor = 168;
    }

    return period*factor;
  }

  static Map<String, dynamic> getPeriodAndTypeByTotal(int total) {
    if (total % 168 == 0) {
      return {
        "type":"Weeks",
        "period": (total~/168).toString()
      };
    } else if (total % 24 == 0) {
      return {
        "type":"Days",
        "period": (total~/24).toString()
      };
    } else {
      return {
        "type":"Hours",
        "period": total.toString()
      };
    }
  }
}