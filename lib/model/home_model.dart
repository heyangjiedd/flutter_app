import 'package:flutter_app/model/common_model.dart';
import 'package:flutter_app/model/config_model.dart';
import 'package:flutter_app/model/grid_nav_model.dart';
import 'package:flutter_app/model/sales_box_model.dart';

class HomeModel {
  final ConfigModel config;
  final List<CommonModel> bannerList;
  final List<CommonModel> localNavList;
  final List<CommonModel> subNavList;
  final GridNavModel gridNav;
  final SalesBoxModel salesBox;
  HomeModel({
    this.config,
    this.bannerList,
    this.localNavList,
    this.subNavList,
    this.gridNav,
    this.salesBox,
  });
  factory HomeModel.formJson(Map<String, dynamic> json) {
    List<CommonModel> bannerList = (json['bannerList'] as List).map((i) => CommonModel.fromJson(i)).toList();
    List<CommonModel> localNavList = (json['localNavList'] as List).map((i) => CommonModel.fromJson(i)).toList();
    List<CommonModel> subNavList = (json['subNavList'] as List).map((i) => CommonModel.fromJson(i)).toList();
    return HomeModel(
        bannerList: bannerList,
        localNavList: localNavList,
        subNavList: subNavList,
        config: ConfigModel.fromJson(json['config']),
        gridNav: GridNavModel.fromJson(json['gridNav']),
        salesBox: SalesBoxModel.fromJson(json['salesBox']));
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.config != null) {
      data['config'] = this.config.toJson();
    }
    if (this.bannerList != null) {
      data['bannerList'] = this.bannerList.map((v) => v.toJson()).toList();
    }
    if (this.localNavList != null) {
      data['localNavList'] = this.localNavList.map((v) => v.toJson()).toList();
    }
    if (this.gridNav != null) {
      data['gridNav'] = this.gridNav.toJson();
    }
    if (this.subNavList != null) {
      data['subNavList'] = this.subNavList.map((v) => v.toJson()).toList();
    }
    if (this.salesBox != null) {
      data['salesBox'] = this.salesBox.toJson();
    }
    return data;
  }
}
