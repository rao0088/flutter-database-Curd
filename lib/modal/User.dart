class User{
  
  int _id;
  String _title;

  User(this._title);

  //User.withid(this._id, this._title);

  User.map(dynamic obj){
    this._title= obj['title'];
    this._id= obj['id'];
  }

int get id =>_id;
String get title => _title;


Map<String ,dynamic> toMap(){

  var map = Map<String, dynamic>();

  if(_id!=null){
    map['id']= _id;
  }
  map['title'] = _title;

  return map;
}

User.fromMap(Map<String, dynamic>map){

  this._id =map['id'];
  this._title=map['title'];
}

}