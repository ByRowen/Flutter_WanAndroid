/**
 * 玩Android 导航实体类
 * 使用以下工具可将json转换成Bean类
 * [link: https://javiercbk.github.io/json_to_dart/]
 */
class NaviEntity {
  List<NaviData> data;
  int errorCode;
  String errorMsg;

  NaviEntity({this.data, this.errorCode, this.errorMsg});

  NaviEntity.fromJson(Map<String, dynamic> json) {
    if (json['data'] != null) {
      data = new List<NaviData>();
      json['data'].forEach((v) {
        data.add(new NaviData.fromJson(v));
      });
    }
    errorCode = json['errorCode'];
    errorMsg = json['errorMsg'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.data != null) {
      data['data'] = this.data.map((v) => v.toJson()).toList();
    }
    data['errorCode'] = this.errorCode;
    data['errorMsg'] = this.errorMsg;
    return data;
  }
}

class NaviData {
  List<NaviDataArticle> articles;
  int cid;
  String name;

  NaviData({this.articles, this.cid, this.name});

  NaviData.fromJson(Map<String, dynamic> json) {
    if (json['articles'] != null) {
      articles = new List<NaviDataArticle>();
      json['articles'].forEach((v) {
        articles.add(new NaviDataArticle.fromJson(v));
      });
    }
    cid = json['cid'];
    name = json['name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.articles != null) {
      data['articles'] = this.articles.map((v) => v.toJson()).toList();
    }
    data['cid'] = this.cid;
    data['name'] = this.name;
    return data;
  }
}

class NaviDataArticle {
  String superChapterName;
  int publishTime;
  int visible;
  String niceDate;
  String projectLink;
  String author;
  String prefix;
  int zan;
  String origin;
  String chapterName;
  String link;
  String title;
  int type;
  int userId;
  List<Null> tags;
  String apkLink;
  String envelopePic;
  int chapterId;
  int superChapterId;
  int id;
  bool fresh;
  bool collect;
  int courseId;
  String desc;

  NaviDataArticle({this.superChapterName, this.publishTime, this.visible, this.niceDate, this.projectLink, this.author, this.prefix, this.zan, this.origin, this.chapterName, this.link, this.title, this.type, this.userId, this.tags, this.apkLink, this.envelopePic, this.chapterId, this.superChapterId, this.id, this.fresh, this.collect, this.courseId, this.desc});

  NaviDataArticle.fromJson(Map<String, dynamic> json) {
    superChapterName = json['superChapterName'];
    publishTime = json['publishTime'];
    visible = json['visible'];
    niceDate = json['niceDate'];
    projectLink = json['projectLink'];
    author = json['author'];
    prefix = json['prefix'];
    zan = json['zan'];
    origin = json['origin'];
    chapterName = json['chapterName'];
    link = json['link'];
    title = json['title'];
    type = json['type'];
    userId = json['userId'];
    if (json['tags'] != null) {
      tags = new List<Null>();
    }
    apkLink = json['apkLink'];
    envelopePic = json['envelopePic'];
    chapterId = json['chapterId'];
    superChapterId = json['superChapterId'];
    id = json['id'];
    fresh = json['fresh'];
    collect = json['collect'];
    courseId = json['courseId'];
    desc = json['desc'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['superChapterName'] = this.superChapterName;
    data['publishTime'] = this.publishTime;
    data['visible'] = this.visible;
    data['niceDate'] = this.niceDate;
    data['projectLink'] = this.projectLink;
    data['author'] = this.author;
    data['prefix'] = this.prefix;
    data['zan'] = this.zan;
    data['origin'] = this.origin;
    data['chapterName'] = this.chapterName;
    data['link'] = this.link;
    data['title'] = this.title;
    data['type'] = this.type;
    data['userId'] = this.userId;
    if (this.tags != null) {
      data['tags'] =  [];
    }
    data['apkLink'] = this.apkLink;
    data['envelopePic'] = this.envelopePic;
    data['chapterId'] = this.chapterId;
    data['superChapterId'] = this.superChapterId;
    data['id'] = this.id;
    data['fresh'] = this.fresh;
    data['collect'] = this.collect;
    data['courseId'] = this.courseId;
    data['desc'] = this.desc;
    return data;
  }
}