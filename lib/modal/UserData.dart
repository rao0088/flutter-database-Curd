class UserData {
  String _title;
  int _id;

  UserData(this._title);

  UserData.map(dynamic obj){

    this._title =obj['title'];
    this._id =obj['id'];

  }

  int get id =>_id;
  String get title => _title;

  Map<String, dynamic> toMap(){

    var map = Map<String, dynamic>();

    if(_id!=null){
      map['id']= _id;
    }
    map['title'] = _title;

    return map;
  }

  UserData.fromMap(Map<String, dynamic>map){

    this._id =map['id'];
    this._title=map['title'];
  }

}
