class MangaModel {
    String storyid;
    String storyname;
    String storyothername;
    String storyimage;
    String storydes;
    String storygenres;
    String urllinkcraw;
    String storytauthor;
    String views;

    MangaModel({
      required this.storyid,
      required this.storyname,
      required this.storyothername,
      required this.storyimage,
      required this.storydes,
      required this.storygenres,
      required this.urllinkcraw,
      required this.storytauthor,
      required this.views,
    }
  );

  
  factory MangaModel.fromJson(Map <String, dynamic> data) {
    final storyid = data['storyid'] as String? ?? "";
    final storyname = data['storyname'] as String? ?? "";
    final storyothername = data['storyothername'] as String? ?? "";
    final storyimage  = data['storyimage'] as String? ?? "";
    final storydes = data['storydes'] as String? ?? "";
    final storygenres = data['storygenres'] as String? ?? "";
    final urllinkcraw = data['urllinkcraw'] as String? ?? "";
    final storytauthor = data['storytauthor'] as String? ?? "";
    final views = data['views'] as String? ?? "";

    return MangaModel(
      storyid: storyid, 
      storyname: storyname, 
      storyothername: storyothername, 
      storyimage: storyimage, 
      storydes: storydes, 
      storygenres: storygenres, 
      urllinkcraw: urllinkcraw, 
      storytauthor: storytauthor,
      views: views);
    }
  }
