class Message {
  Message({
    required this.msg,
    required this.read,
    required this.told,
    required this.type,
    required this.fromId,
    required this.sent,
    required this.rMsg,
    required this.rId
  });
  late final String msg;
  late final String read;
  late final String told;
  late final Type type;
  late final String fromId;
  late final String sent;
  late final String rMsg;
  late final String rId;

  Message.fromJson(Map<String, dynamic> json){
    msg = json['msg'].toString();
    read = json['read'].toString();
    told = json['told'].toString();
    type = json['type'].toString() == Type.image.name ? Type.image: Type.text;
    fromId = json['fromId'].toString();
    sent = json['sent'].toString();
    rMsg=json['rMsg'].toString();
    rId=json['rId'].toString();
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['msg'] = msg;
    data['read'] = read;
    data['told'] = told;
    data['type'] = type.name;
    data['fromId'] = fromId;
    data['sent'] = sent;
    data['rMsg']=rMsg;
    data['rId']=rId;
    return data;
  }
}
enum Type {text,image}