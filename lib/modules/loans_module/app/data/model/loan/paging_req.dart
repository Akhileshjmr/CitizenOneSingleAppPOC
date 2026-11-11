import 'package:citizenone_app/modules/loans_module/app/data/model/loan/track/facet_filter_resp.dart';

class PagingReq {
  int pageNum = 1;
  int totalPages = 0;
  int totalRecs = 0;
  int recsPerPage = 10;
  String? sortBy;
  String sortByType = 'ASC';
  int paginationRecords = 0;
  List<FacetFilterResp>? facetFilter;

  PagingReq({
    this.pageNum = 1,
    this.totalPages = 0,
    this.totalRecs = 0,
    this.recsPerPage = 10,
    this.sortBy,
    this.sortByType = 'ASC',
    this.paginationRecords = 0,
    this.facetFilter,
  });

  @override
  String toString() {
    return 'PagingReq{pageNum: $pageNum, totalPages: $totalPages, totalRecs: $totalRecs, recsPerPage: $recsPerPage, sortBy: $sortBy, sortByType: $sortByType, paginationRecords: $paginationRecords, facetFilter: $facetFilter}';
  }

  PagingReq.fromJson(Map<String, dynamic> json) {
    pageNum = json['pageNum'];
    totalPages = json['totalPages'];
    totalRecs = json['totalRecs'];
    recsPerPage = json['recsPerPage'];
    sortBy = json['sortBy'];
    sortByType = json['sortByType'];
    paginationRecords = json['paginationRecords'];
    facetFilter =
        json["facetFilter"] == null
            ? []
            : List<FacetFilterResp>.from(
              json["facetFilter"].map((x) => FacetFilterResp.fromJson(x)),
            );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['pageNum'] = pageNum;
    data['totalPages'] = totalPages;
    data['totalRecs'] = totalRecs;
    data['recsPerPage'] = recsPerPage;
    data['sortBy'] = sortBy;
    data['sortByType'] = sortByType;
    data['paginationRecords'] = paginationRecords;
    data['facetFilter'] = facetFilter;
    return data;
  }
}
