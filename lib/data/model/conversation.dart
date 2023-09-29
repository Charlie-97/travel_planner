import 'package:objectbox/objectbox.dart';
import 'package:travel_planner/data/model/message.dart';

@Entity()
class ObjConversation {
  @Id()
  int id = 0;
  String? title;

  @Backlink('conversation')
  final messages = ToMany<ObjMessage>();

  ObjConversation({this.id = 0, this.title});
}
