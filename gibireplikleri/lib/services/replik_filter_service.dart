class FilterService {
  static List filterBySoyleyen(int? soyleyen, List replikler,
      {bool excludeKufur = true}) {
    if (soyleyen == null) {
      return replikler.where((r) => (excludeKufur || !r['kufur'])).toList();
    } else {
      return replikler
          .where(
              (r) => (excludeKufur || !r['kufur']) && r['soyleyen'] == soyleyen)
          .toList();
    }
  }

   static List filterBySearch(String query, List replikler, bool showKufur) {
    if (query.isEmpty) {
      return FilterService.filterByKufur(showKufur, replikler);
    } else {
      final lowercaseQuery = query.toLowerCase();
      return FilterService.filterByKufur(showKufur, replikler)
          .where((r) => r['replik'].toLowerCase().contains(lowercaseQuery))
          .toList();
    }
  }


  static List filterByKufur(bool showKufur, List replikler) {
    if (showKufur) {
      return replikler;
    } else {
      return replikler.where((r) => !r['kufur']).toList();
    }
  }
}
