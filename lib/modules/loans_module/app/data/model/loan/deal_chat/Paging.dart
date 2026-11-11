class Paging {
  Paging({
      this.pageNum, 
      this.totalPages, 
      this.totalRecs, 
      this.recsPerPage, 
      this.sortBy, 
      this.sortByType, 
      this.paginationRecords, 
      this.facetFilter,});

  Paging.fromJson(dynamic json) {
    pageNum = json['pageNum'];
    totalPages = json['totalPages'];
    totalRecs = json['totalRecs'];
    recsPerPage = json['recsPerPage'];
    sortBy = json['sortBy'];
    sortByType = json['sortByType'];
    paginationRecords = json['paginationRecords'];
    facetFilter = json['facetFilter'];
  }
  int? pageNum;
  int? totalPages;
  int? totalRecs;
  int? recsPerPage;
  dynamic sortBy;
  String? sortByType;
  int? paginationRecords;
  dynamic facetFilter;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['pageNum'] = pageNum;
    map['totalPages'] = totalPages;
    map['totalRecs'] = totalRecs;
    map['recsPerPage'] = recsPerPage;
    map['sortBy'] = sortBy;
    map['sortByType'] = sortByType;
    map['paginationRecords'] = paginationRecords;
    map['facetFilter'] = facetFilter;
    return map;
  }

}